# mysql性能
explain显示mysql如何使用索引来处理查询语句和链接表信息。用来帮助优化索引和查询语句。
直接在查询语句前面加explain就可以：
EXPLAIN SELECT dept.dname,emp.job from dept,emp where dept.deptno=emp.empno;

explain列的解释：

列名	意义
id	执行编号，标识select所属的行。如果在语句中没有子查询或关联查询，只有唯一的select，每行都将显示1.否则，内层的select语句一般会顺序编号，对应于其在原始语句中的位置
select_type	显示本行是简单或复杂select。如果查询有任何复杂的子查询，则最外层标记为PRIMARY（DERIVED、UNION、UNION RESUIT）
table	访问引用哪个表（引用某个查询，如“derived3”）
type	数据访问/读取操作类型（All、index、range、ref、eq_ref、const/system、NULL）
possible_key	揭示哪一些索引可能有利于高效的查找
key	显示mysql决定采用哪个索引来优化查询
key_len	显示mysql在索引里使用的字节数
ref	显示了之前的表在key列记录的索引中查找值所用的列或常量
rows	为了找到所需要的行而需要读取的行数，估算值，不精确。通过把所有rows列值相乘，可初略估算整个查询会检查的行数
Extra	额外信息，如using index、filesort等
PS：type显示的是访问类型，是一个重要的指标，结果值从好到坏依次是：
system > const > eq_ref> ref> fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index>all
一般情况下至少要保证range级别，最好能达到ref。

type列返回的描述说明：

类型	说明
All	最坏的情况，全表扫描
index	和全表扫描一样。只是扫描表的时候按照索引次序进行而不是行。主要优点就是避免了排序，但是开销仍然非常大。如在Extra列种看到Usingindex，说明正在使用覆盖索引，只扫描索引的数据，它比按索引次序全表扫描的开销要小很多
range	范围扫描，一个有限制的索引扫描。key列显示使用了哪个索引。当使用=、<>、>、>=、<、<=、IS NULL、<=>、BETWEEN或者IN操作符，用常量比较关键字列时，可以使用range
ref	一种索引访问，它返回所有匹配某个单个值得行。此类索引访问只有当使用非唯一性索引或唯一性索引非唯一性前缀索引时才会发生。这个类型跟eq_ref不同的是，它用在关联操作只使用了索引的最左前缀，或者索引不是UNIQUE和PRIMARY KEY。ref可以用于使用=或<=>操作符的带索引的列。
eq_ref	最多只返回一条符合条件的记录。使用唯一性索引或主键查找时会发生（高效）
const	当确定最多只会有一行匹配的时候，MySQL优化器会在查询前读取它而且只读取一次，因此非常快。当主键放入where字句时，mysql把这个查询转为一个常量（高效）
system	这是const连接类型的一种特例，表仅有一行满足条件
Null	意味说mysql能在优化阶段分解查询语句，在执行阶段甚至用不到访问表或索引（高效）
extra列返回的描述说明：

列名	意义
Distinct	一旦MYSQL找到了与行相联合匹配的行，就不再搜索了
Not exists	MYSQL优化了LEFT JOIN，一旦它找到了匹配LEFT JOIN标准的行，就不再搜索了
Range checked for each Record（index map:#）	没有找到理想的索引，因此对于从前面表中来的每一个行组合，MYSQL检查使用哪个索引，并用它来从表中返回行。这是使用索引的最慢的连接之一
Using filesort	看到这个的时候，查询就需要优化了。MYSQL需要进行额外的步骤来发现如何对返回的行排序。它根据连接类型以及存储排序键值和匹配条件的全部行的行指针来排序全部行
Using index	列数据是从仅仅使用了索引中的信息而没有读取实际的行动的表返回的，这发生在对表的全部的请求列都是同一个索引的部分的时候
Using temporary	看到这个的时候，查询需要优化了。这里，MYSQL需要创建一个临时表来存储结果，这通常发生在对不同的列集进行ORDER BY上，而不是GROUP BY上
Where used	使用了WHERE从句来限制哪些行将与下一张表匹配或者是返回给用户。如果不想返回表中的全部行，并且连接类型ALL或index，这就会发生，或者是查询有问题不同连接类型的解释（按照效率高低的顺序排序）
system 表只有一行	system表。这是const连接类型的特殊情况
const	表中的一个记录的最大值能够匹配这个查询（索引可以是主键或惟一索引）。因为只有一行，这个值实际就是常数，因为MYSQL先读这个值然后把它当做常数来对待
eq_ref	在连接中，MYSQL在查询时，从前面的表中，对每一个记录的联合都从表中读取一个记录，它在查询使用了索引为主键或惟一键的全部时使用
ref	这个连接类型只有在查询使用了不是惟一或主键的键或者是这些类型的部分（比如，利用最左边前缀）时发生。对于之前的表的每一个行联合，全部记录都将从表中读出。这个类型严重依赖于根据索引匹配的记录多少—越少越好
range	这个连接类型使用索引返回一个范围中的行，比如使用>或<查找东西时发生的情况
index	这个连接类型对前面的表中的每一个记录联合进行完全扫描（比ALL更好，因为索引一般小于表数据）
ALL	这个连接类型对于前面的每一个记录联合进行完全扫描，这一般比较糟糕，应该尽量避免