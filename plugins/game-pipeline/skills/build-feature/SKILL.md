---
name: build-feature
description: Orquestrador do ciclo completo de uma feature — pesquisa, planejamento, gate humano, desenvolvimento e review adversarial. Use SEMPRE que o usuário pedir para implementar, começar ou continuar uma feature do jogo. Invocável como /game-pipeline:build-feature <slug>.
---

# /game-pipeline:build-feature <slug>

Ciclo obrigatório por feature. As etapas rodam NESTA ORDEM e nenhuma pode ser pulada. Se o usuário pedir pra pular uma etapa, aponte o risco e peça confirmação explícita.

## Pré-condições (verifique antes de começar)
- **Leia `docs/roadmap.md`.** Confirme que `<slug>` é a próxima feature pendente (menor # não bloqueado) e que as dependências dela estão ✅. Feature fora de ordem: aponte a dependência faltante e peça confirmação. Sem feature indicada, pegue a próxima do roadmap.
- `docs/prd.md` existe e a feature consta no escopo do MVP. Se não consta: pare e pergunte se o escopo mudou (mudança de escopo = atualizar PRD primeiro).
- **Se a feature tem UI:** três checagens, todas obrigatórias:
  1. `design/claude-design.json` existe com um `project_id` válido E o MCP `claude_design` conectado (teste com `mcp__claude_design__get_project`). A UI é espelho do Claude Design, não se inventa.
  2. **DS materializado:** `lib/design_system/` + `design/tokens.json` existem. Se NÃO existirem, PARE e rode `/game-pipeline:materialize-design-system` primeiro — feature de UI não começa sem o DS traduzido da fonte. Nunca materialize tokens ad-hoc dentro da feature.
  3. Se qualquer uma falhar, feature de UI PARA. Avise o usuário com o passo que falta.
- **Se a feature depende de serviço externo** (ads, compras, cloud save, push, CI,
  publicação): o doc correspondente em `docs/setup-manual/` precisa estar
  **concluído**, com ids/chaves reais em mãos. Sem isso a feature **não começa** —
  nada de placeholder "ligo depois". Aponte ao usuário exatamente qual doc falta.
- Working tree limpa. Crie a branch: `git checkout -b feature/<slug>`.

## Etapa 1 — Pesquisa (inclui levantamento de UI no Claude Design)
Invoque o subagent `feature-researcher` com a descrição da feature. Ele investiga o código existente e as opções técnicas.
**Se a feature tem UI**, o researcher OBRIGATORIAMENTE mapeia a feature → tela(s)/componentes/tokens do Claude Design (via `mcp__claude_design__*`, project_id em `design/claude-design.json`) e devolve no relatório a lista exata de arquivos-fonte a reproduzir + os valores visuais já extraídos da fonte (cor, spacing, raio, sombra, tipografia, copy). Sem esse mapa, o plano de UI não pode ser escrito.

## Etapa 2 — Planejamento
Com o relatório em mãos, escreva `docs/features/<slug>.md` usando `docs/templates/feature.md`. O plano define: objetivo, critérios de aceite, abordagem técnica, arquivos afetados, testes previstos, o que fica FORA do escopo.
**Se a feature tem UI:** preencha a seção "Referências de UI (Claude Design)" com as telas/componentes/tokens-fonte. Critérios de aceite de UI são verificáveis contra o `render_preview` dessas telas. Tokens novos entram em `design/tokens.json` + `lib/design_system/` extraídos da fonte, nunca chutados.

## Etapa 3 — Review adversarial do plano
Invoque o subagent `devil-advocate` sobre o plano. Incorpore as correções bloqueantes no doc antes de prosseguir.

## Etapa 4 — GATE HUMANO
Apresente ao usuário: o plano final (resumido em ~10 linhas) + os apontamentos do devil-advocate + como foram resolvidos. **Pare e aguarde aprovação explícita.** Não implemente nada antes do "aprovado".

## Etapa 5 — Desenvolvimento
Implemente seguindo o plano e a skill `flutter-quality`. Commits pequenos com conventional commits. Se descobrir no meio que o plano estava errado: pare, atualize o doc, e se a mudança for estrutural, volte ao gate humano.
**UI:** reproduza fiel as telas/componentes do Claude Design listados no plano; reabra a fonte com `read_file` para qualquer valor exato (cor, spacing, raio, sombra, copy). Cor/medida solta fora do `design_system/` = proibido. Antes de fechar, compare sua tela com o `render_preview` da tela-fonte.

## Etapa 6 — Review da implementação (código + fidelidade visual)
Invoque o `devil-advocate` sobre o diff (`git diff main...HEAD`). Se a feature tem UI, ele TAMBÉM compara a UI construída contra o Claude Design (`read_file`/`render_preview`) e reprova divergência de layout/cor/spacing/copy. **Feature com UI:** rode também `/game-pipeline:ui-fidelity-check <slug>` — captura o `render_preview` da fonte, firma golden tests da tela e aponta divergências; os goldens passam a proteger contra regressão visual na suíte. Corrija os bloqueantes. Registre os não-bloqueantes no doc da feature (seção "Dívidas").

## Etapa 7 — Gate automático e PR
O hook `quality-gate.sh` precisa passar limpo. Então:
```
git push -u origin feature/<slug>
gh pr create --title "feat: <slug>" --body "$(resumo do doc + como testar)"
```
Informe o link do PR ao usuário. O merge é dele, não seu.

## Etapa 8 — Atualizar o roadmap
Atualize `docs/roadmap.md`: marque a linha da feature como ✅ (ou 🔨 em review até o merge), registre a PR, promova a próxima feature em "Próxima ação" e ajuste o "Estado atual". Entra no mesmo PR (ou num commit `docs:` de fechamento). Sem isso, a próxima sessão se perde.
Se a feature mudou algo que a **ficha da loja declara** (SDK novo, dado coletado,
permissão, produto de IAP), anote na **Fase 4** o que precisa ser atualizado:
política de privacidade do site, Data Safety (Play), App Privacy (Apple), ATT.

## Regra de ouro
Uma feature por vez. Nunca comece a próxima com um PR aberto sem decisão do usuário.
