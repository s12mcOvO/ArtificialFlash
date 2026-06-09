# ArtificialFlash WinUI3

C++/WinRT WinUI 3 desktop application for AI model training.

## Prerequisites

- Windows 10 SDK (10.0.22621.0 or later)
- Visual Studio 2022 with "Desktop development with C++" workload
- NuGet package manager

## Building

1. Open `ArtificialFlash.sln` in Visual Studio 2022
2. Restore NuGet packages (they will be auto-restored on build)
3. Select `x64` platform and `Debug`/`Release` configuration
4. Build -> Build Solution (F7)

Or via command line:

```powershell
msbuild ArtificialFlash.sln /p:Configuration=Debug /p:Platform=x64
```

## Project Structure

```
ArtificialFlash/
├── ArtificialFlash.sln          # Solution file
├── ArtificialFlash/
│   ├── App.xaml/.h/.cpp         # Application entry point
│   ├── MainWindow.xaml/.h/.cpp  # Main window with NavigationView
│   ├── Pages/                   # UI pages
│   │   ├── HomePage             # Dashboard
│   │   ├── DataPage             # Dataset management
│   │   ├── ModelsPage           # Model listing
│   │   ├── ModelConfigPage      # Model creation config
│   │   ├── TrainingPage         # Training monitor
│   │   └── SettingsPage         # App settings
│   ├── ViewModels/              # MVVM view models
│   ├── Models/                  # Data model definitions
│   ├── Backend/                 # ML training engine
│   │   ├── NeuralNetworks       # Neural network implementations
│   │   ├── TrainingManager      # Training session management
│   │   └── BackendService       # Backend service singleton
│   ├── Services/                # App services
│   ├── Controls/                # Custom UI controls
│   └── Converters/              # XAML value converters
└── NuGet.Config                 # NuGet source configuration
```

## NuGet Dependencies

- Microsoft.Windows.CppWinRT (2.0.240405.15)
- Microsoft.UI.Xaml (8.2405.1)
- Win2D (for chart rendering, optional)
- libtorch-cxx11-abi-shared (for PyTorch C++ API, optional)

## Notes

- The backend uses pure C++ neural network implementations (no LibTorch dependency required for basic functionality)
- For production use, integrate with LibTorch for GPU-accelerated training
- Settings are persisted via Windows.Storage.ApplicationData
