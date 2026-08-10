# Design Brief — <nome do jogo>

> Documento para colar no Claude Design. Pedido: gerar (1) design system completo com tokens exportáveis e (2) protótipo navegável de todas as telas listadas.

## O jogo em 3 frases
Conceito, core loop e sensação desejada.

## Público e contexto de uso
Jogador casual brasileiro, Android de entrada, sessões de < 3 min (fila, transporte, intervalo). Uma mão, modo retrato, offline.

## Direção visual
Referências, mood (ex: colorido e amigável vs. minimalista), o que EVITAR.

## Telas do MVP (protótipo deve cobrir todas)
1. Splash / carregamento
2. Menu principal (jogar, recordes, configurações)
3. Gameplay (HUD: pontuação, pausa, vidas/tempo)
4. Pausa
5. Game over (pontuação, recorde, jogar de novo)
6. Configurações (som, vibração, idioma)

## Fluxos de navegação
menu → gameplay → game over → (jogar de novo | menu). Pausa acessível durante gameplay.

## Design System (ENTREGÁVEL PRINCIPAL — completo, não espalhado pelas telas)
Entregue um **artifact único e fechado** com as três partes. As telas consomem o DS, não o substituem — se uma tela precisa de um componente, ele é projetado no DS primeiro.
- **Tokens em JSON** (`tokens.json`, nomes semânticos): cores (marca, surface, texto, feedback, recompensa, com variantes de estado), tipografia (famílias + escala completa), espaçamento, raios, elevação, motion (durações/easing), opacidade.
- **Biblioteca de componentes** com TODOS os estados (normal/pressionado/desabilitado/foco/carregando/vazio/erro): botão primário/secundário/de-vídeo/ícone, card, dialog/modal, toggle, HUD, SnackBar (sucesso/erro/aviso/info — casa com `AppSnackBar`), barra de progresso, bottom nav.
- **Regras de uso** (do/don't, hierarquia, espaçamento).
- Acessibilidade: contraste AA, alvos de toque ≥ 48dp. Textos em pt-BR.

## Logo e identidade de marca (ENTREGÁVEL)
- **Logo principal** (lockup horizontal + empilhado) e **símbolo/ícone isolado** que sirva de **ícone do app** (legível em 48×48, reconhecível na loja).
- Variações: cores, monocromática, sobre fundo escuro (splash). Área de proteção, tamanho mínimo e o que evitar.
- Exportar em **SVG/vetor**, com preview aplicado na Splash e como ícone.

## Entregáveis esperados de volta
1. **Design System completo** (tokens + componentes com estados + regras) → `tokens.json` vai para `design/tokens.json`
2. **Logo + ícone do app** (vetor + variações) → `design/` (e depois assets/ícone/splash)
3. Screenshots/export das telas aprovadas, consumindo o DS → `design/screens/`
4. Notas de interação (animações, transições, feedback tátil)
