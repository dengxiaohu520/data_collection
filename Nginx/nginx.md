# nginx

1. PV、UV分析：
```
ls -lh access.log  # 命令查看日志文件的大小

cat access.log  # 命令是用来查看文件内容，文件数据量有多少，它就读多少，不合适大文件

less access.log  # less命令适合大文件，它不会加载整个文件，而是按需加载

wc -l access.log  # 可以查看整体的数量条数了
```

2. PV分析：
```
awk '{print $4}' access.log   # 命令把访问时间的信息过滤出来

awk'[print substr($4，2，11)}' access.log    # 只想显示年月日的信息

awk '[print substr($4,2,11)}' access.log  sort  uniq -c  # 可以使用 sort 对日期进行排序，然后使用 uniq -c 进行统计，于是按天分组的 PV 就出来了.
注意： 使用 uniq -c 命令前，先要进行 sort 排序，因为 uniq 去重的原理是比较相邻的行，然后除去第二行和该行的后续副本，因此在使用 uniq 命令之前，请使用 sort 命令使所有重复行相邻。
```

3. UV分析：
```
awk '{print $1 ]' access.log  sort  uniqwc -l

解析：
awk '{print $1}' access.log，取日志的第 1 列内容，客户端的 IP 地址正是第 1 列；
sort，对信息排序；
uniq，去除重复的记录；
wc -l，查看记录条数；

```
