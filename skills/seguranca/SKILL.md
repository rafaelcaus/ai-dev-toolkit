---
name: seguranca
description: Identificacao de APIs perigosas, configuracoes arriscadas e vulnerabilidades.
---

## Objetivo
Detectar e remediar vulnerabilidades de seguranca em codigo, configuracoes e dependencias.

## Quando ativar
- Revisao de seguranca solicitada
- Implementacao de autenticacao/autorizacao
- Manipulacao de dados sensiveis
- Configuracao de infraestrutura/servicos
- Uso de APIs externas ou integracoes

## Procedimento
1. Identifique superficies de ataque (inputs, endpoints, configs)
2. Verifique autenticacao e autorizacao
3. Valide sanitizacao de inputs e outputs
4. Cheque gestao de segredos (sem hardcoded)
5. Analise dependencias por CVEs conhecidos
6. Verifique configuracoes de CORS, CSP, headers
7. Avalie exposicao de dados sensiveis
8. Documente achados e recomendacoes

## Criterios de conclusao
- Superficies de ataque mapeadas
- Vulnerabilidades classificadas por severidade
- Remediacoes propostas ou aplicadas
- Sem segredos expostos ou hardcoded

## Erros comuns
- Confiar apenas em validacao client-side
- Logs com dados sensiveis
- Segredos em codigo ou variaveis de ambiente inseguras
- Ignorar principios de menor privilegio