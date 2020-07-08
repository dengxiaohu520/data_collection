# python 多线程
1. 单任务变成
```
import time


def sing():
    for i in range(5):
        print("-----唱-----")
        time.sleep(1)


def dance():
    for i in range(5):
        print("-----跳-----")
        time.sleep(1)


sing()
dance()

```

2. 多线程实现多任务
```
import time
import threading


def sing():
    for i in range(5):
        print("-----唱-----")
        time.sleep(1)


def dance():
    for i in range(5):
        print("-----跳-----")
        time.sleep(1)


# 指定线程处理函数
t1 = threading.Thread(target=sing)
t2 = threading.Thread(target=dance)

# 当调用start方法的时候，才会去真正的创建一个线程，并且这个线程立马开始执行
# 在创建这个t1指向的Thread对象时target指定的是那个函数名，那么这个新的线程就会到哪个函数中执行代码
t1.start()
t2.start()

```

3. 使用互拆锁来解决多线程共享全局变量的问题

```
import threading
import time

g_num = 0


def test1(num):
    global g_num
    for i in range(num):
        mutex.acquire() # 上锁
        g_num += 1
        mutex.release() # 解锁

    print("----in test1 g_num=%d---" % g_num)


def test2(num):
    global g_num
    for i in range(num):
        mutex.acquire() # 上锁
        g_num += 1
        mutex.release() # 解锁

    print("----in test2 g_num=%d---" % g_num)


mutex = threading.Lock()  # 创建一个互斥锁，默认没有上锁
t1 = threading.Thread(target=test1, args=(10000000,))
t2 = threading.Thread(target=test2, args=(10000000,))
t1.start()
t2.start()

time.sleep(3)

print("-----in main thread g_num=%d----" % g_num)


```