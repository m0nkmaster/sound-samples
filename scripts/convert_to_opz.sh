#!/usr/bin/env bash
# Convert audio files to OP-Z-friendly AIFF: mono, 44.1kHz, 16-bit little endian, optional trim + normalization.
set -euo pipefail

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required to run this script" >&2
  exit 1
fi

IN_DIR=${1:-"OP-Z/my samples"}
OUT_DIR=${2:-"$IN_DIR/opz-ready"}
MAX_DURATION=${MAX_DURATION:-12}                 # seconds; set to 0 to skip trimming
NORMALIZE_MODE=${NORMALIZE_MODE:-loudnorm}       # loudnorm | peak
TARGET_LUFS=${TARGET_LUFS:--14}                  # integrated loudness target (loudnorm)
TARGET_TP=${TARGET_TP:--1.2}                     # true peak ceiling (loudnorm)
TARGET_LRA=${TARGET_LRA:-11}                     # loudness range target (loudnorm)
TRIM_SILENCE=${TRIM_SILENCE:-1}                  # set to 0 to keep leading silence
SILENCE_THRESHOLD_DB=${SILENCE_THRESHOLD_DB:--35} # threshold for silenceremove
TARGET_SR=44100

mkdir -p "$OUT_DIR"

# Enable case-insensitive globbing for extensions.
shopt -s nullglob nocaseglob

for input in "$IN_DIR"/*.{aif,aiff,wav,m4a,mp3,flac}; do
  [ -e "$input" ] || continue
  filename=$(basename "$input")
  stem=${filename%.*}
  output="$OUT_DIR/${stem}-opz.aif"

  # Build filters: optional silence trim, then loudness target, optional duration trim.
  filters=()
  if [ "$TRIM_SILENCE" -eq 1 ]; then
    # Trim leading silence to prevent fade-in perception when playing on device.
    filters+=("silenceremove=start_periods=1:start_duration=0:start_threshold=${SILENCE_THRESHOLD_DB}dB")
  fi

  if [ "$NORMALIZE_MODE" = "peak" ]; then
    # Simple peak/limiter chain to avoid pumping.
    filters+=("acompressor=threshold=-18dB:ratio=2:attack=5:release=50")
    filters+=("alimiter=limit=-1dB")
  else
    # Loudness normalize (default) with linear response to avoid early ramps.
    filters+=("loudnorm=I=${TARGET_LUFS}:TP=${TARGET_TP}:LRA=${TARGET_LRA}:linear=true:dual_mono=true")
    # Safety limiter after loudnorm to catch inter-sample overs.
    filters+=("alimiter=limit=${TARGET_TP}dB")
  fi

  if [ "$MAX_DURATION" -gt 0 ]; then
    filters+=("atrim=0:${MAX_DURATION}")
    filters+=("asetpts=N/SR/TB")
  fi
  filter_str=$(IFS=","; echo "${filters[*]}")

  ffmpeg -y -i "$input" \
    -ac 1 -ar "$TARGET_SR" \
    -sample_fmt s16 -acodec pcm_s16le \
    -af "$filter_str" \
    -map_metadata -1 \
    "$output"

  echo "Converted: $input -> $output"
done
