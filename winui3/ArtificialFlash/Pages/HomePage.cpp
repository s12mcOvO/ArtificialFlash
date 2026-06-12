#include "pch.h"
#include "HomePage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    HomePage::HomePage()
    {
        auto vmImpl = winrt::make_self<ArtificialFlash::implementation::HomeViewModel>();
        vmImpl->Refresh();
        m_viewModel = vmImpl.as<ArtificialFlash::HomeViewModel>();

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
