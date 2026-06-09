#include "pch.h"
#include "SettingsService.h"

using namespace winrt::Windows::Storage;

namespace ArtificialFlash::Services
{
    SettingsService& SettingsService::Instance()
    {
        static SettingsService instance;
        return instance;
    }

    SettingsService::SettingsService()
    {
        m_settings = LoadSettings();
    }

    AppSettings SettingsService::LoadSettings()
    {
        AppSettings settings;
        try
        {
            auto localSettings = ApplicationData::Current().LocalSettings();
            auto values = localSettings.Values();

            if (auto val = values.TryLookup(L"use_dark_theme"))
                settings.useDarkTheme = val.as<bool>();

            if (auto val = values.TryLookup(L"language"))
                settings.language = val.as<winrt::hstring>().c_str();

            if (auto val = values.TryLookup(L"server_host"))
                settings.serverHost = val.as<winrt::hstring>().c_str();

            if (auto val = values.TryLookup(L"server_port"))
                settings.serverPort = static_cast<int>(val.as<double>());

            if (auto val = values.TryLookup(L"use_remote_server"))
                settings.useRemoteServer = val.as<bool>();
        }
        catch (...) {}
        return settings;
    }

    void SettingsService::SaveSettings(const AppSettings& settings)
    {
        m_settings = settings;
        try
        {
            auto localSettings = ApplicationData::Current().LocalSettings();
            auto values = localSettings.Values();

            values.Insert(L"use_dark_theme",
                winrt::box_value(settings.useDarkTheme));
            values.Insert(L"language",
                winrt::box_value(winrt::hstring(settings.language)));
            values.Insert(L"server_host",
                winrt::box_value(winrt::hstring(settings.serverHost)));
            values.Insert(L"server_port",
                winrt::box_value(static_cast<double>(settings.serverPort)));
            values.Insert(L"use_remote_server",
                winrt::box_value(settings.useRemoteServer));
        }
        catch (...) {}
    }

    void SettingsService::SetUseDarkTheme(bool v)
    {
        m_settings.useDarkTheme = v;
        SaveSettings(m_settings);
    }

    void SettingsService::SetLanguage(const std::wstring& lang)
    {
        m_settings.language = lang;
        SaveSettings(m_settings);
    }
}
