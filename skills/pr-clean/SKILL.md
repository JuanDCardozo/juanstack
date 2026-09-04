---
name: pr-clean
description: >-
  Tends an open pull request end to end: waits for GitHub CI to finish, reads
  the failing checks and the reviewer and bot comments, triages each item into
  auto-fix or needs-human under a rules file, pushes the fixes, and waits for the
  next CI round. Escalates anything ambiguous instead of guessing. Use when the
  user says "pr-clean", "/pr-clean", "clean up this PR", "what's blocking my PR",
  "deal with the review comments", "is CI green yet", "get this mergeable", or
  names a PR number, branch, or GitHub URL and wants it moved toward merge. Do
  NOT use for authoring a new PR, for reviewing someone else's PR where the user
  only wants comments written, or for a PR whose review comments are a design
  disagreement rather than a list of fixes.
pipeline:
  input: pr-ref
  output: pr-status-md
---

# PR clean

Take an open PR and work it toward mergeable. The loop is external: GitHub is
the source of truth, CI decides when there's work to read, and the rules file
decides what can be fixed without asking.

You are not the reviewer here. Real reviewers and real bots have left real
comments. The job is triage and execution, plus knowing when to stop and ask.

## Preconditions

Establish state first, and stop if it isn't clean:

```bash
gh pr view <ref> --json number,headRefName,state,isDraft,mergeable,reviewDecision
git status --porcelain          # must be empty
git log origin/<branch>..HEAD   # must be empty; nothing unpushed
```

Stop and say so if the working tree is dirty, local commits are unpushed, the PR
is closed or merged, or the branch is behind base in a way that needs a rebase
the rules file doesn't authorize. Acting on a stale or divergent checkout is how
this skill would destroy someone's work.

## The rules file

Read `.pr-clean.yml` from the repo root. If absent, use the defaults below and
say once that you're running unconfigured; `pr-clean.example.yml` next to this
file is a copyable starting point. Repo rules override defaults; they
never loosen the "never" list at the bottom of this file.

```yaml
wait:
  poll_seconds: 60
  timeout_minutes: 30
  required_checks: [build, test, lint]   # empty = all required checks

autofix:                 # fix without asking
  - lint
  - formatting
  - import_order
  - typo
  - generated_files      # lockfiles, snapshots, codegen
  - flaky_retry          # rerun a known-flaky check once before treating it as real

escalate:                # always ask, never fix silently
  - api_surface_change
  - behavior_change
  - schema_or_migration
  - security
  - dependency_bump
  - test_deleted_or_weakened
  - reviewer_disagreement

protected_paths:         # never edit, always escalate
  - infra/**
  - .github/workflows/**
  - "**/*.sql"

bots:
  trust: [github-actions, lint-bot]     # findings actionable as-is
  advisory: [coderabbit, sonarcloud]    # triage as suggestions, lower priority

reply_to_threads: true   # post what was done on each thread
resolve_threads: false   # let the human reviewer resolve
max_rounds: 3
```

Unlisted categories escalate. Ambiguity resolves toward asking, always.

## The loop

One round is: wait, gather, triage, fix, push. Repeat until a stop condition.

### 1. Wait for CI

```bash
gh pr checks <ref> --watch --interval 60
```

Do not read comments or act on findings while checks are in flight. Half of what
you'd triage is about failures that are about to be superseded. If the watch
exceeds `timeout_minutes`, stop and report which checks are still pending rather
than proceeding on partial results.

### 2. Gather

Three sources, collected into one work list:

```bash
gh pr checks <ref> --json name,state,link          # failing checks
gh api repos/{owner}/{repo}/pulls/{n}/comments     # inline review comments
gh pr view <ref> --json reviews,comments           # top-level reviews
```

For each failing check, pull the log and find the actual failure line, not the
summary. For each comment, keep its thread id, author, path, and line so a reply
lands in the right place. Note which authors are bots and which tier the rules
put them in.

Skip anything on the decline list (below), and anything already addressed by a
commit later than the comment.

### 3. Triage

Every item lands in exactly one bucket, and the bucket is named in the report:

**Auto-fix** — matches an `autofix` category, touches no protected path, and has
one obvious correct fix. Mechanical.

**Needs human** — matches an `escalate` category, touches a protected path,
requires intent the PR doesn't state, or is a reviewer asserting something you'd
have to disagree with to proceed. Escalation is a success, not a failure.

**Decline** — wrong, out of scope for this PR, or already answered. Declining
needs a stated reason and goes on the decline list, which persists across rounds
so no later round re-raises it.

A comment you don't understand is Needs human. Never guess at reviewer intent.

### 4. Fix and push

Fix auto-fix items only. Then:

- One commit per coherent group, message naming the check or reviewer that
  prompted it.
- Push to the PR branch. Never force push: a reviewer may have pushed a commit
  or applied a suggestion since you last looked.
- If `reply_to_threads`, post a short factual reply on each thread saying what
  changed and in which commit. Do not resolve threads unless `resolve_threads`
  is true. Resolution is the reviewer's call.

Pushing restarts CI, which begins the next round.

## Stop conditions

Stop at whichever comes first:

1. **Clean** — required checks pass, no unaddressed actionable comments. The
   merge-ready exit.
2. **Blocked** — the Needs human list is non-empty and the remaining work
   depends on those answers. Stop and ask. Do not fill the wait with cosmetic
   fixes.
3. **Round cap** — `max_rounds` reached. Report position instead of continuing.
4. **Churn** — the same check fails a third time after a fix aimed at it, or a
   round-N fix reopens something closed in round N-1. Say plainly that the PR is
   fighting back and probably needs a rethink or a split. Do not keep pushing.

## Never

- Force push, rewrite published history, or push to the base branch.
- Make a failing check pass by deleting or weakening a test, loosening an
  assertion, broadening an exception handler, or adding a skip or ignore
  directive. If that is the right fix, it is a Needs human item.
- Edit a protected path, or re-run a check to change a result you didn't fix.
- Resolve or dismiss a reviewer's thread on their behalf when `resolve_threads`
  is false.
- Change behavior to satisfy a style comment. Style findings get style fixes.
- Merge the PR. Merging is always the human's action.

## Output

Report after every round, and once at the end:

```markdown
## Round N — CI: <green | failing: check names | pending>

### Needs your call
[Item — source — the specific question, and the options if there are two.]

### Fixed and pushed
[Item — source (check name or reviewer) — commit sha.]

### Declined
[Item — source — reason.]

### Still failing
[Check — the actual failure line, not the summary.]

## Position
[One line: merge-ready, blocked on N answers, or stopped at the round cap.]
```

Needs your call goes first whenever it's non-empty. It's the only section that
requires the user to do something, and burying it under completed fixes turns a
report into a log.
