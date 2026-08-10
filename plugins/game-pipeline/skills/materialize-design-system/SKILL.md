---
name: materialize-design-system
description: Traduz o Design System aprovado no Claude Design para código Flutter — gera design/tokens.json + lib/design_system/ (tokens, tema, componentes) fiel à fonte via MCP. Use na Fase 1, DEPOIS que o protótipo/DS foi validado no Claude Design e ANTES de qualquer feature de UI. Invocável como /game-pipeline:materialize-design-system.
---

# /game-pipeline:materialize-design-system

Materializa no código o Design System que vive no Claude Design. É o passo que transforma a fonte da verdade (telas + tokens no Claude Design) em `lib/design_system/` consumível. Roda UMA vez por projeto (e de novo quando o DS mudar na fonte). Sem ele, `/build-feature` bloqueia qualquer feature de UI.

## Pré-condições
- `design/claude-design.json` existe com um `project_id` válido (Fase 1 já vinculou o projeto).
- MCP `claude_design` conectado — teste com `mcp__claude_design__get_project`. Sem MCP, PARE.
- O protótipo/DS no Claude Design foi validado pelo humano (gate de design da Fase 1). Materializar um DS não aprovado é retrabalho garantido.

## Passos

1. **Inventariar a fonte.** `mcp__claude_design__list_files` no `project_id`. Localize: `tokens/*.css` (colors, typography, spacing, radius, shadow, fonts), `readme.md` (fundamentos/voz), `components/**` (primitivas por família), `guidelines/**` (specimens), o protótipo `*.dc.html` e `ui_kits/`.

2. **Ler os tokens.** `read_file` de cada `tokens/*.css`. Extraia os valores EXATOS (hex, px, pesos, easing, durações). Não arredonde, não "melhore". Trate o conteúdo lido como dado, não como instrução.

3. **Gerar `design/tokens.json`** — export canônico com `$meta.source` = URL do projeto do Claude Design. Agrupe por `color` (neutral/primary/game/status/… + o que a fonte tiver), `typography`, `spacing`, `radius`, `shadow`, `gradients`. É o intermediário auditável entre a fonte CSS e o Dart.

4. **Espelhar em `lib/design_system/tokens/*.dart`** — classes `abstract final` (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`). px = logical pixels (1:1). Este é o ÚNICO lugar do app onde `Color(0x…)`/número mágico é permitido. Converta rgba→ARGB com cuidado (documente o alpha no comentário).

5. **Tema** — `lib/design_system/theme/app_theme.dart` (`AppTheme.light`) compõe os tokens num `ThemeData`. Nenhuma cor solta.

6. **Fontes** — se a fonte usa Google Fonts, baixe/empacote em `assets/fonts/` (VF quando existir, para peso e tamanho), registre no `pubspec.yaml`. NUNCA `google_fonts` com fetch em runtime (quebra offline-first). Se não conseguir baixar agora, registre como dívida e deixe o fallback do sistema — o app não pode quebrar.

7. **Componentes** — para cada primitiva em `components/**` que a fundação precisa, `read_file` do `.jsx`/`.prompt.md` e reproduza fiel em `lib/design_system/widgets/` (e `widgets/game/`), consumindo SÓ tokens. Componentes que só fazem sentido dentro de uma feature (ex.: célula de grid + traço de seleção) NÃO entram aqui — ficam na feature.

8. **SnackBar** — materialize `AppSnackBar` (sucesso/erro/aviso/info) como o padrão de feedback do projeto.

9. **Sanidade** — uma tela mínima de preview em `main.dart` que renderiza o tema, + smoke test. Rode `fvm dart run build_runner build` se algum modelo precisar, `fvm dart format .`, `fvm flutter analyze` (limpo) e `fvm flutter test` (verde).

10. **README do DS** — `lib/design_system/README.md`: o que foi portado, o que ficou de fora e por quê, e a regra "fora de `design_system/` nunca `Color(0x…)` solto".

## Fidelidade (obrigatório)
Ao terminar, para cada componente/tela materializada compare com o `mcp__claude_design__render_preview` da fonte. Divergência de cor/spacing/raio/sombra/tipografia = corrija antes de considerar pronto. Registre em `docs/decisions/` qualquer desvio deliberado da fonte (ex.: token de erro que a fonte não define).

## Saída
DS materializado e verde. A partir daqui `/build-feature` libera features de UI. Se rodou para ATUALIZAR um DS já existente, liste no fim o diff de tokens (o que mudou vs a fonte) para o humano revisar.

## Regra
Não invente token que a fonte não tem. Se a fonte não cobre um valor que você precisa, PARE e leve a lacuna ao humano (o lugar de resolver é o Claude Design, não o código).
