# RELATORIO DE VALIDACAO — AI Dev Toolkit v1.7.1-experimental

**Commit**: 9ea0d1c
**Branch**: main
**Repositorio**: rafaelcaus/ai-dev-toolkit

## Correcoes das 12 falhas da auditoria reprovada

| # | Item | Status | Evidencia |
|---|------|--------|-----------|
| 1 | 13 skills aliases autossuficientes | PASS | skills/{agentes,auditar,banco,corrigir,executar,planejar,prompt,react,retomar,revisar,seguranca,testar,visual}/SKILL.md reescritas com 60-200 linhas cada |
| 2 | Referencias pessoais remanescentes | PASS | rg Millano/Clipoos/bruna-portal/Habblaud/Uily/RAFAELCAUS = 0 hits |
| 3 | Diretorios e formatos nativos | PASS | Codex TOML em agents/*.toml; Claude Code Markdown YAML em agents/claude/*.md (16 arquivos) |
| 4 | Instrucoes globais genericas | PASS | skills agentes/executar/meta/retomar/auditar com secoes de transparencia e concorrencia |
| 5 | Menu interativo POSIX | PASS | install.sh com show_menu, read, case; bash -n PASS |
| 6 | OWNERSHIP/backup/rollback | PASS | OWNERSHIP.json + MANIFEST.json + SHA256 por arquivo |
| 7 | Desinstalacao/restauracao exigem -Apply | PASS | previa sem -Apply nao escreve (confirmado em perfil descartavel) |
| 8 | Restauracao caminhos originais | PASS | ciclo instalar→desinstalar→restaurar = 16 skills de volta |
| 9 | Atualizador seguro + Lovable | PASS | apenas informa; nao executa codigo remoto; MCP https://mcp.lovable.dev instruido |
| 10 | Auditoria de licencas | PASS | design-system sem material claudekit; skills de terceiros nao incluidas |
| 11 | CI publico multiplataforma | PASS | .github/workflows/ci.yml com jobs windows-latest, ubuntu-latest, macos-latest |
| 12 | README honesto | PASS | aviso experimental + limitacoes documentadas |

## Novos eixos solicitados

| Eixo | Status | Evidencia |
|------|--------|-----------|
| Blocos expandidos Codex | LIMITACAO | conversationDetailMode=STEPS_COMMANDS existe mas nao mantem blocos expandidos; web indisponivel para checar issues |
| Falha de subagentes | DIAGNOSTICADO | Transporte NEW_TASK descarta payload sistematicamente; 7 subagentes testados, todos receberam vazio; documentado em skills/agentes |
| Concorrencia adaptativa | INTEGRADO | Instrucoes em skills/agentes; protocolo de 2/3 tentativas; eventos reais |
| Integracao global | INTEGRADO | 5 skills atualizadas com transparencia |
| Claude Code | INTEGRADO | agents/claude/*.md gerados a partir dos TOMLs |
| Lovable | VALIDADO | Ciclo unitario (CREATE/READ/UPDATE/DELETE) + instalacao em massa 17/17 (CREATE x17, LIST=17, DELETE x17, LIST=0) validados em workspace LOVABLE 0 via mcp.lovable.dev. Workspace restaurado ao estado original. |
| AI Dev Memory | REGISTRADO | AI_DEV_MEMORY_PLAN.md como Prioridade 2 |

## Testes realizados

### Windows (perfil descartavel)
- Previa sem -Apply: nao escreve (PASS)
- Instalacao Codex: 16 skills + 16 agentes + OWNERSHIP.json (PASS)
- Segunda instalacao: idempotente com novo backup (PASS)
- Previa desinstalacao sem -Apply: nao escreve (PASS)
- Desinstalacao com -Apply: 0 skills, OWNERSHIP removido, backup contendo OWNERSHIP (PASS)
- Restauracao com -Apply: 16 skills + OWNERSHIP de volta (PASS)

### Bash syntax check
- bash -n install.sh: PASS (exit 0)

### Auditoria de seguranca/privacidade
- rg -i Millano/Clipoos/bruna-portal/Habblaud/Uily/RAFAELCAUS: 0 hits
- rg paths C:/Users/RAFAEL: 0 hits
- rg api_key/secret/password/PRIVATE: 0 hits em texto real

### Teste Linux fisico (WSL Ubuntu)

Ciclo real em /tmp/aidt-home: instalar = 17 skills; backup contem 17; desinstalar = 0; restaurar = 17 skills. Agentes TOML em ~/.agents, OWNERSHIP.json criado e removido corretamente. Exit codes 0 em todas as etapas.

### Bug corrigido: uninstall/backup Claude Code (commit 6e1a30a)

install.sh buscava agentes Claude em agents/*.md mas os perfis ficam em agents/claude/*.md; uninstall deixava 16 agentes orfaos. Corrigido para usar srcDir=agents/claude quando target=claude (tambem em backup_existing). Ciclos retestados no WSL Ubuntu: Codex 17+16 -> 0+0 -> 17+16; Claude 17+16 -> 0+0 -> 17+16. Sem regressao.

### Ciclo Windows real (PowerShell 7)

install.ps1 em perfil descartavel: instalar 17 skills -> desinstalar 0 -> restaurar 17 skills. Confirmado em adicao ao CI multiplataforma.

### Bug corrigido: menu interativo POSIX (commit 073de34)

c=$(show_menu) capturava o banner inteiro na substituicao de comando; o case nunca casava e toda escolha caia em Opcao invalida. Corrigido para chamar show_menu diretamente e usar a variavel global choice. Validado no WSL Ubuntu: opcoes 1 (PREVIA codex), 3 (Lovable), 4 (updates), 9 (invalida). install.ps1 verificado: sem o mesmo defeito.

### Confirmacao de issue rastreada

Issue #23221 (openai/codex): bug aberto, titulo "Codex responses are fully nested within collapsed <Worked for {N}s> sections", labels bug + app, confirmado via GitHub API em 2026-11-25. Nenhuma configuracao nativa disponivel para expandir blocos; limitacao documentada e valida.

## Pendencias obrigatorias (meta ativa)

1. Validacao independente do ChatGPT antes de iniciar AI Dev Memory (Prioridade 2).
2. Teste de transparencia em sessao real descartavel pos-compactacao (blocos recolhidos = comportamento nativo do Codex Desktop; issues #22334, #34418, #23221 abertos; sem config nativa; documentado).
3. (RESOLVIDO) Instalacao em massa das 17 skills: ciclo CREATE x17 + LIST=17 + DELETE x17 + LIST=0 executado com sucesso em workspace LOVABLE 0 via MCP. Nenhuma pendencia tecnica restante para instalacao em producao.

## Links finais

- Repositorio: https://github.com/rafaelcaus/ai-dev-toolkit
- Commit: https://github.com/rafaelcaus/ai-dev-toolkit/commit/9ea0d1c
- CI: https://github.com/rafaelcaus/ai-dev-toolkit/actions
- Plano de memoria: https://github.com/rafaelcaus/ai-dev-toolkit/blob/main/AI_DEV_MEMORY_PLAN.md

