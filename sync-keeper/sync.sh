#!/bin/bash
# Sync Keeper helper (IDE-friendly)
# Usage: sync.sh [--upstream owner/repo] [--upstream-branch branch] [--target-branch branch] [--mode merge|rebase] [--allow-unrelated true|false] [--push true|false]
# Environment variables override flags: UPSTREAM_REPO, UPSTREAM_BRANCH, TARGET_BRANCH, MERGE_STRATEGY, ALLOW_UNRELATED, PUSH, RESOLUTION_MODE

set -euo pipefail

show_help() {
  cat <<'USAGE'
Sync Keeper helper - IDE-friendly

Usage:
  sync.sh [options]

Options:
  --upstream OWNER/REPO     Upstream repository (default: ntorga/agent-starter-kit)
  --upstream-branch BRANCH  Upstream branch (default: main)
  --target-branch BRANCH    Local target branch to branch off (default: main)
  --mode merge|rebase       Merge strategy (default: merge)
  --allow-unrelated true    Allow merging unrelated histories (explicit opt-in)
  --push true|false         Whether to push the result to origin (default: true)
  --resolution-mode MODE    Conflict resolution mode: attempt|preview|manual (overrides .agent.md)
  --help                    Show this help

Environment variables override flags. When running locally in your IDE, set PUSH=false to avoid pushing to remote.
This script will create a preview sync branch and, on conflicts, may create a resolution branch to attempt conservative resolutions.
USAGE
}

main() {
  local ARGS
  ARGS=$(getopt -o h --long help,upstream:,upstream-branch:,target-branch:,mode:,allow-unrelated:,push:,resolution-mode: -n "sync.sh" -- "$@")
  eval set -- "$ARGS"
  while true; do
    case "$1" in
      --upstream) UPSTREAM_REPO="$2"; shift 2;;
      --upstream-branch) UPSTREAM_BRANCH="$2"; shift 2;;
      --target-branch) TARGET_BRANCH="$2"; shift 2;;
      --mode) MERGE_STRATEGY="$2"; shift 2;;
      --allow-unrelated) ALLOW_UNRELATED="$2"; shift 2;;
      --push) PUSH="$2"; shift 2;;
      --resolution-mode) RESOLUTION_MODE="$2"; shift 2;;
      -h|--help) show_help; exit 0;;
      --) shift; break;;
      *) break;;
    esac
  done

  UPSTREAM_REPO=${UPSTREAM_REPO:-ntorga/agent-starter-kit}
  UPSTREAM_BRANCH=${UPSTREAM_BRANCH:-main}
  TARGET_BRANCH=${TARGET_BRANCH:-main}
  MERGE_STRATEGY=${MERGE_STRATEGY:-merge}
  ALLOW_UNRELATED=${ALLOW_UNRELATED:-false}
  PUSH=${PUSH:-true}
  RESOLUTION_MODE=${RESOLUTION_MODE:-attempt}

  echo "Sync Keeper: upstream=${UPSTREAM_REPO} ${UPSTREAM_BRANCH} -> target=${TARGET_BRANCH} (strategy=${MERGE_STRATEGY}, resolution=${RESOLUTION_MODE}, allow_unrelated=${ALLOW_UNRELATED}, push=${PUSH})"

  git config user.name "Sync Keeper"
  git config user.email "sync-keeper@example.com"

  # ensure upstream remote exists and is fetched
  if ! git remote get-url upstream >/dev/null 2>&1; then
    git remote add upstream https://github.com/${UPSTREAM_REPO}.git || true
  fi
  git fetch upstream --no-tags --prune --depth=1

  # create branch off target
  local DATE
  DATE=$(date +%Y%m%d)
  local SYNC_BRANCH
  SYNC_BRANCH=sync/upstream-${UPSTREAM_BRANCH}-${DATE}
  if git rev-parse --verify origin/${TARGET_BRANCH} >/dev/null 2>&1; then
    git checkout -b "${SYNC_BRANCH}" origin/${TARGET_BRANCH}
  elif git rev-parse --verify ${TARGET_BRANCH} >/dev/null 2>&1; then
    git checkout -b "${SYNC_BRANCH}" ${TARGET_BRANCH}
  else
    git checkout -b "${SYNC_BRANCH}"
  fi

  echo "Created branch ${SYNC_BRANCH}"

  if [ "${MERGE_STRATEGY}" = "rebase" ]; then
    git fetch upstream ${UPSTREAM_BRANCH}
    if ! git rebase upstream/${UPSTREAM_BRANCH}; then
      echo "REBASE_FAILED"
      git rebase --abort || true
      exit 1
    fi
  else
    # default merge (no-ff)
    local MERGE_CMD=(git merge --no-ff upstream/${UPSTREAM_BRANCH} -m "chore: sync from upstream/${UPSTREAM_BRANCH}")
    if [ "${ALLOW_UNRELATED}" = "true" ]; then
      MERGE_CMD=(git merge --no-ff --allow-unrelated-histories upstream/${UPSTREAM_BRANCH} -m "chore: sync from upstream/${UPSTREAM_BRANCH}")
    fi
    if ! "${MERGE_CMD[@]}"; then
      echo "MERGE_CONFLICT"
      # create a resolution branch from the conflicted state
      local RESOLVE_BRANCH
      RESOLVE_BRANCH=${SYNC_BRANCH}-resolve
      git checkout -b "$RESOLVE_BRANCH"

      # gather conflicted files
      local conflicted
      conflicted=$(git diff --name-only --diff-filter=U || true)
      echo "Conflicted files:\n$conflicted"

      # default patterns (can be customized)
      local prefer_local_patterns=("AGENTS.md" "rules/**" "skills/**" "personas/**")
      local prefer_upstream_patterns=()

      local resolved=()
      local unresolved=()
      local f matched_local matched_upstream p tmp_local tmp_theirs
      IFS=$'\n'
      for f in $conflicted; do
        matched_local=false
        matched_upstream=false
        for p in "${prefer_local_patterns[@]}"; do
          if [[ "$f" == $p || "$f" == ${p//**/*}* ]]; then
            matched_local=true
            break
          fi
        done
        for p in "${prefer_upstream_patterns[@]}"; do
          if [[ "$f" == $p || "$f" == ${p//**/*}* ]]; then
            matched_upstream=true
            break
          fi
        done

        if [ "$RESOLUTION_MODE" = "preview" ]; then
          unresolved+=("$f")
          continue
        fi

        if [ "$matched_local" = true ]; then
          echo "Resolving $f -> prefer local (ours)"
          git checkout --ours -- "$f" || true
          git add "$f" || true
          resolved+=("$f")
          continue
        fi

        if [ "$matched_upstream" = true ]; then
          echo "Resolving $f -> prefer upstream (theirs)"
          git checkout --theirs -- "$f" || true
          git add "$f" || true
          resolved+=("$f")
          continue
        fi

        # not matched: attempt safe heuristic for whitespace/formatting conflicts
        # prefer local if unchanged apart from whitespace
        tmp_local=$(mktemp)
        tmp_theirs=$(mktemp)
        git show :1:"$f" > "$tmp_local" 2>/dev/null || true
        git show :2:"$f" > "$tmp_theirs" 2>/dev/null || true
        if diff -w "$tmp_local" "$tmp_theirs" >/dev/null 2>&1; then
          echo "Resolving $f (whitespace-only conflict) -> prefer local"
          git checkout --ours -- "$f" || true
          git add "$f" || true
          resolved+=("$f")
        else
          echo "Left unresolved: $f"
          unresolved+=("$f")
        fi
        rm -f "$tmp_local" "$tmp_theirs"
      done

      if [ ${#unresolved[@]} -ne 0 ]; then
        echo "Unresolved conflicts remain:" >&2
        printf '%s\n' "${unresolved[@]}" >&2
        echo "Wrote resolution report to .sync/resolution-report-${DATE}.md"
        mkdir -p .sync
        {
          echo "Resolution attempt for ${DATE}";
          echo "Resolved:"; printf '%s\n' "${resolved[@]}";
          echo; echo "Unresolved:"; printf '%s\n' "${unresolved[@]}";
        } > .sync/resolution-report-${DATE}.md
        # leave the resolution branch for manual work
        if [ "$PUSH" = "true" ]; then
          git push origin HEAD:$RESOLVE_BRANCH || true
          echo "Pushed resolution branch: $RESOLVE_BRANCH"
        else
          echo "Resolution branch created locally: $RESOLVE_BRANCH (PUSH=false)"
        fi
        exit 2
      fi

      # all resolved: commit
      git commit -m "chore(sync): resolved conflicts for upstream/${UPSTREAM_BRANCH} on ${DATE}" || true
      echo "Committed resolution on $RESOLVE_BRANCH"

      # run checks
      echo "Running lightweight checks (non-fatal)"
      python3 -m unittest discover -v || true
      python3 skills/assets/check_markdown.py .context.md README.md AGENTS.md CHANGELOG.md docs/.context.md docs/CONTRIBUTING.md docs/features.md docs/roadmap.md || true

      if [ "$PUSH" = "true" ]; then
        git push origin HEAD:$RESOLVE_BRANCH
        echo "Pushed resolution branch: $RESOLVE_BRANCH"
        echo "You can create a draft PR with:"
        echo "  gh pr create --base ${TARGET_BRANCH} --head ${RESOLVE_BRANCH} --title \"chore: resolve upstream sync (${DATE})\" --body \"Automated resolution attempt by Sync Keeper. Jules, please review.\" --draft"
      else
        echo "Resolution branch $RESOLVE_BRANCH is available locally. Create a PR when ready."
      fi
      exit 0
    fi
  fi

  echo "Running configured lightweight checks (non-fatal)"
  python3 -m unittest discover -v || true
  python3 skills/assets/check_markdown.py .context.md README.md AGENTS.md CHANGELOG.md docs/.context.md docs/CONTRIBUTING.md docs/features.md docs/roadmap.md || true

  if [ "$PUSH" = "true" ]; then
    echo "Pushing ${SYNC_BRANCH} to origin"
    git push origin HEAD:${SYNC_BRANCH}
    echo "You can create a draft PR with:"
    echo "  gh pr create --base ${TARGET_BRANCH} --head ${SYNC_BRANCH} --title \"chore: sync from ${UPSTREAM_REPO} (${UPSTREAM_BRANCH})\" --body \"Automated sync PR created by Sync Keeper. Jules will review.\" --draft"
  else
    echo "PUSH=false: not pushing branch. Branch available locally: ${SYNC_BRANCH}"
    echo "To push and create a draft PR, run:"
    echo "  git push origin HEAD:${SYNC_BRANCH}"
    echo "  gh pr create --base ${TARGET_BRANCH} --head ${SYNC_BRANCH} --title \"chore: sync from ${UPSTREAM_REPO} (${UPSTREAM_BRANCH})\" --body \"Automated sync PR created by Sync Keeper. Jules will review.\" --draft"
  fi

  echo "Done. Branch: ${SYNC_BRANCH}"
}

main "$@"
