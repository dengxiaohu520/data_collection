# virtualenv基本操作
1. ubuntu安装virtualenv
```
sudo pip install virtualenv
sudo pip install virtualenvwrapper
```
安装完虚拟环境后，如果提示找不到mkvirtualenv命令，须配置环境变量:
    + 1.创建目录用来存放虚拟环境
   ```
   mkdir 
   $HOME/.virtualenvs
   ```
    + 2.打开~/.bashrc文件，并添加如下：
   ```
   export WORKON_HOME=$HOME/.virtualenvs
   source /usr/local/bin/virtualenvwrapper.sh
   ```
    + 3.运行
   ```
   source ~/.bashrc
   ```
2. 创建虚拟环境的命令:
    + 1.在python2中，创建虚拟环境:
    mkvirtualenv 虚拟环境名称
    + 2.在python3中，创建虚拟环境:
    mkvirtualenv -p python3 虚拟环境名称

3. 查看虚拟环境的命令：
```
workon 两次tab键
```
4. 退出虚拟环境的命令:
```
deactivate
```
5. 删除虚拟环境命令：
```
rmvirtualenv 虚拟环境名称
```
6. 查看虚拟环境安装的包：
```
pip freeze
```




# windows 虚拟环境
1. 安装虚拟环境
```
pip install virtualenvwrappe
pip install virtualenvwrapper-win　　#Windows使用该命令，不然就不能使用workon 命令
``` 
2. 创建虚拟环境
```
mkvirtualenv  名字
```
3. 查看有哪些虚拟环境
```
workon  #可查看目前有哪些虚拟环境
```
4. 进入虚拟环境
```
workon 名字 #可进入具体的虚拟环境下工作

或  虚拟环境名称\scripts\activate
```
5. 退出虚拟环境
```
deactivate  #退出虚拟环境
```


