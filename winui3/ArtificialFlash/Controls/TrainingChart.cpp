#include "pch.h"
#include "TrainingChart.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    DependencyProperty TrainingChart::m_lossProperty =
        DependencyProperty::Register(
            L"LossValues",
            winrt::xaml_typename<Windows::Foundation::Collections::IVector<double>>(),
            winrt::xaml_typename<ArtificialFlash::TrainingChart>(),
            PropertyMetadata{ nullptr }
        );

    DependencyProperty TrainingChart::m_accuracyProperty =
        DependencyProperty::Register(
            L"AccuracyValues",
            winrt::xaml_typename<Windows::Foundation::Collections::IVector<double>>(),
            winrt::xaml_typename<ArtificialFlash::TrainingChart>(),
            PropertyMetadata{ nullptr }
        );

    TrainingChart::TrainingChart()
    {
        LossValues(winrt::single_threaded_vector<double>());
        AccuracyValues(winrt::single_threaded_vector<double>());
    }
}
