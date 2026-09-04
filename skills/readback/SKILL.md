---
name: readback
description: Surfaces ambiguities, unstated edge cases, and assumptions in a task or spec as a short checklist before implementation starts. Use at the start of an interview-style coding task, when requirements are informal, verbal, or pasted in loosely, or when the user says "what would you ask about this", "check for edge cases", "clarify this spec".
---

# Readback

Before writing any code, do a 30-second gut check on the spec — this is a quick pass, not an essay.

Read the task description and work out, for whatever is relevant to it:

- **Inputs/outputs**: types, ranges, sizes, who calls this and how.
- **Edge cases**: empty, null/None, zero, negative, duplicate, very large, malformed, concurrent access.
- **Scale/performance constraints**: is this expected to be O(n) vs O(n^2), any stated limits.
- **Error-handling expectations**: should invalid input raise, return an error value, or be assumed not to happen.
- **Anything genuinely underspecified** given the wording used.

Then produce two short parallel lists (aim for well under 10 bullets total, not a wall of text):

1. **Questions worth asking** the interviewer/user if they're available.
2. **Reasonable default assumptions** to proceed under if they're not — state these out loud before coding so the choice is visible, then move on.

Don't stall on this — the point is to catch the two or three things that would otherwise cause rework later, then start implementing (pair with `tdd` to turn the edge cases identified here directly into test cases).
