#pragma once
#include "SettingsPage.g.h"
#include "../Services/SettingsService.h"

namespace winrt::ArtificialFlash::implementation
{
    struct SettingsPage : SettingsPageT<SettingsPage>
    {
        SettingsPage();

        void OnDarkModeToggle(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnRemoteToggle(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnTestConnection(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        ::ArtificialFlash::Services::SettingsService& m_settings =
            ::ArtificialFlash::Services::SettingsService::Instance();
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct SettingsPage : SettingsPageT<SettingsPage, implementation::SettingsPage> {};
}
