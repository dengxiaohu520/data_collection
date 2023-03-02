# php基本用法

1. 使用phpstudy运行thinkphp项目
 1. 配置一个临时域名
 2. 将自己本地域名指向配置的这个临时域名
 3. 根目录指向项目的public文件夹

2. tp5获取配置文件中的参数：
```
use think\facade\Config

$dhs_api = Config::get('dhs_api');
$app_env = Config::get('app_env');
```

<!-- 3. tp5 使用post请求：
```
jsonRequestPost(url, $params); -->
```

4. tp5常用函数：
```
!empty($result)  # 判断$result是否为空

```