import os

def validate_exercise_1(base_path, language):
    errors = []

    # Validaciones específicas para Java
    if language == "java":
        login_page = os.path.join(base_path, "src/pages/LoginPage.java")
        if not os.path.exists(login_page):
            errors.append("Falta el archivo 'LoginPage.java'.")
        else:
            with open(login_page) as f:
                content = f.read()
                if "https://www.saucedemo.com" not in content:
                    errors.append("Falta la referencia a 'https://www.saucedemo.com' en 'LoginPage.java'.")
                if not any(selector in content for selector in ["By.id(\"username\")", "By.id(\"password\")", "By.id(\"login-button\")"]):
                    errors.append("Faltan selectores de usuario, contraseña o botón de login en 'LoginPage.java'.")

    # Validaciones específicas para JavaScript
    elif language == "javascript":
        login_page = os.path.join(base_path, "src/pages/LoginPage.js")
        if not os.path.exists(login_page):
            errors.append("Falta el archivo 'LoginPage.js'.")
        else:
            with open(login_page) as f:
                content = f.read()
                if "https://www.saucedemo.com" not in content:
                    errors.append("Falta la referencia a 'https://www.saucedemo.com' en 'LoginPage.js'.")
                if not any(selector in content for selector in ["By.id('username')", "By.id('password')", "By.id('login-button')"]):
                    errors.append("Faltan selectores de usuario, contraseña o botón de login en 'LoginPage.js'.")

    return errors

if __name__ == "__main__":
    import sys
    base_path = sys.argv[1]
    language = sys.argv[2]
    exercise_errors = validate_exercise_1(base_path, language)
    if exercise_errors:
        print("Errores del Ejercicio 1:")
        for error in exercise_errors:
            print(f"- {error}")
        sys.exit(1)
