# Changelog

Autoresearch log for `blog-knowledge-extraction`.

## Experiment 0 — baseline

**Score:** 48/49 (98.0%)
**Change:** Original skill, no changes.
**Reasoning:** Establish baseline against the 7 existing blog materials.
**Result:** The skill reliably produced Stage One only, merged mechanisms into transferable clusters, and avoided narrative titles. One output used a custom advice label (`推荐并入主文，不单独拆篇`) instead of the fixed Stage One label set.
**Failing outputs:** `一行 YAML 的旅行：从 db postgresql 到 DATABASE_URL.md` produced a high-scoring dependent cluster with a custom advice label.

## Experiment 1 — keep

**Score:** 49/49 (100.0%)
**Change:** Added one paragraph clarifying that the `建议` column must use only `推荐成文`, `作为章节`, or `不推荐`; dependency and threshold exceptions belong in rationale fields.
**Reasoning:** The baseline failure came from a high-scoring dependent knowledge cluster where the agent encoded the exception directly inside the advice label.
**Result:** The optimized skill preserved all Stage One behavior and fixed label consistency across all 7 blog materials.
**Failing outputs:** None in this run.
