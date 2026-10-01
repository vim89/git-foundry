# repo-sync-bot

Runs on a schedule and syncs every fork

Daily, at 08:00 CET (07:00 UTC; see note on DST in the workflow), fast-forwards
the default branch of each allowlisted fork to match its upstream.

## Repos synced

Edit the `repos` array in `.github/workflows/sync-forks.yml` to add or remove forks.

## Setup

This workflow needs a Personal Access Token with `repo` scope, stored as the
`SYNC_PAT` secret (Settings -> Secrets and variables -> Actions). The default
`GITHUB_TOKEN` only has access to this repo, not your other forks, so it can't
be used here.
