---
name: new-game
description: Materializa um jogo aprovado na incubadora — cria a pasta do projeto FORA do hub (diretório irmão), copia o scaffold, importa o plugin no projeto novo e prepara git/GitHub. Use SEMPRE que o usuário aprovar/escolher um conceito de jogo na Fase 0 do hub, ou disser "criar o projeto", "vamos com essa ideia", "materializar".
---

# /game-pipeline:new-game <slug>

Pré-condições: rodando dentro do HUB (pasta com `plugins/game-pipeline/`), e o usuário já escolheu o conceito na Fase 0. Se não houver conceito aprovado, volte à Fase 0 em vez de criar às cegas. Confirme o `<slug>` (kebab-case) com o usuário antes de executar.

## Passos

1. **Definir destino fora do hub** (pasta irmã) e validar que não existe:
   ```bash
   HUB="$PWD"
   TARGET="$(dirname "$PWD")/<slug>"
   [ -e "$TARGET" ] && echo "ERRO: $TARGET já existe" || mkdir -p "$TARGET"
   ```
   Criar fora do diretório da sessão exige aprovação de permissão — explique isso ao usuário na primeira vez.

2. **Copiar o scaffold do projeto:**
   ```bash
   TPL="$HUB/plugins/game-pipeline/project-template"
   cp "$TPL/CLAUDE.md" "$TARGET/CLAUDE.md"
   mkdir -p "$TARGET"/{docs/research,docs/features,docs/decisions,design/screens,design/store,.claude}
   cp -r "$TPL/docs/templates"    "$TARGET/docs/templates"
   cp -r "$TPL/docs/setup-manual" "$TARGET/docs/setup-manual"   # contas, lojas, domínio, CI
   cp -r "$TPL/ci"                "$TARGET/ci"                  # base do codemagic.yaml
   cp "$TPL/docs/architecture.md" "$TARGET/docs/architecture.md"
   ```
   O `docs/setup-manual/` é o que faz o projeto **nascer sabendo o caminho até a
   loja** (privacidade, domínio, IAP, Games Services, ASO, screenshots, CI) — não
   é opcional.
   Crie tambem o ponteiro de UI `design/claude-design.json` (preenchido na Fase 1, quando o projeto do Claude Design existir):
   ```bash
   printf '{\n  "provider": "claude-design",\n  "project_id": "PREENCHER_NA_FASE_1",\n  "url": "",\n  "role": "FONTE DA VERDADE de UI. Toda tela/componente/token de UI espelha este projeto via MCP claude_design. Nada de UI e inventado."\n}\n' > "$TARGET/design/claude-design.json"
   ```

3. **Transferir a Fase 0:** copie os relatórios aprovados de `$HUB/research/` para `$TARGET/docs/research/` e gere `$TARGET/docs/prd.md` com o conceito escolhido: pitch, core loop, features do MVP (do game-ideator) **e uma seção "Monetização"** com a projeção do market-researcher (mix ads vs IAP, faixa de ARPU/LTV com premissas, risco nº1). Ajuste o título e o conceito no CLAUDE.md do projeto.

3b. **Gerar o roadmap:** a partir de `docs/templates/roadmap.md` + as features do MVP do `docs/prd.md`, escreva `$TARGET/docs/roadmap.md` — derive a sequência de features (domínio/persistência → loop de jogo → telas satélite → navegação), preencha a **Fase 3** (cada serviço com o doc de `setup-manual/` que o destrava) e mantenha a **Fase 4 (lançamento)** do template inteira. Marque a Fase 0 como ✅ e a Fase 1 como próxima. É a fonte da verdade do progresso.

4. **Plugin no projeto novo:** nada a instalar — o plugin foi instalado no escopo do usuário a partir do hub local, então já está ativo em qualquer pasta desta máquina. Apenas acrescente ao final do CLAUDE.md do projeto uma seção "Setup em outra máquina":
   ```
   ## Setup em outra máquina
   Este projeto depende do plugin local `game-pipeline`. Copie a pasta do hub
   para a máquina e rode no Claude Code:
   /plugin marketplace add <caminho-absoluto-do-hub>
   /plugin install game-pipeline@game-pipeline-marketplace
   ```

5. **Git e GitHub** (confirme nome e visibilidade antes de criar o repo remoto):
   ```bash
   git -C "$TARGET" init -b main
   git -C "$TARGET" add -A
   git -C "$TARGET" commit -m "chore: bootstrap do pipeline + PRD (Fase 0)"
   gh repo create <slug> --private --source="$TARGET" --push
   ```

6. **Handoff.** Registre a ideia como "materializada" em `$HUB/research/descartadas.md` (seção separada) e finalize a resposta com exatamente isto:
   > Projeto criado em `../<slug>`. Para continuar: `cd ../<slug> && claude` — a sessão nova já abre na Fase 1 (Design): eu gero o `docs/design-brief.md` e rodo `/game-pipeline:design-kickoff` (cria o projeto no Claude Design, semeia o brief e grava o `project_id` em `design/claude-design.json`). Você valida o DS/protótipo lá; depois `/game-pipeline:materialize-design-system` traz tudo pro código.

## Regras
- NUNCA rode `flutter create` aqui — é responsabilidade da Fase 2, dentro do projeto.
- O **site** do jogo (landing + privacidade + termos) é outro repo irmão, criado
  na Fase 4 por `/game-pipeline:site-legal` — não crie agora, mas deixe a Fase 4
  do roadmap apontando para ele.
- Quando o projeto for pinado com `fvm use <versao>`, confirme que o
  `.fvmrc` existe antes do primeiro commit — os hooks e o CI dependem dele.
- NUNCA crie o projeto dentro do hub. Se `dirname $PWD` não for gravável, pergunte ao usuário onde criar.
- Um projeto por vez: se já existir um projeto irmão em Fase 0/1 incompleta, avise antes de criar outro.
