# Optional shared learning record

Read this reference only when the learner explicitly asks to save, inspect, or resume progress.

## Authorization and location

Use `~/.learnlm/` as the shared local directory across agents. Before the first write, resolve and show the exact path and summarize what will be stored. The learner's request to “save progress” authorizes the described write; ask again if the target or stored content materially changes.

Ordinary tutor sessions remain stateless. Store compact learning evidence and learner-authorized notes rather than raw conversation, and omit sensitive personal data, secrets, private source text, and unrelated activity.

## Files

Use Markdown so different agents can read the record without special tooling:

```text
~/.learnlm/
|-- profile.md              # optional stable preferences explicitly approved by the learner
`-- topics/
    `-- <topic-slug>.md     # one compact record per topic
```

Create `profile.md` only when stable preferences have actually been established. Use a short filesystem-safe topic slug and preserve existing user-authored content when updating a topic.

## Topic record

```markdown
# <Topic>

Updated: <ISO date>

## Goal
<Current learner goal>

## Demonstrated understanding
- <Capability and the evidence observed>

## Learner-authored notes
### <Milestone>
- Unaided: <learner's original wording or artifact reference>
- Revised: <learner's revised wording or artifact reference>
- Scaffold: <none, or the outline used after the learner remained stuck>

## Open gaps
- <Specific unresolved misconception, prerequisite, or uncertainty>

## Next retrieval or practice
- <One or more concrete prompts or tasks>

## Sources
- <Material used, with useful location or URL>

## Session notes
- <Date>: <brief change since the previous session>
```

Preserve the learner's wording except for formatting and clearly accepted corrections; place tutor additions outside the learner-authored note. Use evidence descriptions rather than numeric mastery scores. This version does not calculate FSRS intervals, schedule notifications, or maintain a dashboard.

## Resume

When asked to resume, read the relevant topic record, state its last update and unresolved items, then begin with retrieval evidence rather than re-explaining everything. Treat the record as a fallible handoff: current learner performance overrides it.
