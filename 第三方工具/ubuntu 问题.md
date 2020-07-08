# ubuntu碰到过问题：
1. ubuntu 18.04 解决无法联网的问题：
    + 1.输入以下代码：
    ```
    sudo service network-manager stop
    sudo rm /var/lib/NetworkManager/NetworkManager.state
    sudo service network-manager start
    ```
	再次输入ifconfig ，之前的静态IP重新出现了。问题解决，可以联网了。

	+ 2.上面删除的内容，然后重启网络
	```
	$cat ~/software/NetworkManager.state
    [main]
    NetworkingEnabled=false
    WirelessEnabled=true
    WWANEnabled=true
	```

2. 解决ubuntu与windows之间无法复制问题
    + 1.重装vmware-tools:
    ```
    sudo apt-get autoremove open-vm-tools
    sudo apt-get install open-vm-tools 
    sudo apt-get install open-vm-tools-desktopvmware-tools
    ```
    + 2.重装后，仍无法复制粘贴操作复制粘贴、拖拽、窗口缩放等问题都是因为vmware-user这个进程没有启动起来，在终端输入“/usr/bin/vmware-user”就可以手动启动。


