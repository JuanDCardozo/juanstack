---
name: pipeline
description: Orchestrates multi-stage workflows by chaining installed skills, defined in yaml files under ~/.claude/pipelines/. Validates that chained skills are compatible via their declared input/output types before executing. Use whenever the user says "run the X pipeline", "pipeline", "/pipeline", names a yaml in ~/.claude/pipelines/, pastes a pipeline definition inline, or describes a multi-step workflow where one skill's output feeds another (e.g. "take this transcript, intake it, draft a post, format it"). Also use when the user uploads artifacts or a status folder from a previous run and wants to resume, or asks to list, add, or edit pipelines.
---

# Pipeline

Orchestration skill. It does no work itself; it reads a yaml pipeline definition, validates that the chained skills fit together, and executes them in order, managing the artifacts between stages.

## Where things live

- **Pipeline definitions**: `~/.claude/pipelines/*.yaml`. In the juanstack repo these live at the repo root under `pipelines/`; `setup.sh` copies them to `~/.claude/pipelines/`. That directory persists across conversations; see "Adding or editing pipelines" below.
- **Type registry**: `~/.claude/pipelines/types.yaml` — external input/output annotations for skills that don't declare their own.
- **Run state**: `~/.claude/pipeline-runs/<run-name>/` — persists across sessions on this machine.
- **Deliverables**: copied to `./pipeline-output/<run-name>/` in the working directory and presented at the end.

## Pipeline definition format

```yaml
pipeline: voice-to-post
description: Raw transcript to publish-ready blog post
stages:
  - skill: intake
  - skill: draft-post          # a skill, or "inline" with instructions
  - checkpoint: "Draft ready. Continue to edit, or give feedback first?"
  - skill: inline
    name: edit
    input: draft-md
    output: final-md
    instructions: >
      Tighten by ~15%, cut anything that doesn't earn its place,
      add title and one-line description.
```

Rules:
- A stage is either a `skill:` entry or a `checkpoint:` entry.
- `skill: <name>` references an installed skill. `skill: inline` defines the stage in place and must declare `name`, `input`, `output`, and `instructions`.
- A `checkpoint:` stage stops execution, asks the user the given question, and waits. Resume only on explicit go-ahead. Feedback given at a checkpoint becomes extra input to the next stage.
- Stage order defines dataflow: each skill stage consumes the previous skill stage's output artifact.

## Type validation (do this BEFORE executing anything)

Each skill declares what it accepts and produces in its SKILL.md frontmatter:

```yaml
name: intake
pipeline:
  input: raw-text
  output: structured-md
```

Validation protocol:
1. For each `skill:` stage, read that skill's SKILL.md from `~/.claude/skills/<name>/` (or `.claude/skills/<name>/` in the current project for project-scoped skills). Look for the `pipeline:` block in frontmatter.
2. If the skill has no `pipeline:` block, look it up in `~/.claude/pipelines/types.yaml`. That registry annotates third-party skills externally.
3. If it's in neither place, warn the user that the stage is untyped, and treat its types as wildcards (matches anything) rather than blocking the run.
4. Walk the chain: stage N's output type must equal stage N+1's input type (checkpoints are transparent to typing). On mismatch, stop before executing anything, name the two stages and the two types, and propose fixes (reorder, insert a converting stage, or override with user confirmation).

Types are lowercase tags like `raw-text`, `structured-md`, `draft-md`, `final-md`, `docx`, `html`. They're conventions, not a formal system; the point is catching "you wired a docx producer into a transcript consumer" before wasting a run.

## Execution protocol

1. **Resolve the definition**: inline paste in this conversation > matching yaml in `~/.claude/pipelines/` > a yaml path the user names. If asked to "list pipelines", read `~/.claude/pipelines/` and summarize each yaml's name and description.
2. **Validate the chain** (above). Do not execute an invalid chain.
3. **Create the run directory**: `~/.claude/pipeline-runs/<run-name>/` with a short descriptive run name, and one subdirectory per stage: `NN-<stage-name>/`.
4. **Collect first inputs.** If the first stage's input is user-provided and missing, ask once, specifically.
5. **Execute stages in order.** For each skill stage:
   - Read the skill's full SKILL.md and follow it. For `inline` stages, the `instructions` field is the full spec.
   - Read input only from the previous stage's output directory (plus checkpoint feedback if any). Do not pull from earlier conversation context unless the definition says to.
   - Write output files to `NN-<stage-name>/output/`.
   - Write a status file `NN-<stage-name>/status.md` (format below).
6. **At checkpoints**: show the latest output (inline if short, presented file if long), ask the checkpoint question, stop. Do not continue in the same message.
7. **Deliver**: copy final outputs to `./pipeline-output/<run-name>/`, present them, give a one-paragraph run summary.

## Status files

After each stage, write `NN-<stage-name>/status.md`:

```markdown
# <skill-name> — <run-name>
date: <iso>
pipeline: <pipeline-name>
stage: <N> of <total>

## Done
- [x] <what this stage completed>

## Remaining in pipeline
- [ ] <stage N+1 name>
- [ ] <stage N+2 name>
```

Also maintain `~/.claude/pipeline-runs/<run-name>/status.md` as the roll-up: same checklist covering the whole pipeline, updated after every stage. These files are the portable state of the run.

## Resuming across sessions and surfaces

Run state lives in `~/.claude/pipeline-runs/`, so a run on this machine resumes by name:

- On "resume <run-name>": read its status.md files, mark completed stages done, re-validate the remaining chain, and continue from the first unchecked stage. If asked to "list runs", read that directory and show each roll-up's position.
- To move a run to another machine or surface (a claude.ai chat, a Cowork session), zip the run directory into `./pipeline-output/` and tell the user to upload it there. On receiving uploaded status files, rebuild the run directory from them and continue the same way.
- The status format is the portable state, so keep it boring and identical everywhere.

## Failure handling

- If a stage produces unusable output, stop. Name the stage, show the roll-up status, propose re-running from that stage. Never continue on bad input, never fabricate a missing artifact.

## Adding or editing pipelines

Definitions are plain files in `~/.claude/pipelines/`, not part of the skill. To change them:

1. Preferred: edit `pipelines/*.yaml` in the juanstack repo and re-run `./setup.sh`, so the repo stays the source of truth. If the repo is not to hand, write the yaml straight into `~/.claude/pipelines/` and it resolves on the next run; copy it back to the repo later.
2. Offer this proactively when the user runs the same inline definition twice: "want me to save this to ~/.claude/pipelines/?"
3. For fast-churning definitions, keep the yaml in the project and pass its path; it resolves without installing.

Same for `types.yaml`: register a new third-party skill's types by editing it in place. For the user's own skills, the better fix is adding the `pipeline:` frontmatter block to that skill directly next time it's updated.
