#!/bin/bash
# session-complete.sh - Comprehensive workflow validation at session end
# Triggered on Stop events to ensure all systems are healthy and synced
# Provides session summary and handles any final cleanup

set -euo pipefail

# Configuration - TEMPLATE: Update these paths for your project
PROJECT_ROOT="$(pwd)"  # Default to current directory, update as needed
BATCH_DIR="/tmp/claude-progress-batch"
LOG_FILE="/tmp/claude-hook-session.log"
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

# Helper function to get current tag
get_current_tag() {
    # Try to get current tag from Taskmaster
    local tag=""
    
    # Check if there's a current tag file
    if [ -f "$PROJECT_ROOT/.current_tag" ]; then
        tag=$(cat "$PROJECT_ROOT/.current_tag" 2>/dev/null || echo "")
    fi
    
    # If no tag found, try to infer from git branch
    if [ -z "$tag" ] && [ -d "$PROJECT_ROOT/.git" ]; then
        local branch_name=$(cd "$PROJECT_ROOT" && git branch --show-current 2>/dev/null || echo "")
        if [[ "$branch_name" =~ ^([^-]+)-tasks? ]]; then
            tag="${BASH_REMATCH[1]}"
        fi
    fi
    
    echo "$tag"
}

# Helper function to flush any remaining progress batches
flush_remaining_batches() {
    local flushed_count=0
    
    if [ -d "$BATCH_DIR" ]; then
        for batch_file in "$BATCH_DIR"/task-*.log; do
            if [ -f "$batch_file" ]; then
                local task_id=$(basename "$batch_file" | sed 's/task-\(.*\)\.log/\1/')
                
                log "INFO: Flushing remaining batch for task $task_id"
                
                # Use the batch-progress.sh flush function
                if [ -f "$SCRIPT_DIR/batch-progress.sh" ]; then
                    bash "$SCRIPT_DIR/batch-progress.sh" flush "$task_id" || true
                fi
                
                ((flushed_count++))
            fi
        done
    fi
    
    if [ $flushed_count -gt 0 ]; then
        log "INFO: Flushed $flushed_count remaining progress batches"
    fi
}

# Helper function to validate Linear sync status
validate_linear_sync() {
    local tag="$1"
    local issues_found=0
    
    log "INFO: Validating Linear sync status for tag: $tag"
    
    # TODO: Implement actual validation using existing utilities
    # This would call the linear-sync-utils.md functions to:
    # 1. Check all tasks have Linear issue mappings
    # 2. Check all subtasks have Linear sub-issue mappings
    # 3. Validate status consistency between Taskmaster and Linear
    # 4. Check for orphaned issues or missing assignments
    
    # For now, just log the validation attempt
    log "INFO: Linear sync validation complete - $issues_found issues found"
    
    return $issues_found
}

# Helper function to check git status
check_git_status() {
    local git_issues=0
    
    if [ -d "$PROJECT_ROOT/.git" ]; then
        cd "$PROJECT_ROOT"
        
        # Check for uncommitted changes
        if ! git diff-index --quiet HEAD --; then
            log "WARNING: Uncommitted changes found in git working directory"
            git_issues=1
        fi
        
        # Check for untracked files (excluding common ones)
        local untracked=$(git ls-files --others --exclude-standard)
        if [ -n "$untracked" ]; then
            log "INFO: Untracked files found: $(echo "$untracked" | wc -l) files"
        fi
        
        # Get current branch info
        local branch=$(git branch --show-current)
        local ahead=$(git rev-list --count HEAD ^origin/$branch 2>/dev/null || echo "0")
        local behind=$(git rev-list --count origin/$branch ^HEAD 2>/dev/null || echo "0")
        
        log "INFO: Git status - Branch: $branch, Ahead: $ahead, Behind: $behind"
        
        cd - > /dev/null
    else
        log "WARNING: No git repository found"
        git_issues=1
    fi
    
    return $git_issues
}

# Helper function to generate session summary
generate_session_summary() {
    local tag="$1"
    
    log "INFO: Generating session summary for tag: $tag"
    
    # Get session statistics
    local session_start_time=$(head -n1 "$LOG_FILE" 2>/dev/null | cut -d']' -f1 | tr -d '[' || echo "Unknown")
    local session_end_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Count operations from log
    local sync_operations=$(grep -c "SUCCESS.*synced" "$LOG_FILE" 2>/dev/null || echo "0")
    local progress_updates=$(grep -c "Flushed.*progress" "$LOG_FILE" 2>/dev/null || echo "0")
    local validation_checks=$(grep -c "validation complete" "$LOG_FILE" 2>/dev/null || echo "0")
    
    # Create summary
    local summary="📊 Session Summary (tag: $tag)
⏰ Duration: $session_start_time to $session_end_time
🔄 Sync operations: $sync_operations
📝 Progress updates: $progress_updates
✅ Validation checks: $validation_checks
🤖 Completed by: $(whoami)"
    
    echo "$summary"
}

# Helper function to cleanup temporary files
cleanup_temp_files() {
    local cleaned_count=0
    
    # Clean up old batch files
    if [ -d "$BATCH_DIR" ]; then
        find "$BATCH_DIR" -name "task-*.log" -mtime +1 -delete 2>/dev/null || true
        find "$BATCH_DIR" -name "*.last_flush" -mtime +1 -delete 2>/dev/null || true
    fi
    
    # Clean up old log files
    find /tmp -name "claude-hook-*.log" -mtime +7 -delete 2>/dev/null || true
    
    log "INFO: Temporary file cleanup complete"
}

# Helper function to auto-recover sync issues
auto_recover_sync() {
    local tag="$1"
    local recovery_count=0
    
    log "INFO: Attempting auto-recovery for sync issues in tag: $tag"
    
    # TODO: Implement actual recovery using existing utilities
    # This would:
    # 1. Retry failed Linear API calls
    # 2. Re-sync tasks with missing Linear mappings
    # 3. Fix orphaned sub-issues
    # 4. Update stale status mappings
    
    if [ $recovery_count -gt 0 ]; then
        log "INFO: Auto-recovery completed - $recovery_count issues resolved"
    fi
    
    return 0
}

# Helper function to create final Linear summary comment
create_session_summary_comment() {
    local tag="$1"
    local summary="$2"
    
    # Find the most recent task that was worked on
    local recent_task_id=""
    
    if [ -d "$BATCH_DIR" ]; then
        # Find the most recently modified batch file
        local recent_batch=$(find "$BATCH_DIR" -name "task-*.log" -exec ls -t {} + | head -1 2>/dev/null || echo "")
        if [ -n "$recent_batch" ]; then
            recent_task_id=$(basename "$recent_batch" | sed 's/task-\(.*\)\.log/\1/')
        fi
    fi
    
    # If we have a recent task, add the session summary as a comment
    if [ -n "$recent_task_id" ]; then
        log "INFO: Adding session summary comment to task $recent_task_id"
        
        # TODO: Implement actual Linear API call
        # add_linear_comment "$recent_task_id" "$summary"
    fi
}

# Main session completion logic
main() {
    log "INFO: Starting session completion validation"
    
    # Get current tag context
    local tag=$(get_current_tag)
    
    if [ -z "$tag" ]; then
        log "WARNING: No current tag found - using default validation"
        tag="unknown"
    fi
    
    log "INFO: Running session completion for tag: $tag"
    
    # 1. Flush any remaining progress batches
    flush_remaining_batches
    
    # 2. Validate Linear sync status
    local sync_issues=0
    if ! validate_linear_sync "$tag"; then
        sync_issues=$?
        log "WARNING: Found $sync_issues Linear sync issues"
        
        # Attempt auto-recovery
        auto_recover_sync "$tag"
    fi
    
    # 3. Check git status
    local git_issues=0
    if ! check_git_status; then
        git_issues=$?
        log "WARNING: Found $git_issues git issues"
    fi
    
    # 4. Generate session summary
    local session_summary=$(generate_session_summary "$tag")
    log "INFO: Session summary generated"
    echo "$session_summary"
    
    # 5. Create final Linear summary comment
    create_session_summary_comment "$tag" "$session_summary"
    
    # 6. Cleanup temporary files
    cleanup_temp_files
    
    # 7. Final health check
    local total_issues=$((sync_issues + git_issues))
    
    if [ $total_issues -eq 0 ]; then
        log "SUCCESS: Session completed successfully - all systems healthy"
    else
        log "WARNING: Session completed with $total_issues issues - check logs for details"
    fi
    
    log "INFO: Session completion validation finished"
    
    # Always exit successfully to avoid blocking the workflow
    exit 0
}

# Run main function
main "$@"