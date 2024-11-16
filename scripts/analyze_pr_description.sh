#!/bin/bash
# Analyze the PR description to find marked exercises and language

PR_DESCRIPTION="${{ github.event.pull_request.body }}"
# Detect language
if echo "$PR_DESCRIPTION" | grep -q '\- \[X\] Java'; then
  echo "language=java" >> $GITHUB_ENV
elif echo "$PR_DESCRIPTION" | grep -q '\- \[X\] JS'; then
  echo "language=javascript" >> $GITHUB_ENV
else
  echo "ERROR: No se especificó el lenguaje de programación o más de uno fue marcado."
  exit 1
fi

# Detect exercises
EXERCISES=""
for i in {1..5}; do
  if echo "$PR_DESCRIPTION" | grep -q "\- \[X\] Ejercicio $i"; then
    EXERCISES="$EXERCISES $i"
  fi
done

if [ -z "$EXERCISES" ]; then
  echo "ERROR: No se marcaron ejercicios para validar."
  exit 1
fi

echo "marked_exercises=$EXERCISES" >> $GITHUB_ENV
