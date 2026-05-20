# Synthetic Raw Eval: partition-notes

Source blog: `DATABASE_PARTITIONING_GUIDE`
Style: 设计草稿

## 原始材料

- 问题：GenLab 任务表未来会大。现在要不要 PostgreSQL 分区？分表？分库分表？还是换 MongoDB？
- 白话：
  - 分区：应用看到一张表，数据库内部拆子表。
  - 分表：真的拆多张表，业务代码通常知道。
  - 分库分表：拆到多个数据库实例，要 shard key 和路由。
- PostgreSQL 声明式分区：`PARTITION BY RANGE(created_at)`。查询带 `created_at` 才能 partition pruning。
- 主键/唯一约束要包含分区键，不然全局唯一很麻烦。
- 未来 partition 要提前建。插入没有匹配 partition 会失败。
- GenLab 的 `image_generation_tasks` / `video_generation_tasks` 适合按 `created_at` 月度分区。写入都带时间，历史归档也按时间。
- 现在不建议分库分表：单库还不是瓶颈，先别引入 shard 路由。
- 分表有价值，但要等业务边界明确，比如租户隔离、冷热路径完全不同、schema 开始分叉。
- MongoDB 不能逃避拆分问题。数据大了还是 sharding，还是要 shard key，热点 shard 仍然会有。
- Runway/RDS 不给你控制底层磁盘物理分区；这里说的是 PostgreSQL 表分区。

## 希望写成博客

不要写成 GenLab 部署清单。讲清楚分区、分表、分库分表的选择模型。
