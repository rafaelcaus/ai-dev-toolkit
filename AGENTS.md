# AI Dev Toolkit — Global Agent Instructions

Este arquivo complementa as instruções nativas da plataforma. Não substitui configurações existentes do usuário.

## Workflow Padrão
1. **Planejar**: Transformar ideias em planos executáveis com critérios verificáveis.
2. **Executar**: Implementar com verificação contínua e checkpoints de estado.
3. **Corrigir**: Diagnóstico disciplinado de bugs (reproduzir → minimizar → corrigir → validar).
4. **Testar**: Evidência fresca antes de qualquer afirmação de sucesso.
5. **Auditar**: Revisão independente da entrega versus requisitos.
6. **Revisar**: Code review focado em arquitetura, segurança e manutenibilidade.

## Regras Operacionais
- **Transparência**: Usar cabeçalhos `###` + emoji + negrito em avisos operacionais.
- **Estagnação**: Após 2 tentativas improdutivas, mudar hipótese; após 3, revisar arquitetura.
- **Estado Externo**: Manter `STATE.json` e `HANDOFF.md` por tarefa para recuperação pós-compactação.
- **Segurança**: Nunca armazenar segredos ou credenciais em arquivos de estado.

## Equipe de Agentes Especializados
| Agente | Responsabilidade Principal |
|--------|---------------------------|
| ag-arquiteto | Arquitetura, planejamento técnico e análise de impactos. |
| ag-investigador | Causa-raiz de bugs e tarefas estagnadas. |
| ag-programador | Implementação geral de código e funcionalidades. |
| ag-frontend | React, TypeScript e interfaces de usuário. |
| ag-backend | APIs, serviços e lógica de negócio no servidor. |
| ag-banco | PostgreSQL, Supabase e SQL Server. |
| ag-seguranca | Revisão de segurança, autenticação e vulnerabilidades. |
| ag-qualidade | Revisão independente de código e padrões. |
| ag-testador | Testes automatizados, funcionais e E2E. |
| ag-designer | Design de interfaces, UI/UX e design system. |
| ag-desempenho | Otimização e identificação de gargalos. |
| ag-infra | Docker, servidores e DevOps. |
| ag-pesquisador | Documentação oficial, APIs e pesquisa técnica. |
| ag-auditor | Auditoria independente de entregas e planos. |
| ag-integracoes | Integrações: ERP, n8n, APIs e webhooks. |
| ag-automacao | Acompanhamento automático e supervisão contínua. |

## Limitações da Plataforma
- Blocos "Processando" podem ser recolhidos automaticamente pelo Codex Desktop.
- Subagentes podem apresentar falhas de transporte de payload em algumas sessões.
- `update_goal(complete)` não valida requisitos automaticamente; use a matriz de rastreabilidade.
