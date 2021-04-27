# PHP基础语法
1. PHP范围解析操作符 （::） 
范围解析操作符（也可称作 Paamayim Nekudotayim）或者更简单地说是一对冒号，可以用于访问静态成员，类常量，还可以用于覆盖类中的属性和方法

2. PHP => 、 -> :
->是对象执行方法或取得属性用的。
=>是数组里键和值对应用的。
```
<?php
//从数组变量$arr中，读取键为apple的值
$arr = array('apple' => "苹果", 'banana' => "香蕉", 'pineapple' => "菠萝");
$arr0 = $arr["apple"];
if (isset($arr0)) {
    print_r($arr0);
}
?>
```

```
<?php
class Car {
    public $speed = 0;
//增加speedUp方法，使speed加10
    public function speedUp(){
        $this->speed+=10;
    }
}
$car = new Car();
$car->speedUp();
echo $car->speed;
?>
```

3. PHP文件上传error的错误类型  
```
$_FILES['file']['error']
```

4. 