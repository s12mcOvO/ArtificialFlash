#include "pch.h"
#include "DataPage.h"
#include <winrt/Windows.UI.Popups.h>

using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Windows::UI::Popups;

namespace winrt::ArtificialFlash::implementation
{
    DataPage::DataPage()
    {
        InitializeComponent();
        m_viewModel = *winrt::make<ArtificialFlash::implementation::DataViewModel>();
        m_viewModel.Refresh();
    }

    void DataPage::OnAddDataset(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
        // TODO: Show file picker dialog
        m_viewModel.AddDataset(L"New Dataset", L"C:\\data", L"image");
    }

    void DataPage::OnDownloadFromUrl(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
        auto url = UrlTextBox().Text();
        auto name = NameTextBox().Text();
        if (!url.empty() && !name.empty())
        {
            m_viewModel.AddDataset(name, url, L"mixed");
        }
    }

    void DataPage::OnDownloadBuiltIn(
        Windows::Foundation::IInspectable const& sender,
        RoutedEventArgs const&)
    {
        auto btn = sender.as<Controls::Button>();
        auto tag = btn.Tag().as<winrt::hstring>();
        m_viewModel.AddDataset(tag, L"builtin://" + tag, L"image");
    }
}
