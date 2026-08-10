# 7. Ficha das lojas (Play + App Store) + ASO

Este doc é **método**, não texto pronto: eu gero o texto a partir do
`docs/prd.md` (pitch, diferenciais, público) e você cola. Screenshots têm doc
próprio: [`10-screenshots-lojas.md`](10-screenshots-lojas.md).

---

## Parte A — Como cada loja indexa (o "porquê")

| Aspecto | Google Play | Apple App Store |
|---|---|---|
| Campo de keywords dedicado | **Não** (vivem nos textos visíveis) | **Sim** — 100 chars, oculto |
| Subtítulo | não existe (tem descrição curta 80) | **Sim**, 30 chars, indexado |
| Descrição indexa busca? | **Sim** (densidade importa) | **Não** (só conversão) |
| Título | 30 chars | 30 chars |
| Texto promocional editável sem update | — | **170 chars** |
| HTML na descrição | `<b>`, `<i>` | **não** (texto puro) |
| Privacidade | Data Safety (formulário) | App Privacy (nutrition labels) |
| Ads | "Contém anúncios = Sim" | Device ID/tracking + **ATT** |
| Revisão | automatizada (rápida) | **humana** (~24–48 h) |
| A/B nativo | Store Listing Experiments | Product Page Optimization |

**Apple — total indexado = 160 chars** (nome 30 + subtítulo 30 + keywords 100). A
Apple **combina** tokens dos três campos: cada palavra aparece **UMA vez**;
repetir desperdiça espaço. **Google** — a keyword-mãe deve aparecer no título, na
descrição curta e ~3–5× na completa, sem stuffing.

## Parte B — Campos e limites (checklist de preenchimento)

**Google Play**
- Título (30) · Descrição curta (80) · Descrição completa (4.000, aceita `<b>`).
- Categoria: **Jogos → <subcategoria>**. Classificação IARC, público-alvo.
- Gráficos: ícone 512×512 (32-bit, com alfa), **feature graphic 1024×500**
  (obrigatório), screenshots (doc `10`), vídeo YouTube (opcional).

**App Store**
- Nome (30) · Subtítulo (30) · **Keywords** (100, separado por vírgula, **sem
  espaço**, singular basta — a Apple faz stemming; use a grafia **sem acento**
  quando é como o usuário digita) · Texto promocional (170) · Descrição (4.000,
  texto puro).
- Ícone 1024×1024 **sem alfa e sem cantos arredondados**. Screenshots: doc `10`.
- **App Privacy** (nutrition labels), Age Rating, Support URL + Marketing URL
  (o site do doc [`02`](02-dominio-hospedagem.md)), política de privacidade (URL).

## Parte C — Regras de conteúdo que reprovam
- **Proibido na arte e nos textos:** "#1", "Melhor", "Top", "Baixe agora",
  superlativos e claims de ranking → reprovação na revisão.
- Nada de menção a outras marcas/lojas, nem preço fixo no texto (varia por país).
- Screenshots só com **telas reais do app**.

---

## Parte D — Passo a passo no Play Console (ordem de preenchimento)
1. **Presença na loja → Ficha principal:** título, descrição curta, completa,
   ícone, feature graphic, screenshots.
2. **Conteúdo do app (destravam a publicação):** classificação IARC ·
   público-alvo e conteúdo · **segurança de dados** (declare o que o SDK de ads
   coleta: ID do dispositivo, dados de uso — precisa **bater** com a política de
   privacidade) · anúncios ("contém anúncios = Sim") · política de privacidade
   (URL) · app de governo/finanças = não.
3. **Testes → faixa interna → aberta → produção.** O `.aab` sai de
   `fvm flutter build appbundle --release` (doc [`00`](00-play-console.md)).
4. **Antes de produção:** rode 1–2 **Store Listing Experiments** (A/B grátis,
   ≥7 dias, 1 elemento por vez, métrica "instaladores retidos"). O título **não**
   é testável.

## Parte E — Passo a passo no App Store Connect
1. **App Information:** Name, Subtitle, Category (primária Jogos → <sub>).
2. **Versão → App Store:** Promotional Text, Description (texto puro), **Keywords**.
3. **Screenshots** (doc `10`) — iPhone 6,9" obrigatório; **iPad 13" obrigatório se
   o app rodar em iPad** (marque o target como iPhone-only se não quiser).
4. **Support URL** (obrigatório) + Marketing URL — site do doc `02`.
5. **App Privacy:** nutrition labels. App offline puro: nada coletado. **Com
   AdMob:** "Identifiers → Device ID" + "Usage Data" para "Third-Party
   Advertising", ligados a tracking (IDFA/ATT) — tem que bater com o prompt ATT e
   com a política.
6. **Age Rating**, **Build** (via TestFlight/CI, doc [`09`](09-codemagic-ci.md)),
   **Submeter para revisão** (~24–48 h).
   > Rejeição comum: **ATT** — com ads, `NSUserTrackingUsageDescription` tem que
   > existir e o prompt ser chamado antes de rastrear (Guideline 5.1.2).

## Parte F — Otimização contínua
- **Google:** Store Listing Experiments (ícone, feature graphic, até 8
  screenshots, descrições) + Custom Store Listings por origem de campanha.
- **Apple:** Product Page Optimization (ícone/screenshots/preview) + Custom
  Product Pages. **Keywords mudam sem update do app**; nome/subtítulo exigem update.
- Reotimize keywords a cada 4–6 semanas com base no que rankeou.

## O que me entregar depois
- Confirmação de ficha preenchida nas duas lojas (pt-BR) e **declarações sem
  pendências** (Data Safety / App Privacy / IARC / Age Rating).
- Variantes que quer testar no primeiro A/B.

### Fontes (ASO 2025/2026)
- App Radar — ASO Google Play: https://appradar.com/academy/google-play-optimization
- AppTweak — Play keyword research: https://www.apptweak.com/en/aso-blog/play-store-keyword-research
- Apple — Screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/
- AppLaunchFlow — App Store keyword field: https://www.applaunchflow.com/blog/app-store-keyword-field-guide-2026
- ASOMobile — Screenshots (guia de conversão): https://asomobile.net/en/blog/screenshots-for-app-store-and-google-play-in-2025-a-complete-guide/
- Google Play — Melhores práticas de ficha: https://support.google.com/googleplay/android-developer/answer/13393723
