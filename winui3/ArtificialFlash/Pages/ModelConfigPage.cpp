#include "pch.h"
#include "ModelConfigPage.h"
#include "../Backend/BackendService.h"

using namespace Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    ModelConfigPage::ModelConfigPage()
    {
        auto stack = Controls::StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = Controls::TextBlock();
        title.Text(L"Create Model");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void ModelConfigPage::OnCreateModel(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }
}
