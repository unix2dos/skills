# Synthetic Raw Eval: logs-incident-notes

Source blog: `自建日志搜索：为什么我们没用 CloudWatch Logs Insights`
Style: 排障日志

## 原始材料

- 线上排障时大家一直用 Logs Insights，单次 `$0.005/GB` 看起来不贵，但关键词改几次、时间范围拉大、日志组多选后扫描量不可控。
- 需求不是实时 tail，也不是做日志平台，只想搜最近 7 天历史日志，成本边界要稳定。
- 方案草图：
  ```text
  CloudWatch Logs -> subscription filter -> Firehose -> S3 -> EC2 cron -> EBS /logs -> rg -z
  ```
- Firehose buffer 现在是 64 MiB / 300 秒。延迟几分钟可以接受，小文件数量别太爆炸。
- S3 bucket 只是 transit，保留 1 天。EC2 成功解析后删对象，失败就留着下次 cron 继续。
- cron 要 `flock`，不然上一次还在跑，下一分钟又进来。
- 一开始有人想 Lambda，但权限和运行时依赖麻烦，而且后面还是要落 EBS 给 rg 搜。
- Firehose 落下来的不是普通 gzip：外层 gzip 解开以后，里面每条 record 的 `data` 还要再看 gzip magic。之前误以为是 base64 文本，解析错了。
- 搜索入口：SSM 进实例，`cdlogs`，然后 `rg -z "user_id" /logs/app/date/hour.gz`。
- 硬伤：不是高可用；不能实时；复杂聚合不行；权限隔离粗；跨天要搜相邻目录。

## 希望写成博客

不要写成“我们为什么不用 Logs Insights”的情绪文。最好讲清楚这种小系统什么时候值得搭，什么时候不值得搭。
