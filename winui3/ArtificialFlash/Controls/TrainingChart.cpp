#include "pch.h"
#include "TrainingChart.h"

namespace winrt::ArtificialFlash::implementation
{
    TrainingChart::TrainingChart()
    {
        m_lossValues = winrt::single_threaded_vector<double>();
        m_accuracyValues = winrt::single_threaded_vector<double>();
    }
}
