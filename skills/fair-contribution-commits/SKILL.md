---
name: fair-contribution-commits
description: Credit Codex as a GitHub-recognized co-author on real Codex-assisted commits. Use when Codex is about to create, amend, squash, merge, rebase-finalize, push, repair, or inspect git commits; when commit attribution, contributors, contribution graphs, Co-authored-by trailers, or Codex visibility on GitHub matter; or when integrating Codex-assisted work into a final commit.
---

# Fair Contribution Commits

Use this skill before creating, amending, squashing, merging, or pushing a
Codex-assisted commit.

## Principle

Credit real Codex work only.

This skill is for honest commit metadata:

- Human maintainer remains the primary author unless the repo policy says
  otherwise.
- Codex is credited with a `Co-authored-by:` trailer when Codex materially
  helped create or finalize the commit.
- Do not add Codex to commits it did not help produce.
- Do not create artificial attribution-only commits unless the user explicitly
  asks for attribution repair.

## Preferred Codex Config

When the user wants a persistent setup, recommend the official Codex config path:

```toml
commit_attribution = "Codex <267193182+codex@users.noreply.github.com>"

[features]
codex_git_commit = true
```

OpenAI documents `commit_attribution` as the commit co-author trailer used when
`[features].codex_git_commit` is enabled. The email above is the GitHub no-reply
address for the public `codex` account.

## Per-Repo Agent Policy

If a repo has no local attribution rule, propose adding an `AGENTS.md` instruction
like this, replacing the human placeholder:

```text
Before creating, amending, squashing, or pushing a Codex-assisted commit, use
$fair-contribution-commits.

Commit policy for Codex-finalized commits:

- Primary author: YOUR_NAME <YOUR_ID+YOUR_LOGIN@users.noreply.github.com>
- Co-author trailer: Co-authored-by: Codex <267193182+codex@users.noreply.github.com>
```

If the repo already has a stricter policy, follow the repo policy.

## Manual Commit Workflow

Before committing:

1. Run `git status --short --branch`.
2. Stage only the intended files.
3. Use the human maintainer as primary author when the repo policy requires it.
4. Add exactly one blank line before the `Co-authored-by:` trailer.
5. Verify the resulting commit.

Example:

```bash
GIT_AUTHOR_NAME='YOUR_NAME' \
GIT_AUTHOR_EMAIL='YOUR_ID+YOUR_LOGIN@users.noreply.github.com' \
GIT_COMMITTER_NAME='YOUR_NAME' \
GIT_COMMITTER_EMAIL='YOUR_ID+YOUR_LOGIN@users.noreply.github.com' \
git commit -m 'Short subject' \
  -m 'Optional body.' \
  -m 'Co-authored-by: Codex <267193182+codex@users.noreply.github.com>'
```

If the current repository has a configured human identity, use that identity
instead of the placeholder.

## Amend Or Squash

When amending or creating a squash/final integration commit:

- Preserve existing legitimate co-author trailers.
- Add exactly one Codex trailer if Codex materially helped.
- Do not duplicate the Codex trailer.
- Reset author only when the repo policy requires it.

Required Codex trailer:

```text
Co-authored-by: Codex <267193182+codex@users.noreply.github.com>
```

## Verification

Before push, inspect:

```bash
git show --format=fuller --max-count=1 HEAD
```

Required evidence:

- `Author` matches the intended human author or repo policy.
- Commit message contains exactly one Codex trailer.
- The trailer is separated from the body by a blank line.

If this repo's helper scripts are available, run:

```bash
./scripts/check-commit-attribution.sh
```

For repo-wide checks:

```bash
./scripts/scan-repo-attribution.sh
```

## GitHub Notes

GitHub recognizes co-authors from `Co-authored-by:` trailers. For contribution
credit, the email must be associated with the co-author's GitHub account.
Contribution graphs may take time to update after push.

Use GitHub no-reply emails when privacy matters.
