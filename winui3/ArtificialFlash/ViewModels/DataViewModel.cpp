#include "pch.h"
#include "DataViewModel.h"

using ::ArtificialFlash::Backend::BackendService;

namespace ArtificialFlash
{
    DataViewModel::DataViewModel()
    {
        Refresh();
    }

    void DataViewModel::Refresh()
    {
        auto& backend = BackendService::Instance();
        backend.ListDatasets();
    }

    void DataViewModel::AddDataset(winrt::hstring const& name,
        winrt::hstring const& path, winrt::hstring const& type)
    {
        auto& backend = BackendService::Instance();
        backend.CreateDataset(name.c_str(), path.c_str(), type.c_str());
        Refresh();
    }

    void DataViewModel::DeleteDataset(winrt::hstring const& id)
    {
        auto& backend = BackendService::Instance();
        backend.DeleteDataset(id.c_str());
        Refresh();
    }
}
