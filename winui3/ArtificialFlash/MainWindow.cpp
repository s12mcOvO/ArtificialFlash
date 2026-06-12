#include "pch.h"
#include "MainWindow.h"
#include "Pages/HomePage.h"
#include "Pages/DataPage.h"
#include "Pages/ModelsPage.h"
#include "Pages/TrainingPage.h"
#include "Pages/SettingsPage.h"

using namespace winrt;
using namespace winrt::Microsoft::UI::Xaml;
using namespace winrt::Microsoft::UI::Xaml::Controls;

namespace ArtificialFlash
{
    MainWindowImpl::MainWindowImpl()
    {
        m_window = Microsoft::UI::Xaml::Window();
        m_window.Title(L"ArtificialFlash");

        m_contentFrame = Frame();

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
        m_navView.SelectionChanged({ this, &MainWindowImpl::OnNavigationChanged });
        m_navView.SelectedItem(homeItem);

        m_window.Content(m_navView);
        NavigateToPage(L"home");
    }

    void MainWindowImpl::Activate()
    {
        m_window.Activate();
    }

    void MainWindowImpl::OnNavigationChanged(
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

    void MainWindowImpl::NavigateToPage(winrt::hstring const& tag)
    {
        Windows::Foundation::IInspectable page;
        if (tag == L"home")
            page = make<winrt::ArtificialFlash::implementation::HomePage>();
        else if (tag == L"data")
            page = make<winrt::ArtificialFlash::implementation::DataPage>();
        else if (tag == L"models")
            page = make<winrt::ArtificialFlash::implementation::ModelsPage>();
        else if (tag == L"training")
            page = make<winrt::ArtificialFlash::implementation::TrainingPage>();
        else if (tag == L"settings")
            page = make<winrt::ArtificialFlash::implementation::SettingsPage>();
        else
            page = make<winrt::ArtificialFlash::implementation::HomePage>();
        m_navView.Content(page);
    }
}
