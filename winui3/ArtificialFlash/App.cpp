#include "pch.h"
#include "App.h"
#include "MainWindow.h"
#include "Backend/BackendService.h"

namespace winrt::ArtificialFlash::implementation
{
    App::App()
    {
        InitializeBackend();
    }

    void App::OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&)
    {
        window = make<MainWindow>();
        window.Activate();
    }

    void App::InitializeBackend()
    {
        Backend::BackendService::Instance().Initialize();
    }

    void App::ShutdownBackend()
    {
        Backend::BackendService::Instance().Shutdown();
    }
}
