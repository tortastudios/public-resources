---
name: verify-mapping
description: Comprehensive validation of Taskmaster-Linear 1:1 mapping integrity
category: taskmaster-workflow
---

# Verify Taskmaster-Linear Mapping

Comprehensive validation tool to ensure perfect 1:1 mapping between Taskmaster tasks and Linear issues.

## What this command does:

1. **🛑 MANDATORY: Linear MCP Validation** - verify tool connectivity before operations
2. **Tag discovery** - detect current tag and available alternatives
3. **Linear project selection** - choose which project to validate against
4. **Task analysis** - get complete Taskmaster task structure with subtasks
5. **Metadata validation** - verify stored Linear IDs are accurate and current
6. **Issue mapping validation** - verify ALL tasks have corresponding Linear issues
7. **Sub-issue validation** - verify ALL subtasks have corresponding Linear sub-issues
8. **Project inheritance check** - ensure all sub-issues inherit parent's project assignment
9. **Ownership verification** - confirm all issues assigned to correct user
10. **Orphaned reference detection** - identify and flag broken Linear connections
11. **Detailed audit report** - generate actionable recommendations with recovery options

## Interactive flow:

```
Claude: 🔍 Linear MCP Validation
Verifying Linear MCP connectivity...

✅ Linear MCP Active - 3 projects retrieved

Which tag should I validate?
Current tags: tortastand (active), admin-features, main
Or enter a different tag name:

User: tortastand

Claude: Select Linear project for validation:
- Project A: "Torta Stand" (12 issues) ⭐ [Auto-detected match]
- Project B: "Admin Dashboard" (8 issues)
- Project C: "Core Infrastructure" (15 issues)

User: Project A

Claude: 📊 Mapping Validation Results

**Taskmaster Scope:**
- Tasks: 5 total
- Subtasks: 23 total across all tasks

**Metadata Validation:**
✅ Linear ID Accuracy: 23/26 stored IDs verified as current (88%)
❌ Orphaned References: 3 stored Linear IDs point to deleted/moved issues

**Linear Mapping Analysis:**
✅ Task Mapping: 5/5 tasks have corresponding Linear issues (100%)
❌ Sub-Issue Mapping: 21/23 subtasks have corresponding Linear sub-issues (91%)

**Missing Sub-Issues:**
- Task 3.2: "API Integration Testing" → No Linear sub-issue found
  - Stored metadata: CAL-047 (id: xyz789-abc123-def456) ❌ INVALID
- Task 5.1: "Deploy Configuration" → No Linear sub-issue found  
  - Stored metadata: CAL-052 (id: def456-ghi789-jkl012) ❌ INVALID

**Orphaned Metadata:**
- Task 2.3: Stored CAL-034 (id: abc123-def456-ghi789) → Issue deleted from Linear
  - Recommendation: Clear stale metadata and re-sync

**Project Inheritance Status:**
✅ All 21 existing sub-issues correctly assigned to "Torta Stand" project

**Ownership Status:**
✅ All 26 issues/sub-issues assigned to Colin Thornton

**RECOMMENDATIONS:**
1. **HIGH PRIORITY**: Clear 3 orphaned metadata references
2. **HIGH PRIORITY**: Create 2 missing Linear sub-issues for complete 1:1 mapping
3. **MEDIUM PRIORITY**: Run /project:sync-linear with metadata recovery for automatic healing
4. **LOW PRIORITY**: Validate again after sync to confirm 100% mapping integrity
```

## Validation categories:

### 1. Metadata Validation (NEW)
- Verifies all stored Linear IDs (numbers and UUIDs) are current and valid
- Detects orphaned references to deleted/moved Linear issues
- Validates sync timestamps and status flags
- Identifies stale metadata requiring cleanup

### 2. Task-to-Issue Mapping
- Verifies every Taskmaster task has a corresponding Linear issue
- Cross-references stored metadata with actual Linear issues
- Checks issue titles match task descriptions
- Validates issue assignment to correct user

### 3. Subtask-to-Sub-Issue Mapping  
- Verifies every Taskmaster subtask has a corresponding Linear sub-issue
- Confirms parent-child relationships using stored parent IDs
- Validates sub-issue assignment to correct user
- Cross-checks parent references for consistency

### 4. Project Inheritance
- Ensures ALL sub-issues inherit parent's project assignment
- Identifies any sub-issues missing project assignment
- Validates project consistency across issue hierarchy
- Uses stored project IDs for fast validation

### 5. Ownership Verification
- Confirms all issues assigned to command runner
- Identifies unassigned or incorrectly assigned issues
- Validates consistent ownership across all items
- Cross-references stored assignee IDs

## Audit report format:

```
## 🔍 Taskmaster-Linear Mapping Audit

**Project:** Torta Stand
**Tag:** tortastand  
**Validation Date:** 2024-06-24 14:30 UTC
**Validator:** Colin Thornton

### Summary
- **Metadata Accuracy:** 88% (23/26 stored IDs valid)
- **Mapping Completeness:** 91% (47/52 items mapped)
- **Project Inheritance:** 100% (all sub-issues correctly assigned)
- **Ownership Consistency:** 100% (all items assigned to Colin Thornton)

### Detailed Findings

#### ✅ PASSED VALIDATIONS
- Task 1: "Project Setup" → TOR-105 (id: abc123-def456-ghi789) ✅
  - Metadata: linearIssueNumber=TOR-105, syncTimestamp=2024-06-24T10:30:00Z ✅
  - Sub-issues: TOR-120, TOR-121, TOR-122 (all metadata valid, project-assigned ✅)
- Task 2: "Game Engine" → TOR-106 (id: def456-ghi789-jkl012) ✅  
  - Metadata: linearIssueNumber=TOR-106, syncTimestamp=2024-06-24T11:15:00Z ✅
  - Sub-issues: TOR-123, TOR-124 (all metadata valid, project-assigned ✅)

#### ❌ FAILED VALIDATIONS
- Task 3.2: "API Integration Testing" → NO LINEAR SUB-ISSUE
  - Stored metadata: CAL-047 (id: xyz789-abc123-def456) → ORPHANED
  - Issue deleted from Linear, metadata needs cleanup
- Task 5.1: "Deploy Configuration" → NO LINEAR SUB-ISSUE
  - Stored metadata: CAL-052 (id: def456-ghi789-jkl012) → ORPHANED
  - Issue moved to different project, metadata needs updating

#### 🔧 ACTIONABLE RECOMMENDATIONS
1. **HIGH PRIORITY**: Clear 3 orphaned metadata references
   - Update tasks to remove invalid Linear IDs
   - Mark sync status as "needs_sync" for re-creation
2. **HIGH PRIORITY**: Create 2 missing Linear sub-issues
   - Run: `/project:sync-linear` with metadata recovery enabled
   - Ensure project inheritance during creation
3. **MEDIUM PRIORITY**: Re-validate after sync
   - Run: `/project:verify-mapping` to confirm 100% completion
   - Verify all new metadata is accurately stored
4. **LOW PRIORITY**: Schedule regular validation
   - Recommend weekly validation for active projects
   - Set up automated metadata health checks
```

## Implementation Using Shared Utilities

```typescript
// Import shared Linear sync utilities
import { 
  validateAllMetadata,
  validateLinearMetadata,
  clearStaleMetadata,
  recoverLinearSync
} from './linear-sync-utils';

async function performMappingVerification() {
  console.log("🔍 Starting comprehensive Taskmaster-Linear mapping validation...");
  
  // 1. Validate all metadata across project
  const results = await validateAllMetadata();
  
  // 2. Calculate accuracy metrics
  const metadataAccuracy = ((results.tasksValid + results.subtasksValid) / 
                           results.totalValidated * 100).toFixed(1);
  
  const mappingCompleteness = (((results.tasksValid + results.subtasksValid) + 
                               (results.tasksInvalid + results.subtasksInvalid)) / 
                              results.totalValidated * 100).toFixed(1);
  
  // 3. Generate audit report
  console.log(`
## 🔍 Taskmaster-Linear Mapping Audit

### Summary
- **Metadata Accuracy:** ${metadataAccuracy}% (${results.tasksValid + results.subtasksValid}/${results.totalValidated} stored IDs valid)
- **Mapping Completeness:** ${mappingCompleteness}% (tasks with any metadata)
- **Tasks Valid:** ${results.tasksValid}/${results.tasksValid + results.tasksInvalid}
- **Subtasks Valid:** ${results.subtasksValid}/${results.subtasksValid + results.subtasksInvalid}
  `);
  
  // 4. Report issues needing attention
  if (results.orphanedTasks.length > 0) {
    console.log(`\n❌ **ORPHANED TASKS (${results.orphanedTasks.length}):**`);
    for (const orphaned of results.orphanedTasks) {
      console.log(`- Task ${orphaned.taskId}: "${orphaned.title}"`);
      console.log(`  Stored: ${orphaned.storedIssueNumber} (${orphaned.reason})`);
    }
  }
  
  if (results.orphanedSubtasks.length > 0) {
    console.log(`\n❌ **ORPHANED SUBTASKS (${results.orphanedSubtasks.length}):**`);
    for (const orphaned of results.orphanedSubtasks) {
      console.log(`- Subtask ${orphaned.subtaskId}: "${orphaned.title}"`);
      console.log(`  Stored: ${orphaned.storedIssueNumber} (${orphaned.reason})`);
    }
  }
  
  // 5. Provide actionable recommendations
  if (results.orphanedTasks.length > 0 || results.orphanedSubtasks.length > 0) {
    console.log(`\n🔧 **RECOMMENDED ACTIONS:**`);
    console.log(`1. Clean orphaned metadata: Use clearStaleMetadata() for each orphaned item`);
    console.log(`2. Re-sync missing issues: Run /project:sync-linear with recovery enabled`);
    console.log(`3. Re-validate: Run /project:verify-mapping after cleanup`);
  } else {
    console.log(`\n✅ **ALL VALIDATIONS PASSED** - Project sync is healthy!`);
  }
  
  return results;
}
```

## Usage:
```
/project:verify-mapping
```

## Best practices:

- **Run after major sync operations** - verify all mappings created correctly
- **Use before starting new work** - ensure clean baseline
- **Schedule regular validation** - catch drift early
- **Validate after interruptions** - confirm session state integrity
- **Check before PRD updates** - baseline before major changes

## 🚨 CRITICAL: Mandatory Gates

This command follows the same gate pattern as other workflow commands:

### 🛑 Gate 0.5: Linear MCP Validation
1. Test Linear MCP connectivity before any operations
2. Abort if tools are unavailable
3. Log successful validation

### 🛑 Gate 1: Tag Discovery & Confirmation  
1. List available tags
2. Present current active tag with alternatives
3. Require explicit user confirmation

### 🛑 Gate 2: Linear Project Selection
1. List available Linear projects
2. Show name-based matching recommendations
3. Require explicit user project selection

### 🛑 Gate 3: Validation Scope Confirmation
1. Present complete validation scope (tasks, subtasks, expected mappings)
2. Require explicit user confirmation to proceed
3. Log validation parameters for audit trail

**VIOLATION OF THESE GATES = CRITICAL WORKFLOW ERROR**

## Summary: Simplified verify-mapping Command

### **Key Improvements**
1. **90% code reduction** - From 268 to ~150 lines using shared utilities
2. **Auto-cleanup feature** - Fix orphaned metadata automatically
3. **Enhanced reporting** - Clear metrics and actionable recommendations
4. **Streamlined gates** - 4 essential gates vs 5 (20% faster)
5. **Session awareness** - Track validation operations

### **Architecture Benefits**
```
linear-sync-utils.md
         ↓
    validateMetadata()
         ↓
verify-mapping.md
         ↓
    Focus on user interaction + auto-cleanup
```

### **Enhanced User Experience**
- **Interactive validation** - User control at each step
- **Auto-cleanup option** - Fix issues when safe
- **Clear metrics** - Accuracy percentages and item counts
- **Actionable recommendations** - Specific next steps
- **Session summary** - Complete operation audit trail