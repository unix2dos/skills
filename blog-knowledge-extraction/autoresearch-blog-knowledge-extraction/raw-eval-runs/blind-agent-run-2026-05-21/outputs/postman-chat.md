## 上位知识簇评估

| 上位知识簇 | 共同回答的读者问题 | 包含内容 | 为什么合并 | 可迁移性 | 认知增量 | 技术深度 | 材料证据 | 成文完整度 | 学习必要性 | 总分 | 建议 |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| 用 OpenAPI 管住 Postman 调试资产 | 为什么 Postman collection 不适合手工维护，应该怎样让它从 OpenAPI 自动派生并保持可 review？ | 代码、OpenAPI、Postman 三份漂移；Postman 作为派生物；OpenAPI security 到 Bearer Auth 的继承；登录接口 After response 保存 token；删除随机 id 和 examples；本地生成与 `postman workspace push` 分离；生成物和可 review 源的边界 | 聊天中的问题虽然分别提到手工维护、登录 token、sync target 和 Native Git 目录，但都围绕同一条主线：调试资产只能有一个源头。后处理、同步边界和 review 边界都是为了让 Postman 不变成第二个事实源 | 5 | 5 | 4 | 4 | 5 | 5 | 28 | 推荐成文 |

## 推荐文章

建议写 1 篇：

1. 《让 Postman 回到生成物：用 OpenAPI 管住调试资产》
   主知识簇：用 OpenAPI 管住 Postman 调试资产
   推荐理由：这组材料最有价值的地方，是把“手工维护 Postman 很快”这个直觉反转成工程判断：快是短期的，长期会制造漂移。文章应讲清楚怎样用 OpenAPI 做单一源头，把 Postman 定制沉淀到后处理脚本，把云端同步作为显式副作用处理。

   知识簇结构：
   - 必讲机制：单一源头；Postman collection 作为派生物；postprocess 承载定制规则；生成物与可 review 源文件的边界；云端同步的副作用边界。
   - 可选补充：Native Git 目录是否提交；删除随机 id 和 examples 的 review 价值；After response 保存 token 的具体用途。
   - 项目案例：从 OpenAPI security 继承 Bearer；登录接口添加 After response；`make postman-sync` 不并入 `openapi` target。
   - 删除内容：Postman UI 手工配置流程；完整接口测试教程；Native Git 目录的逐项文件说明。

   文章骨架：
   1. 先提出问题：为什么“手工改 Postman 很快”会在接口变更后变成漂移风险。
   2. 建立最小模型：事实源只保留 OpenAPI，Postman collection 从它生成。
   3. 解释定制规则放哪里：登录 token、Bearer Auth、随机 id 和 examples 都进入 postprocess。
   4. 解释 review 边界：review OpenAPI、转换配置、后处理脚本和测试，不把生成物当业务变更审。
   5. 解释同步边界：`postman workspace push` 有账号、网络和 workspace 副作用，必须显式执行。
   6. 给出落地建议：把生成、后处理、同步拆成独立命令，并用测试守住生成链路。

## 不推荐单独成文的内容

- `Postman 登录后保存 token`：它只是后处理脚本的一个示例，单独写会偏向工具技巧，应该放进“项目定制规则代码化”章节。
- `Native Git 目录是否提交`：它回答的是生成物 review 边界，适合作为一段原则说明，不需要独立成文。
- `make postman-sync 是否并入 openapi target`：它是副作用隔离的具体案例，应放在“本地生成和云端同步分离”章节。

请确认是否按推荐文章写。
