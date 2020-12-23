# mysql根据两个字段去重, 只保留其中一条
```
// 创建中间表
CREATE TABLE tb_electron_ic_back(id INTEGER,part_number VARCHAR(128),merchant_name VARCHAR(128));


// 将重复数据插入到第三张表中
INSERT INTO tb_electron_ic_back (
SELECT *  
FROM tb_electron_ic 
WHERE (part_number, merchant_name) IN (SELECT `part_number`,`merchant_name` 
  FROM tb_electron_ic GROUP BY tb_electron_ic.`part_number`,tb_electron_ic.`merchant_name` 
  HAVING COUNT(*) > 1) 
  AND id NOT IN 
  (SELECT MIN(id) FROM tb_electron_ic 
  GROUP BY tb_electron_ic.`part_number`,tb_electron_ic.`merchant_name` 
  HAVING COUNT(*) > 1)) ;
	
	
//删除中间表
DELETE FROM A WHERE a1 IN (SELECT a1 FROM F);
SELECT *FROM A;
```