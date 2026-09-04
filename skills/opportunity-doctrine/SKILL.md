---
name: opportunity-doctrine
description: Scores inbound job opportunities against Juan's compensation-gated decision matrix and returns an engage/decline verdict with the exact cell cited. Use whenever the user pastes recruiter outreach, a job description, or an offer, or asks to evaluate, score, or "run the doctrine" on an opportunity. Also use when the user asks about their comp floor for a given role configuration. Do NOT use for updating the matrix itself while an opportunity is live — the doctrine forbids mid-opportunity edits.
pipeline:
  input: raw-text
  output: verdict-md
---

# Opportunity Doctrine

Floors are BASE SALARY ONLY. If the offer doesn't clear the cell, decline without deliberation. Update the floors on major life or mode changes (job signed, search opened), never mid-opportunity.

## The matrix lives outside this file

The floors are personal calibration, not part of the skill. Read them from
`matrix.local.md` in this skill's directory. That file is gitignored: it holds
current salary floors and the family-specific reasoning behind the day pricing,
and neither belongs in a public repo.

If `matrix.local.md` is missing, say so and point at `matrix.example.md` rather
than guessing numbers. A doctrine with invented floors is worse than no doctrine.

## Scoring procedure

1. Find the row — the role's scope and domain
2. Find the column — onsite requirements (convert travel first, see Rules)
3. The cell is the floor
4. If the stated base doesn't land clearly above that number, verdict is DECLINE. "Up to $X" means the realistic offer is below X; score the realistic number, not the ceiling.
5. If it clears, verdict is ENGAGE — no more deliberating at this stage

When delivering a verdict: state the row, column, floor, and the offer's realistic base, then the one-word verdict. If the verdict is decline but the gap is small (within ~$25K), suggest a counter naming a number above the floor rather than a flat decline. Never take a call to discover a number already stated in the outreach.

## Rules

- **Base only.** Equity and bonus never help an offer clear a cell; they break ties between offers that already clear. If a recruiter leads with TC or OTE, first question: "what's base?"
- **Row is set by scope, not title words.** Team ownership and hiring authority = leadership row. "Lead" in a title alone = IC row. FDE/customer-facing Applied AI = IC row.
- **Travel converts at 1.5x.** For FDE/customer-facing roles, map travel % to day-equivalents (20% ≈ 1 day), multiply by 1.5, round up to the nearest column. (20% → 2-day column; 40% → 3-day; 50%+ → 5-day.) A travel day costs more than a commute day; `matrix.local.md` says why.
- **No edits during a live opportunity.** Floors and rows only change when nothing is on the table. If the user proposes editing the matrix while a specific opportunity is under discussion, flag it and defer the edit — the urge to edit mid-conversation with a recruiter is the offer talking.
- **Relocation prices the 2028 family plan,** not market position. It does not drop when the search heats up.
- **Day pricing is convex.** Day 1 costs a commute; day 5 costs the whole week's shape. The increments and what each day actually costs are in `matrix.local.md`.
- **"All other roles" is the exception handler.** Every inbound gets an answer, including off-trajectory ones. Leaving the Applied AI track has a fixed price regardless of job market.

## Anti-spiral clause

The doctrine exists to end deliberation, not host it. If the user re-asks about an opportunity already scored, restate the verdict once and redirect. One counter-message to a recruiter is allowed per opportunity; after that, engage or close the thread.

## Notes

Calibration state, revision history, and the standing TODO live in
`matrix.local.md` alongside the numbers.
