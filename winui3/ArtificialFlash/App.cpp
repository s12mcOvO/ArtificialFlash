#include "pch.h"
#include "App.h"
#include "MainWindow.h"
#include "Backend/BackendService.h"

using ::ArtificialFlash::Backend::BackendService;

namespace ArtificialFlash
{
    App::App()
    {
        m_impl = std::make_unique<MainWindowImpl>();
    }

    void App::OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&)
    {
        m_impl->Activate();
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
