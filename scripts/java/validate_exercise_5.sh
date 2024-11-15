#!/bin/bash

EXERCISE=1
# Llamar a las validaciones comunes
bash scripts/validate_common.sh $EXERCISE

# Aquí van las validaciones específicas para el ejercicio 1
FOLDER="./ejercicio-$EXERCISE"
ERROR_FLAG=0
ERROR_MESSAGES=""
 
mvn -f "$FOLDER/pom.xml" checkstyle:check || ERROR_FLAG=1
# Validar TablePage.java
              if [ ! -f "$FOLDER/src/pages/TablePage.java" ]; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo TablePage.java en $FOLDER/src/pages (Java)"
                ERROR_FLAG=1
              else
                # Validar que contiene métodos clave
                if ! grep -q 'datatable' "$FOLDER/src/pages/TablePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró la referencia al datatable en TablePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'WebDriver' "$FOLDER/src/pages/TablePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriver en TablePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'By' "$FOLDER/src/pages/TablePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de By en TablePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'WebDriverWait' "$FOLDER/src/pages/TablePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriverWait en TablePage.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'driver.findElement' "$FOLDER/src/pages/TablePage.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para interactuar con los elementos de la tabla (driver.findElement) en TablePage.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

              # Validar Test para TablePage
              if [ ! -f "$FOLDER/src/tests/TablePageTest.java" ]; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo TablePageTest.java en $FOLDER/src/tests (Java)"
                ERROR_FLAG=1
              else
                # Validar que usa TablePage
                if ! grep -q 'TablePage tablePage = new TablePage' "$FOLDER/src/tests/TablePageTest.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de TablePage en TablePageTest.java (Java)"
                  ERROR_FLAG=1
                fi
                # Validar que contiene pruebas de interacción con la tabla (ordenar, filtrar, etc.)
                if ! grep -q 'datatable' "$FOLDER/src/tests/TablePageTest.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró interacción con la tabla (datatable) en TablePageTest.java (Java)"
                  ERROR_FLAG=1
                fi
                if ! grep -q 'assert' "$FOLDER/src/tests/TablePageTest.java"; then
                  ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró una aserción para verificar la acción en TablePageTest.java (Java)"
                  ERROR_FLAG=1
                fi
              fi

# Output errors if any
if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados en el ejercicio $EXERCISE:\n$ERROR_MESSAGES"
  exit 1
fi
