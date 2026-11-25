# AI DEV MEMORY — Plano Mestre (Registrado)

**Status**: Prioridade 2 — aguardando conclusão da Prioridade 1 e validação independente antes de implementação.

**Escopo**: Infraestrutura de memória de desenvolvimento persistente, segura, portátil e independente de modelo, integrada ao Codex, Claude Code e Lovable, com adaptação futura ao ChatGPT. Custo adicional obrigatório: zero.

## Resumo dos requisitos

### Arquitetura
- **Local (padrão)**: SQLite no diretório privado do usuário; CLI e MCP local via stdio. Sem rede obrigatória.
- **Compartilhado (opt-in)**: PostgreSQL/Supabase Free dedicado, sincronização opcional, cache/fila SQLite.
- **GitHub**: fonte de código, nunca de memória privada ou segredos.

### Fonte de verdade
- Código e estado real do projeto: fonte da implementação.
- SQLite (local) e PostgreSQL (remoto): autoridade da memória no respectivo modo.
- Diretrizes autorizadas prevalecem sobre recordações.

### Escopos
usuario/organizacao → workspace → projeto → tarefa → sessao/agente. Sem vinculo automatico por nome/caminho; identificadores estaveis obrigatorios.

### Modelo de dados
Tabelas principais: workspaces, memberships, projects, tasks, sessions, directives, decisions, plans, milestones, checkpoints, attempts, test_results, audit_results, agent_runs, operational_events, lessons_learned, artifacts, sync_outbox, sync_conflicts, schema_migrations.

### Recuperacao
- FTS5 (local) e full-text (remoto). Contexto de retomada ate ~2000 tokens, expansao sob demanda.
- Sem embeddings, chamadas externas ou resumos periodicos obrigatorios.

### CLI e MCP
- CLI: init, doctor, bind, status, context, search, checkpoint, resume, export, import, backup, restore, sync, conflicts, disconnect, purge.
- MCP local stdio; MCP remoto Streamable HTTP.
- Ferramentas MCP: memory_health, memory_context, memory_search, memory_project, memory_task, memory_resume, memory_list_pending, memory_sync_status, memory_checkpoint, memory_record_decision, memory_record_test, memory_record_attempt, memory_record_event, memory_record_lesson.

### Seguranca
- Threat model: prompt injection, acesso cross-tenant, symlink/path traversal, segredo vazado, backup roubado, dependencia adulterada.
- RLS em todas as tabelas expostas; menor privilegio; deny-by-default.
- Sem service_role nos clientes; HTTPS; tokens em armazenamento nativo seguro.

### Integracoes
- Codex: skills retomar/meta/planejar/executar/corrigir/testar/auditar/agentes/banco/seguranca + hooks documentados.
- Claude Code: adaptador separado, formatos nativos, MCP local/remoto, CLAUDE.md.
- Lovable: MCP oficial (https://mcp.lovable.dev) para administrar Lovable; conector MCP personalizado para Lovable consultar memoria. Sao coisas diferentes.
- ChatGPT: interoperabilidade futura via MCP remoto ou handoff autorizado.

### Instalador
- Integrar ao instalador universal existente (Codex/Claude/Lovable).
- Menu: instalar memória local, habilitar nuvem opcional, conectar plataformas, status/sync, backup, atualizar, desconectar.

### Plano de execução (fases)
0. Baseline (inventário, SHA, ADR, threat model)
1. Núcleo local (schema, CLI, FTS, backups)
2. MCP e adaptadores locais (Codex, Claude Code)
3. Remoto opcional (Supabase/PostgreSQL, RLS, Auth)
4. Sincronização (outbox, conflitos, offline)
5. Lovable/ChatGPT (adaptadores, testes reais)
6. Pacote público/privado (instalador, atualizador, docs)
7. Auditorias e aceite

### Critérios de aceite

- **Local**: instalação segura, zero rede obrigatória, persistência real, busca seletiva, isolamento e recuperação em sessão distinta.
- **Remoto**: RLS testada com cross-tenant negativo, sincronização idempotente, custo gratuito verificado.
- **Lovable**: leitura/escrita reais em sandbox, continuidade cruzada.
- **Publico**: auditoria de seguranca/licenca, instalador completo, nenhuma dependência privada.

### Matriz de testes
Instalação/idempotência/conflito/backup/rollback; SQLite integridade/crash/migração; MCP discovery/schemas/limites; segurança cross-tenant/RLS/injection; sincronização offline/conflito/tombstone; continuidade sessão/modelo/compactação; agentes concorrência/falha de transporte; Lovable OAuth/write/read/revogação; desempenho p50/p95 com baseline.

## Status de implementação

**NÃO INICIADO**. Aguardando conclusão da Prioridade 1 e validação independente do ChatGPT antes de iniciar a implementação.

## Referências

- Supabase: https://supabase.com/pricing, /docs/guides/platform/free-project-pausing, /docs/guides/ai-tools/byo-mcp
- Lovable: https://lovable.dev/mcp, https://docs.lovable.dev/
- Codex: https://developers.openai.com/learn/docs-mcp, https://learn.chatgpt.com/docs/hooks
- Claude Code: https://code.claude.com/docs/
- MCP: https://modelcontextprotocol.io/


## Nota de integracao Prioridade 1

A skill utomacao (Prioridade 1) acompanha metas via Thread Heartbeat nativo e supervisao externa (Dot/Acessor). O plano AI Dev Memory (Prioridade 2) deve respeitar essa infraestrutura e usa-la para retomadas de longa duracao quando disponivel.
