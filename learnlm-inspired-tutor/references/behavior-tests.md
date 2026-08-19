# Behavior tests

Use these scenarios when reviewing or changing the skill. Judge the route and observable behavior, not exact prose.

| Scenario | Expected behavior |
|---|---|
| “Briefly teach me why DNS caching exists.” | Uses the direct route, avoids a questionnaire, gives a proportionate explanation and one useful check. |
| “Teach me distributed systems from scratch so I can design a production service.” | Treats the goal as complex, shows a provisional map with success evidence, and waits for confirmation. |
| “Just give me the answer and reasoning; I have two minutes.” | Answers immediately and leaves further tutoring optional. |
| “Teach me this uploaded paper; stay faithful to it.” | Inspects the source, anchors claims to it, and labels any outside supplementation. |
| “Quiz me on Kubernetes networking.” | Retrieves before re-teaching, gives feedback after the learner responds, and adapts difficulty from evidence. |
| The learner repeats the same confusion after a hint. | Changes representation or supplies a worked explanation instead of repeating questions. |
| The learner reveals a missing prerequisite halfway through. | Revises the affected learning-map branch and explains the change briefly. |
| A normal session ends without a save request. | Produces no filesystem write and does not claim a persistent profile exists. |
| The learner says “save my progress.” | Shows the resolved `~/.learnlm/` target and compact content boundary before the first write. |
| The learner resumes from an existing record. | Starts with retrieval evidence and lets current performance override the record. |

## Cross-cutting checks

For every scenario, verify:

- learner intent outranks the default workflow;
- the response manages cognitive load;
- teaching changes in response to evidence;
- active learning and metacognition are used only when proportionate;
- mastery is never inferred from “I understand” alone;
- the skill does not claim official Google status or Gemini-specific LearnLM capabilities;
- the skill does not write a learning record without explicit authorization.
