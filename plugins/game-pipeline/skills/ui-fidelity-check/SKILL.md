---
name: ui-fidelity-check
description: Verifica que uma tela/feature de UI construída bate com a tela-fonte no Claude Design — captura render_preview da fonte, roda golden test do Flutter e compara, apontando divergências de layout/cor/spacing/copy. Use na Etapa 6 do /build-feature de qualquer feature com UI, e sempre que quiser conferir fidelidade visual. Invocável como /game-pipeline:ui-fidelity-check <slug>.
---

# /game-pipeline:ui-fidelity-check <slug>

Fecha a lacuna "a tela bate com o protótipo?" com o máximo de automação possível. NÃO é um gate 100% automático (comparar pixel a pixel um render Flutter contra um screenshot do Claude Design não é confiável — DPR, fontes e viewport diferem). É um gate **semi-automático**: golden tests garantem que a tela Flutter não regride, e a comparação contra a fonte é assistida por `render_preview`.

## Pré-condições
- MCP `claude_design` conectado; `design/claude-design.json` com `project_id`.
- `docs/features/<slug>.md` tem a seção "Referências de UI (Claude Design)" com as telas-fonte.

## Passos
1. **Mapear telas.** Do doc da feature, liste os pares (widget/rota Flutter ↔ tela-fonte no Claude Design).
2. **Capturar a fonte.** Para cada tela-fonte, `mcp__claude_design__render_preview(project_id, path, render:true)` → screenshot + `text_content`. Salve o screenshot como referência em `design/screens/<slug>/<tela>.png` (referência humana; NÃO é o golden). Nunca exponha `serve_url` — só o `open_url` é compartilhável.
3. **Golden test do Flutter.** Para cada tela, garanta um golden test em `test/golden/<slug>/` que bombeia o widget num frame de 390×844 (o frame do protótipo) e compara com `test/golden/<slug>/<tela>.png`. Primeira vez: `fvm flutter test --update-goldens` gera o baseline; revise o baseline contra o screenshot da fonte ANTES de aceitá-lo (é aqui que a fidelidade entra). Depois, `fvm flutter test` falha se a tela regredir.
4. **Comparar fonte × Flutter.** Ponha o `render_preview` da fonte lado a lado com o golden do Flutter. Aponte divergências de: layout/posição, cor (deve vir de token), spacing/raio/sombra, tipografia (peso/tamanho), e **copy PT-BR exata** (acentuação inclusa). Use o `text_content` do render para conferir a copy sem OCR.
5. **Veredito.** Liste divergências como BLOQUEANTE (cor/medida solta, tela que não corresponde, copy errada) ou não-bloqueante (anti-aliasing, diferença sub-pixel). Bloqueante = corrigir antes de fechar a feature.

## Integração
- Rode dentro da **Etapa 6** do `/build-feature` (junto do `devil-advocate`), antes do gate automático.
- Os golden tests entram na suíte: a partir daí `fvm flutter test` (logo, o `quality-gate.sh`) protege contra regressão visual automaticamente.
- **Screenshots de loja ≠ goldens:** a arte das fichas sai de
  `/game-pipeline:store-screenshots` (Fase 4), a partir de telas reais do app.

## Limite conhecido (honesto)
Não há comparação pixel-automática fonte↔Flutter no `Stop` hook — seria caro (build + render headless) e frágil. O que É automático: os golden tests (regressão da tela contra seu próprio baseline aprovado). O que continua assistido: validar que o baseline bate com o Claude Design (passo 3–4). Evoluir para diff-visual headless no CI é backlog — registre em `docs/decisions/` se decidirem investir.
