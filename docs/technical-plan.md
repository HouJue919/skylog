# SkyLog 技术方案

## 技术目标

SkyLog 第一阶段定位为本地优先的个人无人机飞行日志 App。核心目标是让用户在没有网络、没有账号、没有第三方后端的情况下，也能稳定记录、查看和整理飞行数据。

第一版原则：

- 新增、查看、编辑和删除飞行记录都不依赖网络
- 不把云存储和 AI 服务作为 MVP 必需项
- 不强制登录，降低使用门槛和隐私压力
- 支持数据导出，便于备份和迁移
- 保留后续同步、AI 和厂商日志导入扩展能力

## 技术栈

- Flutter
- Dart
- Riverpod 或 Provider
- GoRouter
- Drift + SQLite
- image_picker
- path_provider
- share_plus
- geolocator，可选
- flutter_map + OpenStreetMap 瓦片，或系统地图跳转

第一阶段不默认接入：

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- App 直连 OpenAI API
- 强制云账号
- 视频云上传

## 架构设计

推荐目录结构：

```text
lib/
  app/
    app.dart
    router.dart
    theme.dart
  features/
    dashboard/
    flight_log/
    flight_editor/
    map/
    profile/
    settings/
    ai_summary/
  data/
    db/
    models/
    repositories/
    export/
  shared/
    widgets/
    utils/
    constants/
```

### 页面层

负责 UI 展示和交互，不直接处理数据库细节。

### 状态层

管理飞行记录列表、当前编辑表单、当前选中记录、统计数据和地图点位。

### Repository 层

统一提供数据读写接口：

- `FlightRepository`
- `MediaRepository`
- `DroneRepository`
- `BackupRepository`

第一版 Repository 只连接本地数据库和本地文件。后续同步能力可通过远程数据源扩展。

## 本地存储

推荐使用 Drift + SQLite。

原因：

- 数据结构清晰
- 适合飞行日志、设备、素材等关系数据
- 方便按日期、地点、天气、无人机型号筛选
- 方便做统计
- 方便导出 JSON 或 CSV

素材存储策略：

- 保存用户选择的图片封面
- 必要图片复制到 App 私有目录，避免原相册文件被删除后失效
- 视频先保存本地路径或缩略图，不做云上传
- 每条素材记录保存 `localPath`、`type`、`caption` 和 `flightId`

## 数据模型

### FlightRecord

```dart
class FlightRecord {
  final String id;
  final String title;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final DateTime flightDate;
  final int durationMinutes;
  final String? droneModel;
  final int? batteryCount;
  final String? weather;
  final String? windLevel;
  final double? temperature;
  final String? visibility;
  final String? purpose;
  final List<String> shotTypes;
  final String? coverAssetId;
  final String? summary;
  final String? issues;
  final String? improvements;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

### MediaAsset

```dart
class MediaAsset {
  final String id;
  final String flightId;
  final MediaType type;
  final String localPath;
  final String? caption;
  final DateTime createdAt;
}

enum MediaType {
  photo,
  video,
  cover,
}
```

### DroneProfile

```dart
class DroneProfile {
  final String id;
  final String name;
  final String model;
  final String? serialNumber;
  final DateTime createdAt;
}
```

## AI 方案

AI 不进入 MVP 核心链路。基础记录功能必须在无 AI、无网络时完整可用。

推荐通过 Cloudflare Worker 或类似轻量服务端代理 AI 请求：

```text
Flutter App
  -> Cloudflare Worker
    -> AI Provider
```

Worker 负责：

- 保存服务端 API Key
- 校验请求来源
- 限流
- 管理 Prompt 模板
- 记录匿名调用量
- 根据成本切换模型供应商
- 返回结构化 JSON

统一请求示例：

```json
{
  "location": "青岛 石老人海岸",
  "weather": "多云",
  "windLevel": "4 级",
  "purpose": "旅行航拍",
  "shotTypes": ["低空横移", "日落航拍"],
  "notes": "风比较大，画面有些不稳"
}
```

统一返回示例：

```json
{
  "summary": "本次飞行在海边日落时段完成...",
  "shootingAnalysis": "低空横移受风力影响较明显...",
  "safetyNotes": "建议提前设置返航电量...",
  "nextImprovements": "下次降低横移速度并选择风力更小的时间段。"
}
```

## 备份与迁移

第一版提供 JSON 导出，后续加入 CSV 和 PDF 报告。

JSON 导出内容：

- 飞行记录
- 无人机设备
- 素材元数据
- App 版本
- 导出时间

未来同步方案可评估：

- iCloud 文件同步
- Google Drive 文件备份
- Supabase
- Firebase
- 自建后端

## 开发计划

### Sprint 1：项目基础

- 初始化 Flutter 项目
- 设置路由和主题
- 建立 SQLite / Drift
- 建立数据模型
- 建立 Repository

### Sprint 2：飞行记录闭环

- 新增飞行表单
- 本地保存
- 日志列表
- 详情页
- 编辑和删除

### Sprint 3：素材和地图

- 图片选择
- 封面图显示
- 素材画廊
- 经纬度保存
- 系统地图跳转或 App 内轻量地图

### Sprint 4：统计、设备和备份

- 首页统计
- 个人页统计
- 无人机设备管理
- JSON 导出
- CSV 导出，可选

### Sprint 5：AI 和数据增强

- Cloudflare Worker AI 网关
- Prompt 模板
- 生成总结草稿
- 限流和成本控制
- 厂商日志导入原型

## 测试清单

- 无网络时可以新增飞行记录
- 无网络时可以查看历史记录
- 可以新增一条最小飞行记录
- 缺少地点时不能保存
- 飞行时长小于等于 0 时不能保存
- 列表按日期倒序展示
- 点击列表项能进入详情页
- 地图能显示记录点位或跳转系统地图
- 图片不存在时显示占位图
- 删除记录后统计数据更新
- JSON 导出文件可正常生成
- AI 服务不可用时不影响飞行记录功能

