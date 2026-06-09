#pragma once
#include <string>
#include <vector>
#include <chrono>

namespace ArtificialFlash::Models
{
    enum class DatasetType
    {
        Image,
        Text,
        Mixed
    };

    enum class DatasetStatus
    {
        Pending,
        Uploading,
        Ready,
        Error
    };

    struct Dataset
    {
        std::wstring id;
        std::wstring name;
        std::wstring path;
        DatasetType type = DatasetType::Mixed;
        DatasetStatus status = DatasetStatus::Pending;
        int fileCount = 0;
        std::chrono::system_clock::time_point createdAt;
        std::wstring errorMessage;

        static std::wstring TypeToString(DatasetType t)
        {
            switch (t)
            {
            case DatasetType::Image: return L"image";
            case DatasetType::Text:  return L"text";
            case DatasetType::Mixed: return L"mixed";
            }
            return L"mixed";
        }

        static DatasetType StringToType(const std::wstring& s)
        {
            if (s == L"image") return DatasetType::Image;
            if (s == L"text")  return DatasetType::Text;
            return DatasetType::Mixed;
        }
    };
}
