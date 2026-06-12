#pragma once
#include <winrt/Microsoft.UI.Xaml.h>
#include <memory>

namespace winrt::ArtificialFlash::implementation
{
    struct App : AppT<App>
    {
        App();
        ~App();

        void OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&);

    private:
        void InitializeBackend();
        void ShutdownBackend();
        winrt::Microsoft::UI::Xaml::Window m_window{ nullptr };
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct App : AppT<App, implementation::App> {};
}
