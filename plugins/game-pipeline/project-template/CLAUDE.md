# Projeto: <nome do jogo> (Flutter)

Pipeline automatizado de criação de jogo mobile: pesquisa → ideação → design →
implementação feature por feature → lançamento nas lojas, com gates de qualidade
entre fases.

## 🧭 Arranque de sessão (SEMPRE, antes de agir)
Chat novo = leia **`docs/roadmap.md`** primeiro. É a fonte da verdade do PROGRESSO: em que fase estamos, qual feature é a próxima, o que depende do quê. O foco é sempre o item 🔨/⬜ de menor número não bloqueado. Não escolha a próxima tarefa "de cabeça" — o roadmap decide. Ao concluir feature/fase, **atualize o roadmap**. Ordem/escopo só mudam com decisão do usuário.

## Contexto do produto
- Jogo casual/hyper-casual, sessões curtas, offline-first.
- Público-alvo de lançamento: Brasil (pt-BR primeiro, i18n preparado).
- Stack: **Flutter puro**; Flame só se o jogo tiver game-loop de verdade
  (grid/tabuleiro/menus são widgets — não force o motor).
- **Arquitetura canônica: `docs/architecture.md`** (Clean + feature-first,
  `ValueNotifier` + `get_it` + `result_dart`). É lei — toda feature segue.

## Fonte da verdade de UI — Claude Design (LEI, não-negociável)
Toda UI deste app **espelha o projeto no Claude Design**, via MCP `mcp__claude_design__*`. Ponteiro em `design/claude-design.json` (`project_id`).
- **Nunca inventar UI.** Antes de escrever/editar qualquer tela, widget, cor, spacing, raio, sombra ou copy: `read_file` da tela/componente/token alvo e reproduza fiel.
- `design/tokens.json` + `lib/design_system/` são a **materialização** local dos tokens. Divergiu? O Claude Design vence — reimportar.
- Fidelidade se verifica com `render_preview` contra a tela implementada.
- Sem o MCP `claude_design` conectado, feature de UI para.

## Comandos — **SEMPRE via `fvm`**
A versão do Flutter é pinada em `.fvmrc` para dev e CI (Codemagic) usarem a
MESMA. Nunca chame `flutter`/`dart` direto.
```bash
fvm flutter pub get
fvm dart run build_runner build --delete-conflicting-outputs
fvm flutter analyze
fvm flutter test
fvm flutter run
fvm use <versao>    # troca/pina a versão do projeto
```
Os hooks do plugin (`quality-gate.sh`, `format-check.sh`) detectam fvm sozinhos.

## Estrutura (Clean + feature-first — detalhe em `docs/architecture.md`)
```
lib/
├── core/                   # DI helpers, constantes, utils
├── design_system/          # tokens, tema, componentes (AppSnackBar, botões)
├── features/<x>/
│   ├── data/services/      # implementações concretas
│   ├── domain/{dtos,models,services,enums,errors,states,viewmodels}
│   ├── view/widgets/       # UI (game-loop aqui, se houver)
│   └── <x>_routes.dart
├── shared/                 # compartilhado entre features
├── l10n/                   # strings pt-BR (e futuras)
├── app_routes.dart · app_injections.dart · main.dart
docs/
├── architecture.md         # arquitetura canônica (seguir sempre)
├── roadmap.md              # PROGRESSO — fonte da verdade, leia primeiro
├── prd.md                  # visão do produto (Fase 0)
├── design-brief.md         # doc para o Claude Design
├── setup-manual/           # o que só o humano faz: contas, lojas, domínio, CI
├── decisions/              # ADRs — uma decisão por arquivo
└── features/               # um doc por feature (obrigatório antes do merge)
design/
├── claude-design.json      # ponteiro p/ o Claude Design — fonte da verdade de UI
├── tokens.json             # tokens materializados
├── screens/                # referências do protótipo aprovado
└── store/                  # screenshots/gráficos das lojas (Fase 4)
ci/codemagic.yaml           # base do CI (copiar para a raiz ao configurar)
```

## Workflow de Git
- `main` protegida. Nunca commitar direto na main.
- Branch por feature: `feature/<slug>` | correções: `fix/<slug>`
- Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Todo PR referencia `docs/features/<slug>.md`. Sem doc, sem merge.
- PRs via `gh pr create` com: o quê, por quê, como testar.

## Fases do pipeline (ordem obrigatória)
0. **Pesquisa & Ideação** — subagents `market-researcher` e `game-ideator`. Saída: `docs/prd.md` (com seção **Monetização**: mix ads vs IAP + projeção ARPU/LTV). GATE HUMANO: aprovar a ideia.
1. **Design** — (a) `docs/design-brief.md`; (b) `/game-pipeline:design-kickoff` cria o projeto no Claude Design e grava `design/claude-design.json`; (c) **GATE HUMANO**: humano valida DS + protótipo; (d) `/game-pipeline:materialize-design-system` traduz para `design/tokens.json` + `lib/design_system/`.
2. **Implementação** — feature a feature via `/game-pipeline:build-feature`, **na ordem do `docs/roadmap.md`**: pesquisa → plano → GATE HUMANO → dev → review adversarial → gate automático → atualizar roadmap.
3. **Serviços de plataforma** — ads, IAP, cloud save, notificações, áudio. Cada um **destravado por um doc de `docs/setup-manual/`** (contas/ids/chaves). Sem o pré-requisito manual, a feature não começa — nada de placeholder.
4. **Lançamento** — site + legal (`/game-pipeline:site-legal`), domínio + Cloudflare (`docs/setup-manual/02`), CI (`09`), ícone/splash (`06`), ficha + ASO (`07`), screenshots (`/game-pipeline:store-screenshots`), declarações de privacidade, faixas de teste → produção. Sequência completa na Fase 4 do `docs/roadmap.md`.

## Regras não-negociáveis
- Nunca pular um gate. Gate falhou = corrigir antes de avançar.
- Nunca começar uma feature sem `docs/features/<slug>.md` criado na etapa de plano.
- `docs/roadmap.md` é a fonte da verdade do progresso: seguir a ordem dele e atualizá-lo ao fim de cada feature/fase.
- Nunca inventar UI: tudo espelha o Claude Design. Cor/medida solta fora do `design_system/` é proibida.
- **Nada que dependa de conta/id externo é implementado com placeholder** — o doc de `docs/setup-manual/` correspondente vem primeiro.
- **Texto legal e declarações de loja precisam bater com o que o app faz de fato** (Data Safety, App Privacy, ATT, política de privacidade do site).
- Modo econômico ativo por padrão (skill `caveman`): delegar pesquisa a subagents, respostas curtas, sem reler arquivos já em contexto.
- Antes de qualquer plano ser aprovado, invocar o subagent `devil-advocate`.
- Toda decisão de arquitetura relevante vira um ADR em `docs/decisions/`.
- Persistência local por padrão. Nenhuma chamada de rede em runtime do jogo além dos SDKs opcionais (ads/IAP/cloud), que degradam graciosamente offline.
