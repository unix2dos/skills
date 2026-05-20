## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 按 `workflow_job queued` 调度 Gitea Actions 弹性 runner | Gitea Actions 要把 runner 做成一次性弹性任务时，应该监听什么事件，怎样让 runner 生命周期和 job 需求一一闭合？ | `push/create` 旧触发、`workflow_job queued` 新触发、ECS RunTask、`act_runner register --ephemeral`、一个 job 一个 runner、`force RunTask`、push fallback 或预热、并发 job 饿死风险、runner 版本匹配、webhook UI 事件勾选、离线 runner 清理、验证信号 | 所有坑都指向同一个上位问题：弹性 runner 的调度信号必须来自 job 级事件，而不是代码变更事件。ephemeral、force、清理和验证都是这个生命周期闭环的必讲机制 | 5 | 5 | 5 | 5 | 5 | 5 | 30 | 推荐成文 |
| Gitea 升级后的兼容性排障 | 升级 Gitea 后，为什么功能看似可用但 runner 相关能力没有生效？ | server 升级但 `act_runner` 镜像未升级、`unknown flag: --ephemeral`、webhook 新事件未勾选、注销 API path 变化、HTTP status 未打印 | 这些是主知识簇的反例和验证材料。单独写会变成升级流水账，不能独立回答弹性 runner 的核心模型 | 4 | 4 | 4 | 5 | 4 | 4 | 25 | 作为章节 |

## 推荐文章

建议写 1 篇：

1. 《按 Job 调度 Runner：Gitea Actions 的弹性模型》
   主知识簇：按 `workflow_job queued` 调度 Gitea Actions 弹性 runner
   推荐理由：材料能提炼出一个清晰的可迁移模型：弹性 runner 不应该按代码事件扩缩容，而应该按 job 队列事件创建一次性执行环境。这个模型能解释为什么 push fallback 会饿死并发 job，也能串起 ephemeral runner 的注册、执行、退出、清理和验证。

   知识簇结构：
   - 必讲机制：`push/create` 只能说明代码变化；`workflow_job queued` 才表示具体 job 等 runner；一个 queued job 应触发一次 `force RunTask`；`act_runner register --ephemeral` 跑一个 job 后退出；旧 push fallback 不能决定 runner 数量；并发 job 下 skip existing runner 会导致饿死。
   - 可选补充：Gitea UI 里 webhook 事件名称可能是“工作流任务”；runner 日志应打印版本；离线 runner 清理要记录 HTTP status；注销 API path 和 token 权限需要验证。
   - 项目案例：`workflow_job queued -> force RunTask -> runner register --ephemeral -> run one job -> exit`，以及 ECS task 数与 queued job 数匹配的验证方式。
   - 删除内容：升级半天踩坑的时间线；旧 runner 起 30 分钟的全部历史细节；未验证的 API path 猜测。

   文章骨架：
   1. 先定义问题：弹性 runner 的关键不是“什么时候有代码变化”，而是“什么时候有 job 在等执行环境”。
   2. 最小模型：用一条流程描述 `workflow_job queued` 到 ephemeral runner 退出的生命周期。
   3. 核心机制一：`push/create` 和 `workflow_job queued` 的事件语义差异。
   4. 核心机制二：为什么 job 级事件必须强制拉起 runner，不能因为已有 runner running 就 skip。
   5. 核心机制三：ephemeral runner 是 runner 二进制能力，server 升级不等于镜像里的 `act_runner` 自动升级。
   6. 项目案例：ECS RunTask 如何和 queued job 对齐，push/create 只保留 fallback 或预热。
   7. 清理与验证：offline runner 清理要暴露状态码，并用 webhook delivery、ECS task 数、runner 版本日志、runner 列表验证闭环。
   8. 明确建议：按 `workflow_job queued` 创建一次性 runner；只有 fallback 或预热场景才用 push/create。
   9. 常见误区和边界：不要用代码事件估算 job 数；不要跳过 runner 版本验证；不要静默吞掉注销失败。

## 不推荐单独成文的内容

- `升级 Gitea 之后的半天踩坑`：时间线不适合作为主线，应改成事件语义和生命周期模型。
- `unknown flag: --ephemeral`：这是 runner 版本验证的反例，放在核心机制或常见误区里。
- `webhook UI 新事件没勾选`：是事件接入检查项，放在项目案例或验证章节。
- `两百多个 offline runner`：是清理和可观测性问题，作为生命周期闭环的边界补充即可。

请确认是否按推荐文章写。
