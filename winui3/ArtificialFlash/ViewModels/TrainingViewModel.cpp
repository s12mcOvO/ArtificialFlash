#include "pch.h"
#include "TrainingViewModel.h"
#include "../Backend/BackendService.h"

namespace winrt::ArtificialFlash::implementation
{
    TrainingViewModel::TrainingViewModel()
    {
        auto& backend = Backend::BackendService::Instance();
        backend.SetTrainingCallback([this](const Models::TrainingLog& log)
        {
            Progress(static_cast<double>(log.epoch) /
                (log.epoch + 1));
            CurrentLoss(log.loss);
            CurrentAccuracy(log.accuracy);
            auto msg = L"Epoch " + std::to_wstring(log.epoch) +
                L": loss=" + std::to_wstring(log.loss) +
                L", acc=" + std::to_wstring(log.accuracy);
            StatusText(winrt::hstring(msg));
        });
    }

    double TrainingViewModel::Progress() { return m_progress; }
    void TrainingViewModel::Progress(double value)
    {
        if (m_progress != value) { m_progress = value; RaisePropertyChanged(L"Progress"); }
    }

    double TrainingViewModel::CurrentLoss() { return m_currentLoss; }
    void TrainingViewModel::CurrentLoss(double value)
    {
        if (m_currentLoss != value) { m_currentLoss = value; RaisePropertyChanged(L"CurrentLoss"); }
    }

    double TrainingViewModel::CurrentAccuracy() { return m_currentAccuracy; }
    void TrainingViewModel::CurrentAccuracy(double value)
    {
        if (m_currentAccuracy != value) { m_currentAccuracy = value; RaisePropertyChanged(L"CurrentAccuracy"); }
    }

    winrt::hstring TrainingViewModel::StatusText() { return m_statusText; }
    void TrainingViewModel::StatusText(winrt::hstring const& value)
    {
        if (m_statusText != value) { m_statusText = value; RaisePropertyChanged(L"StatusText"); }
    }

    void TrainingViewModel::StartTraining(winrt::hstring const& modelId)
    {
        auto& backend = Backend::BackendService::Instance();
        m_currentSessionId = backend.StartTraining(modelId.c_str());
        if (!m_currentSessionId.empty())
            StatusText(L"Training started...");
        else
            StatusText(L"Failed to start training");
    }

    void TrainingViewModel::PauseTraining()
    {
        if (!m_currentSessionId.empty())
        {
            Backend::BackendService::Instance().PauseTraining(m_currentSessionId);
            StatusText(L"Paused");
        }
    }

    void TrainingViewModel::ResumeTraining()
    {
        if (!m_currentSessionId.empty())
        {
            Backend::BackendService::Instance().ResumeTraining(m_currentSessionId);
            StatusText(L"Resumed");
        }
    }

    void TrainingViewModel::StopTraining()
    {
        if (!m_currentSessionId.empty())
        {
            Backend::BackendService::Instance().StopTraining(m_currentSessionId);
            StatusText(L"Stopped");
        }
    }

    void TrainingViewModel::Refresh()
    {
        if (!m_currentSessionId.empty())
        {
            auto session = Backend::BackendService::Instance()
                .GetTrainingSession(m_currentSessionId);
            Progress(session.progress);
            CurrentLoss(session.currentLoss);
            CurrentAccuracy(session.currentAccuracy);
        }
    }

    winrt::event_token TrainingViewModel::PropertyChanged(
        Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler)
    {
        return m_propertyChanged.add(handler);
    }

    void TrainingViewModel::PropertyChanged(winrt::event_token const& token)
    {
        m_propertyChanged.remove(token);
    }

    void TrainingViewModel::RaisePropertyChanged(winrt::hstring const& name)
    {
        m_propertyChanged(*this,
            Microsoft::UI::Xaml::Data::PropertyChangedEventArgs(name));
    }
}
