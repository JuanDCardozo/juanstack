---
name: build
description: End-to-end build loop for one unit of work — drafts a plan, verifies it, implements test-first via TDD, then reports back a summary. Use when the user says "build this", "implement this", or hands you a task/spec and wants it taken from raw requirement to verified, tested code in one go. Does not include the requirements-clarification pass — run `readback` separately first if the task needs it.
pipeline:
  input: spec-md
  output: report-md
---

# Build

Plan, verify the plan, build test-first, report back. Don't skip a step by jumping straight to code — the report at the end is only trustworthy if the earlier steps actually happened.

1. **Plan.** Draft a short implementation plan: the approach/topology, the files that will be touched or created, and the order operations happen in. Keep it to a few lines — a punch list, not a design doc.
2. **Verify the plan.** Sanity-check it before writing anything: does it actually cover the requirement (including any edge cases already surfaced by a `readback` pass, if one was run), does it match the existing code's conventions, and is it the simplest approach that works — not overbuilt for what was asked? If something's genuinely ambiguous and there's a human to ask, surface the plan and get a quick confirmation before proceeding; if not, state the assumption out loud and move on rather than stalling.
3. **Build test-first.** Follow `tdd`'s red-green-refactor loop for each piece of the plan: write the failing test(s) first, confirm they fail for the right reason, implement the minimal code to pass, run the full suite, refactor only on green.
4. **Report back.** Once green, summarize in a few lines: what was built, which tests cover it and what each one asserts, and anything from the plan that changed once you were actually implementing it.

`readback` is a separate, standalone skill, not chained in automatically — run it on its own first if the requirement is vague or verbal.
