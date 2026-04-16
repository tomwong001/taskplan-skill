# Taskplan

AI task breakdown and scheduling skill for Claude Code.

Turn overwhelming tasks into clear, actionable plans with realistic time estimates. Optionally schedule them directly into Google Calendar.

## Background

This skill is extracted from **[Steplify.ai](https://steplify.ai)**, a startup that built an AI-powered personal task planner and calendar scheduler. The product helped users break down complex tasks, estimate realistic durations, and auto-schedule everything into Google Calendar.

Steplify ran in production through 2025–2026, serving real users with features like:
- AI task breakdown with anti-procrastination prompting
- Personalized time estimation that learned from your actual work patterns
- Google Calendar integration with smart free-slot detection
- RAG-based behavioral profiling (ChromaDB + GPT)

The startup shut down, but the core planning logic — the prompts, scheduling patterns, and learning algorithms — was too useful to let die. So we open-sourced it as a Claude Code skill.

**What survived:** The battle-tested prompt engineering, scheduling heuristics, and user learning patterns. No API keys, user data, or backend infrastructure — just the brains.

## What It Does

- **Break down complex tasks** into ordered subtasks with duration estimates
- **Schedule into Google Calendar** if a calendar MCP is connected
- **Learn your patterns** over time — adjusts estimates based on your actual work habits

## Install

```bash
claude install-skill /path/to/taskplan.skill
```

Or add the skill directory to your Claude Code project.

## Usage

```
/taskplan "Write a research paper on climate change, due next Friday"
```

### Commands

| Command | Description |
|---------|-------------|
| `/taskplan <task>` | Break down + schedule (if calendar connected) |
| `/taskplan breakdown <task>` | Breakdown only, no scheduling |
| `/taskplan schedule` | Schedule a previous breakdown into calendar |
| `/taskplan clear` | Remove all Taskplan events from calendar |

## Example

```
> /taskplan "Prepare for job interview at Google, this Thursday"

## Task: Prepare for job interview at Google
Deadline: Thursday
Total estimated time: 6.5 hours

| # | Task                          | Duration | Description                              |
|---|-------------------------------|----------|------------------------------------------|
| 1 | Research Google's recent work  | 1h       | Products, culture, recent news           |
| 2 | Review common interview Qs     | 1.5h     | Behavioral + technical questions         |
| 3 | Practice coding problems       | 2h       | LeetCode medium, focus on arrays/trees   |
| 4 | Prepare STAR stories           | 1h       | 5 stories for behavioral questions       |
| 5 | Mock interview run-through     | 1h       | End-to-end practice with timer           |
```

## Calendar Integration

Taskplan works in two modes:

**Without calendar MCP** — gives you a plan with time estimates. You schedule it yourself.

**With calendar MCP** — finds free slots in your calendar and creates events automatically.

To connect Google Calendar:
```bash
claude mcp add google-calendar -- npx @anthropic/google-calendar-mcp
```

## How It Works

Built from production-tested patterns (previously powering [Steplify.ai](https://steplify.ai)):

1. **No meta-tasks** — won't generate "plan the plan" or "define objectives". Every subtask is real work.
2. **Duration = complexity** — a 2-hour task takes 2 hours whether the deadline is tomorrow or next month.
3. **Simple stays simple** — won't over-engineer "buy groceries" into 5 subtasks.
4. **Deadline honesty** — flags tasks that won't fit before the deadline.

## Project Structure

```
taskplan-skill/
├── skill/
│   ├── SKILL.md                        # Main skill definition
│   └── references/
│       ├── prompts.md                  # Core AI prompts
│       ├── calendar-integration.md     # Calendar MCP patterns
│       └── learning.md                 # User pattern learning
├── build-skill.sh                      # Build script
├── VERSION
└── taskplan.skill                      # Built skill (ZIP)
```

## Build

```bash
./build-skill.sh
```

## License

MIT
