# Linear Sync Functions

Internal functions used by `/project:execute-tasks` for real-time Linear synchronization.

## Core Sync Functions

### **ensureTaskLinearMapping(taskId: string): Promise<string>**
Guarantees a Linear issue exists for the given Taskmaster task.

**Logic:**
1. Query existing Linear issues to find task mapping
2. If no mapping exists, create new Linear issue
3. Return Linear issue ID for further operations

**Implementation Pattern:**
```typescript
async ensureTaskLinearMapping(taskId: string): Promise<string> {
  // Get task details from Taskmaster
  const task = await mcp__task_master_ai__get_task(taskId);
  
  // Check if Linear issue already exists (session memory or API search)
  let linearIssueId = findExistingLinearIssue(taskId);
  
  if (!linearIssueId) {
    // Create new Linear issue
    const issue = await mcp__linear__create_issue({
      title: task.title,
      description: task.description,
      teamId: getLinearTeamId(),
      projectId: getLinearProjectId(),
      assigneeId: getCurrentUserId()
    });
    
    linearIssueId = issue.id;
    
    // Store mapping in session memory
    storeTaskLinearMapping(taskId, linearIssueId);
  }
  
  return linearIssueId;
}
```

### **ensureSubtaskLinearMapping(parentTaskId: string, subtaskId: string): Promise<string>**
Guarantees a Linear sub-issue exists for the given Taskmaster subtask.

**Logic:**
1. Ensure parent task has Linear issue (call ensureTaskLinearMapping)
2. Query existing Linear sub-issues to find subtask mapping
3. If no mapping exists, create new Linear sub-issue with parent relationship
4. Return Linear sub-issue ID

**Implementation Pattern:**
```typescript
async ensureSubtaskLinearMapping(parentTaskId: string, subtaskId: string): Promise<string> {
  // Ensure parent Linear issue exists
  const parentLinearId = await ensureTaskLinearMapping(parentTaskId);
  
  // Get subtask details
  const subtask = await mcp__task_master_ai__get_task(subtaskId);
  
  // Check if Linear sub-issue already exists
  let linearSubIssueId = findExistingLinearSubIssue(subtaskId);
  
  if (!linearSubIssueId) {
    // Create new Linear sub-issue
    const subIssue = await mcp__linear__create_issue({
      title: subtask.title,
      description: subtask.description,
      parentId: parentLinearId,  // Critical: parent-child relationship
      teamId: getLinearTeamId(),
      projectId: getLinearProjectId(),  // Inherit from parent
      assigneeId: getCurrentUserId()
    });
    
    linearSubIssueId = subIssue.id;
    
    // Store mapping in session memory
    storeSubtaskLinearMapping(subtaskId, linearSubIssueId);
  }
  
  return linearSubIssueId;
}
```

### **syncTaskStatus(taskId: string, status: TaskStatus): Promise<void>**
Updates Linear issue status to match Taskmaster task status.

**Logic:**
1. Ensure Linear issue exists for task
2. Map Taskmaster status to Linear state
3. Update Linear issue status
4. Add status change comment for audit trail

**Status Mapping:**
```typescript
const STATUS_MAPPING = {
  'pending': 'Backlog',
  'in-progress': 'In Progress',
  'review': 'In Review', 
  'done': 'Done',
  'blocked': 'Blocked',
  'cancelled': 'Cancelled'
};
```

**Implementation Pattern:**
```typescript
async syncTaskStatus(taskId: string, status: TaskStatus): Promise<void> {
  const linearIssueId = await ensureTaskLinearMapping(taskId);
  const linearStatus = STATUS_MAPPING[status];
  
  // Get Linear state ID for status
  const stateId = await getLinearStateId(linearStatus);
  
  // Update Linear issue status
  await mcp__linear__update_issue(linearIssueId, {
    stateId: stateId
  });
  
  // Add audit comment
  await mcp__linear__create_comment(linearIssueId, 
    `🔄 Status updated to: ${linearStatus} (synced from Taskmaster)`
  );
  
  // Update session memory
  updateTaskStatusInMemory(taskId, status);
}
```

### **syncSubtaskProgress(subtaskId: string, progress: string): Promise<void>**
Adds implementation progress to Linear sub-issue as comments.

**Logic:**
1. Ensure Linear sub-issue exists for subtask
2. Add progress as timestamped comment
3. Update sub-issue status if applicable (e.g., completion)

**Implementation Pattern:**
```typescript
async syncSubtaskProgress(subtaskId: string, progress: string): Promise<void> {
  const [parentTaskId] = subtaskId.split('.'); // Extract parent task ID
  const linearSubIssueId = await ensureSubtaskLinearMapping(parentTaskId, subtaskId);
  
  // Add timestamped progress comment
  const timestamp = new Date().toISOString();
  const progressComment = `⚡ **Progress Update** (${timestamp})

${progress}

*Synced from Taskmaster subtask ${subtaskId}*`;
  
  await mcp__linear__create_comment(linearSubIssueId, progressComment);
  
  // Check if subtask is complete and update status
  const subtask = await mcp__task_master_ai__get_task(subtaskId);
  if (subtask.status === 'done') {
    const doneStateId = await getLinearStateId('Done');
    await mcp__linear__update_issue(linearSubIssueId, {
      stateId: doneStateId
    });
  }
}
```

## Error Handling & Resilience

### **handleLinearSyncFailure(error: Error, operation: string): void**
Graceful error handling for Linear API failures.

**Strategy:**
- Log error details for debugging
- Continue task execution (don't block on Linear failures)
- Queue retry operations for later
- Notify user of sync issues

```typescript
async function handleLinearSyncFailure(error: Error, operation: string): Promise<void> {
  console.error(`Linear sync failed for ${operation}:`, error);
  
  // Add to retry queue
  queueLinearRetry(operation);
  
  // Continue execution - don't block on Linear failures
  console.warn(`Continuing task execution despite Linear sync failure`);
}
```

## Session Memory Management

### **Task-Linear Mapping Cache**
Maintain in-memory cache of task→issue mappings to avoid repeated API calls.

```typescript
interface TaskLinearMapping {
  taskId: string;
  linearIssueId: string;
  subtasks: Map<string, string>; // subtaskId → linearSubIssueId
  lastSynced: Date;
}

const sessionMappings = new Map<string, TaskLinearMapping>();
```

### **Sync State Tracking**
Track what's been synced to avoid duplicate operations.

```typescript
interface SyncState {
  tasksSynced: Set<string>;
  subtasksSynced: Set<string>;
  statusUpdates: Map<string, TaskStatus>;
  errors: Array<{operation: string, error: Error, timestamp: Date}>;
}
```

## Integration Points

### **Called by execute-tasks at these points:**

1. **Task Start**: `await syncTaskStatus(taskId, "in-progress")`
2. **Subtask Progress**: `await syncSubtaskProgress(subtaskId, progressUpdate)`
3. **Task Completion**: `await syncTaskStatus(taskId, "done")`
4. **Error Handling**: `await handleLinearSyncFailure(error, operation)`

### **Safety & Validation:**

- **Duplicate Prevention**: Check session memory before creating new issues
- **Project Inheritance**: Sub-issues automatically inherit parent's project
- **Immediate Validation**: Verify project assignment after sub-issue creation
- **Graceful Degradation**: Continue task execution even if Linear sync fails

## Benefits of This Architecture

✅ **Complete 1:1 Parity**: Every task and subtask gets Linear representation  
✅ **Real-time Sync**: Status changes propagate immediately  
✅ **No Manual Intervention**: Execute-tasks handles all sync automatically  
✅ **Resilient**: Graceful handling of Linear API failures  
✅ **Efficient**: Session memory prevents duplicate API calls  
✅ **Auditable**: All changes logged with timestamps and context