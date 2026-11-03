#!/usr/bin/env bash

# Get the GIDs of the host video and render groups
VIDEO_GID=$(getent group video | cut -d: -f3)
RENDER_GID=$(getent group render | cut -d: -f3)

if [ -z "$RENDER_GID" ]; then RENDER_GID=109; fi
if [ -z "$VIDEO_GID" ]; then VIDEO_GID=44; fi

# Set the default model when it is not passed via CLI or environment
export MODEL_FILE="${MODEL_FILE:-qwen2.5-coder-7b-instruct-q4_k_m.gguf}"
export VIDEO_GID
export RENDER_GID

echo "-> GIDs detected: video=$VIDEO_GID, render=$RENDER_GID"
echo "-> Selected model: $MODEL_FILE"

if [[ "$*" == *"-d"* ]]; then
    echo "-> Starting stack in the background..."
    nohup podman-compose "$@" > /dev/null 2>&1 &
    echo "-> Stack started!"
else
    exec podman-compose "$@"
fi
