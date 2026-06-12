#include "pch.h"
#include "ModelsPage.h"

using namespace Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    ModelsPage::ModelsPage()
    {
        m_viewModel = *winrt::make<ArtificialFlash::implementation::ModelsViewModel>();
        m_viewModel.Refresh();

        auto stack = Controls::StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = Controls::TextBlock();
        title.Text(L"Models");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void ModelsPage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void ModelsPage::OnModelClick(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::Controls::ItemClickEventArgs const&)
    {
    }
}
