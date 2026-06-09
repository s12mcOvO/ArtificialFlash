#pragma once
#include <string>
#include <vector>
#include <memory>
#include <functional>
#include "TrainingManager.h"
#include "../Models/Dataset.h"
#include "../Models/Model.h"

namespace ArtificialFlash::Backend
{
    class BackendService
    {
    public:
        static BackendService& Instance();

        void Initialize();
        void Shutdown();
        bool IsHealthy() const;

        TrainingManager& GetTrainingManager() { return *m_trainingManager; }

        std::vector<Models::Dataset> ListDatasets() const;
        Models::Dataset GetDataset(const std::wstring& id) const;
        Models::Dataset CreateDataset(const std::wstring& name,
            const std::wstring& path, const std::wstring& type);
        bool DeleteDataset(const std::wstring& id);

        std::vector<Models::AIModel> ListModels() const;
        Models::AIModel GetModel(const std::wstring& id) const;
        Models::AIModel CreateModel(const std::wstring& name,
            const std::wstring& type, const std::wstring& baseModel,
            const std::wstring& datasetId,
            const Models::TrainingParams& params);
        bool DeleteModel(const std::wstring& id);

        std::wstring StartTraining(const std::wstring& modelId,
            const std::wstring& sessionId = L"");
        bool PauseTraining(const std::wstring& sessionId);
        bool ResumeTraining(const std::wstring& sessionId);
        bool StopTraining(const std::wstring& sessionId);
        Models::TrainingSession GetTrainingSession(const std::wstring& sessionId) const;

        using TrainingUpdateCallback = std::function<void(const Models::TrainingLog&)>;
        void SetTrainingCallback(TrainingUpdateCallback cb)
        { m_trainingCallback = cb; }

    private:
        BackendService() = default;
        BackendService(const BackendService&) = delete;
        BackendService& operator=(const BackendService&) = delete;

        std::unique_ptr<TrainingManager> m_trainingManager;
        std::unordered_map<std::wstring, Models::Dataset> m_datasets;
        std::unordered_map<std::wstring, Models::AIModel> m_models;
        TrainingUpdateCallback m_trainingCallback;
    };
}
