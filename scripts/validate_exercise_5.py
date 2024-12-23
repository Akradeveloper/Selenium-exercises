import os

def validate_exercise_5(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        page_object = os.path.join(base_path, "src/pages/PageObject.java")
        if not os.path.exists(page_object):
            errors.append("Falta el archivo 'PageObject.java'.")
        else:
            with open(page_object) as f:
                content = f.read()
                if "public class PageObject" not in content:
                    errors.append("La clase 'PageObject' no está definida correctamente en 'PageObject.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        page_object = os.path.join(base_path, "src/pages/PageObject.js")
        if not os.path.exists(page_object):
            errors.append("Falta el archivo 'PageObject.js'.")
        else:
            with open(page_object) as f:
                content = f.read()
                if "class PageObject" not in content:
                    errors.append("La clase 'PageObject' no está definida correctamente en 'PageObject.js'.")

    return errors


if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_5(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 1:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
