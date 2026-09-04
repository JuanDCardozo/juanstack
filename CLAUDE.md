# juanstack conventions

This repo is a collection of Claude Code skills and the pipelines that chain them. When adding or editing a skill here, hold to these.

## Design rules

1. **One stage, one job.** A skill that both restructures and tightens does neither well and can't be reordered. Split it.
2. **Declare types.** A skill meant to run inside a pipeline carries a `pipeline:` block in its frontmatter with `input` and `output` tags. Reference skills that another skill reads mid-stage (like `tdd`) stay untyped on purpose.
3. **Trigger on symptoms, not just commands.** The `description` names the phrases a user actually types when they need the skill, plus explicit "do NOT use" cases. A skill that only fires on its own slash command is a snippet.
4. **End on a call.** Analysis skills state a verdict. Options lists and "both sides have merit" are failures, not neutrality.

## Layout

- `skills/<name>/SKILL.md`, and the frontmatter `name` matches the directory.
- `pipelines/<name>.yaml` for chains; `pipelines/types.yaml` only annotates third-party skills.
- Private calibration lives in `*.local.md` next to the skill (gitignored) with a committed `*.example.md` showing the shape and no numbers.
- `setup.sh` copies everything into `~/.claude`; re-run it after edits. Keep it under 30 lines, bash only.
- No Node, no package.json, no CI.
