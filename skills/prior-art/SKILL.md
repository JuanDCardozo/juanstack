---
name: prior-art
description: >-
  Researches how the best teams actually doing this thing already do it, names
  them, and reports where the user's approach converges, diverges, or covers
  ground nobody has covered. Use when the user says "prior art", "/prior-art",
  "who else does this", "how do the top companies do this", "what's the standard
  approach", "am I reinventing something", or is designing an approach and hasn't
  checked what already exists. Pulls the subject from earlier conversation
  context when the user says "for what we've been discussing" rather than
  restating it. Do NOT use for competitive/market analysis of a business (that's
  a different job), for settled factual lookups, or when the user has already
  surveyed the landscape and is asking for a decision.
pipeline:
  input: structured-md
  output: prior-art-md
---

# Prior art

Find who is already doing this well, say what they actually do, and report
where the user's approach sits against it.

Requires live search. If search is unavailable, say so and stop. Answering this
from memory produces a list of plausible-sounding practices that may be two
years stale, which is worse than no answer because it reads authoritative.

## Scope the subject first

State in one line what approach is being compared, then who the relevant
"top companies" are and why those. "Top" is domain-specific and needs an
argument: the best teams at agent evaluation are not the biggest companies, and
the biggest companies are often the worst at the thing precisely because they
have scale to burn.

Pick five to eight organizations, mixed:
- Two or three obvious leaders in the domain.
- At least one team that is small but unusually good at this specific thing.
- At least one adjacent-industry team solving the same shape of problem.

If the user has named the subject only obliquely ("what we've been discussing"),
pull it from the conversation, restate it in one line, and proceed. Do not ask
them to repeat themselves.

## Sourcing rules

- **Every practice ties to a named organization and a source.** No "industry
  best practice", no "it's generally recommended". If it can't be attributed,
  it doesn't go in.
- **Date every finding.** Practices go stale fast. A 2023 post about how a team
  handles something is a historical claim, not a current one. Label it.
- **Rank sources**: engineering blogs and published postmortems from the team
  itself > conference talks > docs > press coverage > vendor marketing. Vendor
  pages describing their own product's virtues are not evidence of practice.
- **Say when you couldn't find it.** "No public record of how they do this" is
  a real finding and often the most interesting one.

## Classify every finding

Each practice goes in exactly one bucket. The buckets are the whole value of
this skill, so do not collapse them into a flat list.

**Convergent** — nearly everyone does it this way. Strong prior that it's
right, and a strong prior that not doing it needs a reason. Note how many of
the surveyed teams, explicitly.

**Contested** — the best teams genuinely disagree. This is a real design choice,
not a solved problem. Say who is on each side and what makes them differ,
because the differing factor usually tells the user which side they're on.

**Absent** — nobody surveyed does it. Two readings, and you must pick one and
defend it: either the user has found an edge, or there's a reason everyone
skipped it and the reason isn't written down anywhere. Default to the second
unless there's evidence for the first.

## Two failure modes to guard against

- **Scale transfer.** What a company does at their scale is often a solution to
  a problem the user doesn't have. Before recommending a practice, say what
  scale or constraint makes it necessary, and whether the user is there. Most
  cargo-culting happens here.
- **Survivorship.** The winners' practices are not necessarily why they won.
  If a practice is only visible at successful companies, that's weak evidence.
  Flag any finding that rests on it.

## Output

```markdown
## Subject
[The approach being compared, one line.]

## Who was surveyed
[Organizations, with one line each on why they're relevant. Note any you
expected to include but couldn't find public information on.]

## Convergent
[Practice — who does it (n of m surveyed) — source and date.]

## Contested
[The choice, who's on each side, and what makes them differ.]

## Absent
[What nobody does, and the call: edge, or reason nobody wrote down.]

## Against the user's approach
[Three sections, each concrete: what to adopt, what to skip and why, and where
the approach diverges. For each divergence, a verdict: deliberate edge, or
mistake. Name which.]
```

End on the divergence verdict, not on the survey. The survey is the evidence;
the verdict is the deliverable.
