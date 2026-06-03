#!/usr/bin/env bash
# ainfera-hermes — point hermes-agent at Ainfera.
#
# Prereqs: hermes-agent installed (verify: `hermes --version`) + an Ainfera API key.
# Get a key at https://app.ainfera.ai/signup (free $5 launch credit).
#
# STATUS: routing is correct (CUSTOM_BASE_URL → Ainfera), but hermes attaches a
# toolset to every request and Ainfera's OpenAI-compatible /v1/chat/completions
# shim does not yet translate tool calls — so this currently returns HTTP 422.
# Routed TEXT inference + signed audit work today via ./curl-example.sh. This
# script starts working automatically once the shim supports tool calls.

set -euo pipefail

: "${AINFERA_API_KEY:?Set AINFERA_API_KEY first (see README)}"

# Hermes reads the custom OpenAI-compatible endpoint from CUSTOM_BASE_URL (NOT
# OPENAI_BASE_URL — that is ignored for the chat model) and the key from
# OPENAI_API_KEY. See README "Persistent setup" for the config.yaml alternative.
export CUSTOM_BASE_URL="https://api.ainfera.ai/v1"
export OPENAI_API_KEY="$AINFERA_API_KEY"

# model=ainfera-inference routes through Ainfera — do NOT pin a vendor slug here;
# that bypasses routing + outcome capture (AIN-285).
PROMPT="${1:-Summarize the 3 most-adopted open-source AI agent frameworks today, one tradeoff each, in 5 bullets.}"

if ! hermes chat --provider custom --model ainfera-inference --quiet --query "$PROMPT"; then
  cat >&2 <<'NOTE'

── hermes call failed ─────────────────────────────────────────────────
If this is "422 tool_calling_not_supported_on_shim": that is expected today.
hermes sends tools and Ainfera's /v1/chat/completions shim does not yet
translate tool calls. Routing IS correct — the request reached Ainfera.
For a working routed demo right now (text + signed audit), run:
    ./curl-example.sh
───────────────────────────────────────────────────────────────────────
NOTE
  exit 1
fi
