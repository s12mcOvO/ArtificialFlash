#include "pch.h"
#include "ModelConfigPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    ModelConfigPage::ModelConfigPage()
    {
        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"Create Model");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void ModelConfigPage::OnCreateModel(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
}
