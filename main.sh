#!/usr/bin/env bash
# ainfera-hermes — point hermes-agent at Ainfera in 2 env vars.
#
# Prereqs: hermes-agent installed (verify: `hermes --version`) + an Ainfera API key.
# Get a key at https://app.ainfera.ai/signup (free $5 launch credit).

set -euo pipefail

: "${AINFERA_API_KEY:?Set AINFERA_API_KEY first (see README)}"

# Hermes reads a custom OpenAI-compatible endpoint from CUSTOM_BASE_URL, and the
# matching key from OPENAI_API_KEY. NOTE: hermes does NOT read OPENAI_BASE_URL for
# the chat model — CUSTOM_BASE_URL (or a config.yaml provider) is the source of
# truth; OPENAI_BASE_URL is silently ignored and would fall back to the default
# provider. See README "Persistent setup" for the config.yaml alternative.
export CUSTOM_BASE_URL="https://api.ainfera.ai/v1"
export OPENAI_API_KEY="$AINFERA_API_KEY"

# One-shot, non-interactive run. model=ainfera-inference routes through Ainfera —
# do NOT pin a vendor slug here; that bypasses routing + outcome capture (AIN-285).
PROMPT="${1:-Summarize the 3 most-adopted open-source AI agent frameworks today, one tradeoff each, in 5 bullets.}"

hermes chat --provider custom --model ainfera-inference --quiet --query "$PROMPT"
