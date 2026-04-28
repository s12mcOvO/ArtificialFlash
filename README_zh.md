# ArtificialFlash 🧠 能工智人

一个基于 Flutter 构建的入门级 AI 模型训练助手。支持视觉、NLP 和生成式模型，提供本地和远程训练能力。

![平台](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-blue)
![许可证](https://img.shields.io/badge/license-Apache%202.0-green)

## 许可证

本项目基于 Apache 许可证 2.0 版本授权。详见 [LICENSE](LICENSE)。

## 功能特点

### 🎯 核心功能
- **数据管理**：上传本地文件（拖放）、URL 下载、内置数据集
- **模型配置**：视觉、NLP、生成式和自定义模型
- **训练控制**：开始/暂停/停止，支持本地或远程训练
- **实时监控**：实时进度、损失曲线、训练日志
- **模型管理**：查看、测试、导出（ONNX/TFLite）、删除模型

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
- Flutter SDK 3.x
- Python 3.8+（可选，用于后端）

### 快速启动

```bash
# 克隆仓库
git clone https://github.com/s12mcOvO/ArtificialFlash.git
cd ArtificialFlash

# 安装依赖
flutter pub get

# 运行应用
flutter run
```

### 运行后端（可选）

```bash
cd backend
pip install -r requirements.txt
python main.py
```

## 项目结构

```
lib/
├── core/               # 核心工具
│   ├── constants/     # 应用常量
│   ├── network/       # API 和 WebSocket
│   ├── theme/        # Material 主题
│   └── utils/        # 本地存储
├── domain/
│   └── entities/     # 数据模型
├── l10n/             # 本地化
└── presentation/
    ├── pages/        # 界面页面
    ├── providers/   # 状态管理
    └── widgets/     # 可复用组件

backend/              # Python FastAPI 服务端
```

## 界面预览

### 桌面端 UI
- 左侧边栏导航
- 实时训练进度
- 损失曲线可视化

### 移动端 UI
- 底部导航栏
- 响应式布局

## 技术栈

- **前端**：Flutter 3.x、Riverpod、WebSocket、Dio
- **后端**：FastAPI、WebSocket、PyTorch/TensorFlow
- **存储**：本地文件系统、SharedPreferences

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)。

---

Made with ❤️ for AI 爱好者