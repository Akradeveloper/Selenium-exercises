#!/bin/bash

# Accede a las variables del PR pasadas como entorno a través del contexto
PR_BODY="${{ github.event.pull_request.body }}"
PR_TITLE="${{ github.event.pull_request.title }}"
PR_NUMBER="${{ github.event.pull_request.number }}"

# Imprime los detalles
echo "PR Body: $PR_BODY"
echo "PR Title: $PR_TITLE"
echo "PR Number: $PR_NUMBER"
EXERCISES=""
LANGUAGE=""

# Detectar el lenguaje
if echo "$PR_BODY" | grep -q '\- \[X\] Java'; then
  LANGUAGE="java"
elif echo "$PR_BODY" | grep -q '\- \[X\] JS'; then
  LANGUAGE="javascript"
else
  echo "ERROR: No se especificó el lenguaje de programación o más de uno fue marcado."
  exit 1
fi

# Detectar los ejercicios seleccionados
for i in {1..9}; do
  if echo "$PR_BODY" | grep -q "\- \[X\] Ejercicio $i"; then
    EXERCISES="$EXERCISES $i"
  fi
done

if [ -z "$EXERCISES" ]; then
  echo "ERROR: No se marcaron ejercicios para validar."
  exit 1
fi

# Guardar las variables en archivos para el siguiente paso
echo "$LANGUAGE" > .language
echo "$EXERCISES" > .exercises

echo "Detalles del PR obtenidos: Lenguaje=$LANGUAGE, Ejercicios=$EXERCISES"
