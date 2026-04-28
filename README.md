# ArtificialFlash 🧠 能工智人

A beginner-friendly AI model training assistant built with Flutter. Supports Visual, NLP, and Generative models with local and remote training capabilities.

![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-blue)
![License](https://img.shields.io/badge/license-Apache%202.0-green)

## License

This project is licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

## Features

### 🎯 Core Functionality
- **Data Management**: Upload local files (drag & drop), URL download, built-in datasets
- **Model Configuration**: Visual, NLP, Generative, and Custom models
- **Training Control**: Start/Pause/Stop with local or remote training
- **Real-time Monitoring**: Live progress, loss curves, training logs
- **Model Management**: View, test, export (ONNX/TFLite), delete models

### 🎨 Customization
- **Themes**: Light / Dark / System theme
- **Languages**: English, 中文 (Chinese)

### 📱 Cross-Platform
| Platform | Local Training | Remote Training |
|----------|:--------------:|:---------------:|
| Linux    |       ✅       |        ✅       |
| macOS    |       ✅       |        ✅       |
| Windows  |       ✅       |        ✅       |
| Android  |       ❌       |        ✅       |
| iOS      |       ❌       |        ✅       |

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Python 3.8+ (optional, for backend)

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

### Run Backend (Optional)

```bash
cd backend
pip install -r requirements.txt
python main.py
```

## Project Structure

```
lib/
├── core/               # Core utilities
│   ├── constants/      # App constants
│   ├── network/        # API & WebSocket
│   ├── theme/          # Material themes
│   └── utils/          # Local storage
├── domain/
│   └── entities/       # Data models
├── l10n/               # Localizations
└── presentation/
    ├── pages/          # UI screens
    ├── providers/      # State management
    └── widgets/        # Reusable widgets

backend/                # Python FastAPI server
```

## Screenshots

### Desktop UI
- Left sidebar navigation
- Real-time training progress
- Loss curve visualization

### Mobile UI
- Bottom navigation
- Responsive layout

## Tech Stack

- **Frontend**: Flutter 3.x, Riverpod, WebSocket, Dio
- **Backend**: FastAPI, WebSocket, PyTorch/TensorFlow
- **Storage**: Local file system, SharedPreferences

## License

MIT License - See [LICENSE](LICENSE) for details.

---

Made with ❤️ for AI enthusiasts