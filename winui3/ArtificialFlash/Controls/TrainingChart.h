#pragma once
#include <winrt/Microsoft.UI.Xaml.h>
#include <winrt/Microsoft.UI.Xaml.Controls.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Foundation.Collections.h>
#include "TrainingChart.g.h"

namespace winrt::ArtificialFlash::implementation
{
    struct TrainingChart : TrainingChartT<TrainingChart>
    {
        TrainingChart();

        Windows::Foundation::Collections::IVector<double> LossValues() { return m_lossValues; }
        void LossValues(Windows::Foundation::Collections::IVector<double> const& value) { m_lossValues = value; }

        Windows::Foundation::Collections::IVector<double> AccuracyValues() { return m_accuracyValues; }
        void AccuracyValues(Windows::Foundation::Collections::IVector<double> const& value) { m_accuracyValues = value; }

    private:
        Windows::Foundation::Collections::IVector<double> m_lossValues{ nullptr };
        Windows::Foundation::Collections::IVector<double> m_accuracyValues{ nullptr };
    };
}

namespace winrt::ArtificialFlash::factory_implementation
{
    struct TrainingChart : TrainingChartT<TrainingChart, implementation::TrainingChart> {};
}
