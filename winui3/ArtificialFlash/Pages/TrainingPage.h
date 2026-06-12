#pragma once
#include <memory>
#include "../ViewModels/TrainingViewModel.h"
#include "TrainingPage.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct TrainingPage : TrainingPageT<TrainingPage>
    {
        TrainingPage();

        void OnStartTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnPauseTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnResumeTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnStopTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        std::shared_ptr<::ArtificialFlash::TrainingViewModel> m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct TrainingPage : TrainingPageT<TrainingPage, implementation::TrainingPage> {};
}
