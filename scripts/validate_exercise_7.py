import os

def validate_exercise_7(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        screenshot_page = os.path.join(base_path, "src/pages/ScreenshotPage.java")
        if not os.path.exists(screenshot_page):
            errors.append("Falta el archivo 'ScreenshotPage.java'.")
        else:
            with open(screenshot_page) as f:
                content = f.read()
                if "TakesScreenshot" not in content:
                    errors.append("No se encontró la captura de pantalla en 'ScreenshotPage.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        screenshot_page = os.path.join(base_path, "src/pages/ScreenshotPage.js")
        if not os.path.exists(screenshot_page):
            errors.append("Falta el archivo 'ScreenshotPage.js'.")
        else:
            with open(screenshot_page) as f:
                content = f.read()
                if "takeScreenshot" not in content:
                    errors.append("No se encontró la captura de pantalla en 'ScreenshotPage.js'.")

    return errors



if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_7(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 7:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
