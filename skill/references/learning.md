# Learning from User Patterns

Taskplan can improve over time by learning from the user's actual task completion patterns.
This is an advanced feature that builds a behavioral profile across sessions.

## What to Learn

### 1. Duration Accuracy
Track estimated vs. actual time for completed tasks:
- If user consistently takes 1.5x estimated time for "writing" tasks, adjust future estimates
- If user finishes "coding" tasks in 0.7x estimated time, tighten estimates

### 2. Time Preferences
Observe when users prefer different task types:
- Deep work (writing, coding) → morning
- Meetings, calls → afternoon
- Creative work → evening
- Exercise → early morning

### 3. Task Complexity Patterns
- How many subtasks users typically need
- Whether they prefer detailed or high-level breakdowns
- Common task types and their typical structures

## How to Learn (Using Memory)

Since this is a Claude Code skill, use the **memory system** to persist learnings:

### Saving Patterns
After the user completes tasks or provides feedback on estimates:

```markdown
---
name: taskplan_user_profile
description: Taskplan user behavioral profile — task duration patterns and time preferences
type: user
---

## Duration Patterns
- Writing tasks: typically take 1.3x estimated (user is thorough)
- Coding tasks: typically take 0.8x estimated (user is experienced)
- Research tasks: on target

## Time Preferences
- Prefers deep work before noon
- Avoids scheduling after 8pm
- Likes 15-min breaks between tasks

## Complexity Preferences
- Prefers 3-5 subtasks max
- Wants brief descriptions, not detailed
```

### Reading Patterns
At the start of each `/taskplan` invocation:
1. Check if `taskplan_user_profile` exists in memory
2. If yes, load and incorporate into the planning prompt as additional context
3. Add to the system instructions: "Use the user's behavioral profile for reference..."

## Profile Injection Format

When a profile exists, append this to the planning prompt:

```
User's behavioral profile and preferences (for reference):
- Task type patterns: {duration_patterns}
- Time preferences: {time_preferences}
- Complexity preferences: {complexity_preferences}
- Known habits: {habits_list}

Use these patterns to make more accurate duration estimates and scheduling decisions.
```

## Event Type Classification

Classify tasks into types for pattern tracking:

| Keywords | Type |
|----------|------|
| meeting, call, zoom, standup | meeting |
| study, homework, assignment, learn | study |
| work, project, task, build, implement | work |
| exercise, gym, workout, run, yoga | exercise |
| write, essay, report, document, blog | writing |
| code, program, develop, debug, fix | coding |
| research, investigate, explore, analyze | research |
| read, review, check | review |

## When to Update Profile

Update the profile when:
1. User explicitly says "that took longer/shorter than expected"
2. User adjusts estimates you provided ("make it 2 hours instead of 1")
3. User consistently reschedules certain task types to different times
4. User provides feedback on breakdown granularity

Don't update on every interaction — wait for clear signals.
