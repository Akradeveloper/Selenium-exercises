#!/bin/bash

# Definir el ejercicio actual
EXERCISE=1
FOLDER="./ejercicio-$EXERCISE"

# Inicializar indicadores de error y mensajes
ERROR_FLAG=0
ERROR_MESSAGES=""

# Llamar a las validaciones comunes
if ! bash ./scripts/validate_common.sh "$EXERCISE"; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falló la validación común para el ejercicio $EXERCISE."
  ERROR_FLAG=1
fi

# Validaciones específicas para el ejercicio 1
# 1. Verificar la estructura y contenido del archivo LoginPage.java
if [ ! -f "$FOLDER/src/pages/LoginPage.java" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginPage.java en el directorio Pages (Java)."
  ERROR_FLAG=1
else
  if ! grep -q 'https://www.saucedemo.com' "$FOLDER/src/pages/LoginPage.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró referencia a 'https://www.saucedemo.com' en LoginPage.java (Java)."
    ERROR_FLAG=1
  fi
  if ! grep -E 'By\..*username|By\..*password|By\..*login-button' "$FOLDER/src/pages/LoginPage.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontraron selectores 'username', 'password' o 'login-button' en LoginPage.java (Java)."
    ERROR_FLAG=1
  fi
fi

# 2. Validar LoginTest.java
if [ ! -f "$FOLDER/src/tests/LoginTest.java" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginTest.java en el directorio Test (Java)."
  ERROR_FLAG=1
else
  if ! grep -q 'assert.*getTitle.*"Swag Labs"' "$FOLDER/src/tests/LoginTest.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un assert verificando el título 'Swag Labs' en LoginTest.java (Java)."
    ERROR_FLAG=1
  fi
fi

# 3. Verificar calidad del código con Checkstyle
if ! mvn -f "$FOLDER/pom.xml" checkstyle:check; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falló la validación de Checkstyle en el proyecto (Java)."
  ERROR_FLAG=1
fi


