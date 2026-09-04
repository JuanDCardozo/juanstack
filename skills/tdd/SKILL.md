---
name: tdd
description: Red-green-refactor TDD workflow for Python with pytest. Use for ANY Python implementation work — writing a new function/class/module, adding a feature, or fixing a bug — whether or not the user says "TDD" or "tests". Especially use it in repos that already have tests, in pairing/interview settings, and whenever the user asks to "add tests" alongside code. Core rule: no implementation code before a failing test exists for it.
---

# TDD

Follow red-green-refactor. Do not write implementation code before there is a failing test for it. The value of the discipline is that every line of implementation is justified by a test that watched it fail — that's what makes the tests trustworthy later.

## The loop

1. **Restate the requirement as test cases.** Before touching implementation code, write the tests as actual test code, not prose: the happy path plus at least one edge case — empty/zero, boundary value, invalid input, duplicates, ordering, whichever applies. Name each test after the behavior it pins down (`test_withdraw_rejects_amount_over_balance`, not `test_withdraw_2`) so a failure reads as a sentence about what broke. For expected errors, use `pytest.raises(SomeError, match="...")` — asserting on the message, not just the type, catches the case where the right exception fires for the wrong reason. Bare `pytest.raises(Exception)` proves almost nothing.
2. **Match existing conventions.** Look at the existing tests (or run `repo-orient` first if you haven't) for layout (`tests/` mirror vs alongside), fixture usage, naming, and assertion style, and follow them. Don't introduce a new test framework or plugin into an existing repo.
3. **Run the new test and confirm it fails for the right reason.** Run just the new test: `pytest tests/test_x.py::test_name -x`. The right reason is an assertion failure or `NotImplementedError`; the wrong reasons are import errors, collection errors, fixture errors, typos. A test that fails for the wrong reason has never actually tested anything — fix the setup before moving on. Useful trick: stub the function/class with `raise NotImplementedError` so imports resolve and the failure is the meaningful one.
4. **Write the minimal implementation to pass.** No speculative parameters, no handling for cases nothing asked for yet. If you feel the itch to handle another case, that itch is the next test — write it down for the next loop instead of coding it now. Minimal-but-correct is allowed to look naive; the next red test is what earns the generality.
5. **Run the full suite, not just the new test.** `pytest --lf -x` is fine while iterating on a failure, but the gate for "done with this loop" is the whole suite (`pytest -q`), because the point is catching what you didn't know you broke.
6. **Refactor only on green.** Rename, extract, dedupe — with the tests unchanged. Re-run the full suite after. If a pure refactor forces you to edit tests, the tests were coupled to implementation details; prefer asserting observable behavior (return values, raised errors, side effects at the boundary) over internals.
7. **Narrate the transitions briefly.** Say when a test goes from failing to passing, so the process is visible if this is being observed live (e.g. an interview).

Repeat per requirement/edge case rather than writing every test up front for a large task — small red-green loops beat one big batch. One behavior per loop.

## Bug fixes

A bug report is a missing test. First write the test that would have caught it, watch it fail by reproducing the reported behavior, then fix. The test stays as a regression guard — never fix first and backfill the test, because a test written against already-fixed code has never been seen red and may pass vacuously.

## pytest technique

- **Parametrize same-shaped cases.** When several cases share one assertion shape, use `@pytest.mark.parametrize` with readable `ids=`; each case still shows up as its own red/green. Cases with different failure modes (raises vs returns) get separate test functions.
- **Plain `assert`.** pytest's assertion introspection makes bare asserts readable on failure; no `assertEquals`-style helpers. Use `pytest.approx` for floats.
- **Fixtures over setup code.** Use `tmp_path` for files, `monkeypatch` for env vars and attributes, `capsys` for output. Promote a fixture to `conftest.py` only once a second test file needs it.
- **Mock only at boundaries you don't own** — network, clock, external services. Mocking your own internals welds the test to the implementation, which is exactly what step 6 needs freedom from. When you do mock, the primary assertion should still be about your code's observable behavior, not the mock's call log.
- **Smells to refuse:** a test with no assertion; `time.sleep` for synchronization; a test that passes before the implementation exists (it tests nothing — see step 3); marking a failing test `skip`/`xfail` to get to green.

## Command reference

```
pytest tests/test_x.py::test_name -x   # one test, stop at first failure (step 3)
pytest --lf -x                         # re-run last failures while iterating
pytest -q                              # full suite — the green gate (step 5)
```
