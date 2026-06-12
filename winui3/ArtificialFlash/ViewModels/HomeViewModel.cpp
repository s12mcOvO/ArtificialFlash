#include "pch.h"
#include "HomeViewModel.h"

using ::ArtificialFlash::Backend::BackendService;
using ::ArtificialFlash::Models::TrainingStatus;

namespace ArtificialFlash
{
    HomeViewModel::HomeViewModel()
    {
        Refresh();
    }

    void HomeViewModel::Refresh()
    {
        auto& backend = BackendService::Instance();
        m_datasetCount = static_cast<int32_t>(backend.ListDatasets().size());
        m_modelCount = static_cast<int32_t>(backend.ListModels().size());

        auto sessions = backend.GetTrainingManager().ActiveSessions();
        m_isTrainingActive = false;
        for (const auto& [id, session] : sessions)
        {
            if (session.status == TrainingStatus::Training ||
                session.status == TrainingStatus::Preparing)
            {
                m_isTrainingActive = true;
                break;
            }
        }
    }
}
