# Example: Generate and Publish Workflow

This workflow demonstrates how an agent can generate a changelog for a repository and publish it.

## Steps

### 1. Set up authentication

```bash
export SHIPLOG_API_KEY="sl_your_api_key"
```

### 2. Check available repos

```bash
./scripts/shiplog-api.sh GET /v1/repos | jq '.repos[] | {full_name, id}'
```

### 3. Generate a changelog

```bash
RESULT=$(./scripts/shiplog-api.sh POST /v1/changelog '{"repo": "owner/repo", "auto_publish": false}')
ENTRY_ID=$(echo "$RESULT" | jq -r '.result.entry_id')
echo "Entry ID: $ENTRY_ID"
```

### 4. Review the draft

```bash
./scripts/shiplog-api.sh GET "/v1/changelog/$ENTRY_ID" | jq '.entry.content' -r
```

### 5. Publish

```bash
./scripts/shiplog-api.sh POST "/v1/changelog/$ENTRY_ID/publish" '{"action": "publish"}'
```

## Alternative: Using the CLI

```bash
shiplog repos list
shiplog changelog generate owner/repo
shiplog changelog view <entry_id>
shiplog changelog publish <entry_id>
```
