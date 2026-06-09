#include "pch.h"
#include "MainWindow.h"
#include "Pages/HomePage.h"
#include "Pages/DataPage.h"
#include "Pages/ModelsPage.h"
#include "Pages/TrainingPage.h"
#include "Pages/SettingsPage.h"

using namespace winrt;
using namespace Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    MainWindow::MainWindow()
    {
        InitializeComponent();
        Title(L"ArtificialFlash \u80FD\u5DE5\u667A\u4EBA");
    }

    void MainWindow::OnNavLoaded(
        IInspectable const&,
        IInspectable const&)
    {
        AppNavView().SelectedItem(NavHome());
        NavigateToPage(L"home");
    }

    void MainWindow::OnNavigationChanged(
        NavigationView const&,
        NavigationViewSelectionChangedEventArgs const& args)
    {
        auto selectedItem = args.SelectedItem().try_as<NavigationViewItem>();
        if (selectedItem)
        {
            auto tag = selectedItem.Tag().as<winrt::hstring>();
            NavigateToPage(tag);
        }
    }

    void MainWindow::NavigateToPage(winrt::hstring const& tag)
    {
        Windows::UI::Xaml::Interop::TypeName pageType;

        if (tag == L"home")
            pageType = xaml_typename<ArtificialFlash::HomePage>();
        else if (tag == L"data")
            pageType = xaml_typename<ArtificialFlash::DataPage>();
        else if (tag == L"models")
            pageType = xaml_typename<ArtificialFlash::ModelsPage>();
        else if (tag == L"training")
            pageType = xaml_typename<ArtificialFlash::TrainingPage>();
        else if (tag == L"settings")
            pageType = xaml_typename<ArtificialFlash::SettingsPage>();
        else
            pageType = xaml_typename<ArtificialFlash::HomePage>();

        ContentFrame().Navigate(pageType, nullptr);
    }
}
