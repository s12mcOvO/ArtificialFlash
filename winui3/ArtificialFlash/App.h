#pragma once
#include <winrt/Microsoft.UI.Xaml.h>
#include <winrt/Microsoft.UI.Xaml.Controls.h>
#include <winrt/Windows.Foundation.h>

namespace ArtificialFlash
{
    struct App
    {
        App();
        ~App() = default;

        void OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&);
        void InitializeBackend();
        void ShutdownBackend();

    private:
        struct MainWindowImpl;
        std::unique_ptr<MainWindowImpl> m_impl;
    };
}
