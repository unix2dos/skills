# Synthetic Raw Eval: logs-chat

Source blog: `自建日志搜索：为什么我们没用 CloudWatch Logs Insights`
Style: 聊天记录

## 原始材料

> A：CloudWatch Logs Insights 已经能查日志，为什么还搞 EC2 + ripgrep？

> B：不是要替代它。问题是开发排查时会反复改 query，扫描量不好控。我们愿意用 5-7 分钟延迟换固定底盘。

> A：Firehose 到 S3 以后直接 rg？

> B：不能。S3 是中转。EC2 定时拉，解 Firehose 文件，按 app/hour 写本地 gzip。

> A：Firehose 文件不就是 gzip 吗？

> B：坑在这里。外层 gzip 只是 envelope，record 里还有 CloudWatch Logs 压缩 payload。要检测 gzip magic 再解，否则提不出 logEvents.message。

> A：那 S3 为啥只留一天？

> B：因为最终可搜的是 EBS 上最近 7 天，S3 只负责失败重试和传输缓冲。留太久会让错误堆积和成本边界变差。

> A：入口是啥？

> B：`runway logs shell` 进 SSM，然后 `rg -z`。没有 API，没有 OpenSearch。

> A：这个是不是太土？

> B：土，但边界清楚。适合临时历史搜索，不适合实时 tail、聚合分析、高可用日志平台。
