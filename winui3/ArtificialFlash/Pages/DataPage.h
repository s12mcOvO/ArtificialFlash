#pragma once
#include <memory>
#include "../ViewModels/DataViewModel.h"
#include "DataPage.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct DataPage : DataPageT<DataPage>
    {
        DataPage();

        void OnAddDataset(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnDownloadFromUrl(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnDownloadBuiltIn(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        std::shared_ptr<::ArtificialFlash::DataViewModel> m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct DataPage : DataPageT<DataPage, implementation::DataPage> {};
}
