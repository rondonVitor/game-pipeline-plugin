# game-pipeline — hub + plugin do Claude Code

Incubadora de jogos mobile (Flutter). Este repo é duas coisas ao mesmo tempo:
1. **Hub/incubadora** — você abre o Claude Code AQUI para pesquisar e escolher o próximo jogo.
2. **Marketplace local do plugin** — agents, skills, hooks e templates que todos os projetos criados vão usar. O hub vive só nesta máquina (não precisa de GitHub).

## Setup (uma vez por máquina)
```bash
cd game-pipeline-plugin && claude
```
Dentro da sessão:
```
/plugin marketplace add <caminho-absoluto-desta-pasta>
/plugin install game-pipeline@game-pipeline-marketplace
```
O plugin fica no escopo do usuário — ativo em todas as pastas da máquina.

## Fluxo end-to-end
```
[HUB]  abrir claude aqui
  └► Fase 0: market-researcher + game-ideator ► top 3 ► VOCÊ ESCOLHE
  └► /game-pipeline:new-game <slug>
        cria ../<slug>/ (FORA do hub): CLAUDE.md, docs/ (templates, arquitetura,
        setup-manual das lojas), ci/codemagic.yaml, PRD + roadmap, git/GitHub
[PROJETO]  cd ../<slug> && claude
  └► Fase 1: design-brief ► /design-kickoff ► VOCÊ APROVA ► /materialize-design-system
  └► Fase 2: /build-feature <slug>, uma por vez:
        pesquisa ► plano ► devil-advocate ► VOCÊ APROVA ► dev ►
        devil-advocate no diff ► ui-fidelity-check ► quality-gate ► PR ► roadmap
  └► Fase 3: serviços (ads/IAP/cloud/áudio) — cada um destravado por um doc de
        docs/setup-manual/ (conta, ids, chaves). Sem pré-requisito, sem código.
  └► Fase 4: LANÇAMENTO
        /site-legal (repo irmão: landing + privacidade + termos, Astro)
        ► domínio + Cloudflare Pages ► Play Console / App Store Connect
        ► Codemagic (IPA sem Mac) ► ícone/splash ► ficha + ASO
        ► /store-screenshots ► declarações de privacidade ► faixas ► produção
```

## Estrutura
```
game-pipeline-plugin/
├── CLAUDE.md                     # instruções do modo incubadora
├── research/                     # pesquisas de mercado acumuladas entre projetos
├── .claude-plugin/marketplace.json
└── plugins/game-pipeline/
    ├── .claude-plugin/plugin.json
    ├── agents/                   # market-researcher, game-ideator, feature-researcher, devil-advocate
    ├── skills/                   # new-game, init-project, build-feature, design-kickoff,
    │                             # materialize-design-system, ui-fidelity-check,
    │                             # site-legal, store-screenshots, flutter-quality,
    │                             # critical-review, caveman
    ├── hooks/hooks.json          # quality-gate (Stop), format (PostToolUse), guard-git (PreToolUse)
    ├── scripts/                  # os 3 hooks (sem dependência de python; detectam fvm)
    ├── project-template/         # o que vai para o repo do JOGO
    │   ├── CLAUDE.md · docs/{architecture,templates,setup-manual}/ · ci/codemagic.yaml
    └── project-template-site/    # o que vira o repo do SITE (Astro: landing + legal)
```

## Manutenção do pipeline
Melhorou um agent, skill, gate ou template? Commit aqui + bump da `version` em
`plugins/game-pipeline/.claude-plugin/plugin.json` **e** em
`.claude-plugin/marketplace.json` (mantenha iguais) + `/plugin update game-pipeline`
nos projetos. Para testar antes: `claude --plugin-dir ./plugins/game-pipeline` e
`/reload-plugins` a cada edição.

## Notas
- O hub nunca contém código de jogo — cada jogo vive em pasta irmã com repo próprio; o site do jogo é um terceiro repo (`<slug>-site`).
- Criar pasta irmã pede aprovação de permissão (escrita fora do diretório da sessão).
- O quality-gate só ativa onde existe `pubspec.yaml` — não incomoda no hub, nas Fases 0/1 nem no repo do site.
- Os hooks **não dependem de `python3`** (no Windows ele costuma ser o stub da Microsoft Store, que falha silenciosamente e desarma o guard) e usam `fvm` quando o projeto tem `.fvmrc`.
