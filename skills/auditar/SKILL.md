---
name: auditar
description: Auditoria independente de entregas, etapas ou planos concluidos.
---

## Objetivo
Verificar de forma independente se uma entrega, etapa ou plano atende aos criterios definidos, identificando gaps, inconsistencias e riscos.

## Quando ativar
- Ao concluir uma etapa significativa de implementacao
- Antes de merge ou publicacao
- Quando solicitado explicitamente
- Apos correcao de falha critica

## Procedimento
1. Leia o escopo e os criterios de aceitacao originais
2. Inspecione os artefatos entregues (codigo, docs, testes, config)
3. Compare o entregue vs. o especificado
4. Verifique testes, evidencias e documentacao
5. Classifique achados: critico, importante, sugestao
6. Produza relatorio estruturado

## Criterios de conclusao
- Relatorio de auditoria produzido com classificacao de achados
- Cada achado tem evidencia concreta (arquivo, linha, comando)
- Recomendacoes acionaveis para cada achado

## Erros comuns
- Auditar sem ler a especificacao original
- Confundir opiniao pessoal com criterio objetivo
- Nao verificar comportamento real (so ler codigo)
- Declarar conformidade sem evidencia

## Auditoria de Transparência e Concorrência

- Verifique se registros operacionais foram preservados na resposta final.
- Confirme que eventos de concorrência (agentes acionados, concluídos, falhas) foram registrados com evidência.
- Valide que instruções de transparência foram reforçadas após compactação.
- Diferencie mecanismos efetivamente automatizados de simples instruções comportamentais.