# hashlib函数操作
1. hash之后存入redis中
```
import hashlib
redis_conn = get_redis_connection("electron_hot_list")
new = hashlib.md5()
new.update(str(key).encode('utf8'))
keys = new.hexdigest()
# 设置过期时间为1天
redis_conn.set(keys, json.dumps(result, ensure_ascii=False))
redis_conn.expire(keys, 86400)
```

2. 从redis中取出数据
```
import hashlib
redis_conn = get_redis_connection("electron_similar")
new = hashlib.md5()
new.update(str(part_number).encode('utf8'))
keys = new.hexdigest()
result = redis_conn.get(keys)
if result:
    redis_similar = result.decode('utf8')
    results = json.loads(redis_similar, encoding='utf-8')
```