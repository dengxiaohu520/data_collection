# GO go1.18.X windows系统安装Beego 和 Bee

1. 问题：（1） 无法使用go get安装。（2）'bee’不是内部或外部命令，也不是可执行程序。（3）执行go env显示的GOPATH与系统变量中设置的不一致。（4）github访问不了导致包下载失败。

2. 注意事项：
   beege和bee是两个概念。beego是框架，bee是工具，是命令。

   在安装Beego前，先确认是否将$GOPATH/bin写入GO环境中。


3. 先配置正确的环境变量：
    查看印象笔记


4. 安装命令：go install github.com/beego/bee/v2@latest

   



