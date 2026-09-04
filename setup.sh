#!/usr/bin/env bash
# Install juanstack skills and pipelines into ~/.claude. Re-run after editing.
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
SKILLS="$HOME/.claude/skills"
PIPELINES="$HOME/.claude/pipelines"

mkdir -p "$SKILLS" "$PIPELINES"
cp -R "$REPO"/skills/* "$SKILLS"/
cp "$REPO"/pipelines/*.yaml "$PIPELINES"/

echo "Skills -> $SKILLS"
for d in "$REPO"/skills/*/; do echo "  $(basename "$d")"; done
echo "Pipelines -> $PIPELINES"
for f in "$REPO"/pipelines/*.yaml; do echo "  $(basename "$f")"; done

if [ ! -f "$SKILLS/opportunity-doctrine/matrix.local.md" ]; then
  echo
  echo "Note: opportunity-doctrine needs $SKILLS/opportunity-doctrine/matrix.local.md"
  echo "      (copy matrix.example.md next to it and fill in your numbers)"
fi

echo
echo "Try: claude \"run the voice-to-post pipeline on this: <paste a braindump>\""
