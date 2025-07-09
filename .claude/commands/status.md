---
name: status
description: Comprehensive project progress overview with health validation
category: simplified-workflow
---

# Project Status Overview (/status)

**Comprehensive project progress view with health validation, Linear sync status, and intelligent recommendations.**

## Purpose

Provide a complete project status overview with health checks, sync validation, and actionable recommendations through a clean, informative interface.

## Workflow Overview

1. **Tag Selection** - Choose project context for status review
2. **Comprehensive Analysis** - Progress, health, sync status, recommendations
3. **Actionable Insights** - Clear next steps and issue resolution

## Essential Requirements (Non-Negotiable)

- ✅ **Tag confirmation required** - Commands work independently
- ✅ **Linear sync validation** - Check 1:1 mapping including sub-issues
- ✅ **Health monitoring** - Detect and report issues
- ✅ **Actionable recommendations** - Clear next steps

## Command Implementation

### Step 1: Tag Selection (Required)
```typescript
// Always confirm tag for independent command usage
const availableTags = await mcp__task_master_ai__list_tags({ projectRoot });

// Show available tags with basic metrics
const tagOptions = availableTags.map(tag => ({
  label: `${tag.name} (${tag.totalTasks} tasks)`,
  value: tag.name
}));

const selectedTag = await promptUser("Which tag should I show status for?", tagOptions);
```

### Step 2: Comprehensive Status Analysis
```typescript
// Gather all status information
const statusData = await gatherComprehensiveStatus({
  tag: selectedTag,
  projectRoot,
  includeHealth: true,
  includeLinearSync: true,
  includeRecommendations: true
});

// Display formatted status
await displayProjectStatus(statusData);
```

## Implementation Details

### Core Status Gathering Function
```typescript
async function gatherComprehensiveStatus(config) {
  const { tag, projectRoot, includeHealth, includeLinearSync, includeRecommendations } = config;
  
  // 1. Get all tasks with subtasks
  const tasks = await mcp__task_master_ai__get_tasks({
    projectRoot,
    withSubtasks: true
  });
  
  // 2. Calculate progress metrics
  const progress = calculateProgressMetrics(tasks);
  
  // 3. Validate Linear sync status
  const linearStatus = includeLinearSync ? 
    await validateLinearSyncStatus(tasks, tag) : null;
  
  // 4. Check workflow health
  const healthStatus = includeHealth ? 
    await checkWorkflowHealth(tag, projectRoot) : null;
  
  // 5. Generate recommendations
  const recommendations = includeRecommendations ? 
    await generateRecommendations(tasks, linearStatus, healthStatus) : null;
  
  // 6. Get git status
  const gitStatus = await getGitStatus(projectRoot);
  
  return {
    tag,
    progress,
    linearStatus,
    healthStatus,
    recommendations,
    gitStatus,
    timestamp: new Date().toISOString()
  };
}
```

### Progress Metrics Calculation
```typescript
function calculateProgressMetrics(tasks) {
  const metrics = {
    total: tasks.length,
    completed: 0,
    inProgress: 0,
    pending: 0,
    blocked: 0,
    totalSubtasks: 0,
    completedSubtasks: 0,
    estimatedTimeRemaining: 0
  };
  
  tasks.forEach(task => {
    // Count task statuses
    switch (task.status) {
      case 'done':
        metrics.completed++;
        break;
      case 'in-progress':
        metrics.inProgress++;
        break;
      case 'blocked':
        metrics.blocked++;
        break;
      default:
        metrics.pending++;
    }
    
    // Count subtask statuses
    if (task.subtasks) {
      metrics.totalSubtasks += task.subtasks.length;
      task.subtasks.forEach(subtask => {
        if (subtask.status === 'done') {
          metrics.completedSubtasks++;
        }
      });
    }
    
    // Estimate remaining time
    if (task.status !== 'done') {
      metrics.estimatedTimeRemaining += (task.complexity || 5) * 15; // 15 min per complexity point
    }
  });
  
  metrics.completionPercentage = Math.round((metrics.completed / metrics.total) * 100);
  metrics.subtaskCompletionPercentage = metrics.totalSubtasks > 0 ? 
    Math.round((metrics.completedSubtasks / metrics.totalSubtasks) * 100) : 0;
  
  return metrics;
}
```

### Linear Sync Status Validation
```typescript
async function validateLinearSyncStatus(tasks, tag) {
  const syncStatus = {
    healthy: true,
    issues: [],
    tasksSynced: 0,
    subtasksSynced: 0,
    lastSyncTime: null,
    recommendations: []
  };
  
  for (const task of tasks) {
    // Check if task has Linear metadata
    const taskMetadata = await getLinearMetadata(task.id);
    
    if (!taskMetadata) {
      syncStatus.healthy = false;
      syncStatus.issues.push(`Task ${task.id} missing Linear mapping`);
    } else {
      syncStatus.tasksSynced++;
      
      // Validate Linear issue status matches Taskmaster
      const linearIssue = await getLinearIssue(taskMetadata.linearIssueId);
      if (linearIssue && linearIssue.status !== convertTaskmasterToLinearStatus(task.status)) {
        syncStatus.healthy = false;
        syncStatus.issues.push(`Task ${task.id} status mismatch: Taskmaster=${task.status}, Linear=${linearIssue.status}`);
      }
    }
    
    // Check subtasks
    if (task.subtasks) {
      for (const subtask of task.subtasks) {
        const subtaskMetadata = await getLinearMetadata(subtask.id, true);
        
        if (!subtaskMetadata) {
          syncStatus.healthy = false;
          syncStatus.issues.push(`Subtask ${task.id}.${subtask.id} missing Linear sub-issue`);
        } else {
          syncStatus.subtasksSynced++;
        }
      }
    }
  }
  
  // Generate recommendations
  if (syncStatus.issues.length > 0) {
    syncStatus.recommendations.push("Run `/sync-linear` to fix sync issues");
    syncStatus.recommendations.push("Run `/verify-mapping` for detailed analysis");
  }
  
  return syncStatus;
}
```

### Workflow Health Check
```typescript
async function checkWorkflowHealth(tag, projectRoot) {
  const healthStatus = {
    healthy: true,
    issues: [],
    warnings: [],
    recommendations: []
  };
  
  // Check git status
  const gitIssues = await checkGitHealth(projectRoot);
  if (gitIssues.length > 0) {
    healthStatus.warnings.push(...gitIssues);
  }
  
  // Check for hook functionality
  const hookStatus = await checkHookHealth();
  if (!hookStatus.healthy) {
    healthStatus.healthy = false;
    healthStatus.issues.push("Hook system not functioning properly");
    healthStatus.recommendations.push("Check hook configuration and permissions");
  }
  
  // Check for batch progress files
  const batchStatus = await checkBatchProgressHealth();
  if (batchStatus.staleBatches > 0) {
    healthStatus.warnings.push(`${batchStatus.staleBatches} stale progress batches found`);
    healthStatus.recommendations.push("Stale batches will be cleaned up automatically");
  }
  
  // Check MCP connectivity
  const mcpStatus = await checkMCPConnectivity();
  if (!mcpStatus.taskmaster || !mcpStatus.linear) {
    healthStatus.healthy = false;
    healthStatus.issues.push("MCP connectivity issues detected");
    healthStatus.recommendations.push("Restart Claude Code to refresh MCP connections");
  }
  
  return healthStatus;
}
```

### Intelligent Recommendations
```typescript
async function generateRecommendations(tasks, linearStatus, healthStatus) {
  const recommendations = [];
  
  // Task-based recommendations
  const pendingTasks = tasks.filter(t => t.status === 'pending');
  const inProgressTasks = tasks.filter(t => t.status === 'in-progress');
  const blockedTasks = tasks.filter(t => t.status === 'blocked');
  
  if (inProgressTasks.length === 0 && pendingTasks.length > 0) {
    recommendations.push({
      type: 'action',
      priority: 'high',
      message: 'No tasks in progress - ready to start work',
      command: '/work',
      description: 'Start working on the next recommended task'
    });
  }
  
  if (inProgressTasks.length > 1) {
    recommendations.push({
      type: 'warning',
      priority: 'medium',
      message: `${inProgressTasks.length} tasks in progress - consider focusing on one`,
      command: '/work',
      description: 'Focus on completing current tasks before starting new ones'
    });
  }
  
  if (blockedTasks.length > 0) {
    recommendations.push({
      type: 'attention',
      priority: 'medium',
      message: `${blockedTasks.length} tasks blocked - review dependencies`,
      command: '/verify-mapping',
      description: 'Check task dependencies and resolve blockers'
    });
  }
  
  // Linear sync recommendations
  if (linearStatus && !linearStatus.healthy) {
    recommendations.push({
      type: 'error',
      priority: 'high',
      message: 'Linear sync issues detected',
      command: '/sync-linear',
      description: 'Fix Linear synchronization problems'
    });
  }
  
  // Health-based recommendations
  if (healthStatus && !healthStatus.healthy) {
    recommendations.push({
      type: 'error',
      priority: 'high',
      message: 'Workflow health issues detected',
      command: '/status',
      description: 'Run detailed health diagnostics'
    });
  }
  
  return recommendations;
}
```

### Status Display Function
```typescript
async function displayProjectStatus(statusData) {
  const { tag, progress, linearStatus, healthStatus, recommendations, gitStatus } = statusData;
  
  // Header
  console.log(`📊 ${tag.toUpperCase()} Project Status`);
  console.log('');
  
  // Progress overview
  console.log(`🎯 Progress: ${progress.completed}/${progress.total} tasks complete (${progress.completionPercentage}%)`);
  console.log(`⏱️  Estimated remaining: ~${Math.ceil(progress.estimatedTimeRemaining / 60)} hours`);
  console.log('');
  
  // Recent activity
  const recentlyCompleted = getRecentlyCompletedTasks(tasks, 3);
  if (recentlyCompleted.length > 0) {
    console.log('✅ Recently completed:');
    recentlyCompleted.forEach(task => {
      const linearRef = getLinearReference(task.id);
      console.log(`   ${task.title} → ${linearRef} ✅`);
    });
    console.log('');
  }
  
  // Current work
  const currentWork = getInProgressTasks(tasks);
  if (currentWork.length > 0) {
    console.log('🔄 Currently working:');
    currentWork.forEach(task => {
      const subtaskProgress = getSubtaskProgress(task);
      const linearRef = getLinearReference(task.id);
      console.log(`   ${task.title} (${subtaskProgress}) → ${linearRef}`);
    });
    console.log('');
  }
  
  // Next up
  const nextTasks = getNextRecommendedTasks(tasks, 2);
  if (nextTasks.length > 0) {
    console.log('📋 Up next:');
    nextTasks.forEach(task => {
      const status = getTaskReadinessStatus(task);
      console.log(`   ${task.title} (${status})`);
    });
    console.log('');
  }
  
  // Linear sync status
  if (linearStatus) {
    const syncIcon = linearStatus.healthy ? '✅' : '❌';
    console.log(`🔗 Linear: ${syncIcon} ${linearStatus.tasksSynced} tasks synced | Last sync: ${formatLastSync(linearStatus.lastSyncTime)}`);
  }
  
  // Git status
  if (gitStatus) {
    console.log(`🌿 Git: ${gitStatus.branch} | ${gitStatus.ahead} commits ahead of main`);
  }
  
  console.log('');
  
  // Health status
  if (healthStatus) {
    if (healthStatus.healthy) {
      console.log('🟢 Everything looks healthy! Run `/work` to continue.');
    } else {
      console.log('🔴 Issues detected - see recommendations below.');
    }
  }
  
  // Recommendations
  if (recommendations && recommendations.length > 0) {
    console.log('');
    console.log('💡 Recommendations:');
    recommendations.forEach(rec => {
      const icon = getRecommendationIcon(rec.type);
      console.log(`   ${icon} ${rec.message}`);
      console.log(`      → Run: ${rec.command}`);
    });
  }
}
```

## User Experience Flow

### What Users See
```bash
User: /status

Claude: Which tag should I show status for?
🏷️  Available tags:
📌 [project-tag] (12 tasks)
📌 [other-tag] (8 tasks)
📌 [another-tag] (5 tasks)

User: [project-tag]

Claude: 📊 PROJECT-TAG Project Status

🎯 Progress: 7/12 tasks complete (58%)
⏱️  Estimated remaining: ~4 hours

✅ Recently completed:
   Task 2: SSR-Safe Architecture → PROJECT-348 ✅
   Task 5: Auto-Save System → PROJECT-351 ✅

🔄 Currently working:
   Task 1: Component Implementation (2/5 subtasks) → PROJECT-347

📋 Up next:
   Task 4: State Management (ready to start)
   Task 7: Interface Polish (blocked on Task 1)

🔗 Linear: ✅ 12 tasks synced | Last sync: 2 min ago
🌿 Git: [project-tag]-tasks-1 | 12 commits ahead of main

🟢 Everything looks healthy! Run `/work` to continue.
```

### With Issues Present
```bash
📊 PROJECT-TAG Project Status

🎯 Progress: 7/12 tasks complete (58%)
⏱️  Estimated remaining: ~4 hours

🔄 Currently working:
   Task 1: Component Implementation (2/5 subtasks) → PROJECT-347

🔗 Linear: ❌ 11/12 tasks synced | Last sync: 15 min ago
🌿 Git: [project-tag]-tasks-1 | 12 commits ahead of main

🔴 Issues detected - see recommendations below.

💡 Recommendations:
   ❌ Linear sync issues detected
      → Run: /sync-linear
   ⚠️  1 task blocked - review dependencies
      → Run: /verify-mapping
   📋 No tasks in progress - ready to start work
      → Run: /work
```

## Error Handling

### Graceful Degradation
```typescript
catch (error) {
  console.error("❌ Status check failed:", error.message);
  console.log("💡 Try checking project configuration");
  console.log("💡 Basic task information still available");
}
```

## Success Metrics

### User Experience
- ✅ **At-a-glance overview** - Complete project status in seconds
- ✅ **Actionable insights** - Clear next steps and commands
- ✅ **Health awareness** - Proactive issue detection
- ✅ **Team coordination** - Real Linear sync status

### Reliability
- ✅ **Hook-validated data** - Always current status
- ✅ **Comprehensive checks** - All systems validated
- ✅ **Intelligent recommendations** - AI-driven suggestions
- ✅ **Error recovery** - Clear path to resolution

This simplified `/status` command provides comprehensive project oversight while maintaining all sophisticated monitoring capabilities and integrating seamlessly with the hook system for real-time accuracy.