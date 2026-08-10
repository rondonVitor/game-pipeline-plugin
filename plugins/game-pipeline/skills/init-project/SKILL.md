---
name: init-project
description: Instala o padrão do pipeline num projeto que JÁ existe (ou numa pasta vazia fora do hub) — copia CLAUDE.md, docs (templates, arquitetura, setup-manual), roadmap e ci, sem sobrescrever o que já existe. Use quando o usuário quiser adotar o pipeline num repo existente, ou disser "bootstrap", "adotar o pipeline", "iniciar projeto" fora do hub. Para jogo NOVO vindo da incubadora, use /game-pipeline:new-game.
---

# /game-pipeline:init-project

**Quando usar qual:**
| Situação | Skill |
|---|---|
| Jogo novo, conceito aprovado na Fase 0 do hub | `/game-pipeline:new-game <slug>` (cria a pasta irmã, move a pesquisa, gera PRD+roadmap) |
| Repo que já existe / pasta fora do hub | **esta** |

Execute na raiz do projeto alvo.

## Passos
1. **Inventariar antes de copiar.** Liste o que já existe (`CLAUDE.md`,
   `docs/`, `design/`, `.fvmrc`). **Nada é sobrescrito sem decisão do usuário.**
2. Copie o que falta:
   ```bash
   TPL="${CLAUDE_PLUGIN_ROOT}/project-template"
   mkdir -p docs/research docs/features docs/decisions design/screens design/store
   cp -rn "$TPL/docs/templates"    docs/templates
   cp -rn "$TPL/docs/setup-manual" docs/setup-manual
   cp -rn "$TPL/ci"                ci
   cp -n  "$TPL/docs/architecture.md" docs/architecture.md
   cp -n  "$TPL/CLAUDE.md"            CLAUDE.md
   ```
   Se já houver `CLAUDE.md`, **não sobrescreva**: mostre quais seções do template
   faltam (arranque por roadmap, fonte de UI, comandos via fvm, fases 3/4, regras
   não-negociáveis) e pergunte o que incorporar.
3. **`docs/roadmap.md`** — se não existir, gere a partir de
   `docs/templates/roadmap.md`; se existir, confira que tem **Fase 3** (serviços ×
   doc de setup-manual) e **Fase 4** (lançamento) e complete o que faltar. É o
   arranque de toda sessão.
4. **Ponteiro de UI** — crie `design/claude-design.json` se não existir:
   ```bash
   printf '{\n  "provider": "claude-design",\n  "project_id": "PREENCHER_NA_FASE_1",\n  "url": "",\n  "role": "FONTE DA VERDADE de UI. Toda tela/componente/token de UI espelha este projeto via MCP claude_design. Nada de UI e inventado."\n}\n' > design/claude-design.json
   ```
5. **fvm** — se não houver `.fvmrc`, pergunte a versão e rode `fvm use <versao>`.
   Os hooks e o CI dependem dela.
6. Git: se ainda não é repo, `git init -b main` + commit `chore: adota o pipeline`
   (confirme nome/visibilidade antes de `gh repo create`).
7. Diga em que fase o projeto está (pelo roadmap) e qual é a próxima ação.

## Observações
- NÃO rode `flutter create` num projeto já existente. Em projeto novo, isso é
  Fase 2 — depois do design aprovado, para nascer alinhado aos tokens.
- Ao adotar o pipeline num repo com código, rode o `quality-gate.sh` cedo: se
  `analyze`/`test` já falham, resolva antes de abrir a primeira feature.
