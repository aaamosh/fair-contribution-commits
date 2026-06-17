#!/usr/bin/env bash
set -euo pipefail

commit="${1:-HEAD}"
codex_name="${CODEX_COAUTHOR_NAME:-Codex}"
codex_email="${CODEX_COAUTHOR_EMAIL:-267193182+codex@users.noreply.github.com}"
trailer="Co-authored-by: $codex_name <$codex_email>"

if ! git rev-parse --verify "$commit" >/dev/null 2>&1; then
  echo "Commit not found: $commit" >&2
  exit 2
fi

message="$(git log -1 --format=%B "$commit")"
author_name="$(git log -1 --format=%an "$commit")"
author_email="$(git log -1 --format=%ae "$commit")"

count="$(printf '%s\n' "$message" | grep -Fxc "$trailer" || true)"

if [[ "$count" != "1" ]]; then
  echo "Expected exactly one Codex co-author trailer:" >&2
  echo "$trailer" >&2
  echo "Found: $count" >&2
  exit 1
fi

if [[ -n "${EXPECTED_AUTHOR_NAME:-}" && "$author_name" != "$EXPECTED_AUTHOR_NAME" ]]; then
  echo "Unexpected author name: $author_name" >&2
  echo "Expected: $EXPECTED_AUTHOR_NAME" >&2
  exit 1
fi

if [[ -n "${EXPECTED_AUTHOR_EMAIL:-}" && "$author_email" != "$EXPECTED_AUTHOR_EMAIL" ]]; then
  echo "Unexpected author email: $author_email" >&2
  echo "Expected: $EXPECTED_AUTHOR_EMAIL" >&2
  exit 1
fi

echo "OK: $commit includes $trailer"
