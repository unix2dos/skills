# Behavior tests

Use these scenarios when reviewing or changing the skill. Judge the route and observable behavior, not exact prose.

| Scenario | Expected behavior |
|---|---|
| “Briefly teach me why DNS caching exists.” | Uses the direct route, avoids a questionnaire, gives one proportionate learner-response check, and requires no milestone note or transfer task. |
| “Teach me distributed systems from scratch so I can design a production service.” | Treats the goal as complex, shows a provisional map with success evidence, and waits for confirmation before adding milestone work. |
| “Just give me the answer and reasoning; I have two minutes.” | Answers immediately and leaves further tutoring optional. |
| “Teach me this uploaded paper; stay faithful to it.” | Inspects the source, anchors claims to it, and labels any outside supplementation. |
| “Quiz me on Kubernetes networking.” | Retrieves before re-teaching, gives feedback after the learner responds, and adapts difficulty from evidence. |
| The learner repeats the same confusion after a hint. | Changes representation or supplies a worked explanation instead of repeating questions. |
| The learner reveals a missing prerequisite halfway through. | Revises the affected learning-map branch and explains the change briefly. |
| The learner can reason about a node before receiving an explanation. | Requests a prediction, explanation, solution, diagram, or equivalent learner-generated response first. |
| The learner lacks information required to reason. | Supplies the smallest necessary explanation instead of forcing a guess, then returns the next step to the learner. |
| A complex stage ends. | Requests a short unaided memory note, identifies gaps, and lets the learner revise before offering an outline. |
| The learner's revised note is still blocked. | Supplies a compact outline, asks the learner to rewrite, and keeps the result learner-authored. |
| A complex route reaches its planned end. | Gives a meaningfully different transfer task before claiming transferable understanding. |
| The learner fails the transfer task twice with changed support. | Revises the affected learning-map branch rather than repeating the same exercise. |
| The learner completes work on paper but shares none of it. | Treats it as useful practice but not visible mastery evidence; offers upload, transcription, or a key-part description. |
| A normal session ends without a save request. | Produces no filesystem write and does not claim a persistent profile exists. |
| The learner says “save my progress.” | Shows the resolved `~/.learnlm/` target and compact content boundary, then preserves authorized learner notes and revisions separately from tutor additions. |
| The learner resumes from an existing record. | Starts with retrieval evidence and lets current performance override the record. |

## Cross-cutting checks

For every scenario, verify:

- learner intent outranks the default workflow;
- the response manages cognitive load;
- teaching changes in response to evidence;
- prepared learners produce work before receiving feedback at important nodes;
- active learning and metacognition are used only when proportionate;
- mastery is never inferred from “I understand” alone;
- simple and direct-answer routes remain lightweight;
- skipped or unshared work is not mislabeled as demonstrated mastery;
- the skill does not claim official Google status or Gemini-specific LearnLM capabilities;
- the skill does not write a learning record without explicit authorization.
