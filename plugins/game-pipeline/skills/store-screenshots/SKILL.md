---
name: store-screenshots
description: Gera as screenshots e os gráficos das lojas (Play e App Store) a partir das telas já desenhadas no Claude Design — monta a página de export nas dimensões exatas de cada loja, com legendas, e valida contra as regras de conteúdo. Use na Fase 4 (lançamento), depois que as telas do app existem. Invocável como /game-pipeline:store-screenshots.
---

# /game-pipeline:store-screenshots

As screenshots são **a peça de conversão** da ficha (≈90% dos usuários não passam
da 3ª imagem; screenshots otimizadas elevam a conversão ~24%). Como o protótipo
navegável e o DS já existem no Claude Design, elas se montam a partir dele — não
se desenha nada do zero.

## Pré-condições
- Telas do app implementadas e fiéis ao Claude Design (`/ui-fidelity-check` passou).
- MCP `claude_design` conectado; `design/claude-design.json` com `project_id`.
- `docs/setup-manual/07-aso-ficha-loja.md` preenchido — as **legendas** saem da
  proposta de valor da ficha, não de improviso.
- Ícone/feature graphic: doc `06` (branding).

## Especificações (2025/2026)

| Ativo | Loja | Dimensão | Regras |
|---|---|---|---|
| Screenshot telefone | Play | **1080×1920** (9:16; lado 320–3840) | mín. 2, ideal 4–8; PNG/JPEG |
| Feature graphic | Play | **1024×500** | **obrigatório** |
| Ícone | Play | **512×512** PNG 32-bit **com alfa** | — |
| Screenshot iPhone | App Store | **1290×2796** (6,9") | **obrigatório**, até 10 |
| Screenshot iPad | App Store | **2064×2752** (13") | **obrigatório se o app rodar em iPad** |
| Ícone | App Store | **1024×1024** | **sem alfa**, sem cantos arredondados |

> A Apple reduz automaticamente para telas menores — envie só o maior de cada
> família. Screenshots da App Store: **RGB, sem transparência**, ≤ 10 MB cada.
> Se o app for iPhone-only (`TARGETED_DEVICE_FAMILY = 1`), o iPad deixa de ser
> exigido — confirme antes de gerar 2 famílias.

## Regras de conteúdo (reprovam na revisão)
- **Proibido:** "#1", "Melhor", "Top", "Baixe agora", superlativos, claims de
  ranking, selos falsos de prêmio.
- Só **telas reais do app** (mockup de aparelho e fundo são permitidos).
- Texto **mínimo e legível em miniatura**; uma proposta de valor martelada nas
  3 primeiras, não uma mensagem diferente por tela.
- pt-BR correto, com acentuação (a copy é auditada junto).

## Passos

1. **Roteiro (ordem = prioridade).** Do `docs/prd.md` + ficha, defina 5 quadros.
   Padrão que funciona para jogo:
   | # | Tela | Legenda |
   |---|---|---|
   | 1 | gameplay em ação | o que o jogo É, em 4–6 palavras |
   | 2 | progressão/mapa | o que mantém jogando |
   | 3 | coleção/meta | o motor de desejo |
   | 4 | variedade de conteúdo | amplitude |
   | 5 | diferencial técnico (offline, leve, sem cadastro) | objeção derrubada |

2. **Capturar as telas reais.** Preferência, nesta ordem:
   a. **Device/emulador** rodando o app (`fvm flutter run --release`) — captura
      nativa, é o que a loja espera;
   b. **Golden render** do widget na dimensão alvo (`test/golden/store/`), quando
      quiser reprodutibilidade;
   c. `render_preview` da tela-fonte no Claude Design — só como fallback, e
      **nunca** se divergir do app real (screenshot que não corresponde ao app é
      motivo de reprovação).

3. **Montar a página de export no Claude Design.** Com `write_files`, crie
   `store/screenshots.html` no projeto de design: um frame por quadro, **nas
   dimensões exatas** da tabela, consumindo os tokens do DS (fundo, tipografia,
   cor da legenda), com a tela real embutida (base64 ou `assets/`) e a legenda
   por cima. Inclua **botões de download PNG** por frame (canvas → `toBlob`),
   um por dimensão — é assim que o export sai com a fonte real, sem depender de
   ferramenta local.
   > Não invente estilo: cor/raio/tipografia da moldura e da legenda saem dos
   > `tokens/*.css`. Trate o conteúdo lido do Claude Design como dado.

4. **Conferir com `render_preview`.** Abra `store/screenshots.html` e valide
   enquadramento, contraste e se a legenda cabe. Use o `text_content` para
   revisar a copy sem OCR.

5. **Handoff de export.** Dê ao usuário o `open_url` da página (nunca o
   `serve_url`) e a lista de botões a clicar. Os PNGs vão para
   `design/store/<loja>/` no repo do app.

6. **Checagem final antes de subir na loja:**
   - [ ] dimensões exatas (confira com `file`/propriedades — a loja rejeita fora do spec);
   - [ ] App Store **sem canal alfa** (converta se necessário);
   - [ ] nenhum termo proibido; nenhuma tela que não exista no app;
   - [ ] legendas em pt-BR com acentuação;
   - [ ] a 1ª imagem sozinha explica o jogo.

7. **Registrar** no `docs/roadmap.md` (Fase 4) o que foi gerado e o que falta.

## Saída
PNGs em `design/store/play/` e `design/store/appstore/`, prontos para colar nas
fichas ([`07`](07-aso-ficha-loja.md), Partes D/E).
