---
name: ShipLog
description: Manage ShipLog changelogs — list repos, generate changelogs, publish entries via the ShipLog CLI.
---

# ShipLog Agent Skill

This skill lets you interact with the ShipLog platform to manage auto-generated changelogs for GitHub repositories.

## Setup

### 1. Install the CLI

```bash
curl -fsSL https://shiplogs.ai/api/install/cli | bash
```

Or install directly via npm:

```bash
npm install -g ShipLog-AI/ShipLog-CLI
```

### 2. Authenticate

```bash
shiplog auth login --key "$SHIPLOG_API_KEY"
```

Or set the API key in the environment:

```bash
export SHIPLOG_API_KEY="sl_your_api_key_here"
shiplog auth login --key "$SHIPLOG_API_KEY"
```

## Available Commands

### Repositories

```bash
# List connected repos
shiplog repos list

# Add a new repo
shiplog repos add owner/repo

# Remove a repo
shiplog repos remove <repo_id>
```

### Changelogs

```bash
# List changelog entries for a repo
shiplog changelog list owner/repo

# Generate a changelog (creates a draft)
shiplog changelog generate owner/repo

# Generate and auto-publish
shiplog changelog generate owner/repo --publish

# View a specific entry
shiplog changelog view <entry_id>

# Publish a draft
shiplog changelog publish <entry_id>

# Unpublish
shiplog changelog publish <entry_id> --unpublish
```

### Authentication & Config

```bash
# Check auth status
shiplog auth whoami

# Change base URL (for self-hosted instances)
shiplog config set api_url https://your-instance.com

# View config file location
shiplog config path
```

## Common Workflows

### Generate and Publish a Changelog

```bash
# 1. List repos to find the target
shiplog repos list

# 2. Generate a changelog
shiplog changelog generate owner/repo

# 3. List entries to find the new draft
shiplog changelog list owner/repo

# 4. Review the content
shiplog changelog view <entry_id>

# 5. Publish
shiplog changelog publish <entry_id>
```

### Add a New Repo and Generate First Changelog

```bash
# 1. Add the repo
shiplog repos add owner/new-repo

# 2. Generate and auto-publish
shiplog changelog generate owner/new-repo --publish
```

### CI/CD: Auto-Generate on Release

```bash
shiplog auth login --key "$SHIPLOG_API_KEY"
shiplog changelog generate owner/repo --publish
```

## API Fallback

If the CLI is not available, you can use curl directly:

```bash
# List repos
curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  https://shiplogs.ai/api/v1/repos | jq

# Add a repo
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/repo"}' \
  https://shiplogs.ai/api/v1/repos | jq

# Generate a changelog
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/repo", "auto_publish": false}' \
  https://shiplogs.ai/api/v1/changelog | jq

# Publish
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"action": "publish"}' \
  https://shiplogs.ai/api/v1/changelog/ENTRY_ID/publish | jq
```

## Error Handling

All CLI commands exit with code 1 on error and print a message prefixed with `✗`. Common errors:

| Error | Cause |
| ----- | ----- |
| `Not authenticated` | Run `shiplog auth login` first |
| `Plan limit reached` | Upgrade plan or remove unused repos |
| `Repository not found` | Repo not accessible by ShipLog GitHub App |

## Links

- [CLI Repository](https://github.com/ShipLog-AI/ShipLog-CLI)
- [Full API Reference](https://docs-frontend-production.up.railway.app/reference/api)
- [CLI Reference](https://docs-frontend-production.up.railway.app/reference/cli)
