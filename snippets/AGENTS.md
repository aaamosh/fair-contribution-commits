# Commit Attribution Policy

Before creating, amending, squashing, or pushing a Codex-assisted commit, use
`$fair-contribution-commits`.

For commits finalized by Codex:

- Primary author: `YOUR_NAME <YOUR_ID+YOUR_LOGIN@users.noreply.github.com>`
- Co-author trailer: `Co-authored-by: Codex <267193182+codex@users.noreply.github.com>`

Git commit objects have exactly one primary `Author`. Use the primary author for
the human maintainer and the `Co-authored-by:` trailer for Codex when Codex
materially helped create or finalize the commit.

Do not add Codex to commits it did not help produce. Do not create artificial
attribution-only commits unless explicitly requested for attribution repair.
