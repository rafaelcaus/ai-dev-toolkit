# Matriz de Rastreabilidade — AI Dev Toolkit

**Última atualização:** 2026-11-25
**Status:** REPROVADO pela auditoria independente — pendências abertas abaixo

## Legenda
- ✅ Evidência verificável existe e está vinculada
- ⚠️ Parcialmente atendido / evidência incompleta
- ❌ Não atendido / sem evidência
- 🔒 Bloqueado por dependência externa

## Requisitos Originais (PR #1 + Instruções)

| ID | Requisito | Status | Evidência | Commit/Link |
|----|-----------|--------|-----------|-------------|
| R01 | Instalação em ambiente descartável | ✅ | Windows TEMP + WSL /tmp testados | 0f78fe4, 6e1a30a |
| R02 | Testes automatizados | ⚠️ | CI verde, mas testes negativos ausentes | .github/workflows/ci.yml |
| R03 | Continuidade após compactação | ✅ | Sessão atual recuperou contexto via HANDOFF | Esta sessão |
| R04 | Skills personalizadas (17 públicas) | ✅ | Listadas e instaláveis | skills/ |
| R05 | Delegação de tarefas (16 agentes) | ⚠️ | TOMLs presentes; execução real não comprovada para todos | agents/ |
| R06 | Formatação dos avisos operacionais | ✅ | ### + emoji + negrito preservados nesta sessão | AGENTS.md |
| R07 | Seleção automática de skills | ❌ | Sem teste funcional de descoberta automática | — |
| R08 | Acionamento real dos 16 agentes | ⚠️ | Configuração presente; execução limitada por falha de transporte NEW_TASK em algumas sessões | skills/agentes/SKILL.md |
| R09 | Metas nativas (create/get/update_goal) | ✅ | Meta ativa criada e acompanhada nesta sessão | get_goal output |
| R10 | Hooks de continuidade e recuperação | ⚠️ | STATE.json/HANDOFF funcionais; hooks de qualidade INEXISTENTES no perfil | Investigação sistêmica |
| R11 | Controle de estagnação | ⚠️ | Regra 2/3 tentativas em AGENTS.md; sem validador automático | AGENTS.md |
| R12 | Persistência após compactações | ✅ | HANDOFF.md + checkpoint funcional | Esta sessão |
| R13 | Transparência operacional v1.3 | ✅ | Cabeçalhos ### mantidos em todas as respostas | Esta sessão |
| R14 | Planejamento, execução, correções, testes, dupla auditoria | ⚠️ | Fluxo existe; barreira técnica de bloqueio NÃO existe | auditoria-final SKILL.md |
| R15 | Instalador universal (Codex/Claude/Lovable) | ✅ | install.ps1 + install.sh funcionais | 6e1a30a, 073de34 |
| R16 | Portabilidade, atualização, backup, restauração | ✅ | Ciclos completos testados em 3 ambientes | VALIDATION_REPORT.md |
| R17 | Segurança e privacidade (sem credenciais/dados pessoais) | ✅ | rg -i Millano/RAFAEL/api_key = 0 hits | VALIDATION_REPORT.md |
| R18 | README profissional em PT-BR | ⚠️ | Existe mas falta detalhamento individual das 17 skills e 16 agentes | README.md |
| R19 | Licenças auditadas | ✅ | LICENSE por skill + procedência de Pexels e BM25 documentadas | f12a1e7 |
| R20 | Integração Lovable MCP | ✅ | Ciclo CRUD + massa 17/17 validado | e954579 |
| R21 | Integração Claude Code | ✅ | Agentes MD + ciclo instalar/desinstalar/restaurar | 6e1a30a |
| R22 | Repositório público independente do privado | ✅ | rafaelcaus/ai-dev-toolkit sem histórico privado | GitHub |
| R23 | Pacote PARTICULAR validado | ❌ | Validação pendente (não confundir com público) | — |
| R24 | Barreira técnica de conclusão | ❌ | NÃO EXISTE; conclusão depende apenas de disciplina comportamental | Investigação sistêmica |

## Correções da Auditoria Independente v2

| ID | Correção Exigida | Status | Evidência | Commit/Link |
|----|------------------|--------|-----------|-------------|
| C01 | Procedência/licença dos 27 arquivos design-system | ✅ | LICENSE criado com MIT/Pexels/BM25/divergência documentada | f12a1e7 |
| C02 | AGENTS.md e CLAUDE.md nativos (no repo) | ✅ | Ambos criados genericos na raiz do repo publico | e73516c |
| C03 | README detalhado (17 skills + 16 agentes com exemplos) | ❌ | README atual lista nomes mas sem exemplos individuais | README.md |
| C04 | CI com testes negativos (propriedade, conflito, corrupção, rollback) | ❌ | CI só tem testes positivos/sintáticos | .github/workflows/ci.yml |
| C05 | Reclassificar falha de subagentes (NÃO é limite de concorrência) | ✅ | Classificado como falha de transporte NEW_TASK; regra de máx. 3 agentes aplicada | Esta sessão |
| C06 | Validar pacote PARTICULAR e integrações | ❌ | Apenas o público foi validado | — |
| C07 | Matriz completa de rastreabilidade | ✅ | Este arquivo (TRACEABILITY_MATRIX.md) | HEAD |

## Barreiras Técnicas de Qualidade (a implementar)

| ID | Mecanismo | Plataforma | Status | Notas |
|----|-----------|------------|--------|-------|
| B01 | Matriz persistente de requisitos | Codex/Claude/Lovable | 🔄 Em progresso | Este arquivo |
| B02 | Validador de cobertura pré-conclusão | Codex (update_goal) | ❌ Não implementado | Requer hook ou wrapper |
| B03 | Invalidação seletiva de evidências | Todas | ❌ Não implementado | Quando código muda, evidência antiga é invalidada |
| B04 | Testes negativos obrigatórios no CI | GitHub Actions | ❌ Não implementado | Propriedade, conflito, corrupção, rollback |
| B05 | Auditoria independente automática | Codex | ❌ Não implementado | Subagente auditor com critérios verificáveis |
| B06 | Bloqueio de merge/conclusão com falhas | GitHub/Codex | ⚠️ Branch protection possível; update_goal sem gate nativo | Documentar limitação |

## Limitações da Plataforma (documentadas, não inventar workarounds)

| Limitação | Impacto | Issue/Rastreamento |
|-----------|---------|-------------------|
| update_goal(complete) não valida requisitos automaticamente | Conclusão prematura possível | Comportamento nativo; mitigar com matriz + auditoria |
| Hooks de qualidade não existem no perfil Codex | Sem gate automático pré-conclusão | Investigação sistêmica confirmou ausência |
| Subagentes NEW_TASK com payload vazio | Delegação paralela falha sistematicamente | 9+ casos confirmados nesta sessão |
| Blocos "Processando" recolhidos | Transparência reduzida pós-resposta | Issues #22334, #34418, #23221 (abertos) |

