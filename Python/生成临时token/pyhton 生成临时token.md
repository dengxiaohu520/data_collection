# pyhton 生成token和临时token
```
import time
import jwt
import uuid
from django.conf import settings
from .constants import SET_PASSWORD_TOKEN_EXPIRES
from django_redis import get_redis_connection
from itsdangerous import TimedJSONWebSignatureSerializer as TJWSSerializer, BadData
from rest_framework.response import Response


def create_token():
    """生成token"""
    uid = str(uuid.uuid4())
    suid = ''.join(uid.split('-'))
    # headers
    headers = {
        'alg': "HS256",  # 声明所使用的算法
    }
    # payload
    token_dict = {
        'time': time.time(),  # 时间戳
        'suid': suid,  # UUID(生成随机数)
        'version': '2.0.0',
        }

    # 调用jwt库,生成json web token
    jwt_token = jwt.encode(token_dict,  # payload, 有效载体
                           "dhs_infinigo@210",  # 进行加密签名的密钥
                           algorithm="HS256",  # 指明签名算法方式, 默认也是HS256
                           headers=headers  # json web token 数据结构包含两部分, payload(有效载体), headers(标头)
                           ).decode('ascii')  # python3 编码后得到 bytes, 再进行解码(指明解码的格式), 得到一个str
    return jwt_token


def varify_token(token):
    """验证token"""
    redis_conn = get_redis_connection('user_info')
    real_token = redis_conn.get(token)
    if real_token is None:
        data = {"code": 401, "zh_message": '请先登录', "en_message": "Please login first"}
        return data
    else:
        data = {"code": 200}
        return data








def create_set_password_token(user_name):
    """
    生成修改密码的临时token
    """
    serializer = TJWSSerializer(settings.SECRET_KEY, expires_in=SET_PASSWORD_TOKEN_EXPIRES)
    data = {'username': user_name}
    token = serializer.dumps(data)
    return token.decode()


def check_set_password_token(token, username):
    """
    检验修改密码的临时token
    """
    serializer = TJWSSerializer(settings.SECRET_KEY, expires_in=SET_PASSWORD_TOKEN_EXPIRES)
    try:
        data = serializer.loads(token)
    except BadData:
        return False
    else:

        if username != str(data.get('username')):
            return False
        else:
            return True
```