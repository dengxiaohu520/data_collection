# python url路径处理模块

1. url编码和解码
```
from urllib import parse

url = 'https://www.baidu.com/'
nwe_url = parse.urlencode(url)  # 对url进行编码

url2 = parse.quote_plus(url)   # 对url进行解码
```
2. 对url编码过得参数进行解码
```
parse.unquote(request.query_params.get('parameter', None))
```