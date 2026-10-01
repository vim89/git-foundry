# git-foundry

Two small, unrelated git workflow problems, each already solved by mature
tools elsewhere -- this repo is just my concrete configuration of those
tools, kept in one place so it's a `brew install` or a scheduled workflow
away instead of re-derived by hand on every machine or every new fork.

1. **Fork sync** -- a scheduled GitHub Actions workflow that keeps my forks
   from drifting out of date with upstream.
2. **Branch-protection git hook** -- a [lefthook](https://github.com/evilmartians/lefthook)
   config, installable via Homebrew, that blocks accidental direct pushes to
   `main`/`master`.

They don't depend on each other. Use either one on its own.

---

## 1. Fork sync

**Problem it solves:** forks silently fall behind their upstream, and
nobody notices until a PR conflicts badly or an old commit resurfaces.

**What it does:** daily, at 08:00 CET (07:00 UTC -- see the DST note in the
workflow), force-pushes the default branch of every allowlisted fork to
match its upstream exactly.

**Repos synced:** edit the `repos` array in
[`.github/workflows/sync-forks.yml`](.github/workflows/sync-forks.yml) to
add or remove forks.

**Important:** because sync force-pushes, don't commit directly to the
default branch of an allowlisted fork -- use a feature branch, or those
commits get overwritten on the next run.

**Setup:** the workflow needs a **classic** Personal Access Token with
`repo` scope, stored as the `SYNC_PAT` secret (Settings -> Secrets and
variables -> Actions). Fine-grained tokens won't work: they need per-repo
Contents:write permission, and some orgs block long-lived fine-grained
tokens outright.

**Failure reporting:** every run writes a markdown table to the job summary
listing each repo's sync status, and for failures, the matched reason and a
suggested fix. See the "Summary" tab on a given workflow run.

Built on top of [github-forks-sync-action](https://github.com/TobKed/github-forks-sync-action)
patterns, not a replacement for it.

---

## 2. Branch-protection git hook

**Problem it solves:** an accidental `git push` straight to `main` with no
PR, no review, no second look.

**What it does:** installs [lefthook](https://github.com/evilmartians/lefthook)
and a `pre-push` hook that refuses to push when the current branch is
`main` or `master`.

### Getting started

```
brew tap vim89/tools https://github.com/vim89/homebrew-tools
brew install git-foundry
cd /path/to/target/repo
git-foundry install
```

This pulls in lefthook as a dependency, copies this repo's `lefthook.yml`
into the target repo, and runs `lefthook install` for you.

**Need to push to main anyway for one push?**

```
ALLOW_PUSH_TO_MAIN=1 git push
```

**Known quirk:** lefthook skips every `pre-push` command when the push has
no changed files (e.g. an empty-commit push via `git commit --allow-empty`)
-- that's lefthook's own gating, not a bug in this config. It fires
correctly for any push that actually moves a file.

Not a replacement for lefthook/pre-commit/simple-git-hooks -- just my
specific hook config for this one guard.
