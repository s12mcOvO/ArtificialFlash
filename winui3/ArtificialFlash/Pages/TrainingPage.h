#pragma once
#include "TrainingPage.g.h"
#include "../ViewModels/TrainingViewModel.h"

namespace winrt::ArtificialFlash::implementation
{
    struct TrainingPage : TrainingPageT<TrainingPage>
    {
        TrainingPage();
        ArtificialFlash::TrainingViewModel ViewModel() { return m_viewModel; }

        void OnStartTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnPauseTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnResumeTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnStopTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        ArtificialFlash::TrainingViewModel m_viewModel;
        Windows::Foundation::Collections::IVector<winrt::hstring>
            m_logs = winrt::single_threaded_observable_vector<winrt::hstring>();
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct TrainingPage : TrainingPageT<TrainingPage, implementation::TrainingPage> {};
}
