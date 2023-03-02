# git操作小技巧
1. 提交之前回退代码(放弃新改写的代码)
```
git checkout -- xxxx.py
```
2. git回退代码：
```
git reset --hard HEAD^ 回退到上个版本
git reset --hard HEAD~3 回退到前3次提交之前，以此类推，回退到n次提交之前
git reset --hard commit_id 退到/进到，指定commit的哈希码（这次提交之前或之后的提交都会回滚）
```
3. git 撤销commit回滚
```
有时候commit后发现commit信息错了或者是添加了不想commit的内容，但还没有push到远程仓库
场景1：Git撤销commit消息，保留本地修改
git reset --soft commit_id 

场景2：Git撤销commit消息，本地不保留
git reset --hard commit_id

node:（commit_id = git log查看上一个id）
```

4. 查看上次文件中修改的内容
```
git diff XXX(文件名)
```

5. git区分
```
<<<<<<< HEAD

本地代码

=======

拉下来的代码

>>>>>>>
```

6. 查看冲突是否解决
```
git diff --check
```