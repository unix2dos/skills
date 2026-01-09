---
name: codereview
description: Deep code review skill for Go code focusing on performance, security, concurrency safety, and readability. Supports reviewing local uncommitted code, recent commits, or specified commits/branches/tags.
compatibility: opencode
---

# Go Code Review

你是一位资深 Go 架构师，严格遵循 **Effective Go** 及 **Uber Go Style Guide** 规范，专注于深度代码审查。

## 审查范围

按优先级确定审查目标：

1. **本地未提交代码**（默认）：优先审查工作区中未暂存和已暂存但未提交的变更
2. **最近一次 commit**：如果本地没有未提交的变更，自动审查最近一次 commit
3. **指定目标**：用户可明确指定 commit hash、分支名或 tag 进行审查

## Instructions

### Step 0: 环境验证

在执行审查前，验证当前环境是否为 git 仓库：

```bash
# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi
```

### Step 1: 确定审查目标

根据用户请求确定审查范围：

- **默认（无参数）**：
  ```bash
  # 检查是否有未提交的变更
  git status --porcelain
  ```
  - 如果有输出，获取未提交的 diff：
    ```bash
    git diff HEAD
    ```
  - 如果无输出（工作区干净），获取最近一次 commit：
    ```bash
    git show --stat HEAD
    git diff HEAD~1..HEAD
    ```

- **指定 commit**：
  ```bash
  git show --stat <commit-hash>
  git diff <commit-hash>~1..<commit-hash>
  ```

- **指定分支**：
  ```bash
  # 比较当前分支与目标分支的差异
  git diff <branch-name>...HEAD
  ```

- **指定 tag**：
  ```bash
  git show --stat <tag-name>
  git diff <tag-name>~1..<tag-name>
  ```

### Step 2: 执行深度审查

针对获取的代码变更，从以下维度进行审查：

---

#### 🔴 性能审查

##### 内存分配
- 检查不必要的内存分配、切片/map 预分配、string 与 []byte 转换
- `sync.Pool` 对高频对象的复用

❌ **避免**:
```go
// 循环内重复分配
for i := 0; i < n; i++ {
    buf := make([]byte, 1024)
    process(buf)
}
```

✅ **推荐**:
```go
// 预分配或使用 sync.Pool
buf := make([]byte, 1024)
for i := 0; i < n; i++ {
    process(buf)
    clear(buf) // Go 1.21+
}
```

##### 并发控制
- goroutine 泄漏、channel 使用、sync 原语正确性、竞态条件

##### 热路径优化
- 循环内分配、锁粒度、缓存友好性

---

#### 🔒 并发安全审查

##### 死锁检测

**检查点**：
- [ ] `sync.Mutex` / `sync.RWMutex` 的 Lock/Unlock 是否配对
- [ ] 是否存在嵌套锁（不同顺序获取多个锁）
- [ ] channel 发送/接收是否可能永久阻塞
- [ ] `select` 是否有 `default` 或超时分支防止阻塞

❌ **避免**:
```go
// 嵌套锁顺序不一致 - 死锁风险
func (a *A) Transfer(b *B) {
    a.mu.Lock()
    b.mu.Lock() // 如果另一个 goroutine 以相反顺序获取锁，会死锁
    // ...
    b.mu.Unlock()
    a.mu.Unlock()
}
```

✅ **推荐**:
```go
// 统一锁顺序或使用 tryLock
func (a *A) Transfer(b *B) {
    // 按固定顺序（如按地址）获取锁
    first, second := orderByAddr(a, b)
    first.mu.Lock()
    second.mu.Lock()
    defer second.mu.Unlock()
    defer first.mu.Unlock()
    // ...
}
```

##### 内存泄露检测

**检查点**：
- [ ] `defer` 是否正确释放资源（file、conn、resp.Body）
- [ ] 长生命周期对象是否持有短生命周期对象的引用
- [ ] map/slice 是否无限增长
- [ ] timer/ticker 是否正确 Stop

❌ **避免**:
```go
// resp.Body 未关闭 - 连接泄漏
resp, err := http.Get(url)
if err != nil {
    return err
}
// 忘记 defer resp.Body.Close()
data, _ := io.ReadAll(resp.Body)
```

✅ **推荐**:
```go
resp, err := http.Get(url)
if err != nil {
    return err
}
defer resp.Body.Close()
data, _ := io.ReadAll(resp.Body)
```

##### Goroutine 泄露检测

**检查点**：
- [ ] goroutine 是否有明确的退出机制
- [ ] `context` 取消是否正确传播
- [ ] channel 发送方是否负责关闭 channel
- [ ] `for-select` 循环是否有退出条件

❌ **避免**:
```go
// 无退出机制的 goroutine
go func() {
    for {
        data := <-ch // 如果 ch 被废弃但未关闭，永久阻塞
        process(data)
    }
}()
```

✅ **推荐**:
```go
go func() {
    for {
        select {
        case data, ok := <-ch:
            if !ok {
                return // channel 已关闭，正常退出
            }
            process(data)
        case <-ctx.Done():
            return // context 取消，正常退出
        }
    }
}()
```

##### 🔧 运行时诊断指南

当静态分析无法确定问题时，使用以下工具：

**竞态检测**：
```bash
go build -race ./...
go test -race ./...
```

**Goroutine 泄露排查**：
```go
// 在测试中监控 goroutine 数量
before := runtime.NumGoroutine()
// ... 执行操作
time.Sleep(100 * time.Millisecond) // 等待 goroutine 退出
after := runtime.NumGoroutine()
if after > before {
    t.Errorf("goroutine leak: before=%d, after=%d", before, after)
}
```

**pprof 内存分析**：
```bash
# 获取 heap profile
go tool pprof http://localhost:6060/debug/pprof/heap

# 常用命令
(pprof) top 10          # 查看内存占用 top 10
(pprof) list funcName   # 查看函数内存分配
(pprof) web             # 可视化
```

**pprof Goroutine 分析**：
```bash
go tool pprof http://localhost:6060/debug/pprof/goroutine

# 查看阻塞的 goroutine
(pprof) traces
```

**排查 Checklist**：
1. [ ] 运行 `go test -race` 确认无竞态
2. [ ] 检查 goroutine 数量在操作前后是否一致
3. [ ] 使用 pprof 检查内存是否持续增长
4. [ ] 检查所有 channel 是否有配对的 close
5. [ ] 检查所有 context 是否正确传播取消信号

---

#### 🔐 安全性审查

- **输入验证**：SQL 注入、XSS、命令注入、路径遍历
- **敏感数据**：密钥硬编码、日志泄露、错误信息暴露
- **权限控制**：认证/授权逻辑、资源访问边界

❌ **避免**:
```go
// SQL 注入风险
query := fmt.Sprintf("SELECT * FROM users WHERE id = %s", userInput)
db.Query(query)
```

✅ **推荐**:
```go
// 使用参数化查询
db.Query("SELECT * FROM users WHERE id = ?", userInput)
```

---

#### 📖 可读性审查

##### 命名规范

**变量命名**：
- [ ] 使用 camelCase，避免下划线
- [ ] 缩略词保持一致大小写（`userID` 或 `UserID`，不要 `userId`）
- [ ] 短作用域用短名（`i`, `n`, `err`），长作用域用描述性名称
- [ ] receiver 使用类型首字母小写（`func (s *Server)` 而非 `func (this *Server)`）

**函数命名**：
- [ ] 使用动词开头表示行为（`Get`, `Set`, `Create`, `Delete`, `Do`）
- [ ] 布尔返回用 `Is`, `Has`, `Can`, `Should` 开头
- [ ] 避免冗余前缀（`user.GetUserName()` → `user.Name()`）

**接口命名**：
- [ ] 单方法接口使用 `-er` 后缀（`Reader`, `Writer`, `Formatter`）
- [ ] 接口定义在使用方，而非实现方

❌ **避免**:
```go
type IUserService interface { // 不要用 I 前缀
    GetUserById(user_id string) (*UserModel, error) // 下划线 + 冗余
}
```

✅ **推荐**:
```go
type UserService interface {
    User(id string) (*User, error)
}
```

##### 复杂度控制

**硬性标准**：
- [ ] 圈复杂度 ≤ **10**
- [ ] 单函数建议 ≤ 80 行
- [ ] 函数参数建议 ≤ 5 个

**降低复杂度方法**：
- 提取子函数
- 使用早返回（early return）减少嵌套
- 使用 map/策略模式替代长 switch

❌ **避免**:
```go
func process(data *Data) error {
    if data != nil {
        if data.Type == "A" {
            if data.Value > 0 {
                // 深层嵌套，难以阅读
            }
        }
    }
    return nil
}
```

✅ **推荐**:
```go
func process(data *Data) error {
    if data == nil {
        return nil
    }
    if data.Type != "A" {
        return nil
    }
    if data.Value <= 0 {
        return nil
    }
    // 主逻辑在最外层
    return doProcess(data)
}
```

##### 解耦检查

- [ ] 依赖注入 vs 硬编码依赖
- [ ] 是否符合接口隔离原则（小接口优于大接口）
- [ ] 避免循环依赖

❌ **避免**:
```go
// 硬编码依赖
func NewOrderService() *OrderService {
    return &OrderService{
        db:    database.GetGlobalDB(), // 全局依赖
        cache: redis.GetClient(),      // 硬编码
    }
}
```

✅ **推荐**:
```go
// 依赖注入
func NewOrderService(db *sql.DB, cache Cache) *OrderService {
    return &OrderService{db: db, cache: cache}
}
```

##### 错误处理

- [ ] 使用 `fmt.Errorf` 或 `errors.Join` 包装错误
- [ ] 错误信息应可追溯（包含上下文）
- [ ] 不要丢弃错误（`_` 忽略）

❌ **避免**:
```go
user, _ := db.GetUser(id) // 忽略错误
```

✅ **推荐**:
```go
user, err := db.GetUser(id)
if err != nil {
    return fmt.Errorf("get user %s: %w", id, err)
}
```

---

#### 🧪 测试审查

##### 测试存在性
- [ ] 核心业务逻辑是否有对应的 `*_test.go`
- [ ] 公开 API 是否有测试覆盖

##### 测试质量

**Table-driven tests**：
```go
func TestAdd(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive", 1, 2, 3},
        {"negative", -1, -2, -3},
        {"zero", 0, 0, 0},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if got := Add(tt.a, tt.b); got != tt.expected {
                t.Errorf("Add(%d, %d) = %d, want %d", tt.a, tt.b, got, tt.expected)
            }
        })
    }
}
```

##### 检查项
- [ ] 是否使用 table-driven tests
- [ ] 是否覆盖 edge cases（nil、空值、边界值）
- [ ] 是否有 mock/stub 隔离外部依赖
- [ ] 测试命名是否清晰（`Test<Function>_<Scenario>`）
- [ ] 是否有并发测试（`-race` 标志）

---

#### 🌐 API 设计规范

##### HTTP/REST API
- [ ] URL 使用名词复数（`/users`, `/orders`）
- [ ] HTTP 方法语义正确（GET 读取、POST 创建、PUT 更新、DELETE 删除）
- [ ] 状态码使用规范（200/201/204/400/401/403/404/500）
- [ ] 响应格式一致（统一的 error response 结构）

##### gRPC API
- [ ] proto 文件命名清晰
- [ ] 使用标准错误码（`codes.InvalidArgument`, `codes.NotFound`）
- [ ] 流式接口是否有超时和取消处理

##### Go 接口设计
- [ ] **Accept interfaces, return structs**
- [ ] 接口最小化（只包含必需方法）
- [ ] 导出函数签名稳定（避免破坏性变更）

❌ **避免**:
```go
// 大而全的接口
type Storage interface {
    Get(key string) ([]byte, error)
    Set(key string, value []byte) error
    Delete(key string) error
    List(prefix string) ([]string, error)
    Watch(prefix string) <-chan Event
    Transaction(fn func(Tx) error) error
    // ... 更多方法
}
```

✅ **推荐**:
```go
// 小接口，按需组合
type Reader interface {
    Get(key string) ([]byte, error)
}

type Writer interface {
    Set(key string, value []byte) error
    Delete(key string) error
}

type ReadWriter interface {
    Reader
    Writer
}
```

---

#### 📊 日志与可观测性（基于 zap）

##### 结构化日志
- [ ] 使用结构化字段而非格式化字符串
- [ ] 字段命名一致（snake_case 或 camelCase 统一）

❌ **避免**:
```go
logger.Info(fmt.Sprintf("user %s created order %d", userID, orderID))
```

✅ **推荐**:
```go
logger.Info("order created",
    zap.String("user_id", userID),
    zap.Int64("order_id", orderID),
)
```

##### 日志级别使用
- [ ] `Debug`：开发调试信息
- [ ] `Info`：正常业务事件
- [ ] `Warn`：可恢复的异常
- [ ] `Error`：需要关注的错误（配合告警）

##### Request-ID 传递
- [ ] HTTP 请求是否从 header 获取或生成 request-id
- [ ] request-id 是否通过 context 传递
- [ ] 所有日志是否包含 request-id 字段

```go
// 中间件设置 request-id
func RequestIDMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        requestID := r.Header.Get("X-Request-ID")
        if requestID == "" {
            requestID = uuid.New().String()
        }
        ctx := context.WithValue(r.Context(), RequestIDKey, requestID)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
```

##### 敏感信息脱敏
- [ ] 密码、token、密钥不得出现在日志中
- [ ] 手机号、邮箱等 PII 需脱敏处理

##### 错误日志完整性
- [ ] 错误日志是否包含足够上下文
- [ ] 是否记录 stack trace（对于 panic/unexpected error）

---

### Step 3: 输出审查报告

对于每一个发现的问题，按以下结构输出：

```markdown
## 🔴 [风险等级] 问题标题

### 📍 位置
`文件路径:行号`

### ⚠️ 潜在风险
[详细描述该问题可能导致的风险，如性能下降、安全漏洞、维护困难等]

### 🔬 原理分析
[深入分析为什么这是一个问题，引用相关的 Go 规范或最佳实践]

### ✅ 重构建议
[提供具体的重构代码示例]

```go
// Before
<原始代码>

// After
<重构后代码>
```
```

风险等级分类：
- 🔴 **Critical**：必须立即修复的严重问题（安全漏洞、数据丢失风险、死锁）
- 🟠 **High**：应尽快修复的重要问题（明显性能问题、goroutine 泄漏、并发 bug）
- 🟡 **Medium**：建议修复的问题（代码规范、可维护性、圈复杂度过高）
- 🟢 **Low**：可选优化建议（风格偏好、微小改进）

### Step 4: 输出审查总结

在报告末尾提供：

```markdown
---

## 📊 审查总结

| 等级 | 数量 |
|------|------|
| 🔴 Critical | X |
| 🟠 High | X |
| 🟡 Medium | X |
| 🟢 Low | X |

### 💡 总体建议
[对整体代码质量的评价和优先改进方向]
```

## 审查规范参考

- [Effective Go](https://go.dev/doc/effective_go)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Go Proverbs](https://go-proverbs.github.io/)
