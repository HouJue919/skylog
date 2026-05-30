# Sprint 5 计划：AI 和数据增强

Sprint 5 的目标不是“为了 AI 而 AI”，而是让 SkyLog 在不破坏本地优先基础功能的前提下，尝试用 AI 帮用户更快完成飞行复盘。

## 原初技术方案里的 Sprint 5

- Cloudflare Worker AI 网关
- Prompt 模板
- 生成总结草稿
- 限流和成本控制
- 厂商日志导入原型

## 重要原则

### 1. 不在 App 里直接放 API Key

如果以后接 OpenAI 或其他 AI 服务，不能把 API key 写进 Flutter 前端代码。网页和 App 前端代码会被别人看到，key 放进去就等于公开。

正确方向是：Flutter App 发送请求到自己的后端代理，后端代理保存 API key，后端代理再请求 AI 服务。

原初方案里写的 Cloudflare Worker，就是这个思路。

### 2. AI 不能成为核心链路

SkyLog 必须在没有网络、没有 AI、AI 服务失败时仍然可用：

- 新增飞行记录
- 查看历史记录
- 编辑记录
- 搜索记录
- 地图足迹
- JSON / CSV 导出

AI 只能是辅助增强。

### 3. AI 输出必须可编辑

AI 生成的内容不能直接当成最终记录。它应该是一个 draft，用户可以改完再保存。

推荐功能名称：

- Generate Draft Summary
- Improve Review Notes
- Suggest Next Improvements

## 最小可行版本

### v3.3：AI Readiness，不接真实 AI

先在 App 里做一个本地的 AI Readiness / Prompt Preview：

- 从现有 flight record 自动整理 prompt 输入
- 显示会发送给 AI 的字段
- 解释哪些字段不会发送
- 不接网络，不调用 AI

目的：先把数据边界和 prompt 结构想清楚。

状态：已完成。

### v3.4：语言设置

在进入更深的 AI 功能之前，先增加 English / 中文 语言切换雏形，方便中文 tester 使用，也让项目更适合大学申请展示。

状态：已完成。

### v3.5：本地假 AI 草稿

不接 API，先用本地规则生成一个简单 summary draft，例如根据地点、天气、目的、问题、改进字段组合一段草稿。

目的：验证“AI 总结草稿”这个工作流是否真的有用。

状态：已完成。

### v3.6：AI Gateway 设计文档

在真正接 AI 前，写清楚 Cloudflare Worker 输入、输出、错误处理、限流、成本控制，以及不保存敏感数据。

### v3.7：真实 AI 原型

只有当前面都稳定后，再接真实 AI 服务。

## Prompt 需要的输入

第一版 prompt 可以只用这些字段：

- title
- location
- date
- duration
- drone
- weather
- purpose
- summary
- issues
- improvements
- mediaCaption
- checklistLabel

先不要上传图片或视频文件。

## 风险

- API key 泄露
- 成本失控
- AI 输出不准确
- 用户误以为 AI 是安全建议
- 发送过多私人地点信息

## 解决策略

- 不直连 AI API
- 先做 prompt preview
- 只生成可编辑草稿
- 明确说明 AI 不是飞行安全系统
- 给用户选择是否生成
- 后续再考虑隐藏精确坐标

## 推荐下一版

下一版建议做：

**v3.6 AI Gateway 设计文档**

这一步继续不接真实 API，但会把未来 Cloudflare Worker、限流、错误处理和成本控制设计清楚。
