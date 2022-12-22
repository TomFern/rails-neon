# get projects

# curl 'https://console.neon.tech/api/v2/projects' \
#   -H 'Accept: application/json' \
#   -H "Authorization: Bearer $NEON_API_KEY" | jq

# get branches

curl "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches" \
  -H 'accept: application/json' \
  -H "Authorization: Bearer $NEON_API_KEY" | jq

# create branch (you need the id of the parent branch)

curl -X POST "https://console.neon.tech/api/v2/projects/$NEON_PROJECT_ID/branches" \
  -H 'Accept: application/json' \
  -H "Authorization: Bearer $NEON_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{
  "endpoints": [
    {
      "type": "read_write"
    }
  ],
  "branch": {
    "parent_id": "br-blue-feather-415684"
  }
}' | jq