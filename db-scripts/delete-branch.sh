#!/usr/bin/env bash
# Delete Neon branch
#
# Usage: delete-branch.sh BRANCH_ID
# Example: delete-branch.sh br-dawn-shape-137746

set -e 
set -u

branch_id=$1

id=$(curl -s -X 'DELETE' \
  "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches/$branch_id" \
  -H "accept: application/json" \
  -H "Authorization: Bearer $NEON_API_KEY"  |
  jq ' .branch | .id ' | sed 's/"//g')

echo "Deleted branch: $id"