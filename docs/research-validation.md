# SkyLog 研究与验证

## 研究目的

SkyLog 的研究重点是验证一个具体场景：无人机用户在飞行结束后，是否需要一个独立工具来整理飞行信息、航拍素材和个人复盘。

项目从一次飞行后的真实行为切入。用户完成飞行后，会面对照片、视频、地点、天气、设备、电池、飞行问题和拍摄总结等多类信息。研究目标是判断这些信息是否值得被结构化记录，以及用户是否愿意持续使用这样的工具。

## 市场背景

2026 年的公开资料显示，无人机和消费级航拍仍在增长：

- Grand View Research 估算，全球无人机市场 2025 年约为 838.085 亿美元，预计 2033 年达到 1,824.496 亿美元，2026-2033 年 CAGR 为 9.5%。[1]
- Fortune Business Insights 的 2026 年消费级无人机报告估算，全球消费级无人机市场 2025 年约为 58.9 亿美元，预计 2034 年达到 156.5 亿美元，2026-2034 年 CAGR 为 11.6%。[2]
- 该报告指出，摄影/摄像是消费级无人机的重要应用场景，社交媒体需求、4K/8K 影像和中端价位设备推动普通用户使用无人机拍摄。[2]
- FAA 2025-2045 预测显示，美国娱乐无人机用户规模已经较大，但新增注册增速下降，娱乐小型无人机市场有趋于成熟的信号。[3]

这些资料说明，SkyLog 的用户基础更可能来自已经拥有设备、已经积累素材、需要整理和复盘的存量用户。

## 用户分层

### 新手飞手

关注练习过程、飞行安全和问题复盘。适合提供练习模板、飞行问题记录和安全注意事项。

### 旅行航拍用户

关注地点、路线、照片视频和旅行素材整理。适合提供地图足迹、素材关联和旅行项目记录。

### 进阶玩家

关注设备表现、电池、天气影响和飞行经验。适合提供设备统计、历史检索和飞行问题追踪。

### 内容创作者

关注镜头类型、片段用途、素材标签和作品整理。适合提供项目视图、镜头说明和作品集导出。

## 可触达半径

### 第一圈：身边真实用户

渠道包括学校科技社团、摄影社团、无人机兴趣小组、本地航拍玩家和旅行摄影用户。目标是访谈 20-50 人，收集 100 条左右真实飞行记录，观察字段填写率和复盘行为。

### 第二圈：线上垂直社区

渠道包括 DJI 用户社区、无人机论坛、Reddit 的 drones / DJI / videography 社区、小红书、Bilibili 和 YouTube 航拍内容区。适合发布原型、飞行复盘模板和样例记录。

### 第三圈：课程与创作者场景

渠道包括航拍教程账号、摄影课程、STEM 社团、无人机训练活动和旅行视频创作者。适合验证飞行报告、练习模板、地图足迹和作品集导出。

## 验证问题

用户访谈和原型测试需要重点回答以下问题：

- 用户飞行后如何整理素材？
- 厂商 App 的飞行记录是否已经满足日常需求？
- 用户最容易忘记哪些飞行信息？
- 哪些字段愿意手动填写，哪些字段需要自动获取？
- 地图足迹是否有持续回顾价值？
- 用户是否愿意导入 flight record 文件生成记录？
- AI 总结是否能提升复盘质量，并形成可编辑、可保存的内容？

## 验证指标

### 记录行为

- 首次记录完成率
- 平均记录完成时间
- 30 日内第二条记录比例
- 每条记录字段完整度

### 素材和地图

- 素材关联率
- 封面图添加率
- 地图点位使用率
- 历史记录搜索次数

### 数据增强

- flight record 导入意愿
- 导入后自动字段准确率
- AI 草稿触发率
- AI 草稿被编辑和保存的比例

## 样本目标

第一轮验证以真实记录样本为核心：

- 20-50 名无人机用户
- 100 条左右真实飞行记录
- 30 个以上飞行地点
- 3 种以上无人机型号
- 覆盖练习、旅行、城市风景、户外航拍等不同目的

## 竞品观察

- DJI Fly / DJI GO：飞行记录、同步、导出和售后日志能力
- DJI FlightHub 2：企业级飞行管理和行业场景
- AirData UAV：专业飞行日志和维护记录
- Aloft / B4UFLY：空域、合规和飞行前信息
- 手机相册和剪辑软件：素材管理与创作流程
- Notion / 备忘录：手动记录与模板化复盘

SkyLog 的差异化应落在“个人航拍复盘”上：比相册更结构化，比专业平台更轻量，比厂商 App 更关注飞行后的创作语义。

## Sources

[1] Grand View Research, Drone Market Size, Share & Growth, 2026-2033: https://www.grandviewresearch.com/industry-analysis/drone-market-report

[2] Fortune Business Insights, Consumer Drone Market Size, Share & Industry Analysis, updated April 27, 2026: https://www.fortunebusinessinsights.com/consumer-drone-market-115477

[3] FAA, Aerospace Forecast Fiscal Years 2025-2045 UAS and AAM Summary: https://www.faa.gov/data_research/aviation/aerospace_forecasts/2025-uas-and-aam-summary.pdf

[4] Digital Camera World, The best drones for beginners in 2026: https://www.digitalcameraworld.com/buying-guides/the-best-drones-for-beginners

[5] FAA, Recreational Flyers & Community-Based Organizations: https://www.faa.gov/uas/recreational_flyers

