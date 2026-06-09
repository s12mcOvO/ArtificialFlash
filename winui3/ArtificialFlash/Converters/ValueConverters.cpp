#include "pch.h"
#include "ValueConverters.h"

namespace winrt::ArtificialFlash::implementation
{
    Windows::Foundation::IInspectable BoolToVisibilityConverter::Convert(
        Windows::Foundation::IInspectable const& value,
        Windows::UI::Xaml::Interop::TypeName const&,
        Windows::Foundation::IInspectable const&,
        winrt::hstring const&)
    {
        if (auto b = value.try_as<bool>())
        {
            return *b ?
                Microsoft::UI::Xaml::Visibility::Visible :
                Microsoft::UI::Xaml::Visibility::Collapsed;
        }
        return Microsoft::UI::Xaml::Visibility::Collapsed;
    }

    Windows::Foundation::IInspectable BoolToVisibilityConverter::ConvertBack(
        Windows::Foundation::IInspectable const&,
        Windows::UI::Xaml::Interop::TypeName const&,
        Windows::Foundation::IInspectable const&,
        winrt::hstring const&)
    {
        throw winrt::hresult_not_implemented();
    }

    Windows::Foundation::IInspectable InverseBoolConverter::Convert(
        Windows::Foundation::IInspectable const& value,
        Windows::UI::Xaml::Interop::TypeName const&,
        Windows::Foundation::IInspectable const&,
        winrt::hstring const&)
    {
        if (auto b = value.try_as<bool>())
            return winrt::box_value(!*b);
        return winrt::box_value(false);
    }

    Windows::Foundation::IInspectable InverseBoolConverter::ConvertBack(
        Windows::Foundation::IInspectable const&,
        Windows::UI::Xaml::Interop::TypeName const&,
        Windows::Foundation::IInspectable const&,
        winrt::hstring const&)
    {
        throw winrt::hresult_not_implemented();
    }
}
