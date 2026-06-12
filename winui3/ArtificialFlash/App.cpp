#include "pch.h"
#include "App.h"
#include "MainWindow.h"
#include "Backend/BackendService.h"

using ::ArtificialFlash::Backend::BackendService;

namespace winrt::ArtificialFlash::implementation
{
    App::App()
    {
        InitializeBackend();
    }

    App::~App()
    {
        ShutdownBackend();
    }

    void App::OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&)
    {
        m_window = make<MainWindow>();
        m_window.Activate();
    }

    void App::InitializeBackend()
    {
        BackendService::Instance().Initialize();
    }

    void App::ShutdownBackend()
    {
        BackendService::Instance().Shutdown();
    }
}
