# Repository Contents Manifest

This repository contains the complete Claude Code + Taskmaster workflow system.

## File Structure

### Root Files
- `README.md` - Complete workflow documentation (formerly claude-code-taskmaster-workflow.md)
- `CLAUDE.md` - Claude Code configuration and guidelines
- `claude-code-workflow-diagram.md` - Visual workflow diagram
- `userprompt.md` - Task executor prompt template
- `setup.sh` - Quick setup script
- `LICENSE` - MIT License
- `.gitignore` - Git ignore patterns

### .claude/
Claude Code custom commands and configuration:
- `commands/` - Custom slash commands (11 files)
  - `project-setup.md` - Initialize project from PRD
  - `execute-tasks.md` - Multi-agent task execution
  - `sync-linear.md` - Bidirectional Linear sync
  - `workflow-status.md` - Project progress overview
  - `verify-mapping.md` - Validate task mapping integrity
  - `sync-status.md` - Fast status sync
  - `enhance-docs.md` - Documentation enhancement
  - `testing-intelligence.md` - Smart testing framework
  - `linear-sync-utils.md` - Core sync utilities (2177 lines)
  - `linear-sync-functions.md` - Sync function library
  - `README.md` - Commands documentation
- `settings.local.json` - Claude local settings

### .cursor/
Cursor IDE configuration and rules:
- `rules/` - Development workflow rules (10 files)
  - `taskmaster.mdc` - Comprehensive Taskmaster command reference
  - `taskmaster-base.mdc` - Base Taskmaster configuration rules
  - `taskmaster-executor.mdc` - Task execution guidelines
  - `taskmaster_to_linear.mdc` - Linear sync workflow rules
  - `dev_workflow.mdc` - Development workflow process
  - `context7-usage.mdc` - Context7 documentation lookup rules
  - `playwright_mcp.mdc` - Playwright testing best practices
  - `sapling.mdc` - Sapling SCM workflow rules
  - `cursor_rules.mdc` - Cursor rule formatting guidelines
  - `self_improve.mdc` - Rule improvement workflow

### .taskmaster/
Taskmaster configuration and examples:
- `config.json` - Taskmaster configuration
- `docs/` - Example PRDs
  - `calorietrackerprd.txt` - Calorie tracker example
  - `tortastandprd.txt` - Torta Stand game example

### scripts/
- `example_prd.txt` - Template PRD for new projects

### content-factory/
Additional documentation and templates:
- `templates/`
  - `Claude Code + Taskmaster X Post Template.md` - Social media template
- `product-development/`
  - `Taskmaster Workflow Technical Architecture.md` - Technical deep dive

## Total Contents
- 37 files total
- 11 Claude Code custom commands
- 10 Cursor development rules
- 2 example PRDs
- Complete workflow documentation
- All utilities and helper functions

## Getting Started
Run `./setup.sh` or see README.md for complete setup instructions. 