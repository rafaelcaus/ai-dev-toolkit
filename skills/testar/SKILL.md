---
name: testar
description: Verificacao baseada em evidencias antes de declarar conclusao.
---

## Objetivo
Validar que mudancas funcionam corretamente atraves de testes automatizados e verificacao funcional, com evidencia concreta.

## Quando ativar
- Apos implementacao de feature ou correcao
- Antes de declarar tarefa concluida
- Quando solicitado explicitamente
- Como parte do fluxo de verificacao

## Procedimento
1. Identifique cenarios de teste relevantes
2. Escreva/executa testes automatizados
3. Verifique comportamento real (nao so build/lint)
4. Valide casos limite e erros
5. Documente evidencia dos testes
6. Distinga: implementado, testado, validado

## Criterios de conclusao
- Testes automatizados passando
- Comportamento verificado funcionalmente
- Evidencia documentada
- Casos limite cobertos

## Erros comuns
- Declarar conclusao sem teste real
- Testar so caminho feliz
- Build/lint como substituto de teste funcional
- Nao verificar comportamento em ambiente real