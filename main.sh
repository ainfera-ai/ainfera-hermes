#!/usr/bin/env bash
# ainfera-hermes — point hermes-agent at Ainfera.
#
# Prereqs: hermes-agent installed (verify: `hermes --version`) + an Ainfera API key.
# Get a key at https://app.ainfera.ai/signup (free $5 launch credit).
#
# STATUS (2026-06-10): routing is correct (CUSTOM_BASE_URL → Ainfera) and the
# old 422 is GONE — the shim now accepts-and-DROPS hermes' toolset (AIN-347,
# surfaced via the x-ainfera-tools-dropped response header), so this returns a
# routed text completion. Caveat: tool-using turns degrade to plain text until
# the shim translates tool calls; real tool_use lives on /v1/inference.

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
The old "422 tool_calling_not_supported_on_shim" is FIXED (the shim now
accepts hermes' toolset and drops it — x-ainfera-tools-dropped header).
Common remaining causes: missing/invalid key (401), no registered agent
on the tenant (400 no_agents_registered), or an unfunded wallet (402
insufficient_funds). For a working routed demo (text + signed audit):
    ./curl-example.sh
───────────────────────────────────────────────────────────────────────
NOTE
  exit 1
fi
