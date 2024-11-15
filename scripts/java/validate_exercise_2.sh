#!/bin/bash

EXERCISE=1
# Llamar a las validaciones comunes
bash scripts/validate_common.sh $EXERCISE

# Aquí van las validaciones específicas para el ejercicio 1
FOLDER="./ejercicio-$EXERCISE"
ERROR_FLAG=0
ERROR_MESSAGES=""
 
mvn -f "$FOLDER/pom.xml" checkstyle:check || ERROR_FLAG=1
# Validar existencia de FormPage.java
              if [ ! -f "$FOLDER/src/pages/FormPage.java" ]; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormPage.java en el directorio src/pages (Java)"
                ERROR_FLAG=1
              else
                # Verificar referencias a elementos del formulario
                if ! grep -q 'By.*name.*"firstName"' "$FOLDER/src/pages/FormPage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un selector para el campo de nombre en FormPage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'By.*email.*"userEmail"' "$FOLDER/src/pages/FormPage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un selector para el campo de correo electrónico en FormPage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'By.*button.*"submit"' "$FOLDER/src/pages/FormPage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un selector para el botón de envío en FormPage.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

              # Validar existencia de FormTest.java
            if [ ! -f "$FOLDER/src/tests/FormTest.java" ]; then
              ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormTest.java en el directorio src/tests (Java)"
              ERROR_FLAG=1
            else
              # Verificar la validación del mensaje de éxito
              if ! grep -q 'assert.*getText.*"Thank you"' "$FOLDER/src/tests/FormTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró la validación del mensaje de éxito en FormTest.java (Java)"
                ERROR_FLAG=1
              fi
            fi

# Output errors if any
if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados en el ejercicio $EXERCISE:\n$ERROR_MESSAGES"
  exit 1
fi
