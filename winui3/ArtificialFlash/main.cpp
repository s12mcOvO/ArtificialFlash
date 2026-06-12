#include "pch.h"
#include "MainWindow.h"
#include "Backend/BackendService.h"

using ::ArtificialFlash::Backend::BackendService;

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPWSTR, int)
{
    winrt::init_apartment(winrt::apartment_type::single_threaded);

    BackendService::Instance().Initialize();

    ArtificialFlash::MainWindowImpl mainWindow;
    mainWindow.Activate();

    MSG msg{};
    while (GetMessage(&msg, nullptr, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    BackendService::Instance().Shutdown();
    return 0;
}
