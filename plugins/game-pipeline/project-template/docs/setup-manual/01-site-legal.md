# 1. Site oficial + Política de Privacidade + Termos de Uso

**Bloqueia:** publicar em **qualquer uma das lojas**. Custo: **zero** (fora o
domínio, doc [`02`](02-dominio-hospedagem.md)). Pode fazer cedo — não depende de
conta paga.

## Por que é obrigatório

| Exigência | Onde | Sem isso |
|---|---|---|
| **URL da política de privacidade** | Play Console (Conteúdo do app) e App Store Connect | não dá para enviar para revisão |
| **Support URL** | App Store Connect | campo obrigatório, trava o envio |
| **Site do desenvolvedor** | Play Console → ficha | necessário p/ validar `app-ads.txt` |
| **`app-ads.txt`** na raiz do domínio | AdMob | inventário não autorizado (spoofing) |
| Marketing URL | App Store (opcional) | — |

A política **precisa bater** com o formulário **Data Safety** (Play) e com o
**App Privacy** (Apple). Declarar menos do que os SDKs coletam = reprovação.

## Como fazer

Rode **`/game-pipeline:site-legal`**: crio o repo irmão `../<slug>-site` (Astro
estático) com landing + `/privacidade` + `/termos`, materializando as cores e
fontes do Claude Design, e ajusto os textos legais ao que o app **de fato** faz
(ads? IAP? cloud save? notificações?).

Depois, o deploy e o domínio: [`02-dominio-hospedagem.md`](02-dominio-hospedagem.md).

## O que preciso de você
- **Nome do publisher** (pessoa física ou empresa) — vai como controlador na
  política e como autor no site.
- **E-mail de suporte público** — vai na política, nos termos e no Support URL.
- **Domínio** (ou a decisão de comprar — doc `02`).
- Confirmação de quais recursos o app terá **no lançamento**: anúncios? compras?
  cloud save? notificações? (Define o que entra nos textos legais.)

## Checklist antes de considerar pronto
- [ ] `/`, `/privacidade` e `/termos` no ar, sem `{{PLACEHOLDER}}` sobrando.
- [ ] Rodapé com os dois links legais em todas as páginas.
- [ ] Texto legal bate com Data Safety / App Privacy / prompt ATT.
- [ ] `app-ads.txt` publicado (mesmo vazio de linha, o arquivo existe).
- [ ] URLs anotadas para colar nas fichas: `https://<dominio>/privacidade`,
      `https://<dominio>/termos`, `https://<dominio>`.

> **Revisão jurídica é sua.** O template é uma base sólida (LGPD, itens
> virtuais, ads, IAP), não substitui advogado se o seu caso tiver algo fora do
> padrão.
