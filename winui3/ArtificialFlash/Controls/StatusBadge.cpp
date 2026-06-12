#include "pch.h"
#include "StatusBadge.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    DependencyProperty StatusBadge::m_statusProperty =
        DependencyProperty::Register(
            L"Status",
            winrt::xaml_typename<winrt::hstring>(),
            winrt::xaml_typename<ArtificialFlash::StatusBadge>(),
            PropertyMetadata{ box_value(L"") }
        );
}
