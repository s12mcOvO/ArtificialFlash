#include "pch.h"
#include "TrainingChart.h"

namespace winrt::ArtificialFlash::implementation
{
    Microsoft::UI::Xaml::DependencyProperty TrainingChart::m_lossProperty =
        Microsoft::UI::Xaml::DependencyProperty::Register(
            L"LossValues",
            xaml_typename<Windows::Foundation::Collections::IVector<double>>(),
            xaml_typename<ArtificialFlash::TrainingChart>(),
            Microsoft::UI::Xaml::PropertyMetadata{ nullptr }
        );

    Microsoft::UI::Xaml::DependencyProperty TrainingChart::m_accuracyProperty =
        Microsoft::UI::Xaml::DependencyProperty::Register(
            L"AccuracyValues",
            xaml_typename<Windows::Foundation::Collections::IVector<double>>(),
            xaml_typename<ArtificialFlash::TrainingChart>(),
            Microsoft::UI::Xaml::PropertyMetadata{ nullptr }
        );

    TrainingChart::TrainingChart()
    {
        DefaultStyleKey(box_value(L"ArtificialFlash.TrainingChart"));
        LossValues(winrt::single_threaded_vector<double>());
        AccuracyValues(winrt::single_threaded_vector<double>());
    }
}
