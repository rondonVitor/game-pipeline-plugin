# 10. Screenshots e gráficos das lojas

**Quando:** Fase 4, depois que as telas do app estão prontas e fiéis ao Claude
Design. **Bloqueia:** envio da ficha nas duas lojas (screenshots são campo
obrigatório). Custo: zero.

## Como fazer
Rode **`/game-pipeline:store-screenshots`**: monto a página de export no Claude
Design com os quadros nas **dimensões exatas** de cada loja, usando as telas
reais do app e as legendas derivadas da ficha ([`07`](07-aso-ficha-loja.md)).
Você clica nos botões de download e cola os PNGs em `design/store/`.

## Specs (resumo — detalhe na skill)

| Ativo | Loja | Dimensão |
|---|---|---|
| Screenshot telefone | Play | 1080×1920 (9:16), mín. 2, ideal 4–8 |
| Feature graphic | Play | **1024×500** (obrigatório) |
| Ícone | Play | 512×512 PNG com alfa |
| Screenshot iPhone 6,9" | App Store | **1290×2796** (obrigatório) |
| Screenshot iPad 13" | App Store | **2064×2752** (só se o app rodar em iPad) |
| Ícone | App Store | 1024×1024 **sem alfa** |

> **iPhone-only:** se marcar `TARGETED_DEVICE_FAMILY = 1` no target Runner, o
> iPad deixa de ser exigido — decida antes de produzir 2 famílias de arte.

## Regras que reprovam
"#1", "Melhor", "Top", "Baixe agora", superlativos e claims de ranking na arte;
telas que não existem no app; texto ilegível em miniatura. Só telas reais.

## O que me entregar depois
- Confirmação dos PNGs em `design/store/play/` e `design/store/appstore/`.
- Se decidiu iPhone-only (muda o que a App Store exige).
