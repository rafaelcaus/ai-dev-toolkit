---
name: react
description: Otimizacoes de React e Next.js baseadas em engenharia da Vercel.
---

## Objetivo
Aplicar boas praticas de performance e manutenibilidade em aplicacoes React e Next.js.

## Quando ativar
- Desenvolvimento de componentes React
- Otimizacao de renderizacao e bundle
- Configurar Next.js (SSR, SSG, ISR)
- Revisao de codigo React/Next.js

## Procedimento
1. Use composicao de componentes sobre heranca
2. Memoize valores caros com useMemo/useCallback
3. Evite re-renders desnecessarios (React.memo, keys estaveis)
4. Prefira Server Components quando possivel (Next.js)
5. Otimize imagens (next/image) e fontes (next/font)
6. Code-split rotas e componentes pesados
7. Minimize JavaScript no cliente
8. Use Suspense para loading states

## Criterios de conclusao
- Componentes otimizados para renderizacao
- Bundle size dentro de limites aceitaveis
- Core Web Vitals atendidos
- Sem anti-padroes de React

## Erros comuns
- useEffect como substituto de derivacao de estado
- Keys instaveis em listas
- Importar bibliotecas inteiras sem tree-shaking
- Ignorar hydration mismatches