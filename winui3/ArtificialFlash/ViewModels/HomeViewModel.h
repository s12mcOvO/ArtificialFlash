#pragma once
#include <string>
#include <vector>
#include <functional>
#include <winrt/Microsoft.UI.Xaml.Data.h>
#include <winrt/Windows.Foundation.Collections.h>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class HomeViewModel
    {
    public:
        HomeViewModel();
        ~HomeViewModel() = default;

        int32_t DatasetCount() const { return m_datasetCount; }
        void DatasetCount(int32_t value);
        int32_t ModelCount() const { return m_modelCount; }
        void ModelCount(int32_t value);
        bool IsTrainingActive() const { return m_isTrainingActive; }
        void IsTrainingActive(bool value);
        winrt::hstring BackendStatus() const { return m_backendStatus; }
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
