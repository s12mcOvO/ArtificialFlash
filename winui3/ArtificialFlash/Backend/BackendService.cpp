#include "pch.h"
#include "BackendService.h"
#include <random>
#include <sstream>

namespace ArtificialFlash::Backend
{
    BackendService& BackendService::Instance()
    {
        static BackendService instance;
        return instance;
    }

    void BackendService::Initialize()
    {
        m_trainingManager = std::make_unique<TrainingManager>();
    }

    void BackendService::Shutdown()
    {
        m_trainingManager.reset();
    }

    bool BackendService::IsHealthy() const
    {
        return m_trainingManager != nullptr;
    }

    std::vector<Models::Dataset> BackendService::ListDatasets() const
    {
        std::vector<Models::Dataset> result;
        for (const auto& [id, ds] : m_datasets)
            result.push_back(ds);
        return result;
    }

    Models::Dataset BackendService::GetDataset(const std::wstring& id) const
    {
        auto it = m_datasets.find(id);
        if (it != m_datasets.end()) return it->second;
        return {};
    }

    static std::wstring GenerateId()
    {
        std::mt19937 rng(std::random_device{}());
        std::uniform_int_distribution<int> dist(0, 15);
        std::wstringstream ss;
        for (int i = 0; i < 36; ++i)
        {
            if (i == 8 || i == 13 || i == 18 || i == 23)
                ss << L'-';
            else
                ss << std::hex << dist(rng);
        }
        return ss.str();
    }

    Models::Dataset BackendService::CreateDataset(const std::wstring& name,
        const std::wstring& path, const std::wstring& type)
    {
        Models::Dataset ds;
        ds.id = GenerateId();
        ds.name = name;
        ds.path = path;
        ds.type = Models::Dataset::StringToType(type);
        ds.status = Models::DatasetStatus::Ready;
        ds.fileCount = 0;
        ds.createdAt = std::chrono::system_clock::now();
        m_datasets[ds.id] = ds;
        return ds;
    }

    bool BackendService::DeleteDataset(const std::wstring& id)
    {
        return m_datasets.erase(id) > 0;
    }

    std::vector<Models::AIModel> BackendService::ListModels() const
    {
        std::vector<Models::AIModel> result;
        for (const auto& [id, m] : m_models)
            result.push_back(m);
        return result;
    }

    Models::AIModel BackendService::GetModel(const std::wstring& id) const
    {
        auto it = m_models.find(id);
        if (it != m_models.end()) return it->second;
        return {};
    }

    Models::AIModel BackendService::CreateModel(const std::wstring& name,
        const std::wstring& type, const std::wstring& baseModel,
        const std::wstring& datasetId, const Models::TrainingParams& params)
    {
        Models::AIModel model;
        model.id = GenerateId();
        model.name = name;
        model.type = type;
        model.baseModel = baseModel;
        model.status = Models::ModelStatus::Pending;
        model.datasetId = datasetId;
        model.params = params;
        model.createdAt = std::chrono::system_clock::now();
        m_models[model.id] = model;
        return model;
    }

    bool BackendService::DeleteModel(const std::wstring& id)
    {
        return m_models.erase(id) > 0;
    }

    std::wstring BackendService::StartTraining(const std::wstring& modelId,
        const std::wstring& sessionId)
    {
        auto modelIt = m_models.find(modelId);
        if (modelIt == m_models.end()) return L"";

        auto& model = modelIt->second;
        model.status = Models::ModelStatus::Training;

        TrainingConfig config;
        config.epochs = model.params.epochs;
        config.learningRate = model.params.learningRate;
        config.batchSize = model.params.batchSize;

        auto sid = m_trainingManager->CreateSession(modelId, L"local");

        bool started = m_trainingManager->StartTraining(sid, config,
            [this, sid](const TrainingMetrics& metrics) {
                if (m_trainingCallback)
                {
                    Models::TrainingLog log;
                    log.epoch = metrics.epoch;
                    log.step = metrics.step;
                    log.loss = metrics.loss;
                    log.accuracy = metrics.accuracy;
                    log.valLoss = metrics.valLoss;
                    log.valAccuracy = metrics.valAccuracy;
                    log.timestamp = std::chrono::system_clock::now();
                    m_trainingCallback(log);
                }
            });

        return started ? sid : L"";
    }

    bool BackendService::PauseTraining(const std::wstring& sessionId)
    {
        m_trainingManager->PauseTraining(sessionId);
        return true;
    }

    bool BackendService::ResumeTraining(const std::wstring& sessionId)
    {
        m_trainingManager->ResumeTraining(sessionId);
        return true;
    }

    bool BackendService::StopTraining(const std::wstring& sessionId)
    {
        m_trainingManager->StopTraining(sessionId);
        return true;
    }

    Models::TrainingSession BackendService::GetTrainingSession(
        const std::wstring& sessionId) const
    {
        auto* session = const_cast<TrainingManager*>(m_trainingManager.get())
            ->GetSession(sessionId);
        return session ? *session : Models::TrainingSession{};
    }
}
