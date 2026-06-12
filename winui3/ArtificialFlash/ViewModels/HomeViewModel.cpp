#include "pch.h"
#include "HomeViewModel.h"
#include "../Backend/BackendService.h"
#include "../Models/Model.h"
#include "../Models/Dataset.h"

using ::ArtificialFlash::Backend::BackendService;
using ::ArtificialFlash::Models::TrainingStatus;

namespace winrt::ArtificialFlash::implementation
{
    int32_t HomeViewModel::DatasetCount() { return m_datasetCount; }
    void HomeViewModel::DatasetCount(int32_t value)
    {
        if (m_datasetCount != value) { m_datasetCount = value; RaisePropertyChanged(L"DatasetCount"); }
    }

    int32_t HomeViewModel::ModelCount() { return m_modelCount; }
    void HomeViewModel::ModelCount(int32_t value)
    {
        if (m_modelCount != value) { m_modelCount = value; RaisePropertyChanged(L"ModelCount"); }
    }

    bool HomeViewModel::IsTrainingActive() { return m_isTrainingActive; }
    void HomeViewModel::IsTrainingActive(bool value)
    {
        if (m_isTrainingActive != value) { m_isTrainingActive = value; RaisePropertyChanged(L"IsTrainingActive"); }
    }

    winrt::hstring HomeViewModel::BackendStatus() { return m_backendStatus; }
    void HomeViewModel::BackendStatus(winrt::hstring const& value)
    {
        if (m_backendStatus != value) { m_backendStatus = value; RaisePropertyChanged(L"BackendStatus"); }
    }

    void HomeViewModel::Refresh()
    {
        auto& backend = BackendService::Instance();
        DatasetCount(static_cast<int32_t>(backend.ListDatasets().size()));
        ModelCount(static_cast<int32_t>(backend.ListModels().size()));

        auto sessions = backend.GetTrainingManager().ActiveSessions();
        bool training = false;
        for (const auto& [id, session] : sessions)
        {
            if (session.status == TrainingStatus::Training ||
                session.status == TrainingStatus::Preparing)
            {
                training = true;
                break;
            }
        }
        IsTrainingActive(training);
    }

    winrt::event_token HomeViewModel::PropertyChanged(
        Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler)
    {
        return m_propertyChanged.add(handler);
    }

    void HomeViewModel::PropertyChanged(winrt::event_token const& token)
    {
        m_propertyChanged.remove(token);
    }

    void HomeViewModel::RaisePropertyChanged(winrt::hstring const& name)
    {
        m_propertyChanged(*this,
            Microsoft::UI::Xaml::Data::PropertyChangedEventArgs(name));
    }
}
