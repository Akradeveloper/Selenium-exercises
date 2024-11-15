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
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/pages (Java)"
                ERROR_FLAG=1
              else
                # Validar que contiene métodos clave
                if ! grep -q 'driver.get("https://www.telerik.com/")' "$FOLDER/src/pages/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para navegar a https://www.telerik.com en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'driver.findElement(By.*).click()' "$FOLDER/src/pages/HomePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para hacer clic en un enlace en HomePage.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

            # Validar DemoPage.java
            if [ ! -f "$FOLDER/src/pages/DemoPage.java" ]; then
              ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo DemoPage.java en $FOLDER/src/pages (Java)"
              ERROR_FLAG=1
            else
              # Validar que contiene método para verificar el título
              if ! grep -q 'assert.*getTitle.*"Demos"' "$FOLDER/src/pages/DemoPage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un método para verificar el título en DemoPage.java (Java)"
                ERROR_FLAG=1
              fi
            fi

            # Validar HomeTest.java
            if [ ! -f "$FOLDER/src/tests/HomeTest.java" ]; then
              ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomeTest.java en $FOLDER/src/tests (Java)"
              ERROR_FLAG=1
            else
              # Validar que usa HomePage y DemoPage
              if ! grep -q 'HomePage homePage = new HomePage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de HomePage en HomeTest.java (Java)"
                ERROR_FLAG=1
              fi
              if ! grep -q 'DemoPage demoPage = new DemoPage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de DemoPage en HomeTest.java (Java)"
                ERROR_FLAG=1
              fi
            fi

# Output errors if any
if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados en el ejercicio $EXERCISE:\n$ERROR_MESSAGES"
  exit 1
fi
