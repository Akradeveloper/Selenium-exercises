import os

def validate_exercise_4(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        wait_page = os.path.join(base_path, "src/pages/WaitPage.java")
        if not os.path.exists(wait_page):
            errors.append("Falta el archivo 'WaitPage.java'.")
        else:
            with open(wait_page) as f:
                content = f.read()
                if "WebDriverWait" not in content or "ExpectedConditions" not in content:
                    errors.append("Faltan las esperas explícitas en 'WaitPage.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        wait_page = os.path.join(base_path, "src/pages/WaitPage.js")
        if not os.path.exists(wait_page):
            errors.append("Falta el archivo 'WaitPage.js'.")
        else:
            with open(wait_page) as f:
                content = f.read()
                if "until" not in content or "By" not in content:
                    errors.append("Faltan las esperas explícitas en 'WaitPage.js'.")

    return errors


if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_4(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 4:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
