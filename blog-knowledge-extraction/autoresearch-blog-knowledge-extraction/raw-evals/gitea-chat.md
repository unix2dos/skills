# Synthetic Raw Eval: gitea-chat

Source blog: `升级 Gitea 之后的半天踩坑`
Style: 聊天记录

## 原始材料

> A：我以为 push 来了就拉 runner，不就行了吗？

> B：不够。push 只能说明代码变了，不说明有几个 job queued。一个 workflow 可能有 3 个 job。

> A：那应该看什么？

> B：`workflow_job` 的 `queued`。它表示具体 job 在等 runner。弹性 runner 应该按这个信号拉。

> A：但我们之前看到已有 runner running 就 skip，这不是省钱吗？

> B：对 push fallback 可以，对 workflow_job 不行。workflow_job 来了就是一个明确需求，必须 `force=true` 拉 runner，否则并发 job 没 runner。

> A：ephemeral 是 Gitea 的功能还是 runner 的功能？

> B：runner 二进制要支持 `--ephemeral`。server 升级不会让镜像里的 act_runner 自动变新。

> A：offline runner 一堆怎么来的？

> B：注销失败了，但日志没 status。旧 API path 可能不对，token 权限也要查。

> A：那文章怎么写？

> B：不要叫升级踩坑。讲按 job 调度 runner：事件语义、生命周期、清理和验证。
