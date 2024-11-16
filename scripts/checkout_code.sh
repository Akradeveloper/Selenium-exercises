#!/bin/bash
# Checkout the code from the specified repository

echo "Checking out the code..."
git clone https://github.com/Akradeveloper/Selenium-exercises.git
cd Selenium-exercises || exit 1
git checkout "${GITHUB_REF}"
