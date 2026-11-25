---
name: design-system
description: Arquitetura de tokens de design, especificacao de componentes e geracao de slides com tokens consistentes.
---

# Design System

## Objetivo
Garantir design consistente em interfaces e apresentacoes usando tokens em tres camadas (primitivo, semantico, componente).

## Quando ativar
- Criacao ou manutencao de design tokens
- Construcao de componentes com tokens
- Geracao de apresentacoes com identidade visual
- Auditoria de consistencia visual

## Arquitetura
- Primitivos: valores brutos, nunca usar diretamente
- Semanticos: aliases por proposito (bg-surface, text-primary)
- Componente: tokens especificos por componente (btn-bg, card-radius)

## Procedimento
1. Leia assets/design-tokens.json como fonte unica de verdade
2. Gere CSS com node scripts/generate-tokens.cjs --config assets/design-tokens.json -o tokens.css
3. Valide componentes com node scripts/validate-tokens.cjs --dir src/
4. Para slides, importe assets/design-tokens.css e use apenas var()
5. Valide slides com python scripts/slide-token-validator.py

## Regras
- Nunca use hex cru em componentes — sempre tokens semanticos
- Todo semantico deriva de um primitivo
- Documente o proposito de cada token
- Slides devem importar design-tokens.css e usar var() exclusivamente

## Criterios de conclusao
- Tokens em tres camadas definidos
- CSS gerado e importado
- Componentes sem valores hardcoded
- Slides validados com var() apenas

## Erros comuns
- Usar primitivos diretamente
- Duplicar semanticos com valores diferentes
- Ignorar validacao em slides
- Hex cru em CSS