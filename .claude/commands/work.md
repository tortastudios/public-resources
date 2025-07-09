---
name: work
description: Intelligent task execution with team coordination and automatic sync
category: simplified-workflow
---

# Task Execution (/work)

**Streamlined task execution with intelligent selection, parallel agents, and perfect Linear sync - all through a simplified interface.**

## Purpose

Execute tasks with intelligent prioritization, automatic team coordination, and seamless Linear integration while maintaining all sophisticated workflow capabilities.

## Workflow Overview

1. **Tag Selection** - Choose project context (commands work independently)
2. **Task Selection** - AI-recommended tasks with complexity analysis
3. **Execution** - Parallel agents with real-time Linear updates

## Essential Requirements (Non-Negotiable)

- ✅ **Tag confirmation required** - Never assume tag context
- ✅ **Commands work independently** - No context assumptions
- ✅ **No redundant Context7** - Tasks already enhanced during setup
- ✅ **Linear sub-issue updates** - ALL subtasks sync to Linear sub-issues
- ✅ **Team coordination** - Real-time progress updates

## Command Implementation

### Step 1: Tag Selection (Required)
```typescript
// Always confirm tag - commands are independent
const availableTags = await mcp__task_master_ai__list_tags({ projectRoot });

// Show available tags with task counts
const tagOptions = availableTags.map(tag => ({
  label: `${tag.name} (${tag.pendingTasks} pending tasks)`,
  value: tag.name
}));

const selectedTag = await promptUser("Which tag should I work on?", tagOptions);
```

### Step 2: Intelligent Task Selection
```typescript
// Get tasks for selected tag
const tasks = await mcp__task_master_ai__get_tasks({
  projectRoot,
  withSubtasks: true,
  status: 'pending'
});

// Analyze task priorities and dependencies
const taskAnalysis = await analyzeTaskPriorities(tasks, selectedTag);

// Present intelligent recommendations
const recommendations = {
  primary: taskAnalysis.highPriority[0],
  alternatives: taskAnalysis.readyTasks.slice(0, 3),
  blocked: taskAnalysis.blockedTasks
};

const selectedTask = await promptUser("What should we work on?", recommendations);
```

### Step 3: Task Execution with Team Coordination
```typescript
// Execute task with full workflow integration
await executeTaskWithTeamCoordination({
  taskId: selectedTask.id,
  tag: selectedTag,
  projectRoot,
  options: {
    useParallelAgents: true,    // Spawn multiple agents for efficiency
    enableLinearSync: true,     // Real-time Linear updates
    skipContext7: true,         // Tasks already enhanced
    enableTesting: true,        // Smart Playwright testing
    createCommits: true,        // Granular git commits
    teamUpdates: true          // Progress comments for team
  }
});
```

## Implementation Details

### Core Execution Function
```typescript
async function executeTaskWithTeamCoordination(config) {
  const { taskId, tag, projectRoot, options } = config;
  
  try {
    // 1. Start task with Linear sync (hook will handle this)
    console.log(`✅ Starting Task ${taskId}: ${task.title}`);
    console.log(`🔄 Updating Taskmaster: pending → in-progress`);
    
    await mcp__task_master_ai__set_task_status({
      projectRoot,
      id: taskId,
      status: 'in_progress'
    });
    
    // Hook will automatically:
    // - Update Linear status to "In Progress"
    // - Add team notification comment
    // - Set up progress tracking
    
    // 2. Create git branch for work
    const branchName = `${tag}-tasks-${taskId}`;
    console.log(`🔀 Created branch: ${branchName}`);
    await createGitBranch(branchName);
    
    // 3. Analyze subtasks for parallel execution
    const subtasks = task.subtasks || [];
    const executionPlan = analyzeSubtaskParallelization(subtasks);
    
    console.log(`🤖 Spawning agents for ${executionPlan.parallel.length} parallel subtasks...`);
    
    // 4. Execute subtasks with agents
    const results = await executeSubtasksWithAgents(executionPlan, {
      taskId,
      tag,
      projectRoot,
      enableProgressUpdates: options.teamUpdates
    });
    
    // 5. Run validation and testing
    console.log(`🧪 Running validation and testing...`);
    const validationResults = await runTaskValidation(results, {
      enableTesting: options.enableTesting,
      taskId,
      tag
    });
    
    // 6. Complete task with detailed summary
    await completeTaskWithDetails(taskId, {
      subtaskResults: results,
      validationResults,
      tag,
      projectRoot
    });
    
    // 7. Suggest next task
    await suggestNextTask(tag, projectRoot);
    
  } catch (error) {
    console.error(`❌ Task ${taskId} failed:`, error.message);
    console.log("💡 Task status remains in-progress for debugging");
    throw error;
  }
}
```

### Task Completion with Perfect Sync
```typescript
async function completeTaskWithDetails(taskId, config) {
  const { subtaskResults, validationResults, tag, projectRoot } = config;
  
  // Prepare comprehensive completion details
  const completionDetails = {
    subtasksCompleted: subtaskResults.length,
    linesAdded: subtaskResults.reduce((sum, r) => sum + r.linesAdded, 0),
    filesModified: subtaskResults.reduce((sum, r) => sum + r.filesModified, 0),
    testsStatus: validationResults.allTestsPassed ? 'pass' : 'fail',
    screenshotPaths: validationResults.screenshots || [],
    commits: await getRecentCommits(taskId),
    completedAt: new Date().toISOString(),
    tag
  };
  
  // CRITICAL: Add details to Taskmaster BEFORE marking done
  await mcp__task_master_ai__update_task({
    projectRoot,
    id: taskId,
    prompt: `Task completed with details: ${JSON.stringify(completionDetails)}`
  });
  
  // Now mark as done - hook will handle Linear sync
  await mcp__task_master_ai__set_task_status({
    projectRoot,
    id: taskId,
    status: 'done'
  });
  
  // Hook will automatically:
  // - Add completion details to Linear comment
  // - Update Linear status to "Done"
  // - Notify team of completion
}
```

## User Experience Flow

### What Users See
```bash
User: /work

Claude: Which tag should I work on?
🏷️  Available tags:
📌 [project-tag] (7 pending tasks)
📌 [other-tag] (3 pending tasks)

User: [project-tag]

Claude: [Project] project - what should we work on?

🎯 Recommended next:
   Task 2: [Task Title] (3 subtasks, ~45 min)
   
📋 Other options:
   Task 1: [Other Task] (5 subtasks, ~90 min)
   Task 4: [Another Task] (4 subtasks, ~60 min)

User: 2

Claude: ✅ Starting Task 2: [Task Title] (tag: [project-tag])
🔄 Updating Taskmaster: pending → in-progress
🔄 Updating Linear: Backlog → In Progress
📝 Added Linear comment: "🚀 Started by [user] - development in progress"

🔀 Created branch: [project-tag]-tasks-2
🤖 Spawning agents for 3 parallel subtasks...

[Live progress updates with Linear comments]
📝 Linear comment: "🔧 Development Progress: 12 changes, 4 files"

🧪 Running validation and testing...
✅ All tests pass
📸 UI screenshots captured

✅ Task 2 Complete!
📊 3 subtasks completed
📄 156 lines added
📁 4 files modified
🧪 Tests: pass
📸 Screenshots: 3 captured

Ready for next task?
```

## Error Handling

### Graceful Task Failure
```typescript
catch (error) {
  console.error(`❌ Task ${taskId} failed:`, error.message);
  console.log("💡 Task status remains in-progress for debugging");
  console.log("💡 Run `/status` to check current state");
}
```

## Success Metrics

### User Experience
- ✅ **2-step process** - Tag selection → Task execution
- ✅ **AI recommendations** - Intelligent task prioritization
- ✅ **Real-time feedback** - Live progress updates
- ✅ **Team coordination** - Automatic Linear updates

### Reliability
- ✅ **Hook-enforced sync** - Perfect Linear integration
- ✅ **Automatic validation** - Health checks built-in
- ✅ **Error recovery** - Resilient execution
- ✅ **Progress tracking** - Complete audit trail

This simplified `/work` command provides intuitive task execution while maintaining all the sophisticated workflow capabilities and adding enhanced team coordination through the hook system.