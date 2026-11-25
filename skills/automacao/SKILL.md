---
name: automacao
description: Acompanhamento automatico e supervisao continua de projetos, metas e trabalhos de longa duracao via Thread Automation/Heartbeat nativo e supervisor externo (Dot/Acessor).
---

# Automacao e Supervisao Continua

## Objetivo
Garantir que trabalhos de longa duracao tenham acompanhamento automatico e recuperacao autonoma sem depender de lembranca do usuario, preservando continuidade, transparência e ordem das prioridades.

## Quando ativar

Quando o usuario aprovar um plano complexo ou iniciar uma meta de longa duracao (multiplas fases, mais de uma sessao prevista, dependencias externas). Nao perguntar em tarefas pequenas ou unicas.

## Identificacao automatica

Ao aprovar plano complexo, oferecer via ferramenta nativa de perguntas (quando disponivel):

| Opcao | Funcionamento |
|-------|---------------|
| 1. Automacao interna | A propria conversa monitora e retoma via Heartbeat. |
| 2. Supervisor externo | Dot/Acessor acompanha, audita e orienta. |
| 3. Ambos (recomendado) | Codex executa, Dot supervisiona. |
| 4. Sem automacao | Execucao convencional. |

Sugestao padrao: a cada 1 hora, personalizavel.

Nao repetir a pergunta na mesma meta se a decisao ja estiver registrada em checkpoint/HANDOFF.

## Automacao interna (Thread Heartbeat)

Usar o mecanismo nativo `automation_update` do Codex App com `kind=heartbeat`, `destination=thread`, `targetThreadId` da conversa original.

A cada execucao:
1. Recuperar meta via get_goal, plano original e checkpoints.
2. Verificar progresso, pendencias e bloqueios.
3. Nao interromper execucao saudavel.
4. Se estagnado, investigar causa e retomar pelo proximo passo pendente.
5. Corrigir falhas comprovadas, executar testes.
6. Respeitar autorizacoes e prioridades.
7. Encerrar agendamento apos conclusao validada (status PAUSED ou delete).

## Supervisao externa (Dot/Acessor)

Supervisor independente acompanha a conversa original:
- Audita progresso, commits e testes.
- Identifica desvios e falhas.
- Envia orientacoes a conversa correta quando houver acesso comprovado.
- Evita conclusoes prematuras.
- Nao executa; orienta.

Versao particular do Rafael: ACESSOR como supervisor preferencial.
Versao publica: Dot disponivel de cada usuario.

## Comandos naturais suportados

- "Ative o acompanhamento"
- "Coloque meu Dot para supervisionar"
- "Monitore este plano de hora em hora"
- "Pause o acompanhamento"
- "-Retome a supervisao"
- "-Encerre a automacao"

## Coordenacao

- Evitar agendamentos duplicados: verificar se existe automacao ativa para a mesma meta antes de criar.
- Registrar no checkpoint: id da automacao, thread vinculada, frequencia, status, ultima execucao e resultado.
- Codex executa; Dot supervisiona; ambos preservam mesma meta e mesmos criterios.

## Transparencia operacional

Usar titulos somente para eventos reais:

### ⏰ AUTOMACAO ATIVADA
### 👁️ SUPERVISAO ATIVADA
### 🔄 RETOMADA AUTOMATICA
### 🚨 BLOQUEIO IDENTIFICADO
### ✅ AUTOMACAO CONCLUIDA

## Seguranca

- Nao simular agendamentos, acessos ou mensagens.
- Validar vinculo real entre automacao e conversa.
- Quando plataforma nao oferecer recurso nativo, fornecer alternativa suportada ou instrucao curta.
- Nao exigir servicos pagos adicionais.
- Nao contornar limites de utilizacao.
- Nao realizar acoes produtivas sem autorizacao.

## Criterios de conclusao

- Automacao ativa registrada com id verificavel (quando escolhida).
- Supervisor ativo com canal de comunicacao comprovado (quando escolhido).
- Meta avancando conforme plano.
- Pendencias reduzindo progressivamente.
- Eventos reais registrados com titulos operacionais.

## Erros comuns

- Criar automacao duplicada para mesma meta.
- Simular automacao sem registro real.
- Supervisor tentando executar em vez de orientar.
- Perguntar sobre automacao em tarefa pequena.
- Esquecer de encerrar agendamento apos conclusao.
- Nao registrar id/status da automacao no checkpoint.
