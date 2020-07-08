# Django 导入常用模块
1. HttpResponse 
```
HttpResponse(content=响应体, content_type=响应体数据MIME类型, status=状态码)
MIME(Multipurpose Internet Mail Extensions)多用途互联网邮件扩展类型：
text/html html
text/plain 普通文本
application/json json

from django.http import HttpResponse
```
2. JsonResponse：
```
1.帮助我们将数据转换为json字符串，再返回给客户端
2.会设置响应头 Content-Type 为 application/json

from django.http import JsonResponse
```