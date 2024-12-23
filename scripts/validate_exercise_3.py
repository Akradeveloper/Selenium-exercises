import os

def validate_exercise_3(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        pages = os.path.join(base_path, "src/pages")
        if not os.path.isdir(pages):
            errors.append("Falta el directorio 'pages' en 'src'.")
        else:
            page_files = os.listdir(pages)
            if not any("HomePage.java" in f for f in page_files):
                errors.append("Falta la página 'HomePage.java' en 'src/pages'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        pages = os.path.join(base_path, "src/pages")
        if not os.path.isdir(pages):
            errors.append("Falta el directorio 'pages' en 'src'.")
        else:
            page_files = os.listdir(pages)
            if not any("HomePage.js" in f for f in page_files):
                errors.append("Falta la página 'HomePage.js' en 'src/pages'.")

    return errors


if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_3(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 3:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
