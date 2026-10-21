#!/usr/bin/env bash
#
# @description  Case-based tests for sync-framework.sh.
# @usage        .agents/scripts/sync-framework_test.sh
# @output       PASS/FAIL per test case, summary at end.
# @requires     bash v4+, git
# @version      0.1.0
# @updated      2026-10-21
set -euo pipefail

scriptDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
syncScript="$scriptDir/sync-framework.sh"

passCount=0
failCount=0
caseDir=""

#
## Test Helpers
#

cleanupCaseDirectory() {
  if [[ -n "$caseDir" ]]; then
    rm -rf "$caseDir"
  fi
}

assertEquals() {
  local label="$1"
  local expected="$2"
  local actual="$3"

  if [[ "$actual" == "$expected" ]]; then
    echo "PASS $label"
    passCount=$((passCount + 1))
    return
  fi

  cat <<EOF
FAIL $label
  expected: $expected
  actual: $actual
EOF
  failCount=$((failCount + 1))
}

assertFrameworkCall() {
  local label="$1"
  local expectedExit="$2"
  local expectedPattern="$3"
  local caseDir="$4"
  local functionName="$5"
  shift 5

  local actualOutput actualExit
  actualExit=0
  actualOutput=$( (
    cd "${caseDir}/project"
    source "$syncScript"
    "$functionName" "$@"
  ) 2>&1 ) || actualExit=$?

  if [[ "$actualExit" != "$expectedExit" ]]; then
    cat <<EOF
FAIL $label
  expected exit=$expectedExit, got exit=$actualExit
  output: $actualOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  if [[ "$actualOutput" != *"$expectedPattern"* ]]; then
    cat <<EOF
FAIL $label
  expected output to contain: $expectedPattern
  output: $actualOutput
EOF
    failCount=$((failCount + 1))
    return
  fi

  echo "PASS $label"
  passCount=$((passCount + 1))
}

createFrameworkProject() {
  local caseDir="$1"
  mkdir -p "$caseDir/seed" "$caseDir/project"
  git init --bare -q --initial-branch=main "$caseDir/origin.git"
  git init -q --initial-branch=main "$caseDir/seed"
  git -C "$caseDir/seed" config user.email test@example.com
  git -C "$caseDir/seed" config user.name Test
  echo first > "$caseDir/seed/README.md"
  git -C "$caseDir/seed" add README.md
  git -C "$caseDir/seed" commit -qm "first"
  git -C "$caseDir/seed" remote add origin "$caseDir/origin.git"
  git -C "$caseDir/seed" push -qu origin main
  git -C "$caseDir/seed" checkout -q -b develop
  echo develop > "$caseDir/seed/develop.txt"
  git -C "$caseDir/seed" add develop.txt
  git -C "$caseDir/seed" commit -qm "develop work"
  git -C "$caseDir/seed" push -qu origin develop
  git -C "$caseDir/seed" checkout -q main
  git clone -q "$caseDir/origin.git" "$caseDir/project/.agents"
}

trap cleanupCaseDirectory EXIT

#
## Test Cases
#

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
assertFrameworkCall "update no-op" 0 "frameworkChanged=no" \
  "$caseDir" updateFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
echo second >> "$caseDir/seed/README.md"
git -C "$caseDir/seed" commit -qam "second"
git -C "$caseDir/seed" push -q origin main
assertFrameworkCall "update with a new commit" 0 "frameworkChanged=yes" \
  "$caseDir" updateFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
git -C "$caseDir/project/.agents" remote set-url origin \
  "$caseDir/missing.git"
assertFrameworkCall "failed pull" 1 "FrameworkNotUpdated" \
  "$caseDir" updateFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
assertFrameworkCall "check in sync" 0 "frameworkRemoteState=reachable" \
  "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
echo second >> "$caseDir/seed/README.md"
git -C "$caseDir/seed" commit -qam "second"
git -C "$caseDir/seed" push -q origin main
assertFrameworkCall "check behind" 1 "FrameworkOutOfSync" \
  "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
git -C "$caseDir/project/.agents" remote set-url origin \
  "$caseDir/missing.git"
assertFrameworkCall "check with unreachable remote" 1 \
  "frameworkRemoteState=unknown" "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
assertFrameworkCall "track a valid ref" 0 "frameworkRef=develop" \
  "$caseDir" trackFrameworkRef develop
actualBranch=$(git -C "$caseDir/project/.agents" \
  rev-parse --abbrev-ref HEAD)
assertEquals "track checks out the ref" "develop" "$actualBranch"
actualUpstream=$(git -C "$caseDir/project/.agents" rev-parse \
  --abbrev-ref --symbolic-full-name '@{upstream}')
assertEquals "track sets the upstream" "origin/develop" "$actualUpstream"
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
assertFrameworkCall "track an unknown ref" 1 "UnknownFrameworkRef" \
  "$caseDir" trackFrameworkRef does-not-exist
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
assertFrameworkCall "invalid ref format" 2 "InvalidFrameworkRef" \
  "$caseDir" trackFrameworkRef "bad..ref"
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
rm -rf "$caseDir/project/.agents"
assertFrameworkCall "missing clone" 1 \
  "FrameworkCloneMissing: '${caseDir}/project/.agents'" \
  "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
rm -rf "$caseDir/project/.agents"
mkdir -p "$caseDir/project/.agents"
assertFrameworkCall "directory is not a worktree" 1 \
  "FrameworkCloneMissing: '${caseDir}/project/.agents'" \
  "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
echo dirty >> "$caseDir/project/.agents/README.md"
assertFrameworkCall "dirty clone during track" 0 "README.md" \
  "$caseDir" trackFrameworkRef main
actualStatus=$(git -C "$caseDir/project/.agents" status --porcelain)
assertEquals "dirty clone is reset" "" "$actualStatus"
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
git -C "$caseDir/project/.agents" config user.email test@example.com
git -C "$caseDir/project/.agents" config user.name Test
echo local > "$caseDir/project/.agents/local.txt"
git -C "$caseDir/project/.agents" add local.txt
git -C "$caseDir/project/.agents" commit -qm "local work"
assertFrameworkCall "local commits are listed" 0 "local work" \
  "$caseDir" trackFrameworkRef main
rm -rf "$caseDir"

caseDir=$(mktemp -d)
createFrameworkProject "$caseDir"
rm -rf "$caseDir/project/.agents"
ln -s . "$caseDir/project/.agents"
git init -q --initial-branch=main "$caseDir/project"
assertFrameworkCall "clone points at the project" 1 \
  "FrameworkCloneIsProject" "$caseDir" checkFrameworkClone
rm -rf "$caseDir"

#
## Results
#

cat <<EOF

Results: $passCount passed, $failCount failed
EOF
[[ $failCount -eq 0 ]]
