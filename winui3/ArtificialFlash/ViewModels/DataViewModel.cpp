#include "pch.h"
#include "DataViewModel.h"
#include "../Backend/BackendService.h"
#include "../Models/Dataset.h"

namespace winrt::ArtificialFlash::implementation
{
    Windows::Foundation::Collections::IVector<Windows::Foundation::IInspectable>
        DataViewModel::Datasets()
    {
        return m_datasets;
    }

    void DataViewModel::Refresh()
    {
        m_datasets.Clear();
        auto& backend = Backend::BackendService::Instance();
        for (const auto& ds : backend.ListDatasets())
        {
            auto obj = winrt::Windows::Foundation::PropertyValue::CreateString(
                winrt::hstring(ds.name));
            m_datasets.Append(obj);
        }
        RaisePropertyChanged(L"Datasets");
    }

    void DataViewModel::AddDataset(winrt::hstring const& name,
        winrt::hstring const& path, winrt::hstring const& type)
    {
        auto& backend = Backend::BackendService::Instance();
        backend.CreateDataset(name.c_str(), path.c_str(), type.c_str());
        Refresh();
    }

    void DataViewModel::DeleteDataset(winrt::hstring const& id)
    {
        auto& backend = Backend::BackendService::Instance();
        backend.DeleteDataset(id.c_str());
        Refresh();
    }

    winrt::event_token DataViewModel::PropertyChanged(
        Microsoft::UI::Xaml::Data::PropertyChangedEventHandler const& handler)
    {
        return m_propertyChanged.add(handler);
    }

    void DataViewModel::PropertyChanged(winrt::event_token const& token)
    {
        m_propertyChanged.remove(token);
    }

    void DataViewModel::RaisePropertyChanged(winrt::hstring const& name)
    {
        m_propertyChanged(*this,
            Microsoft::UI::Xaml::Data::PropertyChangedEventArgs(name));
    }
}
