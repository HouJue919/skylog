# Sprint 4 学习总结：统计、设备和备份

Sprint 4 的目标是让 SkyLog 从“能记录数据”进入“能理解和保护数据”。这一阶段对应原初技术方案里的统计、设备和备份。

## 完成内容

- Profile 真实统计：总飞行次数、总飞行时长、有坐标记录、有素材记录
- Primary Drone：根据真实记录计算最常用无人机
- My Drones：从简单次数升级为设备档案摘要
- JSON Backup：适合完整备份和未来迁移
- CSV Export：适合放进 Excel、Numbers 或 Google Sheets 分析
- Backup Report：解释导出包含什么，以及本地浏览器数据的风险

## 学到的核心知识

### 1. 数据可以被二次利用

一开始的 flight record 只是列表里的卡片。到了 Sprint 4，同一份数据被用于 Dashboard、Logs、Map、Profile、Drone profile、JSON 导出和 CSV 导出。

这就是软件里的一个重要概念：数据模型设计得越清楚，后面能复用的地方越多。

### 2. 统计不是写死文字

Profile 的数字来自真实记录，而不是手写展示内容。这样用户新增、编辑、删除记录后，统计会自动变化。

这对应编程里的 list 遍历、条件筛选、累加计算、map/count 汇总，以及 UI 根据 state 自动更新。

### 3. 备份是一种信任感

本地优先 app 的好处是简单、隐私压力小、不需要账号。缺点是：如果用户清浏览器数据或换设备，记录可能丢失。

所以 v3.2 的 Backup Report 很重要。它不是更炫的功能，但它让用户知道数据现在在哪里、JSON 和 CSV 分别有什么用、什么时候需要导出，以及当前版本还没有云同步。

### 4. 设备管理可以逐步做

原初 PRD 写了 DroneProfile，但我们没有一开始就做复杂的“新增/编辑/删除设备档案”。我们先从飞行记录自动生成设备摘要。

这是更稳的路线：先用已有数据产生价值，再观察用户是否真的需要单独管理设备，最后再决定是否做独立设备页面。

### 5. 测试保护长期项目

Sprint 4 增加功能时，每一步都加了 widget test。测试的作用不是为了“好看”，而是防止后面继续开发时把旧功能弄坏。

## 对申请大学有什么帮助

Sprint 4 展示了几个很有价值的能力：

- 你不是只做 UI，而是在做真实数据产品
- 你能按照路线图迭代，而不是一次性乱加功能
- 你考虑了隐私、本地存储、导出、测试和用户信任
- 你保留了清晰的 commit history，能证明项目是长期做出来的

如果以后写申请材料，可以把 Sprint 4 描述成：

> I improved SkyLog from a basic logging app into a local-first data tool with statistics, device summaries, backup exports, and clear data-safety guidance.

## 下一步

Sprint 5 可以开始 AI 和数据增强，但要保持一个原则：

AI 只能辅助用户写总结草稿，不能破坏已有的本地记录、搜索、导出和备份功能。
