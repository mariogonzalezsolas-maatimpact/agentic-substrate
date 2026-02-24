#!/usr/bin/env bash
# metrics/tracker.sh
# Track workflow metrics for continuous improvement
# Requires: jq (graceful degradation if not available)

set -e

METRICS_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/metrics"
METRICS_FILE="$METRICS_DIR/data.json"

# Create metrics directory and file if they don't exist
mkdir -p "$METRICS_DIR"
if [ ! -f "$METRICS_FILE" ]; then
    cat > "$METRICS_FILE" << 'EOF'
{
  "version": "1.0",
  "sessions": [],
  "summary": {
    "total_workflows": 0,
    "successful_workflows": 0,
    "failed_workflows": 0,
    "total_self_corrections": 0,
    "avg_research_score": 0,
    "avg_plan_score": 0,
    "patterns_captured": 0
  }
}
EOF
fi

# Guard: jq required for JSON manipulation
if ! command -v jq &>/dev/null; then
    echo "⚠️  jq not found — metrics tracking requires jq. Install: https://jqlang.github.io/jq/download/" >&2
    exit 0
fi

# Function to record workflow start
record_workflow_start() {
    local workflow_id="$1"
    local feature_name="$2"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local tmp_file="$METRICS_FILE.tmp"
    jq --arg id "$workflow_id" --arg name "$feature_name" --arg ts "$timestamp" \
        '.sessions += [{"id": $id, "feature": $name, "started": $ts, "status": "in_progress", "phases": [], "self_corrections": 0}] |
         .summary.total_workflows += 1' \
        "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"

    echo "📊 Workflow started: $workflow_id ($feature_name)"
}

# Function to record phase completion
record_phase() {
    local workflow_id="$1"
    local phase="$2"
    local score="$3"
    local duration="$4"

    local tmp_file="$METRICS_FILE.tmp"
    jq --arg id "$workflow_id" --arg ph "$phase" --argjson sc "${score:-0}" --argjson dur "${duration:-0}" \
        '(.sessions[] | select(.id == $id) | .phases) += [{"phase": $ph, "score": $sc, "duration_seconds": $dur}]' \
        "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"

    echo "📈 Phase complete: $phase (score: $score, ${duration}s)"
}

# Function to record workflow completion
record_workflow_complete() {
    local workflow_id="$1"
    local status="$2"
    local self_corrections="${3:-0}"
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    local tmp_file="$METRICS_FILE.tmp"
    if [ "$status" = "success" ]; then
        jq --arg id "$workflow_id" --arg st "$status" --argjson sc "$self_corrections" --arg ts "$timestamp" \
            '(.sessions[] | select(.id == $id)) |= (.status = $st | .completed = $ts | .self_corrections = $sc) |
             .summary.successful_workflows += 1 |
             .summary.total_self_corrections += $sc' \
            "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"
    else
        jq --arg id "$workflow_id" --arg st "$status" --argjson sc "$self_corrections" --arg ts "$timestamp" \
            '(.sessions[] | select(.id == $id)) |= (.status = $st | .completed = $ts | .self_corrections = $sc) |
             .summary.failed_workflows += 1 |
             .summary.total_self_corrections += $sc' \
            "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"
    fi

    # Recalculate averages
    tmp_file="$METRICS_FILE.tmp"
    jq '.summary.avg_research_score = ([.sessions[].phases[] | select(.phase == "research") | .score] | if length > 0 then add / length else 0 end) |
        .summary.avg_plan_score = ([.sessions[].phases[] | select(.phase == "planning") | .score] | if length > 0 then add / length else 0 end)' \
        "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"

    echo "✅ Workflow $status: $workflow_id (self-corrections: $self_corrections)"
}

# Function to record pattern capture
record_pattern() {
    local tmp_file="$METRICS_FILE.tmp"
    jq '.summary.patterns_captured += 1' \
        "$METRICS_FILE" > "$tmp_file" && mv "$tmp_file" "$METRICS_FILE"

    echo "🧠 Pattern captured (total: $(jq '.summary.patterns_captured' "$METRICS_FILE"))"
}

# Function to generate metrics report
generate_report() {
    if [ ! -f "$METRICS_FILE" ]; then
        echo "No metrics data available yet."
        return
    fi

    echo "📊 Metrics Report"
    echo "================"
    echo ""

    local total success failed sc_total avg_r avg_p patterns
    total=$(jq '.summary.total_workflows' "$METRICS_FILE")
    success=$(jq '.summary.successful_workflows' "$METRICS_FILE")
    failed=$(jq '.summary.failed_workflows' "$METRICS_FILE")
    sc_total=$(jq '.summary.total_self_corrections' "$METRICS_FILE")
    avg_r=$(jq '.summary.avg_research_score | . * 10 | round / 10' "$METRICS_FILE")
    avg_p=$(jq '.summary.avg_plan_score | . * 10 | round / 10' "$METRICS_FILE")
    patterns=$(jq '.summary.patterns_captured' "$METRICS_FILE")

    local rate="N/A"
    if [ "$total" -gt 0 ]; then
        rate=$(jq -n "$success * 100 / $total | . * 10 | round / 10")%
    fi

    echo "Workflows: $total total | $success success | $failed failed | $rate success rate"
    echo "Quality:   Research avg $avg_r | Plan avg $avg_p"
    echo "Recovery:  $sc_total self-corrections"
    echo "Knowledge: $patterns patterns captured"

    # Show last 5 sessions
    local session_count
    session_count=$(jq '.sessions | length' "$METRICS_FILE")
    if [ "$session_count" -gt 0 ]; then
        echo ""
        echo "Recent workflows (last 5):"
        jq -r '.sessions | .[-5:] | .[] | "  \(.id) | \(.feature) | \(.status) | \(.self_corrections) retries"' "$METRICS_FILE"
    fi
}

# Main command dispatcher
case "${1:-help}" in
    "start")
        record_workflow_start "$2" "$3"
        ;;
    "phase")
        record_phase "$2" "$3" "$4" "$5"
        ;;
    "complete")
        record_workflow_complete "$2" "$3" "$4"
        ;;
    "pattern")
        record_pattern
        ;;
    "report")
        generate_report
        ;;
    "help"|*)
        cat << EOF
Usage: $0 <command> [args]

Commands:
  start <workflow-id> <feature-name>    Record workflow start
  phase <workflow-id> <phase> <score> <duration>  Record phase completion
  complete <workflow-id> <status> <self-corrections>  Record completion
  pattern                               Record pattern capture
  report                                Generate metrics report

Examples:
  $0 start wf-001 "Add Redis caching"
  $0 phase wf-001 research 85 120
  $0 complete wf-001 success 1
  $0 pattern
  $0 report
EOF
        ;;
esac
