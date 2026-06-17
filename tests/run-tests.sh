#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cd "$repo_root"

python3 tests/validate-skill.py skills/fair-contribution-commits
bash scripts/scan-text-hygiene.sh

install_home="$tmp_dir/codex-home"
CODEX_HOME="$install_home" bash scripts/install.sh >/dev/null
test -f "$install_home/skills/fair-contribution-commits/SKILL.md"

git_dir="$tmp_dir/repo"
mkdir -p "$git_dir"
cd "$git_dir"
git init -q
git config user.name "Example Human"
git config user.email "123456+example@users.noreply.github.com"

printf 'one\n' > one.txt
git add one.txt
git commit -q -m 'Initial example' -m 'Co-authored-by: Codex <267193182+codex@users.noreply.github.com>'

EXPECTED_AUTHOR_NAME="Example Human" \
EXPECTED_AUTHOR_EMAIL="123456+example@users.noreply.github.com" \
bash "$repo_root/scripts/check-commit-attribution.sh" HEAD >/dev/null

REQUIRE_ALL_CODEX_ATTRIBUTION=true bash "$repo_root/scripts/scan-repo-attribution.sh" HEAD >/dev/null

printf 'two\n' > two.txt
git add two.txt
git commit -q -m 'Missing trailer example'

if bash "$repo_root/scripts/check-commit-attribution.sh" HEAD >/dev/null 2>&1; then
  echo "Expected check-commit-attribution.sh to fail without Codex trailer." >&2
  exit 1
fi

if REQUIRE_ALL_CODEX_ATTRIBUTION=true bash "$repo_root/scripts/scan-repo-attribution.sh" HEAD >/dev/null 2>&1; then
  echo "Expected scan-repo-attribution.sh to fail when a commit is missing the trailer." >&2
  exit 1
fi

echo "OK: tests passed"
