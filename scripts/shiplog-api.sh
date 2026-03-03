#!/usr/bin/env bash
# ShipLog API helper — call ShipLog endpoints with minimal boilerplate.
# Usage: ./shiplog-api.sh <method> <path> [json_body]
# Requires: SHIPLOG_API_KEY env var

set -euo pipefail

API_URL="${SHIPLOG_API_URL:-https://shiplogs.ai/api}"
API_KEY="${SHIPLOG_API_KEY:?Set SHIPLOG_API_KEY environment variable}"

METHOD="${1:?Usage: shiplog-api.sh <GET|POST|DELETE> <path> [body]}"
PATH_SEGMENT="${2:?Usage: shiplog-api.sh <method> <path> [body]}"
BODY="${3:-}"

ARGS=(
  -s
  -X "$METHOD"
  -H "Authorization: Bearer $API_KEY"
  -H "Content-Type: application/json"
)

if [ -n "$BODY" ]; then
  ARGS+=(-d "$BODY")
fi

curl "${ARGS[@]}" "${API_URL}${PATH_SEGMENT}"
