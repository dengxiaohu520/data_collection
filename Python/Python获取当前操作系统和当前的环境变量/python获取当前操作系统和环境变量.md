# python常用函数

1. python中获取常用变量的一个方法：
```
import os

JS_ADDRESS = os.environ.get("PALM_JS_ADDRESS")
print(os.environ.get("PALM_JS_ADDRESS"))
```
2. Python之获取平台和操作系统信息（platform模块）
```
import platform
platform.platform()        #获取操作系统名称及版本号，'Linux-3.13.0-46-generic-i686-with-Deepin-2014.2-trusty'
platform.system()          #获取操作系统名称，'Linux'
platform.version()         #获取操作系统版本号，'#76-Ubuntu SMP Thu Feb 26 18:52:49 UTC 2015'
platform.architecture()    #获取操作系统的位数，('32bit', 'ELF')
platform.machine()         #计算机类型，'i686'
platform.node()            #计算机的网络名称，'XF654'
platform.processor()       #计算机处理器信息，''i686'
platform.uname()           #包含上面所有的信息汇总，('Linux', 'XF654', '3.13.0-46-generic', '#76-Ubuntu SMP Thu Feb 26 18:52:49 UTC 2015', 'i686', 'i686')

示例：
LOG_PATH = '/data/logs/icmofang/moli_apscheduler/'
    if platform.system().lower() == 'windows':
        LOG_PATH = 'E:/log/apscheduler/'
        if not os.path.exists(LOG_PATH):
            os.mkdir(LOG_PATH)
    elif platform.system().lower() == 'linux':
        if not os.path.exists(LOG_PATH):
            os.mkdir(LOG_PATH)
    else:
        if not os.path.exists(LOG_PATH):
            os.mkdir(LOG_PATH)
```
