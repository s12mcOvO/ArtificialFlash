#include "pch.h"
#include "ModelsViewModel.h"

using ::ArtificialFlash::Backend::BackendService;

namespace ArtificialFlash
{
    ModelsViewModel::ModelsViewModel()
    {
        Refresh();
    }

    void ModelsViewModel::Refresh()
    {
        auto& backend = BackendService::Instance();
        backend.ListModels();
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
}
