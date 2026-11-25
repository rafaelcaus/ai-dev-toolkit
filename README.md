## AVISO — VERSAO EXPERIMENTAL

**Nao execute o instalador ate a conclusao da auditoria final.** Esta versao (1.7.1-experimental) corrige falhas identificadas na revisao anterior. O aviso sera removido apos validacao completa.

---

# AI Dev Toolkit

Kit de produtividade para desenvolvimento assistido por IA para Codex Desktop/CLI e Claude Code.

## O que e

Conjunto de **17 skills** e **16 perfis de agente** (formato TOML para Codex, Markdown YAML para Claude Code) que automatizam planejamento, execucao, correcao, teste, auditoria e revisao de codigo.

## As 17 skills

| Skill | Funcao |
|-------|--------|
| planejar | Transforma ideias em planos executaveis. |
| meta | Cria, acompanha e conclui metas nativas. |
| executar | Implementa planos com verificacao continua. |
| corrigir | Diagnostico disciplinado de bugs. |
| testar | Verificacao baseada em evidencias. |
| auditar | Auditoria independente de entregas. |
| revisar | Revisao de codigo antes de merge. |
| retomar | Recupera contexto apos compactacao. |
| agentes | Delegacao paralela e concorrencia adaptativa. |
| banco | Boas praticas PostgreSQL/Supabase. |
| react | Otimizacoes React/Next.js. |
| visual | Diretrizes de interface web. |
| seguranca | Vulnerabilidades e config. arriscadas. |
| prompt | Geracao de prompts estruturados. |
| design-system | Tokens de design em tres camadas. |
| desempenho | Analise de gargalos mensuraveis. |
| automacao | Acompanhamento automatico e supervisao continua. |

## Os 16 agentes

arquiteto, investigador, programador, frontend, backend, banco, seguranca, qualidade, testador, designer, desempenho, infra, pesquisador, auditor, integracoes, automacao.


## Detalhamento das 17 Skills

| Skill | Função | Exemplo de Acionamento |
|-------|--------|------------------------|
| **planejar** | Transforma ideias em planos executáveis com critérios verificáveis. | "Planeje a implementação do módulo de autenticação." |
| **executar** | Implementa planos com verificação contínua e checkpoints de estado. | "Execute o plano de migração do banco de dados." |
| **corrigir** | Diagnóstico disciplinado de bugs (reproduzir → minimizar → corrigir). | "Corrija o erro 500 ao salvar o formulário." |
| **testar** | Exige evidência fresca antes de qualquer afirmação de sucesso. | "Teste se o login funciona com credenciais inválidas." |
| **auditar** | Revisão independente da entrega versus requisitos originais. | "Audite a entrega da feature de pagamentos." |
| **revisar** | Code review focado em arquitetura, segurança e manutenibilidade. | "Revise o PR #42 antes do merge." |
| **retomar** | Recupera contexto e estado após compactação ou troca de sessão. | "Retome a tarefa de refatoração do frontend." |
| **agentes** | Gerencia delegação paralela e concorrência adaptativa (máx. 3). | "Use agentes para testar frontend e backend em paralelo." |
| **banco** | Boas práticas para PostgreSQL, Supabase e SQL Server. | "Otimize a query de listagem de usuários no Supabase." |
| **react** | Otimizações de performance para React e Next.js. | "Melhore o LCP da página inicial usando React Server Components." |
| **visual** | Diretrizes de interface web e acessibilidade (WCAG). | "Ajuste o contraste dos botões para atender ao nível AA." |
| **seguranca** | Identifica vulnerabilidades e configurações arriscadas. | "Verifique se há exposição de variáveis de ambiente no código." |
| **prompt** | Geração de prompts estruturados para LLMs e agentes. | "Gere um prompt para um agente especialista em SQL." |
| **design-system** | Arquitetura de tokens de design em três camadas (primitivo, semântico, componente). | "Crie um novo token de cor para o tema escuro." |
| **desempenho** | Análise de gargalos mensuráveis em frontend e backend. | "Identifique por que a API demora 2s para responder." |
| **meta** | Cria, acompanha e conclui metas nativas da plataforma. | "Crie uma meta para a entrega do MVP até sexta-feira." |
| **automacao** | Acompanhamento automático e supervisão contínua de tarefas. | "Monitore o deploy e avise se houver falha." |

## Detalhamento dos 16 Agentes

| Agente | Responsabilidade Principal | Skills Prioritárias |
|--------|---------------------------|---------------------|
| **ag-arquiteto** | Planejamento técnico, análise de impactos e definição de arquitetura. | planejar, desempenho |
| **ag-investigador** | Causa-raiz de bugs complexos e tarefas estagnadas. | corrigir, retomar |
| **ag-programador** | Implementação geral de código, correções e novas funcionalidades. | executar, testar |
| **ag-frontend** | Interfaces de usuário em React/TypeScript e UX. | react, visual, testar |
| **ag-backend** | APIs, serviços, lógica de negócio e integração com banco. | executar, banco, seguranca |
| **ag-banco** | Modelagem, otimização e segurança de dados (Postgres/Supabase). | banco, seguranca |
| **ag-seguranca** | Revisão de segurança, autenticação, autorização e vulnerabilidades. | seguranca, revisar |
| **ag-qualidade** | Revisão independente de código e padrões de engenharia. | revisar, testar |
| **ag-testador** | Testes automatizados, funcionais, E2E e regressivos. | testar, automacao |
| **ag-designer** | Design de interfaces, UI/UX e aplicação do design system. | visual, design-system |
| **ag-desempenho** | Otimização de gargalos de frontend e backend. | desempenho, react, banco |
| **ag-infra** | Docker, servidores, CI/CD e DevOps. | executar, seguranca |
| **ag-pesquisador** | Pesquisa técnica, documentação oficial e APIs de terceiros. | prompt, revisar |
| **ag-auditor** | Auditoria independente de entregas, planos e conformidade. | auditar, meta |
| **ag-integracoes** | Integrações com ERP, n8n, webhooks e APIs externas. | executar, seguranca |
| **ag-automacao** | Supervisão contínua, heartbeats e alertas automáticos. | automacao, meta |

## Como funciona o acionamento automatico

O AI Dev Toolkit usa duas formas de acionamento, dependendo da plataforma:

**Codex Desktop/CLI:** o agente principal interpreta pedidos em linguagem natural. Palavras-chave (planeje, corrija, teste, audite, revise, retome) ativam a skill correspondente; tarefas tecnicas especificas podem ser delegadas aos agentes TOML. Nao e necessario memorizar comandos.

**Claude Code:** as skills seguem o formato nativo do Claude Code (SKILL.md com frontmatter YAML) e sao descobertas automaticamente.

**Lovable (via MCP):** skills sao instaladas como workspace skills e ficam disponiveis nos chats do workspace.

## Transparencia operacional

Avisos operacionais sao exibidos com titulos destacados:

### SKILL ATIVADA
### AGENTE ACIONADO
### AGENTE CONCLUIDO
### TESTES CONCLUIDOS
### AUDITORIA INICIADA
### ESTAGNACAO DETECTADA
### PENDENCIA GRAVE
## Instalador universal

Menu com seis opcoes: Codex, Claude Code, Lovable (MCP), atualizacoes, restauracao, desinstalacao.

- **Windows**: `pwsh ./install.ps1` (requer PowerShell 7+)
- **Linux/macOS**: `./install.sh` (requer bash)

### Recursos comprovados

- Previa sem escrita por padrao; aplicacao so com `-Apply` / `--apply`.
- Backup com hash SHA256 por arquivo antes de qualquer sobrescrita.
- Manifesto OWNERSHIP.json com lista de arquivos gerenciados.
- Desinstalacao e restauracao exigem confirmacao explicita.
- Desinstalacao/remove apenas componentes gerenciados; nunca toca em terceiros.
- Restauracao retorna arquivos aos caminhos originais.
- Atualizador apenas INFORMA; nao executa codigo remoto automaticamente.
- Lovable: ciclo unitario (CREATE/LIST/GET/UPDATE/DELETE) + instalacao em massa (17/17 skills) validados via MCP mcp.lovable.dev em workspace de teste.
- Ciclo completo (instalar → reinstalar → desinstalar → restaurar) validado em Windows.

### Limitacoes conhecidas

- CI multiplataforma (Windows/Linux/macOS) incluido em `.github/workflows/ci.yml`; execucao depende do GitHub Actions.
- Integracao Lovable via MCP validada em ciclo unitario e instalacao em massa (17/17 skills) no workspace LOVABLE 0.
- Subagentes reais do Codex podem apresentar falha de transporte de payload em algumas sessoes; ver skill `agentes` para protocolo de diagnostico.
- Blocos intermediarios do Codex Desktop podem recolher apos conclusao; nenhuma configuracao nativa encontrada para manter sempre expandido (`conversationDetailMode = STEPS_COMMANDS` nao controla isso).
- install.sh executado em WSL Ubuntu (Linux real): ciclo instalar 17 skills, desinstalar 0 skills, restaurar 17 skills. Pendente macOS fisico (CI cobre sintaxe).

## Seguranca e privacidade

O instalador NAO coleta, NAO transmite e NAO armazena credenciais, tokens, senhas, chaves de API, informacoes de empresas ou clientes, caminhos pessoais, historico do Git, conversas ou backups. Nenhuma alteracao em permissoes do sistema ou credenciais existentes.

## Restaurar backup

```
pwsh ./install.ps1 -RestoreBackup caminho-do-backup [-Apply] [-Target codex|claude]
./install.sh --restore caminho-do-backup [--target codex|claude] [--apply]
```

## Desinstalar

```
pwsh ./install.ps1 -Uninstall [-Target codex|claude] [-Apply]
./install.sh --uninstall [--target codex|claude] [--apply]
```

## Versao

**v1.7.1-experimental** (branch main, ver ultimo commit em https://github.com/rafaelcaus/ai-dev-toolkit/commits/main). Aviso experimental sera removido apos validacao completa.

## Licenca

Skills originais deste repositorio. Consulte LICENSE em cada skill de terceiros redistribuida.

