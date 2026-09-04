# juanstack

Personal Claude Code skills, each doing one stage of thinking, writing, or shipping, plus the pipelines that chain them. Every pipeline skill declares what it takes in and hands off, and the `pipeline` skill refuses to run a chain whose types don't connect.

## Install

```bash
git clone https://github.com/JuanDCardozo/juanstack.git && cd juanstack && ./setup.sh
```

That copies `skills/*` to `~/.claude/skills/` and `pipelines/*.yaml` to `~/.claude/pipelines/`. Edit here, re-run to update.

## How the skills chain

```
 voice-to-post                          decision-brief
 -------------                          --------------
 raw-text                               raw-text
    |                                      |
 [intake] ....... untangle, confirm     [intake]
    |                                      |
 structured-md                          structured-md
    |                                      |
 (draft) ........ inline stage          [steelman] ..... best case against, verdict
    |                                      |
 draft-md                               structured-md
    |                                      |
 -- checkpoint --                       [prior-art] .... who already does this
    |                                      |
 (edit) ......... inline stage          prior-art-md
    |                                      |
 final-md                               -- checkpoint --
                                           |
                                        (decide) ....... inline stage
                                           |
                                        decision-md


 standalone stages, same type system

 draft-md ---> [structure-post] ---> shaped-md      slots between draft and edit
 raw-text ---> [opportunity-doctrine] ---> verdict-md
 pr-ref ----> [pr-clean] ---> pr-status-md         loops on CI and review comments


 coding chain, wired by reference instead of yaml

 [repo-orient] --> [readback] --> [build] --> [tdd]
                                     |
                      reads [api-prompting] and [llm-orchestration-patterns]
                      when the thing being built is an LLM app
```

Pipeline definitions are in `pipelines/`. A stage is either an installed skill or an `inline` block with its own instructions; a `checkpoint` stops and asks before continuing. Types are lowercase tags, conventions not a schema, and `pipelines/types.yaml` annotates third-party skills that don't declare their own.

## Local calibration

`opportunity-doctrine` reads its salary floors from `matrix.local.md` next to its `SKILL.md`. The repo ships `matrix.example.md` with the shape and no numbers; anything matching `*.local.md` is gitignored, so a skill can carry private calibration without the skill itself being private. `pr-clean` reads `.pr-clean.yml` from the repo it works in.

## License

MIT.
