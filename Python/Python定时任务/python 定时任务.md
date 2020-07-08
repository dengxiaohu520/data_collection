# python 定时任务.md
1.使用Linux的定时任务（Crontab）:
```
INSTALLED_APPS = [
'django_crontab'
]

CRONJOBS = [
    # ('*/5 * * * *', 'apps.order.cron.clean', '>> %s/magic_home/order.log' % BASE_DIR_LOG),  # 订单两小时回滚库存
    ('*/1 * * * *', 'apps.order.cron.clean', '>> %s/logs/order.log' % BASE_DIR),  # 订单两小时回滚库存
]
```

2. python BlockingScheduler定时任务
```
#BlockingScheduler定时任务
from apscheduler.schedulers.blocking import BlockingScheduler
from datetime import datetime
首先看看周一到周五定时执行任务
# 输出时间
def job():
  print(datetime.now().strtime("%Y-%m-%d %H:%M:%S"))
# BlockingScheduler
scheduler = BlockingScheduler()
scheduler.add_job(job, "cron"， day_of_week="1-5", hour=6, minute=30)
schduler.start()
 
 
scheduler.add_job(job, 'cron', hour=1, minute=5)
hour =19 , minute =23  这里表示每天的19：23 分执行任务
hour ='19', minute ='23'  这里可以填写数字，也可以填写字符串
hour ='19-21', minute= '23'  表示 19:23、 20:23、 21:23 各执行一次任务
 
#每300秒执行一次
scheduler .add_job(job, 'interval', seconds=300)
 
#在1月,3月,5月,7-9月，每天的下午2点，每一分钟执行一次任务
scheduler .add_job(func=job, trigger='cron', month='1,3,5,7-9', day='*', hour='14', minute='*')
 
# 当前任务会在 6、7、8、11、12 月的第三个周五的 0、1、2、3 点执行
scheduler .add_job(job, 'cron', month='6-8,11-12', day='3rd fri', hour='0-3')
 
#从开始时间到结束时间，每隔俩小时运行一次
scheduler .add_job(job, 'interval', hours=2, start_date='2018-01-10 09:30:00', end_date='2018-06-15 11:00:00')
 
#自制定时器
 from datetime import datetime
 import time
 # 每n秒执行一次
 def timer(n):
   while True:
     print(datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
     time.sleep(n)
 
timer(5)
```

3. threading模块中的Timer能够帮助实现定时任务，而且是非阻塞的
```
def printHello():
  print "Hello World"
  t = Timer(2, printHello)
  t.start()
  
  
if __name__ == "__main__":
  printHello()
```
