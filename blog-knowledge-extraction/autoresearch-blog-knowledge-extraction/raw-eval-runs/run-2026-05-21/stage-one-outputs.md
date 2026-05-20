# Stage One Outputs

Skill: `skills/blog-knowledge-extraction/SKILL.md`

Input set: `raw-evals/*.md`

Run mode: single-agent execution of Stage One only. Outputs are intentionally compact but keep the required Stage One sections.

## logs-incident-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 固定成本的近期历史日志搜索链路 | 如何在不搭完整日志平台的前提下，用稳定成本搜索最近几天历史日志？ | Logs Insights 扫描成本、Firehose、S3 transit、EC2 cron、EBS gzip、Firehose 双层 gzip、SSM、`rg -z` | 这些组件共同构成同一条最小链路，拆开会变成服务说明 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| Firehose 文件解析机制 | Firehose 写到 S3 的日志为什么不能当普通 gzip 处理？ | 外层 gzip、内层 gzip payload、gzip magic、`logEvents.message` | 这是主链路的关键机制，不是完整主题 | 4 | 5 | 4 | 5 | 4 | 4 | 26 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《固定成本搜日志：从 CloudWatch 到 ripgrep》
   主知识簇：固定成本的近期历史日志搜索链路。
   推荐理由：材料核心不是“CloudWatch 不好”，而是如何用异步搬运、短期中转、本地落盘和文件搜索换稳定成本边界。

   知识簇结构：
   - 必讲机制：Logs Insights 扫描量；Firehose buffer；S3 中转；EC2 cron 和 `flock`；双层 gzip；`rg -z` 搜索。
   - 可选补充：不用 Lambda；`cdlogs`；相邻日期查询。
   - 项目案例：64 MiB / 300 秒 buffer，S3 保留一天，EBS 保留最近 7 天。
   - 删除内容：具体 app 名、完整部署手册、成本数字精算。

   文章骨架：
   1. 定义“近期历史日志搜索”问题。
   2. 最小模型：`CloudWatch -> Firehose -> S3 -> EC2 -> rg`。
   3. 解释采集、同步、解析、搜索四段机制。
   4. 给出适用场景和边界。

### 不推荐单独成文的内容

- `Firehose 双层 gzip`：放核心机制。
- `SSM 入口`：放项目案例。
- `不用 Lambda`：放边界。
- `成本模型`：放开头和明确建议。

请确认是否按推荐文章写。

## logs-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 低成本历史日志搜索的最小系统 | 如何用简单云组件替代频繁宽范围日志扫描？ | 成本、延迟、Firehose、S3、EC2、gzip 解析、`ripgrep`、边界 | 聊天中的问题都围绕同一个系统取舍，不应按组件拆篇 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《低成本历史日志搜索：从 CloudWatch 到 ripgrep》
   主知识簇：低成本历史日志搜索的最小系统。
   推荐理由：能把“为什么不用托管查询引擎”转成可迁移的系统设计模型。

   知识簇结构：
   - 必讲机制：按扫描量计费；异步日志搬运；S3 只做中转；本地 gzip 文件搜索；双层 gzip。
   - 可选补充：`cdlogs`、辅助 jq 查询、S3 lifecycle。
   - 项目案例：`runway logs shell` 后用 `rg -z` 搜索。
   - 删除内容：争论口吻和“土不土”的表达。

   文章骨架：
   1. 问题：频繁排障查询的成本不可控。
   2. 最小模型：托管采集 + 对象存储中转 + 单机搜索。
   3. 核心机制：buffer、重试、格式解析、搜索入口。
   4. 明确建议与边界。

### 不推荐单独成文的内容

- `CloudWatch Logs Insights 费用`：作为动机。
- `S3 lifecycle`：作为可靠性/成本边界。
- `cdlogs`：作为体验细节。

请确认是否按推荐文章写。

## gitea-incident-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| Gitea Actions 按 job 拉起 ephemeral runner 的调度模型 | 弹性 runner 应该监听什么事件、拉几个 runner、如何退出和清理？ | `workflow_job queued`、`push` fallback、Fargate `RunTask`、`--ephemeral`、`force=true`、注销和验证 | 事件语义、生命周期和清理共同回答一个调度模型问题 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| 升级后的 runner 可观测性 | server 升级后为什么 runner 仍失败，如何让失败可见？ | runner 版本、webhook 勾选、API path、HTTP status、offline 清理 | 属于主模型的落地边界 | 4 | 4 | 4 | 5 | 4 | 4 | 25 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《按 Job 拉起 Runner：Gitea Actions 的 workflow_job 模型》
   主知识簇：Gitea Actions 按 job 拉起 ephemeral runner 的调度模型。
   推荐理由：材料的可迁移点是按 job 调度临时 runner，而不是升级过程本身。

   知识簇结构：
   - 必讲机制：`push` 和 `workflow_job` 语义差异；ephemeral 生命周期；`force=true`；runner label；清理和可观测性。
   - 可选补充：旧 fallback；webhook UI 名称；版本打印。
   - 项目案例：Gitea webhook -> server -> ECS `RunTask`。
   - 删除内容：半天排障时间线和情绪。

   文章骨架：
   1. 为什么 `push` 不等于 runner 需求。
   2. 最小模型：queued job -> one runner。
   3. 事件、生命周期、清理、验证。

### 不推荐单独成文的内容

- `offline runner 清理脚本`：放可靠性章节。
- `act_runner 版本`：放检查清单。
- `升级踩坑复盘`：压缩成引入。

请确认是否按推荐文章写。

## gitea-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 一次性 runner 的事件语义和生命周期 | Gitea Actions 里哪个事件表示“现在需要 runner”，runner 跑完后如何收尾？ | `push`、`workflow_job queued`、`--ephemeral`、`force=true`、注销失败、offline runner | 这些点必须一起讲，否则读者只会学到零散 webhook 名称 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《一次性 Runner 怎么跑：Gitea Actions 的 workflow_job 模型》
   主知识簇：一次性 runner 的事件语义和生命周期。
   推荐理由：聊天材料自然暴露了误区：`push` 不是 job 需求，ephemeral 不是 server 自动具备的能力。

   知识簇结构：
   - 必讲机制：`push`/`workflow_job` 区别；并发 job；ephemeral runner；runner 注销。
   - 可选补充：webhook 勾选、API path、token 权限。
   - 项目案例：Fargate runner。
   - 删除内容：升级闲聊。

   文章骨架：
   1. 从 `push` 误解切入。
   2. 最小模型：每个 queued job 一个 runner。
   3. 生命周期和失败可观测性。

### 不推荐单独成文的内容

- `push fallback`：作为兼容边界。
- `webhook 勾选`：作为检查项。
- `API path`：作为清理细节。

请确认是否按推荐文章写。

## postman-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 用 OpenAPI 把 Postman 变成可生成资产 | 如何避免接口代码、OpenAPI、Postman 三份定义漂移？ | OpenAPI 单一源头、Makefile 分层、converter、Native Git、postprocess、sync、测试 | 这些步骤构成同一条生成链路，不应拆成工具教程 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《让 Postman 跟着 OpenAPI 走：从契约生成到 Native Git》
   主知识簇：用 OpenAPI 把 Postman 变成可生成资产。
   推荐理由：可迁移点是调试资产的所有权模型：Postman 是生成物，不是第二接口源头。

   知识簇结构：
   - 必讲机制：唯一契约；本地生成/云端同步分离；转换链路；后处理；生成链路测试。
   - 可选补充：tags 分组、Local/Cloud View。
   - 项目案例：Bearer Auth、登录 token、删除随机 id/examples。
   - 删除内容：Postman UI 教程。

   文章骨架：
   1. 三份接口定义漂移的问题。
   2. 最小模型：OpenAPI -> Postman Native Git。
   3. 生成、副作用、后处理、测试。

### 不推荐单独成文的内容

- `Bearer Auth 注入`：后处理案例。
- `删除 examples`：review 降噪案例。
- `Local View`：边界说明。

请确认是否按推荐文章写。

## postman-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 接口调试资产的单一源头生成链路 | Postman 如何从 OpenAPI 派生，而不是变成另一个手工源头？ | OpenAPI、postprocess、sync 副作用、generated review 边界 | 聊天里所有争论都围绕“源头”和“副作用边界” | 5 | 5 | 4 | 4 | 5 | 5 | 28 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《把 Postman 变成生成物：用 OpenAPI 驱动 Native Git》
   主知识簇：接口调试资产的单一源头生成链路。
   推荐理由：材料能讲清楚团队协作里哪些文件该 review，哪些只是生成物。

   知识簇结构：
   - 必讲机制：单一源头；脚本化定制；显式云端同步；生成物边界。
   - 可选补充：登录 token 脚本。
   - 项目案例：Make target 分层。
   - 删除内容：Postman UI 操作。

   文章骨架：
   1. 手工 collection 的漂移问题。
   2. 最小模型和副作用边界。
   3. 后处理脚本和 review 边界。

### 不推荐单独成文的内容

- `Postman UI 教程`：删除。
- `openapi-to-postmanv2 参数`：作为配置段。
- `登录 token 脚本`：作为后处理例子。

请确认是否按推荐文章写。

## terraform-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 平台化 Terraform 的 Embedded IaC 模型 | 平台如何把 Terraform 收进服务端，同时保留 Terraform 的执行和接管能力？ | `go:embed`、固定解压、provider cache、template HCL、CLI 子进程、state 引用、边界 | 这些共同描述平台接管 Terraform 控制面的执行模型 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| 跨 stack state 引用策略 | 哪些依赖交给 Terraform，哪些由平台先判断？ | `terraform_remote_state`、Go 读 tfstate、必需/可选依赖 | 是主模型的核心机制 | 5 | 5 | 4 | 5 | 4 | 5 | 28 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《把 Terraform 收进平台：从 YAML 到 apply》
   主知识簇：平台化 Terraform 的 Embedded IaC 模型。
   推荐理由：材料不是技巧列表，而是一种平台 IaC 架构模式。

   知识簇结构：
   - 必讲机制：模块嵌入；固定解压；HCL 模板；子进程执行；state 引用。
   - 可选补充：symlink、ALB priority、ACM 两阶段。
   - 项目案例：业务只写 YAML，server 生成 `.tf` 后 apply。
   - 删除内容：零散 Terraform 小技巧。

   文章骨架：
   1. 定义 Embedded IaC。
   2. 最小模型：YAML -> generated HCL -> Terraform apply。
   3. 模块、模板、执行、state、边界。

### 不推荐单独成文的内容

- `ALB priority`：细节。
- `ACM 两阶段`：边界案例。
- `Secret 立即删除`：风险提示。

请确认是否按推荐文章写。

## terraform-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 把 Terraform 作为平台内部执行引擎 | Terraform 仍是 CLI 时，平台到底接管了什么？ | 模块版本、输入生成、执行时机、日志、固定路径、普通 HCL、state 判断 | 这些都解释“当库用”的真实含义 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《把 Terraform 收进平台：从 YAML 到 apply》
   主知识簇：把 Terraform 作为平台内部执行引擎。
   推荐理由：聊天材料能纠正“import Terraform”误解，适合写成机制解释文。

   知识簇结构：
   - 必讲机制：不是 SDK；平台接管模块和输入；普通 HCL；子进程；可选 state。
   - 可选补充：provider cache、PR plan review 缺失。
   - 项目案例：Runway server 二进制绑定模块版本。
   - 删除内容：单独讲某个 remote_state 或 `prevent_destroy`。

   文章骨架：
   1. “当库用”是什么意思。
   2. 最小模型。
   3. 模块、模板、执行、state、代价。

### 不推荐单独成文的内容

- `terraform_remote_state 单点`：作为机制。
- `prevent_destroy`：边界。
- `CodeBuild prereqs`：实现优化。

请确认是否按推荐文章写。

## database-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 数据库凭证从平台资源进入容器环境变量的链路 | 配置声明如何变成容器启动时的 `DATABASE_URL`？ | `db create`、Terraform、Secret、tfstate 反查、ECS secrets、IAM role、SG 边界 | 这些是从资源创建到容器注入的一条链路 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| ECS Secret 注入与 role 分工 | 为什么应用无需 AWS SDK 也能拿到 Secret？ | `valueFrom :url::`、execution role、task role、server role | 主链路核心机制 | 5 | 5 | 5 | 5 | 4 | 5 | 29 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《从 YAML 到环境变量：数据库凭证如何进入容器》
   主知识簇：数据库凭证从平台资源进入容器环境变量的链路。
   推荐理由：材料最强点是跨 CLI、Terraform、Secret、ECS、IAM 的完整链路。

   知识簇结构：
   - 必讲机制：`db: postgresql` 不是动作；`db create`；tfstate 反查；ECS secret 注入；role 分工。
   - 可选补充：Secret rotation、SG、recovery window。
   - 项目案例：Runway DB stack 到 app deploy。
   - 删除内容：ECR tag、完整等待逻辑。

   文章骨架：
   1. YAML 字段不是命令。
   2. 最小模型：db create -> secret -> deploy -> env。
   3. Secret、tfstate、ECS、IAM。

### 不推荐单独成文的内容

- `db: postgresql 误会`：开头误区。
- `recovery_window`：边界。
- `publicly_accessible`：安全反例。

请确认是否按推荐文章写。

## database-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 配置声明到容器启动前 Secret 注入链路 | 平台怎样把数据库声明、资源创建、部署反查和容器注入接起来？ | YAML、`db create`、tfstate、Secrets Manager、ECS `valueFrom`、execution role | 这些必须合并才能解释为什么 `DATABASE_URL` 为空或出现 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《数据库凭证怎样进容器：从 RDS 到 DATABASE_URL》
   主知识簇：配置声明到容器启动前 Secret 注入链路。
   推荐理由：聊天材料自然聚焦“谁负责把 Secret 放进容器”。

   知识簇结构：
   - 必讲机制：声明/动作分离；tfstate 反查；ECS agent 注入；execution role vs task role。
   - 可选补充：Secret rotation。
   - 项目案例：`db create` 后下一次 deploy。
   - 删除内容：ECR tag、ECS completed 观察。

   文章骨架：
   1. 为什么 YAML 不等于 env。
   2. 最小模型。
   3. 注入机制和权限边界。

### 不推荐单独成文的内容

- `Task role vs execution role 单篇`：作为核心机制。
- `ECR tag`：删除或另文。
- `ECS completed 观察`：另一个部署稳定性主题。

请确认是否按推荐文章写。

## partition-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 数据增长时如何选择分区、分表、分库分表 | 数据变多后应该在哪一层拆，应用是否感知？ | 分区/分表/分库分表、partition pruning、分区键、唯一约束、未来 partition、MongoDB 反例、GenLab 案例 | 这些共同构成选择模型 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| 托管 PostgreSQL 分区落地检查 | 在 RDS/Runway 上落地分区要注意什么？ | env、migration、EnsurePartitions、advisory lock、归档 | 是主选择后的实践章节 | 4 | 4 | 4 | 5 | 4 | 4 | 25 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《数据增长后怎么拆表：分区、分表和分库分表的选择》
   主知识簇：数据增长时如何选择分区、分表、分库分表。
   推荐理由：材料的价值是概念和决策模型，不是 GenLab 部署清单。

   知识簇结构：
   - 必讲机制：谁来拆、拆到哪、应用知不知道；PostgreSQL 分区；分表；分库分表。
   - 可选补充：MongoDB sharding、物理分区。
   - 项目案例：GenLab 按 `created_at` 月度分区。
   - 删除内容：完整 Runway 检查清单。

   文章骨架：
   1. 三个概念一句话区分。
   2. 最小模型。
   3. PostgreSQL 分区、分表、分库分表门槛。
   4. GenLab 案例和建议。

### 不推荐单独成文的内容

- `GenLab 部署清单`：项目案例。
- `MongoDB 是否绕开`：误区。
- `物理分区`：术语澄清。

请确认是否按推荐文章写。

## partition-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| PostgreSQL 分区、分表、分库分表的决策模型 | 大表应该先分区、分表、分库分表，还是换数据库？ | 分区、分表、分库分表、MongoDB sharding、GenLab 选择 | 对话围绕同一个选择问题，不应拆成数据库选型散文 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《数据变大后怎么拆：分区、分表和分库分表》
   主知识簇：PostgreSQL 分区、分表、分库分表的决策模型。
   推荐理由：能纠正常见跳跃：从“大表”直接跳到“分库分表”或“换 MongoDB”。

   知识簇结构：
   - 必讲机制：分区键、pruning、业务路由、shard key。
   - 可选补充：EnsurePartitions、env 名。
   - 项目案例：GenLab。
   - 删除内容：Runway 部署步骤。

   文章骨架：
   1. 概念区分。
   2. 选择门槛。
   3. GenLab 案例。
   4. MongoDB 误区。

### 不推荐单独成文的内容

- `EnsurePartitions`：落地细节。
- `Runway env 名`：部署提醒。
- `MongoDB sharding`：反例和边界。

请确认是否按推荐文章写。

## cli-notes

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 内部 CLI 的服务端边界设计 | 内部 CLI 如何把网络、安全、成功判断和资源反代放到可信服务端？ | DB tunnel、WebSocket、TCP_NODELAY、Redis 授权、ECS 观察、冷静期、pgweb、脱敏、受控反代 | 这些点共同回答“边界放哪里”，不应拆成功能清单 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| WebSocket 隧道机制 | 数据库 TCP 流如何穿过 WebSocket？ | frame、goroutine、NoDelay | 主知识簇的网络机制 | 5 | 5 | 4 | 5 | 4 | 4 | 27 | 作为章节 |

### 推荐文章

建议写 1 篇：

1. 《把边界放到服务端：内部 CLI 的工程化设计》
   主知识簇：内部 CLI 的服务端边界设计。
   推荐理由：乱序材料能收敛到同一工程取向：CLI 和前端只是入口，可信边界在服务端。

   知识簇结构：
   - 必讲机制：网络边界；协议边界；成功边界；安全确认；受控反代。
   - 可选补充：`TCP_NODELAY`、readiness。
   - 项目案例：Runway DB tunnel、ECS wait、pgweb。
   - 删除内容：CLI 功能清单。

   文章骨架：
   1. 边界问题。
   2. 最小模型。
   3. 网络、安全、成功、资源四类边界。

### 不推荐单独成文的内容

- `WebSocket 不能 io.Copy`：核心机制。
- `TCP_NODELAY`：性能细节。
- `pgweb readiness`：项目案例。

请确认是否按推荐文章写。

## cli-chat

### 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 内部平台工具的可信边界设计 | 内部工具中网络、安全、成功判断和反代范围的可信边界应该在哪里？ | DB tunnel、冷静期、ECS completed、pgweb 反代、日志脱敏 | 聊天材料明确指向“边界放哪里”这一上位问题 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

### 推荐文章

建议写 1 篇：

1. 《把边界放到服务端：内部 CLI 的工程化设计》
   主知识簇：内部平台工具的可信边界设计。
   推荐理由：能把多个分散功能统一为内部平台工具的设计原则。

   知识簇结构：
   - 必讲机制：server 进 VPC；服务端冷静期；二阶段成功判断；manager 登记端口。
   - 可选补充：日志脱敏。
   - 项目案例：Runway CLI。
   - 删除内容：单独讲 DB tunnel/ECS/pgweb。

   文章骨架：
   1. CLI 不是可信边界。
   2. 四类边界。
   3. Runway 案例。
   4. 明确建议。

### 不推荐单独成文的内容

- `DB tunnel 单篇`：作为网络边界。
- `ECS completed 单篇`：作为成功边界。
- `pgweb 管理单篇`：作为资源边界。

请确认是否按推荐文章写。
