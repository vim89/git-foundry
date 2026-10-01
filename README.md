# git-foundry

Personal git workflow configs: a scheduled fork-sync job for my allowlisted
forks, and a [lefthook](https://github.com/evilmartians/lefthook) config
with a protected-branch guard. Both problems have mature existing tools
([github-forks-sync-action](https://github.com/TobKed/github-forks-sync-action)
for fork syncing, lefthook/pre-commit/simple-git-hooks for hook management)
-- this repo is my concrete configuration of them, not a replacement for
either, kept here so it's one clone away instead of re-derived per machine.

## Fork sync

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

## Git hooks

`lefthook.yml` defines a `pre-push` guard that refuses a direct push from
`main`/`master`. Getting started:

```
brew tap vim89/tools https://github.com/vim89/homebrew-tools
brew install git-foundry
cd /path/to/target/repo
git-foundry install
```

This pulls in lefthook as a dependency and runs `lefthook install` for you.

Push a feature branch instead, or override for one push with:

```
ALLOW_PUSH_TO_MAIN=1 git push
```

Note: lefthook skips every `pre-push` command when the push has no changed
files (e.g. an empty-commit push via `git commit --allow-empty`) -- this is
lefthook's own gating, not a bug in this config. It fires correctly for any
push that actually moves a file.
