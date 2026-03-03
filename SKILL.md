---
name: ShipLog
description: Manage ShipLog changelogs — list repos, generate changelogs, publish entries, and manage subscriptions via the ShipLog REST API.
---

# ShipLog Agent Skill

This skill lets you interact with the ShipLog platform to manage auto-generated changelogs for GitHub repositories.

## Prerequisites

- A ShipLog API key (create one at **Settings → API Keys** in the dashboard)
- The API key must be set as an environment variable or passed directly

## Authentication

Set the API key as an environment variable:

```bash
export SHIPLOG_API_KEY="sl_your_api_key_here"
```

Or use it directly in requests via the `Authorization: Bearer` header.

## API Base URL

```
https://shiplogs.ai/api
```

## Available Operations

### 1. List Connected Repositories

```bash
curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  https://shiplogs.ai/api/v1/repos | jq
```

Returns: `{ "ok": true, "repos": [...] }`

Each repo has `id`, `full_name`, `schedule_frequency`, and `schedule_auto_publish`.

### 2. Add a Repository

```bash
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/repo-name"}' \
  https://shiplogs.ai/api/v1/repos | jq
```

The repo must be accessible by the ShipLog GitHub App installed on the account.

### 3. Remove a Repository

```bash
curl -s -X DELETE \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  "https://shiplogs.ai/api/v1/repos?id=REPO_UUID" | jq
```

### 4. List Changelogs

```bash
# Public: published entries only
curl -s "https://shiplogs.ai/api/v1/changelog?repo=owner/repo&limit=10" | jq

# Authenticated: include drafts
curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  "https://shiplogs.ai/api/v1/changelog?repo=owner/repo&published=false" | jq
```

Parameters: `repo` (required), `limit` (default 20), `offset`, `published` (default true).

### 5. Generate a Changelog

```bash
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/repo", "auto_publish": false}' \
  https://shiplogs.ai/api/v1/changelog | jq
```

This triggers AI-based changelog generation from recent commits, PRs, and releases. Set `auto_publish: true` to publish immediately.

### 6. View a Single Changelog Entry

```bash
curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  https://shiplogs.ai/api/v1/changelog/ENTRY_ID | jq
```

### 7. Publish a Changelog Entry

```bash
# Publish
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"action": "publish"}' \
  https://shiplogs.ai/api/v1/changelog/ENTRY_ID/publish | jq

# Unpublish
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"action": "unpublish"}' \
  https://shiplogs.ai/api/v1/changelog/ENTRY_ID/publish | jq
```

### 8. Subscribe to Notifications (Public)

```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "repo": "owner/repo"}' \
  https://shiplogs.ai/api/subscribe | jq
```

## Common Workflows

### Generate and Publish a Changelog

```bash
# 1. List repos to find the target
REPOS=$(curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" https://shiplogs.ai/api/v1/repos)
echo "$REPOS" | jq '.repos[] | {id, full_name, schedule_frequency}'

# 2. Generate a changelog for a repo
RESULT=$(curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/repo", "auto_publish": false}' \
  https://shiplogs.ai/api/v1/changelog)

ENTRY_ID=$(echo "$RESULT" | jq -r '.result.entry_id')
echo "Generated entry: $ENTRY_ID"

# 3. View the draft
curl -s -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  https://shiplogs.ai/api/v1/changelog/$ENTRY_ID | jq '.entry.content'

# 4. Publish it
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"action": "publish"}' \
  https://shiplogs.ai/api/v1/changelog/$ENTRY_ID/publish | jq
```

### Add a New Repo and Generate First Changelog

```bash
# 1. Add the repo
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/new-repo"}' \
  https://shiplogs.ai/api/v1/repos | jq

# 2. Generate and auto-publish
curl -s -X POST \
  -H "Authorization: Bearer $SHIPLOG_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"repo": "owner/new-repo", "auto_publish": true}' \
  https://shiplogs.ai/api/v1/changelog | jq
```

## CLI Alternative

If the ShipLog CLI is installed, you can use it instead of curl:

```bash
shiplog auth login --key $SHIPLOG_API_KEY
shiplog repos list
shiplog repos add owner/repo
shiplog changelog generate owner/repo
shiplog changelog publish ENTRY_ID
shiplog changelog view ENTRY_ID
```

Install: `npm install -g @shiplog/cli`

## Error Handling

All errors return JSON: `{ "error": "message" }`

| Code | Meaning |
|------|---------|
| 400 | Bad request (missing params) |
| 401 | Invalid or missing API key |
| 403 | Plan limit reached |
| 404 | Resource not found |
| 502 | GitHub API error |

## Documentation

Full API reference: https://docs-frontend-production.up.railway.app/reference/api
