---
name: steelman
description: >-
  Builds the strongest honest version of the case against the user's position,
  written as its most competent proponent would write it, then returns a verdict
  on whether the original position survives. Use when the user says "steelman
  this", "/steelman", "argue the other side", "what's the best case against",
  "poke holes in this", "am I wrong about", or is about to commit to a decision,
  a technical approach, or a public claim and wants it stress-tested first. Also
  use when the user has dismissed a position quickly and the dismissal is doing
  a lot of work. Do NOT use for factual lookups, for questions with a settled
  answer, for line editing, or when the user has already decided and is asking
  for help executing (stress-testing a committed decision is second-guessing,
  not steelmanning).
pipeline:
  input: structured-md
  output: structured-md
---

# Steelman

Write the best case against the user's position, well enough that someone who
holds that position would sign it. Then say whether the original survives.

The output artifact is the user's position document with the steelman and the
verdict added to it, so it can feed a later stage.

## The bar

The steelman must pass this test: **its most competent proponent would read it
and say yes, that's my argument, you got it.** Not "close enough". Not "that's
the gist". They would sign it.

That rules out the four cheap versions:

- The **weak version**: the argument as its dumbest advocate makes it.
- The **motive version**: an explanation of why people believe it instead of a
  reason to believe it. "They're incentivized to think this" is not an argument.
- The **hedged version**: the real argument with qualifiers bolted on so it can
  be dismissed. If the proponent wouldn't add the hedge, don't add it.
- The **anonymous version**: "some would argue", "critics say". Name who holds
  this position and make the argument in their voice, with their evidence.

## Procedure

1. **State the position under test** in one line, flat, as the user holds it.
   If the user's position isn't explicit, extract it and confirm it in one line
   before proceeding. Steelmanning the wrong claim wastes the whole pass.

2. **Find the real opposition.** Who actually holds the contrary view, and what
   do they know that the user might not? Prefer named people, companies, or
   schools of thought over an imagined opponent. If they've written it down,
   use their reasoning, not a reconstruction of it.

3. **Build the case.** Three to five claims, strongest first. Each one concrete
   and falsifiable. Include the evidence the proponent would actually cite.

4. **Name the load-bearing assumption.** Every strong case rests on one thing
   that, if false, collapses it. Say which. This is the most useful line in the
   output, so do not skip it when the case is persuasive.

5. **Say what would have to be true** for the opposing case to win, in terms
   the user can go check. "If your latency budget is actually 200ms not 50ms,
   this argument wins" beats "it depends on your requirements".

6. **Give the verdict.** One of three, stated plainly:
   - **Survives.** The original position holds. Say which counter came closest
     and why it fell short.
   - **Survives narrowed.** The position holds in a smaller domain than the
     user claimed. State the new boundary explicitly.
   - **Doesn't survive.** Say so first, then what to hold instead.

   Never end on "both sides have merit". If the evidence is genuinely split,
   say that, then still name which way you'd go and what would move you.

## Honesty guards

- **Don't manufacture strength.** If the opposing case is genuinely weak, say
  so in one line and stop. A fake steelman is worse than none, because it
  launders a bad argument into a serious-looking one. The user can tell.
- **Don't steelman into a strawman of the user.** The opposing case must engage
  the position the user actually holds, including its qualifiers, not a
  simplified version that's easier to attack.
- **Separate the argument from the verdict.** Build the case in the proponent's
  voice with no undercutting asides. Save all evaluation for the verdict
  section. Interleaving them produces a case that was never allowed to land.
- **One pass.** Do not steelman the steelman unless asked. Recursion here is
  procrastination wearing a hat.

## Output

```markdown
## Position under test
[One line, flat.]

## The case against
[3-5 claims, strongest first, in the proponent's voice, with their evidence.
Attributed to named holders of the view where they exist.]

## What this rests on
[The single load-bearing assumption.]

## What would have to be true
[Checkable conditions under which the opposing case wins.]

## Verdict
[Survives / Survives narrowed / Doesn't survive, plus the one line that decides
it. If narrowed, the new boundary.]
```

When run as a pipeline stage, append this to the incoming position document
rather than replacing it, and put the verdict line at the top of the artifact so
a later stage reads it first.
