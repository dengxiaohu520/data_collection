# tp5操作数据库
1. tp连接数据库
```
Db::connect([
    // 数据库类型
    'type'        => 'mysql',
    // 数据库连接DSN配置
    'dsn'         => '',
    // 服务器地址
    'hostname'    => '127.0.0.1',
    // 数据库名
    'database'    => 'thinkphp',
    // 数据库用户名
    'username'    => 'root',
    // 数据库密码
    'password'    => '',
    // 数据库连接端口
    'hostport'    => '',
    // 数据库连接参数
    'params'      => [],
    // 数据库编码默认采用utf8
    'charset'     => 'utf8',
    // 数据库表前缀
    'prefix'      => 'think_',
])->table('user')->find();


Db::connect('mysql://root:1234@127.0.0.1:3306/thinkphp#utf8')
	->table('user')
    ->find();
```
2. tp5 mysql数据查询
```
 2.1 查询单个数据使用find方法：
	 1. // table方法必须指定完整的数据表名
	 Db::table('think_user')->where('id',1)->find();   ----sql语句相当于：SELECT * FROM `think_user` WHERE  `id` = 1 LIMIT 1
 2.2 查询多个数据（数据集）使用select方法：
     Db::table('think_user')->where('status',1)->select();  ----sql语句相当于： SELECT * FROM `think_user` WHERE `status` = 1

 2.3 值和列查询
     查询某个字段的值可以用
     Db::table('think_user')->where('id',1)->value('name');
     查询某一列的值可以用
       // 返回数组
       Db::table('think_user')->where('status',1)->column('name');
       // 指定id字段的值作为索引
       Db::table('think_user')->where('status',1)->column('name','id');
     如果要返回完整数据，并且添加一个索引值的话，可以使用
       // 指定id字段的值作为索引 返回所有数据
       Db::table('think_user')->where('status',1)->column('*','id');
```

3. tp5 mysql添加数据
```
 3.1 使用 Db 类的 insert 方法向数据库提交数据 （方法添加数据成功返回添加成功的条数，通常情况返回 1）
    $data = ['foo' => 'bar', 'bar' => 'foo'];
    Db::name('user')->insert($data);
 3.2 使用data方法配合insert使用 （如果你的数据表里面没有foo或者bar字段，那么就会抛出异常。）
    $data = ['foo' => 'bar', 'bar' => 'foo'];
    Db::name('user')
    ->data($data)
    ->insert();
 3.3 如果不希望抛出异常，可以使用下面的方法 （不存在的字段的值将会直接抛弃）
    $data = ['foo' => 'bar', 'bar' => 'foo'];
    Db::name('user')->strict(false)->insert($data);
 3.4 添加数据后如果需要返回新增数据的自增主键，可以使用insertGetId方法新增数据并返回主键值
    $userId = Db::name('user')->insertGetId($data);

 3.5 填加多条数据
    添加多条数据直接向 Db 类的 insertAll 方法传入需要添加的数据即可
    $data = [
    ['foo' => 'bar', 'bar' => 'foo'],
    ['foo' => 'bar1', 'bar' => 'foo1'],
    ['foo' => 'bar2', 'bar' => 'foo2']
    ];
    Db::name('user')->insertAll($data);

    如果批量插入的数据比较多，可以指定分批插入，使用limit方法指定每次插入的数量限制。
    $data = [
    ['foo' => 'bar', 'bar' => 'foo'],
    ['foo' => 'bar1', 'bar' => 'foo1'],
    ['foo' => 'bar2', 'bar' => 'foo2']
    ...
    ];
    // 分批写入 每次最多100条数据
    Db::name('user')->data($data)->limit(100)->insertAll();
```

4. 更新数据
```
 4.1 更新id为1的数据 
    Db::name('user') -> where('id', 1) -> update(['name' => 'thinkphp']);  ---sql语句相当于：UPDATE `think_user`  SET `name`='thinkphp'  WHERE  `id` = 1
 4.2 支持使用data方法传入要更新的数据
    Db::name('user')
    ->where('id', 1)
    ->data(['name' => 'thinkphp'])
    ->update();
 4.3 如果数据中包含主键，可以直接使用
    Db::name('user')
    ->update(['name' => 'thinkphp','id'=>1]);
 4.4 更新字段
    Db::name('user')
    ->where('id',1)
    ->setField('name', 'thinkphp');   ---sql语句相当于：UPDATE `think_user`  SET `name` = 'thinkphp'  WHERE  `id` = 1
```

5. 删除数据
```
 5.1 删除数据
    // 根据主键删除
    Db::table('think_user')->delete(1);  ----sql语句相当于： DELETE FROM `think_user` WHERE  `id` = 1 
    Db::table('think_user')->delete([1,2,3]);  ----sql语句相当于： DELETE FROM `think_user` WHERE  `id` IN (1,2,3) 
    //条件删除
    Db::table('think_user')->where('id',1)->delete();  ----sql语句相当于： DELETE FROM `think_user` WHERE  `id` = 1
    Db::table('think_user')->where('id','<',10)->delete();  ---sql语句相当于： DELETE FROM `think_user` WHERE  `id` < 10 
 5.2 删除全部数据
    // 无条件删除所有数据
    Db::name('user')->delete(true);
```

6 查询表达式
```
 6.1 tp5 查询表达式
    where('字段名','表达式','查询条件');
    whereOr('字段名','表达式','查询条件');
 6.2 tp5.1 查询表达式
    whereField('表达式','查询条件');
    whereOrField('表达式','查询条件');

 6.3 不等于（<>）
   Db::name('user')->where('id','<>',100)->select();  ---sql语句相当于：SELECT * FROM `think_user` WHERE  `id` <> 100
```