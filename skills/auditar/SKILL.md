---
name: auditar
description: "Ponto de entrada ''auditar'' do workflow de Rafael. Carregar e aplicar as skills: auditoria-final. Alias de nome curto; os identificadores reais permanecem inalterados."
---

# Alias ''auditar''

Este alias nao duplica conteudo. Ao ser acionado, carregue e siga integralmente as skills reais listadas abaixo (uma autoridade por etapa; sem coordenadores concorrentes):

- auditoria-final

Regras do workflow global em AGENTS.md (bloco WORKFLOW-GLOBAL-RAFAEL) continuam aplicaveis.


- Integracao com a skill meta: ao aprovar plano complexo, criar/ativar meta nativa (create_goal/get_goal/update_goal) conforme contrato em ~/.agents/skills/meta.
