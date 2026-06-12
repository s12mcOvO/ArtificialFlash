#include "pch.h"
#include "TrainingPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    TrainingPage::TrainingPage()
    {
        m_viewModel = make<ArtificialFlash::implementation::TrainingViewModel>();

        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"Training");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        auto startBtn = Button();
        startBtn.Content(box_value(L"Start Training"));
        stack.Children().Append(startBtn);

        Content(stack);
    }

    void TrainingPage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
    void TrainingPage::OnPauseTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
    void TrainingPage::OnResumeTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
    void TrainingPage::OnStopTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
}
