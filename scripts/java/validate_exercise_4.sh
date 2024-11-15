#!/bin/bash

EXERCISE=1
# Llamar a las validaciones comunes
bash scripts/validate_common.sh $EXERCISE

# Aquí van las validaciones específicas para el ejercicio 1
FOLDER="./ejercicio-$EXERCISE"
ERROR_FLAG=0
ERROR_MESSAGES=""
 
mvn -f "$FOLDER/pom.xml" checkstyle:check || ERROR_FLAG=1
# Validar HomePage.java
              if [ ! -f "$FOLDER/src/pages/HomePage.java" ]; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo WaitExamplePage.java en $FOLDER/src/pages (Java)"
                ERROR_FLAG=1
              else
                # Validar que contiene métodos clave
                if ! grep -q 'driver.get("https://www.telerik.com/")' "$FOLDER/src/pages/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para navegar a https://www.telerik.com en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'WebDriverWait' "$FOLDER/src/pages/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriverWait para esperas explícitas en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'driver.findElement(By.*).click()' "$FOLDER/src/pages/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para hacer clic en un botón en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

              # Validar HomePage.java
              if [ ! -f "$FOLDER/src/tests/HomePage.java" ]; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/tests (Java)"
                ERROR_FLAG=1
              else
                # Validar que usa HomePage
                if ! grep -q 'HomePage waitPage = new HomePage' "$FOLDER/src/tests/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de HomePage en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
                # Validar que contiene una aserción para confirmar la acción
                if ! grep -q 'assert.*getTitle.*"Expected Title"' "$FOLDER/src/tests/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró una aserción para verificar la acción en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

# Output errors if any
if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados en el ejercicio $EXERCISE:\n$ERROR_MESSAGES"
  exit 1
fi
