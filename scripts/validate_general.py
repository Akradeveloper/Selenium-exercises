import os
import json

def validate_general(base_path, language):
    errors = []
    # Validar directorios comunes
    if not os.path.exists(os.path.join(base_path, "src/pages")):
        errors.append("Falta el directorio 'src/pages'.")
    if not os.path.exists(os.path.join(base_path, "src/tests")):
        errors.append("Falta el directorio 'src/tests'.")
    if not os.path.exists(os.path.join(base_path, ".gitignore")):
        errors.append("Falta el archivo '.gitignore'.")

    # Validar archivos prohibidos
    for root, _, files in os.walk(base_path):
        for file in files:
            if "solution" in file or "test_example" in file:
                errors.append(f"Archivo prohibido encontrado: {os.path.join(root, file)}.")
                
    # Validación de comentarios en el código
    src_folder = os.path.join(base_path, 'src')
    
    # Comprobar si existen comentarios de clase (/* */)
    if not any('/\*' in line and '\*/' in line for line in open(src_folder, 'r')):
        errors.append(f"WARNING: No se encontraron comentarios de clase en el código de {base_path}")
    
    # Comprobar si existen comentarios de método (//)
    if not any('// ' in line for line in open(src_folder, 'r')):
        errors.append(f"WARNING: No se encontraron comentarios de métodos en el código de {base_path}")
        
    # Validaciones específicas por lenguaje
    if language == "java":
        if not os.path.exists(os.path.join(base_path, "pom.xml")) and not os.path.exists(os.path.join(base_path, "build.gradle")):
            errors.append("Falta la dependencia de Selenium en 'pom.xml' o 'build.gradle'.")
        # Validación de dependencia Selenium en Java
        if not any('selenium' in line for line in open(os.path.join(base_path, 'pom.xml'))):
            errors.append(f"ERROR: Falta la dependencia de Selenium en el archivo pom.xml (Java) en {base_path}")
        
        # Validación de configuración ChromeDriver en código Java
        if not any('System.setProperty("webdriver.chrome.driver"' in line for line in open(os.path.join(base_path, 'src'))):
            errors.append(f"ERROR: No se encontró configuración correcta de ChromeDriver en el código Java en {base_path}")
            
    elif language == "javascript":
        if not os.path.exists(os.path.join(base_path, "package.json")):
            errors.append("Falta el archivo 'package.json'.")
        else:
            with open(os.path.join(base_path, "package.json")) as f:
                if '"selenium-webdriver"' not in f.read():
                    errors.append("Falta la dependencia 'selenium-webdriver' en 'package.json'.")

    return errors

if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    general_errors = validate_general(base_path, language)
    if general_errors:
        print("Errores generales:")
        for error in general_errors:
            print(f"- {error}")
        sys.exit(1)
