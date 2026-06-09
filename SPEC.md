# ArtificialFlash 能工智人 - Project Specification

## 1. Project Overview

**Project Name**: ArtificialFlash (能工智人)  
**Project Type**: Windows Desktop Application (C++/WinRT WinUI 3)  
**Core Functionality**: A beginner-friendly AI model training assistant that allows users to select datasets, configure models, control training processes, monitor progress, and manage trained models through an intuitive UI.

## 2. Technology Stack

### Frontend (WinUI 3)
| Category | Technology |
|----------|------------|
| UI Framework | WinUI 3 (Windows App SDK) |
| Language | C++/WinRT |
| Architecture | MVVM (Model-View-ViewModel) |
| Data Binding | x:Bind, {Binding} |
| Charts | Custom Canvas rendering |
| Storage | Windows.Storage |

### Backend (C++)
| Category | Technology |
|----------|------------|
| Neural Networks | Pure C++ implementation |
| Training Manager | Async thread-based training |
| Image Processing | Direct2D / WIC |

### Platform Support
| Feature | Support |
|---------|:-------:|
| Windows 10 (1809+) | ✅ |
| Windows 11 | ✅ |
| Local Training | ✅ |
| Remote Training | ❌ (planned) |

## 3. Features

### 3.1 Data Management
- 📁 Local file upload
- 🔗 URL dataset download
- 📦 Built-in datasets (MNIST, CIFAR-10, Fashion-MNIST)
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
- 🖥️ Training mode: Local only
- 💾 Configuration persistence

### 3.4 Progress Monitoring
- 📊 Real-time training progress
- 📈 Loss curve visualization (Canvas)
- 📋 Training logs streaming
- 🎯 Metrics (loss, accuracy)

### 3.5 Model Management
- 📋 View trained models
- 📤 Export (ONNX, TensorFlow Lite, PyTorch)
- 🧪 Model testing with text/image input
- 🗑️ Model deletion

### 3.6 Settings
- 🎨 **Appearance**: Light / Dark / System theme
- 🌐 **Language**: English, Chinese (简体中文)

## 4. UI/UX Design

### Visual Style
- WinUI 3 (Fluent Design)
- Beginner-friendly with guided steps

### Color Scheme
| Role | Color |
|------|-------|
| Primary | Deep Blue (#1565C0) |
| Secondary | Teal (#00897B) |
| Accent | Orange (#FF6D00) |
| Success | Green (#388E3C) |
| Error | Red (#D32F2F) |

### Navigation
- **Desktop**: Left sidebar navigation (NavigationView)

### Key Screens
1. **Home**: Dashboard with quick actions, stats, getting started guide
2. **Data**: Dataset management with tabs (Local/URL/Built-in)
3. **Model**: Model configuration wizard
4. **Train**: Training control center with real-time metrics
5. **Models**: Trained model library
6. **Settings**: Appearance, language configuration

## 5. Project Structure

```
winui3/
├── ArtificialFlash.sln
├── ArtificialFlash/
│   ├── App.*                 # Application entry point
│   ├── MainWindow.*          # Main window with NavigationView
│   ├── Pages/                # UI pages
│   │   ├── HomePage.*
│   │   ├── DataPage.*
│   │   ├── ModelConfigPage.*
│   │   ├── TrainingPage.*
│   │   ├── ModelsPage.*
│   │   └── SettingsPage.*
│   ├── ViewModels/           # MVVM ViewModels
│   ├── Models/               # Data models
│   ├── Backend/              # C++ backend
│   │   ├── NeuralNetworks.*
│   │   ├── TrainingManager.*
│   │   └── BackendService.*
│   ├── Controls/             # Custom controls
│   │   ├── StatusBadge.*
│   │   └── TrainingChart.*
│   ├── Converters/           # Value converters
│   └── Services/             # App services
```

## 6. Getting Started

### Prerequisites
- Visual Studio 2022
- Windows SDK 10.0.22621.0
- Windows 10 (version 1809+) or Windows 11

### Build and Run
1. Open `winui3/ArtificialFlash.sln` in Visual Studio 2022
2. Set `ArtificialFlash` as startup project
3. Build and run (F5)

## 7. Data Storage

- **Local Storage**: Models and datasets saved to app local folder
- **Settings**: Theme and language preferences stored in ApplicationData
- **Offline Support**: Full functionality without network connection

## 8. License

Apache License 2.0 - See [LICENSE](LICENSE)
