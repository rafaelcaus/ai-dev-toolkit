---
name: agentes
description: Delegacao paralela de tarefas independentes para acelerar execucao.
---

## Objetivo
Coordenar a execucao simultanea de tarefas que nao compartilham estado mutavel, distribuindo trabalho entre multiplos agentes especializados.

## Quando ativar
- Tarefa com 2+ partes independentes (ex: frontend + backend + testes)
- Investigacao que pode ser paralelizada (pesquisa + analise de codigo + logs)
- Revisao multi-eixo (seguranca + desempenho + qualidade)

## Procedimento
1. Identifique as partes independentes da tarefa
2. Defina fronteiras claras de arquivos/responsabilidade para cada agente
3. Disparar agentes em paralelo com instrucoes completas e autossuficientes
4. Aguardar resultados e integrar
5. Verificar consistencia entre as partes entregues

## Criterios de conclusao
- Todas as partes foram executadas e entregues
- Integracao verificada sem conflitos
- Resultado final coerente e completo

## Erros comuns
- Dividir tarefas com dependencia sequencial em paralelo
- Nao definir fronteiras de arquivos (risco de conflito)
- Enviar payload incompleto ao subagente
- Assumir que o subagente tem contexto da conversa pai

## Concorrência Adaptativa de Subagentes

- Identifique tarefas independentes antes de delegar.
- Distribua entre especialistas com fronteiras claras de arquivos.
- Mantenha agentes produtivos: quando um concluir, atribua outra tarefa independente se houver trabalho paralelo.
- Aumente progressivamente a concorrência conforme resultados comprovados; ao identificar limite real, retorne ao último nível estável.
- Registre eventos reais: AGENTES ACIONADOS, CONCORRÊNCIA AMPLIADA, LIMITE DE AGENTES ATINGIDO, CONCORRÊNCIA AJUSTADA, FALHA DE TRANSPORTE, AGENTES CONCLUÍDOS.
- Não simule agentes nem apresente tentativas rejeitadas como execução bem-sucedida.

## Falha de Transporte de Payload

Se subagentes receberem atribuições vazias repetidamente:
1. Verifique limite de concorrência da plataforma.
2. Confirme que o payload enviado contém identificador, objetivo, fronteiras, critério de conclusão e autorização.
3. Após duas tentativas equivalentes sem sucesso, altere a hipótese.
4. Após três abordagens sem progresso, registre bloqueio e execute diretamente.
5. Não tente contornar limitações da plataforma por meios não suportados.