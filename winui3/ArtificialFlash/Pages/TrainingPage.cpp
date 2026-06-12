#include "pch.h"
#include "TrainingPage.h"
#include "../Backend/BackendService.h"

using namespace Microsoft::UI::Xaml;

namespace winrt::ArtificialFlash::implementation
{
    TrainingPage::TrainingPage()
    {
        m_viewModel = *winrt::make<ArtificialFlash::implementation::TrainingViewModel>();

        auto stack = Controls::StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = Controls::TextBlock();
        title.Text(L"Training");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        auto startBtn = Controls::Button();
        startBtn.Content(box_value(L"Start Training"));
        startBtn.Margin(Thickness{ 0, 0, 0, 8 });
        stack.Children().Append(startBtn);

        auto stopBtn = Controls::Button();
        stopBtn.Content(box_value(L"Stop Training"));
        stack.Children().Append(stopBtn);

        Content(stack);
    }

    void TrainingPage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void TrainingPage::OnPauseTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void TrainingPage::OnResumeTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }

    void TrainingPage::OnStopTraining(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
    }
}
