# Roadmap de Desenvolvimento — <nome do jogo>

> **Documento vivo. Fonte da verdade do PROGRESSO do projeto.** Uma sessão nova (chat novo) lê ESTE arquivo primeiro para saber onde paramos e o que vem a seguir — antes de qualquer código. Mantê-lo atualizado é obrigatório (ver "Manutenção" no fim).
>
> Ele NÃO substitui: `docs/prd.md` (visão/PRD), `docs/architecture.md` (arquitetura), `docs/features/<slug>.md` (plano de cada feature), `docs/setup-manual/` (o que só o humano faz), `design/claude-design.json` (fonte de UI). Ele **orquestra** a ordem em que tudo isso é executado.

## Estado atual (resumo de 1 linha)
<preencher: em que fase/feature estamos e qual a próxima ação>

---

## Fases do pipeline

| Fase | O que é | Estado |
|---|---|---|
| 0 — Pesquisa & Ideação | Visão, mercado, monetização, escopo do MVP → `docs/prd.md` | ⬜ |
| 1 — Design & DS | Protótipo + DS no Claude Design (`/design-kickoff`) → materializado (`/materialize-design-system`) | ⬜ |
| 2 — Features | Implementação feature a feature via `/build-feature`, na ordem abaixo | ⬜ |
| 3 — Serviços de plataforma | Ads, IAP, cloud save, notificações, áudio — cada um destravado por um doc de `docs/setup-manual/` | ⬜ |
| 4 — Lançamento | Site+legal, domínio, CI, ícone, screenshots, ficha das lojas, release | ⬜ |

### Detalhe da Fase 1
- [ ] Projeto vinculado ao Claude Design (`design/claude-design.json`, project_id).
- [ ] Protótipo + DS + tokens validados no Claude Design (gate humano de design).
- [ ] DS materializado em `lib/design_system/` + `design/tokens.json`.

---

## Fase 2 — Sequência de features (ordem obrigatória por dependência)

Ordem pensada por dependência técnica: domínio/persistência antes de telas; o coração do jogo antes dos satélites; navegação depois das telas que ela conecta. Cada linha só começa quando as dependências estão ✅. Reordenar exige decisão do usuário.

| # | Slug | O que entrega | UI? | Depende de | Estado | Branch / PR |
|---|---|---|---|---|---|---|
| — | `design-system` | Fundação de UI (tokens, tema, componentes) | fundação | Fase 1 | ⬜ | — |
| 1 | `<slug>` | <o que entrega> | não | — | ⬜ | — |
| 2 | `<slug>` | ... | sim | 1 | ⬜ | — |

<Derive a lista e a ordem das features do MVP em `docs/prd.md`. Regra geral: lógica de domínio e persistência primeiro (sem UI), depois o loop de jogo, depois telas satélite, depois navegação/hub, por último serviços de plataforma (Fase 3).>

---

## Fase 3 — Serviços de plataforma (depois do core jogável)

Cada um é uma feature via `/build-feature`, atrás de interface em `domain/services/`. **A coluna "Destrava com" é um doc de `docs/setup-manual/` que só o humano faz** — sem ele, a feature não começa (nada de placeholder).

| # | Serviço | Destrava com | Estado |
|---|---|---|---|
| 1 | áudio (SFX/música) | — (assets) | ⬜ |
| 2 | notificações locais | — | ⬜ |
| 3 | ads (`google_mobile_ads`) | [`03-ads-admob.md`](setup-manual/03-ads-admob.md) (test ads já; reais → `00`) | ⬜ |
| 4 | compras (`in_app_purchase`) | [`00`](setup-manual/00-play-console.md) + [`04`](setup-manual/04-iap-play-console.md) + build interno | ⬜🔒 |
| 5 | cloud save (`games_services`) | [`00`](setup-manual/00-play-console.md) + [`05`](setup-manual/05-cloud-games-services.md) (2 SHA-1) | ⬜🔒 |
| 6 | branding (ícone/splash) | [`06`](setup-manual/06-branding-icone-splash.md) — independente, pode fazer já | ⬜ |

---

## Fase 4 — Lançamento (ordem por dependência)

> Regra: o que é **grátis e destrava outras coisas** vem primeiro; o que custa conta paga vem quando o app já está jogável. Detalhe de cada item em `docs/setup-manual/`.

| # | Passo | Skill / doc | Depende de | Estado |
|---|---|---|---|---|
| 1 | **Site + legal** (landing, `/privacidade`, `/termos`) — repo irmão `<slug>-site` | `/game-pipeline:site-legal` · [`01`](setup-manual/01-site-legal.md) | PRD + DS | ⬜ |
| 2 | **Domínio + Cloudflare Pages** (compra, DNS, HTTPS, `app-ads.txt`) | [`02`](setup-manual/02-dominio-hospedagem.md) | 1 | ⬜ |
| 3 | **Raiz Android** — Play Console, app criado, keystore, build interno | [`00`](setup-manual/00-play-console.md) | — | ⬜ |
| 4 | **Raiz iOS** — Apple Developer, app no App Store Connect, capabilities | [`08`](setup-manual/08-app-store-connect.md) | — | ⬜ |
| 5 | **CI/CD** — `codemagic.yaml` (IPA sem Mac + AAB), TestFlight | [`09`](setup-manual/09-codemagic-ci.md) | 4 | ⬜ |
| 6 | **Ícone + splash + feature graphic** | [`06`](setup-manual/06-branding-icone-splash.md) | DS | ⬜ |
| 7 | **Ficha + ASO** (título, descrições, keywords, declarações) | [`07`](setup-manual/07-aso-ficha-loja.md) | 1–4, 6 | ⬜ |
| 8 | **Screenshots das lojas** (Play 9:16 · iPhone 6,9" · iPad 13") | `/game-pipeline:store-screenshots` · [`10`](setup-manual/10-screenshots-lojas.md) | telas prontas + 7 | ⬜ |
| 9 | **Declarações de privacidade** — Data Safety (Play) + App Privacy (Apple), batendo com o texto do site | [`07`](setup-manual/07-aso-ficha-loja.md) | 1, 3, 4 | ⬜ |
| 10 | **Faixa de teste → produção** (interna → aberta → prod; TestFlight → App Store) | [`00`](setup-manual/00-play-console.md) / [`08`](setup-manual/08-app-store-connect.md) | tudo acima | ⬜ |
| 11 | **Pós-lançamento** — A/B de ficha, ads reais vinculados, monitorar crash/reviews | [`03`](setup-manual/03-ads-admob.md) passos 6–7 · [`07`](setup-manual/07-aso-ficha-loja.md) Parte F | 10 | ⬜ |

**Armadilhas que atrasam lançamento** (aprendidas na prática):
- URL de política de privacidade é **campo obrigatório** nas duas lojas → passo 1 cedo.
- Produtos de IAP **só ativam** depois de um build numa faixa.
- Games Services precisa dos **dois** SHA-1 (upload **e** distribuição).
- Game Center só pode ser marcado **depois** de um build com o entitlement no TestFlight.
- Ads reais exigem app **publicado e vinculado** no AdMob (review de 2–3 dias).
- Domínio expirado derruba a URL de privacidade → renovação automática ligada.

---

## Próxima ação concreta
1. <passo imediato>
2. ...

---

## Manutenção deste documento (obrigatório)
- **Sessão nova:** leia este arquivo ANTES de agir. Foco = item 🔨/⬜ de menor # não bloqueado.
- **Ao concluir uma feature** (`/build-feature`, Etapa 8): linha → ✅, registre a PR, promova a próxima em "Próxima ação".
- **Ao concluir uma fase:** marque a fase e ajuste o "Estado atual (resumo de 1 linha)".
- **Mudança de escopo/ordem:** só com decisão do usuário; reflita aqui E no `docs/prd.md` se mudar o MVP.
- Legenda: ✅ concluído · 🔨 em andamento · ⬜ pendente · 🔒 bloqueado.
