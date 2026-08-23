#!/usr/bin/env bash
# Sync the framework files between the repository root and the nested .agents/
# clone so the two copies cannot silently drift apart.
#
# Usage:
#   scripts/sync-framework.sh            # sync root -> .agents/ (root is canonical)
#   scripts/sync-framework.sh --to-root  # sync .agents/ -> root (after `git -C .agents pull`)
#   scripts/sync-framework.sh --check    # report drift only, no writes
#
# The script refuses to sync when either side has uncommitted changes, so a
# sync never hides work in progress. Deletions in the source are reported but
# not auto-removed (kept intentionally conservative); remove them manually.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENTS_DIR="$ROOT_DIR/.agents"

# Framework paths tracked in both locations (relative to each root).
PATHS=(AGENTS.md personas skills rules)

usage() {
  grep '^#' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

arg="${1:-}"
arg="${arg%$'\r'}"
MODE=""
case "$arg" in
  "") MODE="to-agents" ;;
  --to-root) MODE="to-root" ;;
  --check) MODE="check" ;;
  -h|--help) usage 0 ;;
  *) echo "Unknown argument: $arg" >&2; usage 1 ;;
esac

# Refuse to sync with uncommitted (tracked) changes on either side.
for dir in "$ROOT_DIR" "$AGENTS_DIR"; do
  if [[ -n "$(git -C "$dir" status --porcelain 2>/dev/null | grep -v '^??')" ]]; then
    echo "ERROR: uncommitted changes in $dir — commit or stash before syncing." >&2
    exit 1
  fi
done

if [[ "$MODE" == "check" ]]; then
  if diff -rq "$ROOT_DIR/AGENTS.md" "$AGENTS_DIR/AGENTS.md" >/dev/null 2>&1 && \
     diff -rq "$ROOT_DIR/personas" "$AGENTS_DIR/personas" >/dev/null 2>&1 && \
     diff -rq "$ROOT_DIR/skills" "$AGENTS_DIR/skills" >/dev/null 2>&1 && \
     diff -rq "$ROOT_DIR/rules" "$AGENTS_DIR/rules" >/dev/null 2>&1; then
    echo "in sync"
  else
    echo "DRIFT DETECTED:"
    for p in "${PATHS[@]}"; do
      diff -rq "$ROOT_DIR/$p" "$AGENTS_DIR/$p" || true
    done
  fi
  exit 0
fi

SRC="$ROOT_DIR"
DST="$AGENTS_DIR"
[[ "$MODE" == "to-root" ]] && SRC="$AGENTS_DIR" && DST="$ROOT_DIR"

echo "Syncing: $SRC -> $DST"
for p in "${PATHS[@]}"; do
  cp -Rf "$SRC/$p" "$DST/$p"
  # Report files present in dst but missing in src (manual cleanup needed).
  while IFS= read -r extra; do
    echo "  NOTE: $extra exists in $DST but not in $SRC — remove manually if intended as deletion."
  done < <(diff -rq "$SRC/$p" "$DST/$p" 2>/dev/null | grep '^Only in '"$DST" | sed "s|^Only in $DST/||")
  echo "  synced $p"
done
echo "Done. Review the diff and commit on both sides."
