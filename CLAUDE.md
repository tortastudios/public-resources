# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Lint/Test Commands

### Project-Specific Commands
Configure your build, lint, and test commands based on your technology stack:

```bash
# Example: Next.js Web Application
cd src && npm run dev    # Start development server
cd src && npm run build  # Build for production
cd src && npm run lint   # Run ESLint

# Example: iOS Swift Application  
# XcodeBuildMCP handles builds automatically
swiftformat .            # Format Swift code
swiftlint               # Lint Swift code
```

## Code Style Guidelines

### General
- Follow trunk-based development workflow
- Make small, atomic commits
- Pull frequently from main

### Language-Specific Guidelines
Configure based on your tech stack:

#### TypeScript/React
- Use TypeScript for type safety
- Follow framework conventions for routing
- Use React hooks for stateful logic
- Use CSS modules for component styling

#### Swift (if applicable)
- Use SwiftUI for new UI components
- Follow MVVM architecture for feature modules
- Group related files in feature directories
- Follow Apple's Swift API Design Guidelines

### Error Handling
- Use structured error handling
- Log errors with appropriate context
- Implement error tracking (Sentry, etc.)

### Naming Conventions
- Use descriptive, meaningful names
- PascalCase for components/types
- camelCase for variables/functions
- snake_case for cursor rule files

## Project Management Integration

**CORE PRINCIPLE: Taskmaster + Linear Sync**

This project uses Taskmaster for task management with automated Linear synchronization for team coordination and Slack notifications. See [Taskmaster Workflow Documentation](docs/ai-context/taskmaster-workflow.md) for complete details.

### Essential Commands
- `/start` - Initialize complete workflow from PRD to Linear
- `/work` - Execute tasks with intelligent parallelization
- `/sync-linear` - Bidirectional Taskmaster-Linear synchronization
- `/status` - Comprehensive project progress view
- `/enhance-docs` - Update tasks with Context7 documentation

### Quick Start Pattern
```typescript
1. Initialize: /start
2. Execute: /work  
3. Monitor: /status
```

## Testing Integration

**Intelligent Playwright Testing**: Claude automatically determines when to run UI tests based on component detection. Screenshots saved to `tests/taskmaster-screenshots/` with naming pattern `task-{taskId}-subtask-{subtaskId}-{ComponentName}.png`.

## Documentation Structure

- **Foundation**: Essential project config (this file)
- **Component**: Technology-specific guidance in `docs/ai-context/`
- **Feature**: Workflow commands in `.claude/commands/`

### Key Documentation Files
- [Taskmaster Workflow](docs/ai-context/taskmaster-workflow.md) - Complete workflow process
- [Claude Code Hooks](.claude/hooks/) - Deterministic sync automation
- [Workflow Commands](.claude/commands/) - Interactive project commands

## Important Instructions
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.