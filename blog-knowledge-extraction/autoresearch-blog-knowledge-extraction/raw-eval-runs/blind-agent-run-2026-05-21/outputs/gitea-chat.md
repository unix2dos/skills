## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| Gitea Actions 按 job 事件拉起一次性 runner | 一个 workflow 可能产生多个 job 时，弹性 runner 应该按什么信号扩容，怎样避免并发 job 没有 runner？ | push 不能表示 job 数、`workflow_job queued` 表示具体 job 等 runner、`force=true` 拉 runner、已有 runner running 时不能 skip、`--ephemeral` 由 runner 二进制支持、server 升级不升级镜像、offline runner 注销失败、清理日志要打 status、API path 和 token 权限检查 | 聊天中的问答都在围绕“按 job 调度 runner”展开。事件语义、ephemeral 支持、force 行为和 offline 清理共同构成生命周期闭环，拆开会让读者看不到完整模型 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| Runner 清理与升级验证 | 为什么升级后会堆 offline runner，怎样确认 runner 镜像和清理逻辑真的有效？ | `act_runner` 版本、`--ephemeral` 支持、注销失败、HTTP status 缺失、旧 API path、token 权限 | 这是主文的验证和边界章节。它不能替代“按 job 调度”的主知识点，也不应单独变成升级排障文 | 4 | 4 | 4 | 4 | 4 | 4 | 24 | 作为章节 |

## 推荐文章

建议写 1 篇：

1. 《一次性 Runner 怎么跑：Gitea Actions 的 Job 调度模型》
   主知识簇：Gitea Actions 按 job 事件拉起一次性 runner
   推荐理由：材料的核心不是升级故障，而是一个通用调度原则：弹性执行环境要跟“具体待执行 job”绑定，而不是跟“代码发生变化”绑定。文章可以帮助读者建立 Gitea Actions runner 的事件语义、扩容动作和生命周期闭环。

   知识簇结构：
   - 必讲机制：push 事件只表示代码变化；一个 workflow 可能产生多个 job；`workflow_job queued` 才是 runner 需求信号；queued job 到来时要 `force=true` 拉 runner；ephemeral runner 跑完一个 job 就退出；runner 二进制必须支持 `--ephemeral`。
   - 可选补充：push fallback 可以用于预热但不能决定容量；offline runner 清理要记录 HTTP status；旧 API path 和 token 权限是排查方向。
   - 项目案例：旧逻辑看到已有 runner running 就 skip，导致并发 job 饿死；新逻辑按 `workflow_job queued` 强制拉起 runner。
   - 删除内容：把文章命名为升级踩坑；大篇幅复述聊天过程；展开未确认的注销 API 细节。

   文章骨架：
   1. 先讲清楚误区：push 来了不等于只有一个 job，也不等于 runner 数量足够。
   2. 最小模型：`workflow_job queued -> force=true RunTask -> register --ephemeral -> run one job -> exit`。
   3. 核心机制一：事件语义决定扩容信号，`workflow_job queued` 比 push 更接近真实资源需求。
   4. 核心机制二：为什么对 `workflow_job` 不能因为已有 runner running 就 skip。
   5. 核心机制三：ephemeral 是 runner 能力，必须验证镜像里的 `act_runner` 版本。
   6. 项目案例：从 push fallback 迁移到 job 级调度后，如何避免并发 job 饿死。
   7. 清理与验证：offline runner 注销失败要看 HTTP status、API path、token 权限，并验证 runner 列表不再堆积。
   8. 明确建议：弹性 runner 默认监听 `workflow_job queued` 并按 job 强制拉起；push/create 只做 fallback 或预热。
   9. 常见误区和边界：不要用 push 估算 job 数；不要以为 server 升级会更新 runner；不要静默处理注销失败。

## 不推荐单独成文的内容

- `push 来了就拉 runner`：这是主文开头的误区，不是独立主题。
- `server 升级不会自动更新 act_runner`：很重要，但属于 ephemeral 能力验证章节。
- `offline runner 一堆怎么来`：适合作为生命周期清理和可观测性章节。
- `注销 API path 和 token 权限`：材料只有排查方向，证据不足以独立成文。

请确认是否按推荐文章写。
