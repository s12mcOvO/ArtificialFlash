#pragma once
#include "MainWindow.xaml.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct MainWindow : MainWindowT<MainWindow>
    {
        MainWindow();

        void OnNavigationChanged(
            Microsoft::UI::Xaml::Controls::NavigationView const&,
            Microsoft::UI::Xaml::Controls::NavigationViewSelectionChangedEventArgs const&);
        void OnNavLoaded(
            winrt::Windows::Foundation::IInspectable const&,
            winrt::Windows::Foundation::IInspectable const&);

    private:
        void NavigateToPage(winrt::hstring const& tag);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct MainWindow : MainWindowT<MainWindow, implementation::MainWindow> {};
}
