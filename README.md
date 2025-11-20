# sound-samples
Personal library of samples for the OP-Z and other gear. Root-level files are one-off samples; platform-specific packs and utilities live in their own folders.

## Folder layout
- `Bass/`, `Drums/`, `Guitars/`, `Synths/`: Raw recordings and tweaked single hits/phrases.
- `OP-Z/`: Platform-specific packs, backups, and helper apps/zips (e.g., drum utility, datapacks, personal kits).
- `scripts/`: Batch helpers to prep samples for devices.

## Workflow notes
- Keep final, ready-to-load assets at project root; stash in-progress edits in a subfolder so the root stays clean.
- Name files with instrument + context (e.g., `kick-warm-110bpm.wav`); include tempo/key when relevant.
- If a pack targets specific hardware (OP-Z, OP-1, etc.), keep its assets and backups inside that platform folder to avoid mixing formats.
- When adding scripts, include a quick one-liner usage in the script header so it’s clear how to run batch conversions.

## OP-Z conversion helper
- Script: `scripts/convert_to_opz.sh` (uses `ffmpeg`).
- Default input: `OP-Z/my samples`; output: `OP-Z/my samples/opz-ready`.
- Converts to mono, 44.1kHz, 16-bit little-endian AIFF, strips metadata, normalizes loudness, and trims to 12s by default (set `MAX_DURATION=0` to disable trimming).
- Usage: `./scripts/convert_to_opz.sh [input_dir] [output_dir]` (directories optional).
