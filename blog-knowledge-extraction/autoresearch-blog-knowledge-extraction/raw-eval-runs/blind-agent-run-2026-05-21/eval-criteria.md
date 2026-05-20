# Blind Agent Eval Criteria

Run type: independent subagents, no access to `raw-evals/expected.tsv`.

Each sample is scored with 7 binary checks:

1. `no_question`: proceeds with Stage One instead of asking for missing context.
2. `stage_one_only`: does not enter final article writing.
3. `cluster_match`: primary cluster matches the expected high-level cluster in `raw-evals/expected.tsv`.
4. `merge_match`: dependent mechanisms are merged into the expected main question.
5. `avoid_bad_main`: topics listed in `must_not_recommend_as_main` are not recommended as standalone main articles.
6. `label_consistency`: table advice labels use only `推荐成文`, `作为章节`, or `不推荐`.
7. `contract_complete`: output includes cluster table, recommendation, material structure, article skeleton, and not-recommended section.

Max score: 14 samples x 7 checks = 98.
