#pragma once
#include <string>
#include <winrt/Microsoft.UI.Xaml.Data.h>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class TrainingViewModel
    {
    public:
        TrainingViewModel();
        ~TrainingViewModel() = default;

        double Progress() const { return m_progress; }
        void Progress(double value);
        double CurrentLoss() const { return m_currentLoss; }
        void CurrentLoss(double value);
        double CurrentAccuracy() const { return m_currentAccuracy; }
        void CurrentAccuracy(double value);
        winrt::hstring StatusText() const { return m_statusText; }
        void StatusText(winrt::hstring const& value);

        void StartTraining(winrt::hstring const& modelId);
        void PauseTraining();
        void ResumeTraining();
        void StopTraining();
        void Refresh();

        winrt::event_token PropertyChanged(
            Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler);
        void PropertyChanged(winrt::event_token const& token);

    private:
        double m_progress = 0.0;
        double m_currentLoss = 0.0;
        double m_currentAccuracy = 0.0;
        winrt::hstring m_statusText = L"Ready";
        std::wstring m_currentSessionId;
        winrt::event<Microsoft::UI::Xaml::Data::PropertyChangedEventHandler> m_propertyChanged;

        void RaisePropertyChanged(winrt::hstring const& name);
    };
}
