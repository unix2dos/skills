## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 内部 CLI 的服务端边界设计 | 内部 CLI 连接云资源、执行危险操作、暴露本地管理界面时，哪些边界必须放到服务端？ | 数据库 tunnel、WebSocket 转发、TCP `SetNoDelay(true)`、Redis sidecar 校验、ECS rollout 判定、危险操作冷静期、pgweb 进程复用、日志脱敏、admin console 反代白名单、TCP readiness | 这些功能表面很散，但共同回答“CLI 不能信任本地入口，真实边界要放在哪里”。网络边界、安全边界、成功边界、资源边界都是同一个工程化原则的不同落点，拆开会变成功能清单。 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《把边界放到服务端：内部 CLI 的工程化原则》
   主知识簇：内部 CLI 的服务端边界设计
   推荐理由：材料明确要求不要写 Runway CLI 功能清单，而要讲“内部 CLI 怎么把真实边界放到服务端”。这篇文章可以把 db tunnel、危险操作确认、部署等待、pgweb、反代安全统一成一个可迁移原则：CLI 只做入口和交互，网络访问、权限校验、危险操作确认、成功判定和资源授权必须由服务端掌握。

   知识簇结构：
   - 必讲机制：本地 CLI 与服务端的职责分界；`psql -> CLI -> WebSocket -> server -> VPC 内 RDS` 的网络边界；危险操作的服务端 `cooldown_until`；ECS rollout 不能只看 `COMPLETED`；反代只能访问 manager 登记端口；日志脱敏。
   - 可选补充：WebSocket 不是普通 `io.ReadWriter`，要按 message frame 双向转发；PostgreSQL / Redis 小包协议需要两段 TCP `SetNoDelay(true)`；pgweb 按 app/env 复用并闲置回收；readiness 用 TCP 而不是 HTTP。
   - 项目案例：Runway CLI 的 db tunnel、Redis tunnel、ECS 部署等待、pgweb 管理界面、危险操作 preview/confirm。
   - 删除内容：逐条介绍 Runway CLI 功能；把 pgweb 进程管理写成本地工具使用教程；展开 AWS ECS 的完整部署系统。

   文章骨架：
   1. 先用一句话定义原则：CLI 是入口，边界在服务端。
   2. 最小模型：画出 CLI、server、VPC、RDS、manager、admin console 的职责边界。
   3. 核心机制一：网络边界为什么在 server，而不是开发者本机。
   4. 核心机制二：危险操作确认为什么必须由服务端数据库保存冷静期。
   5. 核心机制三：成功边界为什么不能只依赖单个云厂商状态。
   6. 核心机制四：资源边界和反代白名单如何避免任意端口代理风险。
   7. 项目案例：Runway CLI 如何把 tunnel、Redis、ECS、pgweb 串成同一个边界模型。
   8. 明确建议：设计内部 CLI 时，默认把授权、确认、状态判定和资源白名单放到服务端。

## 不推荐单独成文的内容

- `WebSocket tunnel 转发细节`：它很有技术深度，但只是网络边界落地的一部分，适合作为核心机制里的实现细节。
- `ECS rolloutState=COMPLETED 之后还要等待`：这是成功边界的案例，不应脱离 CLI 边界设计单独成文。
- `pgweb 进程复用和 TCP readiness`：属于资源管理和本地工具生命周期细节，应压缩进项目案例。
- `日志脱敏`：重要但材料不足以独立成文，应放在资源边界或安全边界章节。

请确认是否按推荐文章写。
