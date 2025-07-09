---
name: start
description: Streamlined project initialization - PRD to Linear workflow in 3 steps
category: simplified-workflow
---

# Project Initialization (/start)

**Simplified workflow initialization that maintains all sophisticated functionality while providing a clean user experience.**

## Purpose

Transform a PRD document into a complete working Linear project with enhanced tasks, Context7 documentation, and perfect 1:1 mapping - all through a streamlined 3-step process.

## Workflow Overview

1. **Tag Selection** - Choose existing or create new project tag
2. **PRD Selection** - Smart detection with manual override
3. **Full Setup** - Complete workflow with progress indicators

## Essential Requirements (Non-Negotiable)

- ✅ **Tag confirmation required** - User must explicitly choose tag
- ✅ **Linear sub-issues created** - ALL subtasks become Linear sub-issues (1:1 mapping)
- ✅ **Context7 enhancement** - Official documentation integrated
- ✅ **Research expansion** - Perplexity research for strategic guidance
- ✅ **Interactive gates** - Streamlined but present for user control

## Command Implementation

### Step 1: Tag Selection (Required)
```typescript
// Always confirm tag - non-negotiable requirement
const availableTags = await mcp__task_master_ai__list_tags({ projectRoot });

// Present options with current tag highlighted
const tagOptions = [
  { label: `${currentTag} (current active)`, value: currentTag },
  { label: 'Create new tag', value: 'new' },
  ...otherTags.map(tag => ({ label: tag.name, value: tag.name }))
];

const selectedTag = await promptUser("Which tag should I use?", tagOptions);
```

### Step 2: PRD Discovery (Smart Detection)
```typescript
// Smart PRD detection based on tag
const prdOptions = [
  `${selectedTag}prd.txt`, // Tag-specific PRD (primary)
  'prd.txt',               // Fallback PRD
  'Other (specify path)'   // Manual override
];

const prdFile = await promptUser("Which PRD file should I use?", prdOptions);
```

### Step 3: Full Setup Execution
```typescript
// Execute complete workflow with progress indicators
await executeProjectSetup({
  tag: selectedTag,
  prdFile: prdFile,
  projectRoot: process.cwd(),
  options: {
    research: true,           // Enable Perplexity research
    context7: true,           // Enable Context7 documentation
    linearSync: true,         // Enable Linear integration
    createSubIssues: true,    // Create sub-issues for ALL subtasks
    showProgress: true        // Show progress indicators
  }
});
```

## Implementation Details

### Core Execution Function
```typescript
async function executeProjectSetup(config) {
  const { tag, prdFile, projectRoot, options } = config;
  
  // Initialize progress tracking
  console.log("✅ Starting project setup...");
  console.log("🔄 This takes ~3 minutes with full enhancement...");
  
  try {
    // 1. Parse PRD and create initial tasks
    console.log("📄 Parsing PRD and creating tasks...");
    const parseResult = await mcp__task_master_ai__parse_prd({
      projectRoot,
      input: `.taskmaster/docs/${prdFile}`,
      research: options.research,
      append: false
    });
    
    // 2. Expand all tasks with research
    if (options.research) {
      console.log("🔍 Expanding tasks with Perplexity research...");
      await mcp__task_master_ai__expand_all({
        projectRoot,
        research: true
      });
    }
    
    // 3. Enhance with Context7 documentation
    if (options.context7) {
      console.log("📚 Enhancing tasks with Context7 documentation...");
      await mcp__task_master_ai__enhance_docs({
        projectRoot
      });
    }
    
    // 4. Create Linear integration
    if (options.linearSync) {
      console.log("🔗 Creating Linear project integration...");
      await createLinearIntegration(tag, projectRoot);
    }
    
    // 5. Get final task summary
    const tasks = await mcp__task_master_ai__get_tasks({
      projectRoot,
      withSubtasks: true
    });
    
    // 6. Success summary
    const taskCount = tasks.length;
    const subtaskCount = tasks.reduce((sum, task) => sum + (task.subtasks?.length || 0), 0);
    
    console.log("✅ Project setup complete!");
    console.log(`📋 Created ${taskCount} tasks with ${subtaskCount} subtasks`);
    console.log(`🎯 Linear project: ${getLinearProjectName(tag)}`);
    console.log(`   - ${taskCount} main issues created`);
    console.log(`   - ${subtaskCount} sub-issues created within parent issues`);
    console.log("👥 Linear will notify team automatically");
    console.log("");
    console.log("Ready to work? Run `/work` to start development.");
    
  } catch (error) {
    console.error("❌ Setup failed:", error.message);
    console.log("💡 Try running `/sync-linear` for detailed diagnostics");
    throw error;
  }
}
```

### Linear Integration Function
```typescript
async function createLinearIntegration(tag, projectRoot) {
  // Use existing sophisticated Linear integration
  await mcp__task_master_ai__sync_linear({
    projectRoot,
    tag
  });
  
  // Ensure ALL subtasks become Linear sub-issues
  const tasks = await mcp__task_master_ai__get_tasks({
    projectRoot,
    withSubtasks: true
  });
  
  for (const task of tasks) {
    if (task.subtasks?.length > 0) {
      await createLinearSubIssues(task, tag);
    }
  }
}
```

## Simplified User Experience

### What Users See
```bash
User: /start

Claude: Which tag should I use?
🏷️  Available tags:
📌 [current-tag] (current active)
📌 [other-tag]
📌 Create new tag

User: [current-tag]

Claude: Which PRD file should I use?
📄 [tag-name]prd.txt (detected from tag)
📄 prd.txt (fallback)
📄 Other (specify path)

User: [tag-name]prd.txt

Claude: ✅ Starting project setup...
🔄 This takes ~3 minutes with full enhancement...
📄 Parsing PRD and creating tasks...
🔍 Expanding tasks with Perplexity research...
📚 Enhancing tasks with Context7 documentation...
🔗 Creating Linear project integration...

✅ Project setup complete!
📋 Created [N] tasks with [N] subtasks
🎯 Linear project: [Project Name]
   - [N] main issues created
   - [N] sub-issues created within parent issues
👥 Linear will notify team automatically

Ready to work? Run `/work` to start development.
```

## Error Handling and Recovery

### Graceful Degradation
```typescript
// If simplified setup fails, recommend alternatives
catch (error) {
  console.error("❌ Setup failed:", error.message);
  console.log("💡 Try running `/sync-linear` for detailed diagnostics");
  console.log("💡 Or run `/status` to check current state");
}
```

## Success Metrics

### User Experience
- ✅ **3-step process** instead of 6+ gates
- ✅ **Clear progress indicators** with time estimates
- ✅ **Smart defaults** with manual override options
- ✅ **Preserved functionality** - nothing lost

### Reliability
- ✅ **Hook-enforced sync** - Linear updates automatic
- ✅ **Validation integration** - Health checks built-in
- ✅ **Error recovery** - Automatic retry mechanisms
- ✅ **Team coordination** - Real-time updates

This simplified `/start` command provides an intuitive interface while preserving all the sophisticated workflow capabilities that make the current system powerful.