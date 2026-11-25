---
name: banco
description: Boas praticas para PostgreSQL, Supabase e SQL Server em projetos reais.
---

## Objetivo
Garantir que operacoes de banco de dados sigam boas praticas de seguranca, desempenho e manutenibilidade.

## Quando ativar
- Criacao ou alteracao de schema, indices, constraints
- Consultas complexas ou com impacto de desempenho
- Configuracao de conexoes, pools, autenticacao
- Migracoes de dados ou estrutura

## Procedimento
1. Valide nomes de tabelas/colunas (snake_case, descritivos)
2. Garanta tipos adequados e constraints (NOT NULL, FK, CHECK)
3. Crie indices para colunas filtradas/ordenadas frequentemente
4. Use transacoes para operacoes atomicas
5. Evite SELECT *; selecione colunas explicitas
6. Parametrize consultas (nunca concatene strings)
7. Configure timeouts e limites de conexao
8. Documente decisoes de modelagem

## Criterios de conclusao
- Schema validado contra boas praticas
- Consultas parametrizadas e com plano de execucao analisado
- Indices criados onde necessario
- Sem vulnerabilidades de injecao SQL

## Erros comuns
- Usar string interpolation em queries
- Ignorar N+1 em relacoes
- Nao usar transacoes em escritas multiplas
- Indices excessivos ou ausentes