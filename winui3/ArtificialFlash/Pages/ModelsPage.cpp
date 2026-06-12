#include "pch.h"
#include "ModelsPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    ModelsPage::ModelsPage()
    {
        auto vmImpl = winrt::make_self<ArtificialFlash::implementation::ModelsViewModel>();
        vmImpl->Refresh();
        m_viewModel = vmImpl.as<ArtificialFlash::ModelsViewModel>();

        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"Models");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void ModelsPage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}

    void ModelsPage::OnModelClick(
        Windows::Foundation::IInspectable const&,
        Controls::ItemClickEventArgs const&) {}
}
