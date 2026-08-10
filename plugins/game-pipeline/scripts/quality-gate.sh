#!/usr/bin/env bash
# Quality gate deterministico. Exit code 2 = bloqueia o Claude Code (hard stop).
# Roda no evento Stop (fim de cada resposta que mexeu em codigo).
set -uo pipefail

# So roda se for um projeto Flutter ja inicializado
[ -f "pubspec.yaml" ] || exit 0

BRANCH=$(git branch --show-current 2>/dev/null || echo "")

# Roda quando ha .dart tocado -- seja NAO commitado, seja ja commitado na branch
# de feature. (Commitar nao pode ser um jeito de pular o gate: o ciclo do
# /build-feature manda fazer commits pequenos e frequentes.)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  TOCOU_DART=0
  git status --porcelain | grep -q '\.dart$' && TOCOU_DART=1
  if [ "$TOCOU_DART" -eq 0 ] && [[ "$BRANCH" == feature/* || "$BRANCH" == fix/* ]]; then
    BASE=main; git rev-parse --verify main >/dev/null 2>&1 || BASE=master
    git diff --name-only "$BASE...HEAD" 2>/dev/null | grep -q '\.dart$' && TOCOU_DART=1
  fi
  [ "$TOCOU_DART" -eq 1 ] || exit 0
fi

# Sempre via fvm quando disponivel e projeto pinado -- garante que dev e CI
# (Codemagic) usem a MESMA versao do Flutter.
FLUTTER="flutter"; DART="dart"
if command -v fvm >/dev/null 2>&1 && { [ -f ".fvmrc" ] || [ -f ".fvm/fvm_config.json" ]; }; then
  FLUTTER="fvm flutter"; DART="fvm dart"
fi

FAIL=0
LOG=""

echo "-- Quality Gate ------------------------------"

if ! $FLUTTER analyze 2>&1 | tail -5; then
  LOG+="X flutter analyze falhou\n"; FAIL=1
fi

if ! $DART format --set-exit-if-changed --output=none . >/dev/null 2>&1; then
  LOG+="X codigo nao formatado (rode: $DART format .)\n"; FAIL=1
fi

if ! $FLUTTER test 2>&1 | tail -5; then
  LOG+="X testes falharam\n"; FAIL=1
fi

# Numa branch de feature, exige o doc da feature
if [[ "$BRANCH" == feature/* ]]; then
  SLUG="${BRANCH#feature/}"
  if [ ! -f "docs/features/${SLUG}.md" ]; then
    LOG+="X docs/features/${SLUG}.md nao existe -- documente a feature antes de continuar\n"; FAIL=1
  fi
fi

if [ "$FAIL" -eq 1 ]; then
  echo -e "GATE BLOQUEADO:\n${LOG}" >&2
  echo "Corrija os problemas acima antes de encerrar esta etapa." >&2
  exit 2
fi

echo "OK Gate aprovado"
exit 0
