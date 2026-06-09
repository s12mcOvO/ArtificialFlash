#pragma once
#include "ModelsViewModel.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct ModelsViewModel : ModelsViewModelT<ModelsViewModel>
    {
        ModelsViewModel() = default;

        Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable> Models();
        void Refresh();
        void CreateModel(winrt::hstring const& name, winrt::hstring const& type);
        void DeleteModel(winrt::hstring const& id);

        winrt::event_token PropertyChanged(
            Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler);
        void PropertyChanged(winrt::event_token const& token);

    private:
        Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable>
            m_models = winrt::single_threaded_observable_vector<Windows::Foundation::IInspectable>();
        winrt::event<Microsoft::UI::Xaml::Data::PropertyChangedEventHandler> m_propertyChanged;

        void RaisePropertyChanged(winrt::hstring const& name);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct ModelsViewModel : ModelsViewModelT<ModelsViewModel, implementation::ModelsViewModel> {};
}
