## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 平台把数据库资源接成 `DATABASE_URL` 的运行模型 | 为什么写了数据库配置后，应用最终能从容器环境变量里拿到连接串？ | `db: postgresql` 被解析但不负责建库、`runway db create` 才执行资源创建、deploy 反查 DB stack tfstate、Secrets Manager JSON 中的 `url` 字段、ECS task definition 的 `valueFrom` 字段选择、ECS agent 启动前注入环境变量、task execution role 与 task role 的职责差异 | 这些内容都在回答同一个链路问题：数据库资源如何穿过平台控制面、Secret 存储、部署描述和 ECS 运行时，变成应用进程里的 `DATABASE_URL`。其中任何一个机制单独写都会缺少上下游语境 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《数据库连接串注入：从资源创建到容器启动》
   主知识簇：平台把数据库资源接成 `DATABASE_URL` 的运行模型
   推荐理由：聊天材料的价值不在某一行 YAML 是否有 bug，而在澄清一个常见误解：配置被解析、资源被创建、Secret 被引用、环境变量被注入，是四个不同阶段。把它写成端到端模型，读者才能迁移到自己的平台或 ECS 服务里。

   知识簇结构：
   - 必讲机制：`db: postgresql` 只是被解析的配置；建库动作属于 `runway db create`；deploy 通过 tfstate 找 `secret_arn`；Secrets Manager 的 JSON 字段 `url` 被 `valueFrom` 选择；ECS agent 负责注入环境变量；task execution role 和 task role 分别服务启动期和运行期。
   - 可选补充：deploy 请求没有带 database 配置导致的排障线索；“主动通知 app”和“部署时反查状态”的差异；应用不需要 AWS SDK 读取 Secret。
   - 项目案例：用户写了 `db: postgresql` 后容器没有 `DATABASE_URL`，排查发现建库和部署是两条链路，下一次 deploy 需要从 DB stack tfstate 反查 Secret。
   - 删除内容：逐句复述聊天记录；把文章写成问答整理；展开不影响主线的 CLI 参数细节。

   文章骨架：
   1. 用 `DATABASE_URL` 为空的问题引出阶段拆分：声明、创建、引用、注入。
   2. 声明阶段：解释为什么 YAML 被解析不等于数据库已经存在。
   3. 创建阶段：`runway db create` 创建数据库资源，并把连接串写入 Secrets Manager。
   4. 部署阶段：deploy 反查 DB stack tfstate，拿到 `secret_arn`，写入 ECS task definition。
   5. 启动阶段：`valueFrom` 选择 Secret JSON 的 `url` 字段，ECS agent 注入 `DATABASE_URL`。
   6. 权限阶段：区分 task execution role 和 task role，说明应用代码为什么不需要 AWS SDK。
   7. 默认建议：把启动所需 Secret 交给 task definition 和 execution role，把业务 AWS 权限留给 task role。

## 不推荐单独成文的内容

- `deploy 请求没带 database 配置`：这是排障证据，不是完整知识点，应作为项目案例说明“解析配置不等于传递配置”。
- `应用是否需要 AWS SDK 读 Secret`：答案很关键，但它依赖 ECS Secret 注入机制，适合作为核心机制或误区章节。
- `task role 和 execution role 区别`：这是权限边界章节，不应脱离 `DATABASE_URL` 注入链路单独成文。

请确认是否按推荐文章写。
