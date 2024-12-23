import os
import sys

def check_common_validations(folder):
    errors = []
    
    # Validación de directorios comunes
    if not os.path.isdir(os.path.join(folder, 'src', 'pages')):
        errors.append(f"ERROR: Falta el directorio src/pages en {folder}")
    if not os.path.isdir(os.path.join(folder, 'src', 'tests')):
        errors.append(f"ERROR: Falta el directorio src/tests en {folder}")
    if not os.path.isfile(os.path.join(folder, '.gitignore')):
        errors.append(f"ERROR: Falta el archivo .gitignore en {folder}")
    
    # Validación de archivos de solución y ejemplos de prueba
    for filename in os.listdir(folder):
        if 'solution' in filename:
            errors.append(f"ERROR: No debe haber archivos de solución (e.g., solution.java) en {folder}")
        if 'test_example' in filename:
            errors.append(f"ERROR: No debe haber archivos de test de ejemplo (e.g., test_example.js) en {folder}")
    
    # Validación de comentarios en el código
    if not any('/*' in line for line in open(os.path.join(folder, 'src'))):
        errors.append(f"WARNING: No se encontraron comentarios de clase en el código de {folder}")
    if not any('// ' in line for line in open(os.path.join(folder, 'src'))):
        errors.append(f"WARNING: No se encontraron comentarios de métodos en el código de {folder}")
    
    return errors

def check_language_specific_validations(folder, language):
    errors = []
    
    if language == 'java':
        # Validación de dependencia Selenium
        if not any('selenium' in line for line in open(os.path.join(folder, 'pom.xml'))):
            errors.append(f"ERROR: Falta la dependencia de Selenium en el archivo pom.xml (Java) en {folder}")
        
        # Validación de configuración ChromeDriver
        if not any('System.setProperty("webdriver.chrome.driver"' in line for line in open(os.path.join(folder, 'src'))):
            errors.append(f"ERROR: No se encontró configuración correcta de ChromeDriver en el código Java en {folder}")
        
    elif language == 'javascript':
        # Validación de dependencia selenium-webdriver
        if not os.path.isfile(os.path.join(folder, 'package.json')) or 'selenium-webdriver' not in open(os.path.join(folder, 'package.json')).read():
            errors.append(f"ERROR: Falta la dependencia de selenium-webdriver en package.json (JavaScript) en {folder}")
        
        # Validación de configuración ChromeDriver
        if not any("require('selenium-webdriver/chrome')" in line for line in open(os.path.join(folder, 'src'))):
            errors.append(f"ERROR: No se encontró configuración correcta de ChromeDriver en el código JavaScript en {folder}")
    
    return errors

def main():
    folder = sys.argv[1]
    language = sys.argv[2]
    
    errors = []
    
    # Validación común
    errors.extend(check_common_validations(folder))
    
    # Validación por lenguaje
    errors.extend(check_language_specific_validations(folder, language))
    
    # Imprimir errores si los hay
    if errors:
        for error in errors:
            print(error)
        sys.exit(1)
    else:
        print("¡Validación exitosa!")
        sys.exit(0)

if __name__ == "__main__":
    main()
