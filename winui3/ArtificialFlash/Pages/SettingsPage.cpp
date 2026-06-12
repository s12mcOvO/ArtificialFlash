#include "pch.h"
#include "SettingsPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    SettingsPage::SettingsPage()
    {
        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"Settings");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void SettingsPage::OnDarkModeToggle(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
    void SettingsPage::OnRemoteToggle(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
    void SettingsPage::OnTestConnection(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
}
