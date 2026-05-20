## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 用平台封装 Terraform 执行链路 | “把 Terraform 当库用”在工程上到底是什么意思，平台需要接管哪些部分，又会付出什么代价？ | Terraform 仍作为 CLI 子进程；平台接管模块版本、输入生成、执行时机和日志；`go:embed all:modules` 打包模块；固定路径解压稳定 provider cache；模板生成普通 `.tf`；保留手工接管能力；必需依赖用 remote state；可选依赖由 Go 读 tfstate 后跳过或注入；server 成为部署入口；没有 drift detection 和 PR plan review | 聊天里每个问答都在校正同一个概念误区：这里不是把 Terraform SDK import 进 Go，而是让平台成为 Terraform 的外层执行系统。模块嵌入、固定路径、HCL 模板、依赖策略和代价都服务于这个概念 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《把 Terraform 当内部引擎：平台封装 IaC 的取舍》
   主知识簇：用平台封装 Terraform 执行链路
   推荐理由：材料能纠正一个重要误解：“把 Terraform 当库用”不是调用 Terraform API，而是把 Terraform CLI 包进平台的部署闭环。文章可以讲清楚平台封装 IaC 的最小模型、为什么保留普通 `.tf`、为什么固定路径看似粗糙却有缓存收益，以及这种封装带来的集中化风险。

   知识簇结构：
   - 必讲机制：Terraform 仍是 CLI；平台接管模块、输入、执行和日志；模块内嵌到 server；固定路径解压与 provider cache；模板生成 HCL；必需依赖和可选依赖分流；平台化代价。
   - 可选补充：为什么不选 Pulumi/CDK；生成普通 `.tf` 后可以手工 apply；固定路径“不优雅但有效”的工程取舍。
   - 项目案例：业务仓库不拿 modules，只写平台配置；server 通过 `go:embed all:modules` 携带 modules；可选 DB 不存在时跳过注入。
   - 删除内容：抽象讨论 IaC 工具优劣；完整 Terraform 教程；所有 cloud resource 的具体封装细节。

   文章骨架：
   1. 先澄清概念：这里的“当库用”指平台接管 Terraform 执行链路，不是 Go 里 import Terraform。
   2. 给出最小模型：业务 YAML 输入、平台生成 `.tf`、Terraform CLI 执行、日志和结果回到平台。
   3. 解释模块交付：为什么 modules 不发给业务仓库，而是 embed 进 server 二进制。
   4. 解释固定路径：随机目录会让 provider cache 失效，固定路径用工程朴素性换执行稳定性。
   5. 解释为什么生成普通 `.tf`：保留 Terraform 生态和故障接管能力，避免把 HCL 变成不可见的内部对象。
   6. 解释跨 stack 依赖策略：必需依赖交给 `terraform_remote_state`，可选依赖由 Go 先判断。
   7. 收束到边界：统一模块版本提升一致性，但 server 变部署入口，且没有 drift detection 和 PR plan review。

## 不推荐单独成文的内容

- `固定路径是不是脏`：这是 provider cache 机制下的取舍案例，必须放回平台执行链路里解释，单独写会过窄。
- `为什么不 Pulumi/CDK`：这是工具选择的补充，不是主问题；正文中作为“为什么保留普通 .tf”的一段即可。
- `跨 stack 是否都用 remote_state`：它依赖“必需依赖/可选依赖”这个平台注入模型，适合作为核心机制之一，不应拆成独立文章。
- `server 成为部署入口的代价`：这是主文章边界，必须讲，但单独成文会缺少前面的最小模型。

请确认是否按推荐文章写。
