#!/bin/bash
# Validate based on marked exercises and language

ERROR_FLAG=0
ERROR_MESSAGES=""

validate_exercise() {
  EXERCISE=$1
  FOLDER="./ejercicio-$EXERCISE"
  LANGUAGE="${{ env.language }}"

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
  if find "$FOLDER" -type f -name "*solution*" | grep -q .; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de solución (e.g., solution.java) en $FOLDER"
      ERROR_FLAG=1
  fi
  if find "$FOLDER" -type f -name "*test_example*" | grep -q .; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No debe haber archivos de test de ejemplo (e.g., test_example.js) en $FOLDER"
      ERROR_FLAG=1
  fi
  if ! grep -r "/\*.*\*/" "$FOLDER/src" >/dev/null 2>&1; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de clase en el código de $FOLDER"
  fi
  if ! grep -r "//.*" "$FOLDER/src" >/dev/null 2>&1; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nWARNING: No se encontraron comentarios de métodos en el código de $FOLDER"
  fi

  # Language-specific validation
  if [ "$LANGUAGE" == "java" ]; then
    # Check for Selenium dependency in pom.xml or build.gradle
    if ! grep -q 'org.seleniumhq.selenium' "$FOLDER/pom.xml" && ! grep -q 'selenium-java' "$FOLDER/build.gradle"; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta la dependencia de Selenium en el archivo pom.xml o build.gradle (Java)"
      ERROR_FLAG=1
    fi
    # Validate ChromeDriver setup
    if ! grep -q 'System.setProperty("webdriver.chrome.driver"' "$FOLDER/src" || ! grep -q 'new ChromeDriver()' "$FOLDER/src"; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró configuración correcta de ChromeDriver en el código Java"
      ERROR_FLAG=1
    fi
    java_validation $EXERCISE $FOLDER
  elif [ "$LANGUAGE" == "javascript" ]; then
    # Check for selenium-webdriver dependency in package.json
    if [ ! -f "$FOLDER/package.json" ] || ! grep -q '"selenium-webdriver"' "$FOLDER/package.json"; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: Falta la dependencia de selenium-webdriver en package.json (JavaScript)"
      ERROR_FLAG=1
    fi
    # Validate ChromeDriver setup in JS code
    if ! grep -q "require('selenium-webdriver/chrome')" "$FOLDER/src" || ! grep -q "new Builder().forBrowser('chrome')" "$FOLDER/src"; then
      ERROR_MESSAGES="$ERROR_MESSAGES\nERROR: No se encontró configuración correcta de ChromeDriver en el código JavaScript"
      ERROR_FLAG=1
    fi
    javascript_validation $EXERCISE $FOLDER
  fi
}

# Function for Java-specific validation
java_validation() {
  EXERCISE=$1
  FOLDER=$2
  mvn -f "$FOLDER/pom.xml" checkstyle:check || ERROR_FLAG=1
  
  # Specific validation checks for Java
  # Add your Java-specific checks here...
}

# Function for JavaScript-specific validation
javascript_validation() {
  EXERCISE=$1
  FOLDER=$2
  # Add your JavaScript-specific checks here...
}

# Iterate through marked exercises
for EXERCISE in ${{ env.marked_exercises }}; do
  validate_exercise $EXERCISE
done

if [ $ERROR_FLAG -eq 1 ]; then
  echo -e "Errores encontrados durante la validación:\n$ERROR_MESSAGES"
  curl -X POST -H "Authorization: token ${{ secrets.TOKEN_GITHUB }}" \
    -d "{\"body\": \"Errores encontrados en la validación del PR:\n$ERROR_MESSAGES\"}" \
    "https://api.github.com/repos/${{ github.repository }}/issues/${{ github.event.pull_request.number }}/comments"
  exit 1
fi
