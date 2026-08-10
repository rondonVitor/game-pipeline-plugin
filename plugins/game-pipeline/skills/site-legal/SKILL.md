---
name: site-legal
description: Cria o site oficial do jogo (landing + Política de Privacidade + Termos de Uso) como repo irmão em Astro, materializando a marca do Claude Design. Use na Fase 4 (lançamento) — ou antes, assim que precisar da URL de privacidade para a ficha das lojas. Invocável como /game-pipeline:site-legal.
---

# /game-pipeline:site-legal

Gera o site que **destrava a publicação nas lojas**. Sem ele o lançamento trava:

| Exigência | Onde | O que precisa |
|---|---|---|
| **URL da política de privacidade** | Play Console + App Store Connect | página pública, estável |
| **Support URL** | App Store Connect (obrigatório) | página ou e-mail público |
| **Site do desenvolvedor** | Play Console (ficha) | domínio próprio |
| **`app-ads.txt`** | raiz do domínio | linha do AdMob (doc `03`) |
| Marketing URL | App Store (opcional) | landing |

O site vive em **repositório irmão** (`../<slug>-site`), separado do app: deploy
próprio, ciclo próprio, e o repo do jogo não carrega Node.

## Pré-condições
- `docs/prd.md` existe (pitch, diferenciais, público → viram o texto da landing).
- **Domínio decidido** (comprar é o doc [`02-dominio-hospedagem.md`]; dá pra
  gerar o site antes e apontar o domínio depois).
- MCP `claude_design` conectado + `design/claude-design.json` — a marca do site
  **materializa os tokens do app**, não inventa paleta.
- Node >= 18.17.1 na máquina (`node -v`).

## Passos

1. **Ler a fonte da marca.** `mcp__claude_design__read_file` dos `tokens/*.css`
   (colors, typography, radius, shadow) e da página de logo. Extraia os valores
   EXATOS: cores, fontes (famílias + link do Google Fonts), raios, sombra.
   Se `design/tokens.json` já existe no app, use-o como atalho — mas confira
   contra a fonte.

2. **Copiar o scaffold** para o repo irmão:
   ```bash
   TARGET="$(dirname "$PWD")/<slug>-site"
   [ -e "$TARGET" ] && echo "ERRO: já existe" || cp -r "${CLAUDE_PLUGIN_ROOT}/project-template-site" "$TARGET"
   ```

3. **Substituir os placeholders `{{...}}`** em todos os arquivos:

   | Placeholder | Vem de |
   |---|---|
   | `{{NOME_DO_APP}}` `{{SLUG}}` `{{TAGLINE}}` `{{DESCRICAO_CURTA}}` | `docs/prd.md` (e a ficha do doc `07`, se já escrita) |
   | `{{DESENVOLVEDOR}}` `{{EMAIL_SUPORTE}}` | dados do publisher (pergunte se não souber) |
   | `{{DOMINIO}}` | doc `02` (sem `https://`, sem barra) |
   | `{{COR_*}}` `{{FONTE_*}}` `{{RAIO_*}}` `{{SOMBRA_CARD}}` `{{LINK_GOOGLE_FONTS}}` | tokens do Claude Design (passo 1) |
   | `{{EYEBROW}}` `{{TITULO_HERO}}` `{{SUBTITULO_HERO}}` `{{DESTAQUE_N_*}}` | PRD — 3 diferenciais reais do jogo |
   | `{{LISTA_DADOS_LOCAIS}}` | o que o save guarda de fato (leia o `SaveState`) |
   | `{{DATA_ATUALIZACAO}}` | data de hoje, por extenso |
   | `{{APPLICATION_ID_ANDROID}}` `{{APP_APPLE_ID}}` `{{INICIAL}}` | docs `00`/`08`; deixe o comentário se ainda não existirem |

4. **Ajustar os textos legais ao app REAL.** Os templates cobrem ads + IAP +
   cloud save + notificações. **Remova o que o app não tem** e adicione o que ele
   tem a mais. O texto precisa **bater** com:
   - o formulário **Data Safety** do Play e o **App Privacy** da Apple;
   - o que os SDKs realmente coletam (AdMob → Advertising ID/IDFA);
   - o prompt **ATT** do iOS.
   > Divergência aqui é motivo de reprovação na revisão — e é a rejeição mais
   > chata de descobrir tarde. Declare o que existe, nem mais nem menos.

5. **Build local + smoke:**
   ```bash
   cd "$TARGET" && npm install && npm run build && npm run preview
   ```
   Confirme: `/`, `/privacidade`, `/termos` renderizam; links do rodapé; nenhum
   `{{PLACEHOLDER}}` sobrou (`grep -r "{{" src public tools`).

6. **Git + remoto** (confirme nome e visibilidade com o usuário):
   ```bash
   git -C "$TARGET" init -b main
   git -C "$TARGET" add -A
   git -C "$TARGET" commit -m "feat: site oficial (landing + privacidade + termos)"
   gh repo create <slug>-site --public --source="$TARGET" --push
   ```
   Público facilita o deploy e não expõe nada sensível.

7. **Handoff para o deploy.** Aponte o usuário para
   `docs/setup-manual/02-dominio-hospedagem.md` (Cloudflare Pages + domínio) e
   registre no `docs/roadmap.md` do app: site gerado, falta publicar.

## Regras
- **Não invente marca.** Cor/fonte/raio saem dos tokens do Claude Design.
- **Não prometa o que o app não faz** na landing nem no legal (as lojas leem).
- Nada de `aggregateRating` no JSON-LD sem avaliação real — schema enganoso
  penaliza o SEO.
- O site é repo **irmão**; nunca dentro do repo do app (o quality-gate do Flutter
  não deve ver `node_modules`).
- Revisão jurídica é do usuário: o template é uma base sólida em LGPD, não
  parecer de advogado. Diga isso ao entregar.
