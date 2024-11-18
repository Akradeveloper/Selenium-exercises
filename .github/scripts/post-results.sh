#!/bin/bash

ERROR_FLAG=$1
ERROR_MESSAGES=$2
PR_NUMBER=$3

if [ "$ERROR_FLAG" -eq 1 ]; then
  curl -X POST -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
    -d "{\"body\": \"❌ Errores encontrados en la validación del PR:\n$ERROR_MESSAGES\"}" \
    "https://api.github.com/repos/${{ github.repository }}/issues/$PR_NUMBER/comments"
else
  curl -X POST -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
    -d "{\"body\": \"✅ Validación completada sin errores.\"}" \
    "https://api.github.com/repos/${{ github.repository }}/issues/$PR_NUMBER/comments"
fi
