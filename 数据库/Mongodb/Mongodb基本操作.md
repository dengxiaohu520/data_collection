数据库端口：
```
MySQL：3306
Redis：6379
MongoDB：27017
```
创建数据存储的目录，指定读、写、操作权限
```
sudo mkdir -p /data/db
sudo chmod 777 /data/db
sudo mongod --dbpath=/data/db
```

# 一、MongoDB的注意点：
1. 开启MongoDB服务：
    + 1.正常开启服务
    ```
    sudo mongod
    ```
    + 指定数据存放位置开启服务
    ```
    sudo mongod --dbpath=/data/db
    ```
    + 允许任何主机IP访问MongoDB数据库（解决新版本的ip默认只允许本机访问）
    ```
    sudo mongod --bind_ip=0.0.0.0
    ctrl +c 关闭服务
    ```
    + 指定日志文件位置，再以守护进程开启服务
    ```
    sudo mongod --logpath=/data/db/log.log --fork
    ```
    + 注意：如果用守护进程开始服务，建议通过在mongo 交互终端内关闭服务：
    ```
    > use admin
    > db.shutdownServer()
    ```

2. 开启MongoDB shell 交互终端：
```
mongo
```

3. MongoDB的命令：
    + 如果是一个单词组成，则所有字母小写；
    + 如果是多个单词组成，则第一个单词小写，后面单词首字母大写。
    + 如 db.test.find() 、db.createUser()

4. MongoDB的增删改查命令的参数，都是 字典 形式。
    + 如 db.text.insert({name : "hello", age : 18})

5. 一个MongoDB服务器里，可以有多个 数据库(db),
    + 一个数据库里，可以有多个 集合(collection),
    + 一个集合里，可以有多个 文档(document),
    + 一个文档里，可以有多个 键值对(key : value)

6. MongoDB的数据库和集合可以不用创建，通过 use 切换到指定数据库，并向指定集合中添加数据后，
    数据库和集合会被自动创建。
    ```
    db.text.insert({name : "hello", age : 18})
    ```
# 二、数据库的基本命令：

1. db  查看当前所在的数据库

2. show dbs 查看所有数据库

3. use xxx 切换到指定数据库

4. show collections 查看当前数据库下所有的集合

5. db.xxxxxx.find()  查看当前数据库下指定集合的所有文档信息

6. 关闭服务命令：
```
> use admin
> db.shutdownServer()
或 在开启服务的终端 ctrl + c
```
# 三、集合的基本命令：

1. 查看当前数据库所有的集合
```
show collections
```
2. 单独创建一个新集合，默认不设数据大小上限
```
db.createCollection("test")
```
3. 单独创建一个新集合，设置数据存储上限为 1024 Bytes
```
db.createCollection("test", {capped : true, size : 1024})
```
4. 删除指定集合（导致该集合内所有文档数据删除）
```
db.test.drop()
```
# 四、数据的增加 insert()

1. 插入一个完整的文档
```
db.stu.insert({_id : 1, name : "老王", age : 18, gender : true})
```
2. 构建空文档 data，再分别赋值，最后插入data文档
```
data = {}
data._id = 2
data.name = "小王"
data.age = 15
data.gender = false
db.stu.insert(data)
```

# 五、数据的修改 update()
    + 根据条件找到指定的文档，再做更新，无论如何，_id 不会变动

    + 第一个参数：表示匹配条件
    + 第二个参数：表示修改内容
    + 第三个参数：表示是否全部匹配

1. 更新当前文档的所有数据
查询到name为小王的文档数据，并将该文档 全部 替换为 第二个参数的文档
```
db.stu.update({name : "小王"}, {age : 16})
```
2. 更新当前文档的指定数据 （修饰符 $set）
查询到name为小王的文档数据，并替换指定字段 age 为16其他保持不变
```
db.stu.update({name : "小王"}, {$set : {age : 16}})
db.stu.update({name : "小王"}, {$set : {age : 16, gender : true}})
```
3. 更新所有符合条件的文档
添加第三个参数 {multi : true} 表示修改所有符合条件的文档 ,默认
# {multi : false} 表示只替换第一个符合匹配的结果
```
db.stu.update({name : "小王"}, {$set : {age : 40}}, {multi : true})
```
# 六：插入+修改数据： save()
    语法等同于 insert() 根据_id来找数据:
        如果_id存在，则修改整个文档数据
        如果_id不存在，则新增插入数据

# 如果_id:2 数据存在，则将该文档数据进行全部替换
db.stu.save({_id : 2, name : "大王", age : 20, gender : false})

# 如果_id:5 数据不存在，则新增该文档数据
db.stu.save({_id : 5, name : "大王", age : 20, gender : false})


七、删除数据 remove()
    根据条件匹配，删除一条/所有 符合匹配的数据

# 默认删除所有 name 为小王 的文档数据
> db.stu.remove({name : "小王"})

# 添加第二个参数{justOne : true} 表示只删除第一条符合匹配的结果
> db.stu.remove({name : "小王"}, {justOne : true})


八、查询数据 find() 和 findOne():

-1 基本查询：根据条件查询

1. 查询第一个符合匹配条件的结果
> db.stu.findOne({hometown : "桃花岛"})

2. 查询所有符合匹配条件的结果
> db.stu.find({hometown : "桃花岛"})

3. 按文档格式化显示数据
> db.stu.findOne({hometown : "桃花岛"}).pretty()


-2 比较运算符

默认是 等于
db.stu.find({age : 18})

$gt : 大于
> db.stu.find({age : {$gt : 18}})

$gte : 大于等于
> db.stu.find({age : {$gte : 18}})

$lt : 小于
> db.stu.find({age : {$lt : 18}})

$lte : 小于等于
> db.stu.find({age : {$lte : 18}})

$ne : 不等于
> db.stu.find({age : {$ne : 18}})

查找所有age 大于16 小于30 的文档数据
db.stu.find({age : {$gt : 16, $lt : 30}})

-3 逻辑运算符：

默认 多个条件的关系是 与 and

# 表示查找所有hometown为蒙古 和  age大于等于18 的文档数据

db.stu.find( {hometown : "蒙古", age : {$gt : 18}} )

db.stu.find( {$and : [ {hometown : "蒙古"}, {age : {$gt : 18} ])

通过修饰符 $or 修饰 数组中的多个独立条件
# 表示查找所有hometown为蒙古，或者 age大于等于18 的文档数据
db.stu.find( {$or : [ {hometown : "蒙古"}, {age : {$gt : 18}} ] )

-4. 范围运算符 $in  $nin

查询所有hometown不是 桃花岛和大理的文档信息

db.stu.find({homtwon : {$nin : ["桃花岛", "大理"]}})

查询所有年龄在 16、18、20 之间的女性文档数据
db.stu.find({age : {$in : [16, 18, 20]}, gender : false})

-5 正则表达式：

1. 常规正则写法

# 查找name 为 黄开头的文档数据
db.stu.find({name : /^黄/})
db.stu.find({name : {$regex : "^黄"}})

2. 通过修饰符修饰正则： $i 忽略大小写
db.stu.insert({ "_id" : 7, "name" : "Richard", "age" : 40, "hometown" : "江苏", "gender" : true })

# 查找name 为 richard（忽略大小写的）的文档数据
db.stu.find({name : {$regex : "richard", $options : "$i"}})


-6 使用自定义函数查询

# 遍历集合内所有文档对象，并根据每个文档的age值进行判断，并返回所有age 大于等于 18 的文档对象，最后统一输出显示
db.stu.find({ $where : function() {return this.age >= 18}  })

九：对查询结果的后续处理

1. limit() 和 skip()
显示查询结果的前3条
db.stu.find().limit(3)

跳过查询结果的前2条，再向后显示
db.stu.find().skip(2)

当两个方法配合使用时，先执行 skip() 再执行 limit()
db.stu.find().skip(2).limit(3)
db.stu.find().limit(3).skip(2)

2. 投影
    显示文档结果的 指定字段
    在 find() 指定第二个参数，表示启用投影显示

第二个参数中， 通过 1 或 true 表示指定显示字段内容，默认其他不做显示 （_id 无论如何都默认显示）
db.stu.find({}, {name : 1, age : true})

如果不显示 _id ，需要手动指定为 0 或 false
db.stu.find({}, {_id : 0, name : 1, age : 1})

3. 排序 sort()
    对查询结果按指定字段的值进行排序（注意不要排序中文）
    数字按大小排序，字母按ascii值排序

对查询结果按 age 进行排序，1 表示升序， -1 降序
db.stu.find().sort({age : 1})
db.stu.find().sort({age : -1})

如果有多个排序依据，先按第一个进行排序，如果有相同结果，再后面的排序依据排序处理。
db.stu.find().sort({age : 1, gender : 1})

4. count() 方法 统计符合条件的文档个数
    和 find()语法相同，可以写查询条件，但是 find() 返回的是文档，count()的是数字

db.stu.find().count()
db.stu.count()

db.stu.count({age : {$gte : 18}})

5. distinct() 返回指定字段去重后的数组

返回集合中所有的 hometown的值，并去重返回数组
db.stu.distinct("hometown")

也可以指定第二个参数为查询条件，返回符合条件的文档结果

返回集合中所有age大于20的文档 的hometown值，并去重返回数组
db.stu.distinct("hometown", {age : {$gt : 20}})


十、聚合 aggregate()

1. $group 分组
    对集合中所有文档，按指定字段的值种类，进行分组，之后再使用统计方法对各个分组进行统计计算

将集合中所有文档按 gender 字段进行分组，并统计各个分组的 age 总和
> db.stu.aggregate([ {$group : {_id : "$gender", sum_age : {$sum : "$age"}}} ])

将集合中所有文档按 gender 字段进行分组，并统计各个分组 文档个数
> db.stu.aggregate([ {$group : {_id : "$gender",sum_age : {$sum : 1}}}  ])

将集合中所有文档按 gender 字段进行分组，并统计各个分组的 age 的平均值
> db.stu.aggregate([ {$group : {_id : "$gender", sum_age : {$sum : "$age"}, avg_age : {$avg : "$age"}}} ])

将集合中所有文档按 hometown 字段进行分组，并统计各个分组的 age 的最大值
> db.stu.aggregate([ {$group : {_id : "$hometown", max_age : {$max : "$age"}}} ])

将集合中所有文档按 hometown 字段进行分组，并统计各个分组的 age 的最小值
> db.stu.aggregate([ {$group : {_id : "$hometown", max_age : {$min : "$age"}}} ])

将集合中所有文档按 hometown 字段进行分组，并统计各个分组的 第一条文档的 name
> db.stu.aggregate([ {$group : {_id : "$hometown", max_age : {$first : "$name"}}} ])

将集合中所有文档按 hometown 字段进行分组，并统计各个分组的 最后一文档的 name
> db.stu.aggregate([ {$group : {_id : "$hometown", max_age : {$last : "$name"}}} ])

将集合中所有文档按 gender 字段进行分组，并统计各个分组 所有文档 name，并保存在数组中
> db.stu.aggregate([ {$group : {_id : "$gender", name_arr : {$push : "$name"}}} ])

将集合中所有文档按 gender 字段进行分组，并统计各个分组 所有文档 全部数据，并保存在数组中
> db.stu.aggregate([ {$group : {_id : "$gender", name_arr : {$push : "$$ROOT"}}} ])


2. $match 条件过滤
    一般用于 $group 之前，表示先对集合的所有文档进行条件过滤，再进行分组统计计算
    {$match : {和 find() 查询条件相同}}

$match 查找所有age大于等于18的文档数据
$group 对过滤结果进行分组统计，按hometown分组，统计各个分组的所有name

db.stu.aggregate([
    {$match : {age : {$gte : 18}}},
    {$group : {_id : "$hometown", name_arr : {$push : "$name"}}}
])


3. $project 投影处理：
    对聚合结果进行投影处理，显示字段的值
    （_id 默认显示，需要手动指定为 0 或 false 表示不显示，
        其他字段 需要手动指定为 1 或 true 表示显示）

    手动指定_id 为 0 或者 false，表示 _id 不显示，则其他字段默认显示；
    手动指定其他任意字段 1 或 true，表示该字段显示，则其他字段默认不显示。

对文档数据聚合运算后，只显示 sum_age ，不显示 _id
db.stu.aggregate([
    {$group : {_id : "$gender", sum_age : {$sum : "$age"}, avg_age : {$avg : "$age"}}},
    {$project : {_id : 0, sum_age : 1}}
])



4. $sort
    按指定字段进行排序，1 表示升序， -1 表示降序

$match 对集合的所有文档过滤，获取所有 age 大于等于18的文档
$group 按hometown分组，再分别统计各个分组的 age 平均值 和 所有name
$sort 对age平均值 按升序排序
$proect 投影只显示age 平均值和所有姓名，_id不显示

db.stu.aggregate([
    {$match : {age : {$gte : 18}}},
    {$group : {_id : "$hometown", avg_age : {$avg : "$age"}, name_arr : {$push : "$name"}}},
    {$sort : {avg_age : 1}},
    {$project : {_id : 0, avg_age : 1, name_arr : 1}}
])

5. $skip 和 $limit
    跳过再显示和分片显示，单个使用时，结果和 skip()/limit() 一样
    配合使用时，要注意使用顺序（前一个管道的输出做为后一个管道的输入）

db.stu.aggregate([
    {$match : {age : {$gte : 18}}},
    {$group : {_id : "$hometown", avg_age : {$avg : "$age"}, name_arr : {$push : "$name"}}},
    {$sort : {avg_age : 1}},
    {$project : {_id : 0, avg_age : 1, name_arr : 1}},
    {$limit : 2},
    {$skip : 1}
])


6. $unwind
    对数组形式的字段值进行拆分，返回多条文档数据

> db.stu.aggregate([
    {$match : {age : {$gte : 18}}},
    {$group : {_id : "$hometown", avg_age : {$avg : "$age"}, name_arr : {$push : "$name"}}},     {$sort : {avg_age : 1}},
    {$project : {avg_age : 1, name_arr : 1}},
    {$unwind : "$name_arr"}
])

十一、MongoDB的索引操作
    索引的作用主要是 极大的提高查询速度

1. 查看当前集合下的所有索引
    查看索引，注意每个索引多有对应 name 字段，表示该索引的索引名，
    之后删除索引根据name字段删除

db.data.getIndexes()

2. 使用索引。并查看执行状态

db.data.find({_id : 10240}).explain("executionStats")

3. 创建新索引
db.data.ensureIndex({name : 1, num : 1})

4. 删除索引，根据索引的 name字段值
db.data.dropIndex("name_1")

十二、 MongoDB数据库的备份和恢复
    安装好MongoDB后，自带mongodump 和 mongorestore

        -h 需要备份的主机IP:PORT -d 需要备份的数据库名  -o 备份后数据库的保存目录
备份： sudo mongodump -h 192.168.40.80 -d youyuan -o /data/db/mongodata/

        -h 需要恢复的主机IP:PORT -d 需要恢复的数据库名  --dir 需要恢复的数据库所在的目录
恢复： sudo mongorestore -h 192.168.40.80 -d youyuan --dir /data/db/mongodata/youyuan

十三： Python通过pymongo 和 MongoDB数据库交互

import pymongo

client = pymongo.MongoClient(host="192.168.15.80", port=27017)

collection = client.test.stu


Mongodb