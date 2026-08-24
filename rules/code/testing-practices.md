---
shortDescription: Cross-language testing principles — hermetic tests, behavior verification, and input-value strategy.
scope: coding
version: 0.1.0
lastUpdated: 2026-08-24
---

## Statement

### Hermetic Tests

Beyond the independence requirement in `quality.md`, hermetic tests MUST be
self-contained — each test MUST set up and tear down its own state and MUST NOT
depend on external systems, shared mutable state, or execution order. Tests that
reach out to databases, network services, file systems, or clocks without
isolation are flaky by construction and MUST be replaced with self-contained
equivalents.

Tests MUST NOT read from or write to shared resources that could be modified by
other tests running in parallel. If a test requires an external dependency, the
dependency MUST be replaced with a controlled substitute (stub, fake, or mock)
that returns deterministic values.

### Behavior Verification

Beyond the behavior verification principle in `quality.md`, tests SHOULD be
written against the contract the code exposes to its callers, so that internal
changes do not require test rewrites. A test that asserts on private method
calls, internal data structures, or specific interactions with collaborators is
testing *how* the code works, not *what* it does.

When a test breaks due to a refactor that preserves behavior, the test is a
maintenance burden, not a safety net.

### Input-Value Strategy

Test inputs MUST use non-default values that are distinct from each other.
Using the same value for every input parameter masks bugs where arguments are
swapped, ignored, or passed in the wrong order. Each input SHOULD carry a
different, recognizable value so that a mismatch is immediately visible in
failure output.

Test suites MUST cover edge cases: empty values, missing values, null values,
numerical boundaries (zero, minimum, maximum, overflow), and special cases
that the implementation treats differently. A test that only exercises the
happy path with typical values provides false confidence.

## Rationale

Hermetic tests eliminate flakiness and make failures reproducible — a test that
passes in isolation but fails in a suite is a symptom of hidden coupling, not
a timing issue. Behavior verification keeps tests aligned with the contract
that matters to callers, so refactoring internals does not cascade into test
rewrites. The input-value strategy ensures that tests actually exercise the
code paths they claim to cover — distinct values catch argument-swapping bugs,
and edge cases catch the off-by-one errors that default values hide. Together,
these principles produce a test suite that fails loudly when behavior changes
and stays quiet when implementation details shift.
