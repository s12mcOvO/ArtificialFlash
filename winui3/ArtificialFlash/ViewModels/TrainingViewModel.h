#pragma once
#include <string>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class TrainingViewModel
    {
    public:
        TrainingViewModel();
        ~TrainingViewModel() = default;

        void StartTraining(winrt::hstring const& modelId);
        void PauseTraining();
        void ResumeTraining();
        void StopTraining();
        void Refresh();

        double Progress() const { return m_progress; }
        double CurrentLoss() const { return m_currentLoss; }
        double CurrentAccuracy() const { return m_currentAccuracy; }
        winrt::hstring StatusText() const { return m_statusText; }

    private:
        double m_progress = 0.0;
        double m_currentLoss = 0.0;
        double m_currentAccuracy = 0.0;
        winrt::hstring m_statusText = L"Ready";
        std::wstring m_currentSessionId;
    };
}
