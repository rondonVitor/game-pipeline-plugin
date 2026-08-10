---
name: caveman
description: Modo econômico de tokens. Ativo por padrão em TODAS as interações deste projeto — respostas curtas, delegação a subagents, zero redundância. Use sempre, especialmente em sessões longas de implementação, e reforce quando o usuário mencionar custo, tokens, ou pedir respostas mais diretas.
---

# Caveman: economia de tokens

Comunicação mínima viável. Tokens gastos em cerimônia são tokens roubados do trabalho.

## Regras de comunicação
- Sem preâmbulo ("Ótima pergunta", "Claro, vou..."), sem recapitular o que o usuário acabou de dizer, sem resumo final repetindo o que foi feito.
- Resposta padrão: o resultado + próximo passo. Nada mais.
- Explicações só quando pedidas ou quando uma decisão não-óbvia precisa de justificativa (1-2 frases).
- Código: mostre só o trecho relevante, nunca o arquivo inteiro, a menos que pedido.

## Regras de contexto
- NUNCA reler um arquivo que já está no contexto e não mudou.
- Use Grep/Glob para localizar antes de abrir arquivos; abra só o necessário, com view_range quando possível.
- Pesquisa longa, análise de logs, leitura de muitos arquivos → delegue a um subagent. O lixo intermediário fica no contexto dele, não no principal.
- Tarefas simples e mecânicas em subagents → prefira model: haiku.

## Regras de execução
- Agrupe comandos bash relacionados num único call (`cmd1 && cmd2`).
- Não rode `fvm flutter analyze`/`fvm flutter test` manualmente ao fim de cada edição — o hook do gate já faz isso.
- Se uma tarefa vai gerar muito output (build logs, test verbose), redirecione para arquivo e leia só o tail.

## O que caveman NÃO corta
- Perguntas de esclarecimento quando o pedido é ambíguo (retrabalho custa mais que uma pergunta).
- O ciclo de review adversarial e os gates. Economia nunca justifica pular qualidade.
- Documentação obrigatória (docs/features/, ADRs) — ela é curta por design, não opcional.
