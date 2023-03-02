# 微信公众号授权登录
1. 获取微信公众号的二维码
```
class GetWxcode(APIView):
    """获取微信公众号二维码"""

    def get(self, request):
        try:
            wechat = SendMessage()
            # 1.获取access_token
            scene_id = str(int((time.time())))
            access_token = wechat.get_access_token()
            if access_token:
                # 2.获取生成二维码的ticket
                user_info_url = u'https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=' + access_token
                params = {
                    'expire_seconds': 60,
                    'action_name': 'QR_STR_SCENE',
                    'action_info': {"scene": {"scene_str": scene_id}},
                }
                params = json.dumps(params)
                userinfo = requests.post(user_info_url, data=params).json()
                ticket = userinfo['ticket']
                data = {
                    'url': 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=' + ticket,
                    'scene_id': scene_id,
                    'code': 200
                }
                return Response(data)
            else:
                return Response({'code': 200})
        except Exception as e:
            print("infinigo_app_home.users - views.py - GetWxcode - error : {}".format(e))
            meta = get_http_meta(self, request)
            # 请求时间 - 响应时间 - 模块名 - 文件名 - 方法名 - 日志级别: HTTP_HOST - REMOTE_ADDR - UUID - PATH_INFO - QUERY_STRING - "错误描述"
            log.error("{} - infinigo_app_home.users - view.py - GetWxcode - error : {} - {} - {} - {} - {} - {}".format(
                    meta['time_now'], meta['HTTP_HOST'], meta['REMOTE_ADDR'], meta['UUID'], meta['PATH_INFO'], meta['QUERY_STRING'], e))
            data = {'code': 400, "zh_message": "获取微信公众号二维码出错", "en_message": ""}
            return Response(data)
```
2. 获取微信服务器返回的信息(1.将服务器中的url路径配置在微信公众号中，2.微信认证，3.用户扫码关注后，微信服务器会通过配置在公众号中的url把用户的open_id和关注状态返回，4.通过open_id获取用户信息，将信息储存在redis中)
```
import hashlib
import xml.etree.ElementTree as ET
from django.http import HttpResponse
def get_public_wx_status(request):
    '''
    获取微信服务器返回的信息
    参数
     scene_id  场景值 必传 判断是哪个用户 扫码
    轮询查看 公众号 是否扫码关注，扫码关注是否绑定手机号
    '''
    try:
        if request.method == "GET":
            # 微信服务器认证
            # 获取微信服务器上传来的几个参数
            signature = str(request.GET.get("signature", None))
            timestamp = str(request.GET.get("timestamp", None))
            nonce = str(request.GET.get('nonce', None))
            echostr = str(request.GET.get('echostr', None))
            token = "xiaohu"
            # 将要排序加密的参数放在一个数组中
            hashlist = [token, timestamp, nonce]
            hashlist.sort()
            hashstr = ''
            # 连接
            for i in hashlist:
                hashstr += i
            # 加密 sha1
            hashstr = hashlib.sha1(hashstr.encode(encoding="UTF-8")).hexdigest()
            # 验证
            if hashstr == signature:
                return HttpResponse(echostr)
            else:
                return HttpResponse("error")
        elif request.method == "POST":
            # 获取微信服务器回调信息
            wechat = SendMessage()
            webData = request.body
            xmlData = ET.fromstring(webData)
            msg_type = xmlData.find('MsgType').text  # 消息类型，event
            to_user_name = xmlData.find('ToUserName').text  # 开发者微信号
            scene_id = (xmlData.find('EventKey').text).replace('qrscene_', '') if xmlData.find('EventKey').text  else xmlData.find('EventKey').text # 临时公众号二维码创建时间
            from_user_name = xmlData.find('FromUserName').text  # 用户公众号OpenID
            event = xmlData.find('Event').text  # 事件类型，sunscribe:新用户关注， SCAN老用户关注
            # print('from_user_name', from_user_name)
            # print('scene_id', scene_id)
            # msg_type=event，表示用户已经关注
            if msg_type == 'event':
                # 通过微信open_id 获取用户信息
                result = wechat.get_wechat_user_info(from_user_name)
                if result:
                    # 将获取到的公众号的open_id存储到redis中
                    sava_wechat_info_redis(scene_id, result)
                return HttpResponse({'code': 200})
            else:
                data = {'code': 400, 'zh_message': '您还未关注公众号！！！'}
                return HttpResponse(data)
    except Exception as e:
        print("infinigo_app_home.users - views.py - get_public_wx_status - error : {}".format(e))
        log.error("infinigo_app_home.users - views.py - get_public_wx_status - error : {}".format(e))
        data = {'code': 400, 'zh_message': ''}
        return HttpResponse(data)
```

3. 前端轮询判断用户是否扫码(实际是询问后端是否接收到微信服务器回传的信息)
```
class VerifyUserQRcodeViewSet(APIView):
    """前端轮询判断用户是否扫码"""
    def get(self, request):
        try:
            print("前端轮询判断用户是否扫码")
            bus = get_gen_seq()
            seq = request.query_params.get('sequence', '')
            scene_id = request.query_params.get('scene_id', '')
            if not scene_id:
                return Response({'code': 400, 'zh_message': 'scene_id不能为空'})

            # 从redis获取用户公众号的open_id
            new = hashlib.md5()
            new.update(str(scene_id).encode('utf8'))
            digest = new.hexdigest()
            redis_conn = get_redis_connection('user_info')
            user_info_str_old = redis_conn.get(digest)
            if not user_info_str_old or user_info_str_old == '':
                return Response({'code': 201, 'zh_message': '用户还未扫码'})

            # 根据公众号open_id查询用户是否绑定手机号，如绑定手机号则返回用户登录信息，未绑定手机号则提醒用户绑定手机号
            user_info_str = user_info_str_old.decode('utf-8')
            user_info_dict = json.loads(user_info_str)
            wxopenid = user_info_dict.get('openid', '')
            result_data = open_id_binding_mobile(bus, seq, wxopenid)
            if result_data.get('code', '') == 200:
                # 用户已经绑定手机号
                # 将用户信息储存到redis中
                token = create_token()
                user_info_dict = result_data.get('user_info', '')
                redis_conn_user_info = get_redis_connection('user_info')
                pl = redis_conn_user_info.pipeline()
                pl.multi()
                pl.setex(token, USER_INFO_TIME, json.dumps(user_info_dict, ensure_ascii=False))
                pl.execute()
                return Response({'code': 200, 'zh_message': '登录成功', 'data': user_info_dict, 'token': token})
            elif result_data.get('code', '') == 203:
                return Response({'code': 203, 'zh_message': '请先绑定手机号'})
            else:
                return Response({'code': 400, 'zh_message': '绑定失败'})
        except Exception as e:
            print("infinigo_app_home.users - views.py - VerifyUserQRcodeViewSet - error : {}".format(e))
            meta = get_http_meta(self, request)
            # 请求时间 - 响应时间 - 模块名 - 文件名 - 方法名 - 日志级别: HTTP_HOST - REMOTE_ADDR - UUID - PATH_INFO - QUERY_STRING - "错误描述"
            log.error("{} - infinigo_app_home.users - view.py - VerifyUserQRcodeViewSet - error : {} - {} - {} - {} - {} - {}".format(
                    meta['time_now'], meta['HTTP_HOST'], meta['REMOTE_ADDR'], meta['UUID'], meta['PATH_INFO'], meta['QUERY_STRING'], e))
            data = {'code': 400, "zh_message": "前端轮询判断用户是否扫码出错", "en_message": ""}
            return Response(data)
```