# References

Checked on 2026-06-17.

## OpenAI Codex

OpenAI Codex agent skills:

<https://developers.openai.com/codex/skills>

Relevant facts:

- A skill packages instructions, resources, and optional scripts so Codex can
  follow a workflow reliably.
- Skills use progressive disclosure: Codex starts with metadata, then loads
  `SKILL.md` only when it selects the skill.
- A skill is a directory with `SKILL.md`; scripts, references, assets, and
  `agents/openai.yaml` are optional.
- `SKILL.md` must include `name` and `description`.

OpenAI Codex config reference:

<https://developers.openai.com/codex/config-reference#configtoml>

Relevant facts:

- User-level config lives in `~/.codex/config.toml`.
- `commit_attribution` is the commit co-author trailer used when
  `[features].codex_git_commit` is enabled.
- `features.codex_git_commit` enables Codex-generated git commits and appends
  the configured `Co-authored-by:` trailer.
- `skills.config` can enable or disable a skill folder by path.

## GitHub

Creating a commit with multiple authors:

<https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors>

Relevant facts:

- GitHub supports multiple authors through `Co-authored-by:` trailers in the
  commit message.
- For contribution credit, the co-author email must be associated with the
  co-author's GitHub account.
- GitHub recommends no-reply email addresses when privacy matters.
- The trailer should follow the commit body after a blank line.

Troubleshooting missing contributions:

<https://docs.github.com/en/account-and-profile/how-tos/contribution-settings/troubleshooting-missing-contributions>

Relevant facts:

- Contributions may take up to 24 hours to appear.
- Commits need an email connected to the GitHub account, or the account's
  GitHub no-reply email.
- Contribution visibility depends on branch and repository context.

GitHub `codex` account check:

```bash
gh api users/codex --jq '{login:.login,id:.id,html_url:.html_url}'
```

Observed result on 2026-06-17:

```json
{"html_url":"https://github.com/codex","id":267193182,"login":"codex"}
```

The GitHub no-reply email derived from that account id and login is:

```text
267193182+codex@users.noreply.github.com
```

## Similar Projects

Searches performed on 2026-06-17:

```bash
gh search repos 'codex coauthor commits' --limit 10 --json fullName,description,url
gh search repos 'codex commit attribution' --limit 10 --json fullName,description,url
gh search code 'commit_attribution Codex Co-authored-by' --limit 10 --json repository,path,url
gh search code 'fair contribution commits' --limit 10 --json repository,path,url
```

These searches returned no direct polished Codex skill equivalent. That is a
search result, not a claim that no similar tool can exist.
