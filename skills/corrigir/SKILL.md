---
name: corrigir
description: Diagnostico disciplinado de bugs e regressoes de desempenho.
---

## Objetivo
Identificar e corrigir a causa raiz de falhas, bugs e regressoes usando metodo sistematico, evitando correcoes superficiais.

## Quando ativar
- Falha reproduzivel em teste ou producao
- Regressao de desempenho detectada
- Comportamento inesperado sem causa obvia
- Erro intermitente

## Procedimento
1. Reproduza a falha de forma confiavel
2. Colete evidencia (logs, stack trace, metricas)
3. Formule hipotese causal baseada em evidencia
4. Projete teste discriminante para validar/refutar hipotese
5. Execute teste e analise resultado
6. Se hipotese refutada, formule nova e repita
7. Aplique correcao minima que resolve a causa raiz
8. Adicione teste de regressao
9. Verifique que a correcao nao introduz novos problemas

## Criterios de conclusao
- Causa raiz identificada e documentada
- Correcao aplicada e verificada
- Teste de regressao adicionado
- Falha original nao mais reproduzivel

## Erros comuns
- Corrigir sintoma sem investigar causa raiz
- Mudar multiplas coisas de uma vez
- Nao adicionar teste de regressao
- Desistir apos 1 tentativa sem mudar abordagem