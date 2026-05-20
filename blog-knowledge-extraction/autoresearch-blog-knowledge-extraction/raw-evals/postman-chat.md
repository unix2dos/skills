# Synthetic Raw Eval: postman-chat

Source blog: `用 OpenAPI 驱动 Postman Native Git`
Style: 聊天记录

## 原始材料

> A：Postman collection 手工维护很快啊，为什么要自动生成？

> B：快是错觉。接口一改，代码、OpenAPI、Postman 三份就开始漂移。最后不知道谁是真的。

> A：那 Postman 里面登录后保存 token 这种定制怎么办？

> B：写进 postprocess。不要靠 UI 手工点。比如从 OpenAPI security 继承 Bearer，登录接口加 After response，删掉随机 id 和 examples。

> A：`make postman-sync` 能不能直接放进 openapi target？

> B：不行。sync 会推 Postman Cloud，有外部副作用。本地生成和云端同步要拆开。

> A：Native Git 目录提交吗？

> B：生成物不要拿来业务 review。真正要 review 的是 OpenAPI、转换配置、后处理脚本和测试。

> A：文章重点？

> B：不是 Postman 操作教程。讲“调试资产只能有一个源头，Postman 是派生物”。
