#pragma once
#include "DataViewModel.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct DataViewModel : DataViewModelT<DataViewModel>
    {
        DataViewModel() = default;

        Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable> Datasets();
        void Refresh();
        void AddDataset(winrt::hstring const& name,
            winrt::hstring const& path, winrt::hstring const& type);
        void DeleteDataset(winrt::hstring const& id);

        winrt::event_token PropertyChanged(
            Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler);
        void PropertyChanged(winrt::event_token const& token);

    private:
        Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable>
            m_datasets = winrt::single_threaded_observable_vector<Windows::Foundation::IInspectable>();
        winrt::event<Microsoft::UI::Xaml::Data::PropertyChangedEventHandler> m_propertyChanged;

        void RaisePropertyChanged(winrt::hstring const& name);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct DataViewModel : DataViewModelT<DataViewModel, implementation::DataViewModel> {};
}
