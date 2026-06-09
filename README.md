# ArtificialFlash 🧠 能工智人

[English](#english) | [中文](#中文)

---

## English

A beginner-friendly AI model training assistant for Windows, built with C++/WinRT and WinUI 3. Supports Visual, NLP, and Generative models with local training capabilities.

![License](https://img.shields.io/badge/license-Apache%202.0-green)

### Features

- **Data Management**: Upload local files, URL download, built-in datasets
- **Model Configuration**: Visual, NLP, Generative, and Custom models
- **Training Control**: Start/Pause/Stop with local training
- **Real-time Monitoring**: Live progress, loss curves, training logs
- **Model Management**: View, test, export (ONNX/TFLite/PyTorch), delete models

### Themes
- Light / Dark / System theme

### Prerequisites
- Visual Studio 2022
- Windows SDK 10.0.22621.0
- Windows 10 (version 1809+) or Windows 11

### Quick Start

```bash
# Clone the repository
git clone https://github.com/s12mcOvO/ArtificialFlash.git
cd ArtificialFlash

# Open with Visual Studio 2022
start winui3/ArtificialFlash.sln
```

Then build and run the `ArtificialFlash` project from Visual Studio.

### Tech Stack

| Category | Technology |
|----------|------------|
| UI Framework | WinUI 3 (Windows App SDK) |
| Language | C++/WinRT |
| Backend | C++ (Neural Networks, Training Manager) |
| Charts | Custom Canvas rendering |

### License

Apache License 2.0 - See [LICENSE](LICENSE)

---

## 中文

一个基于 C++/WinRT 和 WinUI 3 构建的 Windows 入门级 AI 模型训练助手。支持视觉、NLP 和生成式模型，提供本地训练能力。

![许可证](https://img.shields.io/badge/license-Apache%202.0-green)

### 功能特点

- **数据管理**：上传本地文件、URL 下载、内置数据集
- **模型配置**：视觉、NLP、生成式和自定义模型
- **训练控制**：开始/暂停/停止，本地训练
- **实时监控**：实时进度、损失曲线、训练日志
- **模型管理**：查看、测试、导出（ONNX/TFLite/PyTorch）、删除模型

### 主题
- 浅色 / 深色 / 跟随系统

### 先决条件
- Visual Studio 2022
- Windows SDK 10.0.22621.0
- Windows 10 (版本 1809+) 或 Windows 11

### 快速开始

```bash
# 克隆仓库
git clone https://github.com/s12mcOvO/ArtificialFlash.git
cd ArtificialFlash

# 使用 Visual Studio 2022 打开
start winui3/ArtificialFlash.sln
```

然后在 Visual Studio 中构建并运行 `ArtificialFlash` 项目。

### 技术栈

| 分类 | 技术 |
|------|------|
| UI 框架 | WinUI 3 (Windows App SDK) |
| 语言 | C++/WinRT |
| 后端 | C++ (神经网络、训练管理器) |
| 图表 | 自定义 Canvas 渲染 |

### 许可证

Apache License 2.0 - 详见 [LICENSE](LICENSE)
