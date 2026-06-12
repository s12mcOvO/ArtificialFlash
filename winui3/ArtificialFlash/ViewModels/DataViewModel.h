#pragma once
#include <winrt/Microsoft.UI.Xaml.Data.h>
#include <winrt/Windows.Foundation.Collections.h>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class DataViewModel
    {
    public:
        DataViewModel();
        ~DataViewModel() = default;

        Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable> Datasets() const { return m_datasets; }
        void Refresh();
        void AddDataset(winrt::hstring const& name, winrt::hstring const& path, winrt::hstring const& type);
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
