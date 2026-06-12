#pragma once
#include <memory>
#include "../ViewModels/ModelsViewModel.h"
#include "ModelsPage.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct ModelsPage : ModelsPageT<ModelsPage>
    {
        ModelsPage();

        void OnNewModel(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
        void OnModelClick(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::Controls::ItemClickEventArgs const&);

    private:
        std::shared_ptr<::ArtificialFlash::ModelsViewModel> m_viewModel;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct ModelsPage : ModelsPageT<ModelsPage, implementation::ModelsPage> {};
}
