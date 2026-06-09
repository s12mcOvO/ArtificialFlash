#include "pch.h"
#include "SettingsPage.h"

namespace winrt::ArtificialFlash::implementation
{
    SettingsPage::SettingsPage()
    {
        InitializeComponent();

        auto settings = m_settings.LoadSettings();
        DarkModeToggle().IsOn(settings.useDarkTheme);
        RemoteToggle().IsOn(settings.useRemoteServer);
        HostBox().Text(winrt::hstring(settings.serverHost));
        PortBox().Value(settings.serverPort);
    }

    void SettingsPage::OnDarkModeToggle(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        m_settings.SetUseDarkTheme(DarkModeToggle().IsOn());
    }

    void SettingsPage::OnRemoteToggle(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        Settings::AppSettings s = m_settings.LoadSettings();
        s.useRemoteServer = RemoteToggle().IsOn();
        s.serverHost = HostBox().Text().c_str();
        s.serverPort = static_cast<int>(PortBox().Value());
        m_settings.SaveSettings(s);
    }

    void SettingsPage::OnTestConnection(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        // TODO: Implement HTTP health check
    }
}
