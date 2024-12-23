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

    # Validaciones específicas por lenguaje
    if language == "java":
        if not os.path.exists(os.path.join(base_path, "pom.xml")) and not os.path.exists(os.path.join(base_path, "build.gradle")):
            errors.append("Falta la dependencia de Selenium en 'pom.xml' o 'build.gradle'.")
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
