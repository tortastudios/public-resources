---
name: sync-status
description: Fast status-only sync between Taskmaster and Linear for Slack notifications
category: taskmaster-workflow
---

# Sync Task Status to Linear

Fast, focused command to sync task and subtask statuses from Taskmaster to Linear without timeouts.

## Purpose

Updates Linear issue statuses to match Taskmaster task statuses, ensuring Slack notifications are triggered for team visibility.

## Workflow

1. **Get current tag tasks** - Retrieve all tasks with their current statuses
2. **Find status mismatches** - Compare Taskmaster vs Linear statuses  
3. **Batch status updates** - Update Linear issues in small, efficient batches
4. **Trigger notifications** - Linear updates automatically notify Slack

## Interactive flow

```
Claude: 🔄 Status Sync for tag 'tortastand'

Analyzing status differences between Taskmaster and Linear...

Found mismatches:
- Task 1: Taskmaster='done', Linear='Backlog' → Update to 'Done'
- Task 2: Taskmaster='done', Linear='Backlog' → Update to 'Done'  
- Subtask 1.1: Taskmaster='done', Linear='Backlog' → Update to 'Done'
- Subtask 1.2: Taskmaster='done', Linear='Backlog' → Update to 'Done'

Total updates needed: 4 tasks, 8 subtasks (12 total)

Options:
1. Update task statuses only (fast)
2. Update subtask statuses only (fast)
3. Update all statuses (recommended)
4. Cancel

User: 3

Claude: Updating all statuses...
✅ Updated 4 task statuses in Linear
✅ Updated 8 subtask statuses in Linear
✅ All status changes will trigger Slack notifications

Sync complete! Linear now matches Taskmaster status.
```

## Features

- **Fast execution** - Status updates only, no complex operations
- **Batch processing** - Updates multiple items efficiently  
- **Smart filtering** - Only updates items with status differences
- **Slack integration** - Triggers notifications via Linear updates
- **Safe operations** - Read-only analysis, targeted updates only

## Implementation Strategy

### **1. Status Comparison**
```typescript
async function findStatusMismatches() {
  // Get all Taskmaster tasks with statuses
  const taskmasterTasks = await mcp__task_master_ai__get_tasks({
    withSubtasks: true,
    projectRoot: getCurrentProjectRoot()
  });
  
  // Get corresponding Linear issues
  const linearIssues = await mcp__linear__list_issues({
    projectId: getCurrentLinearProjectId(),
    limit: 100
  });
  
  // Compare statuses and identify mismatches
  const mismatches = [];
  
  for (const task of taskmasterTasks) {
    const linearIssue = findLinearIssueByTitle(task.title, linearIssues);
    if (linearIssue && needsStatusUpdate(task.status, linearIssue.status)) {
      mismatches.push({
        type: 'task',
        taskId: task.id,
        linearId: linearIssue.id,
        taskmasterStatus: task.status,
        linearStatus: linearIssue.status
      });
    }
    
    // Check subtasks
    for (const subtask of task.subtasks || []) {
      const linearSubIssue = findLinearSubIssueByTitle(subtask.title, linearIssues);
      if (linearSubIssue && needsStatusUpdate(subtask.status, linearSubIssue.status)) {
        mismatches.push({
          type: 'subtask',
          subtaskId: subtask.id,
          linearId: linearSubIssue.id,
          taskmasterStatus: subtask.status,
          linearStatus: linearSubIssue.status
        });
      }
    }
  }
  
  return mismatches;
}
```

### **2. Batch Status Updates**
```typescript
async function batchUpdateStatuses(mismatches: StatusMismatch[]) {
  const BATCH_SIZE = 10; // Prevent timeout with small batches
  
  for (let i = 0; i < mismatches.length; i += BATCH_SIZE) {
    const batch = mismatches.slice(i, i + BATCH_SIZE);
    
    // Process batch in parallel
    await Promise.all(
      batch.map(async (mismatch) => {
        const linearStatus = mapTaskmasterToLinearStatus(mismatch.taskmasterStatus);
        const stateId = await getLinearStateId(linearStatus);
        
        await mcp__linear__update_issue(mismatch.linearId, {
          stateId: stateId
        });
        
        console.log(`✅ Updated ${mismatch.type} ${mismatch.taskId || mismatch.subtaskId} to ${linearStatus}`);
      })
    );
    
    // Progress indicator
    const completed = Math.min(i + BATCH_SIZE, mismatches.length);
    console.log(`Progress: ${completed}/${mismatches.length} status updates completed`);
  }
}
```

### **3. Status Mapping**
```typescript
function mapTaskmasterToLinearStatus(taskmasterStatus: string): string {
  const STATUS_MAPPING = {
    'pending': 'Backlog',
    'in-progress': 'In Progress',
    'review': 'In Review',
    'done': 'Done', 
    'blocked': 'Blocked',
    'cancelled': 'Cancelled'
  };
  
  return STATUS_MAPPING[taskmasterStatus] || 'Backlog';
}

function needsStatusUpdate(taskmasterStatus: string, linearStatus: string): boolean {
  const expectedLinearStatus = mapTaskmasterToLinearStatus(taskmasterStatus);
  return linearStatus !== expectedLinearStatus;
}
```

## Usage

```
/project:sync-status
```

## Options

- **Tasks only**: Update parent task statuses
- **Subtasks only**: Update sub-issue statuses  
- **All statuses**: Update both tasks and subtasks (recommended)
- **Dry run**: Show what would be updated without making changes

## Benefits

✅ **Fast execution** - Typically completes in 30-60 seconds
✅ **Reliable Slack notifications** - Every status change triggers notification
✅ **Safe operations** - Only updates status field, no data loss risk
✅ **Batch efficiency** - Optimized to prevent timeouts
✅ **Smart targeting** - Only updates items that actually need changes

## When to Use

- **After bulk task completion** - Sync completed work to trigger notifications
- **Before team meetings** - Ensure Linear reflects current progress
- **After manual status changes** - Sync any Taskmaster updates to Linear
- **Troubleshooting sync issues** - Quick way to fix status discrepancies

## Integration with Workflow

This command complements the automatic sync in `/project:execute-tasks`:

- **Automatic sync**: Handles real-time updates during task execution
- **Manual sync**: Handles bulk updates, corrections, and periodic alignment

Both approaches ensure Linear stays synchronized with Taskmaster for reliable Slack notifications and team visibility.