#pragma once
#include <string>
#include <vector>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class DataViewModel
    {
    public:
        DataViewModel();
        ~DataViewModel() = default;

        void Refresh();
        void AddDataset(winrt::hstring const& name, winrt::hstring const& path, winrt::hstring const& type);
        void DeleteDataset(winrt::hstring const& id);

    private:
    };
}
