# Google Calendar Integration

## MCP Detection

At the start of every `/taskplan` invocation, check for calendar tools:

1. Search available tools for names containing: `calendar`, `gcal`, `google_calendar`
2. Look for these key capabilities:
   - **List/query events** — to find busy times
   - **Create events** — to schedule tasks
   - **Delete events** — for `/taskplan clear`

If no calendar MCP is found, fall back to breakdown-only mode.

## Connecting a Calendar MCP

When suggesting calendar connection to the user, provide options:

```
To auto-schedule into Google Calendar, connect a calendar MCP.
Popular options:

  # Google Calendar MCP (community)
  claude mcp add google-calendar -- npx @anthropic/google-calendar-mcp

  # Or search the MCP registry for "calendar"
```

## Free Slot Detection

### Algorithm

1. Query calendar for events in the scheduling window (now → deadline, or now + 2 weeks)
2. Extract busy periods as `[start, end]` pairs
3. Generate free slots by inverting busy periods within work hours
4. Work hours default to 9:00 AM – 9:00 PM in user's local timezone
5. Skip to next day when past sleep_time

### Work Hours Handling

- Ask the user for their work hours on first use, or default to 9AM-9PM
- All times in the user's local timezone
- Handle DST transitions properly (use IANA timezone IDs)

## Event Creation

When creating calendar events for scheduled tasks:

### Event Properties
- **Title**: Task title (no emoji prefix needed, keep it clean)
- **Description**: Subtask description + "\n\nScheduled by Taskplan"
- **Color**: Cycle through available colors for visual variety
- **Reminder**: 15-minute popup reminder
- **Time**: Start and end times from the AI schedule output

### Color Cycling Pattern
Rotate through calendar colors to make Taskplan events visually distinct:
```
colors = ["lavender", "sage", "grape", "flamingo", "banana",
          "tangerine", "peacock", "graphite", "blueberry", "basil", "tomato"]
event_color = colors[subtask_order % len(colors)]
```

## Cleanup

For `/taskplan clear`:
1. Query recent events (past month + next month)
2. Filter for events with "Scheduled by Taskplan" in description
3. Delete matching events
4. Report count of deleted events

## Timezone Best Practices

1. Always detect or ask for user's timezone on first interaction
2. Store as IANA timezone ID (e.g., "America/New_York", "Asia/Shanghai")
3. All calendar API calls use UTC or RFC3339 with offset
4. Display times in user's local timezone
5. Handle "tomorrow" / "next week" relative to user's local time, not UTC
