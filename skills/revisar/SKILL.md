---
name: revisar
description: Revisao de codigo multi-eixo antes de merge ou publicacao.
---

## Objetivo
Realizar revisao abrangente de codigo cobrindo correcao, seguranca, desempenho, manutenibilidade e conformidade.

## Quando ativar
- Antes de merge de PR
- Apos implementacao de feature critica
- Quando solicitado explicitamente
- Como parte do fluxo de auditoria dupla

## Procedimento
1. Leia a descricao da mudanca e o contexto
2. Verifique correcao logica e cobertura de casos limite
3. Avalie seguranca (inputs, auth, dados sensiveis)
4. Analise desempenho (complexidade, alocações, queries)
5. Cheque manutenibilidade (nomes, estrutura, docs)
6. Valide testes e cobertura
7. Produza feedback estruturado por prioridade

## Criterios de conclusao
- Revisao completa em todos os eixos
- Feedback classificado (critico/importante/sugestao)
- Cada item com referencia concreta (arquivo/linha)
- Aprovacao ou lista de acoes pendentes

## Erros comuns
- Revisar so estilo/formatoacao
- Ignorar implicacoes de seguranca
- Nao testar mentalmente os caminhos criticos
- Feedback vago sem acao clara