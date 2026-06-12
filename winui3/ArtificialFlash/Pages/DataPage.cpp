#include "pch.h"
#include "DataPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    DataPage::DataPage()
    {
        m_viewModel = make<ArtificialFlash::implementation::DataViewModel>();
        m_viewModel.Refresh();

        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"Datasets");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        auto addBtn = Button();
        addBtn.Content(box_value(L"Add Dataset"));
        stack.Children().Append(addBtn);

        Content(stack);
    }

    void DataPage::OnAddDataset(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}

    void DataPage::OnDownloadFromUrl(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}

    void DataPage::OnDownloadBuiltIn(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
}
