---
name: retomar
description: Recupera contexto e estado apos compactacao ou troca de sessao.
---

## Objetivo
Restaurar o estado de trabalho apos interrupcoes, compactacoes de contexto ou trocas de sessao, garantindo continuidade fiel.

## Quando ativar
- Inicio de nova sessao em tarefa existente
- Apos compactacao automatica de contexto
- Troca de provedor ou ferramenta
- Quando o usuario diz "retomar"

## Procedimento
1. Localize STATE.json e HANDOFF.md da tarefa
2. Leia o estado salvo e o ultimo checkpoint
3. Verifique consistencia com o codigo atual
4. Restaure autorizacoes e decisoes previas
5. Identifique trabalho pendente
6. Continue a partir do ultimo ponto valido

## Criterios de conclusao
- Estado restaurado e consistente
- Trabalho pendente identificado
- Autorizacoes preservadas
- Sem repeticao de trabalho ja concluido

## Erros comuns
- Reiniciar do zero sem ler estado salvo
- Ignorar HANDOFF.md
- Assumir que o estado salvo esta atualizado sem verificar
- Perder autorizacoes anteriores

## Recuperação de Transparência e Concorrência

- Ao retomar, restaure não apenas o estado da tarefa mas também as instruções de transparência operacional.
- Verifique se houve falhas de transporte de subagentes na sessão anterior e ajuste estratégia de concorrência.
- Reforce regras de transparência e concorrência adaptativa após recuperação.

## Retomada Automatica

Ao retomar via automacao (Heartbeat), verificar id da automacao no checkpoint, recuperar estado atual e continuar pelo proximo passo pendente sem reiniciar.