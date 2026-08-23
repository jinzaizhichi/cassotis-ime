#define NOMINMAX
#define ORT_API_MANUAL_INIT
#include <onnxruntime_cxx_api.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <cwchar>
#include <float.h>
#include <memory>
#include <xmmintrin.h>
#include <string>
#include <vector>
#include <windows.h>

namespace {

constexpr int64_t kCandidateCount = 12;
constexpr int64_t kSequenceLength = 41;
constexpr int64_t kNumericFeatureCount = 88;

struct SessionHandle {
    std::unique_ptr<Ort::Session> session;
};

class FloatingPointMaskGuard {
public:
    FloatingPointMaskGuard() : old_mxcsr_(_mm_getcsr()) {
        _controlfp_s(&old_control_, 0, 0);
        _controlfp_s(nullptr, _MCW_EM, _MCW_EM);
        _mm_setcsr(old_mxcsr_ | _MM_MASK_MASK);
    }

    ~FloatingPointMaskGuard() {
        _controlfp_s(nullptr, old_control_, _MCW_EM);
        _mm_setcsr(old_mxcsr_);
    }

private:
    unsigned int old_control_{};
    unsigned int old_mxcsr_{};
};

Ort::Env& Environment() {
    static Ort::Env env(ORT_LOGGING_LEVEL_WARNING, "cassotis_pinyin_transformer");
    return env;
}

void SetError(wchar_t* destination, int capacity, const std::wstring& message) {
    if (destination == nullptr || capacity <= 0) {
        return;
    }
    const size_t copy_length = std::min(message.size(), static_cast<size_t>(capacity - 1));
    if (copy_length > 0) {
        std::wmemcpy(destination, message.data(), copy_length);
    }
    destination[copy_length] = L'\0';
}

std::wstring Utf8ToWide(const char* message) {
    if (message == nullptr || *message == '\0') {
        return L"unknown ONNX Runtime error";
    }
    const int required = MultiByteToWideChar(CP_UTF8, 0, message, -1, nullptr, 0);
    if (required <= 1) {
        return L"ONNX Runtime error";
    }
    std::wstring result(static_cast<size_t>(required), L'\0');
    MultiByteToWideChar(CP_UTF8, 0, message, -1, result.data(), required);
    result.resize(static_cast<size_t>(required - 1));
    return result;
}

}  // namespace

extern "C" __declspec(dllexport) void* __cdecl nc_pt_create(
    const wchar_t* model_path,
    int intra_threads,
    wchar_t* error_text,
    int error_capacity) {
    SetError(error_text, error_capacity, L"");
    if (model_path == nullptr || *model_path == L'\0') {
        SetError(error_text, error_capacity, L"model path is empty");
        return nullptr;
    }
    try {
        FloatingPointMaskGuard floating_point_guard;
        Ort::InitApi();
        Ort::SessionOptions options;
        options.SetExecutionMode(ExecutionMode::ORT_SEQUENTIAL);
        options.SetIntraOpNumThreads(std::max(1, intra_threads));
        options.SetInterOpNumThreads(1);
        options.SetGraphOptimizationLevel(GraphOptimizationLevel::ORT_ENABLE_ALL);
        auto handle = std::make_unique<SessionHandle>();
        handle->session = std::make_unique<Ort::Session>(Environment(), model_path, options);
        return handle.release();
    } catch (const Ort::Exception& error) {
        SetError(error_text, error_capacity, Utf8ToWide(error.what()));
    } catch (const std::exception& error) {
        SetError(error_text, error_capacity, Utf8ToWide(error.what()));
    } catch (...) {
        SetError(error_text, error_capacity, L"unknown model initialization failure");
    }
    return nullptr;
}

extern "C" __declspec(dllexport) int __cdecl nc_pt_run(
    void* opaque_handle,
    const int64_t* char_ids,
    const int64_t* pinyin_ids,
    const int64_t* boundary_ids,
    const float* numeric_features,
    const uint8_t* candidate_mask,
    float* output_scores,
    int output_score_count,
    wchar_t* error_text,
    int error_capacity) {
    SetError(error_text, error_capacity, L"");
    if (opaque_handle == nullptr || char_ids == nullptr || pinyin_ids == nullptr ||
        boundary_ids == nullptr || numeric_features == nullptr || candidate_mask == nullptr ||
        output_scores == nullptr || output_score_count < kCandidateCount) {
        SetError(error_text, error_capacity, L"invalid inference arguments");
        return 0;
    }
    try {
        FloatingPointMaskGuard floating_point_guard;
        auto* handle = static_cast<SessionHandle*>(opaque_handle);
        if (!handle->session) {
            SetError(error_text, error_capacity, L"model session is unavailable");
            return 0;
        }

        static_assert(sizeof(bool) == sizeof(uint8_t), "ONNX bool tensor requires one-byte bool");
        std::array<uint8_t, kCandidateCount> mask_storage{};
        std::copy_n(candidate_mask, kCandidateCount, mask_storage.begin());

        const std::array<int64_t, 3> candidate_shape{1, kCandidateCount, kSequenceLength};
        const std::array<int64_t, 2> pinyin_shape{1, kSequenceLength};
        const std::array<int64_t, 3> numeric_shape{1, kCandidateCount, kNumericFeatureCount};
        const std::array<int64_t, 2> mask_shape{1, kCandidateCount};
        auto memory = Ort::MemoryInfo::CreateCpu(OrtArenaAllocator, OrtMemTypeDefault);

        std::array<Ort::Value, 5> inputs{
            Ort::Value::CreateTensor<int64_t>(memory, const_cast<int64_t*>(char_ids),
                kCandidateCount * kSequenceLength, candidate_shape.data(), candidate_shape.size()),
            Ort::Value::CreateTensor<int64_t>(memory, const_cast<int64_t*>(pinyin_ids),
                kSequenceLength, pinyin_shape.data(), pinyin_shape.size()),
            Ort::Value::CreateTensor<int64_t>(memory, const_cast<int64_t*>(boundary_ids),
                kCandidateCount * kSequenceLength, candidate_shape.data(), candidate_shape.size()),
            Ort::Value::CreateTensor<float>(memory, const_cast<float*>(numeric_features),
                kCandidateCount * kNumericFeatureCount, numeric_shape.data(), numeric_shape.size()),
            Ort::Value::CreateTensor<bool>(memory, reinterpret_cast<bool*>(mask_storage.data()),
                kCandidateCount, mask_shape.data(), mask_shape.size())};

        constexpr std::array<const char*, 5> input_names{
            "char_ids", "pinyin_ids", "boundary_ids", "numeric_features", "candidate_mask"};
        constexpr std::array<const char*, 1> output_names{"scores"};
        auto outputs = handle->session->Run(Ort::RunOptions{nullptr}, input_names.data(),
            inputs.data(), inputs.size(), output_names.data(), output_names.size());
        if (outputs.size() != 1 || !outputs[0].IsTensor()) {
            SetError(error_text, error_capacity, L"model returned an invalid output tensor");
            return 0;
        }
        const auto info = outputs[0].GetTensorTypeAndShapeInfo();
        if (info.GetElementCount() < kCandidateCount) {
            SetError(error_text, error_capacity, L"model output tensor is too small");
            return 0;
        }
        const float* scores = outputs[0].GetTensorData<float>();
        std::copy_n(scores, kCandidateCount, output_scores);
        return 1;
    } catch (const Ort::Exception& error) {
        SetError(error_text, error_capacity, Utf8ToWide(error.what()));
    } catch (const std::exception& error) {
        SetError(error_text, error_capacity, Utf8ToWide(error.what()));
    } catch (...) {
        SetError(error_text, error_capacity, L"unknown inference failure");
    }
    return 0;
}

extern "C" __declspec(dllexport) void __cdecl nc_pt_destroy(void* opaque_handle) {
    delete static_cast<SessionHandle*>(opaque_handle);
}
