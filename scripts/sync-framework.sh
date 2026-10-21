#!/usr/bin/env bash
#
# @description  Updates, checks, or retargets the .agents/ framework clone.
# @usage        .agents/scripts/sync-framework.sh [--check | --track <ref> | -h]
# @output       Framework state keys on stdout. Warnings on stderr.
# @requires     bash v4+, git
# @version      1.1.0
# @updated      2026-10-21
#
# Run this script from the project root. It updates the .agents/ clone and
# never copies files between the project tree and the clone.

set -euo pipefail

projectRoot="$PWD"
cloneDir="${projectRoot}/.agents"

#
## Framework Clone
#

printFrameworkUsage() {
  cat <<'EOF'
Usage: .agents/scripts/sync-framework.sh [option]

Run this script from the project root. It updates the .agents/ framework
clone. With no option, pull the current branch with --ff-only.

Options:
  --check          Compare HEAD with the remote branch. No fetch.
  --track <ref>    Fetch origin, then reset the clone to origin/<ref>.
  -h, --help       Show this help.
EOF
}

requireFrameworkClone() {
  local cloneTopLevel resolvedCloneDir resolvedProjectRoot
  cloneTopLevel=$(git -C "$cloneDir" rev-parse \
    --show-toplevel 2>/dev/null) || true
  resolvedCloneDir=$(cd "$cloneDir" 2>/dev/null && pwd -P) || true
  resolvedProjectRoot=$(cd "$projectRoot" 2>/dev/null && pwd -P) || true

  if [[ -n "$resolvedCloneDir" &&
    "$resolvedCloneDir" == "$resolvedProjectRoot" ]]; then
    cat >&2 <<EOF
FrameworkCloneIsProject: '${resolvedCloneDir}' is the project repository.
Point the clone at a separate .agents/ directory, then retry.
EOF
    exit 1
  fi

  if [[ -z "$cloneTopLevel" || "$cloneTopLevel" != "$resolvedCloneDir" ]]; then
    cat >&2 <<EOF
FrameworkCloneMissing: '${resolvedCloneDir:-${cloneDir}}' is not a git worktree.
Install the framework clone, or restore it, then retry.
EOF
    exit 1
  fi

  local cloneGitDir projectGitDir
  cloneGitDir=$(git -C "$cloneDir" rev-parse --absolute-git-dir)
  projectGitDir=$(git -C "$projectRoot" rev-parse --absolute-git-dir \
    2>/dev/null) || projectGitDir=""

  if [[ -n "$projectGitDir" && "$cloneGitDir" == "$projectGitDir" ]]; then
    cat >&2 <<EOF
FrameworkCloneIsProject: '${resolvedCloneDir}' is the project repository.
Point the clone at a separate .agents/ directory, then retry.
EOF
    exit 1
  fi
}

reportFrameworkUpdateFailure() {
  local previousHash="$1"
  local lastCommitDate
  lastCommitDate=$(git -C "$cloneDir" log -1 --format=%cs)

  cat >&2 <<EOF
WARNING: FrameworkNotUpdated: the clone could not pull from origin.
WARNING: The session continues on the existing clone at ${previousHash}.
WARNING: framework not updated since ${lastCommitDate}.
EOF
  exit 1
}

updateFrameworkClone() {
  requireFrameworkClone

  local branch
  branch=$(git -C "$cloneDir" rev-parse --abbrev-ref HEAD)

  if [[ "$branch" == "HEAD" ]]; then
    echo "FrameworkDetachedHead: the clone is not on a branch." >&2
    exit 1
  fi

  echo "frameworkBranch=${branch}"

  local previousHash
  previousHash=$(git -C "$cloneDir" rev-parse --short HEAD)
  echo "frameworkBefore=${previousHash}"

  if ! git -C "$cloneDir" pull --quiet --ff-only; then
    reportFrameworkUpdateFailure "$previousHash"
  fi

  local currentHash
  currentHash=$(git -C "$cloneDir" rev-parse --short HEAD)
  echo "frameworkAfter=${currentHash}"

  if [[ "$currentHash" == "$previousHash" ]]; then
    echo "frameworkChanged=no"
    return
  fi
  echo "frameworkChanged=yes"
}

checkFrameworkClone() {
  requireFrameworkClone

  local branch shortHash fullHash subject
  branch=$(git -C "$cloneDir" rev-parse --abbrev-ref HEAD)
  shortHash=$(git -C "$cloneDir" rev-parse --short HEAD)
  fullHash=$(git -C "$cloneDir" rev-parse HEAD)
  subject=$(git -C "$cloneDir" log -1 --format=%s)

  if [[ "$branch" == "HEAD" ]]; then
    echo "FrameworkDetachedHead: the clone is not on a branch." >&2
    exit 1
  fi

  if ! git -C "$cloneDir" rev-parse --verify --quiet \
    "refs/remotes/origin/${branch}^{commit}" >/dev/null; then
    echo "FrameworkRemoteMissing: origin/${branch} does not exist." >&2
    exit 1
  fi

  local behindCount aheadCount
  behindCount=$(git -C "$cloneDir" rev-list --count "HEAD..origin/${branch}")
  aheadCount=$(git -C "$cloneDir" rev-list --count "origin/${branch}..HEAD")

  local worktreeStatus worktreeState
  worktreeStatus=$(git -C "$cloneDir" status --porcelain)
  worktreeState="clean"
  if [[ -n "$worktreeStatus" ]]; then
    worktreeState="dirty"
  fi

  local remoteState remoteHead
  remoteState="unknown"
  remoteHead=""
  if remoteHead=$(git -C "$cloneDir" ls-remote --heads origin \
    "refs/heads/${branch}" | cut -f1) && [[ -n "$remoteHead" ]]; then
    remoteState="reachable"
  fi

  cat <<EOF
frameworkBranch=${branch}
frameworkHead=${shortHash}
frameworkSubject=${subject}
frameworkBehind=${behindCount}
frameworkAhead=${aheadCount}
frameworkWorktree=${worktreeState}
frameworkRemoteState=${remoteState}
EOF

  if [[ "$remoteState" == "unknown" ]]; then
    echo "FrameworkRemoteUnknown: cannot confirm sync with" \
      "origin/${branch}." >&2
    exit 1
  fi

  echo "frameworkRemoteHead=${remoteHead}"

  if [[ "$remoteHead" != "$fullHash" ]]; then
    echo "FrameworkOutOfSync: HEAD ${fullHash} differs from" \
      "origin/${branch} ${remoteHead}." >&2
    exit 1
  fi

  if [[ "$worktreeState" != "clean" ]]; then
    echo "FrameworkWorktreeDirty: the clone has uncommitted changes." >&2
    exit 1
  fi
  exit 0
}

trackFrameworkRef() {
  local requestedRef="$1"
  requireFrameworkClone

  if ! git check-ref-format --branch "$requestedRef" >/dev/null 2>&1; then
    echo "InvalidFrameworkRef: '${requestedRef}' is not a valid branch." >&2
    exit 2
  fi

  if ! git -C "$cloneDir" fetch origin; then
    echo "FrameworkFetchFailed: could not fetch origin." >&2
    exit 1
  fi

  if ! git -C "$cloneDir" show-ref --verify --quiet \
    "refs/remotes/origin/${requestedRef}"; then
    echo "UnknownFrameworkRef: '${requestedRef}' does not exist on origin." >&2
    exit 1
  fi

  local trackedChanges currentBranch discardedCommits
  trackedChanges=$(git -C "$cloneDir" status --porcelain \
    --untracked-files=no)
  currentBranch=$(git -C "$cloneDir" rev-parse --abbrev-ref HEAD)

  discardedCommits=""
  if [[ "$currentBranch" == "$requestedRef" ]]; then
    discardedCommits=$(git -C "$cloneDir" log --oneline \
      "origin/${requestedRef}..HEAD")
  elif git -C "$cloneDir" show-ref --verify --quiet \
    "refs/heads/${requestedRef}"; then
    discardedCommits=$(git -C "$cloneDir" log --oneline \
      "origin/${requestedRef}..${requestedRef}")
  fi

  local discardedWork=""
  if [[ -n "$trackedChanges" ]]; then
    discardedWork+="Tracked modifications:"$'\n'"${trackedChanges}"
  fi
  if [[ -n "$discardedCommits" ]]; then
    if [[ -n "$discardedWork" ]]; then
      discardedWork+=$'\n'
    fi
    discardedWork+="Discarded commits:"$'\n'"${discardedCommits}"
  fi

  cat >&2 <<EOF
WARNING: FrameworkTrackDiscardsChanges: the clone is force-reset.
WARNING: The target is origin/${requestedRef}.
WARNING: Tracked modifications in the clone are discarded.
WARNING: Untracked files that collide with the target tree are removed.
${discardedWork}
EOF

  git -C "$cloneDir" checkout --force -B "$requestedRef" \
    "origin/${requestedRef}"
  git -C "$cloneDir" reset --hard "origin/${requestedRef}"
  git -C "$cloneDir" branch --set-upstream-to="origin/${requestedRef}" \
    "$requestedRef"

  local shortHash
  shortHash=$(git -C "$cloneDir" rev-parse --short HEAD)
  cat <<EOF
frameworkRef=${requestedRef}
frameworkHead=${shortHash}
EOF
}

#
## Runtime
#

if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  return 0
fi

case "${1:-}" in
  "")
    updateFrameworkClone
    ;;
  --check)
    checkFrameworkClone
    ;;
  --track)
    if [[ -z "${2:-}" ]]; then
      echo "MissingFrameworkRef: --track requires a ref name." >&2
      printFrameworkUsage >&2
      exit 2
    fi
    trackFrameworkRef "$2"
    ;;
  -h|--help)
    printFrameworkUsage
    ;;
  *)
    echo "UnknownArgument: $1" >&2
    printFrameworkUsage >&2
    exit 2
    ;;
esac
