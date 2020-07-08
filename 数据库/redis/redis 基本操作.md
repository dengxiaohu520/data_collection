# redis 基本操作.md
1. redis实列化对象：
```
import redis
r1 = redis.Redis()
r2 = redis.StrictRedis()

# redis有上面两个类可以建立连接对象，用法几乎一样，推荐使用StrictRedis.

r = redis.StrictRedis(host='localhost',  # 默认ip为127.0.0.1
                      port=6379,   # 默认端口6379
                      db=0,        # 默认数据库0
                      password=None,) # 默认没有密码
```

2. redis操作string类型：
```
2.1新增：
print(con.set('num', '3'))  # string类型的插入键值对,参数key，value；返回true或False
print(con.setex('name',3,'xiaobai')) # 设置一个有时间的键值对,返回true或false
print(con.setnx('my','hh'))  # 设置单个不存在的键值对
print(con.mset({'my':'cai'}))  # 设置多个键值对，返回true或false
print(con.msetnx({'you':'tan','my':'wan'})) # 为不存在的键设置值，如果有一个已经存在，整个会失败，返回false

2.2 查询：
print(con.get('num'))       # 获取键的值，返回二进制的数据
print(con.getrange('name', 0, 2))  # 获取子串，参数key、下标范围
print(con.strlen('name'))  # 获取值的长度
print(con.exists('name')) # 是否存在这个键，针对所有的类型

2.3 修改：
print(con.incr('num'))      # 值自加操作，返回计算后的结果值
print(con.incr('num','23'))  # 值加一个整数操作，返回计算后的结果值，
print(con.incrby('num', '5')) # 值加一个整数操作，返回计算后的结果值
print(con.incrbyfloat('num', '3.5'))  # 值加一个浮点数操作，返回计算后的结果值
print(con.incrbyfloat('num', '-3.5'))  # 值加一个浮点数操作，返回计算后的结果值
print(con.decr('num'))  # 值自减操作，返回计算后的结果值
print(con.decr('num', '5'))  # 值减一个整数操作，返回计算后的结果值
print(con.append('boy', 'tom'))  # 字符串拼接，参数key value，返回当前字符串的长度
print(con.setrange('name', '5', 'hh'))  # 字符串替换字符，参数为键、偏移量、值，返回当前字符串的长度

2.4 删除：
print(con.delete('my','name'))  # 删除多个键值对，获取删除成功的数量
```

3. redis操作list类型：
```
3.1 增加：
print(con.rpush('list', 'v1', 'v2'))  # 从列表的首部插入，参数键、值,值可多个，返回列表的长度
print(con.lpush('list', 'vx'))        # 从列表的尾部插入，参数键、值,值可多个，返回列表的长度
con.lset('list',0,20)                 # 在列表的下标0位置插入20

3.2 查询：
print(con.lrange('list',0,-1))  # 获取范围内的元素，返回一个列表，原来的列表不变

3.3 删除：
print(con.lpop('list'))   # 从列表首部弹出一个元素
print(con.rpop('list'))  # 从列表尾部弹出一个元素
print(con.blpop('list',3))  # 从列表首部弹出一个元素,在3秒内阻塞等待，默认为0秒；没有获取值返回none
print(con.brpop('list', 3))  # 从列表右端弹出一个元素,在3秒内阻塞等待，默认为0秒

3.4 修改：
print(con.rpoplpush('list', 'list1')) # 将list最右端的元素移到list1的最左端，返回移动的元素
# 将list最右端的元素移到list1的最左端，返回移动的元素,等待时间3秒，默认0秒
print(con.brpoplpush('list', 'list1', 3))
print(con.ltri('list', 2, -1)) # 剪切列表，返回剪切后的列表，改变了原来的列表
```

4. redis操作hash:
```
4.1 增加：
print(con.hset('fruit','apple','red')) # 设置单个散列键值对,参数name,key,value,返回true或false
print(con.hmset('color', {'blue':'good','green':'bad'}))  # 对个散列键值对,返回true或false
print(con.hsetnx('goods', 'color', 'white'))

4.2 删除：
print(con.hdel('color','blue'))  # 删除散列的某些键值对，至少成功一个返回true，其他返回False

4.3 查询：
print(con.hget('color', 'green')) # 获取散列的单个值
print(con.hmget('color', 'green', 'blue'))  # 获取散列的多个值
print(con.hkeys('color'))  # 获取散列的所有的键
print(con.hvals('color'))  # 获取散列的所有的值
print(con.hgetall('color'))  # 获取散列的所有的键值对，返回一个二进制编码的字典
print(con.hexists('color','red')) # 判断一个散列是否存在某个键，返回true或False
print(con.hstrlen('color', 'blue'))  # 获取值字符串的长度，返回一个数字
print(con.hlen('color'))  # 获取该散列的键值对数量

4.4 修改：
print(con.hincrby('color', 'blue', 3)) # 将散列的值加一个整数，默认加1
print(con.hincrbyfloat('color', 'blue', 3.5))  # 加一个浮点数，默认为1.0  
```

5. redis操作集合：
```
5.1 增加：
print(con.sadd('name', 'a', 'b'))  # 添加元素，返回添加的个数

5.2 删除：
print(con.srem('name','a'))  # 移除元素，返回移除元素的数量
print(con.spop('name'))  # 随机的移除一个元素

5.3 修改：
print(con.smove('name','name1','bb')) # 将bb从name移到name1，如果name1不存在，创建；返回true或false

5.4 查询：
print(con.smembers('name'))  # 返回集合所有的元素，以字典的形式
print(con.scard('name'))  # 返回集合元素的个数
print(con.sismember('name','b')) # 查看元素是否在集合中，返回true或false
```

6. 其它redis函数：
```
con.flushdb() # 清除当前数据库
con.flushall() # 清空当前redis

con.expire('name',3)  # 单位为秒,为键设置过期时间
con.time()  # 查看服务器时间，返回时间戳和当前已过去的微秒数
con.ttl(key) # 查看键还有多少生存期，时间单位为秒
con.keys()  # 查看所有的键，默认参数为'*'
```

7. redis管道（管道可以缓存命令，减少客户端与redis-server交互的次数）：
```
# 创建一个管道值
pipe = con.pipeline()
pipe.get('name')
pipe.set('name','xiao')
# 提交
pipe.execute()
```

8. redis删除数据库
```
flushall 是清除所有库的数据
flushdb 是清除当前选择的库的数据
```