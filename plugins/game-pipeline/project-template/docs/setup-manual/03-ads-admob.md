# 3. Anúncios (AdMob → feature `ads` / `google_mobile_ads`)

Quando você terminar os passos abaixo e me passar os ids, eu implemento a feature
`ads` atrás de `IAdService` em `domain/services/`:
- **Rewarded** — "assistir vídeo" para recompensa opcional (dica, dobrar moedas,
  continuar). Nunca obrigatório.
- **Interstitial** — entre partidas/fases, **nunca no meio da partida**, com
  cooldown e as primeiras sessões livres (regra do `docs/prd.md`).

## Precisa do Play Console? Depende do que você quer destravar

| Objetivo | App publicado? | O que basta |
|---|---|---|
| **Implementar a feature + você testar** | **Não** | Conta AdMob + unidades criadas. Em dev uso os **test ad unit ids** oficiais do Google — ads de teste aparecem em qualquer device, sem loja. |
| **Servir ads REAIS (com receita)** | **Sim** | App **publicado numa loja suportada** e **vinculado** no AdMob → "app readiness review" (2–3 dias). |

Por quê: app não publicado / não vinculado recebe **"limited ad serving"** até
passar o review — e **app privado/interno não pode ser vinculado**. Ou seja: dá
pra codar e testar agora; a monetização real só liga depois do
[`00-play-console.md`](00-play-console.md). O código nasce trocando test ids ↔
ids reais por flag de build, então nada muda no app quando a hora chegar.

> **Dual-store:** o AdMob **não** compartilha App ID nem ad units entre
> plataformas. Faça os passos **duas vezes** — uma para Android, outra para iOS.

## Passos (por plataforma)
1. **[AdMob](https://apps.admob.com)** → **Add app** → registre o app. Se ainda
   não está na loja, escolha **"Unpublished"** (volta depois para vincular).
   Anote o **App ID** (`ca-app-pub-XXXX~YYYY`).
2. Crie as **unidades de anúncio**:
   - **Rewarded** → `rewarded_principal` → anote o Ad unit ID.
   - **Interstitial** → `interstitial_partidas` → anote o Ad unit ID.
   > Uma rewarded serve para todos os usos; crie mais se quiser medir separado.
3. **Android** — `android/app/src/main/AndroidManifest.xml`: `meta-data`
   `com.google.android.gms.ads.APPLICATION_ID` dentro de `<application>` (eu faço).
4. **iOS** — `ios/Runner/Info.plist` (eu faço, você me passa os valores):
   - `GADApplicationIdentifier` = App ID **iOS**;
   - **`SKAdNetworkItems`** — lista oficial do Google (atribuição de instalação, iOS 14+);
   - **`NSUserTrackingUsageDescription`** — texto do prompt **ATT**. A Apple exige
     o prompt antes de rastrear (Guideline 5.1.2) — sem ele, rejeição.
5. **Device de teste:** registre o id do seu device no AdMob (evita cliques
   inválidos / ban).

## Só quando for ligar ads reais (depende do `00`)
6. **Publique** o app e volte ao AdMob para **vincular** o app à ficha da loja. O
   review de "app readiness" começa no vínculo; até aprovar, o serviço fica limitado.
7. **`app-ads.txt`** — informe a URL do site na ficha da loja (passo 6 do `00`) e
   publique o `app-ads.txt` **na raiz desse domínio** com a linha exata que o
   AdMob fornecer. Já existe um arquivo pronto no scaffold do site
   ([`01-site-legal.md`](01-site-legal.md)) — só colar a linha. O crawler leva até 24 h.

## Ids registrados — preencha (fonte da verdade p/ implementação)

| Plataforma | Item | Id |
|---|---|---|
| Android | App ID (`~`) | `<preencher>` |
| Android | Rewarded (`/`) | `<preencher>` |
| Android | Interstitial (`/`) | `<preencher>` |
| iOS | App ID (`~`) | `<preencher>` |
| iOS | Rewarded (`/`) | `<preencher>` |
| iOS | Interstitial (`/`) | `<preencher>` |

> ⚠️ **Teste manual só em build `debug`.** O código usa test ad unit ids quando
> `kDebugMode == true`. Em `--profile`/`--release` os ids são os **reais** —
> clicar num ad real em teste pode gerar clique inválido/ban no AdMob.

## O que me entregar depois
- Os 6 ids da tabela acima (ou os de uma plataforma, se for lançar escalonado).
- A lista `SKAdNetworkItems` e o texto do prompt ATT (iOS).
- Confirmação do device de teste registrado.
