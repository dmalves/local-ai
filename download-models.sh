#!/usr/bin/env bash

# Ensure the fixed Podman-managed volume exists
podman volume create local-ai_llama-models > /dev/null 2>&1

echo "=========================================="
echo "         LLM Download Manager"
echo "=========================================="
echo "1) Qwen2.5-7B-Instruct (Q3_K_M ~3.8GB)"
echo "2) Qwen2.5-Coder-7B-Instruct (Q4_K_M ~4.7GB)"
echo "3) Llama-3.2-3B-Instruct (Q5_K_M ~2.3GB)"
echo "4) Download All Models"
echo "5) Exit"
echo "=========================================="
read -rp "Choose an option [1-5]: " OPTION

case $OPTION in
    1)
        MODEL_NAME="qwen2.5-7b-instruct-q3_k_m.gguf"
        URL="https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF/resolve/main/qwen2.5-7b-instruct-q3_k_m.gguf"
        ;;
    2)
        MODEL_NAME="qwen2.5-coder-7b-instruct-q4_k_m.gguf"
        URL="https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/qwen2.5-coder-7b-instruct-q4_k_m.gguf"
        ;;
    3)
        MODEL_NAME="llama-3.2-3b-instruct-q5_k_m.gguf"
        URL="https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
        ;;
    4)
        MODEL_NAME="ALL"
        ;;
    5)
        echo "Exiting without downloading."
        exit 0
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac

download_file() {
    local file=$1
    local url=$2
    echo "-> Downloading $file..."
    podman run --rm -v local-ai_llama-models:/models alpine:latest \
        sh -c "apk add --no-cache curl && curl -L -C - '$url' -o /models/$file"
}

if [ "$MODEL_NAME" = "ALL" ]; then
    download_file "qwen2.5-7b-instruct-q3_k_m.gguf" "https://huggingface.co/Qwen/Qwen2.5-7B-Instruct-GGUF/resolve/main/qwen2.5-7b-instruct-q3_k_m.gguf"
    download_file "qwen2.5-coder-7b-instruct-q4_k_m.gguf" "https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/qwen2.5-coder-7b-instruct-q4_k_m.gguf"
    download_file "llama-3.2-3b-instruct-q5_k_m.gguf" "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q5_K_M.gguf"
else
    download_file "$MODEL_NAME" "$URL"
fi

echo "-> Download(s) finished successfully in volume 'local-ai_llama-models'."
