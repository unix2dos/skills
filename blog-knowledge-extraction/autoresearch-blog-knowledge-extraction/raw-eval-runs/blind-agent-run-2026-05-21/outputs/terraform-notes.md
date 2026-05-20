## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 把 Terraform 作为平台内部执行引擎 | 平台怎样让业务只写声明式配置，同时由服务端接管 Terraform 模块、输入生成、执行和边界？ | 业务仓库只写 `runway.yaml`；`go:embed all:modules` 打包模块；启动后解压到固定目录；固定路径稳定 provider cache；用 `text/template` 生成普通 `.tf`；Terraform 作为 CLI 子进程执行；`-chdir`、`-input=false`、`-no-color`；必需依赖用 `terraform_remote_state`；可选依赖由 Go 先读 tfstate；无 drift detection 和 PR plan review；模块版本与 server 二进制绑定 | 这些内容共同构成 Embedded IaC 的最小模型。embed、解压、模板、CLI、跨 stack 依赖和边界都不是零散技巧，而是在说明平台如何把 Terraform 收进自己的部署入口。拆开会丢掉“平台接管 Terraform 生命周期”的主问题 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| Terraform 细节坑位清单 | 哪些 Terraform 或云资源细节在平台化封装时容易踩坑？ | ALB priority hash；ACM 自定义域名两次 deploy；`prevent_destroy` 必须字面量；Secret 立即删除有风险 | 这些内容是平台落地时的边界或反例，但不共同回答一个独立读者问题。它们依赖主知识簇中的平台执行模型，适合作为边界补充或案例脚注 | 3 | 3 | 3 | 3 | 2 | 2 | 16 | 不推荐 |

## 推荐文章

建议写 1 篇：

1. 《把 Terraform 收进平台：Embedded IaC 的最小模型》
   主知识簇：把 Terraform 作为平台内部执行引擎
   推荐理由：材料最强的知识点不是 Terraform 小技巧，而是平台如何把 Terraform 变成内部执行引擎：业务只提交 YAML，平台负责模块版本、HCL 生成、provider 缓存、子进程执行和依赖注入。这个模型可迁移到任何想封装 IaC 但又不想放弃 Terraform 生态的内部平台。

   知识簇结构：
   - 必讲机制：业务配置和 Terraform 模块分层；`go:embed all:modules` 打包模块；固定路径解压与 provider cache；模板生成普通 `.tf`；Terraform CLI 子进程执行；必需依赖和可选依赖的不同处理；平台化边界。
   - 可选补充：`all:` 为什么不能省；`-chdir`、`-input=false`、`-no-color` 的执行意义；生成物可接管的调试价值。
   - 项目案例：Runway 中业务只写 `runway.yaml`；server 内嵌 modules；shared VPC 用 `terraform_remote_state`；可选 DB 由 Go 读 tfstate 后决定是否注入。
   - 删除内容：ALB priority hash、ACM 两次 deploy、`prevent_destroy` 字面量、Secret 删除风险等零散细节，只保留和主线直接相关的边界。

   文章骨架：
   1. 先澄清“把 Terraform 当库用”不是 Go import Terraform，而是平台接管 Terraform 的输入、模块、执行时机和输出。
   2. 建立最小模型：`runway.yaml -> Go 生成 .tf -> terraform init/apply -> 云资源`。
   3. 解释模块交付：用 `go:embed all:modules` 把 Terraform modules 绑定到 server 二进制。
   4. 解释执行目录：为什么启动后解压到固定目录，以及它如何影响 provider cache。
   5. 解释 HCL 生成：为什么用 `text/template` 生成普通 `.tf`，而不是把 HCL 当 AST 或直接换 CDK。
   6. 解释 Terraform 仍是子进程：`-chdir`、`-input=false`、`-no-color` 分别解决什么执行问题。
   7. 解释跨 stack 依赖：必需依赖交给 Terraform 报错，可选依赖由平台先判断再注入。
   8. 说明代价和边界：没有 drift detection、没有 PR plan review、server 成为部署入口、模块版本和二进制绑定。

## 不推荐单独成文的内容

- `ALB priority hash`：这是资源封装细节，不是 Embedded IaC 的核心模型，适合在项目案例里一句带过或删除。
- `ACM 自定义域名两次 deploy`：它属于具体云资源生命周期问题，会分散主线，除非另写自定义域名部署文章。
- `prevent_destroy 必须字面量`：这是 Terraform 语法边界，可放入“常见误区和边界”，不应单独成文。
- `Secret 立即删除有风险`：这是资源删除策略问题，和主知识簇弱相关，正文最多作为风险提示。

请确认是否按推荐文章写。
