#pragma once
#include "DataPage.g.h"
#include "../ViewModels/DataViewModel.h"

namespace winrt::ArtificialFlash::implementation
{
    struct DataPage : DataPageT<DataPage>
    {
        DataPage();
        ArtificialFlash::DataViewModel ViewModel() { return m_viewModel; }

        void OnAddDataset(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnDownloadFromUrl(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnDownloadBuiltIn(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        ArtificialFlash::DataViewModel m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct DataPage : DataPageT<DataPage, implementation::DataPage> {};
}
