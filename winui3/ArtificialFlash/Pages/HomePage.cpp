#include "pch.h"
#include "HomePage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    HomePage::HomePage()
    {
        m_viewModel = *make<ArtificialFlash::implementation::HomeViewModel>();
        m_viewModel.Refresh();

        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"ArtificialFlash");
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        Content(stack);
    }

    void HomePage::OnNewDataset(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}

    void HomePage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}

    void HomePage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&) {}
}
