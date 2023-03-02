# php三元运算符基本用法
1. 基础用法
```
$if_summary = $row['IF_SUMMARY']==2?'是':'否';
这等同于：
if($row['IF_SUMMARY']==2){
$if_summary="是";
}else{
$if_summary="否"；
}

```