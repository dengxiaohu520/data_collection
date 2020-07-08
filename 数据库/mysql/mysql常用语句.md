# mysql常用语句
1. 目标表增加字段
```
alter table db_electron_property_base.tb_electron_factory add COLUMN source_web varchar(512);
```
2. 复制一张表的结构，再将原有表的数据导入到新表中
```
create table db_electron.tb_electron_2 like db_electron.tb_electron;
insert into db_electron.tb_electron_2 select * from db_electron.tb_electron;
```
3. 将查询出来的结果输出到指定的文件中：
```
select a.id,a.zh_name,a.en_name,b.zh_name,b.en_name from db_electron_property_base.tb_electron_factory a, db_electron_property_base.tb_electron_area b
where a.country_id = b.id and a.country_id = -1 limit 10 
into outfile '/data/mysql_export_dir/a.csv' CHARACTER set gbk 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n';
```
    + 在命令行下使用一对SQL语句完成该操作：
	  导出查询结果：Select语句 into outfile '保存路径+文件名';
	  导入查询结果：load data local infile '保存路径+文件名' into table 表明 character set utf8;
    * 导出查询结果：使用MySQL自带的转存数据库工具musqldump
	  命令行进入musqldump，使用语句

       mysqldump -u用户名 -p -c --default-character-set=字符集 数据库名 数据表 --where="查询条件" > 保存路径和文件名
       
       导入查询结果：mysql -u用户名 -p -c --default-character-set=字符集 数据库名 < 保存路径和文件名

4. 按月统计：
```

SELECT DATE_FORMAT(create_at, '%m') as month, SUM(dj_electron_count) AS dj_electron_count, SUM(electron_count) AS electron_count, SUM(other_electron_count) AS other_electron_count  FROM tb_electron_count 
WHERE  DATE_FORMAT(create_at, '%Y')='2020' 
 GROUP BY DATE_FORMAT(create_at, '%Y-%m');
```

5. mysql按周、月、天统计
```
<!-- 按日查询 -->  
SELECT DATE_FORMAT(created_date,'%Y-%m-%d') as time,sum(money) money FROM o_finance_detail where org_id = 1000  GROUP BY  time  
<!-- 按月查询 -->  
SELECT DATE_FORMAT(created_date,'%Y-%m') as time,sum(money)  money FROM o_finance_detail where org_id = 1000  GROUP BY  time  
<!-- 按年查询 -->  
SELECT DATE_FORMAT(created_date,'%Y') as time,sum(money)  money FROM o_finance_detail where org_id = 1000  GROUP BY  time   
<!-- 按周查询 -->  
SELECT DATE_FORMAT(created_date,'%Y-%u') as time,sum(money)  money FROM o_finance_detail where org_id = 1000  GROUP BY  time  
```


-- 借助第三张表更新表
-- CREATE TABLE temp_images ( SELECT images, images_path FROM `tb_electron_digikey`  where images_path  is NOT NULL)
-- SELECT count(1) from temp_images;

UPDATE tb_electron_digikey  a left join temp_images b on b.images = a.images set a.images_path = b.images_path where a.images_path is NULL and a.images is NOT NULL; 



MYSQL中的ON DUPLICATE KEY UPDATE
今天查看数据入库脚本时，看到使用的插入语句是：

INSERT INTO tablename(field1,field2, field3, ...) VALUES(value1, value2, value3, ...) ON DUPLICATE KEY UPDATE field1=value1,field2=value2, field3=value3, ...;

自己第一次遇到，正好查询文档学习下。

　　使用这条语句的原因，是为了更好的执行插入和更新，因为我们再插入一条语句时，表中可能已经存在了这条语句，我们想实现更新的功能，或者表中没有这条语句，我们想实现插入的功能，而这条语句直接可以同时解决插入和更新的功能。

　　那么这条语句是如何解释呢，我们很容易理解前面的部分，就是一个简单的插入语句，让我们看下后面的部分ON DUPLICATE KEY UPDATE field1=value1,field2=value2...我们看到后面是一个更新的操作，后面指定了更新的字段，也就是说判断出表中没有这条数据，执行的前半部分，插入指定字段得值，在判断出表中有数据，则执行的的更新操作，更新后半部分指定的字段的值。

　　那么下一个问题出来了，我们是如何判断出这条数据是存在的，又需要更新哪些字段呢。

规则如下：

　　如果你插入的记录导致UNIQUE索引重复，那么就会认为该条记录存在，则执行update语句而不是insert语句，反之，则执行insert语句而不是更新语句。

　　比如我创建表的时候设置的唯一索引为字段a，b，c，那么当a，b，c三个字段完全重复时候，此时就要执行更新语句。当然满足一部分唯一索引是不会触发更新操作的，此时会执行插入操作。



验证update语句是否正确的方法：
```
# update语句
update db_electron_property.tb_electron_media m, db_electron.tb_electron_nodigikey d set m.icons = json_array(concat('http://cdn.infinigo.cn/images/electron/', SUBSTRING_INDEX(images_path,'/', -1))) where m.electron_uuid=d.electron_uuid and d.images_path is not null;

# 用select 语句验证
select d.model_name,m.electron_uuid, json_array(concat('http://cdn.infinigo.cn/images/electron/', SUBSTRING_INDEX(images_path,'/', -1), '.jpg')) from db_electron_property.tb_electron_media m, db_electron.tb_electron_digikey d where m.electron_uuid=d.electron_uuid and d.images_path is not null limit 10;

```



# 同一张表去存留一条
```
sql = '''SELECT id ,model_name, electron_uuid,images,images_path from tb_electron_digikey   where images  in (select  images  from tb_electron_digikey  group  by  images   having  count(images) > 1) 
    and id not in (select min(id) from  tb_electron_digikey  group by images  having count(images)>1);'''
```