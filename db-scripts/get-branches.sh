#!/usr/bin/env bash
# List the IDs of all existing branches IDs

set -e

curl -s "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches" \
  -H 'accept: application/json' \
  -H "Authorization: Bearer $NEON_API_KEY" | 
  jq -r ".branches[] | .id"