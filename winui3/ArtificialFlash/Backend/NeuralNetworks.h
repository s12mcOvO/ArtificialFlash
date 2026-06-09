#pragma once
#include <memory>
#include <string>
#include <vector>
#include <functional>
#include <random>

namespace ArtificialFlash::Backend
{
    enum class ModelArchitecture
    {
        SimpleCNN,
        SimpleTextClassifier,
        SimpleMLP
    };

    struct TrainingConfig
    {
        int epochs = 10;
        double learningRate = 0.001;
        int batchSize = 16;
        int numClasses = 10;
        int inputDim = 784;
        int vocabSize = 10000;
        int embeddingDim = 128;
        int hiddenDim = 128;
        int imageSize = 28;
    };

    struct TrainingMetrics
    {
        int epoch = 0;
        int step = 0;
        double loss = 0.0;
        double accuracy = 0.0;
        double valLoss = 0.0;
        double valAccuracy = 0.0;
    };

    using MetricsCallback = std::function<void(const TrainingMetrics&)>;

    class NeuralNetwork
    {
    public:
        virtual ~NeuralNetwork() = default;
        virtual std::vector<double> Forward(const std::vector<double>& input) = 0;
        virtual void TrainStep(const std::vector<double>& input,
            const std::vector<double>& target, double learningRate) = 0;
        virtual std::vector<double> GetWeights() const = 0;
        virtual void LoadWeights(const std::vector<double>& weights) = 0;
    };

    class SimpleCNN : public NeuralNetwork
    {
    public:
        explicit SimpleCNN(int numClasses, int imageSize = 28);
        std::vector<double> Forward(const std::vector<double>& input) override;
        void TrainStep(const std::vector<double>& input,
            const std::vector<double>& target, double learningRate) override;
        std::vector<double> GetWeights() const override;
        void LoadWeights(const std::vector<double>& weights) override;

    private:
        int m_numClasses;
        int m_imageSize;
    };

    class SimpleMLP : public NeuralNetwork
    {
    public:
        SimpleMLP(int inputDim, int numClasses);
        std::vector<double> Forward(const std::vector<double>& input) override;
        void TrainStep(const std::vector<double>& input,
            const std::vector<double>& target, double learningRate) override;
        std::vector<double> GetWeights() const override;
        void LoadWeights(const std::vector<double>& weights) override;

    private:
        int m_inputDim;
        int m_numClasses;
    };

    std::unique_ptr<NeuralNetwork> CreateModel(const std::wstring& type, int numClasses = 10,
        const TrainingConfig& config = {});

    std::vector<std::vector<double>> GenerateDummyData(int numSamples, int inputDim, int numClasses);
    std::vector<std::vector<double>> GenerateDummyLabels(int numSamples, int numClasses);

    class TrainingEngine
    {
    public:
        TrainingEngine();
        void Configure(const TrainingConfig& config);
        void RunTraining(std::unique_ptr<NeuralNetwork> model,
            const std::vector<std::vector<double>>& data,
            const std::vector<std::vector<double>>& labels,
            const std::vector<std::vector<double>>& valData,
            const std::vector<std::vector<double>>& valLabels,
            MetricsCallback onMetrics,
            std::function<bool()> shouldStop);
        void Pause();
        void Resume();
        void Stop();

    private:
        TrainingConfig m_config;
        volatile bool m_paused = false;
        volatile bool m_stopped = false;
        std::mt19937 m_rng;
    };
}
