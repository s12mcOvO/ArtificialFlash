#pragma once
#include <winrt/Microsoft.UI.Xaml.h>
#include <winrt/Microsoft.UI.Xaml.Controls.h>
#include <winrt/Microsoft.UI.Xaml.Media.h>
#include <winrt/Microsoft.UI.Xaml.Media.Imaging.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>
#include "StatusBadge.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct StatusBadge : StatusBadgeT<StatusBadge>
    {
        StatusBadge() = default;

        winrt::hstring Status() { return m_status; }
        void Status(winrt::hstring const& value) { m_status = value; }

    private:
        winrt::hstring m_status;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct StatusBadge : StatusBadgeT<StatusBadge, implementation::StatusBadge> {};
}
