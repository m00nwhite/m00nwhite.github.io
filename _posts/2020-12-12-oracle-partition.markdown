---
layout: post
title:  "Oracle Partition相关操作"
date:   2020-12-12 01:02:37 +0800
categories: Oracle Partition
---

# 常用语句
```sql
--查看表分区
select partition_name, high_value from user_tab_partitions t where table_name = 'tablename'

--查询表分区绑定的字段名
select * from user_part_key-columns t where name='tablename'

-- 查看当前表分区的具体状况
select * from user_tab_partitions t where table_name = 'tablename'

-- 增加表分区
alter table tablename add partition partitionname values
less than ('20201212') logging nocompress;

-- 修改分区名称
alter table tablename rename partition oldpartname to newpartname;




```

