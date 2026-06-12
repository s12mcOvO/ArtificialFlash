#include "pch.h"
#include "SettingsPage.h"

using namespace Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    SettingsPage::SettingsPage()
    {
        auto stack = Controls::StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = Controls::TextBlock();
        title.Text(L"Settings");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void SettingsPage::OnDarkModeToggle(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void SettingsPage::OnRemoteToggle(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void SettingsPage::OnTestConnection(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }
}
