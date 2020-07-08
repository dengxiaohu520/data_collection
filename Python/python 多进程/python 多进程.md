# python 多进程

1. 多进程实现多任务
```
import time
import multiprocessing


def test1():
    while True:
        print("-----test1-----")
        time.sleep(1)

def test2():
    while True:
        print("-----test2-----")
        time.sleep(1)


# 指定进程处理函数
p1 = multiprocessing.Process(target=test1)
p2 = multiprocessing.Process(target=test2)

# 启动进程
p1.start()
p2.start()

```
2. Queue实例
```
import multiprocessing
import time
import random

# 写数据进程执行的代码:
def write(q):
    for value in ['A', 'B', 'C']:
        print('Put %s to queue...' % value)
        q.put(value)
        time.sleep(random.random())

# 读数据进程执行的代码:
def read(q):
    while True:
        if not q.empty():
            value = q.get(True)
            print('Get %s from queue.' % value)
            time.sleep(random.random())
        else:
            break

if __name__=='__main__':
    # 父进程创建Queue，并传给各个子进程：
    q = multiprocessing.Queue()
    pw = multiprocessing.Process(target=write, args=(q,))
    pr = multiprocessing.Process(target=read, args=(q,))
	
    # 启动子进程pw，写入:
    pw.start()    
    # 等待pw结束:
    pw.join()
    # 启动子进程pr，读取:
    pr.start()
    pr.join()
	
    print('')
    print('所有数据都写入并且读完')

```

3. 进程池的使用
```
import os, time, random, multiprocessing

def worker(msg):
    t_start = time.time()
    print("%s开始执行,进程号为%d" % (msg,os.getpid()))
    # random.random()随机生成0~1之间的浮点数
    time.sleep(random.random()*2) 
    t_stop = time.time()
    print(msg,"执行完毕，耗时%0.2f" % (t_stop-t_start))

po = multiprocessing.Pool(3)  # 定义一个进程池，最大进程数3

for i in range(10):
    # Pool().apply_async(要调用的目标,(传递给目标的参数元祖,))
    # 每次循环将会用空闲出来的子进程去调用目标
    po.apply_async(worker,(i,))

print("----start----")
po.close()  # 关闭进程池，关闭后po不再接收新的请求
po.join()  # 等待po中所有子进程执行完成，必须放在close语句之后
print("-----end-----")
```


4. 进程池中的Queue
```
import os, time, random, multiprocessing

def reader(q):
    print("reader启动(%s),父进程为(%s)" % (os.getpid(), os.getppid()))
    for i in range(q.qsize()):
        print("reader从Queue获取到消息：%s" % q.get(True))

def writer(q):
    print("writer启动(%s),父进程为(%s)" % (os.getpid(), os.getppid()))
    for i in "itcast":
        q.put(i)

if __name__=="__main__":
    print("(%s) start" % os.getpid())
    q = multiprocessing.Manager().Queue()  # 使用Manager中的Queue
    po = multiprocessing.Pool()
    po.apply_async(writer, (q,))

    time.sleep(1)  # 先让上面的任务向Queue存入数据，然后再让下面的任务开始从中取数据

    po.apply_async(reader, (q,))
    po.close()
    po.join()
    print("(%s) End" % os.getpid())


 输出：
(18400) start
writer启动(17080),父进程为(18400)
reader启动(19724),父进程为(18400)
reader从Queue获取到消息：i
reader从Queue获取到消息：t
reader从Queue获取到消息：c
reader从Queue获取到消息：a
reader从Queue获取到消息：s
reader从Queue获取到消息：t
(18400) End
```


5. 多进程拷贝文件
```
import multiprocessing
import os
import time


def copyFile(q, fileName, srcFolderName, destFolderName):
    """完成文件的copy"""
    # print("正在copy文件%s" % fileName)

    srcFile = open(srcFolderName + "/" + fileName, "rb")  # 读方式打开
    destFile = open(destFolderName + "/" + fileName, "wb")  # 写方式打开

    # 读取源文件内容，拷贝到目标文件
    content = srcFile.read()
    destFile.write(content)

    # 关闭文件
    srcFile.close()
    destFile.close()

    # 适当延时
    time.sleep(0.2)

    # 文件名放入Queue中
    q.put(fileName)


def main():
    """完成整体的控制"""
    # 1. 获取需要copy的文件夹的名字
    srcFolderName = input("请输入需要copy的文件夹的名字：")

    # 2. 根据需要copy的文件夹的名字，整理一个新的文件夹的名字
    destFolderName = srcFolderName + "[复件]"

    # 3. 创建一个新的文件夹
    try:
        os.mkdir(destFolderName)
    except Exception as ret:
        pass

    # 4. 获取文件夹中需要copy的文件名字
    fileNameList = os.listdir(srcFolderName)

    # 5.1 创建一个队列
    q = multiprocessing.Manager().Queue()

    # 5.2 创建一个进程池，完成copy
    pool = multiprocessing.Pool(5)

    # 6. 向进程池中添加任务
    for fileName in fileNameList:
        pool.apply_async(copyFile, (q, fileName, srcFolderName, destFolderName))

    allNum = len(fileNameList)
    currentNum = 0
    while True:
        fileName = q.get()  # 取出完成的文件名
        currentNum += 1

        # print("已经完成了从%s-------(%s)------>%s" % (srcFolderName, fileName, destFolderName))
        print("\r进度%.2f%%" % (100 * currentNum / allNum), end="")

        # 拷贝完成
        if currentNum == allNum:
            break

    # 不再向进程池中添加任务，并且等待所有的任务结束
    pool.close()
    pool.join()

    print("\n\nok..")


if __name__ == "__main__":
    main()


```