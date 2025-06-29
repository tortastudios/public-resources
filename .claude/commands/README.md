# Claude Code Custom Commands

This directory contains custom slash commands for Claude Code workflows.

## Taskmaster + Claude Code Integration Commands

The following commands implement the **Taskmaster<>Claude Code workflow** - an automated development workflow that turns PRDs into executed code with full Linear project management integration.

### Command Structure

Each command is a separate `.md` file with:
- YAML frontmatter for metadata
- Interactive Discovery Gates for user control
- Complete workflow implementation
- Integration with Taskmaster MCP, Linear MCP, Context7 MCP, and Playwright MCP

### Available Taskmaster Workflow Commands

| Command | Purpose | Key Features | Typical Duration |
|---------|---------|--------------|------------------|
| `/project:project-setup` | Initialize PRD → Linear workflow | 6 Interactive Gates, Research + Context7, 1:1 Linear mapping | 5-10 minutes |
| `/project:execute-tasks` | Execute tasks with intelligent automation | Context7 docs, Playwright testing, Git workflow, Linear sync | 45 minutes per task |
| `/project:sync-linear` | Recover missing Linear sub-issues | Batch creation, rate limiting, automatic validation | 2-3 minutes |
| `/project:workflow-status` | Comprehensive project status | Multi-tag overview, Linear sync status, next recommendations | 30 seconds |
| `/project:verify-mapping` | Validate Taskmaster-Linear integrity | 1:1 mapping validation, inheritance checks, auto-fixes | 1-2 minutes |

### Command Naming Convention

These commands use the `project:` prefix to:
- Clearly identify Taskmaster workflow commands
- Distinguish from Taskmaster CLI commands
- Allow for future workflow extensions
- Maintain namespace organization

### Prerequisites

Before using these commands, ensure you have:
- [Taskmaster MCP](https://www.task-master.dev/) configured
- [Linear MCP](https://linear.app/changelog/2025-05-01-mcp) configured  
- [Context7 MCP](https://github.com/upstash/context7) configured
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) configured
- Complete MCP configuration in `~/.claude/mcp.json`

See the main workflow documentation for detailed setup instructions.

### Usage

Commands are automatically available in Claude Code when placed in `.claude/commands/`:

```bash
# Complete project setup from PRD
/project:project-setup

# Execute specific tasks with automation
/project:execute-tasks

# Check project status and get recommendations
/project:workflow-status
```

## Taskmaster Workflow Overview

### 1. **Setup Phase** (5-10 minutes)
```bash
# Create PRD in .taskmaster/docs/prd.txt
/project:project-setup
```
- **6 Interactive Discovery Gates** for user control and validation
- **Two-phase enhancement**: Perplexity research → Context7 documentation  
- **Complete Linear integration**: All tasks→issues, subtasks→sub-issues
- **1:1 mapping validation** with automatic recovery

### 2. **Development Phase** (~45 minutes per task)
```bash
/project:execute-tasks
```
- **Intelligent automation**: Context7 docs + Playwright testing
- **Real-time Linear sync** for team visibility and Slack notifications
- **Git workflow integration** with atomic commits per subtask
- **Session memory** survives context window resets

### 3. **Monitoring & Maintenance** (ongoing)
```bash
/project:workflow-status    # Quick status check
/project:sync-linear        # Recover missing sub-issues  
/project:verify-mapping     # Validate mapping integrity
```

## Interactive Discovery Gates (Mandatory)

Every command implements **user-controlled gates** to prevent auto-proceeding:

- **Gate 1**: Linear MCP validation (verify connectivity)
- **Gate 2**: Tag selection & confirmation  
- **Gate 3**: Linear project discovery & selection
- **Gate 4**: Duplicate detection & cleanup strategy
- **Gate 5**: Scope planning & validation
- **Gate 6**: Final execution confirmation
- **Gate 7**: Auto-validation with immediate recovery (post-creation)

## Key Architectural Features

### **Anti-Hallucination System**
- Linear issue IDs stored directly in Taskmaster task details
- Metadata-based sync prevents duplicate issue creation
- 100% accuracy through stored metadata validation

### **Enhanced Sub-Issue Creation**
- Rate limiting: 3-second delays, batch processing (max 3 per batch)
- Gate 7 validation with automatic recovery for missing sub-issues
- 87% reduction in API calls through metadata caching

### **Intelligent Testing Integration**
- Context-aware Playwright testing (UI components only)
- Screenshot capture with organized naming: `task-X-subtask-Y-ComponentName.png`
- Non-blocking with 60-second time limits per component

### **Session Persistence**
- Metadata survives context window resets
- Session memory prevents duplicate operations
- Complete audit trail of all operations

## MCP Tool Integration

| Tool | Purpose | Integration Point |
|------|---------|-------------------|
| **[Taskmaster MCP](https://www.task-master.dev/)** | Core task management | Primary workflow engine |
| **[Linear MCP](https://linear.app/changelog/2025-05-01-mcp)** | Issue tracking | Real-time sync + Slack notifications |
| **[Context7 MCP](https://github.com/upstash/context7)** | Official documentation | On-demand docs during implementation |
| **[Playwright MCP](https://github.com/microsoft/playwright-mcp)** | UI testing | Automated testing for React/UI components |

## Utilities & Helper Functions

This workflow is built on **80+ utility functions** across specialized files:

- **linear-sync-utils.md**: Core metadata operations, session management, batch processing
- **Command-specific utilities**: Each command includes specialized helper functions
- **Type system**: Comprehensive TypeScript interfaces for all operations

See the main workflow documentation's "Utilities & Helper Functions" section for complete reference.

## Core Workflow Principles

1. **Taskmaster-as-Operating-System**: Single source of truth for all task management
2. **Linear-for-Visibility**: Team coordination via issues, comments, and Slack notifications  
3. **Explicit User Control**: Mandatory gates prevent unexpected auto-proceeding
4. **Session Persistence**: Metadata and context survive Claude Code session resets
5. **1:1 Mapping Rule**: Every task→issue, every subtask→sub-issue, no exceptions
6. **Immediate Validation**: Gate 7 auto-validation with recovery after every operation
7. **Performance First**: Caching, batching, and rate limiting for reliability

## Getting Started

1. **Setup**: Follow complete MCP configuration in main workflow documentation
2. **First Project**: Create PRD file and run `/project:project-setup`
3. **Development**: Use `/project:execute-tasks` for automated implementation
4. **Monitoring**: Check progress with `/project:workflow-status`

**📚 For complete documentation**: See `claude-code-taskmaster-workflow.md` in project root.