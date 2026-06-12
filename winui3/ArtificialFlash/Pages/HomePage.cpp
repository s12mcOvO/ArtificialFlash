#include "pch.h"
#include "HomePage.h"

using namespace Microsoft::UI::Xaml;
using namespace Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    HomePage::HomePage()
    {
        m_viewModel = *winrt::make<ArtificialFlash::implementation::HomeViewModel>();
        m_viewModel.Refresh();

        auto stack = StackPanel();
        stack.Margin(Thickness{ 16, 16, 16, 16 });

        auto title = TextBlock();
        title.Text(L"ArtificialFlash");
        title.Style(Controls::TextStyle::TitleLarge);
        title.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(title);

        auto statusText = TextBlock();
        statusText.Text(L"Backend: " + m_viewModel.BackendStatus());
        statusText.Margin(Thickness{ 0, 0, 0, 8 });
        stack.Children().Append(statusText);

        auto datasetsText = TextBlock();
        datasetsText.Text(L"Datasets: " + winrt::to_hstring(m_viewModel.DatasetCount()));
        datasetsText.Margin(Thickness{ 0, 0, 0, 8 });
        stack.Children().Append(datasetsText);

        auto modelsText = TextBlock();
        modelsText.Text(L"Models: " + winrt::to_hstring(m_viewModel.ModelCount()));
        modelsText.Margin(Thickness{ 0, 0, 0, 16 });
        stack.Children().Append(modelsText);

        auto newDatasetBtn = Button();
        newDatasetBtn.Content(box_value(L"New Dataset"));
        newDatasetBtn.Margin(Thickness{ 0, 0, 0, 8 });
        stack.Children().Append(newDatasetBtn);

        auto newModelBtn = Button();
        newModelBtn.Content(box_value(L"New Model"));
        newModelBtn.Margin(Thickness{ 0, 0, 0, 8 });
        stack.Children().Append(newModelBtn);

        auto trainBtn = Button();
        trainBtn.Content(box_value(L"Start Training"));
        stack.Children().Append(trainBtn);

        Content(stack);
    }

    void HomePage::OnNewDataset(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }

    void HomePage::OnNewModel(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }

    void HomePage::OnStartTraining(
        Windows::Foundation::IInspectable const&,
        RoutedEventArgs const&)
    {
    }
}
