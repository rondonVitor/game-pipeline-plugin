// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// Site 100% estático: o Astro pré-renderiza tudo em build time e o Cloudflare
// Pages serve `dist/`. Nenhum adapter é necessário para SSG.
// build.format 'file' => emite `privacidade.html`, servido como /privacidade.
export default defineConfig({
  site: 'https://{{DOMINIO}}',
  output: 'static',
  trailingSlash: 'never',
  build: {
    format: 'file',
  },
  integrations: [sitemap()],
});
