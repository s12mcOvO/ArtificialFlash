#include "pch.h"
#include "TrainingManager.h"
#include <random>
#include <sstream>

namespace ArtificialFlash::Backend
{
    std::wstring GenerateUUID()
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

    std::wstring TrainingManager::CreateSession(
        const std::wstring& modelId, const std::wstring& mode)
    {
        auto sessionId = GenerateUUID();
        Models::TrainingSession session;
        session.id = sessionId;
        session.modelId = modelId;
        session.status = Models::TrainingStatus::Preparing;
        session.mode = mode == L"remote" ?
            Models::TrainingMode::Remote : Models::TrainingMode::Local;
        session.startedAt = std::chrono::system_clock::now();
        m_sessions[sessionId] = session;
        return sessionId;
    }

    Models::TrainingSession* TrainingManager::GetSession(const std::wstring& sessionId)
    {
        auto it = m_sessions.find(sessionId);
        return it != m_sessions.end() ? &it->second : nullptr;
    }

    void TrainingManager::UpdateSession(const std::wstring& sessionId,
        const Models::TrainingSession& data)
    {
        if (m_sessions.count(sessionId))
            m_sessions[sessionId] = data;
    }

    void TrainingManager::AddLog(const std::wstring& sessionId,
        const Models::TrainingLog& log)
    {
        if (m_sessions.count(sessionId))
            m_sessions[sessionId].logs.push_back(log);
    }

    void TrainingManager::CloseSession(const std::wstring& sessionId)
    {
        if (m_sessions.count(sessionId))
        {
            m_sessions[sessionId].status = Models::TrainingStatus::Completed;
            m_sessions[sessionId].completedAt = std::chrono::system_clock::now();
        }
    }

    void TrainingManager::RemoveSession(const std::wstring& sessionId)
    {
        m_sessions.erase(sessionId);
        m_engines.erase(sessionId);
        m_models.erase(sessionId);
    }

    bool TrainingManager::StartTraining(const std::wstring& sessionId,
        const TrainingConfig& config, MetricsCallback onMetrics)
    {
        auto* session = GetSession(sessionId);
        if (!session) return false;

        auto model = CreateModel(L"image_classification", config.numClasses, config);
        auto engine = std::make_unique<TrainingEngine>();
        engine->Configure(config);

        auto trainData = GenerateDummyData(100, config.inputDim, config.numClasses);
        auto trainLabels = GenerateDummyLabels(100, config.numClasses);
        auto valData = GenerateDummyData(20, config.inputDim, config.numClasses);
        auto valLabels = GenerateDummyLabels(20, config.numClasses);

        session->status = Models::TrainingStatus::Training;

        auto rawModel = model.get();
        auto rawEngine = engine.get();

        m_models[sessionId] = std::move(model);
        m_engines[sessionId] = std::move(engine);

        auto weakSession = sessionId;
        auto* self = this;
        m_trainingFutures[sessionId] = std::async(std::launch::async,
            [rawEngine, rawModel, trainData, trainLabels,
            valData, valLabels, onMetrics = std::move(onMetrics),
            weakSession, self]()
            {
                rawEngine->RunTraining(
                    std::unique_ptr<NeuralNetwork>(rawModel),
                    trainData, trainLabels,
                    valData, valLabels,
                    [self, &weakSession, &onMetrics](const TrainingMetrics& m) {
                        auto* s = self->GetSession(weakSession);
                        if (s)
                        {
                            s->currentEpoch = m.epoch;
                            s->currentLoss = m.loss;
                            s->currentAccuracy = m.accuracy;
                            s->progress = static_cast<double>(m.epoch) /
                                (m.epoch + 1);

                            Models::TrainingLog log;
                            log.epoch = m.epoch;
                            log.step = m.step;
                            log.loss = m.loss;
                            log.accuracy = m.accuracy;
                            log.valLoss = m.valLoss;
                            log.valAccuracy = m.valAccuracy;
                            log.timestamp = std::chrono::system_clock::now();
                            self->AddLog(weakSession, log);
                        }
                        if (onMetrics) onMetrics(m);
                    },
                    [self, &weakSession]() -> bool {
                        auto* s = self->GetSession(weakSession);
                        return s && s->status == Models::TrainingStatus::Stopped;
                    });

                auto* s = self->GetSession(weakSession);
                if (s) {
                    s->status = Models::TrainingStatus::Completed;
                    s->progress = 1.0;
                }

                self->m_engines.erase(weakSession);
            });

        return true;
    }

    void TrainingManager::PauseTraining(const std::wstring& sessionId)
    {
        auto it = m_engines.find(sessionId);
        if (it != m_engines.end()) it->second->Pause();
        auto* session = GetSession(sessionId);
        if (session) session->status = Models::TrainingStatus::Paused;
    }

    void TrainingManager::ResumeTraining(const std::wstring& sessionId)
    {
        auto it = m_engines.find(sessionId);
        if (it != m_engines.end()) it->second->Resume();
        auto* session = GetSession(sessionId);
        if (session) session->status = Models::TrainingStatus::Training;
    }

    void TrainingManager::StopTraining(const std::wstring& sessionId)
    {
        auto it = m_engines.find(sessionId);
        if (it != m_engines.end()) it->second->Stop();
        auto* session = GetSession(sessionId);
        if (session) session->status = Models::TrainingStatus::Stopped;
    }
}
