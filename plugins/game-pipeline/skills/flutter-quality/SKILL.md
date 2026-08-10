---
name: flutter-quality
description: Padrões de qualidade Flutter deste projeto. Use SEMPRE que for escrever, editar ou revisar código Dart — qualquer arquivo em lib/ ou test/. Use também ao adicionar dependências, criar telas, componentes de jogo, ou decidir arquitetura.
---

# Qualidade Flutter

## Comandos — sempre via `fvm`
O projeto é pinado em `.fvmrc` para dev e CI usarem a mesma versão:
`fvm flutter analyze` · `fvm flutter test` · `fvm dart format .` ·
`fvm dart run build_runner build --delete-conflicting-outputs`.
Chamar `flutter`/`dart` direto pode rodar outra versão e gerar diff fantasma.

## Arquitetura — segue `docs/architecture.md` (Clean + feature-first)
- Camadas por feature: `features/<x>/{data/services, domain/{dtos,models,services,enums,errors,states,viewmodels}, view/widgets, <x>_routes.dart}`. `domain/` nunca importa Flutter.
- Lógica de jogo testável sem renderização: regras, pontuação e progressão em classes puras Dart, sem `BuildContext`. Se usar Flame, o game-loop fica na `view/` e conversa com `domain/` via ViewModel.
- Estado: ViewModel `extends ValueNotifier<State>` + `ValueListenableBuilder`; State imutável (equatable) em pasta separada.
- DI: `get_it`. Erros: `result_dart` (`AsyncResult`/`fold`/`Unit`). Feedback: `AppSnackBar`.
- Persistência local atrás de interface em `domain/services/` (impl em `data/services/`). O resto do app não sabe se é shared_preferences ou hive.
- **Serviço de plataforma (ads/IAP/cloud/notificação) sempre atrás de interface**
  em `domain/services/`, com degradação graciosa offline e quando o produto/id
  não existe. Nada de SDK vazando para a view.

## Regras de código
- Zero warnings de `fvm flutter analyze`. Warnings são erros neste projeto.
- Nenhum número mágico: constantes de gameplay (velocidades, spawn, pontuações) em `lib/core/constants/` — balanceamento num lugar só.
- Nenhuma string de UI hardcoded: tudo via l10n (pt-BR é a base).
- Cores/espaçamentos/tipografia vêm de `lib/design_system/tokens/` (materializado
  de `design/tokens.json` ← Claude Design). **`lib/design_system/` é o único lugar
  onde `Color(0x…)`/número mágico visual é permitido.** Nunca em widget de feature.
- Toda classe pública tem doc comment de 1 linha dizendo por que existe.

## Performance (alvo: 60fps em Android de entrada)
- Zero alocação dentro de `update()`/`render()` (Flame) ou de `build()` chamado a cada frame — pré-aloque e reutilize.
- Sprites em spritesheet/atlas; nada de carregar imagem por imagem em runtime.
- `const` constructors em todo widget que permitir; `RepaintBoundary` em HUD sobreposto.
- Áudio: pré-carregar efeitos no boot; nunca no primeiro uso.
- Layout que depende do tamanho da tela **deriva das constraints** (não fixa
  célula/gutter em pixels): aparelho pequeno corta silenciosamente o que estourar.

## Testes
- **Obrigatório:** unitário para toda lógica pura (regras, pontuação, progressão, persistência, gating de ads/compras).
- **Desejável:** widget test para fluxos críticos (iniciar, terminar, retomar).
- **Golden tests:** exigidos nas telas cobertas por `/game-pipeline:ui-fidelity-check`
  — o baseline é aprovado contra o Claude Design e passa a proteger contra
  regressão visual na suíte. Fora dessas telas, goldens são opcionais.
- Teste de render de Flame: não exigido (custo alto, valor baixo).

## Dependências
- Cada package novo exige justificativa de 1 linha no PR e checagem: mantido nos últimos 6 meses? funciona offline? tamanho razoável? tem alternativa nativa?
- Proibido: package que exige rede para o **core** do jogo funcionar.
- SDKs de ads/IAP/cloud entram **só na Fase 3**, quando o doc de
  `docs/setup-manual/` correspondente já deu os ids reais.
