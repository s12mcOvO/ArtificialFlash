#pragma once
#include "HomeViewModel.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct HomeViewModel : HomeViewModelT<HomeViewModel>
    {
        HomeViewModel() = default;

        int32_t DatasetCount();
        void DatasetCount(int32_t value);
        int32_t ModelCount();
        void ModelCount(int32_t value);
        bool IsTrainingActive();
        void IsTrainingActive(bool value);
        winrt::hstring BackendStatus();
        void BackendStatus(winrt::hstring const& value);

        void Refresh();

        winrt::event_token PropertyChanged(
            Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler);
        void PropertyChanged(winrt::event_token const& token);

    private:
        int32_t m_datasetCount = 0;
        int32_t m_modelCount = 0;
        bool m_isTrainingActive = false;
        winrt::hstring m_backendStatus = L"Initializing...";
        winrt::event<Microsoft::UI::Xaml::Data::PropertyChangedEventHandler> m_propertyChanged;

        void RaisePropertyChanged(winrt::hstring const& name);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct HomeViewModel : HomeViewModelT<HomeViewModel, implementation::HomeViewModel> {};
}
