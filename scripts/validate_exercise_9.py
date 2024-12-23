import os

def validate_exercise_9(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        error_handling = os.path.join(base_path, "src/pages/ErrorHandlingPage.java")
        if not os.path.exists(error_handling):
            errors.append("Falta el archivo 'ErrorHandlingPage.java'.")
        else:
            with open(error_handling) as f:
                content = f.read()
                if "try" not in content or "catch" not in content:
                    errors.append("No se encontró manejo de errores en 'ErrorHandlingPage.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        error_handling = os.path.join(base_path, "src/pages/ErrorHandlingPage.js")
        if not os.path.exists(error_handling):
            errors.append("Falta el archivo 'ErrorHandlingPage.js'.")
        else:
            with open(error_handling) as f:
                content = f.read()
                if "try" not in content or "catch" not in content:
                    errors.append("No se encontró manejo de errores en 'ErrorHandlingPage.js'.")

    return errors


if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_9(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 1:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
