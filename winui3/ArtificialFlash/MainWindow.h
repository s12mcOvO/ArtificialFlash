#pragma once
#include <winrt/Microsoft.UI.Xaml.h>
#include <winrt/Microsoft.UI.Xaml.Controls.h>
#include <winrt/Windows.Foundation.h>
#include <memory>

namespace ArtificialFlash
{
    class MainWindowImpl
    {
    public:
        MainWindowImpl();
        ~MainWindowImpl() = default;
        void Activate();

    private:
        void OnNavigationChanged(
            winrt::Microsoft::UI::Xaml::Controls::NavigationView const&,
            winrt::Microsoft::UI::Xaml::Controls::NavigationViewSelectionChangedEventArgs const&);
        void NavigateToPage(winrt::hstring const& tag);

        winrt::Microsoft::UI::Xaml::Controls::NavigationView m_navView{ nullptr };
        winrt::Microsoft::UI::Xaml::Controls::Frame m_contentFrame{ nullptr };
        winrt::Microsoft::UI::Xaml::Window m_window{ nullptr };
    };
}
