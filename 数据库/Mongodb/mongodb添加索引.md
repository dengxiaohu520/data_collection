# mongodb添加索引
```
db.digikey_images_2.ensureIndex({"status":1})
```

1. 多条件查询：
```
db.getCollection("digikey_images_2").find({'status':1, 'is_push':0}).count()

```
