#pragma once
#include "HomePage.g.h"
#include "../ViewModels/HomeViewModel.h"

namespace winrt::ArtificialFlash::implementation
{
    struct HomePage : HomePageT<HomePage>
    {
        HomePage();
        ArtificialFlash::HomeViewModel ViewModel() { return m_viewModel; }

        void OnNewDataset(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnNewModel(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnStartTraining(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);

    private:
        ArtificialFlash::HomeViewModel m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct HomePage : HomePageT<HomePage, implementation::HomePage> {};
}
