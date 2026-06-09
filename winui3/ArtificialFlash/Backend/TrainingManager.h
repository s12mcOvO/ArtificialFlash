#pragma once
#include <string>
#include <unordered_map>
#include <memory>
#include <thread>
#include <future>
#include "NeuralNetworks.h"
#include "../Models/TrainingSession.h"

namespace ArtificialFlash::Backend
{
    class TrainingManager
    {
    public:
        TrainingManager() = default;

        std::wstring CreateSession(const std::wstring& modelId, const std::wstring& mode);
        Models::TrainingSession* GetSession(const std::wstring& sessionId);
        void UpdateSession(const std::wstring& sessionId, const Models::TrainingSession& data);
        void AddLog(const std::wstring& sessionId, const Models::TrainingLog& log);
        void CloseSession(const std::wstring& sessionId);
        void RemoveSession(const std::wstring& sessionId);

        bool StartTraining(const std::wstring& sessionId, const TrainingConfig& config,
            MetricsCallback onMetrics);
        void PauseTraining(const std::wstring& sessionId);
        void ResumeTraining(const std::wstring& sessionId);
        void StopTraining(const std::wstring& sessionId);

        const std::unordered_map<std::wstring, Models::TrainingSession>& ActiveSessions() const
        { return m_sessions; }

    private:
        std::unordered_map<std::wstring, Models::TrainingSession> m_sessions;
        std::unordered_map<std::wstring, std::unique_ptr<TrainingEngine>> m_engines;
        std::unordered_map<std::wstring, std::future<void>> m_trainingFutures;
        std::unordered_map<std::wstring, std::unique_ptr<NeuralNetwork>> m_models;
    };
}
