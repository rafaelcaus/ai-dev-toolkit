---
name: executar
description: Implementacao de planos com verificacao continua de progresso.
---

## Objetivo
Implementar mudancas planejadas de forma disciplinada, verificando progresso a cada etapa e preservando estado para retomada.

## Quando ativar
- Plano aprovado e pronto para implementacao
- Continuacao de tarefa interrompida
- Implementacao de feature com multiplas etapas

## Procedimento
1. Leia o plano e o estado atual (STATE.json/HANDOFF.md se existirem)
2. Identifique a proxima etapa pendente
3. Implemente a etapa com foco e escopo definido
4. Verifique o resultado antes de prosseguir
5. Atualize checkpoint apos cada marco
6. Se bloqueado, registre o bloqueio e mude de estrategia
7. Ao concluir, valide contra criterios de aceitacao

## Criterios de conclusao
- Todas as etapas do plano implementadas
- Cada etapa verificada individualmente
- Estado final consistente com o plano
- Criterios de aceitacao atendidos

## Erros comuns
- Pular verificacao entre etapas
- Nao salvar checkpoints
- Continuar em tarefa bloqueada sem mudar abordagem
- Perder contexto apos compactacao sem recuperar estado

## Transparência Operacional Persistente

- Preserve títulos Markdown ###, emojis e negrito nos registros operacionais.
- Inclua registros operacionais relevantes na resposta final (não apenas em mensagens intermediárias).
- Mantenha histórico operacional persistente isolado por tarefa em STATE.json ou HANDOFF.md, sem credenciais.
- Reforce instruções de transparência após compactação e retomada.
- Não utilize hooks de reformatação que provoquem ciclos desnecessários ou ocultem respostas completas.