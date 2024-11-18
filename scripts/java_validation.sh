#!/bin/bash
# Archivo donde se guardarán los errores
ERROR_LOG="validation_errors.log"
java_validation() {
    EXERCISE=$1
    FOLDER=$2
    ERROR_FLAG=0
    ERROR_MESSAGES=""
    # Limpiar el archivo de errores al inicio
    > $ERROR_LOG
    # Ejecución de mvn checkstyle y captura de errores
    mvn -f "$FOLDER/pom.xml" checkstyle:check
    if [ $? -ne 0 ]; then
        ERROR_MESSAGES="ERROR: Maven checkstyle falló en el proyecto"
        echo "$ERROR_MESSAGES" >> $ERROR_LOG
        ERROR_FLAG=1
    fi    
    # Specific validation checks for Java
    if [ "$EXERCISE" == "1" ]; then
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
        if [ ! -f "$FOLDER/src/pages/LoginTest.java" ]; then
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
    fi

    # Additional validations for exercises 2 to 6...
    if [ "$EXERCISE" == "2" ]; then
        if [ ! -f "$FOLDER/src/pages/FormPage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormPage.java en el directorio src/pages (Java)"
            ERROR_FLAG=1
        else
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

        if [ ! -f "$FOLDER/src/tests/FormTest.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo FormTest.java en el directorio src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*getText.*"Thank you"' "$FOLDER/src/tests/FormTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró la validación del mensaje de éxito en FormTest.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    # Add similar validation checks for exercises 3, 4, and 5...
    if [ "$EXERCISE" == "3" ]; then
        if [ ! -f "$FOLDER/src/pages/HomePage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'driver.get("https://www.telerik.com/")' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para navegar a https://www.telerik.com en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'driver.findElement(By.*).click()' "$FOLDER/src/pages/HomePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el método para hacer clic en un enlace en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/pages/DemoPage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo DemoPage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*getTitle.*"Demos"' "$FOLDER/src/pages/DemoPage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró un método para verificar el título en DemoPage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/tests/HomeTest.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomeTest.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'HomePage homePage = new HomePage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de HomePage en HomeTest.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'DemoPage demoPage = new DemoPage' "$FOLDER/src/tests/HomeTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de DemoPage en HomeTest.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    # Additional validations for exercises 4, 5, and 6...
    if [ "$EXERCISE" == "4" ]; then
        if [ ! -f "$FOLDER/src/pages/HomePage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo WaitExamplePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
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
        if [ ! -f "$FOLDER/src/tests/HomePage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo HomePage.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'WaitExamplePage waitPage = new WaitExamplePage' "$FOLDER/src/tests/HomePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de WaitExamplePage en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'assert.*getTitle.*"Expected Title"' "$FOLDER/src/tests/HomePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró una aserción para verificar la acción en HomePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    if [ "$EXERCISE" == "5" ]; then
        if [ ! -f "$FOLDER/src/pages/TablePage.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo TablePage.java en $FOLDER/src/pages (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'datatable' "$FOLDER/src/pages/TablePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró la referencia al datatable en TablePage.java (Java)"
                ERROR_FLAG=1
            fi
            if ! grep -q 'WebDriver' "$FOLDER/src/pages/TablePage.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el uso de WebDriver en TablePage.java (Java)"
                ERROR_FLAG=1
            fi
        fi
        if [ ! -f "$FOLDER/src/tests/TableTest.java" ]; then
            ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró el archivo TableTest.java en $FOLDER/src/tests (Java)"
            ERROR_FLAG=1
        else
            if ! grep -q 'assert.*row.*"data"' "$FOLDER/src/tests/TableTest.java"; then
                ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró la validación de la fila en TableTest.java (Java)"
                ERROR_FLAG=1
            fi
        fi
    fi

    # Al final, verificar si hubo errores y salir con código no cero si es necesario
    if [ "$ERROR_FLAG" -eq 1 ]; then
        echo "Errores encontrados. Revisa $ERROR_LOG para más detalles."
        exit 1
    else
        echo "Validación exitosa para el ejercicio $EXERCISE"
    fi
}

# Llamar a la función con los argumentos pasados desde el workflow
EXERCISE=$1
FOLDER=$2

java_validation $EXERCISE $FOLDER