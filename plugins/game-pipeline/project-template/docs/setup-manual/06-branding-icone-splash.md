# 6. Marca — ícone do app + splash (exportar do Claude Design)

Independente de conta paga — pode fazer a qualquer momento. Esforço: baixo.

A logo normalmente **não é um arquivo** no Claude Design: é desenhada em CSS/HTML
(gradientes, tipografia real). Por isso não dá pra "baixar via MCP" — a página de
logo do projeto **exporta PNG** por botões. Você exporta; eu configuro o resto.

## Passos (você) — exportar os PNGs
1. Abra a página da logo no editor do Claude Design (link em
   `design/claude-design.json` + `?file=Logo.html`, ou a página que o DS gerou).
2. Vá até a seção de exportação e salve (se a fonte sair errada no 1º clique,
   **clique de novo** — o navegador já terá carregado a webfont):
   - **Ícone 1024×1024** (fundo sólido, **sem transparência**) → `app-icon-1024.png`
     — **obrigatório** (App Store + fonte do launcher).
   - **Ícone 512×512 transparente** → `app-icon-512.png` — **obrigatório**
     (foreground do ícone adaptativo Android; ficha do Play pede 512 c/ alfa).
   - **Feature graphic 1024×500** → `feature-graphic-1024x500.png` — **obrigatório
     na ficha do Play** (usa no lançamento, doc [`07`](07-aso-ficha-loja.md)).
3. Cole os PNGs em **`assets/branding/`** no projeto e me avise.

## O que eu faço depois (feature `branding`, via `/build-feature`)
- **Ícone do app** — `flutter_launcher_icons` a partir do 1024 (Android
  adaptativo: cor de fundo do DS + foreground do 512), todas as densidades.
- **Splash nativa** — `flutter_native_splash` fiel à variação de splash do DS,
  some quando o Flutter sobe.
- **Logo in-app** — recrio o selo como **widget Flutter vetorial** (fiel ao CSS,
  escala perfeita) para telas e splash animada. Não depende de export.
- Registro `assets/branding/` no `pubspec.yaml` e valido fidelidade via
  `render_preview` contra a página de logo.

## O que me entregar depois
- Confirmação de que `app-icon-1024.png` e `app-icon-512.png` estão em
  `assets/branding/` (e o feature graphic, se já exportou).
- Qual variação de splash prefere (fundo de marca × fundo claro), se houver mais
  de uma no DS.
