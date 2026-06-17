#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_name="fair-contribution-commits"
source_dir="$repo_root/skills/$skill_name"
target_root="${CODEX_HOME:-$HOME/.codex}/skills"
target_dir="$target_root/$skill_name"

if [[ ! -f "$source_dir/SKILL.md" ]]; then
  echo "Skill source not found: $source_dir" >&2
  exit 1
fi

mkdir -p "$target_root"
rm -rf "$target_dir"
cp -R "$source_dir" "$target_dir"

echo "Installed $skill_name to $target_dir"
