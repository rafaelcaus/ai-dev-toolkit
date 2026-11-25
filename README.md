## AVISO — VERSAO EXPERIMENTAL

**Nao execute o instalador ate a conclusao da auditoria final.** Esta versao (1.7.1-experimental) corrige falhas identificadas na revisao anterior. O aviso sera removido apos validacao completa.

---

# AI Dev Toolkit

Kit de produtividade para desenvolvimento assistido por IA para Codex Desktop/CLI e Claude Code.

## O que e

Conjunto de **17 skills** e **16 perfis de agente** (formato TOML para Codex, Markdown YAML para Claude Code) que automatizam planejamento, execucao, correcao, teste, auditoria e revisao de codigo.

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
- Lovable: apenas instrucoes sobre o MCP oficial; sem automacao.
- Ciclo completo (instalar → reinstalar → desinstalar → restaurar) validado em Windows.

### Limitacoes conhecidas

- CI multiplataforma (Windows/Linux/macOS) incluido em `.github/workflows/ci.yml`; execucao depende do GitHub Actions.
- Integracao Lovable via MCP validada em ciclo unitario e instalacao em massa (17/17 skills) no workspace LOVABLE 0.
- Subagentes reais do Codex podem apresentar falha de transporte de payload em algumas sessoes; ver skill `agentes` para protocolo de diagnostico.
- Blocos intermediarios do Codex Desktop podem recolher apos conclusao; nenhuma configuracao nativa encontrada para manter sempre expandido (`conversationDetailMode = STEPS_COMMANDS` nao controla isso).
- install.sh testado sintaticamente (bash -n); execucao fisica em Linux/macOS pendente.

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

**v1.7.1-experimental** — commit ccaccbc. Aviso experimental sera removido apos validacao completa.

## Licenca

Skills originais deste repositorio. Consulte LICENSE em cada skill de terceiros redistribuida.
