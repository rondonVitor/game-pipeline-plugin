# Configuração manual — o que só você pode fazer

Estes passos exigem **contas externas, chaves, domínio e verificação em device**
que o código não resolve sozinho. Cada serviço de plataforma (Fase 3) e cada
etapa de lançamento (Fase 4) só é implementado **depois** que o pré-requisito
manual correspondente estiver pronto — assim os ids/chaves batem de primeira.

## Ordem sugerida

Primeiro o que é **grátis e destrava código** (AdMob em test ads, site/legal),
depois o **domínio**, depois a **raiz paga** de cada loja.

| # | Documento | Bloqueia | Pré-req | Custo |
|---|---|---|---|---|
| 1 | [`03-ads-admob.md`](03-ads-admob.md) | feature de ads (**test ads** já; ads reais → `00`) | conta AdMob | grátis |
| 2 | [`01-site-legal.md`](01-site-legal.md) | **publicar em qualquer loja** (URL de privacidade + Support URL) | — | grátis |
| 3 | [`02-dominio-hospedagem.md`](02-dominio-hospedagem.md) | site no ar, `app-ads.txt` | `01` | domínio ~R$ 40–70/ano |
| 4 | [`00-play-console.md`](00-play-console.md) | **raiz Android** — IAP, Games Services, ads reais | US$ 25 (único) | US$ 25 |
| 5 | [`04-iap-play-console.md`](04-iap-play-console.md) | feature de compras | `00` + build interno | grátis |
| 6 | [`05-cloud-games-services.md`](05-cloud-games-services.md) | feature de cloud save | `00` + SHA-1 | grátis |
| ↯ | [`06-branding-icone-splash.md`](06-branding-icone-splash.md) | ícone + splash | — (independente) | grátis |
| 7 | [`08-app-store-connect.md`](08-app-store-connect.md) | **raiz iOS** — conta + app + IAP/Game Center | US$ 99/ano | US$ 99/ano |
| 8 | [`09-codemagic-ci.md`](09-codemagic-ci.md) | build iOS **sem Mac** + AAB no CI | `08` (app criado) | faixa grátis |
| 9 | [`07-aso-ficha-loja.md`](07-aso-ficha-loja.md) | **Fase 4** — ficha e ASO das duas lojas | `00`/`08` (+ `01` p/ URLs) | grátis |
| 10 | [`10-screenshots-lojas.md`](10-screenshots-lojas.md) | envio da ficha (screenshots são obrigatórias) | telas prontas + `07` | grátis |

> **`06` é independente:** não precisa de conta paga. Você exporta 2 PNGs da
> página de logo do Claude Design e eu configuro ícone + splash + logo in-app.

> **Nota AdMob (nº 1):** o código de ads roda **sem** Play Console (test ad unit
> ids). Só **ads reais com receita** exigem app publicado e vinculado — isto é, o
> `00`. Por isso o AdMob pode começar antes da conta paga.

> **Nota site (nº 2–3):** faça cedo. A **URL de política de privacidade** é campo
> obrigatório nas duas lojas, e descobrir isso no dia do envio custa dias.

## Como funciona a divisão de trabalho
- **Você (manual):** cria contas, produtos, unidades de anúncio, compra o
  domínio, obtém ids/chaves, e roda o app num device real quando o passo pedir.
- **Eu (código):** implemento cada feature atrás de uma interface em
  `domain/services/`, consumindo os ids/chaves que você me passar; gero o site,
  o `codemagic.yaml` e os assets de loja. Nada de placeholder — só implemento
  quando o pré-requisito existe.

No fim de cada doc há **"O que me entregar depois"** — cole os ids/valores no
chat e eu implemento a parte correspondente.

## Custos totais (mínimo para lançar nas duas lojas)
- Google Play: **US$ 25** (único) · Apple: **US$ 99/ano** · domínio: **~R$ 50/ano**.
- AdMob, IAP, Games Services, Cloudflare Pages e Codemagic (faixa grátis): **sem
  custo fixo**.
