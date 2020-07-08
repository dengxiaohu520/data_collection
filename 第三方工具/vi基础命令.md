1、复习
    1.1 操作系统作用
        向下封装硬件，向上提供接口
        
    1.2 目录结构
    a) 相同的
        以树状方式管理
    b) 不同点
        windows以盘符管理
        linux以目录（文件夹）管理
        
    /: 根目录
    /home: 放用户目录（宿主、主目录）
    /bin: 放工具，命令
    /usr: 第三方应用程序
    
    1.3 命令解释器
    命令解释器自带命令(内建命令)
    /bin的命令(外部命令)
    
    找命令，优先从内建中找，找不到再找外部
    
    type -a 命令 看命令的类型
    
    1.4 帮助文件
    a) 外部命令
        命令 --help
        man 命令
        
    b) 内建命令
        help 命令
    
    1.5 快捷键
    ctrl+a(home): 句首
    ctrl+e(end):  句尾
    
    1.6 常用命令
    ls 查看目录信息
    -a: 查看所有，为了查看隐藏文件
        隐藏文件以.开头
    -l: list， 以列表方式显示
    -lh: 更加人性化
    
    ls *.txt 后缀为.txt的文件
    ls *.*   中间带.的文件
    
    tree: 树状方式显示目录
    tree -L 2 只显示2层
    
    重定向：本来显示到屏幕，改为显示到文件
    history > cmd.txt    覆盖
    history >> cmd.txt   追加
    
    切换到主目录
    cd
    cd ~
    cd ~/
    
    无作用
    cd .
    cd ./
    
    上一级目录
    cd ..
    cd ../
    
    上一次
    cd -
    
    根目录下的home
    cd /home
    
    当前目录下的home
    cd home
    cd ./home
    
    上一级目录的home
    cd ../home
    
    
    touch： 文件存在新建空文件(不能是文件夹)，文件存在修改时间
    
    ln -s 源文件  链接文件   创建软链接（快捷方式）
    ln 源文件  链接文件      创建硬链接（用于备份）
        注意：硬链接只能是普通文件
    
    rm 普通文件
    rm 文件夹 -r
              -i 提示
              -f 强制删除
    
    cp 复制
    mv 移动
    
    cp 源文件 目的文件      如果是文件夹，需要-r
    mv 源文件 目的文件
    
    mkdir 文件夹     只能新建文件夹，不能是普通文件
    mkdir a/b/c -p   递归创建文件夹
    
2. 常用命令
    2.1 显示文件内容
    cat 文件          显示文本文件内容，一次性显示内容
    more/less 文件    分页显示内容
    
    示例：
    cat /usr/include/stdio.h
    
    2.2
    find ./ -name "yyy.txt"  在当前路径下，查找名字为"yyy.txt"的文件
    find ./ -name "*.txt"    在当前路径下，查找后缀为".txt"的文件
    find /bin -size 300k     在/bin路径下，找大小为300k的文件
    find /bin -size +300k    在/bin路径下，找大小大于300k的文件
    find /bin -size -300k    在/bin路径下，找大小小于300k的文件
    find ./ -type f    在/bin路径下，找普通文件  
    
    2.3  
    grep "m" demo.txt        查找带"m"关键字的内容
    grep "m" demo.txt -n     -n显示行号
    grep "m" demo.txt -ni    -i 忽略大小写
    grep "m" demo.txt -niv   -v 取反
    grep "^m" demo.txt -n    以m开头的内容
    grep "m$" demo.txt -n    以m结尾的内容
    grep "ke..y" demo.txt -n  以ke开头以y结尾，中间有2个字符
    grep "are u ok?" demo.txt -n  有空格最好加""
    
    2.4
    ls /bin/ > demo.txt   放内容
    grep "pwd" demo.txt   取内容，关键字取
    
    ls /bin/ | grep "pwd"
    | 管道：一端放内容，另外一端取内容
    
    
    管道(|)：一个命令的输出可以通过管道做为另一个命令的输入。
    
    print("mike") #输出，打印， 写
    a = input("请输入a") #输入，读
    
    ps -aux | grep "bash"
    
    2.5
    a) .tar.gz
    压缩：tar -cvzf 压缩包名.tar.gz   需要压缩的文件或文件夹
              f一定要放在后面，前3个顺序任意
              c:   create，新建
              v:   进度，可以不用
              z:   打包完成后，调用gzip工具来压缩
              
          示例：tar -czvf xxx.tar.gz /bin    把/bin目录做成一个压缩包
        
        du -h 查看当前路径下文件总大小
    
    解压：
        tar -xvf 压缩包名.tar.gz   没有指定路径，解压到当前路径
        tar -xvf 压缩包名.tar.gz -C 指定的路径
    
    b) .tar.bz2
    压缩：tar -cvjf 压缩包名.tar.bz2  需要压缩的文件或文件夹
              f一定要放在后面，前3个顺序任意
              c:   create，新建
              v:   进度，可以不用
              j:   打包完成后，调用bzip2工具来压缩
              
          示例：tar -cjvf yyy.tar.bz2 /bin    把/bin目录做成一个压缩包
       
    
    解压：
        tar -xvf 压缩包名.tar.bz2   没有指定路径，解压到当前路径
        tar -xvf 压缩包名.tar.bz2 -C 指定的路径
     
    
    c) .zip
    压缩：
        zip -r 压缩包名.zip  需要压缩的文件或文件夹
    
    解压：
        unzip 压缩包名.zip  没有指定路径，解压到当前路径
        unzip 压缩包名.zip -d 指定的路径
    
    2.6 文件权限
    -rw-rw-r-- 1 python python 7.9M 3月  30 16:21 zzz.zip
    文件所有者：user，谁创建文件，谁就是所有者，朋友圈设置状态为私有
    用户组：    group，QQ群，朋友分类， 发朋友圈指定好友看
    其它用户：  other，朋友圈中允许陌生人看10张状态
    
    r:  只能查看内容，不能修改
    w:  只能修改
    x:  可以执行
    -:  没有权限
    
    字母法：
    chmod u-x cmd.sh  文件所有者减去可执行
    chmod g+x cmd.sh  用户组加上可执行
    chmod o=w cmd.sh  其它用户只用写

    chmod a=rwx cmd.sh 所有用户有可读，可写，可执行
    chmod a=- cmd.sh   什么权限都没有
    chmod u=r,g=w,o=x cmd.sh
    
    数字法：
    rwx
    111   7
    
    r--
    100   4
    
    -w-
    010   2
    
    --x
    001   1
    
    chmod 765 cmd.sh
          rwxrw-r-x

    chmod 7 cmd.sh  等价于 chmod 007 cmd.sh
                                 ------rwx    
    
    
    2.7 切换到管理员
    whoami 查看当前登陆用户
    
    切换到root用户
    sudo -s
    sudo su root  
    
    exit: 退出上一个用户，如果为第一个用户，退出终端
    
    2.8 安装和卸载
    sudo apt-get update          先更新
    sudo apt-get install 软件名  安装
    sudo apt-get remove 软件名   卸载
    
    
    2.9 远程连接
    a) window远程连接linux
       在windows下测试网络：
       运行（win+r） =====>  cmd ======> 终端
       ping 192.168.15.94
    
    b) linux远程连接linux
        ssh 用户名@ip
    
    2.9 远程传输文件
    a) window和linux交互(ftp)
        1) 借助xftp
        2) 借助Filezilla
    
    a) linux和linux交互(ftp)
        1) 借助Filezilla
        2) 借助scp命令
    
    2.10 vi交互文件
    a) 没有保存vi写的内容，直接关闭终端，产生交互文件，这个交互文件是原来内容的备份
    b) 按R先恢复，然后，保存，再删除交互文件
    
    2.11 vi模式切换
    命令  =====》 编辑     按i
    编辑  =====》 命令     esc
    命令  =====》 末行     :
    编辑  =====》 末行    先切换到命令，再切换到末行
    
    
    2.12 vi基本操作
    a) 打开文件 vi xxx.txt
                vi xxx.txt +5  光标定位在第5行
    b) 编辑文件  按i后切换到编辑模式后就可以写代码
    c) :wq
    
    
    vimtutor  vim使用手册
    
    
    2.13 缩进
    按大写V, 向下向上方向键选中多行
       >   往右缩进
       <   往左缩进