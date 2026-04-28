# ArtificialFlash 🧠 能工智人

一个基于 Flutter 构建的入门级 AI 模型训练助手。支持视觉、NLP 和生成式模型，提供本地和远程训练能力。

![平台](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-blue)
![许可证](https://img.shields.io/badge/license-Apache%202.0-green)

## 功能特点

### 🎯 核心功能
- **数据管理**：上传本地文件（拖放）、URL 下载、内置数据集
- **模型配置**：视觉、NLP、生成式和自定义模型
- **训练控制**：开始/暂停/停止，支持本地或远程训练
- **实时监控**：实时进度、损失曲线、训练日志
- **模型管理**：查看、测试、导出（ONNX/TFLite/PyTorch）、删除模型

### 🎨 自定义
- **主题**：浅色 / 深色 / 跟随系统
- **语言**：English, 中文

### 📱 跨平台
| 平台 | 本地训练 | 远程训练 |
|----------|:--------------:|:---------------:|
| Linux    |       ✅       |        ✅       |
| macOS    |       ✅       |        ✅       |
| Windows  |       ✅       |        ✅       |
| Android  |       ❌       |        ✅       |
| iOS      |       ❌       |        ✅       |

## 快速开始

### 环境要求
- Flutter SDK 3.41+
- Python 3.10+（后端）

### 本地运行

```bash
# 克隆仓库
git clone https://github.com/s12mcOvO/ArtificialFlash.git
cd ArtificialFlash

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 运行后端

```bash
# 进入后端目录
cd backend

# 安装依赖
pip install -r requirements.txt

# 启动服务
python main.py
```

后端默认运行在 http://localhost:8000

## 项目结构

```
lib/
├── core/               # 核心工具
│   ├── constants/     # 应用常量
│   ├── network/       # API 服务
│   ├── theme/         # 主题
│   └── utils/         # 本地存储
├── domain/
│   └── entities/     # 数据模型
├── l10n/              # 本地化
└── presentation/
    ├── pages/         # 界面页面
    ├── providers      # 状态管理
    └── widgets       # 可复用组件

backend/               # Python FastAPI 后端
├── main.py           # FastAPI 服务入口
└── training_manager.py  # 训练管理器
```

## 界面预览

### 桌面端
- 左侧边栏导航
- 实时训练进度
- 损失曲线可视化

### 移动端
- 底部导航栏
- 响应式布局

## 技术栈

| 分类 | 技术 |
|------|------|
| 前端 | Flutter 3.41+, Riverpod, Dio, WebSocket |
| 后端 | FastAPI, WebSocket, AsyncIO |
| 图表 | fl_chart |
| 文件 | file_picker, path_provider |

## 许可证

本项目基于 Apache License 2.0 协议开源。详见 [LICENSE](LICENSE)。

---

Made with ❤️ for AI 爱好者