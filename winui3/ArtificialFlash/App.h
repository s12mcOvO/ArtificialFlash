#pragma once
#include "App.xaml.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct App : AppT<App>
    {
        App();
        ~App() { ShutdownBackend(); }

        void OnLaunched(Microsoft::UI::Xaml::LaunchActivatedEventArgs const&);

    private:
        void InitializeBackend();
        void ShutdownBackend();
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct App : AppT<App, implementation::App> {};
}
