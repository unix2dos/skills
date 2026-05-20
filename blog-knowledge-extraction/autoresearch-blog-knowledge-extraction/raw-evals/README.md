# Raw Eval Set

Synthetic rough-material evaluation set for `blog-knowledge-extraction`.

Each source blog has two derived raw inputs:

- incident/debug/design/code-reading notes
- chat-style discussion

These are intentionally noisy and incomplete. They test whether the skill can extract a transferable higher-level knowledge cluster without being pulled into project chronology or feature lists.

Use `expected.tsv` as the oracle for:

- expected primary cluster
- expected article title direction
- content that should be merged
- content that must not become the main standalone recommendation

Run the skill in Stage One only for each `*.md` sample except this README.
