# python操作elasticsearch

1. python连接elasticsearch
```
from elasticsearch import Elasticsearch
es = Elasticsearch([{'host':'10.10.13.12','port':9200}])

es = Elasticsearch(['10.10.13.12'], http_auth=('xiao', '123456'), timeout=3600)  //带密码，超时时间
```

2. 数据检索功能
```
es.search(index='logstash-2015.08.20', q='http_status_code:5* AND server_name:"web1"', from_='124119')

常用参数
index - 索引名
q - 查询指定匹配 使用Lucene查询语法
from_ - 查询起始点  默认0
doc_type - 文档类型
size - 指定查询条数 默认10
field - 指定字段 逗号分隔
sort - 排序  字段：asc/desc
body - 使用Query DSL
scroll - 滚动查询

```

3. range过滤器查询范围
```
gt: > 大于
lt: < 小于
gte: >= 大于或等于
lte: <= 小于或等于

"range":{
    "money":{
        "gt":20,
        "lt":40
    }
}
```

4. 时间范围
```
1. 最近一分钟
"range": {
    '@timestamp': {'gt': 'now-1m'}
}
2. 最近一小时
"range": {
    '@timestamp': {'gt': 'now-1h'}
}
3.最近一天的
"range": {
    '@timestamp': {'gt': 'now-1d'}
}
```

5. bool组合过滤器
```
must：所有分句都必须匹配，与 AND 相同。
must_not：所有分句都必须不匹配，与 NOT 相同。
should：至少有一个分句匹配，与 OR 相同。

{
    "bool":{
    　　"must":[],
    　　"should":[],
    　　"must_not":[],
    }
}
```

6. term过滤器
```
1. term单过滤
{
    "terms":{
    　　"money":20
    }
}
表示money包含20的记录


2. terms复数版本
{
    "terms":{
    　　"money": [20,30]
    }
}
表示money包含20或者30的记录

3.结合bool+term来举一个实际的例子：

查询path字段中包含applogs最近1分钟的记录
"bool": {
    "must": [
        {
            "terms": {
                "path": [
                    "applogs",
                ]
            }
        },
        {
            "range": {
                '@timestamp': {'gt': 'now-1m'}
            }
        }
    ]
}

```

7. match 查询
```
1. match 精准匹配
{
    "match":{
    　　"email":"123456@qq.com"
    }
}

2.multi_match 多字段搜索
{
    "multi_match":{
    　　"query":"11",
    　　"fields":["Tr","Tq"]
    }
}
```