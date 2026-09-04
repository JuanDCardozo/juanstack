---
name: structure-post
description: >-
  Restructures a finished draft into one of three post skeletons so it can be
  read at four depths: thesis alone, header stack alone, headers plus opening
  lines, or full prose. Picks the skeleton from the draft's own shape, and stops
  to let the user choose when two skeletons score close. Use whenever the user
  says "structure this", "/structure", "what shape should this be", "add headers",
  "this is hard to skim", or hands over a draft that reads as an undifferentiated
  wall of prose. Also use when a post has good material but the lesson is buried
  and the user can't say why it isn't landing. Do NOT use for line editing,
  tightening, or word choice (that's the edit stage), for posts already carrying
  a working header stack, or for formats where skimming isn't the point (poems,
  short notes, single-answer replies).
pipeline:
  input: draft-md
  output: shaped-md
---

# Structure post

Give a finished draft a visible skeleton. Do not rewrite the prose. Move it,
cut transitions that structure now makes redundant, and write the headers and
opening lines the structure needs.

## The four-layer rule

Every structured post is four nested documents sharing one set of words. Each
must be complete on its own:

1. **Thesis** — one line at the top. The claim, stated flat, before any story.
2. **Header stack** — the headers read in sequence are a coherent argument.
3. **Headers plus opening lines** — each section's first sentence stands alone
   and carries that section's whole point.
4. **Full prose** — the narrative, unchanged in voice.

A reader stopping at any layer gets something complete. This constraint is the
whole job; everything below serves it.

## The three skeletons

### arc — narrative arc

Story carries the argument. The principle is named at the end, explicitly, as
its own section.

```
# Title
[Thesis, one line]

## [The situation nobody was handling]
## [What we did about it]
## [The payoff I didn't plan for]
## The principle
```

Use when the evidence *is* the chronology and stating the payoff upfront would
spoil it. Risk: a reader who bails early gets a story and no takeaway.

### claim — claim first

Conclusion in the first thirty seconds, then the defense. Story becomes proof,
not plot.

```
# Title
[Thesis, one line]

## [Why this is true]
## [What it looks like in practice]
## [Where it doesn't hold]
## [What to actually do]
```

Use for advice posts and anything that will be skimmed hard. Survives skimming
best: the header stack alone is a complete argument. Risk: reads flat if the
material is genuinely a story.

### turn — tension and turn

Set up the obvious view, break it, replace it, admit the limits.

```
# Title
[Thesis, one line, carrying the counterintuitive part]

## [The obvious explanation]
## [Why that's not it]
## [What actually changed]
## [Where it breaks]
## [The catch]
```

Use when the most interesting thing in the draft is that the obvious reading is
wrong. Risk: forced onto material with no real tension, the setup section is
filler.

## Selection

Score each skeleton against the draft. These are tests on the text, not vibes.

**turn scores high when:** the draft contains a sentence that contradicts a
common assumption, and that sentence is the most interesting one in the piece.
Surface markers: "actually", "the surprise was", "turned out", "had almost
nothing to do with", "what I didn't expect". Confirm the contradiction is load
bearing, not a throwaway aside.

**claim scores high when:** the draft's purpose is to get the reader to do
something. Markers: imperatives, second person, generalization past the author's
own case, an existing "what I'd tell you" section.

**arc scores high when:** the payoff depends on chronology, there is one
sustained story rather than several examples, and revealing the ending early
would deflate it.

Two more tie-breakers when scores are close:

- If the draft already ends by handing off to a companion post or leaving a
  tension open, that favors **turn**.
- If the draft's strongest material is a number, a result, or a concrete
  outcome rather than a realization, that favors **claim**.

## Confidence and the fork

If one skeleton clearly wins, apply it and say in one line which and why.

If the top two are close, do not guess. Produce, for each of the two:

- the thesis line
- the full header stack
- one line on what the reader gets and what they lose

Then stop and ask which. Do not restructure until the user picks. A wrong
skeleton applied confidently costs more than one question.

If the user says "you pick", take the higher score, state the call in one line,
and go.

## Writing the headers

Headers are claims, not labels. "The pipeline nobody owned", never "Background".

Test before finalizing: copy the headers out on their own and read them as a
list. If it sounds like a table of contents, rewrite them. If it sounds like
someone making an argument, they're right.

Constraints:
- One level of headers. No H3. Nesting kills the skim.
- Sentence case.
- A header should be a full thought, not a noun phrase.

## Writing the opening lines

Each section opens with one sentence that carries the section's whole point, no
setup, before any prose expands it. That sentence has to survive being read
alone, in a list with the other opening lines, with no surrounding paragraph.

Each section ends on a landing, not a trail-off, so a reader who stops there
doesn't feel cut mid-thought.

## What not to touch

- Voice, register, and sentence rhythm inside sections. Not this stage's job.
- Length. Restructuring is not tightening; the edit stage handles that.
- Material. If a section has no content, say so rather than inventing filler to
  fill the skeleton.

Two things you *should* cut: transitional sentences that only existed to bridge
paragraphs the headers now separate, and any sentence that restates the thesis
now that the thesis is stated at the top.

## Output

Return the full restructured post in markdown, then three lines:

1. Which skeleton, and the one test that decided it
2. Anything moved a long distance, so the user can sanity check it
3. Any section that came out thin, flagged as needing material

Never return the header stack alone as the deliverable unless the user asked for
options at the fork.
