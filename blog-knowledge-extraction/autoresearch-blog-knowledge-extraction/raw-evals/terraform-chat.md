# Synthetic Raw Eval: terraform-chat

Source blog: `把 Terraform 当库用：Embedded IaC 的工程内幕`
Style: 聊天记录

## 原始材料

> A：你说“把 Terraform 当库用”，Go 里 import Terraform 了吗？

> B：没有。Terraform 还是 CLI 子进程。意思是平台接管模块版本、输入生成、执行时机和日志。

> A：模块怎么发给业务仓库？

> B：不发。`go:embed all:modules` 进 server 二进制，server 解压到固定路径。

> A：固定路径是不是脏？

> B：是有点土，但 provider cache 会稳定。随机路径每次 deploy 都像新 module。

> A：为什么不 Pulumi/CDK？

> B：这里想保留普通 `.tf`。模板生成 HCL，坏了还能拿出来手工 apply。

> A：跨 stack 都用 remote_state 不行吗？

> B：必需依赖可以。可选依赖更适合 Go 先看 tfstate，不存在就跳过注入。

> A：最大代价？

> B：统一模块版本很爽，但 server 变部署入口；没有 drift detection 和 PR plan review；升级平台会影响所有 app。
