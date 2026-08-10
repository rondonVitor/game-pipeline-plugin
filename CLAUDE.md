# game-pipeline — HUB / INCUBADORA

Esta pasta NÃO é um projeto de jogo. É o hub que contém o plugin (agents, skills, hooks, templates) e serve de incubadora: aqui nascem as ideias, e cada jogo aprovado vira uma pasta IRMÃ desta (fora daqui).

## Papel do Claude nesta pasta
Quando uma sessão abre aqui, o objetivo é um só: descobrir e validar o próximo jogo, e então materializá-lo fora do hub. (O outro trabalho legítimo aqui é **meta**: melhorar o próprio pipeline.)

### Workflow da incubadora
1. **Fase 0 — Pesquisa & Ideação**
   - Invoque o subagent `market-researcher` (mercado casual/hyper-casual offline, potencial global, lançamento BR, projeção de monetização).
   - Depois o `game-ideator` para gerar e ranquear conceitos factíveis.
   - Salve os relatórios em **`research/` (do hub)** e apresente o **top 3** resumido.
2. **GATE HUMANO** — o usuário escolhe o conceito (ou pede outra rodada). Nada é criado antes disso.
3. **Materialização** — rode `/game-pipeline:new-game <slug>`:
   - Cria a pasta do projeto FORA do hub (irmã: `../<slug>/`).
   - Copia o scaffold: `CLAUDE.md`, `docs/templates`, `docs/architecture.md`,
     **`docs/setup-manual/`** (contas, lojas, domínio, CI) e **`ci/codemagic.yaml`**.
   - Move a pesquisa aprovada para `docs/research/` do projeto e gera `docs/prd.md` + `docs/roadmap.md` (com Fase 3 e Fase 4 já mapeadas).
   - Inicializa git e, se o usuário quiser, o repo no GitHub.
   - **Nada a instalar no projeto:** o plugin está no escopo do usuário (instalado a partir deste hub), logo já vale em qualquer pasta da máquina. O `new-game` só documenta o "setup em outra máquina" no CLAUDE.md do projeto.
4. **Handoff** — `cd ../<slug> && claude`. Dali o projeto segue o próprio workflow (Fase 1 Design → Fase 2 features → Fase 3 serviços → Fase 4 lançamento), com `docs/roadmap.md` como arranque de toda sessão.

## O que o pipeline entrega além do código
Um jogo não vai à loja só com código. O template já nasce com o caminho completo:
- **`docs/setup-manual/`** — 11 docs do que só o humano faz: Play Console, App
  Store Connect, AdMob, IAP, Games Services, branding, **site+legal**,
  **domínio/Cloudflare**, **CI Codemagic**, ficha/ASO, **screenshots das lojas**.
- **Skills de lançamento** — `/game-pipeline:site-legal` (repo irmão com landing +
  privacidade + termos em Astro) e `/game-pipeline:store-screenshots` (arte das
  fichas a partir das telas do Claude Design).
- **Fase 4 do roadmap** — ordem por dependência, com as armadilhas conhecidas
  (URL de privacidade obrigatória, IAP só ativa com build em faixa, dois SHA-1 do
  Games Services, Game Center só depois do TestFlight, ads reais só com app
  vinculado).

## Regras do hub
- NUNCA desenvolver jogo dentro do hub. Nenhum `flutter create`, nenhum código de jogo aqui.
- **Fidelidade de UI ao Claude Design (política do pipeline):** todo projeto materializado usa o Claude Design como fonte da verdade de UI, via MCP `claude_design` (`design/claude-design.json`). Fase 1: `/game-pipeline:design-kickoff` → gate humano → `/game-pipeline:materialize-design-system`. Nas features: `feature-researcher`/`devil-advocate` têm as tools `mcp__claude_design__*`; `/build-feature` bloqueia UI sem DS materializado; `/game-pipeline:ui-fidelity-check` firma goldens contra a fonte. Sessões de UI precisam do MCP conectado.
- `research/` acumula pesquisas reaproveitáveis entre projetos — antes de pesquisar do zero, leia o que já existe e atualize só o defasado.
- Mudanças no pipeline (agents, skills, hooks, templates em `plugins/game-pipeline/`) são meta-trabalho: **commit aqui + bump de `version`** no `plugin.json` (e no `marketplace.json`, mantendo os dois iguais), e os projetos recebem via `/plugin update`.
- Ideias descartadas não somem: 1 linha por ideia rejeitada + motivo em `research/descartadas.md`.
- Aprendizado de projeto volta pro hub: quando um projeto resolver na mão algo que
  faltava no pipeline (um passo de loja, um fix de hook), **porte para cá** — foi
  assim que os docs de site/domínio/CI e o parser de hook sem `python3` nasceram.

## Setup do hub (primeira vez nesta máquina)
```
/plugin marketplace add <caminho-absoluto-desta-pasta>
/plugin install game-pipeline@game-pipeline-marketplace
```
Isso deixa o plugin ativo em todas as pastas da máquina, incluindo os projetos que a incubadora criar. Para testar mudanças antes de instalar: `claude --plugin-dir ./plugins/game-pipeline` + `/reload-plugins` a cada edição.
