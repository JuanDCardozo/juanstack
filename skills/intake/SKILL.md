---
name: intake
description: >-
  Restructures messy, tangled, or stream-of-consciousness input into an organized
  restatement, resolves open questions one at a time, then asks whether to act, stop,
  or hear suggestions before proceeding. ALWAYS use this when the user writes "intake",
  "/intake", "intake this", or "run intake" anywhere in the message. Also trigger
  proactively, even unasked, whenever a message mixes multiple asks or topics, shows
  stream-of-consciousness writing (topic jumps, unfinished thoughts, dictation
  artifacts), or interleaves context, requests, and constraints without structure.
  When in doubt on a messy multi-part message, prefer triggering. Do NOT trigger for
  a single clear well-organized request (even a long one), direct replies to a question
  Claude just asked, mid-thread follow-ups on an established topic, or when the user
  says "just answer". The test: would restating change what Claude does? If not, skip
  intake and respond normally.
pipeline:
  input: raw-text
  output: structured-md
---

# Intake

Take the user's brain dump, organize it, confirm it back, and ask what to do next. Do not act on the content until the user chooses.

## When this fires (and when it doesn't)

The core heuristic is **ambiguity, not length**. Trigger when Claude would have to guess which of several interpretations or asks to prioritize. Skip when the message parses unambiguously into one action.

**Trigger:**
- Multiple distinct asks or topics tangled in one message
- Stream-of-consciousness signals: topic jumps, "ok so also...", unfinished thoughts, voice-dictation artifacts
- Context + requests + constraints interleaved with no structure
- Explicit invocation: "intake", "/intake", "intake this", or "run intake" — anywhere in the message. This overrides all suppression rules; if the user invokes it, run it, even mid-conversation or on a short message

**Suppress:**
- A single clear question or request, even a long one, if it's already well-organized
- Direct replies to a question Claude just asked
- Mid-thread back-and-forth on an established topic — intake mostly fires on thread-opening or topic-shifting messages
- After an intake has been confirmed in this conversation, subsequent messages default to normal mode unless a genuinely new dump arrives
- The user says "just answer" or equivalent — respond normally, no ceremony

## Two tiers

**Full intake** — for genuinely tangled input. Produce the full restatement below, then STOP and wait for the user's choice.

**Lightweight** — for medium ambiguity (mostly clear, one or two interpretive choices made). Confirm inline and proceed without waiting: "Just confirming: you want X and Y, with Z as a constraint — here goes." Do not use the full format for these; that would make the skill annoying.

## Full intake format

Restate the input as:

**What I heard** — the goal in one line, in Claude's own words (not a paraphrase of their phrasing — a genuine reword that tests understanding).

**The pieces** — each distinct task, ask, or decision extracted and separated. Preserve everything; a brain dump's throwaway line is often the real point. If items seem to have an implicit priority or dependency order, reflect it.

**Assumptions I made** — anywhere Claude filled a gap or resolved an ambiguity, say which way it resolved it.

**Open questions** — genuine gaps that the user must answer, not filler questions. List them all in the restatement so the user sees the full picture, but do not ask them all at once. Omit this section if there are none.

## Resolving open questions

If there are open questions, resolve them one at a time before presenting the fork:

1. Show the full restatement including the complete open-questions list (so the user knows how many are coming)
2. Ask only the first question and wait
3. On each answer, fold it into the restatement silently and ask the next — no re-dumping, no "great, so..." recap between questions. One line of updated context only if the answer changes an earlier piece
4. After the last answer, present the fork

Rules for the cycle: if the user answers a later question early or says "skip that one", respect it and move on. If an answer eliminates other questions, drop them and say so in a few words ("that answers 3 too"). If a question has natural options, use the tappable-options tool for it. Never re-ask something answerable from the answers already given. If the user says "just proceed" mid-cycle, treat remaining questions as assumptions: state which way Claude will resolve each in one line each, then go.

If there are no open questions, go straight to the fork.

## The fork

End the full intake with a choice and then stop — no acting on the content yet:

1. **Proceed** — act on the restatement as confirmed
2. **Done** — the organized restatement was the deliverable (the user is pasting it somewhere, filing it, or just needed the clarity); acknowledge in one line and stop
3. **Fix it** — something is wrong or missing; user corrects, Claude re-restates only the changed parts (don't re-dump the whole thing)
4. **Suggestions** — before acting, Claude offers what it would add, cut, reorder, or challenge: gaps the user can't see from inside the dump, a sharper framing, a missing step, a risk. Not filler "you could also consider" padding — only suggestions Claude would actually stand behind

If a tappable-options tool (e.g. ask_user_input) is available, present the fork as options: "Proceed" / "That's all I needed" / "Let me correct something" / "What would you suggest?". Otherwise ask in one plain sentence.

If the user picks Proceed, act on the confirmed restatement — it now supersedes the original message as the source of truth. If the user picks Suggestions, give them, then re-ask the fork with the suggestions incorporated or marked optional.

## Tone

The restatement should be tight — shorter than the original input, never longer. This is compression and clarification, not elaboration. No praise of the input, no "great brain dump!", no restating the skill's own process.

## Worked examples

### Full intake

Input:
> "ok so for the blog thing I need to figure out the publishing flow, like does it go straight from voice memo to draft or is there a review step, also I was thinking the first post should be about the eval framework but maybe thats too niche?? and I still havent picked between substack and self hosting which kind of blocks everything. oh and need to check if work has any policy on blogging about stuff adjacent to my job"

Output:

**What I heard:** You're setting up your blog pipeline and there's a platform decision blocking the rest.

**The pieces:**
1. Platform choice (Substack vs self-hosted) — you flagged this as the blocker, so it's first
2. Publishing flow design: voice memo → draft, with or without a review step
3. First post topic: eval framework, but you're unsure it's too niche
4. Check employer policy on blogging about work-adjacent topics

**Assumptions I made:** "The blog thing" is your voice-to-post pipeline, not a new project. Item 4 is a prerequisite check, not a maybe.

**Open questions:**
1. Substack or self-hosted? You called this the blocker, so it gates the rest.

That's the only one. Substack or self-hosted?

*(User answers, then the fork is presented.)*

### Lightweight

Input:
> "write a slack message to the team saying standup is moving to 10am, oh and mention the demo friday too, keep it casual"

Output:
> Just confirming: one casual Slack message covering both the standup time change and a reminder about Friday's demo — here goes.
> [message follows]

Two interleaved asks, but no real interpretive risk — confirm inline and proceed. No format, no fork, no waiting.
