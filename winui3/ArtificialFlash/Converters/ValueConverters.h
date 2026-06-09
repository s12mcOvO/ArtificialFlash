#pragma once
#include "ValueConverters.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct BoolToVisibilityConverter : BoolToVisibilityConverterT<BoolToVisibilityConverter>
    {
        BoolToVisibilityConverter() = default;
        Windows::Foundation::IInspectable Convert(
            Windows::Foundation::IInspectable const& value,
            Windows::UI::Xaml::Interop::TypeName const& targetType,
            Windows::Foundation::IInspectable const& parameter,
            winrt::hstring const& language);
        Windows::Foundation::IInspectable ConvertBack(
            Windows::Foundation::IInspectable const& value,
            Windows::UI::Xaml::Interop::TypeName const& targetType,
            Windows::Foundation::IInspectable const& parameter,
            winrt::hstring const& language);
    };

    struct InverseBoolConverter : InverseBoolConverterT<InverseBoolConverter>
    {
        InverseBoolConverter() = default;
        Windows::Foundation::IInspectable Convert(
            Windows::Foundation::IInspectable const& value,
            Windows::UI::Xaml::Interop::TypeName const& targetType,
            Windows::Foundation::IInspectable const& parameter,
            winrt::hstring const& language);
        Windows::Foundation::IInspectable ConvertBack(
            Windows::Foundation::IInspectable const& value,
            Windows::UI::Xaml::Interop::TypeName const& targetType,
            Windows::Foundation::IInspectable const& parameter,
            winrt::hstring const& language);
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct BoolToVisibilityConverter :
        BoolToVisibilityConverterT<BoolToVisibilityConverter, implementation::BoolToVisibilityConverter> {};
    struct InverseBoolConverter :
        InverseBoolConverterT<InverseBoolConverter, implementation::InverseBoolConverter> {};
}
