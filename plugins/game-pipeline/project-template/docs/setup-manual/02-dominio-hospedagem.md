# 2. Domínio + hospedagem (Cloudflare Pages) — passo a passo

Depende de [`01-site-legal.md`](01-site-legal.md) (o site existir). Custo: só o
**domínio** (~R$ 40–70/ano em `.com`; `.com.br` no Registro.br sai ~R$ 40/ano).
Hospedagem no **Cloudflare Pages: grátis** (bandwidth ilimitado no plano free).

## Parte A — Comprar o domínio

1. **Escolha o nome.** Regras práticas: igual ou muito próximo do nome do app
   (ajuda ASO e confiança), curto, sem hífen, fácil de ditar. Cheque
   disponibilidade em [registro.br](https://registro.br) (`.com.br`) e num
   registrador `.com`.
2. **Qual extensão:**
   - **`.com`** — global, aceito em qualquer loja, sem burocracia. Recomendado.
   - **`.com.br`** — exige **CPF/CNPJ brasileiro** e é gerido pelo Registro.br;
     mais barato e passa "é BR". Renovação anual manual (não esqueça — domínio
     expirado derruba a URL de privacidade **e a ficha da loja fica inválida**).
   - `.app`/`.games` — exigem HTTPS (o Cloudflare já entrega) e costumam custar mais.
3. **Onde comprar:**
   - **Cloudflare Registrar** (se disponível para a TLD): vende **a preço de
     custo**, sem markup e sem upsell, e já fica no mesmo painel do deploy.
     Simplifica: DNS e site no mesmo lugar.
   - **Registro.br** para `.com.br` (é o único caminho oficial).
   - Namecheap/Porkbun/GoDaddy servem; evite planos "premium" e o upsell de
     e-mail/SSL — não precisa.
4. **Ative o WHOIS privacy** (proteção de dados do titular) — grátis na maioria.
5. **Anote a data de renovação** e ligue a **renovação automática**. Domínio
   caído = app rejeitado no próximo update (URL de privacidade quebrada).

## Parte B — Publicar no Cloudflare Pages

> Pré-requisito: o repo do site (`<slug>-site`) no GitHub — o
> `/game-pipeline:site-legal` já deixa assim.

1. **Conta** em [dash.cloudflare.com](https://dash.cloudflare.com) (grátis).
2. **Workers & Pages → Create → Pages → Connect to Git** → autorize o GitHub e
   selecione o repositório do site.
3. **Build settings** (o Cloudflare detecta Astro; confirme):
   - **Framework preset:** Astro
   - **Build command:** `npm run build`
   - **Build output directory:** `dist`
   - **Node version:** defina a env var `NODE_VERSION = 20` se o build reclamar.
4. **Save and Deploy.** Sai um domínio `*.pages.dev` funcionando em ~1 min. Cada
   push na `main` refaz o deploy; PRs ganham preview próprio.
5. **Domínio custom:** aba **Custom domains → Set up a domain** → digite o
   domínio.
   - **Se o domínio está no Cloudflare** (comprado lá ou já transferido/apontado):
     ele cria os registros sozinho. Adicione **`www`** também e deixe o
     redirecionamento para o apex (ou o inverso — escolha um canônico e mantenha).
   - **Se está em outro registrador** (Registro.br, Namecheap…): duas vias —
     (a) **apontar os nameservers** do domínio para os do Cloudflare (o painel
     mostra os dois `*.ns.cloudflare.com`) — recomendado, dá DNS completo; ou
     (b) criar um **CNAME** `www → <projeto>.pages.dev` e, no apex, o registro
     que o painel indicar. Propagação: minutos a algumas horas.
6. **HTTPS** é automático (certificado emitido pelo Cloudflare). Confirme que
   `https://<dominio>` e `https://www.<dominio>` respondem, e que o canônico do
   site (`astro.config.mjs → site`) usa **exatamente** a forma escolhida.
7. **Cache/segurança:** o `public/_headers` do scaffold já configura cache eterno
   para `/_astro/*` e headers de segurança. Se aparecer "hydration mismatch",
   desligue o **Auto Minify** do Cloudflare (o Astro já minifica).

## Parte C — Ligar o domínio ao resto do lançamento
- **Play Console → Presença na loja → Configurações da ficha:** URL do site.
- **Play Console → Conteúdo do app:** URL da política (`/privacidade`).
- **App Store Connect:** Support URL (`https://<dominio>`), Marketing URL e
  Privacy Policy URL (`/privacidade`).
- **AdMob:** publique a linha do `app-ads.txt` na raiz
  (`https://<dominio>/app-ads.txt`) — o crawler leva até 24 h.

## Verificação final
```bash
curl -sI https://<dominio> | head -1              # 200
curl -s  https://<dominio>/app-ads.txt | head -3  # linha do AdMob
curl -s  https://<dominio>/sitemap-index.xml | head -3
```
- [ ] `/privacidade` e `/termos` abrem em anônimo (sem login).
- [ ] Renovação automática do domínio ligada.
- [ ] URLs coladas nas duas lojas.

## O que me entregar depois
- O **domínio** final e a confirmação de que o site está no ar.
- Se quiser, o print das build settings — ajudo a depurar se o deploy falhar.
