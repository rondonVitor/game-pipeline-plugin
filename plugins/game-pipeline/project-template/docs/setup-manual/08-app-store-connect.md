# 8. Apple App Store — a raiz iOS

Equivalente iOS do [`00-play-console.md`](00-play-console.md): conta Apple,
assinatura de código, TestFlight, e como o iOS liga cada serviço (IAP, Game
Center, ads/ATT).

## ⚠️ Pré-requisito que não dá pra contornar: build iOS precisa de macOS
Compilar/assinar/enviar app iOS **exige Xcode, que só roda em macOS**. Em dev
Windows/Linux, escolha:

| Via | Como | Serve p/ |
|---|---|---|
| **CI na nuvem (recomendado)** | Codemagic / EAS mantêm Macs remotos: conecta o repo, compila, assina e sobe pro TestFlight. Ver [`09`](09-codemagic-ci.md). | build + distribuição |
| **Mac próprio/alugado** | Mac com Xcode (ou MacinCloud). | build + debug + simulador |

Mesmo via CI, **debug no simulador iOS exige Mac real** — para smoke test, use
TestFlight num iPhone. **Conta Apple Developer é obrigatória em qualquer via.**

## Custo
**Apple Developer Program: US$ 99/ano** (não renovou → app sai do ar). CI tem
faixa grátis de minutos.

## Passos
1. **Conta.** [developer.apple.com/programs](https://developer.apple.com/programs/)
   → Enroll. Pessoa física (mais simples) ou organização (exige **D-U-N-S**,
   demora). Depois, **App Store Connect → Business → Agreements**: ative o
   **Paid Apps Agreement** (banco + fiscais) — **sem ele os IAP não funcionam nem
   no sandbox**.
2. **Bundle ID.** Em Certificates, IDs & Profiles → Identifiers, crie o App ID.
   Marque as capabilities: **In-App Purchase**, **Game Center**, **iCloud** (se
   for ter cloud save).
   > **Nota — ids diferentes por loja (ok):** a Apple **não aceita `_`**. Se o
   > Android usa `br.com.x.meu_jogo`, o iOS usa `br.com.x.meuJogo`. Lojas são
   > independentes; não afeta o código Flutter. Só mantenha consistência dentro
   > de cada loja.
3. **Criar o app no App Store Connect.** My Apps → **+** → iOS, idioma primário
   pt-BR, bundle acima, SKU livre (interno). Anote o **App Apple ID** (numérico) —
   vai no `codemagic.yaml` e na URL da loja (`apps.apple.com/app/id<numero>`).
4. **Assinatura de código.** Via CI: gere uma **App Store Connect API Key**
   (Users and Access → Integrations → chave `.p8` + Issuer ID + Key ID) e cole no
   CI — ele gerencia certificados/provisioning. Via Mac: Xcode → "Automatically
   manage signing".
5. **TestFlight** (equivalente à faixa interna): suba um build → Internal Testing
   → adicione seu Apple ID. **É este build que ativa os produtos IAP no sandbox.**

## Dados de referência — preencha
| Campo | Valor |
|---|---|
| Bundle ID (iOS) | `<preencher>` |
| SKU | `<preencher>` |
| App Apple ID | `<preencher>` |
| Team ID | `<preencher>` |

## IAP no iOS — usa os MESMOS product ids do [`04`](04-iap-play-console.md)
App Store Connect → app → **Monetization → In-App Purchases**: crie os produtos
com os **mesmos IDs**. Tipos: **Non-Consumable** (remoção de ads, desbloqueios),
**Consumable** (moedas). Defina preço (tier) e tax category. Crie um **Sandbox
Tester** (Users and Access → Sandbox); o Paid Apps Agreement precisa estar Active.

## Game Center + iCloud → detalhe em [`05`](05-cloud-games-services.md)
Ordem obrigatória: capability no App ID → entitlement no binário → build no
TestFlight → **só então** marcar Game Center **na versão** do App Store Connect.
Fora dessa ordem: `STATE_ERROR.BUILD_INDICATES_GAME_CENTER_DISABLED`.

## AdMob iOS + ATT → detalhe em [`03`](03-ads-admob.md)
`GADApplicationIdentifier`, `SKAdNetworkItems` e `NSUserTrackingUsageDescription`
no `Info.plist`. O prompt ATT é chamado em runtime pela feature de ads.

## Ficha da App Store → [`07`](07-aso-ficha-loja.md) · Screenshots → [`10`](10-screenshots-lojas.md)

## O que me entregar depois
- Conta Apple ativa + **Paid Apps Agreement Active**.
- App criado (bundle, SKU, **App Apple ID**, **Team ID**) e capabilities ligadas.
- Um build no **TestFlight** + **Sandbox Tester** criado.
- Qual via de build (CI vs Mac) — se CI, eu escrevo o `codemagic.yaml` (doc `09`).
