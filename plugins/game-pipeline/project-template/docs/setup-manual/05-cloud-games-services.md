# 5. Cloud save (Play Games Services / Game Center → feature `games_services`)

Implemento `ICloudSaveService` em `domain/services/` sincronizando o save
(progresso, moedas, coleções) com a nuvem — **sem servidor próprio**: Play Games
*Saved Games* no Android, Game Center + iCloud no iOS.

> **Pré-requisito:** [`00-play-console.md`](00-play-console.md) pronto. O SHA-1
> pedido abaixo é o da chave de upload do `00`.

## Android — Play Games Services

> ### ⚠️ São DOIS SHA-1, não um
> Com **Play App Signing** (padrão), o `.aab` assinado com a **chave de upload** é
> *re-assinado pelo Google* com a **chave de distribuição**. O OAuth do PGS
> autentica contra a assinatura do binário **instalado** — a de **distribuição**.
>
> | Chave | Onde pegar | Cobre |
> |---|---|---|
> | Upload | `keytool -list -v -keystore <seu>.jks` | APK/AAB que você assina e instala na mão |
> | Distribuição | Console → **Testar e lançar → Assinatura de apps** (só após o 1º upload) | Qualquer instalação vinda do Play |
>
> Cadastre **os dois**. Só o de upload = login funciona no seu device e falha para
> todo testador que instalar pela faixa interna.
> **Ordem:** o SHA-1 de distribuição **não existe antes do primeiro `.aab` numa
> faixa** — suba o build primeiro.

### Antes do primeiro upload (pode fazer já)
1. **Play Console → Crescer usuários → Play Games Services → Configuração.**
   Escolha "**Não, meu jogo não usa as APIs do Google**" (se não usa Firebase) e
   dê nome ao jogo. Isso cria o projeto Google Cloud associado.
2. **Ative "Jogos salvos" (Saved Games):** Editar propriedades → alternar →
   Salvar. **Leva até 24 h para propagar.** Para testar antes: device →
   Configurações → Apps → Google Play Services → Gerenciar espaço → Limpar dados.
3. **Testadores:** aba Testadores → adicione seu e-mail (libera em ~2 h).
4. **Anote o App ID** — número de 12+ dígitos no topo da Configuração.

### Depois do primeiro `.aab` na faixa interna
5. Pegue o **SHA-1 de distribuição** em **Testar e lançar → Assinatura de apps**
   (a página "Integridade do app" *não* mostra as impressões — entre na sub-página).
6. **Credenciais:** Configuração do PGS → Adicionar credencial → **Android** →
   package do app → Client ID OAuth com o **SHA-1 de distribuição**. Repita para o
   **SHA-1 de upload** (segunda credencial) p/ seus builds locais.
7. **Publique a configuração do PGS** (botão *Publicar jogo*) — é separado de
   publicar o app. App publicado com PGS não publicado = contas não-testadoras
   falham no login.

### No repo (feature `games_services`)
8. `AndroidManifest.xml` precisa do App ID:
   ```xml
   <meta-data android:name="com.google.android.gms.games.APP_ID"
              android:value="@string/games_app_id"/>
   ```
   Com PGS **v2** o SDK **crasha no launch** se faltar/estiver malformado. Guarde
   o valor em `res/values/strings.xml` — evita o Gradle tratar o número como int.

## iOS — Game Center + iCloud

> **Ordem obrigatória** (Apple, desde 16/08/2023): capability no App ID →
> entitlement no binário → build no TestFlight → **só então** marcar Game Center
> na versão do App Store Connect. Fora dessa ordem a submissão falha com
> `STATE_ERROR.BUILD_INDICATES_GAME_CENTER_DISABLED`.

1. **Apple Developer → Identifiers →** App ID do bundle:
   - marcar **Game Center**;
   - marcar **iCloud** → Configure → container `iCloud.<bundle-id>` (**iCloud
     Documents** — `GKSavedGame` grava em ubiquity container, não em Key-Value);
   - Save → provisioning antigos ficam inválidos → **regenerar** (ou deixar o CI
     regerar via App Store Connect API Key).
2. **Repo (eu faço, não precisa de Mac):** `ios/Runner/Runner.entitlements` com
   `com.apple.developer.game-center`, `icloud-services: [CloudDocuments]`,
   `icloud-container-identifiers`, `ubiquity-container-identifiers`; e
   `CODE_SIGN_ENTITLEMENTS` + `DEVELOPMENT_TEAM` nas 3 configs do target `Runner`.
3. **Build no TestFlight** com esse entitlement (via [`09`](09-codemagic-ci.md)).
4. **App Store Connect → app → a _versão_ iOS** → seção **Game Center** → marcar.
   Não existe aba "Game Center" no nível do app — é **por versão**, e só aparece
   com versão em preparação. Saved Games não tem nada a configurar aqui.
5. **Sandbox Tester** p/ validar login. No device: Game Center logado **e iCloud
   Drive ligado** — sem iCloud o save falha com `GKErrorDomain Code=27`.

## Decisões de política (decida antes de eu implementar)
- **Estratégia de merge** local × nuvem: recomendo **"maior progresso vence"**
  (empate → local). Nunca perde avanço; efeito colateral: device antigo com mais
  progresso pode sobrepor o novo.
- **Opt-in:** cloud save ligado pelo jogador em Config. O app segue 100% funcional
  sem login — coerente com a promessa "offline" da ficha. Sem prompt de login no
  primeiro launch.

## O que me entregar depois
- **App ID** do Play Games Services (12+ dígitos).
- Confirmação de que **os dois** SHA-1 estão cadastrados e de que a config do PGS
  foi **publicada**; "Jogos salvos" ativado; sua conta na lista de testadores.
- iOS: container iCloud criado, capabilities ligadas, Sandbox Tester.
- Sua decisão sobre **merge** e **opt-in**.
