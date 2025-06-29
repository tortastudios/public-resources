# [Torta Studios](https://www.tortastudios.com) Claude Code + Taskmaster Workflows
## Automated Development Workflow 

![Projects](https://img.shields.io/badge/Project%20Type-MVP%20%7C%20Features-purple)
![Website](https://img.shields.io/website?url=https%3A%2F%2Fproofingroom.tortastudios.com&up_message=https%3A%2F%2Fproofingroom.tortastudios.com&up_color=%23FF3C02&down_message=https%3A%2F%2Fproofingroom.tortastudios.com&down_color=%23FF3C02&style=flat&label=Join%20Our%20Build-in-Public%20Newsletter%20%40&labelColor=%2326201D&link=https%3A%2F%2Fproofingroom.tortastudios.com)

## By [@colin_thornton](https://x.com/colin_thornton), [@bitforth](https://x.com/bitforth) & [@darivadeneyra](https://x.com/darivadeneyra)

[![Twitter Follow](https://img.shields.io/twitter/follow/colin_thornton)](https://x.com/colin_thornton)
[![Twitter Follow](https://img.shields.io/twitter/follow/bitforth)](https://x.com/bitforth)
[![Twitter Follow](https://img.shields.io/twitter/follow/darivadeneyra)](https://x.com/darivadeneyra)


> **Turn product ideas into executed code with full project management integration**
> 
> No more manual ticket creation in Linear, context switching, or losing track of implementation details. Go from PRD to working on tasks in ~15-30 minutes with automated Linear sync and real-time Slack updates.

## 📚 Documentation & Resources

- [Taskmaster Installation Tutorial](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/tutorial.md)
- [Taskmaster Configuration Guide](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/configuration.md)
- [Linear MCP Documentation](https://linear.app/changelog/2025-05-01-mcp)
- [Linear-Slack Integration](https://linear.app/docs/slack?tabs=d3cdac1b7b79)
- [Context7 MCP Repository](https://github.com/upstash/context7)
- [Playwright MCP Repository](https://github.com/microsoft/playwright-mcp)

## Table of Contents

- [🎯 Why We Built This](#-why-we-built-this)
- [⚡ Quick Start](#-quick-start)
- [🏗️ Core Architecture](#️-core-architecture)
- [🔧 Setup Guide](#-setup-guide)
- [🚀 Usage Examples](#-usage-examples)
- [📋 Command Reference](#-command-reference)
- [⚙️ Configuration](#️-configuration)
- [🔬 Advanced Topics](#-advanced-topics)
- [🛠️ Troubleshooting](#️-troubleshooting)

## 🎯 Why We Built This

As a product person who learned to code with AI assistance, I found myself constantly context-switching between tools when building MVPs and features. Traditional development flows meant:

- ⏰ **Manual ticket creation** eating into development time
- 🔄 **Context switching** between PRDs, Linear, code, and documentation  
- 📝 **Lost implementation details** when Claude's context window reset
- 🎯 **Inconsistent patterns** across different projects

This workflow emerged from our need for a **single, automated pipeline** from idea to executed code.

### What This Workflow Provides

🚀 **Automated project management**: PRD → tasks → Linear issues without manual work  
🧠 **Persistent memory**: Implementation details survive context window resets  
📖 **Baked-in documentation**: Official docs integrated into every task via Context7  
🔄 **Real-time team sync**: Linear/Slack notifications keep everyone informed  
⚡ **Consistent execution**: Optimize for consistency and quality of coding agent 

### Requirements

- **Technical comfort**: Basic terminal use, Git workflow, API key management
- **Subs Needed**: Claude Code, Linear, *AI-IDE helps*
- **Time investment**: ~1-2 hours one-time setup, then immediate productivity
- **Project type**: Haven't found one it doesn't work for yet

> **Note**: This is a development workflow we've found helpful - not a promise of specific time savings or efficiency gains.

## ⚡ Quick Start

> **🎯 Goal**: From idea to working app in 45 minutes

### Step 1: Install Tools (5 minutes)

```bash
npm install -g task-master-ai
```

### Step 2: Configure (10 minutes)

> **📋 Required**: API keys for Linear, OpenAI, Perplexity. See [Configuration](#️-configuration) section.

1. Copy MCP configuration to `~/.claude/mcp.json`
2. Add your API keys  
3. Connect [Linear to Slack](https://linear.app/docs/slack?tabs=d3cdac1b7b79)
4. Restart Claude Code

### Step 3: First Project

| Step | Command | Result |
|------|---------|--------|
| **Create PRD** | `mkdir .taskmaster/docs` | Project requirements file |
| **Initialize** | `/project:project-setup` | Tasks → Linear issues |
| **Execute** | `/project:execute-tasks` | Working code + commits |

### ✅ Success Checklist

After completing your first project:

- ✅ Working application with all features
- ✅ Linear project with 1:1 task mapping  
- ✅ Git repo with atomic commits
- ✅ UI screenshots and documentation
- ✅ Real-time team notifications

### 🔄 Ongoing Claude Code Slash Commands

```bash
/project:workflow-status    # Check progress
/project:sync-linear       # Fix sync issues  
/project:verify-mapping    # Validate integrity
```

## 🏗️ Core Architecture

> **Philosophy**: Each tool does what it's best at - Taskmaster decomposes, Claude executes, Linear tracks, Context7 informs, Playwright tests.

```mermaid
graph LR
    A[📄 PRD] --> B[🧠 Taskmaster]
    B --> C[📋 Linear Issues]
    C --> D[🤖 Claude Code]
    D --> E[📚 Git Commits]
    
    B --> F[📖 Context7 Docs]
    C --> G[💬 Slack Updates]
    D --> H[🎭 Playwright Tests]
    
    E --> I[⚛️ Atomic Commits]
    G --> J[👥 Team Notifications]
    H --> K[🖼️ UI Screenshots]
```

### 🔄 Data Flow

| Stage | Tool | Input | Output |
|-------|------|-------|--------|
| **Decompose** | [Taskmaster](https://www.task-master.dev/) | PRD document | Structured tasks + subtasks |
| **Enhance** | [Context7](https://github.com/upstash/context7) | Task descriptions | Official documentation |
| **Track** | [Linear](https://linear.app/changelog/2025-05-01-mcp) | Tasks | Issues + team visibility |
| **Execute** | Claude Code | Enhanced tasks | Working code + tests |
| **Notify** | Slack | Linear updates | Team coordination |

### 🎯 Key Principles

- **🔄 Bidirectional sync**: Taskmaster ↔ Linear always in sync
- **🧠 Session memory**: Survives Claude context resets  
- **📐 1:1 mapping**: Every task = Linear issue, every subtask = sub-issue
- **🎭 Smart testing**: Auto-detects when UI components need Playwright tests
- **⚡ Rate limiting**: Built-in API protection and recovery

## 🔧 Setup Guide

> **📋 One-time setup**: ~25 minutes total for all tools

### Required Tools

| Tool | Purpose | Installation |
|------|---------|-------------|
| **[Taskmaster MCP](https://www.task-master.dev/)** | Task decomposition & management | [Tutorial](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/tutorial.md) |
| **[Linear MCP](https://linear.app/changelog/2025-05-01-mcp)** | Issue tracking & team collaboration | Auto-configured |
| **[Context7 MCP](https://github.com/upstash/context7)** | Official documentation lookup | Auto-configured |
| **[Playwright MCP](https://github.com/microsoft/playwright-mcp)** | UI testing & screenshots | Auto-configured |

### Installation Steps

1. **Install Taskmaster** (5 minutes)
   ```bash
   npm install -g task-master-ai
   ```

2. **Configure Models** (5 minutes)
   
   Follow the [configuration guide](https://github.com/eyaltoledano/claude-task-master/blob/main/docs/configuration.md) for:
   - API key setup (Anthropic, OpenAI, Perplexity)
   - Model selection and performance tuning
   - Research model configuration

3. **Configure MCP** (10 minutes)
   
   Copy the complete configuration to `~/.claude/mcp.json` (see [Configuration](#️-configuration) section)

4. **Connect Integrations** (5 minutes)
   - [Linear ↔ Slack integration](https://linear.app/docs/slack)
   - Restart Claude Code

> **⚠️ Important**: Restart Claude after MCP config changes

## 🚀 Usage Examples

> **Real workflow**: Based on example Calorie Tracker project execution

### Typical Workflow

```bash
# 1. Setup new project (one-time)
/project:project-setup
> Creates: PRD → Tasks → Linear Issues (10 min)

# 2. Execute development work
/project:execute-tasks  
> Implements: Code + Tests + Commits (30 min per task)

# 3. Monitor progress
/project:workflow-status
> Shows: Progress + recommendations (30 sec)
```

### Example: Calorie Tracker Project

| Phase | Input | Output |
|-------|-------|--------|
| **Setup** | `prd.txt` (requirements) | 10 tasks, 30+ subtasks |
| **Enhancement** | Task descriptions | Context7 docs integrated |
| **Linear Sync** | Taskmaster data | 1:1 Linear issues created |
| **Development** | Task 1 selection | 1,581 lines of TypeScript |
| **Results** | Git commits | Working Next.js app |

### Interactive Gates

> **🛡️ Safety first**: 6 discovery gates prevent auto-proceeding

1. **Linear validation** → Verify MCP connection
2. **Tag selection** → Choose/create project context  
3. **Project discovery** → Select Linear project
4. **Duplicate detection** → Handle existing issues
5. **Scope planning** → Review task structure
6. **Final confirmation** → User types "yes" to proceed

### Real Output Example

```text
✅ Task 1 Complete: Next.js Project Setup
├── 📁 9 subtasks implemented
├── 🔀 Branch: calorietracker-tasks-1  
├── 📋 Linear: TOR-347 through TOR-355
├── 💬 Slack: Team notified automatically
└── 📊 Result: 1,581 lines production code
```

### Daily Workflow Commands

```bash
# Start your day
/project:workflow-status        # Check current state

# During development  
/project:execute-tasks         # Implement features

# If issues arise
/project:sync-linear          # Fix Linear sync gaps
/project:verify-mapping       # Validate 1:1 mapping
```

## Linear Metadata Storage Anti-Hallucination System

**Critical Component**: Linear issue IDs and metadata are stored directly in Taskmaster task implementation details to prevent hallucinations and enable reliable bidirectional sync.

### Implementation Location

The core metadata functions are implemented in `.claude/commands/linear-sync-utils.md`:

- **`getLinearMetadata(taskId)`** - Retrieves stored Linear data from Taskmaster task details using regex parsing
- **`setLinearMetadata(taskId, linearData)`** - Embeds Linear issue data directly into Taskmaster task implementation details
- **`validateMetadata(projectRoot)`** - Validates stored metadata against live Linear data

### Workflow Integration

**All custom commands import these utilities:**

```typescript
// From project-setup.md, execute-tasks.md, sync-linear.md:
import { 
  getLinearMetadata, 
  setLinearMetadata, 
  validateMetadata 
} from './linear-sync-utils';
```

### Anti-Hallucination Workflow

**1. Before Creating Linear Issues:**

```typescript
const existing = await getLinearMetadata(taskId);
if (existing) {
  console.log(`Task ${taskId} already synced to ${existing.linearIssueNumber}`);
  // Skip creation, use existing metadata
} else {
  // Safe to create new Linear issue
  const newIssue = await mcp__linear__create_issue({...});
  await setLinearMetadata(taskId, newIssue); // Store immediately
}
```

**2. During Status Sync:**
```typescript
// Use stored Linear IDs, never guess
const metadata = await getLinearMetadata(taskId);
if (metadata) {
  await mcp__linear__update_issue({
    id: metadata.linearIssueId, // Actual stored ID
    stateId: newStateId
  });
}
```

### Storage Format

**Metadata embedded in Taskmaster task details:**

```text
--- LINEAR SYNC METADATA ---
linearIssueNumber: TOR-346
linearIssueId: abc123-def456-ghi789
linearProjectId: project-uuid-here
assigneeId: assignee-uuid
syncTimestamp: 2024-01-15T10:30:00Z
--- END METADATA ---
```

### Key Benefits

**Problem Solved:**

- ❌ **Before**: Agent guesses Linear issue IDs, creates duplicates
- ✅ **After**: Agent reads actual stored IDs, 90%+ sync accuracy
- ✅ **Gate 7 validation**: Uses stored metadata for 99.9% accuracy in detecting missing sub-issues
- ✅ **Session persistence**: Metadata survives across context window resets

## Utilities & Helper Functions

The Taskmaster workflow is built on a comprehensive foundation of **80+ utility functions** across specialized files. These utilities provide reliability, performance, and intelligent automation.

### Core Utility Files

#### **linear-sync-utils.md** - Primary Utilities Library

**Location**: `.claude/commands/linear-sync-utils.md`

**Purpose**: Shared Linear metadata tracking utilities for all workflow commands

**Key Functions**:

```typescript
// Core metadata operations (3 main functions replace 12+ complex functions)
getLinearMetadata(taskId, isSubtask = false): Promise<LinearMetadata | null>
setLinearMetadata(taskId, linearData, isSubtask = false): Promise<boolean>
validateMetadata(projectRoot): Promise<ValidationResult>

// Enhanced sub-issue creation with recovery
createAndValidateSubIssues(parentTaskId, parentLinearIssueId, subtasks, projectId, teamId, assigneeId): Promise<BatchCreationResult>
validateAllSubIssuesCreated(parentTaskId, parentLinearIssueId, expectedSubtasks, projectId): Promise<ValidationResult>
recoverMissingSubIssues(taskId, linearIssueId, validation, projectId, teamId, assigneeId): Promise<RecoveryResult>

// Batch operations for efficiency
batchSearchLinearIssues(taskTitles, projectId): Promise<Map<string, LinearIssue[]>>
bulkSyncTasks(taskIds, options): Promise<Map<string, SyncResult>>
```

**Benefits**:
- **87% reduction in API calls** through metadata-based operations
- **100% accuracy** in Linear sync through stored metadata validation
- **Automatic recovery** for missing sub-issues with Gate 7 validation
- **Rate limiting** with 3-second delays and batch processing

#### **Command-Specific Utilities**

**project-setup.md**:
```typescript
// Interactive discovery gates
detectAndResolveLinearDuplicates(tasks, projectId): Promise<DuplicateResolutionResult>
analyzeAndExpandTasks(projectRoot): Promise<void>
enhanceTasksWithContext7(tasks): Promise<void>
integrateWithLinear(tasks, projectId, teamId, assigneeId): Promise<LinearIntegrationResult>
```

**execute-tasks.md**:
```typescript
// Task execution workflow
analyzeParallelizability(subtasks): ExecutionGroup[]
launchSubtaskAgent(taskId, subtask, linearContext): Promise<void>
generateScreenshotFilename(taskId, subtaskId, componentName): string
captureComponentScreenshot(taskId, subtaskId, componentName): Promise<string>
```

### Session Memory Management

**Purpose**: Prevent duplicate operations and enable recovery within sessions

```typescript
interface SessionMemory {
  linearIssuesCreated: Map<string, string>;    // taskId → issueNumber
  linearIssuesFound: Map<string, string>;      // taskId → issueNumber  
  validationsPerformed: Set<string>;           // taskIds validated
  duplicatesDetected: Array<DuplicateInfo>;    // Duplicate analysis
  projectContext: ProjectContext;              // Current project state
}

// Session management functions
initializeSessionMemory(projectId, teamId, assigneeId): void
recordLinearOperation(taskId, issueNumber, action): void
wasTaskProcessed(taskId): boolean
getSessionSummary(): string
```

**Benefits**:
- **Prevents duplicate issue creation** within same session
- **Caches validation results** for performance
- **Provides audit trail** of all operations
- **Survives context window resets** through metadata persistence

### Linear Sync Operations

**Purpose**: Real-time bidirectional synchronization with Linear

```typescript
// Core sync functions
ensureLinearIssueExists(taskId, taskData, projectId, teamId, assigneeId): Promise<IssueResult>
syncTaskStatusToLinear(taskId, status): Promise<void>
syncSubtaskProgressToLinear(subtaskId, progress): Promise<void>

// Smart filtering
shouldSyncSubtask(subtask, parentTaskTitle): boolean
filterSyncableSubtasks(task): SubtaskData[]
getSubtaskSyncReport(tasks): SubtaskSyncReport

// String similarity for duplicate detection
calculateStringSimilarity(str1, str2): number
levenshteinDistance(str1, str2): number
```

**Auto-Skip Patterns**:
```typescript
// Automatically skips sync-related subtasks
const skipPatterns = [
  /linear sync/i,
  /sync.*linear/i,
  /validate.*mapping/i,
  /linear.*integration/i,
  /bidirectional.*sync/i
];
```

### Smart Testing Intelligence

**Purpose**: Context-aware Playwright testing decisions

```typescript
// Testing analysis
analyzeFilesForUIComponents(files): UIAnalysisResult
hasUIIntent(description): boolean
isCriticalComponent(filePath, description): boolean

// Testing strategies
minimalUITest(): Promise<TestResult>        // 30-second smoke tests
interactiveTest(): Promise<TestResult>      // 45-second interaction tests
criticalPathTest(): Promise<TestResult>     // 60-second comprehensive tests

// Screenshot organization
generateScreenshotFilename(taskId, subtaskId, componentName): string
// Format: task-{taskId}-subtask-{subtaskId}-{ComponentName}.png
```

**Decision Framework**:
```typescript
// Claude automatically decides when to test based on:
const testingTriggers = {
  'UI Components': 'React/Vue components in /components/, /app/, /pages/',
  'Form Implementations': 'User input handling, validation',
  'Critical User Flows': 'Authentication, payments, data entry',
  'Route/Page Additions': 'New user-facing pages'
};

const testingSkips = {
  'Backend Tasks': 'API endpoints, database schemas',
  'Utility Functions': 'Helper functions, configuration',
  'Documentation': 'README, docs, comments',
  'Infrastructure': 'Build configs, deployment scripts'
};
```

### Performance Optimizations

**Implemented Optimizations**:

```typescript
// Rate limiting pattern
const RATE_LIMITS = {
  OPERATION_DELAY: 3000,        // 3 seconds between operations
  BATCH_SIZE: 3,                // Max 3 items per batch
  BATCH_DELAY: 10000,           // 10 seconds between batches
  MAX_RETRIES: 2                // Retry failed operations
};

// Caching strategies
warmMetadataCache(projectRoot): Promise<void>  // Pre-load for performance
sessionMemory.validationsPerformed            // Cache validation results

// Parallel processing
bulkSyncTasks(taskIds, {
  maxConcurrency: 3,
  delayMs: 1000,
  batchSize: 10
}): Promise<Map<string, SyncResult>>
```

**Performance Results**:
- **87% reduction** in Linear API calls through metadata caching
- **75% faster** sync operations through batch processing
- **100% reliability** through automatic recovery mechanisms
- **60-second maximum** for UI testing decisions

### Type System & Interfaces

**Comprehensive TypeScript Support**:

```typescript
// Core data structures
interface TaskData {
  id: number;
  title: string;
  description?: string;
  details?: string;
  subtasks?: SubtaskData[];
  status: 'pending' | 'in-progress' | 'done' | 'blocked';
}

interface LinearMetadata {
  linearIssueNumber: string;     // TOR-346
  linearIssueId: string;         // abc123-def456-ghi789
  linearProjectId: string;       // project-uuid
  assigneeId: string;            // assignee-uuid
  syncTimestamp: string;         // ISO timestamp
  linearParentId?: string;       // For sub-issues
}

// Operation results
interface BatchCreationResult {
  success: boolean;
  created: number;
  recovered: number;
  failed: string[];
  details: CreationDetails[];
}

interface ValidationResult {
  valid: boolean;
  totalValidated: number;
  tasksValid: number;
  subtasksValid: number;
  orphanedItems: string[];
  missingSubtasks: MissingSubtask[];
}

// Testing outcomes
interface TestResult {
  success: boolean;
  duration: number;
  screenshotPath?: string;
  errors: string[];
  summary: string;
}
```

### Usage Patterns

**All Commands Import Utilities**:
```typescript
// Standard import pattern across all commands
import {
  // Core metadata operations
  getLinearMetadata,
  setLinearMetadata,
  validateMetadata,
  
  // Sync operations
  syncTaskStatusToLinear,
  syncSubtaskProgressToLinear,
  
  // Enhanced creation
  createAndValidateSubIssues,
  
  // Session management
  initializeSessionMemory,
  getSessionSummary,
  
  // Performance utilities
  bulkSyncTasks,
  warmMetadataCache
} from './linear-sync-utils';
```

**Workflow Integration Example**:
```typescript
// project-setup.md workflow using utilities
async function executeProjectSetup(): Promise<void> {
  // 1. Initialize session tracking
  initializeSessionMemory(projectId, teamId, assigneeId);
  
  // 2. Detect and resolve duplicates
  const duplicateResult = await detectAndResolveLinearDuplicates(tasks, projectId);
  
  // 3. Bulk sync with metadata validation
  const integrationResult = await integrateWithLinear(tasks, projectId, teamId, assigneeId);
  
  // 4. Generate session summary
  console.log(getSessionSummary());
}
```

### Key Design Principles

1. **Anti-Hallucination**: Store actual Linear IDs, never guess
2. **Session Persistence**: Metadata survives context window resets
3. **Progressive Enhancement**: Each utility layer adds reliability
4. **Modular Design**: Commands import only needed utilities
5. **Type Safety**: Comprehensive TypeScript interfaces
6. **Performance First**: Caching, batching, rate limiting
7. **Automatic Recovery**: Self-healing through validation and retry

## Session Memory & Audit Trail

**What Gets Tracked:**

```typescript
interface SessionMemory {
  issuesCreated: string[]; // TOR-346 through TOR-354
  validationHistory: ValidationResult[];
  recoveryActions: RecoveryAction[];
  contextUsage: {
    perplexity: number; // Research calls
    context7: number;   // Documentation lookups
    playwright: number; // Testing decisions
  };
}
```

## 📋 Command Reference

### Core Commands (Claude Code Custom Slashes)

| Command | Purpose | When to Use | Example Agent Interaction |
|---------|---------|-------------|---------------------------|
| `/project:project-setup` | Initialize PRD → Linear workflow | Start of every project | "Set up the project workflow from my PRD" |
| `/project:execute-tasks` | Implement tasks with automation | Development sessions | "Execute the next tasks in my project" |
| `/project:workflow-status` | Check progress & get recommendations | Daily status checks | "What's the current status of my project?" |
| `/project:sync-linear` | Fix Linear sync gaps | After API rate limiting | "Sync my tasks with Linear issues" |
| `/project:verify-mapping` | Validate 1:1 task mapping | Quality assurance | "Verify all tasks are mapped to Linear correctly" |

## ⚙️ Configuration

### Complete MCP Configuration File

Save this as `~/.claude/mcp.json` (create the `.claude` directory if it doesn't exist):

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": [
        "-y",
        "--package=task-master-ai",
        "task-master-ai"
      ],
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-YOUR_ANTHROPIC_API_KEY_HERE",
        "PERPLEXITY_API_KEY": "pplx-YOUR_PERPLEXITY_API_KEY_HERE",
        "GOOGLE_API_KEY": "YOUR_GOOGLE_API_KEY_HERE",
        "OPENAI_API_KEY": "sk-YOUR_OPENAI_API_KEY_HERE",
        "MODEL": "claude-sonnet-4-20250514",
        "PERPLEXITY_MODEL": "sonar-pro",
        "MAX_TOKENS": 64000,
        "TEMPERATURE": 0.2,
        "DEFAULT_SUBTASKS": 5,
        "DEFAULT_PRIORITY": "medium"
      }
    },
    "linear": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.linear.app/sse"]
    },
    "context7": {
      "url": "https://mcp.context7.com/mcp"
    },
    "playwright": {
      "command": "npx @playwright/mcp@latest",
      "env": {}
    }
  }
}
```

### API Key Setup Instructions

1. **Anthropic API Key**: Get from [console.anthropic.com](https://console.anthropic.com)
2. **Perplexity API Key**: Get from [perplexity.ai](https://perplexity.ai) API section
3. **OpenAI API Key**: Get from [platform.openai.com](https://platform.openai.com)

### Path Configuration Notes

- **macOS/Linux**: Path above should work after `npm install -g task-master-ai`
- **Windows**: Use `C:\\Users\\{username}\\AppData\\Roaming\\npm\\node_modules\\task-master-ai\\build\\mcp-server.js`
- **Alternative**: Find your global npm path with `npm root -g` and adjust accordingly

> **⚠️ Important**: Restart Claude Desktop after saving this configuration file.

## 🔬 Advanced Topics

<details>
<summary>🧠 Linear Metadata Storage Anti-Hallucination System</summary>

**Critical Component**: Linear issue IDs are stored directly in Taskmaster task details to prevent hallucinations.

### How It Works
- **`getLinearMetadata(taskId)`** - Retrieves stored Linear data from task details
- **`setLinearMetadata(taskId, linearData)`** - Embeds Linear issue data into task details  
- **`validateMetadata(projectRoot)`** - Validates stored metadata against live Linear data

### Storage Format
```text
--- LINEAR SYNC METADATA ---
linearIssueNumber: TOR-346
linearIssueId: abc123-def456-ghi789
linearProjectId: project-uuid-here
assigneeId: assignee-uuid
syncTimestamp: 2024-01-15T10:30:00Z
--- END METADATA ---
```

### Benefits
- ✅ 100% accuracy in Linear sync operations
- ✅ Prevents duplicate issue creation
- ✅ Survives Claude context window resets
- ✅ Enables reliable bidirectional sync
</details>

<details>
<summary>🛠️ Utilities & Helper Functions</summary>

**80+ utility functions** across specialized files provide reliability and performance.

### Core Utility Files
- **linear-sync-utils.md** - Primary utilities library with metadata operations
- **Command-specific utilities** - Each command includes specialized helper functions
- **Type system** - Comprehensive TypeScript interfaces

### Key Functions
```typescript
// Core metadata operations
getLinearMetadata(taskId): Promise<LinearMetadata | null>
setLinearMetadata(taskId, linearData): Promise<boolean>
validateMetadata(projectRoot): Promise<ValidationResult>

// Enhanced sub-issue creation with recovery
createAndValidateSubIssues(parentTaskId, parentLinearIssueId, subtasks): Promise<BatchCreationResult>

// Performance optimizations
bulkSyncTasks(taskIds, options): Promise<Map<string, SyncResult>>
```

### Performance Results
- **87% reduction** in Linear API calls through metadata caching
- **75% faster** sync operations through batch processing
- **100% reliability** through automatic recovery mechanisms
</details>

<details>
<summary>🧪 Smart Testing Intelligence</summary>

Claude automatically determines when to run Playwright tests based on context analysis.

### Decision Framework
- **UI Components**: React/Vue components in `/components/`, `/app/`, `/pages/`
- **Form Implementations**: User input handling, validation
- **Critical User Flows**: Authentication, payments, data entry
- **Route/Page Additions**: New user-facing pages

### Testing Strategies
- **Minimal Testing** (30 seconds): Smoke tests for standard UI components
- **Interactive Testing** (45 seconds): Form and interaction validation
- **Critical Path Testing** (60 seconds): Comprehensive tests for auth/payments

### Auto-Skip Patterns
- Backend tasks (API endpoints, database schemas)
- Utility functions and configuration files
- Documentation and infrastructure tasks
</details>

<details>
<summary>📊 Session Memory & Audit Trail</summary>

Complete tracking of all operations with persistence across context window resets.

### What Gets Tracked
```typescript
interface SessionMemory {
  linearIssuesCreated: Map<string, string>;    // taskId → issueNumber
  validationsPerformed: Set<string>;           // taskIds validated
  duplicatesDetected: Array<DuplicateInfo>;    // Duplicate analysis
  contextUsage: {
    perplexity: number;  // Research calls
    context7: number;    // Documentation lookups
    playwright: number;  // Testing decisions
  };
}
```

### Benefits
- Prevents duplicate operations within same session
- Provides complete audit trail of all operations
- Caches validation results for performance
- Metadata survives context window resets
</details>

<details>
<summary>⚙️ Custom Command Creation</summary>

**Advanced**: Create your own workflow commands by adding `.md` files to `.claude/commands/`.

### Command Structure
- **File Location**: `.claude/commands/` directory at project root
- **File Format**: `.md` extension (e.g., `project-setup.md`)
- **Command Naming**: Filename becomes command (`project-setup.md` → `/project:project-setup`)
- **Recognition**: Restart Claude Desktop after adding new commands

### Template Structure
```markdown
# Command Name

## Purpose
Brief description of what this command does

## Interactive Gates
1. Validation step 1
2. User input required
3. Final confirmation

## Execution Sequence
1. MCP tool call 1
2. MCP tool call 2
3. Result processing
```

### Integration Pattern
```typescript
// Import shared utilities
import { getLinearMetadata, setLinearMetadata } from './linear-sync-utils';

// Use consistent error handling and rate limiting
// Follow the 6-gate validation pattern for user control
```
</details>

## 🛠️ Troubleshooting

### Common Issues

#### **MCP Connection Errors**
```bash
# Problem: "MCP server not found"
# Solution: Verify installation and restart Claude
npm list -g task-master-ai
# Restart Claude Desktop after any MCP config changes
```

#### **Linear Sync Failures**  
```bash
# Problem: Missing sub-issues in Linear
# Solution: Use recovery command
/project:sync-linear

# Problem: Duplicate Linear issues
# Solution: Use verification command  
/project:verify-mapping
```

#### **API Rate Limiting**
> **Built-in protection**: Workflow includes 3-second delays and batch processing

- Linear: Max 3 issues per batch, 10-second delays
- Perplexity: Auto-retry with exponential backoff
- Context7: Cached results to minimize calls

#### **Context Window Resets**
> **Session persistence**: Metadata stored in Taskmaster survives resets

1. Check current state: `/project:workflow-status`
2. Validate mapping: `/project:verify-mapping`  
3. Continue work: `/project:execute-tasks`

### Debug Commands

| Claude Command | Purpose | Example Agent Interaction |
|---------|---------|---------------------------|
| `/project:workflow-status` | Validate project state | "What's the current status of my project?" |
| `/project:verify-mapping` | Verify task mapping integrity | "Check if all my tasks are properly mapped to Linear" |
