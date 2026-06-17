#!/usr/bin/env bash
set -euo pipefail

range="${1:-HEAD}"
codex_name="${CODEX_COAUTHOR_NAME:-Codex}"
codex_email="${CODEX_COAUTHOR_EMAIL:-267193182+codex@users.noreply.github.com}"
trailer="Co-authored-by: $codex_name <$codex_email>"
require_all="${REQUIRE_ALL_CODEX_ATTRIBUTION:-false}"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 2
fi

if ! git rev-list --max-count=1 "$range" >/dev/null 2>&1; then
  echo "Invalid commit range: $range" >&2
  exit 2
fi

if [[ -z "$(git rev-list --max-count=1 "$range")" ]]; then
  echo "No commits found for range: $range" >&2
  exit 2
fi

total=0
with_codex=0
without_codex=0

while IFS= read -r sha; do
  total=$((total + 1))
  message="$(git log -1 --format=%B "$sha")"
  if printf '%s\n' "$message" | grep -Fqx "$trailer"; then
    with_codex=$((with_codex + 1))
  else
    without_codex=$((without_codex + 1))
    printf 'missing_codex_trailer %s %s\n' "$sha" "$(git log -1 --format=%s "$sha")"
  fi
done < <(git rev-list "$range")

printf 'total=%s with_codex=%s without_codex=%s\n' "$total" "$with_codex" "$without_codex"

if [[ "$require_all" == "true" && "$without_codex" -gt 0 ]]; then
  exit 1
fi
