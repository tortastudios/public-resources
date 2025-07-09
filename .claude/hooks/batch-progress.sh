#!/bin/bash
# batch-progress.sh - Batched progress updates for team coordination
# Triggered after Edit|Write|MultiEdit operations
# Accumulates changes and posts summary updates to Linear for team context

set -euo pipefail

# Configuration - TEMPLATE: Update these paths for your project
PROJECT_ROOT="$(pwd)"  # Default to current directory, update as needed
BATCH_DIR="/tmp/claude-progress-batch"
LOG_FILE="/tmp/claude-hook-batch.log"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Batching configuration
BATCH_SIZE_THRESHOLD=10          # Flush after 10 changes
BATCH_TIME_THRESHOLD=300         # Flush after 5 minutes (300 seconds)
MAX_BATCH_AGE=1800              # Maximum batch age before forced flush (30 minutes)

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Create batch directory if it doesn't exist
mkdir -p "$BATCH_DIR"

# Helper function to get current task context
get_current_task_context() {
    # Try to extract task ID from current working context
    # This would integrate with existing Taskmaster utilities
    local task_id=""
    
    # Check if there's a current task file or environment variable
    if [ -f "$PROJECT_ROOT/.current_task" ]; then
        task_id=$(cat "$PROJECT_ROOT/.current_task" 2>/dev/null || echo "")
    fi
    
    # If no task ID found, try to infer from git branch
    if [ -z "$task_id" ] && [ -d "$PROJECT_ROOT/.git" ]; then
        local branch_name=$(cd "$PROJECT_ROOT" && git branch --show-current 2>/dev/null || echo "")
        if [[ "$branch_name" =~ -tasks?-([0-9]+) ]]; then
            task_id="${BASH_REMATCH[1]}"
        fi
    fi
    
    echo "$task_id"
}

# Helper function to extract file path from tool arguments
extract_file_path() {
    local tool_args="$1"
    
    # Extract file_path from JSON-like arguments
    echo "$tool_args" | grep -o '"file_path":"[^"]*"' | cut -d'"' -f4 | head -1
}

# Helper function to determine if file change is significant
is_significant_change() {
    local file_path="$1"
    local tool_name="$2"
    
    # Skip certain file types that aren't significant for team updates
    case "$file_path" in
        *.log|*.tmp|*/.DS_Store|*/node_modules/*|*/.git/*)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

# Helper function to get file change description
get_change_description() {
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

# Helper function to check if batch should be flushed
should_flush_batch() {
    local batch_file="$1"
    
    if [ ! -f "$batch_file" ]; then
        return 1
    fi
    
    # Check change count threshold
    local change_count=$(wc -l < "$batch_file" 2>/dev/null || echo "0")
    if [ "$change_count" -ge "$BATCH_SIZE_THRESHOLD" ]; then
        return 0
    fi
    
    # Check time threshold
    local batch_age=$(stat -f %m "$batch_file" 2>/dev/null || echo "0")
    local current_time=$(date +%s)
    local time_since_first_change=$((current_time - batch_age))
    
    if [ "$time_since_first_change" -ge "$BATCH_TIME_THRESHOLD" ]; then
        return 0
    fi
    
    return 1
}

# Helper function to create progress summary
create_progress_summary() {
    local batch_file="$1"
    
    if [ ! -f "$batch_file" ]; then
        echo "No changes to summarize"
        return
    fi
    
    local total_changes=$(wc -l < "$batch_file")
    local start_time=$(head -n1 "$batch_file" | cut -d'|' -f1)
    local end_time=$(tail -n1 "$batch_file" | cut -d'|' -f1)
    
    # Get unique files changed
    local files_changed=$(cut -d'|' -f3 "$batch_file" | sort -u | wc -l)
    local file_list=$(cut -d'|' -f3 "$batch_file" | sort -u | head -5 | sed 's/.*\///' | tr '\n' ', ' | sed 's/,$//')
    
    if [ "$files_changed" -gt 5 ]; then
        file_list="$file_list... +$((files_changed-5)) more"
    fi
    
    # Create team-friendly summary
    local summary="🔧 Development Progress ($start_time - $end_time):
• $total_changes code changes
• $files_changed files: $file_list"
    
    echo "$summary"
}

# Helper function to add Linear comment (placeholder)
add_linear_comment() {
    local task_id="$1"
    local comment="$2"
    
    log "INFO: Adding Linear comment for task $task_id: $comment"
    
    # TODO: Implement actual Linear API call using existing utilities
    # This would call the linear-sync-utils.md functions
    
    return 0
}

# Helper function to flush batch to Linear
flush_batch_to_linear() {
    local task_id="$1"
    local batch_file="$2"
    
    if [ ! -f "$batch_file" ] || [ ! -s "$batch_file" ]; then
        log "INFO: No batch data to flush for task $task_id"
        return 0
    fi
    
    # Create progress summary
    local summary=$(create_progress_summary "$batch_file")
    
    # Post to Linear for team context
    add_linear_comment "$task_id" "$summary"
    
    log "INFO: Flushed batch progress to Linear for task $task_id"
    
    # Clean up batch file
    rm "$batch_file"
    
    return 0
}

# Main script logic
main() {
    # Parse arguments from hook
    local tool_name="${1:-}"
    local tool_args="${2:-}"
    
    if [ -z "$tool_name" ]; then
        log "INFO: No tool name provided - skipping batch update"
        exit 0
    fi
    
    # Extract file path from tool arguments
    local file_path=$(extract_file_path "$tool_args")
    
    if [ -z "$file_path" ]; then
        log "INFO: No file path found in tool arguments - skipping batch update"
        exit 0
    fi
    
    # Check if change is significant
    if ! is_significant_change "$file_path" "$tool_name"; then
        log "INFO: Change to $file_path is not significant - skipping batch update"
        exit 0
    fi
    
    # Get current task context
    local task_id=$(get_current_task_context)
    
    if [ -z "$task_id" ]; then
        log "INFO: No current task context found - skipping batch update"
        exit 0
    fi
    
    # Set up batch file for this task
    local batch_file="$BATCH_DIR/task-$task_id.log"
    
    # Create change description
    local change_description=$(get_change_description "$file_path" "$tool_name")
    local timestamp=$(date '+%H:%M')
    
    # Add change to batch log
    echo "$timestamp|$tool_name|$change_description" >> "$batch_file"
    
    log "INFO: Added change to batch for task $task_id: $change_description"
    
    # Check if batch should be flushed
    if should_flush_batch "$batch_file"; then
        log "INFO: Batch threshold reached for task $task_id - flushing to Linear"
        flush_batch_to_linear "$task_id" "$batch_file"
    fi
    
    # Cleanup old batch files (prevent disk space issues)
    find "$BATCH_DIR" -name "task-*.log" -mtime +1 -delete 2>/dev/null || true
    
    log "INFO: Batch progress processing complete for task $task_id"
}

# Run main function with all arguments
main "$@"