# Synthetic Raw Eval: terraform-notes

Source blog: `把 Terraform 当库用：Embedded IaC 的工程内幕`
Style: 代码阅读笔记

## 原始材料

- Runway 不是让业务仓库写 `.tf`。业务只写 `runway.yaml`。
- server 里有：
  ```go
  //go:embed all:modules
  var modulesFS embed.FS
  ```
- `all:` 不能省，Terraform module 里可能有点文件。
- Terraform CLI 看不到 embed.FS，所以 server 启动后解压到固定目录。
- 起初想 `os.MkdirTemp`，但随机目录会让 provider cache 失效，deploy 每次都重新下载 provider。
- HCL 不是 AST，也不是 CDK。用 `text/template` 拼普通 `.tf`。优点：出问题时能拿生成物接管。
- Terraform 仍是子进程：`terraform init/apply`，带 `-chdir`、`-input=false`、`-no-color`。
- 跨 stack 引用有两种：
  - 必须存在的 shared VPC：`terraform_remote_state`，缺失就让 Terraform 报。
  - 可选 DB：Go 先读 tfstate，存在才注入。
- 边界：没有 drift detection；没有 PR plan review；server 是部署入口；模块版本和 server 二进制绑定。
- 零散细节：ALB priority hash、ACM 自定义域名两次 deploy、`prevent_destroy` 必须字面量、Secret 立即删除有风险。

## 希望写成博客

不要写成 Terraform 小技巧列表。主题应该是平台如何把 Terraform 作为内部执行引擎。
