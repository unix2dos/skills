# Synthetic Raw Eval: database-chat

Source blog: `一行 YAML 的旅行：从 db postgresql 到 DATABASE_URL`
Style: 聊天记录

## 原始材料

> A：我写了 `db: postgresql`，为什么容器没有 DATABASE_URL？

> B：因为那行 YAML 被解析了，但 deploy 请求没有带 database 配置。建库动作是 `runway db create`。

> A：那 db create 建完以后怎么告诉 app？

> B：不是主动告诉。下一次 deploy 反查 DB stack 的 tfstate，拿到 `secret_arn`。

> A：连接串在哪？

> B：Secrets Manager 的 JSON 里有 `url`。ECS task definition 通过 `valueFrom` 加 `:url::` 取这个字段。

> A：应用代码需要 AWS SDK 吗？

> B：不需要。ECS agent 在容器启动前注入环境变量。用的是 task execution role。

> A：task role 呢？

> B：留给应用运行后访问 AWS，比如 S3。别把启动需要的权限和业务运行权限混在一起。

> A：文章方向？

> B：不是讲某行 YAML bug。讲平台如何把数据库资源、Secret、tfstate、ECS 和 IAM role 接成 `DATABASE_URL`。
