#!/usr/bin/env bash
# PostToolUse(Edit|Write): formata o .dart tocado. Best-effort, nunca bloqueia.
# Parser de JSON sem python (ver nota em guard-git.sh).
set -uo pipefail
[ -f "pubspec.yaml" ] || exit 0

INPUT=$(cat)

if printf '' | grep -qP '' 2>/dev/null; then
  FILE=$(printf '%s' "$INPUT" | grep -oP '"file_path"\s*:\s*"\K[^"]*' | head -1)
else
  FILE=$(printf '%s' "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi
# Normaliza barras invertidas do Windows (C:\\dev\\x -> C:/dev/x)
FILE=$(printf '%s' "$FILE" | sed 's/\\\\/\//g; s/\\/\//g')

if [[ "$FILE" == *.dart && -f "$FILE" ]]; then
  # Via fvm quando o projeto esta pinado -- mesma versao do dev e do CI.
  if command -v fvm >/dev/null 2>&1 && { [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]; }; then
    fvm dart format "$FILE" >/dev/null 2>&1 || true
  else
    dart format "$FILE" >/dev/null 2>&1 || true
  fi
fi
exit 0
