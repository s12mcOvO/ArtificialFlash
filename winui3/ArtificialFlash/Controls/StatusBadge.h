#pragma once
#include "StatusBadge.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct StatusBadge : StatusBadgeT<StatusBadge>
    {
        StatusBadge() { DefaultStyleKey(box_value(L"ArtificialFlash.StatusBadge")); }

        winrt::hstring Status() { return GetValue(m_statusProperty).as<winrt::hstring>(); }
        void Status(winrt::hstring const& value) { SetValue(m_statusProperty, box_value(value)); }

        static Microsoft::UI::Xaml::DependencyProperty StatusProperty() { return m_statusProperty; }

    private:
        static Microsoft::UI::Xaml::DependencyProperty m_statusProperty;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct StatusBadge : StatusBadgeT<StatusBadge, implementation::StatusBadge> {};
}
