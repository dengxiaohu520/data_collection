# Django 总结.md
谈谈你对Python的理解
Python是一门解释型语言，它就相当于找了个翻译，你说一句话它给计算机翻译一句话；
Python也是一门动态类型语言，在声明变量的时候不需要指定数据类型
Python还支持多继承（其他语言不支持）
Python语言语法简洁、代码编写快但是运行速度比其他语言要慢，但是python允许扩展C语言，可以很好的用于科学计算；
Python是一门强类型语言

强弱类型语言
强类型语言就是 只有相同类型的数据才能进行操作
弱类型语言就是 数据类型随着环境的不同自动变化（a=1 b=’ ’ a+b=a+’ ’）

Python中两个字典如何合并
>>> x = {‘a‘:1, ‘b‘: 2}
>>> y = {‘b‘:10, ‘c‘: 11}
>>> x.update(y)

Python中两个字典如何比较是否相等
a = {‘a‘: 1, ‘b‘: 2}
b = {‘a‘: 1, ‘b‘: 2}
prtint(a == b)
cmp(a, b)
返回-1 a<b 返回1 a>b 返回0 相等

Python的PIL
PIL（Python Image Library）是python的第三方图形处理库，主要用于图像归档（创建缩略图、转换格式、打印图像），图像展示（图像展示），图像处理（对比度增强）

Python的GIL
GIL（Global Interpreter Lock）全局解释器锁，保证了同一时刻只能有一个线程在运行。

Python的标准库（PSL）
Os（系统模块）
Re（正则表达式）
Tkinter（图形化模块）
Time（时间模块）
Random（随机数模块）
Logging（日志模块）
Json（JSON数据）
Base64（编码）
Python的第三方库（PYPL）
Django
Django-redis
Djanog-httprequest
drf
Redis
Falsk
Flask-restful
Flask-sqlchemy
pymysql
Matplotlib
Pil
Numpy
pandas

Python数据的可变与不可变类型
可变类型是 数据发生改变 内存空间地址不变
不可变类型是 数据发生改变 内存空间地址也发生改变
数据类型    可变/不可变
整型    不可变
字符串    不可变
元组    不可变
列表    可变
集合    可变
字典    可变

Python的内存管理机制
引用计数
垃圾回收 python的变量是和对象是在程序运行时就已经确定了的内存大小，但内存不在被使用时，python就回去检查这块内存地址的引用计数，如果引用计数为0的话那就清除这块内存
内存池 python的内存池是用来存放那个被清除掉的变量的内存空间的（python的垃圾回收机制，不会将内存返回给操作系统）

Python的单例模式
单例模式（一个类只有一个实例存在）
重写类中的__new__方法（new方式是对象呗实话实说分配内存地址的方法）
class B(object):
    instant = None
    flag = True

    def __new__(cls, *args, **kwargs):
        if cls.instant is None:
            cls.instant = super().__new__(cls)
        return cls.instant
判断对象是否已经存在内存地址，如果存在则直接使用原来的，如果不存在就创建一个

Python的垃圾回收机制
1.    引用计数 python的变量是和对象是在程序运行时就已经确定了的内存大小，当一个对象有新的引用指向它是引用计数+1否则的话-1 当引用计数为0时，对象就会被立即回收
2.    标记清除 第一阶段是将活跃的对象设置一个标记段 第二阶段是将没有被标记的对象进行回收
3.    分代回收

装饰器
装饰器是通过闭包来对指定的函数进行功能的扩充，装饰器在函数定义时就会执行。

装饰器特点：
1.不修改指定修饰函数的代码，
2.不修改指定修饰函数的调用方式，
3.给指定修饰函数增加相应的功能。

装饰器的功能（应用场景）
日志 记录函数的日志
在请求到达视图之前，对其进行干预（判断用户是否在黑名单中、权限校验）
对响应进行干预
记录函数的执行时间

装饰器的执行流程：
1.    通过语法糖（@装饰器名），将被装饰函数的引用（内存空间地址）传递给装饰器的外层函数的形参；
2.    装饰器的内层函数使用外层函数的参数，即被装饰函数；
3.    外层函数将内层函数的引用（内存空间地址）返回给被装饰函数；
经过这样的步骤，被装饰函数的函数名所指向的引用（内存空间地址）已将发生改变，被装饰函数的函数名所指的就是装饰器的内层函数。

类装饰器
类装饰器的本质和装饰器一样，都是为被装饰的函数增加额外的功能，但是类装饰器的灵活度更大、封装性更强；使用类装饰器可以直接依靠类内部的魔法方法call实现装饰功能。

闭包
闭包：闭包是在函数嵌套的基础上，内层函数使用到外层函数的变量，且外层函数返回内层函数的引用的一种语法格式。

使用装饰器创建单例
先创建装饰器，然后通过装饰器装饰一个类，在使用被装饰的类创建实例即可。
def single01(cls):
    s=[]  //这里定义了一个私有列表，也可以声明一个变量，在wrap用关键字nonlocal去调用
    def wrap(*args,**kwargs):
        if not s:
            s.append(cls(*args,**kwargs))
        return s
    return wrap
@single01
class A(object):
    def __init__(self,name):
        self.name = name
//试一下
a = A("tmac")

生成器
生成器就是列表推导式，通过遍历一个容器类型的数据，重新生成一个列表（list）类型的数据。

深拷贝、浅拷贝
深拷贝 相当于重现在创建了一个文件，其中的内容和被拷贝的内容完全一样，但是不是一个文件，内存空间地址发生了改变。当原文件的数据发生改变时，深拷贝的数据不受影响。
浅拷贝 相当于创建了一个快捷方式，并且使用这个快捷方式指向了文件的内存地址，当原数据发生改变时，浅拷贝的数据也发生改变。

进程、线程、协程
进程是资源分配的基本单位
线程是CPU调度的基本单位
协程是比线程更轻量级，是由程序控制的

协程简介
协程是线程中的并发，是一种轻量级的线程，是受用户程序控制调度的。
进程和线程的关系
每一个进程中至少有一个线程
同一个进程中的多个线程资源共享
线程不能独立执行，必须依赖进程

协程和线程的关系
一个线程可以有多个协程
线程时同步机制，协程是异步机制

并发和并行
并发是指同一时刻有多条指令同时执行
并行是指同一时刻只能有一条指令执行，但是因为指令被快速轮换，所以宏观上看是同时执行的。

同步和异步
同步是指同一时刻只能有一个线程再执行，如：面试（有两个人面试同一家公司），同一时间只能面试一个人，只有我面试完了，才能面试下一个人。
异步是指同一时刻可以有多个协程同时执行，如：饭店吃饭，有很多张桌子（假设人数永远小于饭店的位置），同一时刻可以有多个人在饭店里吃饭。

进程间的通信
Queue（队列）
Socket（套接字）
Pipe（管道）

TCP协议
传输控制协议（TCP，Transmission Control Protocol）是一种面向连接的、可靠的、基于字节流的传输层通信协议

TCP/IP协议
传输控制协议，能够在不同的网络间实现信息的交互。

TCP/IP三次握手
客户端给服务端发送syn数据包
服务端给客户端相应syn和ACK数据包
客户端给服务端发送ACK数据包

TCP/IP四次挥手 
客户端给服务端发送FIN标志，表示要断开连接
服务端给客户端相应ACK数据包，用来确定客户端是否要断开连接
服务端在再将FIN标志发送给客户端
客户端确认关闭连接，并且发送一个关闭连接的消息ACK给服务端

HTTP协议
它是基于TCP协议的用于客户端服务器之间的超文本传输协议。
超文本是超级文本的缩写，是指超越文本限制或者超链接，比如:图片、音乐、视频、超链接等等都属于超文本。
端口是 80

HTTPS协议
HTTPS协议是超文本传输安全协议，是通过HTTP协议进行通信，但是数据经过加密处理的，相比HTTP协议HTTPS协议传递的数据更安全。
端口是443

Socket长短连接
Socket长连接是指建立一次连接后，无论是否使用socket进行同行，连接都不断开
短连接是指 建立一次连接后只进行一次通信，就断开连接。

Websocket协议
Websocket协议是基于TCP连接的全双工协议
Websocket中，服务器和浏览器只需做一次握手动作，即可形成一条快速通道进行数据交互

HTTP响应状态码
2xx 成功类型的状态码
200 请求成功
201 创建成功
205 重置成功

3xx 重定向类别
303 缓存没变
302 重定向

4xx 客户端错误响应
403 服务器拒绝访问 权限不足
404  url无效
405 请求方式不允许

5xx 服务器端错误
500 程序出问题了
503 停机维护
504 网关超时（Nginx反向代理出现问题）

HTTP的常见请求方式
GET\POST\PUT\DELETE

GET和PSOT的区别
Get 用于读取资源
Post 用于表单数据

HTTP常见的请求头
Cookie
Content-type
Server

乐观锁、悲观锁
悲观锁  当查询某条记录时，即让数据库为该记录加锁，锁住记录后别人无法操作

乐观锁 乐观锁并不是真实存在的锁，而是在更新的时候判断此时的库存是否是之前查询出的库存，如果相同，表示没人修改，可以更新库存，否则表示别人抢过资源，不再执行库存更新。（地铁上的座位，当我发现有人做的时候，我就不坐，没有人做的时候我就坐上去）

MySQL引擎
InnoDB  
支持事务 （MySQL5.0）
支持行级锁
是数据库的默认存储引擎；
实现了四个隔离级别；
内部对磁盘的读取操作进行了优化；
支持在线热备份

MyIsam  
不支持事务
不支持行级锁
数据较少时可以使用；
提供了大量的特性，压缩表、空间数据索引等 

数据库事务的隔离级别
读未提交（Read uncommitted） -- 保证所有事务都可以看到其他事务未提交的修改
读提交（read committed） -- 一个事务只能看见其他应经提交的事务所做的修改
可重复读（repeatable read） --- mysql事务的默认隔离级别
串行化（Serializable）

MySQL的锁
共享锁（读锁） 其他事物可以读 但不能写
排他锁（写锁） 其他事物不可以读也不可以写

死锁的产生
用户A访问数据库表A，上锁了，然后又去访问了表B；但是用户B先访问表B并且上了锁，又去访问表A，这样就造成了死锁，用户A要执行就必须等待B把表B解锁，用户B要执行就必须等待用户A把表A解锁。

避免死锁
查询时尽量避免复杂的查询，
数据库数据设置索引

数据库的备份
冷备份 数据库关闭的情况下进行的数据备份，相当于数据的拷贝
热备份 数据库在运行的情况下进行的SQL语句的备份

MySQL索引
索引是一种特殊的约束，如：unique（唯一键约束）、primary key（主键约束）等，所有约束都可以被称之为索引。

MySQL事务（transaction）
事务主要在同时处理多个表数据时使用，保证操作的所有的表同时都能成功。
成功commit
失败 rollback

事务的特性
•    原子性：一个事务（transaction）中的所有操作，要么全部完成，要么全部不完成，不会结束在中间某个环节。
•    一致性：在事务开始之前和事务结束以后，数据库的完整性没有被破坏。
•    隔离性：数据库允许多个并发事务同时对其数据进行读写和修改的能力，隔离性可以防止多个事务并发执行时由于交叉执行而导致数据的不一致。
•    持久性：事务处理结束后，对数据的修改就是永久的，即便系统故障也不会丢失。

MySQL主从同步、读写分离
使用docker镜像创建了一个MySQL的容器
修改Django的配置文件

主从同步的作用：
1.    防止主数据库崩溃
2.    业务的扩展（用户量过大）
3.    提高数据库的并发，用户获取数据的时间降低了，提高用户体验性。

读写分离作用
解决数据库写入问题对数据库查询效率的影响。

MSQL的连接查询
内连接 inner join 查询两张标的交集数据
Select * from a inner join b on a.id = b.id
左连接 left join 以左表为基础 查询两张表的数据（左表的数据+右表符合条件的数据）
Select * from a left join b on a.id = b.id where
有连接 right join 以右表为基础 查询两张表的数据（右表的数据+左表符合条件的数据）
Select * from a right join b on a.id = b.id where

Linux常用命令
Ls  cd  vi  help  touch（创建文件）rm（删除）mkdir（创建文件夹） mv（移动文件夹） cp（复制） tar（解压） ym/apt-get（下载） ps（查看进程） more（查看文件内容）clear（清屏）pwd（当前路径）|（管道） sudo（管理员权限）

Redis代码优化
管道 pipline
Pipline.execute()

Redis为什么快？
1.    完全基于内存操作
2.    对数据操作比较简单，就只有增删改查
3.    采用单线程机制CPU的不必要损耗（死锁）

Redis集群
通过修改redis的配置文件实现（Redis主从）

缓存穿透
恶意用户通过特殊手段，实现了绕过服务端访问缓存的步骤，直接使服务端查询数据库，增加的数据库的压力
使用布隆过滤器对用户请求进行干预
使用默认缓存数据方式，即当通过指定条件查询不到缓存时，设置一个默认的空的缓存

缓存雪崩
开发时候，将所有的缓存数据都设置成了一样的生命周期，导致所有缓存同一时刻全部消失，当用户访问时增加了数据库的压力。
使用随机数的方式生成一个指定范围内的时间作为每一种缓存数据设置有效期

Redis持久化处理
1.    Rdb：压缩到二进制文件中
2.    AOF：以日志方式追加文件中，保证Redis中数据的安全性。

Django中配置Redis
在配置文件中 指定CACHES 属性值即可

MVT各部分的功能
MVT设计模式是基于MVC设计模式的，一种PythonWeb项目的设计模式。
M全拼为Model，与MVC中的M功能相同，负责和数据库（ORM）交互，进行数据处理。
V全拼为View，与MVC中的C功能相同，接收请求，进行业务处理，返回应答。
T全拼为Template，与MVC中的V功能相同，负责封装构造要返回的html。

ORM
ORM（Object Relational Mapping）对象关系映射，它对数据库语句的高度封装，使用ORM框架开发可以提高开发效率，不用直接使用SQL语句，提高了项目的可以执行，保证数据库可以自由更换。

ORM惰性查询
当orm执行时并不会执行sql语句，等queryset执行时才会。

ORM惰性机制—Django缓存
Django自己有缓存，如果两次obj对象一样，第二次直接从缓存中获取

ORM惰性查询（lazy）应用
定义多对多或一对多关系模型时使用
关系模型字段relationship()指定关系

ORM开启事务
1.    语法糖开启  @transaction.atomic
2.    With语句显示的开启 with transaction.atomic()
# 创建保存点
save_id = transaction.savepoint()  
# 回滚到保存点
transaction.savepoint_rollback(save_id)
# 提交从保存点到当前状态的所有数据库事务操作
transaction.savepoint_commit(save_id)

ORM的queryset的常用方法
create() 添加数据 --- 通过对象属性方式添加 对象.save()
update() 修改数据
delete() 删除数据
all() 查询所有
get() 获取条件的单一对象
filter() 获取符合条件的对象列表
order_by() 排序 asc升序（默认） desc降序
count() 统计数量
first() 取出查询集中的第一个
last() 取出查询集中的最后一条
一对多查询 一方类名.多方类名小写_set
通过字段设置related_name属性 一方类型.related_name的属性值
多对多查询 多方类名.外键
创建数据库模型类
通过继承django自带的models模块中的Model类，自定义模型类

Django的基本组件
View modle url template 中间件

Django通过url寻找视图函数
1.    先通过路由文件中导包将视图函数导入到当前文件中；
2.    根据正则表达式匹配url地址，找到严格匹配的地址；
3.    根据匹配的结果寻找导入到文件中的视图函数。

Django中间件
介于request与response处理之间的一道处理过程
可以通过Django中的MIDDLEWARE 属性进行设置
可以自定义一个中间件类 实现中间件的自定义

Django中间件的使用
用户黑名单的判断 --- 在请求没有到达视图之前 先判断一下用户ID是否在黑名单中
CSRF认证
权限

Django框架和Flask框架的异同点
Django是一款重量级的Web框架、功能齐全，提供一站式解决的思路，能解决日常开发到的绝大部分问题；
自带ORM框架和模版引擎，支持JinJa2模版
成熟、稳定、开发效率高、相对于Flask，Django的整体封闭性比较好，适合做企业级网站的开发；
第三方库丰富；
Flask是一款轻量的Web框架、自由、灵活、可扩展性强；
适合做小型网站及Web服务的API，开发大型网站需要自行设计架构；

Django中请求的生命周期
1.    浏览器请求通过wsgi协议发送给Django
2.    Django中的中间件对请求进行干预  （CSRF、JWT认证）
3.    根据理由规则匹配到视图
4.    视图函数进行业务逻辑的处理
5.    中间件进行请求干预
6.    Django将响应通过wsgi协议响应给浏览器

Django路由中的name（命名空间）作用
可以使用name（命名空间）进行反向解析出路由地址对应的视图函数

Django中当一个用户登录 A 应用服务器（进入登录状态），然后下次请求被 nginx 代理到 B 应用服务器会出现什么影响？
如果用户在A应用服务器登陆的session数据没有共享到B应用服务器，那么之前的登录状态就没有了。

Django如何避免CSRF
启用中间件（CSRF）
会在表单中会设置一个（csrf_token）

Django如何实现重定向
使用HttpResponseRedirect模块中的redirect（重定向）和reverse（反向解析）
状态码 302（重定向） 301

Django接收前端传递参数的方式
路径参数 通过正则表达式匹配，视图函数中定义形参接收
查询字符串 request.GET
获取表单数据 request.post
获取JSON数据 request.body.decode()
获取请求头中的数据 request.META
获取当前用户 request.user
获取请求方法 request.method
获取文件 request.FILES

Django如何获取COOKIE和SESSION
Request.COOKIES
Response.SESSION

Django如何设置COOKIE和SESSION
Cookie是设置在客户端的；
HttpResponse()
响应对象.set_cookie(key,value)
session是在服务端的
request.session[key] = value

Wsgi协议
Wsgi协议是web服务器和web框架进行通信的一个规则，规定将动态请求给web框架处理
Wsgi相当于一座桥梁，一端是框架一端是服务器。
借钱：A找B做担保人从银行借钱，A通过B将借钱的请求发送给银行，银行又通过B将钱（响应给了）A 这里A就可以理解为用户  B就理解为wsgi协议 银行就是Web框架

RESTful设计风格理解
RESTful就是一种设计风格，不遵守也没事，就像我们的穿衣风格有日系、港风、韩范；而却别这些穿衣风格的条件就是，身上的衣服是否属于这些风格中的样式，如果是那么就是对应的穿衣风格。

RESTful设计风格规定
尽量将API部署在专用的域名下
尽量将API的版本信息放入url中
每一个url地址对应一种资源
服务器返回给客户端的数据尽量使用JSON数据
服务器给客户端响应时必须包含HTTP响应状态码
例：
GET --- 数据库查询
POST --- 数据库的增加操作
DELETE --- 数据库删除操作
PUT --- 数据库修改操作

什么是DRF框架
DRF框架是基于Django的第三方模块，其本质是Django框架的一个子应用
DRF框架提供的功能
认证 --- 在配置文件中指定认证方式
权限 --- 可以再视图中设置authentication_classes 指定权限
•    AllowAny 允许所有用户
•    IsAuthenticated 仅通过认证的用户
•    IsAdminUser 仅管理员用户
•    IsAuthenticatedOrReadOnly 认证的用户可以完全操作，否则只能get读取
限流
过滤
排序
分页 --- 全局分页器（修改配置文件） 单独视图数据分页pagination_class
异常处理
•    APIException 所有异常的父类
•    ParseError 解析错误
•    AuthenticationFailed 认证失败
•    NotAuthenticated 尚未认证
•    PermissionDenied 权限决绝
•    NotFound 未找到
•    MethodNotAllowed 请求方式不支持
•    NotAcceptable 要获取的数据格式不支持
•    Throttled 超过限流次数
•    ValidationError 校验失败
自动生成接口文档
DRF框架的视图类包括
基类
APIView

子类
ListAPIView
RetrieveAPIView
CreateAPIView
UpdateAPIView
DestroyAPIView

孙子类
GenericViewSet
ListModelMixin
RetrieveModelMixin
CreateModelMixin
UpdateModelMixin
DestroyModelMixin

重孙子类
ModelViewset（视图集）

DRF认证流程
通过路由匹配（底层调用的dispatch方法）到视图函数，再去request中进行认证处理

DRF实现用户访问频率控制
限制view请求频率
用户IP限制

Flask的第三方组件
Flask_restful
Flask_sqlalchemy
Flask_script
Flask_blueprint

Flask的请求上下文和应用上下文
Flask视图中的request就是请求上下文对象，它封装了整个HTTP请求
Current_app、g变量都是应用上下文，
current_app相当于Flask对象的代理，类似于快捷方式；
g变量是Flask中的全局变量，它保存的数据可以再整个项目中访问；

Nginx
Nginx是一款开源的高端性能的HTTP服务器和反向代理服务器
用户访问的地址并不是服务器的真正地址，而是Nginx服务器的地址，Nginx服务器再根据配置文件跳转到服务器
反向代理
隐藏服务器，提高网站的安全性
修改Nginx配置文件设置
负载均衡
指定多台服务器的权重值实现
使用默认的轮询方式实现

uWsgi和Niginx的作用
uWSGI是一个web服务器，他实现了wsgi协议、http协议等，他的作用是处理动态请求，将动态的http请求通过wsgi协议发送给web框架。
Nginx是一款高性能的http服务器，他通过url地址进行解析，判断用户请求访问的资源是静态资源还是动态资源，如果是静态的，就直接将静态资源返回给浏览器；如果是动态资源，就将请求转交给uWSGI服务器。

Nginx配置
Location 后面接指定匹配规则 当用户访问满足指定匹配规则是 则访问location中的路径
#负载均衡
upstream backends {
    server 192.168.229.128:10086;
    server 192.168.229.128:10087;
    server 192.168.229.128:10088;
}
server {
    #监听的端口号
    listen 9001;
    #服务器
    server_name 192.168.229.128;
    location / {
        #指向代理
        proxy_pass http://backends/;
    }
}

Docker
Docker类似虚拟机技术 但是他更小、更强大、运行速度更快，但是docker的本质是一个进程。
镜像 --- 相当于虚拟机的iso镜像文件
容器 --- 相当于一台运行了的虚拟机
仓库 --- github

Docker使用流程
先安装docker
使用docker命令获取镜像
写Dockerfile文件
利用镜像创建容器

DockerFile
Dockerfile就是一个包含了docker指令的文本文件
文件名必须是Dockerfile（首字母大写）
Dockerfile尽量放在一个空的目录中
每个容器只有一个功能
执行的命令越少越好

Dockerfile命令
FROM 导入镜像
RUN 执行命令
LABEL 注释
CMD 指定容器运行时的命令
EXPOSE 指定容器运行时的端口
WORKDIR 指定容器的路径（不存在自动创建）
ENV 环境变量
COPY 拷贝

FastDFS
FastDFS是一款开源的分布式文件系统，有三部分组成客户端（client）、Tracker、Storage（存储服务器）

FastDFS为什么高效
因为fastDFS是属于一个独立的文件存储服务器；使用fastDFS可以避免文件存储占用Django服务器的资源

FastDFS上传的流程
1.    客户端发送上传请求
2.    Tracker查询是否有可用的storage
3.    有的话，上传文件
4.    Storage生成file_id并把文件保存
5.    将file_id返回给客户端

FastDFS利用Nginx访问文件
修改Nginx文件的location 选项添加匹配规则 使当用户访问指定规则url时，可以实现文件的访问

JWT认证
Jwt（JSON Web Token）是一个轻巧的规范，允许使用jwt在两个组织间传递安全可靠的消息。

理解
Jwt认证相当于学生证（工牌），学校创建了学生证给我们，并且学校并不保存我们的学生证，但是我们只要拿着学生证就能通过学校的大门进入学校学习。

AJAX的组成
1、url 请求地址
2、type 请求方式
3、dataType 设置返回的数据格式，常用的是‘json‘格式（可以为空）
4、data 设置发送给服务器的数据
5、success 回调函数 error 设置请求失败后的回调函数

异步处理方案（Celery、rabbitMQ、activeMQ）
Celery --- 消息队列通过配置文件放在Redis中
rabbitMQ
activeMQ

快速排序
1.    现在列表中选取一个基数
2.    将的列表 第一个数据设置为L（做标记点），最后一个数据设置为R（右标记点）
3.    然后L向右走找到比基数大的数停止，R向左走找到比基数小的数时停止
4.    当L和R都停止移动时，交换指定的两个数字
5.    交换完成后，继续移动L和R；
6.    当L和R相同时，交换当前数和基数
7.    然后将基数左侧的列表和右侧的列表再分别进行快速排序

冒泡排序
1.    将列表中的第一个数与第二个数进行比较
2.    如果比第二个数小，就将他俩交换位置
3.    在使用第二个数和第三个数进行比较
4.    依次那这个数和后面的进行比较
5.    最后一个数就是最大的数
外层循环控制循环次数 内层循环控制数据比较

Io包
Stringio ---- 只能操作str---经常用来做字符串的缓存—因为接口和文件操作一致
BytesIO  --  实现了在内存中读写字节输入
要读取BytesIO，可以用一个bytes初始化BytesIO，然后像读文件一样读取；

元类
元类就是创建类的类，因为在Python中类也是一个对象（万物皆对象），type函数就是python中的一个元类，可以通过type函数创建一个类，然后通过这类创建对象。
（元类的作用） --- 用不到不用关心 用到自然知道怎么用
自定义元类
可以先定义一个元类方法，然后在定义类的时，通过metaclass属性指定一下元类的方法。