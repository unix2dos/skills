# Synthetic Raw Eval: cli-chat

Source blog: `Runway CLI 工程化踩坑笔记`
Style: 聊天记录

## 原始材料

> A：这些 CLI 功能看起来很散，db tunnel、部署等待、pgweb、危险操作确认，能写一篇吗？

> B：能，它们其实都在讲边界放哪里。

> A：db tunnel 的边界是什么？

> B：网络边界在 server。只有 server 在 VPC 里，本地 CLI 只是入口。

> A：冷静期呢？

> B：安全边界在服务端数据库里的 `cooldown_until`，不是前端倒计时，也不是 CLI prompt。

> A：ECS completed 为什么还等？

> B：成功边界不能只看第一状态。还要观察 revision 有没有 rollback；看不清就不要报成功。

> A：pgweb 反代呢？

> B：资源边界在 manager 登记的端口。不能反代任意 localhost，否则就是 SSRF 风险。日志还要脱敏。

> A：所以标题？

> B：别叫 CLI 踩坑。叫“把边界放到服务端”更准。
