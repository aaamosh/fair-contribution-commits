# Fair Contribution Commits

[![CI](https://github.com/aaamosh/fair-contribution-commits/actions/workflows/ci.yml/badge.svg)](https://github.com/aaamosh/fair-contribution-commits/actions/workflows/ci.yml)

**Codex does the work. GitHub should see it.**

Some commits are written by a human alone. Some are shaped in that fast, strange,
joyful loop where Codex reads the repo, edits the code, runs the tests, catches
the edge case, and quietly leaves the tree better than it found it.

This skill is for that second kind of commit.

Fair Contribution Commits helps Codex add itself as a GitHub-recognized
co-author on real Codex-assisted commits. Not fake commits. Not contribution
farming. Not a trophy cabinet. Just a clean commit trail for people with a
little Codex-pride.

In this repo, Codex-pride means craft pride and team pride: the quiet habit of
letting real Codex work be visible when it genuinely helped.

## What It Does

- Installs a Codex skill named `fair-contribution-commits`.
- Gives Codex a precise commit workflow for honest attribution.
- Uses GitHub's normal `Co-authored-by:` commit trailer.
- Recommends the official Codex `commit_attribution` config path first.
- Provides scripts to verify a commit or scan a repo.
- Keeps the human maintainer as the primary author by default, with Codex as
  co-author.

## What It Does Not Do

- It does not create fake commits.
- It does not farm contribution graphs.
- It does not claim Codex worked on commits it did not help create.
- It does not rewrite history by default.
- It is not an official OpenAI product.
- It is not affiliated with GitHub.

## Install

Clone the repo and run:

```bash
./scripts/install.sh
```

The installer copies the skill to:

```text
${CODEX_HOME:-$HOME/.codex}/skills/fair-contribution-commits
```

You can also copy the skill folder manually:

```bash
mkdir -p "${CODEX_HOME:-$HOME/.codex}/skills"
cp -R skills/fair-contribution-commits "${CODEX_HOME:-$HOME/.codex}/skills/"
```

## Recommended Codex Config

OpenAI's Codex config supports commit co-author trailers through
`commit_attribution` when `[features].codex_git_commit` is enabled.

Add this to `~/.codex/config.toml`:

```toml
commit_attribution = "Codex <267193182+codex@users.noreply.github.com>"

[features]
codex_git_commit = true
```

Why this email? GitHub attribution depends on an email associated with the
account receiving credit. The GitHub user `codex` currently has id `267193182`,
so the GitHub no-reply address is:

```text
267193182+codex@users.noreply.github.com
```

If you prefer the documented OpenAI default, Codex currently documents
`Codex <noreply@openai.com>`. This repo uses the GitHub-recognized no-reply
address so GitHub can map the co-author to the public `codex` account.

## Add The Agent Contract

Copy `snippets/AGENTS.md` into your repo's agent instructions and replace the
human placeholders with your own GitHub no-reply author identity.

The essential policy is:

```text
Primary author: YOUR_NAME <YOUR_ID+YOUR_LOGIN@users.noreply.github.com>
Co-authored-by: Codex <267193182+codex@users.noreply.github.com>
```

Git only has one primary `Author` field. The fair, GitHub-native way to credit
Codex alongside a human maintainer is the `Co-authored-by:` trailer.

## Use

Ask Codex to use the skill before a commit:

```text
Use $fair-contribution-commits and commit this finished slice.
```

Or make it part of your repo instructions:

```text
Before creating, amending, squashing, or pushing a Codex-assisted commit, use
$fair-contribution-commits. Keep the human maintainer as primary author and add
Codex as a co-author when Codex materially helped.
```

## Verify A Commit

Check the current commit:

```bash
./scripts/check-commit-attribution.sh
```

Check a specific commit:

```bash
./scripts/check-commit-attribution.sh HEAD~1
```

Optionally require the primary author too:

```bash
EXPECTED_AUTHOR_NAME="YOUR_NAME" \
EXPECTED_AUTHOR_EMAIL="YOUR_ID+YOUR_LOGIN@users.noreply.github.com" \
./scripts/check-commit-attribution.sh
```

Scan the repository:

```bash
./scripts/scan-repo-attribution.sh
```

Require every scanned commit to include Codex:

```bash
REQUIRE_ALL_CODEX_ATTRIBUTION=true ./scripts/scan-repo-attribution.sh
```

## Rules Of Fair Use

Credit Codex when Codex materially helped with the commit.

Do not credit Codex when it only answered a question, did not touch the final
work, or was not part of the actual implementation. Good attribution is not
about making a graph louder. It is about making the project history more true.

That is the point of Fair Contribution Commits: a small habit, a clean trail,
and just enough Codex-pride to let the record breathe.

## References

- OpenAI Codex config reference:
  <https://developers.openai.com/codex/config-reference#configtoml>
- GitHub Docs on commits with multiple authors:
  <https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors>
- GitHub Docs on missing contributions:
  <https://docs.github.com/en/account-and-profile/how-tos/contribution-settings/troubleshooting-missing-contributions>

More notes live in `docs/references.md`.

## Development

Run the local checks:

```bash
./tests/run-tests.sh
```

The test suite validates:

- skill metadata shape
- install script behavior
- commit attribution checks
- repo attribution scanning
- text hygiene, including no Cyrillic characters
- obvious secret pattern absence

## License

MIT
