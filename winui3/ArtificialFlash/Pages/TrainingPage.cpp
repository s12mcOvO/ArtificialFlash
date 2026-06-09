#include "pch.h"
#include "TrainingPage.h"
#include "../Backend/BackendService.h"

namespace winrt::ArtificialFlash::implementation
{
    TrainingPage::TrainingPage()
    {
        InitializeComponent();
        m_viewModel = *winrt::make<ArtificialFlash::implementation::TrainingViewModel>();

        TrainingLogs().ItemsSource(m_logs);

        // Load models into selector
        auto& backend = Backend::BackendService::Instance();
        for (const auto& m : backend.ListModels())
        {
            ModelSelector().Items().Append(
                winrt::box_value(winrt::hstring(m.name + L" (" + m.id + L")")));
        }
        if (ModelSelector().Items().Size() > 0)
            ModelSelector().SelectedIndex(0);
    }

    void TrainingPage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto& backend = Backend::BackendService::Instance();
        auto models = backend.ListModels();
        int idx = ModelSelector().SelectedIndex();
        if (idx >= 0 && idx < static_cast<int>(models.size()))
        {
            m_viewModel.StartTraining(winrt::hstring(models[idx].id));
            m_logs.Append(winrt::hstring(
                L"Training started for: " + models[idx].name));
        }
    }

    void TrainingPage::OnPauseTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        m_viewModel.PauseTraining();
    }

    void TrainingPage::OnResumeTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        m_viewModel.ResumeTraining();
    }

    void TrainingPage::OnStopTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        m_viewModel.StopTraining();
    }
}
