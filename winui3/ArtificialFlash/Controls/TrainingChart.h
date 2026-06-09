#pragma once
#include "TrainingChart.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct TrainingChart : TrainingChartT<TrainingChart>
    {
        TrainingChart();

        Windows::Foundation::Collections::IVector<double> LossValues()
        { return GetValue(m_lossProperty).as<Windows::Foundation::Collections::IVector<double>>(); }
        void LossValues(Windows::Foundation::Collections::IVector<double> const& value)
        { SetValue(m_lossProperty, value); }

        Windows::Foundation::Collections::IVector<double> AccuracyValues()
        { return GetValue(m_accuracyProperty).as<Windows::Foundation::Collections::IVector<double>>(); }
        void AccuracyValues(Windows::Foundation::Collections::IVector<double> const& value)
        { SetValue(m_accuracyProperty, value); }

        static Microsoft::UI::Xaml::DependencyProperty LossValuesProperty() { return m_lossProperty; }
        static Microsoft::UI::Xaml::DependencyProperty AccuracyValuesProperty() { return m_accuracyProperty; }

    private:
        static Microsoft::UI::Xaml::DependencyProperty m_lossProperty;
        static Microsoft::UI::Xaml::DependencyProperty m_accuracyProperty;
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct TrainingChart : TrainingChartT<TrainingChart, implementation::TrainingChart> {};
}
