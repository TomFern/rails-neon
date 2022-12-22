#!/usr/bin/env bash
# Create a new Neon branch. Writes updated environment file.
#
# Usage: create-branch.sh PARENT_BRANCH_NAME OUTPUT_FILE
# Example: create-branch.sh main env-branch

set -e
set -u

parent_name=$1
outfile=$2

parent_id=$(curl -s "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches" \
  -H 'accept: application/json' \
  -H "Authorization: Bearer $NEON_API_KEY" | 
  jq -r ".branches[] | select(.name==\"$parent_name\") | .id")

if [ -z "$parent_id" ]; then
    echo "Unable to find id of parent branch '$parent_name'" >&2
    exit 1
fi

branch_data=$(curl -s -X POST "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $NEON_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
  \"endpoints\": [
    {
      \"type\": \"read_write\"
    }
  ],
  \"branch\": {
    \"parent_id\": \"$parent_id\"
  }
}")

branch_endpoint=$(echo "$branch_data" | jq ' .endpoints[] | .host' | sed 's/"//g')
branch_id=$(echo "$branch_data" | jq ' .branch | .id' | sed 's/"//g')

if [ -z "$branch_endpoint" ] || [ -z "$branch_id" ]; then
    echo "Unable to create new branch" >&2
    exit 1
fi

url=$(echo "$DATABASE_URL" | sed "s/$PGHOST/$branch_endpoint/")

echo "Created branch: $branch_id"

echo "# Generated with create-branch.sh" > $outfile
echo "export BRANCH_ID=$branch_id" >> $outfile
echo "export PGHOST=$branch_endpoint" >> $outfile
echo "export DATABASE_URL=$url" >> $outfile

echo "Wrote environment file: $outfile"