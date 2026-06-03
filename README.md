# ainfera-hermes — hermes-agent + Ainfera

**Hermes integration + Ainfera Routing.** Same agent loop — 2 env vars. Routed inference + signed audit underneath.

## Two env-var change

```bash
export CUSTOM_BASE_URL=https://api.ainfera.ai/v1         # hermes reads CUSTOM_BASE_URL — not OPENAI_BASE_URL
export OPENAI_API_KEY=ai_infera_...                      # your Ainfera key — https://app.ainfera.ai/signup
```

Then run with the `custom` provider and the routed model:

```bash
hermes chat --provider custom --model ainfera-inference -q "Plan a 3-day trip to Lisbon in under 80 words."
```

> **Why `CUSTOM_BASE_URL`, not `OPENAI_BASE_URL`?** Hermes treats `config.yaml` /
> `CUSTOM_BASE_URL` as the single source of truth for the chat model's endpoint and
> **ignores `OPENAI_BASE_URL`** — setting that var silently falls back to the default
> provider (sending your key to the wrong endpoint). `OPENAI_API_KEY` is the auth
> fallback for any custom endpoint.

Your existing hermes-agent code keeps working. You now have:

- Signed Agent Card identity (L1)
- Per-call budget enforcement on routed inference (L3)
- Hash-chained audit per call, verifiable offline (L4)
- 5 frontier models via one key: Claude Opus 4.7 · GPT-5.5 · Gemini 3.1 Pro · Grok 4 · Mistral Large 3

> EU AI Act Annex IV ready — every call hash-chained, signed, exportable.

## Quickstart

If you have `hermes-agent` installed:

```bash
git clone https://github.com/ainfera-ai/ainfera-hermes
cd ainfera-hermes
export AINFERA_API_KEY=ai_infera_...
./main.sh
```

Or with `curl` only — no `hermes-agent` install needed:

```bash
AINFERA_API_KEY=ai_infera_... ./curl-example.sh
```

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

Then every run is just:

```bash
export AINFERA_API_KEY=ai_infera_...
hermes chat --provider ainfera -q "Plan a 3-day trip to Lisbon in under 80 words."
```

## What this proves

Pointing hermes-agent at Ainfera adds signed identity, Ainfera Routing, and a verifiable audit log without changing your agent loop or prompt structure. The `custom` provider points hermes at Ainfera's OpenAI-compatible endpoint, which routes every Inference through Ainfera; Ainfera signs the receipt and writes the AuditEvent into your Agent's chain.

See the [Hermes Pool](https://ainfera.ai/hermes) landing page for the full pitch + companion concept pages.

## Verify the audit chain

After running, each call returns a receipt URL. You can also verify offline:

```bash
pip install ainfera-verify
ainfera-verify chain <your-agent-id>
```

## Disclaimer

`hermes-agent` is the [NousResearch](https://github.com/NousResearch) framework. This repository is not affiliated with NousResearch — it's a curated landing for builders who already use it.

## License

Apache 2.0. See [LICENSE](./LICENSE).
