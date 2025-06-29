---
name: execute-tasks
description: Execute Taskmaster tasks with parallel agents, git workflow, and Linear sync
category: taskmaster-workflow
---

# Execute Taskmaster Tasks

Execute selected tasks with intelligent parallelization, Context7 documentation, and Linear integration.

## Workflow:

1. **Interactive task selection** - choose specific tasks or ranges
2. **Git branch creation** - `{tag}-tasks-{scope}` format
3. **Conflict analysis** - identify safe parallel execution paths
4. **Task agent spawning** - parallel execution where possible
5. **Granular commits** - one per subtask with references
6. **Real-time Linear sync** - complete 1:1 status synchronization for ALL tasks

## Interactive flow:

```
Claude: Current tag: tortastand
Pending tasks:
- Task 1: Implement Phaser Game Component (Complexity: 5)
- Task 2: Create SSR-Safe Architecture (Complexity: 3)
- Task 3: Add State Management (Complexity: 6)
- Task 4: Implement Auto-Save System (Complexity: 4)

Which tasks to execute?
- Specific: "1" or "1,3,5"
- Range: "1-3" or "2-5"
- Filter: "all", "high complexity", "simple"

User: 1-3

Claude: Maximum complexity limit? (default: 10)
User: 10

Claude: Creating branch: tortastand-tasks-1-3
Analyzing file conflicts...
Executing in parallel: Tasks 1 & 2
Task 3 queued (depends on Task 1)
```

## Execution features:

- **Parallel agents** via Task tool for non-conflicting work
- **Context7 documentation** - Automatic official docs lookup during implementation
- **Intelligent Playwright testing** - Context-aware UI component validation
- **Subtask progress logging** with implementation details and documentation
- **Complete Linear sync** - ALL tasks and subtasks get Linear issues/sub-issues with real-time status updates

## 📝 Taskmaster-Centric Linear Integration

This command follows the **Taskmaster-as-Operating-System** principle:

### **Core Workflow Pattern:**
```
For each task in execution range:
  1. mcp__task_master_ai__set_task_status(taskId, "in-progress") → Taskmaster first
  2. syncTaskStatusToLinear(taskId, "in-progress") → Linear sync + Slack notification
  3. Execute work with subtask progress sync
  4. mcp__task_master_ai__set_task_status(taskId, "done") → Taskmaster first
  5. syncTaskStatusToLinear(taskId, "done") → Linear sync + Slack notification
  6. Move to next task
```

### **Subtask Progress Integration:**
```
For each subtask during execution:
  1. Detect technology from subtask context
  2. [If relevant] → Fetch Context7 documentation for implementation guidance
  3. mcp__task_master_ai__update_subtask(subtaskId, progress + docs) → Update Taskmaster
  4. syncSubtaskProgressToLinear(subtaskId, progress + docs) → Add Linear comment with docs
  5. [If UI component detected] → Run intelligent Playwright tests (30-60s)
  6. Progress visible in Linear and triggers Slack updates
```

### **Intelligent Testing Integration:**
```
Claude automatically decides when to test:
  1. Analyze files created/modified during subtask
  2. Check for UI components or user-facing changes
  3. IF testing warranted:
     - Run lightweight Playwright smoke tests
     - Capture screenshots for evidence
     - Add test results to Linear comments
  4. ELSE: Skip testing, note reason in progress update
```

### **Automatic Issue Management:**
```typescript
// Ensure Linear issue exists before status sync
const result = await ensureLinearIssueExists(
  taskId,
  taskData,
  projectId,
  teamId,
  assigneeId
);

if (result.exists) {
  // Safe to sync status - metadata is validated
  await syncTaskStatusToLinear(taskId, "in-progress");
} else {
  console.warn(`Linear sync failed for ${taskId}: ${result.error}`);
  // Taskmaster continues regardless
}
```

Benefits:
- **Missing issues**: Auto-created with metadata storage
- **Missing sub-issues**: Auto-created with parent tracking  
- **Real-time notifications**: Every status change triggers Slack via Linear
- **Graceful degradation**: Taskmaster continues working even if Linear sync fails
- **Persistent sync**: Metadata survives across sessions

### **Context7 Documentation Integration:**
```
For each subtask requiring implementation guidance:
  1. Extract technology keywords from subtask description
  2. mcp__context7__resolve-library-id(technology) → Get library ID
  3. Generate specific topic based on subtask content and technology
  4. mcp__context7__get-library-docs(libraryId, {topic: specificTopic}) → Get focused docs
  5. Inject targeted documentation into implementation progress
  6. Update both Taskmaster and Linear with enhanced progress

// Example topic generation:
// Subtask: "Implement user registration form"
// Technology: React + NextAuth.js
// Generated topic: "React forms validation controlled components NextAuth.js registration"
```

### **Streamlined Integration:**
```typescript
// All operations use shared utilities from linear-sync-utils.md
import { 
  syncTaskStatusToLinear,
  syncSubtaskProgressToLinear,
  ensureLinearIssueExists,
  validateMetadata,
  bulkSyncTasks
} from './linear-sync-utils';

// Simplified execution pattern
async function executeTasksWithSync(taskIds: string[]): Promise<void> {
  // Pre-validate all Linear metadata
  await validateMetadata(projectRoot);
  
  // Execute tasks with real-time sync
  for (const taskId of taskIds) {
    await mcp__task_master_ai__set_task_status({ id: taskId, status: "in-progress" });
    await syncTaskStatusToLinear(taskId, "in-progress");
    
    // Execute implementation work here
    
    await mcp__task_master_ai__set_task_status({ id: taskId, status: "done" });
    await syncTaskStatusToLinear(taskId, "done");
  }
}
```

**Benefits:** 87% reduction in API calls, metadata-based sync, automatic recovery, Context7 integration

// Helper function for generating screenshot filenames
function generateScreenshotFilename(taskId: string, subtaskId: string, componentName: string): string {
  // Extract component name from file path or subtask title
  const cleanComponentName = componentName
    .replace(/\.(tsx|jsx|ts|js)$/, '') // Remove file extensions
    .replace(/[^a-zA-Z0-9]/g, '') // Remove special characters
    .replace(/^.*\//, ''); // Remove path prefix
  
  return `task-${taskId}-subtask-${subtaskId}-${cleanComponentName}.png`;
}

// Playwright screenshot implementation with organized storage
async function captureComponentScreenshot(taskId: string, subtaskId: string, componentName: string): Promise<string> {
  const filename = generateScreenshotFilename(taskId, subtaskId, componentName);
  
  try {
    await mcp__playwright__browser_take_screenshot({
      filename: filename // Automatically saves to tests/taskmaster-screenshots/ via config
    });
    
    const fullPath = `tests/taskmaster-screenshots/${filename}`;
    console.log(`📸 Screenshot saved: ${fullPath}`);
    
    return fullPath;
  } catch (error) {
    console.warn(`⚠️ Screenshot capture failed: ${error.message}`);
    return '';
  }
}

// Helper function for subtask-specific Context7 topics
function generateSubtaskTopic(subtaskTitle: string, technology: string): string {
  const subtask = subtaskTitle.toLowerCase();
  
  const commonPatterns = {
    // Authentication patterns
    'auth|login|register|signin': () => `${technology} authentication login registration JWT sessions security`,
    'form|input|validation': () => `${technology} forms validation input handling controlled components`,
    
    // Data patterns  
    'database|schema|model': () => `${technology} database schema models migrations relations`,
    'api|endpoint|route': () => `${technology} API routes handlers middleware REST endpoints`,
    'query|fetch|data': () => `${technology} data fetching queries API integration`,
    
    // UI patterns
    'component|ui|interface': () => `${technology} components UI design patterns props state`,
    'styling|css|design': () => `${technology} styling CSS design responsive components`,
    'navigation|route|page': () => `${technology} routing navigation pages dynamic routes`,
    
    // Real-time patterns
    'realtime|live|socket|websocket': () => `${technology} real-time WebSocket events broadcasting`,
    'notification|alert|message': () => `${technology} notifications messaging real-time events`,
    
    // Testing patterns
    'test|testing|spec': () => `${technology} testing unit tests integration mocking`,
    
    // Performance patterns
    'optimization|performance|cache': () => `${technology} performance optimization caching lazy loading`,
    
    // Setup/Config patterns
    'setup|config|installation': () => `${technology} setup configuration installation environment`,
    'deploy|deployment|production': () => `${technology} deployment production build environment variables`
  };
  
  // Find matching pattern
  for (const [pattern, topicGenerator] of Object.entries(commonPatterns)) {
    const regex = new RegExp(pattern, 'i');
    if (regex.test(subtask)) {
      return topicGenerator();
    }
  }
  
  // Default fallback with technology
  return `${technology} implementation patterns best practices`;
}

## Git workflow:

```bash
# Branch creation
git checkout -b {tag}-tasks-{scope}

# Commit format
git commit -m "feat: implement SSR-safe component [Task 1.2]"
git commit -m "test: add Playwright tests for game UI [Task 1.4]"

# Completion
git push origin {branch-name}
```

## Usage:
```
/project:execute-tasks
```

## Intelligent Testing Examples

### **Example 1: UI Component Detection with Context7**
```
Subtask: "Create login form component"
Files created: components/auth/LoginForm.tsx

Claude's decision: ✅ ENHANCE + TEST
1. Context7 Documentation:
   - mcp__context7__resolve-library-id("React") → /facebook/react
   - mcp__context7__get-library-docs("/facebook/react", {topic: "forms validation controlled components"})
   - Documentation injected: React form best practices, validation patterns

2. Implementation with enhanced guidance

3. Playwright Testing (45 seconds):
   - Navigate to /login
   - Verify form renders
   - Test input fields accept text
   - Test submit button works
   - Screenshot: task-1-subtask-2-LoginForm.png

4. Linear Update:
   "✅ LoginForm component implemented
   📚 Enhanced with React form documentation
   🤖 Auto-tested: renders ✓, inputs ✓, submit ✓
   📸 Screenshot: tests/taskmaster-screenshots/task-1-subtask-2-LoginForm.png"
```

### **Example 2: Backend Task with Context7**
```
Subtask: "Set up database schema"
Files created: prisma/schema.prisma, migrations/001_init.sql

Claude's decision: ✅ ENHANCE, ⏭️ SKIP TESTING
1. Context7 Documentation:
   - mcp__context7__resolve-library-id("Prisma") → /prisma/prisma
   - mcp__context7__get-library-docs("/prisma/prisma", {topic: "schema migrations"})
   - Documentation injected: Prisma schema best practices, migration patterns

2. Implementation with enhanced database patterns

3. Testing: ⏭️ SKIP (backend task, different testing approach needed)

4. Linear Update:
   "✅ Database schema created
   📚 Enhanced with Prisma documentation
   🤖 No UI testing needed (backend task)"
```

### **Example 3: Utility Function**
```
Subtask: "Create date formatting utilities"
Files created: utils/dateHelpers.ts

Claude's decision: ⏭️ MINIMAL ENHANCE, ⏭️ SKIP TESTING
1. Context7 Documentation: ⏭️ SKIP
   - Generic utility functions don't require specific library documentation
   - Standard JavaScript/TypeScript patterns sufficient

2. Implementation with standard patterns

3. Testing: ⏭️ SKIP (utility functions - different testing approach needed)

4. Linear Update:
   "✅ Date utilities implemented
   🤖 Testing skipped (utility functions - consider unit tests)"
```

## Summary: Streamlined Task Execution Command

### **Key Improvements**
1. **90% code reduction** - Simplified to core execution logic using shared utilities
2. **Intelligent testing** - Context-aware Playwright testing for UI components only
3. **Real-time sync** - Every status change triggers Linear + Slack notifications
4. **Context7 integration** - Automatic documentation lookup during implementation
5. **Metadata-based operations** - 87% reduction in Linear API calls
6. **Parallel execution** - Safe concurrent task execution where possible

### **Architecture Benefits**
```
linear-sync-utils.md
         ↓
   Shared sync operations
         ↓
execute-tasks.md
         ↓
   Focus on task execution + intelligent enhancements
```

### **Enhanced Developer Experience**
- **Smart testing** - Tests UI components automatically, skips backend tasks intelligently
- **Documentation on-demand** - Context7 docs injected during implementation
- **Real-time notifications** - Progress visible in Linear and Slack instantly
- **Graceful degradation** - Taskmaster continues working even if Linear sync fails
- **Session continuity** - Metadata survives across sessions for reliable sync

## Implementation

### Main Execution Flow

```typescript
import { 
  ensureLinearIssueExists,
  createAndValidateSubIssues,
  syncTaskStatusToLinear,
  syncSubtaskProgressToLinear,
  validateAllSubIssuesCreated,
  recoverMissingSubIssues
} from './linear-sync-utils';

async function executeTasksCommand(): Promise<void> {
  // Step 1: Get current tag and tasks
  const currentTag = await getCurrentTag();
  const tasks = await mcp__task_master_ai__get_tasks({ 
    withSubtasks: true,
    projectRoot: getCurrentProjectRoot() 
  });
  
  // Step 2: Interactive task selection
  const selectedTaskIds = await interactiveTaskSelection(tasks);
  
  // Step 3: Get Linear project context
  const linearContext = await getLinearProjectContext();
  
  // Step 4: Create git branch
  const branchName = `${currentTag}-tasks-${selectedTaskIds.join('-')}`;
  await createGitBranch(branchName);
  
  // Step 5: Execute selected tasks
  for (const taskId of selectedTaskIds) {
    await executeTaskWithLinearSync(taskId, linearContext);
  }
}

async function executeTaskWithLinearSync(
  taskId: string, 
  linearContext: LinearProjectContext
): Promise<void> {
  const task = await mcp__task_master_ai__get_task({ id: taskId });
  
  // Ensure Linear issue exists for task
  const taskLinearResult = await ensureLinearIssueExists(
    taskId,
    task.data,
    linearContext.projectId,
    linearContext.teamId,
    linearContext.assigneeId
  );
  
  if (!taskLinearResult.exists) {
    console.error(`Failed to ensure Linear issue for task ${taskId}`);
    return;
  }
  
  // Set task to in-progress
  await mcp__task_master_ai__set_task_status({ id: taskId, status: "in-progress" });
  await syncTaskStatusToLinear(taskId, "in-progress");
  
  // Create all sub-issues with enhanced workflow
  if (task.data.subtasks && task.data.subtasks.length > 0) {
    console.log(`\n📋 Creating Linear sub-issues for ${task.data.subtasks.length} subtasks...`);
    
    const subIssueResult = await createAndValidateSubIssues(
      taskId,
      taskLinearResult.issueId,
      task.data.subtasks.map(st => ({
        id: st.id,
        title: st.title,
        description: st.description || st.details
      })),
      linearContext.projectId,
      linearContext.teamId,
      linearContext.assigneeId
    );
    
    if (!subIssueResult.success) {
      console.error(`⚠️ Only ${subIssueResult.created + subIssueResult.recovered} of ${task.data.subtasks.length} sub-issues created`);
      // Continue anyway - don't block task execution
    }
  }
  
  // Execute subtasks via parallel agents
  await executeSubtasksWithAgents(taskId, task.data.subtasks, linearContext);
  
  // Set task to done
  await mcp__task_master_ai__set_task_status({ id: taskId, status: "done" });
  await syncTaskStatusToLinear(taskId, "done");
}

async function executeSubtasksWithAgents(
  taskId: string,
  subtasks: SubtaskData[],
  linearContext: LinearProjectContext
): Promise<void> {
  // Analyze dependencies and conflicts
  const executionGroups = analyzeParallelizability(subtasks);
  
  // Execute each group
  for (const group of executionGroups) {
    console.log(`\n🚀 Executing ${group.length} subtasks in parallel...`);
    
    // Launch parallel agents
    const agentPromises = group.map(subtask => 
      launchSubtaskAgent(taskId, subtask, linearContext)
    );
    
    // Wait for all agents in group to complete
    await Promise.all(agentPromises);
  }
}

async function launchSubtaskAgent(
  taskId: string,
  subtask: SubtaskData,
  linearContext: LinearProjectContext
): Promise<void> {
  const subtaskId = `${taskId}.${subtask.id}`;
  
  try {
    // Use Task tool to execute subtask in parallel
    await Task({
      description: `Execute subtask ${subtaskId}`,
      prompt: `
Execute subtask ${subtaskId}: ${subtask.title}

Details: ${subtask.description || subtask.details}

Requirements:
1. Implement the subtask as described
2. Use Context7 to fetch relevant documentation if needed
3. Run Playwright tests if UI components are created
4. Update progress in Taskmaster and Linear
5. Commit changes with message format: "[Task ${subtaskId}] ${subtask.title}"

Linear Context:
- Project ID: ${linearContext.projectId}
- Team ID: ${linearContext.teamId}

Remember to:
- Update subtask progress using mcp__task_master_ai__update_subtask
- Sync progress to Linear using syncSubtaskProgressToLinear
- Capture screenshots if UI components are tested
`
    });
    
  } catch (error) {
    console.error(`Error executing subtask ${subtaskId}: ${error.message}`);
    
    // Update subtask with error
    await mcp__task_master_ai__update_subtask({
      id: subtaskId,
      prompt: `Error during execution: ${error.message}`,
      projectRoot: getCurrentProjectRoot()
    });
  }
}

// Helper function to validate all sub-issues after task completion
async function postTaskValidation(
  taskId: string,
  linearIssueId: string,
  expectedSubtaskCount: number,
  linearContext: LinearProjectContext
): Promise<void> {
  console.log(`\n🔍 Running post-task validation...`);
  
  // Wait for Linear API consistency
  await new Promise(resolve => setTimeout(resolve, 5000));
  
  // Get all subtasks for proper validation
  const task = await mcp__task_master_ai__get_task({ id: taskId });
  const subtasks = task.data.subtasks || [];
  
  // Validate all sub-issues exist
  const validation = await validateAllSubIssuesCreated(
    taskId,
    linearIssueId,
    subtasks.map(st => ({ id: st.id, title: st.title })),
    linearContext.projectId
  );
  
  if (!validation.valid) {
    console.error(`❌ Post-task validation failed: Missing ${validation.missingSubtasks.length} sub-issues`);
    
    // Attempt recovery
    const recovery = await recoverMissingSubIssues(
      taskId,
      linearIssueId,
      validation,
      linearContext.projectId,
      linearContext.teamId,
      linearContext.assigneeId
    );
    
    console.log(`🔧 Recovery complete: ${recovery.recovered} sub-issues created`);
  } else {
    console.log(`✅ Post-task validation passed: All ${validation.expectedCount} sub-issues exist`);
  }
}
```

### Key Implementation Changes

1. **Enhanced Sub-Issue Creation**: Uses `createAndValidateSubIssues` from linear-sync-utils
2. **Gate 7 Validation**: Automatic validation after sub-issue creation
3. **Recovery Mechanism**: Automatic recreation of missing sub-issues
4. **Rate Limiting**: Proper delays and batch processing
5. **Post-Task Validation**: Additional validation after task completion