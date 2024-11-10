#!/bin/bash

# Variables
REPO_OWNER="Akradeveloper"  # Dueño del repositorio
REPO_NAME="Selenium-exercises"  # Nombre del repositorio
GITHUB_TOKEN="${{ secrets.MY_GITHUB_PAT }}"  # Token de acceso personal (usado en GitHub Actions)
WORKFLOW_NAME="validate.yml"  # Nombre del workflow que quieres ejecutar
REF="${{ github.head_ref }}"  # Rama que quieres usar como referencia (puedes cambiar a cualquier rama específica)

# Llamada API para activar el workflow
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"ref\":\"$REF\"}" \
  "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/workflows/$WORKFLOW_NAME/dispatches"
