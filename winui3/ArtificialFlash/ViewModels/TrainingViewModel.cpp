#include "pch.h"
#include "TrainingViewModel.h"

using ::ArtificialFlash::Backend::BackendService;

namespace ArtificialFlash
{
    TrainingViewModel::TrainingViewModel()
    {
        auto& backend = BackendService::Instance();
        backend.SetTrainingCallback([this](const ::ArtificialFlash::Models::TrainingLog& log)
        {
            m_progress = static_cast<double>(log.epoch) / (log.epoch + 1);
            m_currentLoss = log.loss;
            m_currentAccuracy = log.accuracy;
            m_statusText = winrt::hstring(L"Epoch " + std::to_wstring(log.epoch) +
                L": loss=" + std::to_wstring(log.loss) +
                L", acc=" + std::to_wstring(log.accuracy));
        });
    }

    void TrainingViewModel::StartTraining(winrt::hstring const& modelId)
    {
        auto& backend = BackendService::Instance();
        m_currentSessionId = backend.StartTraining(modelId.c_str());
        if (!m_currentSessionId.empty())
            m_statusText = L"Training started...";
        else
            m_statusText = L"Failed to start training";
    }

    void TrainingViewModel::PauseTraining()
    {
        if (!m_currentSessionId.empty())
        {
            BackendService::Instance().PauseTraining(m_currentSessionId);
            m_statusText = L"Paused";
        }
    }

    void TrainingViewModel::ResumeTraining()
    {
        if (!m_currentSessionId.empty())
        {
            BackendService::Instance().ResumeTraining(m_currentSessionId);
            m_statusText = L"Resumed";
        }
    }

    void TrainingViewModel::StopTraining()
    {
        if (!m_currentSessionId.empty())
        {
            BackendService::Instance().StopTraining(m_currentSessionId);
            m_statusText = L"Stopped";
        }
    }

    void TrainingViewModel::Refresh()
    {
        if (!m_currentSessionId.empty())
        {
            auto session = BackendService::Instance()
                .GetTrainingSession(m_currentSessionId);
            m_progress = session.progress;
            m_currentLoss = session.currentLoss;
            m_currentAccuracy = session.currentAccuracy;
        }
    }
}
