#pragma once
#include <string>
#include <unordered_map>
#include <chrono>

namespace ArtificialFlash::Models
{
    enum class ModelStatus
    {
        Pending,
        Training,
        Ready,
        Error,
        Exported
    };

    struct TrainingParams
    {
        double learningRate = 0.001;
        int epochs = 10;
        int batchSize = 16;
        int imageSize = 28;
        std::wstring backbone;
        bool dataAugmentation = false;
        double trainSplit = 0.8;
        double valSplit = 0.1;
    };

    struct AIModel
    {
        std::wstring id;
        std::wstring name;
        std::wstring type;
        std::wstring baseModel;
        ModelStatus status = ModelStatus::Pending;
        std::wstring datasetId;
        TrainingParams params;
        std::wstring path;
        double accuracy = 0.0;
        double loss = 0.0;
        std::chrono::system_clock::time_point createdAt;
        std::chrono::system_clock::time_point trainedAt;
        std::wstring errorMessage;

        static std::wstring StatusToString(ModelStatus s)
        {
            switch (s)
            {
            case ModelStatus::Pending:  return L"Pending";
            case ModelStatus::Training: return L"Training";
            case ModelStatus::Ready:    return L"Ready";
            case ModelStatus::Error:    return L"Error";
            case ModelStatus::Exported: return L"Exported";
            }
            return L"Unknown";
        }
    };
}
