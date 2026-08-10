# 9. CI/CD — Codemagic (build iOS sem Mac + build Android)

Se o dev é Windows/Linux, o iOS **exige macOS/Xcode** (ver [`08`](08-app-store-connect.md)).
O **Codemagic** é CI com Macs na nuvem: compila, assina e sobe pro
TestFlight/App Store a partir do repositório Git. O mesmo `codemagic.yaml` serve
para gerar o `.aab` Android — um CI só para as duas lojas.

## Pré-requisitos (nesta ordem)
1. **[`08`](08-app-store-connect.md) feito primeiro** — conta Apple ativa **e o
   app já criado no App Store Connect**. O Codemagic assina/sobe para um app que
   já existe; ele não cria a ficha.
2. Repositório no GitHub/GitLab/Bitbucket.

## Passos
1. **Conta.** [codemagic.io](https://codemagic.io) → entrar com o **GitHub** (a
   mesma conta do repo) e autorizar o repositório.
2. **Adicionar o app.** Escolha o repo, tipo **Flutter**. Não configure workflow
   pela UI — vamos versionar o `codemagic.yaml` (controle no Git).
3. **App Store Connect API Key** (é o que destrava assinatura + upload): App Store
   Connect → **Users and Access → Integrations → App Store Connect API** → chave
   com papel **App Manager** → baixe o **`.p8`** (só baixa uma vez), anote
   **Issuer ID** e **Key ID**. No Codemagic: **Teams → Integrations → Apple
   Developer Portal** → cole os três. Isso dá code-signing automático **sem
   mexer com certificados/provisioning à mão**.
4. **Android signing:** Codemagic → app → **Environment variables** (grupo
   `google_play`): suba o **keystore** (`.jks`) como arquivo, e as senhas/alias
   como variáveis **secretas**. Para publicar automático na faixa interna, gere
   uma **service account** JSON no Google Play Console (API Access) e suba também.
5. **`codemagic.yaml` (eu escrevo).** Base pronta em `ci/codemagic.yaml` deste
   template — ajusto ao projeto. Pontos que costumam quebrar:
   - **Versão do Flutter:** o projeto é pinado por **fvm** (`.fvmrc`). O
     `codemagic.yaml` declara a **mesma** versão em `environment: flutter:`.
     Divergiu → build passa no CI e quebra local (ou o inverso).
   - **iCloud/Game Center:** com entitlement de iCloud container (doc `05`), o
     export exige `iCloudContainerEnvironment: Production` no
     `ExportOptions.plist`, senão `xcodebuild -exportArchive` falha. Versionado
     junto (`--export-options-plist=ios/ExportOptions.plist`).
   - **Publish:** alvo é o **App Apple ID** numérico (doc `08`).
6. **Primeiro build → TestFlight.** Dispare o workflow iOS; ao terminar, instale
   pelo TestFlight num iPhone para smoke test (é onde se testa IAP sandbox e o app
   real em iOS, já que não há simulador fora do Mac).

## Divisão de trabalho
- **Você:** cria a conta, conecta o repo, gera a **API Key** e sobe keystore/
  service account como variáveis secretas.
- **Eu:** escrevo e mantenho o `codemagic.yaml` (workflows iOS/Android, signing,
  publish) e ajusto o projeto se o build acusar algo.

## O que me entregar depois
- Confirmação de conta Codemagic conectada ao repo.
- Confirmação de que a **App Store Connect API Key** está colada (não me mande o
  `.p8` — é segredo; só confirme).
- Confirmação de keystore + senhas nas variáveis (Android) e, se quiser publish
  automático, a service account do Play.

## Custo
Faixa grátis de minutos/mês; acima disso, pago por minuto (build iOS consome
mais). Suficiente para começar.
