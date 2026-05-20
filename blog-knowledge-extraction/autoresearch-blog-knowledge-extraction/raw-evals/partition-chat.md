# Synthetic Raw Eval: partition-chat

Source blog: `DATABASE_PARTITIONING_GUIDE`
Style: 聊天记录

## 原始材料

> A：表以后会很大，是不是直接分库分表？

> B：别跳太快。先区分分区、分表、分库分表。它们解决的问题不一样。

> A：PostgreSQL 分区是不是应用无感？

> B：大体上是。应用查父表，但查询要带分区键，比如 `created_at`，否则 pruning 不明显。

> A：分表呢？

> B：业务代码通常要知道去哪张表。它更适合业务边界强、冷热路径不同、schema 开始分叉的时候。

> A：分库分表是不是终极方案？

> B：它解决单库实例瓶颈，但复杂度最高。事务、唯一约束、跨 shard 查询都要付代价。

> A：换 MongoDB 可以绕开吗？

> B：不能。MongoDB 大了也要 sharding，还是要 shard key。除非数据模型更适合文档数据库，否则不是逃避分区设计的理由。

> A：GenLab 怎么选？

> B：当前按 `created_at` 月度 PostgreSQL 分区。保留普通表体验，提前建未来 partition，查询尽量带时间。
