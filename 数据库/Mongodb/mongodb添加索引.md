# mongodb添加索引
```
db.digikey_images_2.ensureIndex({"status":1})
```

1. 多条件查询：
```
db.getCollection("digikey_images_2").find({'status':1, 'is_push':0}).count()

```

2. mongodb添加字段：
```
db.getCollection('分立元件').update({},{$set:{status:0}},{multi:true})
```

3. mongodb 修改某个字段的值
```
db.getCollection('integrated_circuits').find().forEach(function(item){db.getCollection('integrated_circuits').update({"_id": item._id}, {$set: {"status": 0}})})
```
