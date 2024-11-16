#!/bin/bash
# Close the PR if there are validation errors

if [ "$1" == "true" ]; then
  echo "Closing PR due to validation errors..."
  curl -X POST -H "Authorization: token ${{ secrets.TOKEN_GITHUB }}" \
    -d "{\"body\": \"Auto-closing pull request\"}" \
    "https://api.github.com/repos/${{ github.repository }}/issues/${{ github.event.pull_request.number }}/comments"
  exit 0
fi
