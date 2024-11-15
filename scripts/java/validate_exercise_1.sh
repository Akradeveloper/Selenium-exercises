#!/bin/bash

EXERCISE=1
# Llamar a las validaciones comunes
bash /scripts/validate_common.sh $EXERCISE

# Aquí van las validaciones específicas para el ejercicio 1
FOLDER="./ejercicio-$EXERCISE"
ERROR_FLAG=0
ERROR_MESSAGES=""

mvn -f "$FOLDER/pom.xml" checkstyle:check || ERROR_FLAG=1
# Validaciones específicas para el ejercicio 1
if [ ! -f "$FOLDER/src/pages/LoginPage.java" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginPage.java en el directorio Pages (Java)"
  ERROR_FLAG=1
else
  if ! grep -q 'https://www.saucedemo.com' "$FOLDER/src/pages/LoginPage.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró referencia a https://www.saucedemo.com en LoginPage.java (Java)"
    ERROR_FLAG=1
  fi
  if ! grep -E 'By\..*username|By\..*password|By\..*login-button' "$FOLDER/src/pages/LoginPage.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontraron selectores de usuario, contraseña o botón de login en LoginPage.java (Java)"
    ERROR_FLAG=1
  fi
fi

# Validar LoginTest.java
if [ ! -f "$FOLDER/src/tests/LoginTest.java" ]; then
  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginTest.java en el directorio Test (Java)"
  ERROR_FLAG=1
else
  if ! grep -r "assert.*getTitle.*\"Swag Labs\"" "$FOLDER/src/test/java/LoginTest.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginTest.java en el directorio Test (Java)"
    ERROR_FLAG=1
  fi
  if ! grep -r "await driver.getTitle().contains.*'Swag Labs'" "$FOLDER/src/test/java/LoginTest.java"; then
    ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un assert para el título en el test de LoginTest (Java)"
    ERROR_FLAG=1
  fi
fi

# Output errors if any
if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados en el ejercicio $EXERCISE:\n$ERROR_MESSAGES"
  echo -e "Errores encontrados durante la validación:\n$ERROR_MESSAGES"
            curl -X POST -H "Authorization: token ${{ secrets.TOKEN_GITHUB }}" \
              -d "{\"body\": \"Errores encontrados en la validación del PR:\n$ERROR_MESSAGES\"}" \
              "https://api.github.com/repos/${{ github.repository }}/issues/${{ github.event.pull_request.number }}/comments"
  exit 1
fi
