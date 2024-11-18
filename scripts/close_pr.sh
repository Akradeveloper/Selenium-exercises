#!/bin/bash

# Leer los errores del archivo generado en la validación
TOKEN_GITHUB=$1
REPOSITORY=$2
PR=$3
errores=$4

# Si hay errores, agregar un comentario en el PR
if [[ -n "$errores" ]]; then
  echo "Se encontraron errores, enviando comentario en el PR..."
  cat validation_errors.txt

  curl -X POST -H "Authorization: token $TOKEN_GITHUB" \
       -d "{\"body\": \"${errores}\"}" \
       "https://api.github.com/repos/$REPOSITORY/issues/$PR/comments"
else
  echo "No se encontraron errores."
fi

# Opcional: Si deseas cerrar el PR si hay errores graves, lo puedes hacer aquí
curl -X PATCH -H "Authorization: token $TOKEN_GITHUB" \
     -d '{"state": "closed"}' \
     "https://api.github.com/repos/$REPOSITORY/pulls/$PR"
