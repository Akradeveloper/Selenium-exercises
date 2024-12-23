import os

def validate_exercise_8(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        hooks_file = os.path.join(base_path, "src/hooks/PreconditionHooks.java")
        if not os.path.exists(hooks_file):
            errors.append("Falta el archivo 'PreconditionHooks.java'.")
        else:
            with open(hooks_file) as f:
                content = f.read()
                if "@Before" not in content or "@After" not in content:
                    errors.append("No se encontraron los hooks de precondiciones en 'PreconditionHooks.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        hooks_file = os.path.join(base_path, "src/hooks/PreconditionHooks.js")
        if not os.path.exists(hooks_file):
            errors.append("Falta el archivo 'PreconditionHooks.js'.")
        else:
            with open(hooks_file) as f:
                content = f.read()
                if "before" not in content or "after" not in content:
                    errors.append("No se encontraron los hooks de precondiciones en 'PreconditionHooks.js'.")

    return errors



if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_8(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 1:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
