#pragma once
#include "ModelsPage.g.h"
#include "../ViewModels/ModelsViewModel.h"

namespace winrt::ArtificialFlash::implementation
{
    struct ModelsPage : ModelsPageT<ModelsPage>
    {
        ModelsPage();
        ArtificialFlash::ModelsViewModel ViewModel() { return m_viewModel; }

        void OnNewModel(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnModelClick(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::Controls::ItemClickEventArgs const&);

    private:
        ArtificialFlash::ModelsViewModel m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct ModelsPage : ModelsPageT<ModelsPage, implementation::ModelsPage> {};
}
