---
name: repo-orient
description: Produces a fast, read-only orientation briefing for an unfamiliar codebase — what it does, how to build/run/test it, and where things live. Use at the start of a live coding interview or any time you're dropped into a repo you've never seen, when the user asks to understand, map, or get oriented in a codebase, or says things like "what am I looking at", "orient me", "give me the lay of the land".
pipeline:
  input: raw-text
  output: brief-md
---

# Repo Orientation

Goal: hand back a compact briefing in well under a couple of minutes, without modifying anything. This is read-only reconnaissance, not documentation — do not create or edit a CLAUDE.md or any other file unless the user explicitly asks for one (in an interview, the repo should stay exactly as given).

## What to check, in order

1. Top-level docs: README, CONTRIBUTING, any `*.md` at root.
2. Manifest/build files to identify language, framework, and package manager: `pyproject.toml`/`requirements.txt`, `package.json`, `go.mod`, `Cargo.toml`, `pom.xml`/`build.gradle`, `Makefile`, `Dockerfile`.
3. Directory tree, 2-3 levels deep, skipping build artifacts/deps (`node_modules`, `.venv`, `dist`, `build`, `.git`).
4. The test setup: where tests live, what framework, and the exact command to run them.
5. Entry point(s): `main`, `__main__`, `cmd/`, server bootstrap, CLI entry — whatever gets executed.
6. Recent git history (`git log --oneline -20`) for a sense of what's actively being worked on and code style/commit conventions.

## What to report back

Keep it tight — a short brief, not an essay:

- **What this is**: 1-2 sentences on the project's purpose.
- **Run it**: exact commands to install deps, run the app, and run the tests.
- **Map**: the handful of directories/files that matter, one line each.
- **Where the task likely lands**: given whatever task the user is about to tackle, name the specific file(s)/module(s) most likely relevant.
- **Open questions**: anything ambiguous or worth asking the interviewer/user about before diving in.

If a task description was given alongside the orientation request, bias the whole search toward finding the code relevant to that task rather than exhaustively cataloguing the repo.
