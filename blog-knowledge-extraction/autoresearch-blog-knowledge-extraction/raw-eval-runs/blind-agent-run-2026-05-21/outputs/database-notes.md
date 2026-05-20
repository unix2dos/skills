## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 从数据库声明到容器环境变量的注入链路 | 平台怎样把一个数据库资源声明变成应用可读的 `DATABASE_URL`？ | `db: postgresql` 的声明边界、`runway db create` 建库链路、Terraform/RDS/Secrets Manager、deploy 反查 tfstate、ECS task definition 的 `valueFrom`、ECS agent 注入环境变量、task execution role 与 task role 的权限边界、Secret rotation 与 RDS 安全边界 | 这些内容共同解释同一条端到端链路：资源先被创建并写入 Secret，再由部署流程引用 Secret，最后由 ECS 在容器启动前注入环境变量。单独拆开会把主问题切碎，读者无法建立完整模型 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《ECS Secret 注入机制：从数据库声明到 DATABASE_URL》
   主知识簇：从数据库声明到容器环境变量的注入链路
   推荐理由：材料不适合写成“YAML 没生效”的排障复盘。真正可迁移的知识点是：平台如何把数据库资源、Secret、部署状态和容器运行时串起来，让应用不通过 AWS SDK 也能读取连接串。这个模型能迁移到其他基于 Terraform、Secrets Manager 和 ECS 的平台设计里。

   知识簇结构：
   - 必讲机制：声明配置不等于执行命令；`db create` 创建数据库和 Secret；deploy 通过 app/env 反查 DB stack tfstate；ECS task definition 用 `valueFrom = secret_arn + ":url::"` 引用 JSON 字段；ECS agent 在容器启动前注入 `DATABASE_URL`；task execution role 与 task role 的区别。
   - 可选补充：Secret rotation 不会自动更新已运行 task；`recovery_window_in_days = 0` 在生产环境危险；RDS `publicly_accessible` 仍依赖安全组限制。
   - 项目案例：`runway.yaml` 写了 `db: postgresql` 但容器里 `DATABASE_URL` 为空，原因是 deploy 请求没有携带 database 配置，真正建库动作是 `runway db create -e dev`。
   - 删除内容：把问题写成一次 YAML bug 吐槽；展开 Terraform root 模板的完整实现细节；展开 RDS 网络拓扑和安全组配置清单。

   文章骨架：
   1. 先区分“声明数据库需求”和“创建数据库资源”：`db: postgresql` 只是配置，不是建库命令。
   2. 建库阶段：CLI 发请求，服务端生成 Terraform root，apply RDS module，并把连接信息写入 Secrets Manager JSON。
   3. 部署阶段：deploy 不等待 db create 通知，而是按 app/env 反查 DB stack tfstate，拿到 `secret_arn`。
   4. 容器启动阶段：ECS task definition 通过 `valueFrom` 引用 Secret 的 `url` 字段，ECS agent 注入 `DATABASE_URL`。
   5. 权限边界：execution role 服务 ECS agent，task role 服务业务代码，server role 才是能执行 Terraform apply 的高危角色。
   6. 使用建议和边界：应用只读环境变量；Secret 更新后重启任务；生产环境谨慎处理删除窗口、公开访问和安全组。

## 不推荐单独成文的内容

- `db: postgresql 为什么不生效`：它只是引入问题，单独写会变成项目排障流水账，应放在开头作为反例。
- `task execution role 和 task role`：这是理解 Secret 注入的必讲机制，但不能独立回答整条数据库连接串链路，适合作为权限边界章节。
- `Secret rotation、recovery_window_in_days、publicly_accessible`：这些是边界和安全提醒，适合放在“常见误区和边界”，不应抢主线。

请确认是否按推荐文章写。
