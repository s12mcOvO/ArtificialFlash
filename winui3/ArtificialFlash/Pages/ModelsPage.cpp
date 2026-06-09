#include "pch.h"
#include "ModelsPage.h"
#include "ModelConfigPage.h"

namespace winrt::ArtificialFlash::implementation
{
    ModelsPage::ModelsPage()
    {
        InitializeComponent();
        m_viewModel = *winrt::make<ArtificialFlash::implementation::ModelsViewModel>();
        m_viewModel.Refresh();
    }

    void ModelsPage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto frame = Parent().as<Microsoft::UI::Xaml::Controls::Frame>();
        if (frame)
            frame.Navigate(xaml_typename<ArtificialFlash::ModelConfigPage>());
    }

    void ModelsPage::OnModelClick(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::Controls::ItemClickEventArgs const&)
    {
        // TODO: Show model details flyout
    }
}
