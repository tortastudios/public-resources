# Taskmaster-Centric Workflow

**CORE PRINCIPLE: Taskmaster is the Project Management Operating System**

Taskmaster is the single source of truth for all task management. Linear serves as the notification and visibility layer for team coordination and Slack notifications.

## MANDATORY SYNC RULE

**Every Taskmaster status change MUST immediately trigger Linear sync to ensure Slack notifications**

## Task Status Workflow Pattern

```typescript
// REQUIRED PATTERN for all task status changes
1. mcp__task_master_ai__set_task_status(taskId, status) // Update Taskmaster first
2. syncTaskStatusToLinear(taskId, status)               // Sync to Linear immediately
3. // Slack notification automatically triggered by Linear update
```

## Task Execution Workflow

**Starting a Task:**
```
1. mcp__task_master_ai__next_task() → Get next task ID
2. mcp__task_master_ai__set_task_status(taskId, "in-progress") → Update Taskmaster
3. syncTaskStatusToLinear(taskId, "In Progress") → Trigger Slack notification
4. Begin development work
```

**During Task Execution:**
```
1. mcp__task_master_ai__update_subtask(subtaskId, progress) → Update Taskmaster
2. syncSubtaskProgressToLinear(subtaskId, progress) → Add Linear comment
3. // Progress visible in Linear and Slack
```

**Completing a Task:**
```
1. mcp__task_master_ai__set_task_status(taskId, "done") → Update Taskmaster
2. syncTaskStatusToLinear(taskId, "Done") → Trigger Slack notification
3. mcp__task_master_ai__next_task() → Get next task (optional)
```

## Linear Sync Functions (Implementation)

These functions support the Taskmaster workflow:

- **syncTaskStatusToLinear(taskId, status)** - Single task status update
- **syncSubtaskProgressToLinear(subtaskId, progress)** - Add progress comment to sub-issue
- **ensureLinearIssueExists(taskId)** - Create Linear issue if missing
- **ensureLinearSubIssueExists(parentTaskId, subtaskId)** - Create Linear sub-issue if missing

## Status Mapping
| Taskmaster | Linear | Slack Notification |
|------------|---------|-------------------|
| pending | Backlog | Task added |
| in-progress | In Progress | Work started |
| done | Done | Task completed |
| blocked | Blocked | Blocked status |
| review | In Review | Ready for review |

## Intelligent Playwright Testing

**Claude Code automatically determines when to use Playwright testing based on context**

### Automatic Testing Triggers

Claude will run Playwright tests when detecting:
- **New UI components** created in `/components/`, `/app/`, or `/pages/`
- **React components** (`.tsx` files with JSX elements)
- **Form implementations** with user input handling
- **Route/page additions** that users will interact with
- **Critical user flows** (auth, payments, data entry)

### Testing Decision Framework

```typescript
// Claude's internal decision process
1. Analyze files created/modified in subtask
2. Check for UI-related keywords in task description
3. Determine if user interaction is involved
4. IF UI component detected AND user-facing:
   - Run lightweight Playwright validation (30-60 seconds)
   - Capture screenshot for evidence
   - Verify basic functionality
5. ELSE: Skip testing, continue workflow
```

### Lightweight Testing Approach

When testing is triggered:
- **Smoke test only** - Component renders without errors
- **Basic interaction** - Key user actions work (click, type, submit)
- **Screenshot capture** - Visual evidence of working component  
- **Time limit** - 60 seconds maximum per component
- **Non-blocking** - Test failures logged but don't stop workflow

### Test Reporting in Linear

```
✅ Login form component implemented
🤖 Auto-tested with Playwright:
  - Renders correctly ✓
  - Accepts user input ✓  
  - Submits successfully ✓
  - Screenshot: tests/taskmaster-screenshots/task-1-subtask-2-LoginForm.png
  - Test duration: 42 seconds
```

### Override Options

Users can control testing behavior:
- **"Skip all testing"** - Disable automatic testing for session
- **"Test everything"** - Force testing on all subtasks
- **"Test this task"** - Run comprehensive tests on specific task
- **Default** - Let Claude decide based on context

### Screenshot Organization

Screenshots are automatically organized using Playwright configuration:

```typescript
// playwright.config.ts (configured)
export default defineConfig({
  outputDir: './tests/taskmaster-screenshots'
});
```

**Screenshot Naming Convention:**
```
tests/taskmaster-screenshots/
  ├── task-1-subtask-2-LoginForm.png
  ├── task-1-subtask-3-RegisterForm.png
  ├── task-3-subtask-1-Dashboard.png
  └── page-{timestamp}.png (fallback)
```

**Filename Format:**
- `task-{taskId}-subtask-{subtaskId}-{ComponentName}.png`
- Automatically saved to organized directory
- Full path reported in Linear comments and console

### What Gets Tested

**Always tested:**
- Authentication components (login, signup, logout)
- Payment/checkout flows
- Forms with data submission
- New pages/routes
- Components with state management

**Never tested automatically:**
- Configuration files
- Database schemas
- API endpoints (different testing approach)
- Utility functions
- Documentation
- Infrastructure setup

## Two-Phase Task Enhancement

**Maximize task quality with research-backed expansion plus official documentation**

### Phase 1: Perplexity Research Enhancement

Use Taskmaster's native research capabilities for strategic guidance:

```typescript
// Always use research option for task expansion
mcp__task-master-ai__expand_all({
  research: true,  // ← Enables Perplexity research
  projectRoot: "[YOUR_PROJECT_ROOT]"  // Update with your project path
})
```

**Perplexity provides:**
- Industry best practices and current trends
- Implementation strategies from real projects
- Common pitfalls and how to avoid them
- Architecture decisions and trade-offs
- Security considerations and performance tips

### Phase 2: Context7 Documentation Layer

Add official documentation and code examples:

```typescript
// After Perplexity expansion, enhance with official docs using Context7 MCP
/enhance-docs  // Uses mcp__context7__resolve-library-id() and mcp__context7__get-library-docs()
```

**Context7 provides:**
- Official library documentation and APIs
- Version-specific implementation details
- Exact code examples and usage patterns
- Framework-specific best practices
- Up-to-date syntax and methods

### Enhancement Example

**After Perplexity Research:**
```
Task 1.1: Implement user authentication
- Use JWT tokens for stateless authentication
- Implement refresh token rotation for security
- Add rate limiting to prevent brute force attacks
- Consider social OAuth providers for better UX
- Store sensitive data encrypted in database
```

**After Context7 Enhancement:**
```
Task 1.1: Implement user authentication
[Previous Perplexity content...]

Context7 Documentation (via MCP tools):
- mcp__context7__resolve-library-id("NextAuth.js") → /nextauthjs/next-auth
- mcp__context7__get-library-docs("/nextauthjs/next-auth", {topic: "JWT"})
- NextAuth.js v4.24 JWT configuration:
  [Code example with exact API usage]
- bcrypt.js hashing implementation:
  [Code snippet with proper salt rounds]
- Rate limiting with express-rate-limit:
  [Configuration example]
```

### When to Use Each Phase

**Use Perplexity Research when:**
- Starting new projects or features
- Need strategic implementation guidance
- Want to understand current best practices
- Learning about unfamiliar technology areas

**Use Context7 Enhancement when:**
- Have specific technology choices made
- Need exact implementation details
- Want official documentation references
- Preparing for detailed development work

**Combined approach gives comprehensive task preparation with both strategic and tactical guidance.**

## Interactive Discovery Gates

**VIOLATION OF THESE GATES = CRITICAL WORKFLOW ERROR**

Every workflow command MUST pause at these mandatory gates and CANNOT proceed without explicit user confirmation:

### Gate 1: Linear MCP Validation
**Purpose:** Verify Linear connectivity before any operations  
**REQUIRED TOOL SEQUENCE:**
```
1. Test Linear MCP connectivity: mcp__linear__list_projects() (MANDATORY)
2. Verify response validity and tool availability
3. If tools fail, ABORT with clear error message
4. Log successful validation before proceeding
```

**REQUIRED RESPONSE TEMPLATE:**
```
## 🔍 Gate 1: Linear MCP Validation
**Tool Status:** [PASS/FAIL]
**Projects Retrieved:** [X] projects found
**MCP Connection:** [Active/Failed]

**VALIDATION FAILURE PROTOCOL:** [if tools fail]
- ABORT all Linear operations immediately
- Present clear error message to user
- Recommend MCP configuration check
- Do not proceed with any workflow steps
```

### Gate 2: Tag Selection & Confirmation
**Purpose:** Establish Taskmaster context  
**REQUIRED TOOL SEQUENCE:**
```
1. mcp__task-master-ai__list_tags (MANDATORY)
2. Present findings to user
3. Get explicit confirmation before proceeding
```

**REQUIRED RESPONSE TEMPLATE:**
```
## 🔍 Gate 2: Tag Selection & Confirmation
**Available Tags:** [list all tags with task counts]
**Current Active:** [current tag name]
**Recommendation:** [suggested tag based on context]

**CHOICE REQUIRED:** Continue with '[current]' or select different? [current/other/new]
```

### Gate 3: Linear Project Discovery & Selection
**Purpose:** Identify target Linear project  
**REQUIRED TOOL SEQUENCE:**
```
1. mcp__linear__list_projects (MANDATORY)
2. Show available projects with name matching
3. Present recommendation with alternatives
4. Get explicit project selection
```

**REQUIRED RESPONSE TEMPLATE:**
```
## 🔍 Gate 3: Linear Project Discovery & Selection
**Available Projects:** [list with IDs and descriptions]
**Auto-Detected Match:** "[project name]" (based on tag similarity)
**Alternative Options:** [other relevant projects]

**CHOICE REQUIRED:** Use '[detected]' or select different? [detected/project-id/manual]
```

### Gate 4: Duplicate Detection & Cleanup Strategy
**Purpose:** Scan Linear project for existing issues, choose cleanup approach  
**REQUIRED TOOL SEQUENCE:**
```
1. mcp__linear__list_issues(projectId, limit=250) (MANDATORY)
2. Analyze issues for similarity to Taskmaster tasks  
3. Score issues by quality (Context7, recency, sub-issues, description)
4. Present duplicate findings with cleanup strategy recommendations
5. Get explicit user choice before proceeding
```

**REQUIRED RESPONSE TEMPLATE:**
```
## 🔍 Gate 4: Duplicate Detection & Cleanup Strategy
**Existing Issues Found:** [X] issues in Linear project
**Duplicate Sets:** [Y] sets of similar issues detected
**Quality Analysis:** [highest quality issues identified]

**Cleanup Strategies Available:**
1. **Smart Merge** - Keep best quality, update with latest docs (RECOMMENDED)
2. **Clean Slate** - Mark existing as duplicates, create fresh
3. **Link Existing** - Connect tasks to existing issues
4. **Skip Setup** - No changes, project already current

**CHOICE REQUIRED:** Select cleanup strategy [1/2/3/4]: 
```

**DUPLICATE PREVENTION RULES:**
- **NEVER create Linear issues without first checking for existing issues**
- **ALWAYS present cleanup options when duplicates detected**
- **PRESERVE highest quality issues (Context7 docs, recent, sub-issues)**
- **MARK duplicates clearly instead of deleting when possible**

### Gate 5: Scope Planning & Validation
**Purpose:** Analyze complete Taskmaster scope before Linear creation  
**REQUIRED TOOL SEQUENCE:**
```
1. mcp__task-master-ai__get_tasks with withSubtasks: true (MANDATORY)
2. Count tasks and subtasks
3. Calculate Linear scope (tasks→issues + subtasks→sub-issues)
4. Present complete scope plan
5. Get explicit confirmation
```

**REQUIRED RESPONSE TEMPLATE:**
```
## 🔍 Gate 5: Scope Planning & Validation
**Taskmaster Scope:**
- Tasks: [X] (status breakdown)
- Subtasks: [Y] total across all tasks

**Linear Scope (1:1 Mapping):**
- Will create: [X] Linear issues
- Will create: [Y] Linear sub-issues within parent issues
- All assigned to: [command runner name]

**CONFIRMATION REQUIRED:** Create this complete scope? [y/n]
```

### Gate 6: Final Execution Confirmation
**Purpose:** Last chance to abort before any creation/modification  
**REQUIRED BEFORE ANY CREATION:**
```
## ✅ Gate 6: Final Execution Confirmation
**Tag:** [selected tag]
**Linear Project:** [selected project]
**Scope:** [X tasks → X issues + Y subtasks → Y sub-issues]
**Enhancement:** Context7 documentation updates
**Assignment:** All issues → [command runner]

**PROCEED?** Type 'yes' to execute or 'no' to abort: 
```

### Gate 7: Post-Creation Validation (Auto-Executed)
**Purpose:** Validate sub-issue inheritance immediately after creation  
**REQUIRED TOOL SEQUENCE:**
```
1. After creating any sub-issues, IMMEDIATELY validate inheritance
2. mcp__linear__list_issues(projectId, limit=50) (MANDATORY)
3. Check ALL newly created sub-issues have correct project assignment
4. If inheritance failed, execute INHERITANCE FAILURE PROTOCOL
5. Log validation results for audit trail
```

**REQUIRED RESPONSE TEMPLATE:**
```
## ✅ Gate 7: Post-Creation Validation
**Validation Status:** [PASS/FAIL]
**Sub-Issues Created:** [X] sub-issues validated
**Project Inheritance:** [X] sub-issues correctly assigned to project [ProjectName]
**Failures Detected:** [Y] sub-issues missing project assignment

**INHERITANCE FAILURE PROTOCOL:** [if failures detected]
- Immediately update missing assignments using mcp__linear__update_issue
- Re-validate until all sub-issues inherit project correctly
- Log all corrections for audit trail
```

## Discovery Failure Consequences

**Understanding the Critical Impact:**
- **Missing tag confirmation** = User loses work on wrong context, violates user autonomy
- **Missing sub-issue creation** = Breaks fundamental 1:1 mapping principle, incomplete Linear hierarchy
- **Missing scope confirmation** = Unexpected Linear structure, workflow violations
- **Auto-proceeding** = Destroys user control, unpredictable outcomes

**THESE ARE NOT MINOR OMISSIONS - THEY ARE FUNDAMENTAL WORKFLOW VIOLATIONS**

## Mandatory Tool Sequence Checklist

Before executing ANY workflow command, verify this checklist is COMPLETE:

**PRE-EXECUTION GATES:**
- [ ] **Gate 1 - Linear MCP Validation**: Verify Linear MCP tools respond correctly before operations
- [ ] **Gate 2 - Tag Selection**: `mcp__task-master-ai__list_tags` executed and user confirmed tag choice
- [ ] **Gate 3 - Linear Project Selection**: `mcp__linear__list_projects` executed and user confirmed project choice
- [ ] **Gate 4 - Duplicate Detection**: `mcp__linear__list_issues` executed, duplicates analyzed, cleanup strategy selected
- [ ] **Gate 5 - Scope Planning**: `mcp__task-master-ai__get_tasks` with `withSubtasks: true` executed and scope confirmed
- [ ] **Gate 6 - Final Approval**: User typed explicit "yes" to proceed

**POST-EXECUTION VALIDATION:**
- [ ] **Gate 7 - Auto-Validation**: ALL created sub-issues verified to inherit parent's project assignment
- [ ] **Inheritance Failure Recovery**: Any missing assignments corrected immediately
- [ ] **Audit Trail Creation**: All validations and corrections logged for session memory

**FAILURE TO COMPLETE = CRITICAL ERROR**

## Key Workflow Principles
- **MANDATORY GATES**: Complete all 7 Interactive Discovery Gates (1-6) plus Gate 7 auto-validation
- **1:1 MAPPING RULE**: Create Linear issues for ALL tasks AND Linear sub-issues for ALL subtasks
- **EXPLICIT CONFIRMATION**: Never auto-proceed without user typing explicit approval
- **CONTEXT7 ENHANCEMENT**: ALWAYS use Context7 for technology documentation
- **OWNERSHIP TRACKING**: Assign all Linear issues to the command runner for ownership
- **PROJECT INHERITANCE**: Sub-issues MUST inherit the same project assignment as their parent issue
- **IMMEDIATE VALIDATION**: Validate sub-issue inheritance IMMEDIATELY after creation
- **FAILURE RECOVERY**: Automatically correct inheritance failures when detected
- **SESSION MEMORY**: Maintain context of all validations and corrections within session
- **NEVER COPY**: NEVER copy patterns from other projects in the monorepo
- **COMMIT PATTERN**: Commit per subtask with clear references: `[Task X.Y]`
- **UI TESTING**: Use Playwright tests for UI components

## Discovery & Auto-Detection Rules

**PRD File Discovery Priority:**

1. `{currentTag}prd.txt` (e.g., `[project-tag]prd.txt`)
2. `prd.txt` (fallback)
3. Interactive selection from `.taskmaster/docs/*.txt`
4. Prompt for manual file path

**Tag Selection Logic:**

1. ALWAYS list available tags using `mcp__task-master-ai__list_tags`
2. ALWAYS prompt for confirmation even if only one active tag exists
3. Present current active tag as default with alternatives
4. Offer new tag creation with branch-name option
5. REQUIRE explicit user choice before proceeding

**Linear Project Matching:**

1. ALWAYS list available projects using `mcp__linear__list_projects`
2. Show exact name matches (case-insensitive) as recommendations
3. Show partial name matches as alternatives
4. REQUIRE explicit user project selection
5. Auto-assign to command runner for ownership after confirmation

**Existing Setup Detection:**

- ALWAYS analyze current state using `mcp__task-master-ai__get_tasks` with `withSubtasks: true`
- Present 4 re-initialization strategies with clear explanations
- Calculate exact scope impact (tasks, subtasks, Linear issues, sub-issues)
- REQUIRE explicit user choice of re-initialization strategy
- Preserve implementation progress and notes during updates
- Never overwrite without explicit confirmation

## Session Memory Requirements

To reach 95% confidence in duplicate prevention, maintain these session context elements:

### Critical Context Elements (MUST PRESERVE)
- **Linear Issues Created**: Track ALL newly created issue IDs within session
- **Sub-Issue Parent Mapping**: Maintain parent→sub-issue relationships for validation
- **Project Assignments**: Record which project each issue/sub-issue was assigned to
- **Validation Results**: Log all Gate 7 validation outcomes (PASS/FAIL)
- **Inheritance Corrections**: Track any sub-issue project assignment fixes made

### Session Memory Pattern
```
## Session Context (Auto-Maintained)
**Linear Issues Created This Session:**
- PRJ-150: Task 1 "Setup Infrastructure" → Project: [Your Project]
  - Sub-issues: PRJ-151, PRJ-152, PRJ-153 (all assigned to [Your Project] ✅)
- PRJ-154: Task 2 "Core Features" → Project: [Your Project]  
  - Sub-issues: PRJ-155, PRJ-156 (all assigned to [Your Project] ✅)

**Validation History:**
- Gate 7 Validation #1: PASS (all 5 sub-issues inherited project correctly)
- Gate 7 Validation #2: FAIL → 2 corrections made → Re-validation: PASS

**Corrections Made:**
- PRJ-155: Added project assignment ([Your Project])
- PRJ-156: Added project assignment ([Your Project])
```

### Memory Usage Guidelines
- Update session context IMMEDIATELY after any Linear operations
- Reference session context before duplicate detection (prevent re-creating same issues)
- Use session context for Gate 7 validation scope (know which sub-issues to check)
- Maintain context across tool calls within same session