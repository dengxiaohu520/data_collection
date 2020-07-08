# mysql创建触发器
```
CREATE TRIGGER `generate_tb_electron_mall_uuid_before_insert` BEFORE INSERT ON db_business_electron.tb_electron_mall FOR EACH ROW
BEGIN
IF new.electron_uuid is NULL THEN
      SET new.electron_uuid = UUID();
END IF;
END;
```