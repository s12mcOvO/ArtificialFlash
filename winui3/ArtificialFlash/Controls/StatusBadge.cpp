#include "pch.h"
#include "StatusBadge.h"

namespace winrt::ArtificialFlash::implementation
{
    Microsoft::UI::Xaml::DependencyProperty StatusBadge::m_statusProperty =
        Microsoft::UI::Xaml::DependencyProperty::Register(
            L"Status",
            xaml_typename<winrt::hstring>(),
            xaml_typename<ArtificialFlash::StatusBadge>(),
            Microsoft::UI::Xaml::PropertyMetadata{ box_value(L"") }
        );
}
