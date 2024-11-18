#!/bin/bash

LANGUAGE=$1
EXERCISES=$2

# Aquí puedes realizar la validación de los ejercicios
# Para el ejemplo, simulamos un error si hay ejercicios marcados

if [ -z "$EXERCISES" ]; then
  ERROR_FLAG=0
  ERROR_MESSAGES="No hay ejercicios para validar."
else
  ERROR_FLAG=1
  ERROR_MESSAGES="Errores en la validación de ejercicios."
fi

# Exportar los resultados para usarlos en el siguiente paso
echo "ERROR_FLAG=$ERROR_FLAG" >> $GITHUB_ENV
echo "ERROR_MESSAGES=$ERROR_MESSAGES" >> $GITHUB_ENV
