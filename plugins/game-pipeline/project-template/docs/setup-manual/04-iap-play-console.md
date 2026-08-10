# 4. Compras no app (IAP → feature `in_app_purchase`)

## Pré-requisitos
- **[`00-play-console.md`](00-play-console.md) feito antes** — conta Play Console
  (US$ 25), app criado **e um build na faixa de teste interno**. É esse build que
  **ativa os produtos**; sem ele os IDs abaixo não ligam.
- iOS: **App Store Connect** com o app criado ([`08`](08-app-store-connect.md)),
  **Paid Apps Agreement Active** (sem ele o IAP não roda nem no sandbox).

## Produtos a criar — **use EXATAMENTE estes IDs** (o código faz o de-para por eles)

**Play Console → Monetizar → Produtos → Produtos no app** (one-time). Derive a
lista do `docs/prd.md` (seção Monetização). Modelo típico:

| Product ID | Tipo | O que é | Preço sugerido |
|---|---|---|---|
| `remove_ads` | Não consumível | Remover anúncios | `<preço>` |
| `coins_500` | Consumível | Pacote pequeno de moeda | `<preço>` |
| `coins_1200` | Consumível | Pacote médio | `<preço>` |
| `coins_3000` | Consumível | Pacote grande | `<preço>` |
| `premium_<tema>` | Não consumível | Conteúdo premium (1 por ramificação) | `<preço>` |

> Regras: **id em snake_case, imutável** (não dá pra renomear depois de ativo);
> **consumível** para moeda, **não consumível** para desbloqueio permanente; os
> preços do app são decorativos — o preço real vem da loja (localizado).
> Se mudar algum ID, me avise: o código referencia esses ids exatos.

## Passos
1. Crie os produtos com os IDs exatos e **ative** cada um.
2. **Licença de teste:** Play Console → Configurações → Testes de licença →
   adicione sua conta Google (compra sem cobrança).
3. **iOS:** crie os **mesmos IDs** em App Store Connect → Monetization → In-App
   Purchases + um **Sandbox Tester**.
4. Envie um build à **faixa de teste interno** (`fvm flutter build appbundle`).

## O que me entregar depois
- Confirmação de que os produtos existem e estão **ativos** (com os IDs finais).
- Conta de **teste de licença** (Android) e **Sandbox Tester** (iOS) configurados.

Com isso implemento `IPurchaseService` (comprar, restaurar, ouvir o stream de
compras, dedupe transacional), ligo os botões da loja e persisto o que foi
comprado no save local.
