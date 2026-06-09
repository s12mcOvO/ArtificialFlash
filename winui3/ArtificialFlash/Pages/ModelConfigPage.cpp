#include "pch.h"
#include "ModelConfigPage.h"
#include "../Backend/BackendService.h"

namespace winrt::ArtificialFlash::implementation
{
    ModelConfigPage::ModelConfigPage()
    {
        InitializeComponent();
        ArchitectureCombo().SelectedIndex(0);
    }

    void ModelConfigPage::OnCreateModel(
        Windows::Foundation::IInspectable const&,
        Microsoft::UI::Xaml::RoutedEventArgs const&)
    {
        auto name = ModelNameBox().Text();
        if (name.empty()) return;

        std::wstring type = L"image_classification";
        auto arch = ArchitectureCombo().SelectedItem()
            .as<Microsoft::UI::Xaml::Controls::ComboBoxItem>();
        if (arch)
        {
            auto content = arch.Content().as<winrt::hstring>();
            if (content == L"Text Classification" || content == L"Sentiment Analysis")
                type = L"text_classification";
            else if (content == L"Object Detection")
                type = L"object_detection";
        }

        Models::TrainingParams params;
        params.learningRate = LearningRateBox().Value();
        params.epochs = static_cast<int>(EpochsBox().Value());
        params.batchSize = static_cast<int>(BatchSizeBox().Value());
        params.imageSize = static_cast<int>(ImageSizeBox().Value());
        params.dataAugmentation = DataAugToggle().IsOn();

        auto& backend = Backend::BackendService::Instance();
        auto model = backend.CreateModel(name.c_str(), type, L"", L"", params);

        // Navigate back to models page
        auto frame = Parent().as<Microsoft::UI::Xaml::Controls::Frame>();
        if (frame) frame.GoBack();
    }
}
