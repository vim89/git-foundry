# repo-sync-bot

Runs on a schedule and syncs every fork

Daily, at 08:00 CET (07:00 UTC; see note on DST in the workflow), fast-forwards
the default branch of each allowlisted fork to match its upstream.

## Repos synced

Edit the `repos` array in `.github/workflows/sync-forks.yml` to add or remove forks.

Sync is force-pushed to each fork's default branch to match upstream exactly.
**Don't commit directly to the default branch of an allowlisted fork** -- use
a feature branch instead, or those commits will be overwritten on the next
scheduled run.

## Setup

This workflow needs a Personal Access Token with `repo` scope, stored as the
`SYNC_PAT` secret (Settings -> Secrets and variables -> Actions). Use a
**classic** PAT, not fine-grained: fine-grained tokens require per-repo
Contents:write permission and some orgs block long-lived fine-grained tokens
outright.

## Failure reporting

Every run writes a markdown table to the job summary listing each repo's
sync status, and for failures, the matched reason and a suggested fix. See
the "Summary" tab on a given workflow run.
