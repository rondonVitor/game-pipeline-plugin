# Feature: <nome>

**Slug:** `<slug>` · **Branch:** `feature/<slug>` · **Status:** planejada | em dev | em review | mergeada

## Objetivo
O que essa feature muda pro jogador, em 1-2 frases.

## Critérios de aceite
- [ ] ...
- [ ] ...

## Referências de UI (Claude Design) — obrigatório se a feature tem UI
Fonte da verdade: `design/claude-design.json` (`project_id`).
- Tela(s)-fonte: arquivo/rota no protótipo do Claude Design
- Componentes reutilizados: ...
- Tokens envolvidos: `tokens/*.css`
- Critérios de aceite de UI verificáveis contra `render_preview` dessas telas.
- Tokens novos materializados em `design/tokens.json` + `lib/design_system/` — extraídos da fonte, não chutados.

## Pré-requisito manual (se a feature depende de serviço externo)
Doc de `docs/setup-manual/` que a destrava (ads/IAP/cloud/CI/loja) e o estado
dele: concluído? ids/chaves em mãos? Sem isso a feature não começa.

## Abordagem técnica
Resumo da abordagem escolhida (do relatório do feature-researcher) e por quê.

## Arquivos afetados
- `lib/...` — o quê

## Testes previstos
- unit: ...
- widget: ...

## Fora do escopo
O que deliberadamente NÃO entra nesta feature.

## Impacto nas lojas (preencher se houver)
SDK novo, permissão nova, dado coletado, produto de IAP → o que precisa mudar em:
política de privacidade do site · Data Safety (Play) · App Privacy (Apple) · ATT ·
ficha/ASO. Registre também na Fase 4 do `docs/roadmap.md`.

## Review adversarial
Apontamentos do devil-advocate e como foram resolvidos.

## Dívidas
Não-bloqueantes registrados durante o review da implementação.
