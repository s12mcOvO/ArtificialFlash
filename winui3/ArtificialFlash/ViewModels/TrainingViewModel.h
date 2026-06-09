#pragma once
#include "TrainingViewModel.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct TrainingViewModel : TrainingViewModelT<TrainingViewModel>
    {
        TrainingViewModel();

        double Progress();
        void Progress(double value);
        double CurrentLoss();
        void CurrentLoss(double value);
        double CurrentAccuracy();
        void CurrentAccuracy(double value);
        winrt::hstring StatusText();
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

namespace winrt::ArtificialFlash::factory_implementation
{
    struct TrainingViewModel : TrainingViewModelT<TrainingViewModel, implementation::TrainingViewModel> {};
}
