# OP-Z samples
Quick notes for prepping samples for the OP-Z.

## Limits
- Up to ~12s per sample for one-shots/phrases.
- Keep to ~6s for chromatic/synth tracks so pitching stays responsive and memory is safe.

## Format the OP-Z likes
- AIFF, mono, 44.1kHz, 16-bit **little endian**.
- Avoid metadata; keep names short and clear (e.g., `bass-pluck-a4.aif`).

## Folders
- `my samples/`: working files and exports you’ll load onto the OP-Z.
- `my samples/opz-ready/`: auto-generated outputs from the conversion script.
- `backups/`: device backups, notes, and reference docs.
- `other/`: downloaded packs/utilities.

## Converting (batch)
From repo root:
```
./scripts/convert_to_opz.sh "OP-Z/my samples" "OP-Z/my samples/opz-ready"
```
- Drums/phrases (default ~12s): `./scripts/convert_to_opz.sh "OP-Z/my samples" "OP-Z/my samples/opz-ready"`
- Synth/chromatic (trim to 6s): `MAX_DURATION=6 ./scripts/convert_to_opz.sh "OP-Z/my samples" "OP-Z/my samples/opz-ready"`
- Disable trimming: `MAX_DURATION=0 ./scripts/convert_to_opz.sh "OP-Z/my samples" "OP-Z/my samples/opz-ready"`
- Output files are suffixed with `-opz.aif`.

## Checklist before copying to OP-Z
- Files are mono, 44.1kHz, 16-bit LE.
- Length fits your use (≤12s; ≤6s for synth use).
- Names are short and readable.
