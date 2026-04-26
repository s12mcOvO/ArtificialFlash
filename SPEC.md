# ArtificialFlash - AI Training Assistant

## 1. Project Overview

**Project Name**: ArtificialFlash  
**Project Type**: Cross-platform Flutter Application (Desktop & Mobile)  
**Core Functionality**: A beginner-friendly AI model training assistant that allows users to select datasets, configure models, control training processes, monitor progress, and manage trained models through an intuitive UI.

## 2. Technology Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Communication**: WebSocket (real-time training updates) + REST API
- **Architecture**: Clean Architecture (Presentation / Domain / Core layers)
- **Storage**: Local file system + SharedPreferences

### Backend (Python)
- **Framework**: FastAPI
- **WebSocket**: For real-time training progress
- **ML Libraries**: PyTorch, TensorFlow, Transformers, ONNX, scikit-learn

### Cross-platform Support
| Platform | Local Training | Remote Training |
|----------|---------------|-----------------|
| Linux    | ✅            | ✅              |
| macOS    | ✅            | ✅              |
| Windows  | ✅            | ✅              |
| Android  | ❌            | ✅              |
| iOS      | ❌            | ✅              |

## 3. Features

### 3.1 Data Management
- 📁 Local file upload (drag & drop supported on desktop)
- 🔗 URL dataset download
- 📦 Built-in sample datasets (MNIST, CIFAR-10, IMDB Reviews)
- 👁️ Data preview and details

### 3.2 Model Configuration
- 🖼️ **Visual Models**: Image Classification, Object Detection, Image Segmentation
- 📝 **NLP Models**: Text Classification, Sentiment Analysis, QA
- 🎨 **Generative Models**: Text-to-Image, Image-to-Image
- ⚙️ **Custom Models**: User-defined model configurations
- 📐 **Training Parameters**:
  - Learning Rate
  - Epochs
  - Batch Size
  - Image Size (for vision models)
  - Data Augmentation
  - Train/Validation Split

### 3.3 Training Control
- ▶️ Start / ⏸️ Pause / ⏹️ Stop training
- 🖥️ Training mode: Local or Remote server
- 💾 Configuration persistence

### 3.4 Progress Monitoring
- 📊 Real-time training progress
- 📈 Loss curve visualization
- 📋 Training logs streaming
- 🎯 Metrics (loss, accuracy)

### 3.5 Model Management
- 📋 View trained models
- 📤 Export (ONNX, TensorFlow Lite, PyTorch)
- 🧪 Model testing
- 🗑️ Model deletion

### 3.6 Settings
- 🎨 **Appearance**:
  - Light / Dark / System theme
- 🌐 **Language**: English, Chinese (简体中文)
- 🔌 Server connection configuration

## 4. UI/UX Design

### Visual Style
- Material Design 3
- Beginner-friendly with guided steps

### Color Scheme
| Role | Color |
|------|-------|
| Primary | Deep Blue (#1565C0) |
| Secondary | Teal (#00897B) |
| Accent | Orange (#FF6D00) |
| Success | Green (#388E3C) |
| Error | Red (#D32F2F) |

### Layout
- **Desktop (≥800px)**: Left sidebar navigation
- **Tablet (600-800px)**: Collapsed rail navigation
- **Mobile (<600px)**: Bottom navigation bar + drawer

### Key Screens
1. **Home**: Dashboard with quick actions, stats, getting started guide
2. **Data**: Dataset management with tabs (Local/URL/Built-in)
3. **Model**: Model configuration wizard
4. **Train**: Training control center with real-time metrics
5. **Models**: Trained model library
6. **Settings**: Appearance, language, server configuration

## 5. Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants
│   ├── network/         # API & WebSocket services
│   ├── theme/           # Material theme definitions
│   └── utils/           # Local storage utilities
├── domain/
│   └── entities/        # Data models (Dataset, Model, Training)
├── l10n/                # Localizations (en, zh)
└── presentation/
    ├── pages/           # UI screens
    ├── providers/       # Riverpod state management
    └── widgets/         # Reusable components

backend/
├── main.py              # FastAPI server
├── training_manager.py  # Training session management
└── requirements.txt     # Python dependencies
```

## 6. Getting Started

### Prerequisites
- Flutter SDK 3.x
- Python 3.8+ (for backend)

### Run the App
```bash
# Install dependencies
flutter pub get

# Run on desktop
flutter run -d linux
# or
flutter run -d macos
# or
flutter run -d windows

# Run on mobile
flutter run -d android
flutter run -d ios
```

### Run the Backend (Optional)
```bash
cd backend
pip install -r requirements.txt
python main.py
# Server runs on http://localhost:8000
```

## 7. Data Storage

- **Local Storage**: Models and datasets saved to app documents directory
- **Settings**: Theme and language preferences stored in SharedPreferences
- **Offline Support**: Full functionality without backend connection (local training simulation)

## 8. License

MIT License