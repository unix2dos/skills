# Rough Material Smoke Test

Purpose: verify `blog-knowledge-extraction` on note-like source material rather than a finished blog.

This is a proxy test assembled from the Runway CLI material because the repository does not currently contain a true raw troubleshooting note file.

## Input

```markdown
材料：

- runway db tunnel -e dev，本地听 localhost:5432。
- 本机不用 AWS 凭证，CLI 拿 token 连 server。
- server 在 VPC 里 dial RDS。
- 一开始以为 WebSocket 可以直接 io.Copy，后来不行。WS 是消息帧，TCP 是 stream，要按 frame 读写，两个方向 goroutine 转发。
- 小包协议很慢，PostgreSQL / Redis 都需要低延迟，两段 TCP 都 set no delay，只关本地连接不够。
- Redis tunnel 不能只看 token，还要检查部署 sidecar 配置里有没有 redis。
- ECS service deployment rolloutState=COMPLETED 后，之前直接报成功，但后来发现还可能 rollback。要继续看一段时间，看 task definition revision 有没有倒退。
- 如果 AWS API 抖动，看不清状态，宁愿不报 success。
- 危险操作：destroy / delete / reset。前端确认框不可靠，CLI 提示也不可靠。preview 先落库，保存 reason / before snapshot / cooldown_until，confirm 时服务端检查时间。
- pgweb 不要每次打开都启动一个。按 app/env 复用进程，闲置回收。
- pgweb 日志里可能有连接串，要脱敏。
- admin console 反代不能代理任意 localhost 端口，只能代理 manager 登记过的端口，避免 SSRF。
- readiness 用 TCP，不用 HTTP，因为 pgweb 有时 HTTP 还没好但 TCP 已经能连；这个只用来判断进程活着。

目标：想写成一篇技术博客，但不要变成 Runway CLI 功能清单。
```

## Stage One Output

## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 内部 CLI 的服务端边界设计 | 内部 CLI 如何把网络、安全、部署成功判断和工具进程管理放到可信服务端，而不是只在本地封装命令？ | DB tunnel、WebSocket 字节流转发、双端 TCP_NODELAY、Redis 授权、ECS 二阶段观察、危险操作 preview/confirm、pgweb 进程复用、日志脱敏、受控反代端口 | 这些点表面分散，但共同回答同一个更大的问题：CLI 只是入口，真正的网络边界、权限边界、成功边界和资源边界应该由服务端掌握。拆开会变成工具功能清单 | 5 | 5 | 5 | 4 | 5 | 5 | 29 | 推荐成文 |
| WebSocket 隧道转发机制 | 为什么数据库 tunnel 不能把 WebSocket 当普通 TCP stream 直接复制？ | WebSocket frame、TCP stream、双向 goroutine、关闭信号、TCP_NODELAY | 这是主知识簇的网络机制章节，不独立承载完整文章方向 | 5 | 5 | 4 | 4 | 4 | 4 | 26 | 作为章节 |
| 部署成功的二阶段判断 | 云厂商返回 rollout completed 后，部署工具为什么还要继续观察？ | rolloutState、task definition revision、rollback、AWS API 抖动、fail closed | 它是主知识簇的成功边界案例，服务于“边界放到服务端”的主线 | 5 | 5 | 4 | 4 | 4 | 4 | 26 | 作为章节 |
| pgweb 托管与受控反代 | 服务端如何复用外部工具进程，同时避免敏感日志和任意端口代理？ | pgweb manager、按 app/env 复用、闲置回收、日志脱敏、登记端口、TCP readiness | 它是主知识簇的资源边界案例，适合作为项目案例，不应单独拆篇 | 4 | 4 | 4 | 4 | 4 | 3 | 23 | 作为章节 |

## 推荐文章

建议写 1 篇：

1. 《把边界放到服务端：内部 CLI 的工程化设计》
   主知识簇：内部 CLI 的服务端边界设计
   推荐理由：这份材料最值得提炼的不是 DB tunnel、ECS wait 或 pgweb 某个单点功能，而是一个可迁移的内部工具设计原则：CLI 和前端只做入口，可信判断必须落在服务端状态、服务端网络、服务端权限和服务端资源登记上。

   知识簇结构：
   - 必讲机制：入口与可信边界分离；WebSocket 隧道的最小模型；服务端状态机保护危险操作；部署成功需要二阶段观察；受控进程和反代端口必须由服务端登记。
   - 可选补充：双端 `TCP_NODELAY`；AWS API 抖动时 fail closed；pgweb TCP readiness；端口竞态取舍。
   - 项目案例：Runway 的 DB tunnel、Redis tunnel、ECS 部署观察、preview/confirm、pgweb manager。
   - 删除内容：具体命令流水账；完整功能清单；逐行代码解释；单独展开 pgweb 使用方法。

   文章骨架：
   1. CLI 不是把命令包起来，而是把危险边界收进服务端。
   2. 最小模型：`本地入口 -> 服务端校验 -> 受控资源 -> 可观察结果`。
   3. 核心机制一：网络边界，DB tunnel 为什么由 server 进入 VPC。
   4. 核心机制二：协议边界，WebSocket frame 和 TCP stream 为什么不能混用。
   5. 核心机制三：成功边界，ECS completed 后为什么还要观察 rollback。
   6. 核心机制四：安全边界，冷静期和确认必须落在服务端状态机。
   7. 项目案例：pgweb 进程复用、日志脱敏和受控反代。
   8. 明确建议：内部 CLI 默认把权限、等待、确认、反代范围和进程生命周期放到服务端。
   9. 常见误区和边界：不要相信前端确认框；不要把 token 当完整授权；不要代理任意本地端口；不要把第一阶段完成当最终成功。

## 不推荐单独成文的内容

- `TCP_NODELAY 要两边都关`：这是隧道性能机制，适合放在网络章节。
- `WebSocket 不能直接 io.Copy`：认知增量高，但依赖隧道上下文，适合放进核心机制。
- `pgweb readiness 用 TCP`：局部工程取舍，放在项目案例。
- `Redis tunnel 授权`：可作为“token 不等于完整授权”的反例，不单独成文。

请确认是否按推荐文章写。
```
