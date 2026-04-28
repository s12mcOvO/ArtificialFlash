# ArtificialFlash 🧠 能工智人

[English](#english) | [中文](#中文)

---

## English

A beginner-friendly AI model training assistant built with Flutter. Supports Visual, NLP, and Generative models with local and remote training capabilities.

![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-blue)
![License](https://img.shields.io/badge/license-Apache%202.0-green)

### Features

- **Data Management**: Upload local files (drag & drop), URL download, built-in datasets
- **Model Configuration**: Visual, NLP, Generative, and Custom models
- **Training Control**: Start/Pause/Stop with local or remote training
- **Real-time Monitoring**: Live progress, loss curves, training logs
- **Model Management**: View, test, export (ONNX/TFLite/PyTorch), delete models

### Themes
- Light / Dark / System theme

### Languages
- English, 中文

### Quick Start

```bash
# Clone the repository
git clone https://github.com/s12mcOvO/ArtificialFlash.git
cd ArtificialFlash

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Run Backend

```bash
cd backend
pip install -r requirements.txt
python main.py
```

Backend runs at http://localhost:8000

### Tech Stack

| Category | Technology |
|----------|-------------|
| Frontend | Flutter 3.41+, Riverpod, Dio, WebSocket |
| Backend | FastAPI, WebSocket, AsyncIO |
| Charts | fl_chart |
| Files | file_picker, path_provider |

### License

Apache License 2.0 - See [LICENSE](LICENSE)

---

## 中文

一个基于 Flutter 构建的入门级 AI 模型训练助手。支持视觉、NLP 和生成式模型，提供本地和远程训练能力。

![平台](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-blue)
![许可证](https://img.shields.io/badge/license-Apache%202.0-green)

### 功能特点

- **数据管理**：上传本地文件（拖放）、URL 下载、内置数据集
- **模型配置**：视觉、NLP、生成式和自定义模型
- **训练控制**：开始/暂停/停止，支持本地或远程训练
- **实时监控**：实时进度、损失曲线、训练日志
- **模型管理**：查看、测试、导出（ONNX/TFLite/PyTorch）、删除模型

### 主题
- 浅色 / 深色 / 跟随系统

### 语言
- English, 中文

### 快速开始

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
cd backend
pip install -r requirements.txt
python main.py
```

后端默认运行在 http://localhost:8000

### 技术栈

| 分类 | 技术 |
|------|------|
| 前端 | Flutter 3.41+, Riverpod, Dio, WebSocket |
| 后端 | FastAPI, WebSocket, AsyncIO |
| 图表 | fl_chart |
| 文件 | file_picker, path_provider |

### 许可证

Apache License 2.0 - 详见 [LICENSE](LICENSE)

---

Made with ❤️ for AI 爱好者