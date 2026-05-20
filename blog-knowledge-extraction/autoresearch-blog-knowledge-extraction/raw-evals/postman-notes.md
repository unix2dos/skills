# Synthetic Raw Eval: postman-notes

Source blog: `用 OpenAPI 驱动 Postman Native Git`
Style: 代码阅读笔记

## 原始材料

- 痛点：代码里有路由，`docs/openapi.json` 一份，Postman collection 又一份。三份不同步。
- 决策：Postman 只能是生成物，不能当第二个接口源头。
- Make targets：
  ```make
  openapi:
    go run ./tool/openapi -root .
  postman-collection: openapi
    bash script/generate_postman_collection.sh
  postman-sync: postman-collection
    postman workspace push -y
  ```
- 关键边界：本地生成和云端同步分开。`postman workspace push` 有账号、网络和 workspace 副作用。
- 生成链路：
  ```text
  Gin routes -> docs/openapi.json -> openapi-to-postmanv2 -> postman collection migrate -> Native Git dir -> postprocess
  ```
- 后处理脚本做项目规则：Bearer Auth 统一继承；登录接口 After response 保存 token；删随机 id；删 examples。
- 本来有人想在 Postman UI 手工改，这会让规则不可 review。
- Local View 和 Cloud View 别混。生成目录本地可以看，云端同步必须显式。
- 测试脚本不是测接口，是测生成链路没断。

## 希望写成博客

主题不是 Postman 教程。应该讲接口调试资产怎么从 OpenAPI 单一源头派生。
