---
name: workflow-status
description: Comprehensive view of Taskmaster project progress and recommendations
category: taskmaster-workflow
---

# Taskmaster Workflow Status

Get a comprehensive overview of project progress across Taskmaster and Linear.

## Information displayed:

- **Task metrics** - completion percentages by status
- **Active work** - currently in-progress tasks with recent updates
- **Linear sync** - integration status and last sync time
- **Recommendations** - next tasks based on dependencies
- **Blockers** - tasks requiring attention

## Interactive flow:

```
Claude: Which tag to check? (current: [project-tag])
Or type "all" for cross-tag overview:

User: [project-tag]

Claude: 📊 [Project Tag] Project Status

Task Overview:
├─ Total: 12 tasks (36 subtasks)
├─ Done: 3 (25%) ✅
├─ In Progress: 2 (17%) 🔄
├─ Pending: 7 (58%) ⏳
└─ Blocked: 0 (0%) 🚫

Currently Active:
• Task 1: Phaser Game Component
  └─ Subtask 1.2: Implementing SSR-safe init (30 min ago)
• Task 4: Auto-Save System
  └─ Subtask 4.1: Setting up state persistence (2 hours ago)

Linear Status:
✅ 5 issues synced (last: 15 min ago)
⚠️ 2 tasks need Linear issues (complexity ≥4)

Recommended Next:
1. Task 2 - No dependencies, low complexity (3)
2. Task 5 - Dependencies met, medium complexity (5)

Would you like details on any specific task?
```

## Additional features:

- **Dependency graph** - visualize task relationships
- **Time tracking** - estimate remaining work
- **Team view** - see work across different tags
- **Git status** - current branch and uncommitted changes

## Usage:
```
/project:workflow-status
```

## Quick actions from status:

- Jump to specific task details
- Start recommended task execution
- Trigger Linear sync for out-of-date items
- View detailed blocker information