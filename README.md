# AI Dev Toolkit

Kit de produtividade para desenvolvimento assistido por IA, projetado para Codex Desktop/CLI e Claude Code.

## O que e

Conjunto de **16 skills** e **16 perfis de agente** que automatizam planejamento, execucao, correcao, teste, auditoria e revisao de codigo. Os agentes sao acionados automaticamente conforme a natureza da tarefa.

## As 16 skills

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
| agentes | Delegacao paralela de tarefas. |
| banco | Boas praticas para PostgreSQL e Supabase. |
| react | Otimizacoes de React e Next.js. |
| visual | Diretrizes de interface web. |
| seguranca | Vulnerabilidades e configuracoes arriscadas. |
| prompt | Geracao de prompts estruturados. |
| design-system | Tokens e especificacao de componentes. |
| desempenho | Analise de gargalos mensuraveis. |

## Os 16 agentes

| Agente | Especialidade |
|--------|---------------|
| arquiteto | Arquitetura e planejamento tecnico. |
| investigador | Causa-raiz de bugs. |
| programador | Implementacao geral. |
| frontend | React, TypeScript e interfaces. |
| backend | APIs e logica de negocio. |
| banco | PostgreSQL e Supabase. |
| seguranca | Revisao de seguranca. |
| qualidade | Revisao independente. |
| testador | Testes automatizados e E2E. |
| designer | UI/UX e design system. |
| desempenho | Otimizacao e gargalos. |
| infra | Docker e DevOps. |
| pesquisador | Documentacao oficial. |
| auditor | Auditoria do plano e projeto. |
| integracoes | ERP, webhooks e sincronizacao. |
| automacao | Windows e PowerShell. |

## Seguranca e privacidade

O instalador nao coleta, nao transmite e nao armazena credenciais, tokens, senhas, chaves de API, informacoes de empresas ou clientes, caminhos pessoais, historico do Git, conversas ou backups. Nenhuma alteracao em permissoes do sistema ou credenciais existentes.

## Instalacao (Codex Desktop/CLI)

```powershell
git clone https://github.com/rafaelcaus/ai-dev-toolkit.git
cd ai-dev-toolkit
pwsh ./install.ps1
```

A previa e o padrao. Use -Apply para confirmar. Linux/macOS: ./install.sh

## Restauracao

```powershell
pwsh ./install.ps1 -RestoreBackup caminho-do-backup
```

## Versao atual

**v1.7** — base 3426959 da branch qa/codex-hardening-v1.7. Edicao publica em preparacao.

## Testes comprovados

Tres suites automatizadas passaram: instalador, previa completa e hooks escopados. Limitacao conhecida: fixtures sinteticas; nao comprovam integracao nativa com o Codex Desktop nem execucao real de subagentes.

## Licenca

Skills originais deste repositorio. Consulte LICENSE em cada skill de terceiros redistribuida.

---

Prompt pronto para instalar:

```
Instale o AI Dev Toolkit no meu perfil. Faca uma previa primeiro. Se estiver correto, aplique. Preserve minhas configuracoes existentes.
```
## Instalador universal

O instalador oferece um menu com seis opcoes:

1. Instalar no Codex
2. Instalar no Claude Code
3. Instalar no Lovable (MCP oficial)
4. Verificar atualizacoes
5. Restaurar backup
6. Desinstalar

### Instalacao no Codex
`pwsh ./install.ps1 -Target codex` — para aplicar, adicione `-Apply`.

### Instalacao no Claude Code
`pwsh ./install.ps1 -Target claude` — para aplicar, adicione `-Apply`.

### Instalacao no Lovable
`pwsh ./install.ps1 -Target lovable` — apresenta o fluxo MCP. A instalacao via MCP exige agente com acesso Lovable conectado pelo navegador (OAuth oficial). Alternativa manual: copie o conteudo de skills/ para o workspace Lovable.

### Verificar atualizacoes
`pwsh ./install.ps1 -Target updates` — compara commit local com origin/main.

### Restaurar backup
`pwsh ./install.ps1 -RestoreBackup caminho-do-backup`.

### Desinstalar
`pwsh ./install.ps1 -Uninstall` — remove apenas os componentes gerenciados pelo kit, com backup previo.