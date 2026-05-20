# Synthetic Raw Eval: database-notes

Source blog: `一行 YAML 的旅行：从 db postgresql 到 DATABASE_URL`
Style: 排障日志

## 原始材料

- 现象：`runway.yaml` 写了 `db: postgresql`，deploy 成功，但 app 里 `os.Getenv("DATABASE_URL") == ""`。
- 第一猜测：deploy 没读 yaml。错一半。CLI 确实 load 了 cfg.Database，但构造 DeployRequest 时没发 database 配置。
- 结论：`db: postgresql` 不是命令。真建库要 `runway db create -e dev`。
- `db create` 链路：CLI 发 HTTP -> server 用模板生成 Terraform root -> apply RDS module -> Secrets Manager 里有 JSON，含 `url`。
- deploy 不是被 db create 通知。deploy 时按 app/env 命名反查 DB stack tfstate，拿 `secret_arn`。
- ECS task definition 用 secrets：
  ```text
  valueFrom = secret_arn + ":url::"
  ```
  容器启动前 ECS agent 注入 `DATABASE_URL`。
- 应用代码不需要 AWS SDK 读 Secret。
- task execution role 和 task role 不一样。execution role 给 ECS agent 拉镜像、写 logs、读 Secret；task role 给业务代码运行时访问 AWS。
- 真正危险的是 server role，它能 Terraform apply。
- 边界：Secret rotation 不会自动改已运行 task；`recovery_window_in_days = 0` prod 危险；RDS publicly_accessible 依赖 SG 限制。

## 希望写成博客

别写成一次“YAML 没生效”的吐槽。讲清楚从配置声明到容器环境变量的完整链路。
