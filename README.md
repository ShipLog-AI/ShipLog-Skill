# ShipLog Agent Skill

An agent skill for interacting with the ShipLog changelog platform via the ShipLog CLI.

## Quick Install

Install the skill into your project:

```bash
curl -fsSL https://shiplogs.ai/api/install/skill | bash
```

This creates `.agents/skills/shiplog/` with the skill files. Customize the destination:

```bash
SHIPLOG_SKILL_DIR=./my-skills/shiplog curl -fsSL https://shiplogs.ai/api/install/skill | bash
```

## CLI Installation

The skill uses the ShipLog CLI. Install it:

```bash
curl -fsSL https://shiplogs.ai/api/install/cli | bash
```

Or directly via npm:

```bash
npm install -g ShipLog-AI/ShipLog-CLI
```

## What Can Agents Do?

Once the skill is installed, an AI coding agent reading `SKILL.md` will know how to:

- **Authenticate** with the ShipLog API
- **List and manage** connected GitHub repositories
- **Generate** AI-powered changelogs from git history
- **Review and publish** changelog entries
- **Subscribe** users to notifications

## Usage

### For Agents

Place this directory in your project's agent skills folder (e.g., `.agents/skills/shiplog/`). The agent will read `SKILL.md` for instructions.

### For Humans

```bash
# Authenticate
shiplog auth login

# List repos
shiplog repos list

# Generate a changelog
shiplog changelog generate owner/repo

# Publish
shiplog changelog publish <entry_id>
```

## Files

| File | Purpose |
| ---- | ------- |
| `SKILL.md` | Main skill instructions (read by agents) |
| `scripts/shiplog-api.sh` | Helper script for direct API calls |
| `examples/workflow.md` | Example generate → publish workflow |

## Links

- [CLI Repository](https://github.com/ShipLog-AI/ShipLog-CLI)
- [Skill Repository](https://github.com/ShipLog-AI/ShipLog-Skill)
- [Documentation](https://docs-frontend-production.up.railway.app)
- [API Reference](https://docs-frontend-production.up.railway.app/reference/api)

## License

MIT
