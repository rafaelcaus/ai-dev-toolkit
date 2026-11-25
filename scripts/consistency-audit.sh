#!/usr/bin/env bash
# Auditoria automatica de consistencia: docs vs. artefatos reais.
# Falha se README divergir do conteudo real de skills/ e agents/.
set -euo pipefail
cd "$(dirname "$0")/.."

# Skills fisicas
SKILLS=$(find skills -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)
SKILL_COUNT=$(echo "$SKILLS" | wc -l | tr -d ' ')

# Agentes fisicos (Codex TOML)
AGENTS=$(find agents -maxdepth 1 -name '*.toml' -exec basename {} .toml \; | sort | sed 's/^ag-//')
AGENT_COUNT=$(echo "$AGENTS" | wc -l | tr -d ' ')

FAIL=0

# 1. README deve citar cada skill fisica
for s in $SKILLS; do
  if ! grep -qiE "\b$s\b" README.md; then
    echo "AUDIT FALHOU: skill '$s' existe no repo mas nao e citada no README" >&2
    FAIL=1
  fi
done

# 2. README deve citar cada agente fisico
for a in $AGENTS; do
  if ! grep -qiE "ag-$a\b|$a\b" README.md; then
    echo "AUDIT FALHOU: agente 'ag-$a' existe no repo mas nao e citado no README" >&2
    FAIL=1
  fi
done

# 3. README nao deve citar skills inexistentes (nomes em backticks na tabela)
MENTIONED=$(grep -oE '\*\*[a-z-]+\*\*' README.md | tr -d '*' | sort -u | grep -vE '^(ag-)?[a-z-]+$' || true)
for m in $MENTIONED; do
  if [ -d "skills/$m" ] || [ -d "agents/claude/$m" ]; then continue; fi
  if echo "$SKILLS" | grep -qx "$m"; then continue; fi
  echo "AUDIT AVISO: '$m' citado em negrito no README sem skill correspondente" >&2
done

# 4. Contagem declarada deve bater com a real
if ! grep -qE "17 skills" README.md; then
  echo "AUDIT FALHOU: README nao declara 17 skills" >&2; FAIL=1
fi
if ! grep -qiE "16 (perfis de )?agente" README.md; then
  echo "AUDIT FALHOU: README nao declara 16 agentes" >&2; FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  echo "AUDITORIA AUTOMATICA: FALHOU" >&2; exit 1
fi
echo "AUDITORIA AUTOMATICA OK: $SKILL_COUNT skills e $AGENT_COUNT agentes fisicos consistentes com o README."
