# git 暂存操作
1. 暂存操作
```
#查看当前状态
git status 
#如果有修改,添加修改文件
git add .
#暂存操作
git stash save '本次暂存的标识名字'
```
2. 查看当前暂存的记录
```
#查看记录
git stash list
```
3. 恢复暂存的工作
```
‘pop命令恢复,恢复后,暂存区域会删除当前的记录’
#恢复指定的暂存工作, 暂存记录保存在list内,需要通过list索引index取出恢复
git stash pop stash@{index}

‘apply命令恢复,恢复后,暂存区域会保留当前的记录’
#恢复指定的暂存工作, 暂存记录保存在list内,需要通过list索引index取出恢复
git stash apply stash@{index}
```
4. 删除暂存
```
#删除某个暂存, 暂存记录保存在list内,需要通过list索引index取出恢复
git stash drop stash@{index}
#删除全部暂存
git stash clear
```