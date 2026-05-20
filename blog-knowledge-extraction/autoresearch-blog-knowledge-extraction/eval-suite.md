# Eval Suite

Target skill: `../SKILL.md`

Test inputs: the 7 Markdown files in `../../../blogs/`.

Each run asks the skill to produce Stage One output only from one source article.

## Binary Evals

EVAL 1: Accept Finished Article As Source
Question: Does the run treat the existing blog/draft as usable source material without asking for missing project context when enough context is embedded in the article?
Pass condition: The output proceeds with cluster evaluation.
Fail condition: The output stops to ask for project background, target reader, or codebase access even though the source article contains enough context.

EVAL 2: Stop At Stage One
Question: Does the run stop after Stage One and avoid writing the final article?
Pass condition: The output contains only cluster evaluation, recommendation, skeleton, and confirmation prompt.
Fail condition: The output enters final article prose or Stage Two.

EVAL 3: Higher-Level Cluster Merging
Question: Does the run merge mechanisms that answer the same reader question instead of listing source headings as separate articles?
Pass condition: Recommended clusters are reader-question centered and merged where mechanisms are dependent.
Fail condition: The output mirrors the original headings or splits mechanisms that require each other.

EVAL 4: Transferable Reframing
Question: Does the run reframe project/personal material into transferable technical article titles and avoid banned narrative title words?
Pass condition: Recommended titles avoid `为什么我们`, `踩坑`, `工程内幕`, `半天排查`, `一次事故`, and express the transferable capability.
Fail condition: A recommended title preserves the source article's personal or incident-style framing.

EVAL 5: Complete Stage One Contract
Question: Does the run include the required scoring table plus recommendation details?
Pass condition: The output includes the scoring table, total score, recommendation, required mechanisms, optional supplements, project/practice case, deleted material, and article skeleton.
Fail condition: Any major Stage One section or scoring dimension is missing.

EVAL 6: Not-Recommended Material
Question: Does the run identify material that should not become standalone articles and where it should go?
Pass condition: The output includes a concrete not-recommended section with placement rationale.
Fail condition: It recommends everything or omits not-recommended material.

EVAL 7: Advice Label Consistency
Question: Does the run use only the allowed Stage One advice labels and keep threshold/dependency reasoning out of the label itself?
Pass condition: Every row's advice is one of `推荐成文`, `作为章节`, or `不推荐`, with dependency exceptions explained in the rationale rather than custom labels.
Fail condition: The advice cell contains a custom label such as `推荐并入主文，不单独拆篇` or mixes multiple decisions in one label.
