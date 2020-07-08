# MySQL中修改表名，表属性名等的操作.md
```
alter table 表名 change 原列名 新列名  类型； --修改表的列属性名
alter table 表名 modify 列名 类型 ；  --修改表的类类型
alter table 表名 drop 列名；  --删除表的某一列
alter table 表名 add  列名 类型；--添加某一列
alter table 表名 rename 新表名； --修改表名
```