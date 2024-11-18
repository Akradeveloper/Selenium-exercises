#!/bin/bash

# Leer los errores del archivo generado en la validación
errores=$(cat validation_errors.txt)

# Si hay errores, agregar un comentario en el PR
if [[ -n "$errores" ]]; then
  echo "Se encontraron errores, enviando comentario en el PR..."

  curl -X POST -H "Authorization: token $TOKEN_GITHUB" \
       -d "{\"body\": \"${errores}\"}" \
       "https://api.github.com/repos/${{ github.repository }}/issues/${{ github.event.pull_request.number }}/comments"
else
  echo "No se encontraron errores."
fi

# Opcional: Si deseas cerrar el PR si hay errores graves, lo puedes hacer aquí
curl -X PATCH -H "Authorization: token $TOKEN_GITHUB" \
     -d '{"state": "closed"}' \
     "https://api.github.com/repos/${{ github.repository }}/pulls/${{ github.event.pull_request.number }}"
