# [Torta Studios](https://www.tortastudios.com) Claude Code + Taskmaster Workflows
## Automated Development Workflow 

![Projects](https://img.shields.io/badge/Project%20Type-MVP%20%7C%20Features-purple)
[![Join Our Build-in-Public Newsletter](https://img.shields.io/badge/Join%20Our%20Build--in--Public%20Newsletter%20@-proofingroom.tortastudios.com-FF3C02?style=flat&labelColor=26201D)](https://proofingroom.tortastudios.com)

## By [@colin_thornton](https://x.com/colin_thornton), [@bitforth](https://x.com/bitforth) & [@darivadeneyra](https://x.com/darivadeneyra)

[![Twitter Follow](https://img.shields.io/twitter/follow/colin_thornton)](https://x.com/colin_thornton)
[![Twitter Follow](https://img.shields.io/twitter/follow/bitforth)](https://x.com/bitforth)
[![Twitter Follow](https://img.shields.io/twitter/follow/darivadeneyra)](https://x.com/darivadeneyra)

# Claude Code + Taskmaster Workflow Template

**Transform product ideas into executed code with full project management integration**

> No more manual ticket creation in Linear, context switching, or losing track of implementation details. Go from PRD to working on tasks in ~15-30 minutes with automated Linear sync and real-time Slack updates.

## 🚀 What This Template Provides

- **Automated project management**: PRD → tasks → Linear issues without manual work
- **Persistent memory**: Implementation details survive context window resets
- **Real-time team sync**: Linear/Slack notifications keep everyone informed
- **Intelligent testing**: Context-aware Playwright testing decisions
- **Streamlined workflow**: 6 essential commands instead of 14+

## ⚡ Quick Start

### 1. Copy This Template

```bash
# Copy this repository to your project
cp -r /path/to/public-resources/* your-project/
cd your-project/
```

### 2. Configure Your Project

**Update CLAUDE.md:**
- [ ] Replace placeholder project paths with your actual paths
- [ ] Update build/test commands for your tech stack
- [ ] Configure your project-specific guidelines

**Update Hook Scripts:**
- [ ] Set `PROJECT_ROOT` in `.claude/hooks/*.sh` to your project path
- [ ] Update project-specific git patterns and file structures

### 3. Install Dependencies

```bash
# Install Taskmaster
npm install -g task-master-ai

# Configure your API keys (see Configuration section)
# Copy MCP configuration to ~/.claude/mcp.json
# Restart Claude Code
```

### 4. Start Your First Project

```bash
# Create your PRD
mkdir -p docs/ai-context
echo "Your project requirements here" > docs/ai-context/prd.txt

# Initialize workflow
/start    # Streamlined 3-step setup
/work     # Execute tasks with intelligent selection
/status   # Check progress and get recommendations
```

## 🏗️ Template Structure

### Core Files

```
your-project/
├── CLAUDE.md                    # Main configuration (90 lines, streamlined)
├── .claude/
│   ├── commands/                # 6 essential commands
│   │   ├── start.md            # Streamlined project initialization
│   │   ├── work.md             # Intelligent task execution
│   │   ├── status.md           # Progress overview
│   │   ├── sync-linear.md      # Linear synchronization
│   │   ├── enhance-docs.md     # Context7 documentation
│   │   └── verify-mapping.md   # Mapping validation
│   └── hooks/                   # Deterministic sync automation
│       ├── hooks.json          # Hook configuration
│       ├── sync-workflow.sh    # Status sync automation
│       ├── batch-progress.sh   # Progress batching
│       ├── session-complete.sh # Session validation
│       └── sync-utilities.sh   # Shared utilities
└── docs/
    └── ai-context/             # Documentation structure
        └── taskmaster-workflow.md  # Complete workflow guide
```

### Command Overview

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/start` | Initialize PRD → Linear workflow (3 steps) | Start of projects |
| `/work` | Execute tasks with intelligent selection | Development work |
| `/status` | Progress overview with recommendations | Daily check-ins |
| `/sync-linear` | Fix Linear sync issues | When sync breaks |
| `/enhance-docs` | Update tasks with Context7 docs | Before implementation |
| `/verify-mapping` | Validate 1:1 task mapping | Quality assurance |

## 🔧 Configuration

### 1. Update CLAUDE.md

Replace these placeholders with your project details:

```markdown
# CLAUDE.md - Template Areas to Update

## Build/Lint/Test Commands (Lines 7-20)
# Update these commands for your tech stack:
cd src && npm run dev          # Your dev server
cd src && npm run build        # Your build process
cd src && npm run lint         # Your linting

## Code Style Guidelines (Lines 25-55)
# Update for your technology stack and conventions
```

### 2. Configure Hook Scripts

Update `PROJECT_ROOT` in all hook scripts:

```bash
# .claude/hooks/sync-workflow.sh
PROJECT_ROOT="/path/to/your/project"  # Update this line

# .claude/hooks/batch-progress.sh  
PROJECT_ROOT="/path/to/your/project"  # Update this line

# .claude/hooks/session-complete.sh
PROJECT_ROOT="/path/to/your/project"  # Update this line

# .claude/hooks/sync-utilities.sh
PROJECT_ROOT="/path/to/your/project"  # Update this line
```

### 3. API Keys Setup

Add to `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "task-master-ai": {
      "command": "npx",
      "args": ["-y", "--package=task-master-ai", "task-master-ai"],
      "env": {
        "ANTHROPIC_API_KEY": "sk-ant-YOUR_KEY_HERE",
        "PERPLEXITY_API_KEY": "pplx-YOUR_KEY_HERE",
        "OPENAI_API_KEY": "sk-YOUR_KEY_HERE"
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
      "command": "npx @playwright/mcp@latest"
    }
  }
}
```

### 4. Create Documentation Structure

```bash
# Create required directories
mkdir -p docs/ai-context
mkdir -p tests/taskmaster-screenshots

# Create your PRD
echo "Your project requirements here" > docs/ai-context/prd.txt
```

## 💡 Template Customization

### Technology-Specific Adaptations

**React/Next.js Projects:**
```markdown
# Update CLAUDE.md build commands
cd src && npm run dev
cd src && npm run build
cd src && npm run lint
```

**Swift/iOS Projects:**
```markdown
# Update CLAUDE.md build commands
swiftformat .
swiftlint
# XcodeBuildMCP handles builds automatically
```

**Python Projects:**
```markdown
# Update CLAUDE.md build commands
python -m pytest
python -m black .
python -m ruff check
```

### Command Customization

To modify workflow commands:

1. **Edit command files** in `.claude/commands/`
2. **Update template references** (replace `[project-tag]` with your tag patterns)
3. **Adjust gate logic** for your project needs
4. **Test with your team** before deploying

### Hook Customization

To modify automation behavior:

1. **Edit hook scripts** in `.claude/hooks/`
2. **Update `PROJECT_ROOT`** paths
3. **Adjust git patterns** for your branching strategy
4. **Test hook execution** with `chmod +x .claude/hooks/*.sh`

## 🔄 Workflow Integration

### Team Setup

**For Linear + Slack Integration:**
1. Connect [Linear to Slack](https://linear.app/docs/slack)
2. Configure team notifications
3. Set up project channels

**For GitHub Integration:**
1. Connect Linear to GitHub
2. Configure commit linking
3. Set up PR automation

### Development Process

**Daily Workflow:**
```bash
/status     # Check current state
/work       # Execute next tasks
/status     # Review progress
```

**Weekly Maintenance:**
```bash
/verify-mapping    # Validate sync integrity
/sync-linear      # Fix any issues
/enhance-docs     # Update documentation
```

## 🛠️ Troubleshooting

### Common Template Issues

**Commands Not Recognized:**
```bash
# Ensure .claude/commands/ is in project root
# Restart Claude Code after adding commands
```

**Hook Scripts Not Executing:**
```bash
# Make scripts executable
chmod +x .claude/hooks/*.sh

# Check PROJECT_ROOT paths
grep "PROJECT_ROOT" .claude/hooks/*.sh
```

**Missing Dependencies:**
```bash
# Install Taskmaster globally
npm install -g task-master-ai

# Verify installation
npm list -g task-master-ai
```

### Template Validation

**Verify Template Setup:**
1. [ ] CLAUDE.md exists and is configured
2. [ ] .claude/commands/ has 6 command files
3. [ ] .claude/hooks/ has 4 scripts + hooks.json
4. [ ] docs/ai-context/ exists
5. [ ] Hook scripts are executable
6. [ ] PROJECT_ROOT paths are updated

## 📚 Documentation

### Included Documentation

- **CLAUDE.md** - Main configuration (90 lines)
- **docs/ai-context/taskmaster-workflow.md** - Complete workflow guide
- **Command files** - Each command has detailed implementation docs
- **Hook scripts** - Self-documenting with inline comments

### Additional Resources

- [Taskmaster Documentation](https://github.com/eyaltoledano/claude-task-master)
- [Linear MCP](https://linear.app/changelog/2025-05-01-mcp)
- [Context7 MCP](https://github.com/upstash/context7)
- [Playwright MCP](https://github.com/microsoft/playwright-mcp)

## 🎯 Success Metrics

After implementing this template:

### User Experience
- ✅ **3-step initialization** instead of 6+ gates
- ✅ **AI-recommended tasks** with complexity analysis
- ✅ **Real-time progress** with team coordination
- ✅ **90% documentation reduction** while maintaining power

### Technical Reliability
- ✅ **Hook-enforced sync** - Perfect Linear integration
- ✅ **Session persistence** - Survives context resets
- ✅ **Intelligent testing** - Context-aware decisions
- ✅ **Error recovery** - Self-healing workflows

### Team Coordination
- ✅ **Linear notifications** - Real-time updates
- ✅ **Slack integration** - Team awareness
- ✅ **Progress tracking** - Complete audit trail
- ✅ **Quality assurance** - Built-in validation

## 🚀 Get Started

1. **Copy this template** to your project
2. **Configure PROJECT_ROOT** in hook scripts
3. **Update CLAUDE.md** for your tech stack
4. **Install dependencies** and restart Claude
5. **Create your PRD** and run `/start`

Transform your development workflow from manual to automated in minutes!

---

*This template provides a streamlined, production-ready workflow for AI-assisted development with full project management integration.*