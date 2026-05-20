# Blog Knowledge Extraction Artifacts

This directory contains optimization and evaluation evidence for `../SKILL.md`.

## Keep For Review

- `SKILL.md.baseline`: original skill before autoresearch.
- `blog-knowledge-extraction-optimized.md`: optimized copy used during autoresearch. Its accepted change has already been merged into `../SKILL.md`.
- `changelog.md`: mutation log.
- `results.tsv` and `results.json`: autoresearch score log.
- `eval-suite.md`: original binary eval definitions.
- `rough-material-smoke-test.md`: hand-run rough-material proxy test.

## Raw Eval Set

- `raw-evals/`: 14 synthetic rough inputs derived from the 7 blog posts.
- `raw-evals/expected.tsv`: oracle for expected high-level clusters and forbidden standalone recommendations.
- `raw-evals/README.md`: how to use the raw eval set.

## Eval Runs

- `raw-eval-runs/run-2026-05-21/`: main-thread baseline run over all 14 raw samples.
- `raw-eval-runs/blind-agent-run-2026-05-21/`: independent subagent blind run over all 14 raw samples.

## Optional / Historical

- `dashboard.html`: self-contained static dashboard from the autoresearch workflow. It embeds the final `results.json` data so it can be opened directly through `file://` without browser CORS errors.

## Runtime Install Note

The global Codex install should include only:

```text
~/.codex/skills/blog-knowledge-extraction/SKILL.md
```

Do not copy this autoresearch directory into the global skill install unless you explicitly want local evaluation artifacts there.
