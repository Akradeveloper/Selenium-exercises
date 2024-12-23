import os

def validate_exercise_6(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        form_validation = os.path.join(base_path, "src/pages/FormValidation.java")
        if not os.path.exists(form_validation):
            errors.append("Falta el archivo 'FormValidation.java'.")
        else:
            with open(form_validation) as f:
                content = f.read()
                if "form" not in content:
                    errors.append("No se encontró la validación de formulario en 'FormValidation.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        form_validation = os.path.join(base_path, "src/pages/FormValidation.js")
        if not os.path.exists(form_validation):
            errors.append("Falta el archivo 'FormValidation.js'.")
        else:
            with open(form_validation) as f:
                content = f.read()
                if "form" not in content:
                    errors.append("No se encontró la validación de formulario en 'FormValidation.js'.")

    return errors



if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_6(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 6:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
