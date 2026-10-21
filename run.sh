#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

VENV_DIR="${VANISH_VENV:-.venv}"
PY="$VENV_DIR/bin/python"

if [[ ! -x "$PY" ]]; then
  echo "[Vanish] Creating Python environment..."
  if command -v uv >/dev/null; then
    uv venv -q -p 3.12 "$VENV_DIR"
  else
    python3 -m venv "$VENV_DIR"
  fi
fi

if ! "$PY" -c "import cv2, mediapipe, numpy, pyvirtualcam, pygame" >/dev/null 2>&1; then
  echo "[Vanish] Installing dependencies (internet needed once)..."
  if command -v uv >/dev/null; then
    uv pip install -q -p "$PY" -r requirements.txt
  else
    "$PY" -m pip install -q -r requirements.txt
  fi
fi

if ! grep -q "Vanish Cam\|v4l2loopback" /sys/class/video4linux/*/name 2>/dev/null; then
  echo "[Vanish] No v4l2loopback device found: only the local preview will work."
  echo "[Vanish] To load it: sudo modprobe v4l2loopback devices=1 video_nr=10 exclusive_caps=1 card_label=\"Vanish Cam\""
fi

if [[ -z "${DISPLAY:-}" && -n "${WAYLAND_DISPLAY:-}" ]]; then
  echo "[Vanish] OpenCV windows need XWayland (DISPLAY is empty)."
fi
export QT_QPA_PLATFORM="${QT_QPA_PLATFORM:-xcb}"

exec "$PY" vanish_cam.py "$@"
