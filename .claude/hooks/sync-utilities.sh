#!/bin/bash
# sync-utilities.sh - Shared utility functions for Claude Code hooks
# Provides common functionality for Linear sync, Taskmaster integration, and validation
# Designed to integrate with existing linear-sync-utils.md functions

# Configuration - TEMPLATE: Update this path for your project
PROJECT_ROOT="$(pwd)"  # Default to current directory, update as needed

# Helper function to call Taskmaster MCP tools
call_taskmaster_mcp() {
    local tool_name="$1"
    shift
    local args="$@"
    
    # This would integrate with the existing MCP system
    # For now, just log the call
    echo "INFO: Would call $tool_name with args: $args"
    return 0
}

# Helper function to call Linear MCP tools
call_linear_mcp() {
    local tool_name="$1"
    shift
    local args="$@"
    
    # This would integrate with the existing MCP system
    # For now, just log the call
    echo "INFO: Would call $tool_name with args: $args"
    return 0
}

# Get Linear metadata for a task (integrates with existing utilities)
get_linear_metadata_for_task() {
    local task_id="$1"
    local is_subtask="${2:-false}"
    
    # This would call the existing getLinearMetadata function from linear-sync-utils.md
    # For now, return mock data
    echo '{"linearIssueId":"mock-issue-id","linearIssueNumber":"PRJ-123","linearProjectId":"mock-project-id"}'
}

# Update Linear status using MCP
update_linear_issue_status() {
    local linear_issue_id="$1"
    local new_status="$2"
    
    # This would call the Linear MCP to update the issue status
    call_linear_mcp "update_issue" "{\"id\": \"$linear_issue_id\", \"status\": \"$new_status\"}"
    
    return $?
}

# Add comment to Linear issue using MCP
add_linear_issue_comment() {
    local linear_issue_id="$1"
    local comment="$2"
    
    # This would call the Linear MCP to add a comment
    call_linear_mcp "add_comment" "{\"issueId\": \"$linear_issue_id\", \"comment\": \"$comment\"}"
    
    return $?
}

# Get Taskmaster task details
get_taskmaster_task_details() {
    local task_id="$1"
    local tag="${2:-}"
    
    # This would call the existing Taskmaster MCP to get task details
    call_taskmaster_mcp "get_task" "{\"id\": \"$task_id\", \"projectRoot\": \"$PROJECT_ROOT\"}"
    
    return $?
}

# Update Taskmaster task details
update_taskmaster_task_details() {
    local task_id="$1"
    local details="$2"
    
    # This would call the existing Taskmaster MCP to update task details
    call_taskmaster_mcp "update_task" "{\"id\": \"$task_id\", \"prompt\": \"$details\", \"projectRoot\": \"$PROJECT_ROOT\"}"
    
    return $?
}

# Validate Linear sync status for a tag
validate_linear_sync_for_tag() {
    local tag="$1"
    
    # This would integrate with existing validation utilities
    # For now, just return success
    echo "INFO: Validating Linear sync for tag: $tag"
    return 0
}

# Auto-recover sync issues
auto_recover_sync_issues() {
    local tag="$1"
    
    # This would integrate with existing recovery utilities
    # For now, just return success
    echo "INFO: Auto-recovering sync issues for tag: $tag"
    return 0
}

# Get current working tag
get_current_working_tag() {
    local tag=""
    
    # Try multiple methods to get current tag
    if [ -f "$PROJECT_ROOT/.current_tag" ]; then
        tag=$(cat "$PROJECT_ROOT/.current_tag" 2>/dev/null || echo "")
    fi
    
    if [ -z "$tag" ] && [ -d "$PROJECT_ROOT/.git" ]; then
        local branch_name=$(cd "$PROJECT_ROOT" && git branch --show-current 2>/dev/null || echo "")
        if [[ "$branch_name" =~ ^([^-]+)-tasks? ]]; then
            tag="${BASH_REMATCH[1]}"
        fi
    fi
    
    echo "$tag"
}

# Convert Taskmaster status to Linear status
convert_taskmaster_to_linear_status() {
    local taskmaster_status="$1"
    
    case "$taskmaster_status" in
        "pending")
            echo "Backlog"
            ;;
        "in-progress")
            echo "In Progress"
            ;;
        "done")
            echo "Done"
            ;;
        "blocked")
            echo "Blocked"
            ;;
        "review")
            echo "In Review"
            ;;
        *)
            echo "Backlog"
            ;;
    esac
}

# Generate completion details for a task
generate_task_completion_details() {
    local task_id="$1"
    
    local details=""
    
    # Check for recent commits
    if [ -d "$PROJECT_ROOT/.git" ]; then
        local recent_commits=$(cd "$PROJECT_ROOT" && git log --oneline -5 --grep="Task $task_id" 2>/dev/null || echo "")
        if [ -n "$recent_commits" ]; then
            local commit_count=$(echo "$recent_commits" | wc -l)
            details="${details}Recent commits: $commit_count commits"$'\n'
        fi
    fi
    
    # Check for test results
    if [ -d "$PROJECT_ROOT/tests" ]; then
        details="${details}Tests: Available in tests/ directory"$'\n'
    fi
    
    # Add timestamp and user
    details="${details}Completed: $(date '+%Y-%m-%d %H:%M:%S')"$'\n'
    details="${details}Completed by: $(whoami)"
    
    echo "$details"
}

# Check if a file change is significant for progress tracking
is_file_change_significant() {
    local file_path="$1"
    local tool_name="$2"
    
    # Skip certain file types
    case "$file_path" in
        *.log|*.tmp|*/.DS_Store|*/node_modules/*|*/.git/*|*/.claude/*)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Get human-readable file change description
get_file_change_description() {
    local file_path="$1"
    local tool_name="$2"
    
    local filename=$(basename "$file_path")
    local dir=$(dirname "$file_path" | sed "s|$PROJECT_ROOT/||")
    
    case "$tool_name" in
        "Edit")
            echo "Modified $filename"
            ;;
        "Write")
            echo "Created/updated $filename"
            ;;
        "MultiEdit")
            echo "Batch edited $filename"
            ;;
        *)
            echo "Changed $filename"
            ;;
    esac
}

# Flush a progress batch to Linear
flush_progress_batch_to_linear() {
    local task_id="$1"
    local batch_file="$2"
    
    if [ ! -f "$batch_file" ] || [ ! -s "$batch_file" ]; then
        return 0
    fi
    
    local total_changes=$(wc -l < "$batch_file")
    local start_time=$(head -n1 "$batch_file" | cut -d'|' -f1)
    local end_time=$(tail -n1 "$batch_file" | cut -d'|' -f1)
    
    local files_changed=$(cut -d'|' -f3 "$batch_file" | sort -u | wc -l)
    local file_list=$(cut -d'|' -f3 "$batch_file" | sort -u | head -5 | sed 's/.*\///' | tr '\n' ', ' | sed 's/,$//')
    
    if [ "$files_changed" -gt 5 ]; then
        file_list="$file_list... +$((files_changed-5)) more"
    fi
    
    local summary="🔧 Development Progress ($start_time - $end_time):
• $total_changes code changes
• $files_changed files: $file_list"
    
    # Get Linear metadata and add comment
    local linear_metadata=$(get_linear_metadata_for_task "$task_id")
    local linear_issue_id=$(echo "$linear_metadata" | grep -o '"linearIssueId":"[^"]*"' | cut -d'"' -f4)
    
    if [ -n "$linear_issue_id" ]; then
        add_linear_issue_comment "$linear_issue_id" "$summary"
    fi
    
    # Clean up batch file
    rm "$batch_file"
    
    return 0
}

# Create a session summary for Linear
create_session_summary_for_linear() {
    local tag="$1"
    local log_file="$2"
    
    local session_start_time=$(head -n1 "$log_file" 2>/dev/null | cut -d']' -f1 | tr -d '[' || echo "Unknown")
    local session_end_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    local sync_operations=$(grep -c "SUCCESS.*synced" "$log_file" 2>/dev/null || echo "0")
    local progress_updates=$(grep -c "Flushed.*progress" "$log_file" 2>/dev/null || echo "0")
    local validation_checks=$(grep -c "validation complete" "$log_file" 2>/dev/null || echo "0")
    
    local summary="📊 Session Summary (tag: $tag)
⏰ Duration: $session_start_time to $session_end_time
🔄 Sync operations: $sync_operations
📝 Progress updates: $progress_updates
✅ Validation checks: $validation_checks
🤖 Completed by: $(whoami)"
    
    echo "$summary"
}

# Main utility library loaded
echo "INFO: Claude Code hook utilities loaded"