# 厂商飞行数据接入方案

## 定位

DJI Fly / DJI GO / DJI Pilot 等厂商 App 已经能记录飞行数据，并提供飞行记录查看、同步、日志上传和部分导出能力。SkyLog 的方向是将这些飞行数据与用户的素材、拍摄目的、地点记忆和复盘总结结合起来，形成更完整的个人飞行档案。

厂商 App 记录的是飞行和设备状态，SkyLog 管理的是飞行后的创作整理和长期回顾。

## DJI Fly 已有能力

基于公开资料，DJI Fly / DJI GO 相关能力包括：

- 查看飞行记录
- 同步飞行记录，部分地区和条件下
- 导出飞行记录和飞控数据
- 上传日志用于事故、维修或售后判断
- 记录飞行轨迹、时间、坐标、设备信息等遥测数据

第三方飞行日志解析资料显示，DJI Fly / DJI GO 本地会保存 `DJIFlightRecord` 类飞行记录；导出的文本记录通常包含机型、App 版本、飞行时间、GPS、姿态、速度、电池、飞行模式和事件等信息。[2]

## SkyLog 的补充价值

DJI 的飞行记录可以告诉用户：

- 飞了多久
- 飞到哪里
- 高度和速度
- 电池状态
- 飞行模式
- 是否触发返航或告警

SkyLog 补充的是：

- 这次飞行的创作目的
- 哪些照片和视频是可用素材
- 用户觉得哪个镜头最好
- 为什么选择这个地点
- 下次拍摄要如何改进
- 这次飞行属于哪个旅行项目或作品集

## 接入路线

### 阶段一：手动记录

第一版由用户手动输入地点、日期、时长、天气、设备和总结，可选保存经纬度，并选择封面和素材。

### 阶段二：文件导入

支持用户主动导入：

- DJI Fly / DJI GO 导出的 flight record `.txt`
- CSV
- KML / GPX，后续
- 第三方工具导出的飞行日志

导入后自动填充：

- 飞行日期
- 起飞点和降落点
- 飞行时长
- 最大高度
- 最大距离
- 飞行路径
- 电池变化
- 飞行模式和告警事件

### 阶段三：本地解析 DJIFlightRecord

最小解析流程：

```text
导入文件
  -> 识别机型和时间
  -> 解析 GPS 点
  -> 计算飞行时长和距离
  -> 生成地图轨迹
  -> 自动创建飞行记录草稿
```

用户继续补充：

- 飞行目的
- 天气
- 素材
- 拍摄说明
- 个人总结

### 阶段四：官方 API 或平台对接

DJI Developer 有 Flight Record Parsing interfaces 等 API 相关协议说明。[4] 官方 API 可以作为长期方向，MVP 阶段以手动记录和文件导入验证为主。

### 阶段五：企业平台研究

DJI FlightHub 2 是 DJI 的企业级云平台，支持 Dock、Matrice 等企业设备，并提供企业飞行管理能力。[5] 它更适合企业和行业场景，可在 SkyLog 后续教育、社团或小团队版本中继续研究。

## 数据导入后的功能价值

### 自动飞行摘要

- 飞行时长
- 飞行距离
- 最大高度
- 起降点
- 电池消耗
- 主要告警

### 地图轨迹

- 起点
- 终点
- 飞行路径
- 关键事件点
- 返航路径

### 风险复盘

- 低电量返航
- 信号丢失
- GPS 异常
- 高度和距离异常
- 结合天气数据分析风力影响

### AI 复盘增强

AI 可以基于真实遥测数据生成更具体的复盘，而不只依赖用户手写备注。

## 边界

SkyLog 第一版不承诺：

- 自动同步 DJI 云端数据
- 读取所有无人机黑匣子数据
- 兼容所有 DJI 机型
- 绕过 iOS / Android 文件权限限制
- 实时连接厂商账号

SkyLog 第一版应保证：

- 用户可以手动记录
- 用户可以本地保存
- 用户可以导出备份
- 后续可支持用户授权导入飞行日志文件
- 解析失败时不影响基础记录功能

## Sources

[1] DJI Support, DJI Fly 或 DJI GO 4 如何同步飞行记录: https://repair.dji.com/help/content?customId=01700006773&lang=zh-CN&paperDocType=ARTICLE&re=CN&spaceId=17

[2] DJI Flight Data, How to read DJIFlightRecord files, April 17, 2026: https://djiflightdata.com/blog/reading-djiflightrecord-logs.html

[3] DJI ViewPoints, DJI to Disable Flight Records Sync in the U.S. and Remove Thumbnail Previews Globally, June 7, 2024: https://viewpoints.dji.com/blog/dji-to-disable-flight-record-sync-in-the-us

[4] DJI Developer, API License Agreement, Flight Record Parsing interfaces: https://developer.dji.com/policies/flight_record/

[5] DJI Enterprise, FlightHub 2 FAQ: https://enterprise.dji.com/flighthub-2/faq

