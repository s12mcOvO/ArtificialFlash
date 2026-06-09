#pragma once
#include "ModelConfigPage.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct ModelConfigPage : ModelConfigPageT<ModelConfigPage>
    {
        ModelConfigPage();

        void OnCreateModel(Windows::Foundation::IInspectable const&,
            Microsoft::UI::Xaml::RoutedEventArgs const&);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct ModelConfigPage : ModelConfigPageT<ModelConfigPage, implementation::ModelConfigPage> {};
}
