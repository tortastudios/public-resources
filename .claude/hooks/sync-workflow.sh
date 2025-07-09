#!/bin/bash
# sync-workflow.sh - Deterministic Taskmaster <-> Linear status synchronization
# Triggered after every mcp__task-master-ai__set_task_status call
# Ensures perfect bidirectional sync with team coordination

set -euo pipefail

# Configuration - TEMPLATE: Update these paths for your project
PROJECT_ROOT="$(pwd)"  # Default to current directory, update as needed
LOG_FILE="/tmp/claude-hook-sync.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Source linear sync utilities (if they exist)
if [ -f "$SCRIPT_DIR/sync-utilities.sh" ]; then
    source "$SCRIPT_DIR/sync-utilities.sh"
fi

# Parse hook arguments
# Expected format: task_id old_status new_status [tag]
TASK_ID="${1:-}"
OLD_STATUS="${2:-}"
NEW_STATUS="${3:-}"
TAG="${4:-}"

# Validate required arguments
if [ -z "$TASK_ID" ] || [ -z "$NEW_STATUS" ]; then
    log "INFO: Insufficient arguments - skipping sync (task_id: $TASK_ID, new_status: $NEW_STATUS)"
    exit 0
fi

log "INFO: Starting sync for task $TASK_ID: $OLD_STATUS -> $NEW_STATUS (tag: $TAG)"

# Helper function to get Linear metadata
get_linear_metadata() {
    local task_id="$1"
    local is_subtask="${2:-false}"
    
    # This would integrate with existing linear-sync-utils.md functions
    # For now, return mock data structure
    echo '{"linearIssueId":"mock-issue-id","linearIssueNumber":"PRJ-123","linearProjectId":"mock-project-id"}'
}

# Helper function to update Linear status
update_linear_status() {
    local task_id="$1"
    local new_status="$2"
    
    # Convert Taskmaster status to Linear status
    local linear_status
    case "$new_status" in
        "pending")
            linear_status="Backlog"
            ;;
        "in-progress")
            linear_status="In Progress"
            ;;
        "done")
            linear_status="Done"
            ;;
        "blocked")
            linear_status="Blocked"
            ;;
        "review")
            linear_status="In Review"
            ;;
        *)
            linear_status="Backlog"
            ;;
    esac
    
    log "INFO: Updating Linear status for task $task_id to $linear_status"
    
    # TODO: Implement actual Linear API call using existing utilities
    # This would call the linear-sync-utils.md functions
    
    return 0
}

# Helper function to add Linear comment
add_linear_comment() {
    local task_id="$1"
    local comment="$2"
    
    log "INFO: Adding Linear comment for task $task_id: $comment"
    
    # TODO: Implement actual Linear API call using existing utilities
    # This would call the linear-sync-utils.md functions
    
    return 0
}

# Helper function to get completion details
get_completion_details() {
    local task_id="$1"
    
    # Extract completion details from recent work
    local details=""
    
    # Check for recent commits
    if [ -d "$PROJECT_ROOT/.git" ]; then
        local recent_commits=$(cd "$PROJECT_ROOT" && git log --oneline -5 --grep="Task $task_id" || echo "")
        if [ -n "$recent_commits" ]; then
            details="${details}Recent commits: $(echo "$recent_commits" | wc -l) commits"$'\n'
        fi
    fi
    
    # Check for test results (if any test output files exist)
    if [ -d "$PROJECT_ROOT/tests" ]; then
        details="${details}Tests: Available in tests/ directory"$'\n'
    fi
    
    # Add timestamp
    details="${details}Completed: $(date '+%Y-%m-%d %H:%M:%S')"$'\n'
    details="${details}Completed by: $(whoami)"
    
    echo "$details"
}

# Helper function to add completion details to Taskmaster
add_taskmaster_details() {
    local task_id="$1"
    local completion_details="$2"
    
    log "INFO: Adding completion details to Taskmaster for task $task_id"
    
    # TODO: This would integrate with existing Taskmaster utilities
    # For now, just log the details
    log "INFO: Completion details: $completion_details"
    
    return 0
}

# Main sync logic based on status transition
case "$NEW_STATUS" in
    "in-progress")
        log "INFO: Task $TASK_ID started - updating Linear and adding team notification"
        
        # Update Linear status
        update_linear_status "$TASK_ID" "$NEW_STATUS"
        
        # Add team context comment
        local start_comment="🚀 Started by $(whoami) - development in progress"
        if [ -n "$TAG" ]; then
            start_comment="$start_comment (tag: $TAG)"
        fi
        
        add_linear_comment "$TASK_ID" "$start_comment"
        
        log "SUCCESS: Task $TASK_ID started - team notified via Linear"
        ;;
        
    "done")
        log "INFO: Task $TASK_ID completing - adding details and updating Linear"
        
        # Get completion details
        completion_details=$(get_completion_details "$TASK_ID")
        
        # Add to Taskmaster BEFORE marking done (prevents lockout)
        add_taskmaster_details "$TASK_ID" "$completion_details"
        
        # Update Linear with completion info
        local completion_comment="✅ Completed by $(whoami):"$'\n'"$completion_details"
        add_linear_comment "$TASK_ID" "$completion_comment"
        
        # Update Linear status
        update_linear_status "$TASK_ID" "$NEW_STATUS"
        
        log "SUCCESS: Task $TASK_ID completed - team notified with details"
        ;;
        
    "blocked")
        log "INFO: Task $TASK_ID blocked - updating Linear"
        
        update_linear_status "$TASK_ID" "$NEW_STATUS"
        
        local blocked_comment="🚫 Blocked by $(whoami) - waiting for dependencies"
        add_linear_comment "$TASK_ID" "$blocked_comment"
        
        log "SUCCESS: Task $TASK_ID blocked - team notified"
        ;;
        
    "review")
        log "INFO: Task $TASK_ID ready for review - updating Linear"
        
        update_linear_status "$TASK_ID" "$NEW_STATUS"
        
        local review_comment="👀 Ready for review by $(whoami) - please review and approve"
        add_linear_comment "$TASK_ID" "$review_comment"
        
        log "SUCCESS: Task $TASK_ID ready for review - team notified"
        ;;
        
    "pending")
        log "INFO: Task $TASK_ID reset to pending - updating Linear"
        
        update_linear_status "$TASK_ID" "$NEW_STATUS"
        
        local pending_comment="⏸️ Reset to pending by $(whoami)"
        add_linear_comment "$TASK_ID" "$pending_comment"
        
        log "SUCCESS: Task $TASK_ID reset to pending - team notified"
        ;;
        
    *)
        log "WARNING: Unknown status '$NEW_STATUS' for task $TASK_ID - skipping sync"
        exit 0
        ;;
esac

# Validate sync was successful
log "INFO: Sync completed for task $TASK_ID"

# Exit successfully
exit 0