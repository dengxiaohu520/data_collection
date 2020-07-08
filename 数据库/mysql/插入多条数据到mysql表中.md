1. 插入多条数据到mysql表中
```
conn = MySQLdb.connect(host = “localhost”, user = “root”, passwd = “123456”, db = “myDB”)
cursor = conn.cursor()
sql = “insert into myTable (created_day,name,count) values(%s,%s,%s) ON DUPLICATE KEY UPDATE count=count+values(count)”
args=[("2012-08-27","name1",100),("2012-08-27","name1",200),("2012-08-27","name2",300)]
try:
  cursor.executemany(sql, args)
except Exception as e:
  print0(“执行MySQL: %s 时出错：%s” % (sql, e))
finally:
　　cursor.close()
　　conn.commit()
　　conn.close()
```
