#pragma once
#include <string>
#include <vector>
#include "../Backend/BackendService.h"

namespace ArtificialFlash
{
    class ModelsViewModel
    {
    public:
        ModelsViewModel();
        ~ModelsViewModel() = default;

        void Refresh();
        void CreateModel(winrt::hstring const& name, winrt::hstring const& type);
        void DeleteModel(winrt::hstring const& id);

    private:
    };
}
