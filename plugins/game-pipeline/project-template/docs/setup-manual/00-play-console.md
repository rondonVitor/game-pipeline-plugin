# 0. Google Play Console — a raiz de tudo (Android)

**Por que primeiro:** três serviços de plataforma dependem, direta ou
indiretamente, de uma conta Play Console com o app criado:

- `in_app_purchase` — **exige**: produtos só existem dentro do app no Console, e
  só ativam depois de um build enviado a uma faixa.
- `games_services` (cloud save) — **exige**: Play Games Services vive dentro do
  Console (+ SHA-1 da chave de assinatura).
- `google_mobile_ads` — o **código** roda com *test ads* sem isto (ver
  [`03-ads-admob.md`](03-ads-admob.md)); mas **ads reais** só servem com o app
  **publicado numa loja suportada e vinculado** no AdMob.

Faça este doc uma vez; os outros apontam de volta pra cá.

## Custo
**US$ 25, pagamento único**, para sempre. (iOS é conta separada, US$ 99/ano —
ver [`08-app-store-connect.md`](08-app-store-connect.md).)

## Passos

1. **Criar a conta.** [play.google.com/console](https://play.google.com/console)
   com a conta Google que será dona da publicação. Tipo **Pessoal** ou
   **Organização** (Pessoal basta para começar). Pague os US$ 25 e conclua a
   **verificação de identidade** (documento + endereço). A conta fica limitada
   até verificar — **comece cedo, pode levar dias**.

2. **Criar o app.** Console → **Criar app**. Tipo **Jogo**, gratuito. Anote o
   **package name / application id** — precisa bater com
   `android/app/build.gradle` → `applicationId`. Se ainda for `com.example.*`,
   **troque agora** (ex.: `br.com.<seudominio>.<jogo>`): o application id **não
   pode mudar depois** do primeiro upload. Me diga o id final que eu troco no
   projeto.

3. **App Signing (chave de assinatura).** Deixe o **Play App Signing** ativado
   (padrão): você assina o `.aab` com a **chave de upload** e o Google re-assina
   com a **chave de distribuição**. Guarde o keystore de upload em lugar seguro —
   perdê-lo trava updates.
   ```bash
   keytool -genkey -v -keystore upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
   Guarde a senha. Eu plugo o keystore no Gradle via `key.properties` no build de
   release. Os **SHA-1** (de upload **e** de distribuição) são o que o Games
   Services pede — ver [`05`](05-cloud-games-services.md), seção "São DOIS SHA-1".

4. **Ficha da Play Store (mínimo p/ destravar as faixas).** Preencha o que o
   Console marcar como obrigatório: **classificação de conteúdo** (IARC),
   **público-alvo**, **política de privacidade (URL)** ←
   [`01-site-legal.md`](01-site-legal.md), **segurança de dados**, ícone /
   screenshots / descrição ([`07`](07-aso-ficha-loja.md) e
   [`10`](10-screenshots-lojas.md)). Não precisa estar *bonito* agora — precisa
   estar *completo* para o build subir.

5. **Enviar um build à faixa de teste interno.** Console → **Testes → Teste
   interno** → criar versão → subir o `.aab`:
   ```bash
   fvm flutter build appbundle --release
   # saída: build/app/outputs/bundle/release/app-release.aab
   ```
   Adicione seu e-mail à lista de testadores e aceite o convite.
   **É este passo que ativa os produtos IAP e permite testar compras.**

6. **Site do desenvolvedor.** Em **Presença na loja → Configurações da ficha**,
   informe a **URL do site** (o domínio de [`02`](02-dominio-hospedagem.md)).
   Serve para o `app-ads.txt` do AdMob validar a posse do app.

## O que me entregar depois
- **application id** final (se trocou do `com.example.*`).
- Confirmação de que o **app existe no Console** e de que já subiu **um build à
  faixa de teste interno** (destrava IAP).
- O **SHA-1** da chave de upload (`keytool -list -v -keystore ...`) e, depois do
  1º upload, o de **distribuição** (Console → Testar e lançar → Assinatura de apps).

Com o app criado + build interno no ar, [`04`](04-iap-play-console.md) e
[`05`](05-cloud-games-services.md) ficam desbloqueados, e o AdMob pode ser
vinculado para ads reais.
