# ainfera-hermes — hermes-agent + Ainfera

**Point hermes-agent at Ainfera Routing** — routed inference + a signed, hash-chained audit log underneath, wired through hermes' custom OpenAI-compatible provider.

> **Status (2026-06).** Routed **text** inference + signed audit work today — see [Quickstart](#quickstart-works-today). Hermes' agentic **tool-use does not round-trip yet**: hermes attaches its toolset to every request, and Ainfera's OpenAI-compatible `/v1/chat/completions` shim returns `422 tool_calling_not_supported_on_shim`. Full hermes tool-use lands when the shim translates tool calls (or via the native `/v1/inference` API). Until then, `main.sh` surfaces that 422 and points you here.

## Quickstart (works today)

Routed text inference + a verifiable audit chain — no `hermes-agent` install needed. The script signs up a throwaway Agent if you don't pass a key:

```bash
git clone https://github.com/ainfera-ai/ainfera-hermes
cd ainfera-hermes
AINFERA_API_KEY=ai_infera_... ./curl-example.sh        # or omit the key to self-mint one
```

Each call routes through Ainfera (`model: ainfera-inference`) and returns a receipt + an `audit_verify_url`.

## Configure hermes for Ainfera

Point hermes at Ainfera's OpenAI-compatible endpoint with two env vars:

```bash
export CUSTOM_BASE_URL=https://api.ainfera.ai/v1         # hermes reads CUSTOM_BASE_URL — NOT OPENAI_BASE_URL
export OPENAI_API_KEY=ai_infera_...                      # your Ainfera key — https://app.ainfera.ai/signup
hermes chat --provider custom --model ainfera-inference -q "…"
```

> **Why `CUSTOM_BASE_URL`, not `OPENAI_BASE_URL`?** Hermes treats `config.yaml` /
> `CUSTOM_BASE_URL` as the single source of truth for the chat model's endpoint and
> **ignores `OPENAI_BASE_URL`** — setting that var silently falls back to the default
> provider (sending your key to the wrong endpoint). `OPENAI_API_KEY` is the auth
> fallback for any custom endpoint.

The routing is correct (the request reaches Ainfera), but per the status note the
`hermes chat` call above returns `422` until the shim supports tool calls. `./main.sh`
runs this same wiring and reports that clearly.

Through Ainfera Routing you get:

- Signed Agent Card identity (L1)
- Per-call budget enforcement on routed inference (L3)
- Hash-chained audit per call, verifiable offline (L4)
- 5 frontier models via one key: Claude Opus 4.7 · GPT-5.5 · Gemini 3.1 Pro · Grok 4 · Mistral Large 3 — selected by routing (you send `ainfera-inference`)

> EU AI Act Annex IV ready — every call hash-chained, signed, exportable.

## Persistent setup (optional)

Prefer not to export env vars each shell? Add Ainfera as a named provider in
`~/.hermes/config.yaml` once — your key stays in `AINFERA_API_KEY`, no aliasing:

```yaml
providers:
  ainfera:
    name: Ainfera
    base_url: https://api.ainfera.ai/v1
    default_model: ainfera-inference
    key_env: AINFERA_API_KEY
```

Then point hermes at it with `--provider ainfera` (same tool-use caveat applies).

## What this proves

Pointing hermes-agent at Ainfera adds signed identity, Ainfera Routing, and a verifiable audit log without changing your prompt structure. The `custom` provider points hermes at Ainfera's OpenAI-compatible endpoint, which routes every Inference through Ainfera; Ainfera signs the receipt and writes the AuditEvent into your Agent's chain. (Tool-using turns await shim tool-call translation — see the status note.)

See the [Hermes Pool](https://ainfera.ai/hermes) landing page for the full pitch + companion concept pages.

## Verify the audit chain

Each call returns a receipt and an `audit_verify_url`. Verify the chain any time
(public, no auth):

```bash
curl https://api.ainfera.ai/v1/audit/<your-agent-id>/verify
```

Or offline:

```bash
pip install ainfera-verify
ainfera-verify chain <your-agent-id>
```

## Disclaimer

`hermes-agent` is the [NousResearch](https://github.com/NousResearch) framework. This repository is not affiliated with NousResearch — it's a curated landing for builders who already use it.

## License

Apache 2.0. See [LICENSE](./LICENSE).
