---
name: llm-orchestration-patterns
description: Design guidance for composing multiple LLM calls into a working pipeline — which topology fits a given task (prompt chaining, routing, parallelization, orchestrator-workers, evaluator-optimizer) and how to keep each step visible and testable as the task grows in complexity. Use when building an application where multiple LLM inferences work together, when asked to add a stage/step to an existing pipeline, or when the task is explicitly about multi-agent or multi-call design rather than a single prompt.
---

# LLM Orchestration Patterns

The five workhorse topologies (from Anthropic's "Building Effective Agents"), pick the simplest one that satisfies the current requirement rather than defaulting to the most complex:

1. **Prompt chaining** — step B's prompt is built from step A's output. Use for tasks that decompose into a fixed sequence (draft → critique → revise).
2. **Routing** — a classification step picks which of several downstream prompts/paths handles the input. Use when inputs fall into distinct categories that deserve different handling.
3. **Parallelization** — fan the same or different prompts out concurrently, then merge (voting, aggregation, sectioning). Use when independent sub-tasks can run at once, or when running the same prompt multiple times and combining results improves reliability.
4. **Orchestrator-workers** — a central call plans/decomposes the task, dispatches sub-tasks to worker calls, and synthesizes their outputs. Use when the set of subtasks can't be known upfront and needs to be determined per-input.
5. **Evaluator-optimizer** — one call generates, another evaluates against explicit criteria and hands back feedback, loop until it passes or a retry budget is hit. Use when there's a clear quality bar and iteration measurably helps.

## Working effectively under time pressure

- **Start with the simplest topology that could work**, get it running end-to-end, then escalate complexity only when the task actually demands it — the task is described as starting simple and getting more complex, so build incrementally rather than architecting the final version up front.
- **Make every step's input/output visible** (print or log it) as you build — this is both faster to debug and directly demonstrates your process to whoever is evaluating it.
- **Force structured output** (tool use / JSON mode) the moment a downstream step needs to parse a previous step's output programmatically, rather than parsing free text with regex.
- **Keep steps as small composable functions** (see the `step()` pattern in the project scaffold, if present) so a new stage is "add one function + wire it in," not a rewrite.
- **Test the deterministic glue, mock the LLM call.** Routing logic, output parsing, and merge logic are worth a quick real test (see `tdd`); the LLM call itself is mocked so tests stay fast and deterministic (see the project's `tests/test_pipeline.py` for the pattern).
- **State your design choice out loud before building it** — "I'll use routing here because the inputs split cleanly into two cases" — since the ideas and the prompting are what's being evaluated, not just the resulting code.
