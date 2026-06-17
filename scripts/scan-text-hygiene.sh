#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fail=0

cd "$repo_root"

if command -v rg >/dev/null 2>&1; then
  if rg -n --hidden --glob '!.git/**' --pcre2 '\p{Cyrillic}' .; then
    fail=1
  fi

  secret_pattern='g[h]o_|g[h]p_|github_pat_|s[k]-[A-Za-z0-9]|xox[baprs]-|TELEGRAM_[A-Z_]*TOKEN|BOT_[A-Z_]*TOKEN|BEGIN (RSA|OPENSSH|EC|DSA) PRIVATE KEY'
  if rg -n --hidden --glob '!.git/**' --pcre2 "$secret_pattern" .; then
    fail=1
  fi
else
  while IFS= read -r -d '' file; do
    if perl -CS -ne 'if (/\p{Cyrillic}/) { print "$ARGV:$.:$_"; $found=1 } END { exit($found ? 0 : 1) }' "$file"; then
      fail=1
    fi
  done < <(find . -path ./.git -prune -o -type f -print0)
fi

if [[ "$fail" -ne 0 ]]; then
  echo "Text hygiene scan failed." >&2
  exit 1
fi

echo "OK: text hygiene scan passed"
