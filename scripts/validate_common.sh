#!/bin/bash

# Variables
EXERCISE=$1
FOLDER="./ejercicio-$EXERCISE"
ERROR_FLAG=0
ERROR_MESSAGES=""

# General validation checks
if [ ! -d "$FOLDER/src/pages" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el directorio src/pages en $FOLDER"
  ERROR_FLAG=1
fi
if [ ! -d "$FOLDER/src/tests" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el directorio src/tests en $FOLDER"
  ERROR_FLAG=1
fi
if [ ! -f "$FOLDER/.gitignore" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta el archivo .gitignore en $FOLDER"
  ERROR_FLAG=1
fi

# Check for solution files
if find "$FOLDER" -type f -name "*solution*" | grep -q .; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de solución en $FOLDER"
  ERROR_FLAG=1
fi

# Check for example test files
if find "$FOLDER" -type f -name "*test_example*" | grep -q .; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de test de ejemplo en $FOLDER"
  ERROR_FLAG=1
fi

# Check for class comments
if ! grep -r "/\*.*\*/" "$FOLDER/src" >/dev/null 2>&1; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de clase en el código de $FOLDER"
fi

# Check for method comments
if ! grep -r "//.*" "$FOLDER/src" >/dev/null 2>&1; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de métodos en el código de $FOLDER"
fi

# Exportar mensajes de error y estado
echo -e "$ERROR_MESSAGES" >> "$ERROR_FILE"
exit 0