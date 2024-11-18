#!/bin/bash

PR_DESCRIPTION=$1

# Detectar el lenguaje de programación
if echo "$PR_DESCRIPTION" | grep -q '\- \[X\] Java'; then
  LANGUAGE="java"
elif echo "$PR_DESCRIPTION" | grep -q '\- \[X\] JS'; then
  LANGUAGE="javascript"
else
  echo "ERROR: No se especificó el lenguaje de programación o más de uno fue marcado."
  exit 1
fi

# Detectar los ejercicios
EXERCISES=""
for i in {1..9}; do
  if echo "$PR_DESCRIPTION" | grep -q "\- \[X\] Ejercicio $i"; then
    EXERCISES="$EXERCISES $i"
  fi
done

if [ -z "$EXERCISES" ]; then
  echo "ERROR: No se marcaron ejercicios para validar."
  exit 1
fi

# Guardar los resultados en el archivo para su uso posterior
echo "LANGUAGE=$LANGUAGE" >> pr_info.txt
echo "EXERCISES=$EXERCISES" >> pr_info.txt
echo "pr_number=$PR_NUMBER" >> pr_info.txt
