# 自动获取芝麻代理IP
```
def get_proxy():
    proxies = {
        'http': 'http://' + proxy_lst[0],
        'https': 'https://' + proxy_lst[0]
    }
    valid_resp = requests.session().get('https://www.baidu.com', proxies=proxies)
    if valid_resp.status_code == 200:
        # 说明代理ip有效
        return proxies
    else:
        # 说明代理ip无效
        # 从代理商重新获取代理ip
        url = 'http://http.tiqu.alicdns.com/getip3?num=1&type=2&pro=0&city=0&yys=0&port=1&time=1&ts=0&ys=0&cs=0&lb=1&sb=0&pb=45&mr=3&regions=&gm=4'
        html_ = requests.get(url)
        text = html_.text
        if int((json.loads(text))['code']) == 0:

            proxy_lst[0] = (json.loads(text))['data'][0]['ip'] + ':' + (json.loads(text))['data'][0]['port']
            proxies2 = {
                'http': 'http://' + proxy_lst[0],
                'https': 'https://' + proxy_lst[0]
            }
            return proxies2
        else:
            return {}
```
