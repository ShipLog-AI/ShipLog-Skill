# ShipLog Agent Skill

An agent skill for interacting with the ShipLog changelog platform.

## What is this?

This is an "agent skill" — a structured set of instructions, scripts, and examples that help AI coding agents (like Gemini, Copilot, or custom agents) interact with the ShipLog API. Drop this directory into your project and your agent will know how to:

- List and manage connected GitHub repos
- Generate AI-powered changelogs
- Publish and unpublish changelog entries
- Subscribe users to notifications

## Usage

### For Agents

Place this directory in your project's agents skills folder (e.g., `.agents/skills/shiplog/`). The agent will read `SKILL.md` for instructions.

### For Humans

See `SKILL.md` for the full API reference and `examples/workflow.md` for common workflows.

### Quick API Test

```bash
export SHIPLOG_API_KEY="sl_your_api_key"
chmod +x scripts/shiplog-api.sh
./scripts/shiplog-api.sh GET /v1/repos
```

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Main skill instructions (read by agents) |
| `scripts/shiplog-api.sh` | Helper script for API calls |
| `examples/workflow.md` | Example generate → publish workflow |

## License

MIT
