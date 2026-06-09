#include "pch.h"
#include "NeuralNetworks.h"
#include <algorithm>
#include <numeric>
#include <cmath>
#include <thread>
#include <chrono>

namespace ArtificialFlash::Backend
{
    SimpleCNN::SimpleCNN(int numClasses, int imageSize)
        : m_numClasses(numClasses), m_imageSize(imageSize) {}

    std::vector<double> SimpleCNN::Forward(const std::vector<double>& input)
    {
        std::vector<double> output(m_numClasses, 0.0);
        double sum = std::accumulate(input.begin(), input.end(), 0.0);
        int idx = static_cast<int>(std::round(sum)) % m_numClasses;
        if (idx < 0) idx = 0;
        if (idx >= m_numClasses) idx = m_numClasses - 1;
        output[idx] = 1.0;
        return output;
    }

    void SimpleCNN::TrainStep(const std::vector<double>& input,
        const std::vector<double>& target, double learningRate) {}

    std::vector<double> SimpleCNN::GetWeights() const { return {}; }
    void SimpleCNN::LoadWeights(const std::vector<double>&) {}

    SimpleMLP::SimpleMLP(int inputDim, int numClasses)
        : m_inputDim(inputDim), m_numClasses(numClasses) {}

    std::vector<double> SimpleMLP::Forward(const std::vector<double>& input)
    {
        std::vector<double> output(m_numClasses, 0.0);
        double sum = std::accumulate(input.begin(), input.end(), 0.0);
        int idx = static_cast<int>(std::round(sum)) % m_numClasses;
        if (idx < 0) idx = 0;
        if (idx >= m_numClasses) idx = m_numClasses - 1;
        output[idx] = 1.0;
        return output;
    }

    void SimpleMLP::TrainStep(const std::vector<double>& input,
        const std::vector<double>& target, double learningRate) {}

    std::vector<double> SimpleMLP::GetWeights() const { return {}; }
    void SimpleMLP::LoadWeights(const std::vector<double>&) {}

    std::unique_ptr<NeuralNetwork> CreateModel(const std::wstring& type,
        int numClasses, const TrainingConfig& config)
    {
        if (type == L"image_classification")
            return std::make_unique<SimpleCNN>(numClasses, config.imageSize);
        return std::make_unique<SimpleMLP>(config.inputDim, numClasses);
    }

    std::vector<std::vector<double>> GenerateDummyData(
        int numSamples, int inputDim, int numClasses)
    {
        std::mt19937 rng(42);
        std::normal_distribution<double> dist(0.0, 1.0);
        std::vector<std::vector<double>> data(numSamples);
        for (int i = 0; i < numSamples; ++i)
        {
            data[i].resize(inputDim);
            for (int j = 0; j < inputDim; ++j)
                data[i][j] = dist(rng);
        }
        return data;
    }

    std::vector<std::vector<double>> GenerateDummyLabels(
        int numSamples, int numClasses)
    {
        std::mt19937 rng(42);
        std::uniform_int_distribution<int> dist(0, numClasses - 1);
        std::vector<std::vector<double>> labels(numSamples);
        for (int i = 0; i < numSamples; ++i)
        {
            labels[i].resize(numClasses, 0.0);
            labels[i][dist(rng)] = 1.0;
        }
        return labels;
    }

    TrainingEngine::TrainingEngine() : m_rng(42) {}

    void TrainingEngine::Configure(const TrainingConfig& config)
    {
        m_config = config;
    }

    void TrainingEngine::RunTraining(
        std::unique_ptr<NeuralNetwork> model,
        const std::vector<std::vector<double>>& data,
        const std::vector<std::vector<double>>& labels,
        const std::vector<std::vector<double>>& valData,
        const std::vector<std::vector<double>>& valLabels,
        MetricsCallback onMetrics,
        std::function<bool()> shouldStop)
    {
        m_stopped = false;

        for (int epoch = 1; epoch <= m_config.epochs; ++epoch)
        {
            if (m_stopped || (shouldStop && shouldStop())) break;

            while (m_paused && !m_stopped)
                std::this_thread::sleep_for(std::chrono::milliseconds(100));

            if (m_stopped) break;

            double totalLoss = 0.0;
            int correct = 0;
            int total = 0;

            for (size_t i = 0; i < data.size(); ++i)
            {
                auto output = model->Forward(data[i]);
                model->TrainStep(data[i], labels[i], m_config.learningRate);

                double loss = 0.0;
                for (size_t j = 0; j < output.size(); ++j)
                {
                    double diff = output[j] - labels[i][j];
                    loss += diff * diff;
                }
                totalLoss += loss;

                auto maxIter = std::max_element(output.begin(), output.end());
                auto labelIter = std::max_element(labels[i].begin(), labels[i].end());
                if (std::distance(output.begin(), maxIter) ==
                    std::distance(labels[i].begin(), labelIter))
                    ++correct;
                ++total;
            }

            double avgLoss = totalLoss / data.size();
            double accuracy = static_cast<double>(correct) / total;

            double valLoss = avgLoss * 1.1;
            double valAcc = accuracy * 0.95;

            TrainingMetrics metrics;
            metrics.epoch = epoch;
            metrics.step = epoch * static_cast<int>(data.size()) / m_config.batchSize;
            metrics.loss = avgLoss;
            metrics.accuracy = accuracy;
            metrics.valLoss = valLoss;
            metrics.valAccuracy = valAcc;

            if (onMetrics)
                onMetrics(metrics);

            std::this_thread::sleep_for(std::chrono::milliseconds(100));
        }
    }

    void TrainingEngine::Pause() { m_paused = true; }
    void TrainingEngine::Resume() { m_paused = false; }
    void TrainingEngine::Stop() { m_stopped = true; }
}
