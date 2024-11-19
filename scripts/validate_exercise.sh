#!/bin/bash

# Leer las variables desde los archivos
LANGUAGE=$(cat .language)
EXERCISES=$(cat .exercises)

# Archivo donde guardaremos los errores
ERROR_MESSAGES=""
ERROR_FLAG=0
ERROR_FLAG_EXERCISE=0

# Función para validar el ejercicio específico
validate_exercise() {
  EXERCISE=$1
  FOLDER="./ejercicio-$EXERCISE"
  
  

  # Validación específica según el lenguaje
  if [ "$LANGUAGE" == "java" ]; then
    java_validation $EXERCISE $FOLDER
  elif [ "$LANGUAGE" == "javascript" ]; then
    javascript_validation $EXERCISE $FOLDER
  fi
}

# Función para la validación en Java
java_validation() {
  EXERCISE=$1
  FOLDER=$2
  # Comprobación de directorios y archivos necesarios
  if [ ! -d "$FOLDER/src/pages" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el directorio src/pages en $FOLDER"
    ERROR_FLAG=1
  fi
  if [ ! -d "$FOLDER/src/tests" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el directorio src/tests en $FOLDER"
    ERROR_FLAG=1
  fi
  if [ ! -f "$FOLDER/.gitignore" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el archivo .gitignore en $FOLDER"
    ERROR_FLAG=1
  fi

  # Validaciones específicas para no permitir archivos de solución o ejemplos
  if find "$FOLDER" -type f -name "*solution*" | grep -q .; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No debe haber archivos de solución (e.g., solution.java) en $FOLDER"
    ERROR_FLAG_EXERCISE=1
  fi
  if find "$FOLDER" -type f -name "*test_example*" | grep -q .; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No debe haber archivos de test de ejemplo (e.g., test_example.js) en $FOLDER"
    ERROR_FLAG_EXERCISE=1
  fi

  # Validación de comentarios en el código
  if ! grep -r "/\*.*\*/" "$FOLDER/src" >/dev/null 2>&1; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de clase en el código de $FOLDER"
  fi
  if ! grep -r "//.*" "$FOLDER/src" >/dev/null 2>&1; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios en el código de $FOLDER"
  fi
  # Comprobar si el archivo pom.xml o build.gradle tiene dependencia de Selenium
    if ! grep -q 'org.seleniumhq.selenium' "$FOLDER/pom.xml" && ! grep -q 'selenium-java' "$FOLDER/build.gradle"; then
      ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta la dependencia de Selenium en el archivo pom.xml o build.gradle (Java)"
      ERROR_FLAG=1
    fi
    # Validar uso de System.setProperty y new ChromeDriver()
    if ! grep -q 'System.setProperty("webdriver.chrome.driver"' "$FOLDER/src" || ! grep -q 'new ChromeDriver()' "$FOLDER/src"; then
      ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró configuración correcta de ChromeDriver en el código Java"
      ERROR_FLAG=1
    fi
 # Ejecución de mvn checkstyle y captura de errores
    mvn -f "$FOLDER/pom.xml" checkstyle:check
    if [ $? -ne 0 ]; then
        ERROR_MESSAGES+="ERROR: Maven checkstyle falló en el proyecto"
        echo "$ERROR_MESSAGES"
        ERROR_FLAG=1
    fi    
    # Specific validation checks for Java
    if [ "$EXERCISE" == "1" ]; then
        if [ ! -f "$FOLDER/src/pages/LoginPage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginPage.java en el directorio Pages (Java Ejercicio-$EXERCISE)"
            ERROR_FLAG=1
        else
            if ! grep -q 'https://www.saucedemo.com' "$FOLDER/src/pages/LoginPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró referencia a https://www.saucedemo.com en LoginPage.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
            if ! grep -E 'By\..*username|By\..*password|By\..*login-button' "$FOLDER/src/pages/LoginPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontraron selectores de usuario, contraseña o botón de login en LoginPage.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/pages/LoginTest.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginTest.java en el directorio Test (Java Ejercicio-$EXERCISE)"
            ERROR_FLAG=1
        else      
            if ! grep -r "assert.*getTitle.*\"Swag Labs\"" "$FOLDER/src/test/java/LoginTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo LoginTest.java en el directorio Test (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
            if ! grep -r "await driver.getTitle().contains.*'Swag Labs'" "$FOLDER/src/test/java/LoginTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró un assert para el título en el test de LoginTest (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
        fi 
    fi

    # Additional validations for exercises 2 to 6...
    if [ "$EXERCISE" == "2" ]; then
        if [ ! -f "$FOLDER/src/pages/FormPage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormPage.java en el directorio src/pages (Java Ejercicio-$EXERCISE)"
            ERROR_FLAG=1
        else
            if ! grep -q 'By.*name.*"firstName"' "$FOLDER/src/pages/FormPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró un selector para el campo de nombre en FormPage.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'By.*email.*"userEmail"' "$FOLDER/src/pages/FormPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró un selector para el campo de correo electrónico en FormPage.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'By.*button.*"submit"' "$FOLDER/src/pages/FormPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró un selector para el botón de envío en FormPage.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
        fi

        if [ ! -f "$FOLDER/src/tests/FormTest.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormTest.java en el directorio src/tests (Java Ejercicio-$EXERCISE)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*getText.*"Thank you"' "$FOLDER/src/tests/FormTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró la validación del mensaje de éxito en FormTest.java (Java Ejercicio-$EXERCISE)"
                ERROR_FLAG=1
            fi
        fi
    fi

    # Add similar validation checks for exercises 3, 4, and 5...
    if [ "$EXERCISE" == "3" ]; then
        if [ ! -f "$FOLDER/src/pages/HomePage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'driver.get("https://www.telerik.com/")' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el método para navegar a https://www.telerik.com en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'driver.findElement(By.*).click()' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el método para hacer clic en un enlace en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/pages/DemoPage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo DemoPage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*getTitle.*"Demos"' "$FOLDER/src/pages/DemoPage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró un método para verificar el título en DemoPage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/tests/HomeTest.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomeTest.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'HomePage homePage = new HomePage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el uso de HomePage en HomeTest.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'DemoPage demoPage = new DemoPage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el uso de DemoPage en HomeTest.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    # Additional validations for exercises 4, 5, and 6...
    if [ "$EXERCISE" == "4" ]; then
        if [ ! -f "$FOLDER/src/pages/HomePage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo WaitExamplePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'driver.get("https://www.telerik.com/")' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el método para navegar a https://www.telerik.com en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'WebDriverWait' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriverWait para esperas explícitas en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'driver.findElement(By.*).click()' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el método para hacer clic en un botón en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/tests/HomePage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'WaitExamplePage waitPage = new WaitExamplePage' "$FOLDER/src/tests/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el uso de WaitExamplePage en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'assert.*getTitle.*"Expected Title"' "$FOLDER/src/tests/HomePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró una aserción para verificar la acción en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    if [ "$EXERCISE" == "5" ]; then
        if [ ! -f "$FOLDER/src/pages/TablePage.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo TablePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'datatable' "$FOLDER/src/pages/TablePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró la referencia al datatable en TablePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'WebDriver' "$FOLDER/src/pages/TablePage.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriver en TablePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/tests/TableTest.java" ]; then
            ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró el archivo TableTest.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*row.*"data"' "$FOLDER/src/tests/TableTest.java"; then
                ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró la validación de la fila en TableTest.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi
}

# Función para la validación en JavaScript
javascript_validation() {
  EXERCISE=$1
  FOLDER=$2
  # Comprobar si package.json tiene la dependencia de selenium-webdriver
    if [ ! -f "$FOLDER/package.json" ] || ! grep -q '"selenium-webdriver"' "$FOLDER/package.json"; then
      ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta la dependencia de selenium-webdriver en package.json (JavaScript)"
      ERROR_FLAG=1
    fi
    # Validar inicialización del ChromeDriver en código JS
    if ! grep -q "require('selenium-webdriver/chrome')" "$FOLDER/src" || ! grep -q "new Builder().forBrowser('chrome')" "$FOLDER/src"; then
      ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No se encontró configuración correcta de ChromeDriver en el código JavaScript"
      ERROR_FLAG=1
    fi
    # Comprobación de directorios y archivos necesarios
  if [ ! -d "$FOLDER/src/pages" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el directorio src/pages en $FOLDER"
    ERROR_FLAG=1
  fi
  if [ ! -d "$FOLDER/src/tests" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el directorio src/tests en $FOLDER"
    ERROR_FLAG=1
  fi
  if [ ! -f "$FOLDER/.gitignore" ]; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: Falta el archivo .gitignore en $FOLDER"
    ERROR_FLAG=1
  fi

  # Validaciones específicas para no permitir archivos de solución o ejemplos
  if find "$FOLDER" -type f -name "*solution*" | grep -q .; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No debe haber archivos de solución (e.g., solution.java) en $FOLDER"
    ERROR_FLAG_EXERCISE=1
  fi
  if find "$FOLDER" -type f -name "*test_example*" | grep -q .; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nERROR: No debe haber archivos de test de ejemplo (e.g., test_example.js) en $FOLDER"
    ERROR_FLAG_EXERCISE=1
  fi

  # Validación de comentarios en el código
  if ! grep -r "/\*.*\*/" "$FOLDER/src" >/dev/null 2>&1; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de clase en el código de $FOLDER"
  fi
  if ! grep -r "//.*" "$FOLDER/src" >/dev/null 2>&1; then
    ERROR_MESSAGES+="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios en el código de $FOLDER"
  fi
  # Aquí agregas las validaciones JavaScript adicionales si las necesitas
  # Si detectas errores adicionales, añádelos a ERROR_MESSAGES
}

# Validar los ejercicios seleccionados
for EXERCISE in $EXERCISES; do
  validate_exercise $EXERCISE
done

# Si hubo errores, guardamos en el archivo de errores
if [ $ERROR_FLAG -eq 1 ] || [ $ERROR_FLAG_EXERCISE -eq 1 ]; then
  echo -e "$ERROR_MESSAGES" | tee validation_errors.txt
  echo "Errores encontrados y guardados en validation_errors.txt."
  # Mostrar el contenido del archivo validation_errors.txt en los logs
  cat validation_errors.txt
else
  echo "Validación completada sin errores."
fi
