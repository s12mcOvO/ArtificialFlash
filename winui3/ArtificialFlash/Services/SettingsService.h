#pragma once
#include <string>
#include <Windows.h>
#include <winrt/Windows.Storage.h>

namespace ArtificialFlash::Services
{
    struct AppSettings
    {
        bool useDarkTheme = false;
        std::wstring language = L"en";
        std::wstring serverHost = L"localhost";
        int serverPort = 8000;
        bool useRemoteServer = false;
    };

    class SettingsService
    {
    public:
        static SettingsService& Instance();

        AppSettings LoadSettings();
        void SaveSettings(const AppSettings& settings);

        bool UseDarkTheme() const { return m_settings.useDarkTheme; }
        void SetUseDarkTheme(bool v);

        std::wstring Language() const { return m_settings.language; }
        void SetLanguage(const std::wstring& lang);

        std::wstring ServerHost() const { return m_settings.serverHost; }
        int ServerPort() const { return m_settings.serverPort; }
        bool UseRemoteServer() const { return m_settings.useRemoteServer; }

    private:
        SettingsService();
        AppSettings m_settings;
    };
}
