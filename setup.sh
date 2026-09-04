#!/usr/bin/env bash
# Install juanstack skills and pipelines. Re-run after editing.
#   ./setup.sh             -> ~/.claude  (Claude Code)
#   ./setup.sh --cursor    -> ~/.cursor  (Cursor)
#   ./setup.sh /some/root  -> /some/root/skills and /some/root/pipelines
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
case "${1:-}" in
  "")       ROOT="$HOME/.claude" ;;
  --cursor) ROOT="$HOME/.cursor" ;;
  *)        ROOT="$1" ;;
esac
SKILLS="$ROOT/skills"
PIPELINES="$ROOT/pipelines"

mkdir -p "$SKILLS" "$PIPELINES"
cp -R "$REPO"/skills/* "$SKILLS"/
cp "$REPO"/pipelines/*.yaml "$PIPELINES"/

echo "Skills -> $SKILLS";       ls "$REPO/skills"    | sed 's/^/  /'
echo "Pipelines -> $PIPELINES"; ls "$REPO/pipelines" | sed 's/^/  /'
[ -f "$SKILLS/opportunity-doctrine/matrix.local.md" ] || \
  echo "Note: opportunity-doctrine needs $SKILLS/opportunity-doctrine/matrix.local.md (see matrix.example.md)"
echo
echo 'Try: tell the agent "run the voice-to-post pipeline on this: <paste a braindump>"'
