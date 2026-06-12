#include "pch.h"
#include "App.h"
#include "MainWindow.h"
#include "Backend/BackendService.h"

#if !defined(WINAPI_FAMILY) || (WINAPI_FAMILY == WINAPI_FAMILY_DESKTOP_APP)
#include <winrt/Microsoft.UI.Xaml.Hosting.desktop-windowxamlsource.h>
#endif

namespace winrt::ArtificialFlash::implementation
{
    App::App()
    {
        InitializeBackend();
        Microsoft::UI::Xaml::Application::Current().Suspending([this](auto&&, auto&&) { ShutdownBackend(); });
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
        Backend::BackendService::Instance().Initialize();
    }

    void App::ShutdownBackend()
    {
        Backend::BackendService::Instance().Shutdown();
    }
}
