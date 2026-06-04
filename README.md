# ainfera-hermes — hermes-agent + Ainfera

**Hermes integration + Ainfera Routing.** Same agent loop — 2 env vars. Routed inference + signed audit underneath.

## Two env-var change

```bash
export HERMES_INFERENCE_BASE_URL=https://api.ainfera.ai/v1
export HERMES_API_KEY=ainfera_...                      # https://app.ainfera.ai/signup
```

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
export AINFERA_API_KEY=ainfera_...
./main.sh
```

Or with `curl` only — no `hermes-agent` install needed:

```bash
AINFERA_API_KEY=ainfera_... ./curl-example.sh
```

## What this proves

Pointing hermes-agent at Ainfera adds signed identity, Ainfera Routing, and a verifiable audit log without changing your agent loop or prompt structure. The `HERMES_INFERENCE_BASE_URL` hook routes every Inference through Ainfera; Ainfera signs the receipt and writes the AuditEvent into your Agent's chain.

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
