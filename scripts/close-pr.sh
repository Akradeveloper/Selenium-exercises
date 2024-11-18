#!/bin/bash

PR_NUMBER=$1

# Cerrar el PR si hubo un error
curl -X PATCH -H "Authorization: token ${{ secrets.TOKEN_GITHUB }}" \
  -d "{\"state\": \"closed\"}" \
  "https://api.github.com/repos/${{ github.repository }}/pulls/$PR_NUMBER"
