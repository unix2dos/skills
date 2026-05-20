# Synthetic Raw Eval: gitea-incident-notes

Source blog: `升级 Gitea 之后的半天踩坑`
Style: 排障日志

## 原始材料

- 目标：Gitea 升级后把 runner 改成 ephemeral。旧方案是 runner 起 30 分钟，job 跑完也等着。
- 旧触发：`push/create` webhook -> Runway server -> ECS RunTask -> `act_runner daemon`。
- 预期：用 `act_runner register --ephemeral`，跑一个 job 就退出。
- 第一坑：Gitea server 升级了，但镜像里的 `act_runner` 没升级。日志里 `unknown flag: --ephemeral`。
- 第二坑：job queued，但 webhook handler 没收到 `workflow_job`。后来发现 UI 里新事件没勾选，名字像“工作流任务”。
- 第三坑：旧的 push fallback 还在。代码看到已有 runner running 就 skip，但 `workflow_job queued` 应该每个 job 都强制拉一个新的 runner，不然并发 job 会饿死。
- 现在模型：
  ```text
  workflow_job queued -> force RunTask -> runner register --ephemeral -> run one job -> exit
  ```
- `push/create` 只保留 fallback 或预热，不能决定有几个 job 在等 runner。
- 第四坑：两百多个 offline runner。注销 API path 变了，清理逻辑没打 HTTP status，失败静默。
- 验证：webhook delivery 有 `workflow_job queued`；ECS task 数和 queued job 匹配；runner 日志打印版本；Gitea runner 列表不再堆 offline。

## 希望写成博客

不要写升级流水账。核心应该是 Gitea Actions 弹性 runner 到底应该监听什么事件，以及 ephemeral runner 的生命周期怎么闭合。
