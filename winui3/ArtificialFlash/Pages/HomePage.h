#pragma once
#include <memory>
#include "../ViewModels/HomeViewModel.h"
#include "HomePage.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct HomePage : HomePageT<HomePage>
    {
        HomePage();

        void OnNewDataset(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnNewModel(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnStartTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        std::shared_ptr<::ArtificialFlash::HomeViewModel> m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct HomePage : HomePageT<HomePage, implementation::HomePage> {};
}
