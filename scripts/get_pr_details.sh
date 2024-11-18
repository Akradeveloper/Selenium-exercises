#!/bin/bash
# Accede a las variables del PR pasadas como entorno
PR_BODY="${PR_BODY}"
PR_TITLE="${PR_TITLE}"
PR_NUMBER="${PR_NUMBER}"

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
