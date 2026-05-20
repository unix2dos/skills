## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 用 OpenAPI 派生接口调试资产 | 如何避免代码、OpenAPI、Postman collection 三份接口资产互相漂移，并让调试资产可 review、可重复生成？ | 单一源头原则；`make openapi`、`postman-collection`、`postman-sync` 分层；Gin routes -> OpenAPI -> Postman collection -> Native Git 目录 -> postprocess；Bearer Auth 继承、登录后保存 token、删除随机 id 和 examples；本地生成与云端同步边界；生成链路测试 | 这些内容都在回答同一个工程问题：Postman collection 不应成为第二个接口源头，而应从 OpenAPI 派生。Make target、后处理、Native Git、云端同步边界和测试都只是这个模型的落地机制，拆开会变成工具操作清单 | 5 | 5 | 4 | 5 | 5 | 5 | 29 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《用 OpenAPI 派生调试资产：让 Postman 只做生成物》
   主知识簇：用 OpenAPI 派生接口调试资产
   推荐理由：材料的核心不是 Postman 使用教程，而是接口调试资产的源头治理。文章可以把“代码、OpenAPI、Postman 三份漂移”这个常见问题，转成一个可复用的工程模型：代码或 OpenAPI 是事实源，Postman collection 是可重复生成的派生物，项目定制写进脚本和测试，而不是写进 UI 手工操作。

   知识簇结构：
   - 必讲机制：单一接口源头；生成链路分层；本地生成和云端同步分离；postprocess 承载项目规则；生成链路测试的职责。
   - 可选补充：Postman Native Git 目录的本地查看方式；Local View 和 Cloud View 的区别；删除随机 id 和 examples 对 review 的影响。
   - 项目案例：`make openapi`、`make postman-collection`、`make postman-sync` 三个 target；Gin routes 到 `docs/openapi.json` 再到 Postman Native Git 目录的链路；Bearer Auth 和登录 token 的后处理规则。
   - 删除内容：完整 Postman UI 操作教程；接口业务细节；把生成目录当业务 review 主体的讨论。

   文章骨架：
   1. 从“三份接口资产漂移”引出问题：为什么手工维护 Postman collection 会让事实源失控。
   2. 先建立最小模型：`routes -> openapi.json -> converter -> collection -> postprocess`。
   3. 解释 Make target 分层：生成 OpenAPI、生成 collection、同步云端分别承担什么职责。
   4. 解释 postprocess：把 Bearer Auth、登录保存 token、删除随机字段等项目规则写成可 review 的代码。
   5. 解释边界：本地生成可以自动化，`postman workspace push` 因为有账号、网络和 workspace 副作用必须显式触发。
   6. 说明测试重点：测试生成链路是否稳定，而不是测试接口本身。
   7. 给出建议：把 Postman 当派生调试资产，不要让它成为第二个接口源头。

## 不推荐单独成文的内容

- `Postman Native Git 本地目录怎么用`：它只是调试资产生成链路里的承载形式，适合作为项目案例或边界说明，不足以单独回答一个完整读者问题。
- `登录接口自动保存 token`：这是 postprocess 的一个规则示例，单独写会变成 Postman 脚本技巧，应放在“项目规则写进后处理脚本”章节。
- `Local View 和 Cloud View 区别`：这是云端同步边界的补充，不是主知识点，适合放进“本地生成和云端同步分离”章节。
- `生成链路测试`：它服务于“派生物可重复生成”这个主线，不应拆成独立测试文章。

请确认是否按推荐文章写。
