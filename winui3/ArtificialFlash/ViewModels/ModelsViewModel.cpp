#include "pch.h"
#include "ModelsViewModel.h"
#include "../Backend/BackendService.h"

using ::ArtificialFlash::Backend::BackendService;

namespace winrt::ArtificialFlash::implementation
{
    Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable>
        ModelsViewModel::Models()
    {
        return m_models;
    }

    void ModelsViewModel::Refresh()
    {
        m_models.Clear();
        auto& backend = BackendService::Instance();
        for (const auto& model : backend.ListModels())
        {
            auto obj = winrt::Windows::Foundation::PropertyValue::CreateString(
                winrt::hstring(model.name + L" (" + model.type + L")"));
            m_models.Append(obj);
        }
        RaisePropertyChanged(L"Models");
    }

    void ModelsViewModel::CreateModel(winrt::hstring const& name,
        winrt::hstring const& type)
    {
        auto& backend = BackendService::Instance();
        backend.CreateModel(name.c_str(), type.c_str(), L"", L"", {});
        Refresh();
    }

    void ModelsViewModel::DeleteModel(winrt::hstring const& id)
    {
        auto& backend = BackendService::Instance();
        backend.DeleteModel(id.c_str());
        Refresh();
    }

    winrt::event_token ModelsViewModel::PropertyChanged(
        Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler)
    {
        return m_propertyChanged.add(handler);
    }

    void ModelsViewModel::PropertyChanged(winrt::event_token const& token)
    {
        m_propertyChanged.remove(token);
    }

    void ModelsViewModel::RaisePropertyChanged(winrt::hstring const& name)
    {
        m_propertyChanged(*this,
            Microsoft::UI::Xaml::Data::PropertyChangedEventArgs(name));
    }
}
