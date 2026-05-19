#!/usr/bin/env bash
# ainfera-hermes — minimal curl-only flow, no hermes-agent install needed.
#
# This shows what hermes-agent does under the hood when pointed at Ainfera:
# register an Agent → fund Wallet → run an Inference → fetch a signed Receipt.

set -euo pipefail

: "${AINFERA_API_KEY:?Set AINFERA_API_KEY first (see README)}"

BASE="${AINFERA_BASE_URL:-https://api.ainfera.ai}"
AGENT="${AINFERA_AGENT:-my-hermes-agent}"

echo "── 1 · Register Agent ($AGENT) ──"
curl -fsS -X POST "$BASE/v1/agents" \
  -H "Authorization: Bearer $AINFERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$AGENT\"}" || true

echo
echo "── 2 · Request a Wallet top-up (launch week: manual approval) ──"
curl -fsS -X POST "$BASE/v1/agents/$AGENT/wallet/topup-request" \
  -H "Authorization: Bearer $AINFERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"amount_usd": 5}' || true

echo
echo "── 3 · Run a signed Inference ──"
curl -fsS -X POST "$BASE/v1/agents/$AGENT/inference" \
  -H "Authorization: Bearer $AINFERA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"claude-opus-4-7","messages":[{"role":"user","content":"Plan a 3-day trip to Lisbon"}]}'
