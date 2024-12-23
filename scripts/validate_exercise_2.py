import os

def validate_exercise_2(base_path, language):
    errors = []

    # Validaciones para Java
    if language == "java":
        form_page = os.path.join(base_path, "src/pages/FormPage.java")
        if not os.path.exists(form_page):
            errors.append("Falta el archivo 'FormPage.java'.")
        else:
            with open(form_page) as f:
                content = f.read()
                if "https://www.saucedemo.com" not in content:
                    errors.append("Falta la referencia a 'https://www.saucedemo.com' en 'FormPage.java'.")
                if "By.id(\"first-name\")" not in content or "By.id(\"last-name\")" not in content:
                    errors.append("Faltan selectores de nombre o apellido en 'FormPage.java'.")

    # Validaciones para JavaScript
    elif language == "javascript":
        form_page = os.path.join(base_path, "src/pages/FormPage.js")
        if not os.path.exists(form_page):
            errors.append("Falta el archivo 'FormPage.js'.")
        else:
            with open(form_page) as f:
                content = f.read()
                if "https://www.saucedemo.com" not in content:
                    errors.append("Falta la referencia a 'https://www.saucedemo.com' en 'FormPage.js'.")
                if "By.id('first-name')" not in content or "By.id('last-name')" not in content:
                    errors.append("Faltan selectores de nombre o apellido en 'FormPage.js'.")

    return errors


if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_2(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 2:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
