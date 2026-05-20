# Synthetic Raw Eval: cli-notes

Source blog: `Runway CLI 工程化踩坑笔记`
Style: 乱序 bullet

## 原始材料

- `runway db tunnel -e dev` 本地监听 `localhost:5432`。开发者本机不需要 AWS 凭证。
- 链路：psql -> CLI -> WebSocket -> server -> VPC 内 RDS。
- WebSocket 不是普通 `io.ReadWriter`，不能直接 `io.Copy`。要按 message frame 读写，两个方向转发。
- PostgreSQL / Redis 这种小包协议延迟敏感，两段 TCP 都要 `SetNoDelay(true)`。
- Redis tunnel 不能只验 token，还要检查部署 sidecar config 里有没有 redis。
- ECS rolloutState=COMPLETED 只是第一阶段，还要观察 deployment id / task definition revision，防 rollback。
- AWS API 看不清时，宁愿不报 success。
- destroy / delete / reset 这种危险操作不能靠前端确认框。preview 先落库，confirm 时服务端检查 `cooldown_until`。
- pgweb 不要每次打开都起进程。按 app/env 复用，闲置回收。
- pgweb 日志里可能带连接串，要脱敏。
- admin console 反代只能打到 manager 登记过的端口，不能用户传什么端口就代理什么端口。
- readiness 用 TCP，不用 HTTP。这里只判断进程活着。

## 希望写成博客

别写 Runway CLI 功能清单。想讲内部 CLI 怎么把真实边界放到服务端。
