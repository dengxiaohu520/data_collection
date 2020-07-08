# python 编码问题.md
1. json:
```
json.dumps 序列化时对中文默认使用的ascii编码.想输出真正的中文需要指定ensure_ascii=False：
 
>>> import json
>>> print json.dumps('中国')
"\u4e2d\u56fd"
>>> print json.dumps('中国',ensure_ascii=False)
```