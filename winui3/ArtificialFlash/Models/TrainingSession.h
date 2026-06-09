#pragma once
#include <string>
#include <vector>

namespace ArtificialFlash::Models
{
    enum class TrainingStatus
    {
        Idle,
        Preparing,
        Training,
        Paused,
        Completed,
        Error,
        Stopped
    };

    enum class TrainingMode
    {
        Local,
        Remote
    };

    struct TrainingLog
    {
        int epoch = 0;
        int step = 0;
        double loss = 0.0;
        double accuracy = 0.0;
        double valLoss = 0.0;
        double valAccuracy = 0.0;
        std::wstring message;
        std::chrono::system_clock::time_point timestamp;
    };

    struct TrainingSession
    {
        std::wstring id;
        std::wstring modelId;
        TrainingStatus status = TrainingStatus::Idle;
        TrainingMode mode = TrainingMode::Local;
        int currentEpoch = 0;
        int totalEpochs = 10;
        double progress = 0.0;
        double currentLoss = 0.0;
        double currentAccuracy = 0.0;
        std::vector<TrainingLog> logs;
        std::chrono::system_clock::time_point startedAt;
        std::chrono::system_clock::time_point completedAt;
        std::wstring errorMessage;
    };
}
