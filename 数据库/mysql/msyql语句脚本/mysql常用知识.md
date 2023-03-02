# mysql常用知识
1. MySQL删除数据几种情况以及是否释放磁盘空间:
  1. drop table table_name 立刻释放磁盘空间 ，不管是 Innodb和MyISAM ;

  2. truncate table table_name 立刻释放磁盘空间 ，不管是 Innodb和MyISAM 。truncate table其实有点类似于drop table 然后creat,只不过这个create table 的过程做了优化，比如表结构文件之前已经有了等等。所以速度上应该是接近drop table的速度;

  3. delete from table_name删除表的全部数据,对于MyISAM 会立刻释放磁盘空间 （应该是做了特别处理，也比较合理）,InnoDB 不会释放磁盘空间;

  4. 对于delete from table_name where xxx带条件的删除, 不管是innodb还是MyISAM都不会释放磁盘空间;

  5. delete操作以后使用optimize table table_name 会立刻释放磁盘空间。不管是innodb还是myisam 。所以要想达到释放磁盘空间的目的，delete以后执行optimize table 操作。

  6. delete from表以后虽然未释放磁盘空间，但是下次插入数据的时候，仍然可以使用这部分空间


2. 数据库中设置SQL慢查询
  1. 修改配置文件  在 my.ini 增加几行:  主要是慢查询的定义时间（超过2秒就是慢查询），以及慢查询log日志记录（ slow_query_log）


  2. 分析慢查询日志         
       直接分析mysql慢查询日志 ,利用explain关键字可以模拟优化器执行SQL查询语句，来分析sql慢查询语句
      例如：执行EXPLAIN SELECT * FROM res_user ORDER BYmodifiedtime LIMIT 0,1000

  3. 常见慢查询优化
     1. 索引没有起作用
     2. 优化数据库结构
     3. 分解关联查询
     4. 优化limit分页
     