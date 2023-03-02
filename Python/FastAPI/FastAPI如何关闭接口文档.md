# FastAPI如何关闭接口文档
1. 根据环境变量切换
```
import os
from fastapi import FastAPI

env = os.getenv('env')
if env != 'develop':
    app = FastAPI(docs_url=None, redoc_url=None)
else:
    app = FastAPI()
```

2. 隐藏当前模块所有接口
```
app = FastAPI(docs_url=None, redoc_url=None)

```
3. 关闭部分接口 (我们可以在路由装饰器上面添加一个参数include_in_schema=False，如下)
```
@app.post('/login', include_in_schema=False)
```
