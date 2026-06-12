#include "pch.h"
#include "MainWindow.h"
#include "Pages/HomePage.h"
#include "Pages/DataPage.h"
#include "Pages/ModelsPage.h"
#include "Pages/TrainingPage.h"
#include "Pages/SettingsPage.h"

using namespace winrt;
using namespace Microsoft::UI::Xaml;
using namespace Microsoft::UI::Xaml::Controls;

namespace winrt::ArtificialFlash::implementation
{
    MainWindow::MainWindow()
    {
        Title(L"ArtificialFlash");

        m_contentFrame = Frame();
        Content(m_contentFrame);

        auto homeItem = NavigationViewItem();
        homeItem.Content(box_value(L"Home"));
        homeItem.Tag(box_value(L"home"));
        homeItem.Icon(Controls::SymbolIcon(Controls::Symbol::Home));

        auto dataItem = NavigationViewItem();
        dataItem.Content(box_value(L"Data"));
        dataItem.Tag(box_value(L"data"));
        dataItem.Icon(Controls::SymbolIcon(Controls::Symbol::Folder));

        auto modelsItem = NavigationViewItem();
        modelsItem.Content(box_value(L"Models"));
        modelsItem.Tag(box_value(L"models"));
        modelsItem.Icon(Controls::SymbolIcon(Controls::Symbol::Page));

        auto trainingItem = NavigationViewItem();
        trainingItem.Content(box_value(L"Training"));
        trainingItem.Tag(box_value(L"training"));
        trainingItem.Icon(Controls::SymbolIcon(Controls::Symbol::Play));

        auto settingsItem = NavigationViewItem();
        settingsItem.Content(box_value(L"Settings"));
        settingsItem.Tag(box_value(L"settings"));
        settingsItem.Icon(Controls::SymbolIcon(Controls::Symbol::Setting));

        m_navView = NavigationView();
        m_navView.MenuItems().Append(homeItem);
        m_navView.MenuItems().Append(dataItem);
        m_navView.MenuItems().Append(modelsItem);
        m_navView.MenuItems().Append(trainingItem);
        m_navView.MenuItems().Append(settingsItem);
        m_navView.Content(m_contentFrame);
        m_navView.IsBackButtonVisible(NavigationViewBackButtonVisible::Collapsed);

        m_navView.SelectionChanged({ this, &MainWindow::OnNavigationChanged });

        Content(m_navView);
        m_navView.SelectedItem(homeItem);
        NavigateToPage(L"home");
    }

    void MainWindow::OnNavigationChanged(
        NavigationView const&,
        NavigationViewSelectionChangedEventArgs const& args)
    {
        auto selectedItem = args.SelectedItem().try_as<NavigationViewItem>();
        if (selectedItem)
        {
            auto tag = unbox_value<hstring>(selectedItem.Tag());
            NavigateToPage(tag);
        }
    }

    void MainWindow::NavigateToPage(winrt::hstring const& tag)
    {
        if (tag == L"home")
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::HomePage>());
        else if (tag == L"data")
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::DataPage>());
        else if (tag == L"models")
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::ModelsPage>());
        else if (tag == L"training")
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::TrainingPage>());
        else if (tag == L"settings")
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::SettingsPage>());
        else
            m_contentFrame.Navigate(xaml_typename<ArtificialFlash::HomePage>());
    }
}
