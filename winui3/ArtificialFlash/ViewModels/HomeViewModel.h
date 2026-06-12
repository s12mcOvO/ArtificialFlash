#pragma once
#include <string>
#include <vector>
#include <memory>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class HomeViewModel
    {
    public:
        HomeViewModel();
        ~HomeViewModel() = default;

        int32_t DatasetCount() const { return m_datasetCount; }
        int32_t ModelCount() const { return m_modelCount; }
        bool IsTrainingActive() const { return m_isTrainingActive; }
        winrt::hstring BackendStatus() const { return m_backendStatus; }

        void Refresh();

    private:
        int32_t m_datasetCount = 0;
        int32_t m_modelCount = 0;
        bool m_isTrainingActive = false;
        winrt::hstring m_backendStatus = L"Initializing...";
    };
}
