# dajngo orm查询今天、昨天、近7天、近30天的数据
1. orm查询语法:
```
  # 今天的日期
cur_date = datetime.datetime.now().date()
# 前一天日期
yester_day = cur_date - datetime.timedelta(days=1)
# 前一周日期
week = cur_date - datetime.timedelta(weeks=1)
# 前一个月
month = cur_date - datetime.timedelta(weeks=4)


查询语句：
if int(time) == 1:
    user_views_queryset = UserViews.objects.filter(create_at__date=cur_date)
else:
    user_views_queryset = UserViews.objects.filter(create_at__date=yester_day)


if int(time) == 1:
		user_views_queryset = UserViews.objects.filter(create_at__gte=week, create_at__lte=cur_date).values('target').annotate(total=Count('id'))
else:
		user_views_queryset = UserViews.objects.filter(create_at__gte=month, create_at__lte=cur_date).values('target').annotate(total=Count('id'))

```