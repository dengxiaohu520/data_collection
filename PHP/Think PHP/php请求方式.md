# php请求方式

1. 我们要先认识的是请求对象Request类
```
<?php
//要用Request类 第一步就要引入他，才能在当前控制器上使用
//知识点：use 与 namespace前面不可有空格等其他操作。
namespace app\admin\controller;
use think\Request;
class Index{
　　// 在index方法引入Request
　　public function index(Request $request){
　　　　// parma 表示接收所有传过来的参数 不管是post请求还是get请求 parma都能接收到参数
　　　　$data = $request->param();
　　　　// post表示只接收 post方式传出来的参数
　　　　$data1= $request->post();
　　　　// get表示只接收get方式传出来的参数
　　　　$data2= $request->get();
　　　　// 假如你只想拿到一个name值，这时我们可以在括号里面加上name即可。
　　　　$data = $request->param('name');
　　}
　}
?>
```

2. 在TP5.1中又怎么判断请求类型呢？
```
<?php
//要用Request类 第一步就要引入他，才能在当前控制器上使用
//知识点：use 与 namespace前面不可有空格等其他操作。
namespace app\admin\controller;
use think\Request;
class Index{
	// 在index方法引入Request
	public function index(Request $request){
	//判断请求类型是否为 post
	if($request->isPost()){
	dump('当前请求类型为post');
	}
	//判断请求类型是否为 get
	if($request->isGet()){
	dump('当前请求类型为get');
	}
	//判断请求类型是否为 Put
	if($request->isPut()){
	dump('当前请求类型为put');
	}
	//判断请求类型是否为 ajax
	if($request->isAjax()){
	dump('当前请求类型为ajax');
	}
	//判断请求类型是否是手机访问
	if($request->isMobile()){
	dump('当前请求类型为手机类型');
	}
	}
}
?>
```