#!/usr/bin/env bash
# ainfera-hermes — point hermes-agent at Ainfera in 2 env vars.
#
# Prereqs: hermes-agent installed locally + an Ainfera API key.
# Get a key at https://app.ainfera.ai/signup (free $5 launch credit).

set -euo pipefail

: "${AINFERA_API_KEY:?Set AINFERA_API_KEY first (see README)}"

export HERMES_INFERENCE_BASE_URL="https://api.ainfera.ai/v1"
export HERMES_API_KEY="$AINFERA_API_KEY"
export HERMES_DEFAULT_MODEL="claude-opus-4-7"

# Run a sample hermes-agent task. Replace with your own loop / yaml.
hermes-agent run "${1:-examples/research-task.yaml}"
