#include "pch.h"
#include "DataPage.h"

using namespace Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    DataPage::DataPage()
    {
        m_viewModel = *winrt::make<ArtificialFlash::implementation::DataViewModel>();
        m_viewModel.Refresh();

        auto stack = Controls::StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = Controls::TextBlock();
        title.Text(L"Datasets");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        auto addBtn = Controls::Button();
        addBtn.Content(box_value(L"Add Dataset"));
        addBtn.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(addBtn);

        Content(stack);
    }

    void DataPage::OnAddDataset(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }

    void DataPage::OnDownloadFromUrl(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }

    void DataPage::OnDownloadBuiltIn(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }
}
