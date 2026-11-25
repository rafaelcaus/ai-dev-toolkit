---
name: meta
description: "Criar, ativar, acompanhar e concluir metas nativas profissionais (create_goal/update_goal/get_goal) automaticamente quando o usuário aprovar a execução integral de um plano complexo. Use ao aprovar plano, retomar meta, verificar status de meta ou concluir meta com evidências. Não usar para ideias, pedidos de planejamento ou aprovações visuais."
---

# Meta — contrato de execução nativa

## Contrato
Transformar a aprovação de execução de um plano complexo em uma **meta nativa ativa** quando as ferramentas reais estiverem disponíveis e autorizadas. Escrever sobre uma meta não equivale a ativá-la. Se indisponíveis, manter um marco operacional verificável, declarar a limitação e não alegar ativação nativa.

## Ativação automática
Quando o usuário aprovar a execução integral de um plano (ex.: "Aprovo o plano. Pode executar."):
1. Verificar se já existe meta correspondente (get_goal). Se existir e for do mesmo plano, reutilizar; não duplicar nem substituir metas de outros trabalhos.
2. Se não existir, criar com create_goal contendo: objetivo, referência ao plano aprovado (arquivo persistente com caminho e versão), obrigações de execução e critérios de conclusão.
3. Estrutura da meta (referência flexível 800–1500 caracteres, limite nativo 4000):
   - **PLANO:** referência ao arquivo persistente do plano aprovado (caminho, versão, matriz de requisitos).
   - **META:** objetivo, obrigações de execução e critérios de conclusão.
   - **SKILLS:** procedimentos especializados pertinentes.
   - **AGENTES:** especialistas responsáveis pelas tarefas.
   - **HOOKS:** mecanismos de continuidade e controle.
4. Confirmar que a meta foi criada e está ativa (get_goal). Não presuma sucesso sem retorno da ferramenta.
5. Não configurar token_budget sem solicitação explícita do usuário.

## Não é aprovação de execução
- Aprovação de ideia, pedido de planejamento ou aprovação exclusivamente visual NÃO autoriza criação de meta nem implementação.
- Se houver dúvida material sobre o que foi aprovado, usar Questions antes de criar a meta.

## Execução autônoma
Com a meta ativa:
- Continuar pelas etapas autorizadas sem aguardar pedidos de continuidade.
- Carregar skills pertinentes (planejar, executar, corrigir, testar, auditar, revisar, retomar) e usar delegação real quando disponível e útil; recorrer a procedimentos sequenciais somente quando a delegação estiver indisponível ou falhar, registrando a limitação.
- Preservar controle de estagnação (post-tool-monitor + stop-guard) e continuidade (STATE.json/HANDOFF).
- Reaproveitar evidências válidas; não repetir análises ou auditorias sem justificativa.
- Não criar metas menores concorrentes por etapa.
- Continuar tarefas independentes enquanto aguarda decisões via Questions.

## Continuidade
- Integrar ao STATE.json/HANDOFF existentes: identificação da conversa, projeto, tarefa, referência do plano, critérios, decisões, progresso, evidências, bloqueios e próxima ação.
- Após compactação ou nova sessão: reconciliar o estado da meta nativa (get_goal) com o registro persistente; não presumir que a meta migra automaticamente entre conversas.
- Não criar outro sistema concorrente de armazenamento.

## Critérios rígidos de conclusão
Antes de update_goal com status complete, conferir:
- Todos os requisitos obrigatórios do plano implementados.
- Testes aplicáveis aprovados (funcional, integração, regressão, segurança quando pertinentes).
- Validação funcional e visual quando pertinente.
- Auditoria do plano concluída.
- Auditoria global concluída.
- Falhas impeditivas corrigidas e revalidadas.
- Evidências vinculadas à versão examinada.
- Ausência de pendências obrigatórias solucionáveis.

Não marcar como concluída apenas porque o código foi escrito, o build passou ou uma etapa terminou. Bloqueios incontornáveis: usar update_goal com status blocked, preservando o trabalho e identificando a condição para retomada. Publicação é etapa separada e depende de autorização expressa via Questions; não marcar como publicada antes da autorização e comprovação.

## Integração com outras skills
- planejar: o plano aprovado é a fonte da meta (arquivo persistente com matriz de requisitos).
- executar: a meta orienta a execução por etapas verificáveis.
- auditar: auditoria do plano e global são requisitos de conclusão da meta.
- retomar: reconcilia meta nativa com STATE.json/HANDOFF ao retomar.


## Integração com Transparência

- Ao criar/atualizar metas, registre eventos com cabeçalhos ### 🎯 META ATIVADA / ✅ META CONCLUÍDA.
- Inclua critérios de conclusão verificáveis no registro operacional persistente.
- Após compactação, recupere estado da meta e reforce instruções de transparência.

## Integracao com Automacao

Ao criar meta de longa duracao, verificar se acompanhamento automatico e necessario. Se aprovado pelo usuario, usar a skill utomacao para configurar Heartbeat ou supervisor externo. Registrar id da automacao no checkpoint da meta.