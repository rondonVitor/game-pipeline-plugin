# {{SLUG}}-site

Site oficial do app **{{NOME_DO_APP}}** ({{DESENVOLVEDOR}}): landing +
**Política de Privacidade** + **Termos de Uso**. Repositório **separado** do app
Flutter, para deploy contínuo no **Cloudflare Pages**.

> Por que existe: as duas lojas **exigem uma URL pública de política de
> privacidade** para publicar, e a App Store exige **Support URL**. O AdMob exige
> `app-ads.txt` num domínio seu para escalar ads. Sem site, o lançamento trava.

## Stack
- **[Astro](https://astro.build) 5** estático (`output: 'static'`) — zero JS no
  cliente, HTML pré-renderizado (SEO e velocidade). Sem adapter: o Cloudflare
  Pages só serve o `dist/`.
- **`@astrojs/sitemap`** — gera `sitemap-index.xml` no build.
- Marca materializada dos tokens do Claude Design do app em
  `src/styles/global.css`.

## Rodar local
```bash
npm install
npm run dev       # http://localhost:4321
npm run build     # gera dist/
npm run preview
```
Requer **Node >= 18.17.1** (recomendado 20+).

## Deploy — Cloudflare Pages
Passo a passo (incluindo compra do domínio e DNS) em
`docs/setup-manual/02-dominio-hospedagem.md` no repo do app.

## Pendências típicas antes do lançamento
- `public/og-image.png` (1200×630) — preview de compartilhamento.
- `public/app-ads.txt` — colar a linha que o AdMob fornecer.
- `src/components/StoreButtons.astro` — trocar `#baixar` pelos links reais das
  lojas quando as fichas existirem.
- JSON-LD: adicionar `aggregateRating` só quando houver avaliações reais.
