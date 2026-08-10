#!/usr/bin/env bash
# PreToolUse(Bash): bloqueia comandos destrutivos e commit/push direto na main.
# Exit 2 = comando bloqueado.
# Parser de JSON sem python: o `python3` do Windows costuma ser o stub da
# Microsoft Store, que falha -- e o guard passava a aceitar TUDO em silencio.
set -uo pipefail

INPUT=$(cat)

json_str() { # $1 = chave; imprime o valor string cru
  if printf '' | grep -qP '' 2>/dev/null; then
    printf '%s' "$INPUT" | grep -oP "\"$1\"\\s*:\\s*\"\\K(?:\\\\.|[^\"\\\\])*" | head -1
  else # grep sem PCRE (macOS/BSD): fallback com sed
    printf '%s' "$INPUT" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p" | head -1
  fi
}

CMD=$(json_str command)
[ -n "$CMD" ] || exit 0

# 1) Destrutivos
if printf '%s' "$CMD" | grep -qE 'rm -rf (/|~|\.)( |$)|git push [^|;&]*--force|git reset --hard origin|git clean -[a-z]*f|git branch -D (main|master)'; then
  echo "Comando destrutivo bloqueado pelo guard: $CMD" >&2
  exit 2
fi

# 2) Commit/push direto na main/master.
#    Casa em qualquer posicao: comando composto (`cd x && git commit`), `git -C <dir>`.
if printf '%s' "$CMD" | grep -qE '(^|[;&|] *)git( +-[A-Za-z]+ +[^ ]+)* +(commit|push)'; then
  # `git -C <dir>` muda o repo alvo: cheque o branch de la, nao o do cwd.
  DIR=$(printf '%s' "$CMD" | grep -oE 'git +-C +[^ ]+' | head -1 | awk '{print $3}' | tr -d "\"'")
  if [ -n "$DIR" ]; then
    BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null || echo "")
  else
    BRANCH=$(git branch --show-current 2>/dev/null || echo "")
  fi
  if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    echo "Bloqueado: commit/push direto na '$BRANCH'. Crie uma branch: git checkout -b feature/<slug>" >&2
    exit 2
  fi
fi

exit 0
