#!/bin/bash

# Variables
EXERCISE=$1
FOLDER="./ejercicio-$EXERCISE"
ERROR_MESSAGES=""

# Validaciones generales
if [ ! -d "$FOLDER/src/pages" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el directorio src/pages en $FOLDER"
fi

if [ ! -d "$FOLDER/src/tests" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el directorio src/tests en $FOLDER"
fi

if [ ! -f "$FOLDER/.gitignore" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el archivo .gitignore en $FOLDER"
fi

# Verificar si hay archivos de solución
if find "$FOLDER" -type f -name "*solution*" | grep -q .; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de solución en $FOLDER"
fi

# Verificar si hay archivos de ejemplo de test
if find "$FOLDER" -type f -name "*test_example*" | grep -q .; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de test de ejemplo en $FOLDER"
fi

# Verificar comentarios de clase
if ! grep -r "/\*.*\*/" "$FOLDER/src" >/dev/null 2>&1; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de clase en el código de $FOLDER"
fi

# Verificar comentarios de métodos
if ! grep -r "//.*" "$FOLDER/src" >/dev/null 2>&1; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de métodos en el código de $FOLDER"
fi

# Exportar mensajes al archivo de errores
if [ -n "$ERROR_MESSAGES" ]; then
  echo -e "$ERROR_MESSAGES" >> "$ERROR_FILE"
fi

# Salir sin errores para no interrumpir el flujo principal
exit 0
