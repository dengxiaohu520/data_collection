# Django 常用自带后台

    ++ admin配置方式：
    ```
    from .models import *
    @admin.register(User)
	class UserAdmin(admin.ModelAdmin):
    	fields = ('username', 'password', )   # 要显示的字段
    ```
    ```
    from .models import *
    admin.site.register(User)    # 显示User模型类中的全部字段
    ```
1. Django xadmin
2. Django jet
3. Django simpleui



