#include "pch.h"
#include "HomePage.h"

namespace winrt::ArtificialFlash::implementation
{
    HomePage::HomePage()
    {
        InitializeComponent();
        m_viewModel = *winrt::make<ArtificialFlash::implementation::HomeViewModel>();
        m_viewModel.Refresh();
    }

    void HomePage::OnNewDataset(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto frame = Parent().as<Microsoft::UI::Xaml::Controls::Frame>();
        if (frame)
            frame.Navigate(xaml_typename<ArtificialFlash::DataPage>());
    }

    void HomePage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto frame = Parent().as<Microsoft::UI::Xaml::Controls::Frame>();
        if (frame)
            frame.Navigate(xaml_typename<ArtificialFlash::ModelConfigPage>());
    }

    void HomePage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto frame = Parent().as<Microsoft::UI::Xaml::Controls::Frame>();
        if (frame)
            frame.Navigate(xaml_typename<ArtificialFlash::TrainingPage>());
    }
}
