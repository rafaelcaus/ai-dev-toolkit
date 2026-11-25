#!/usr/bin/env bash
# Auditoria automatica de consistencia: docs vs. artefatos reais.
# Uso: consistency-audit.sh [README] [SKILLS_DIR] [AGENTS_DIR] [EXPECT_SKILLS] [EXPECT_AGENTS] [--skip-readme-names]
set -euo pipefail
README="${1:-README.md}"
SKILLS_DIR="${2:-skills}"
AGENTS_DIR="${3:-agents}"
EXPECT_SKILLS="${4:-17}"
EXPECT_AGENTS="${5:-16}"
SKIP_NAMES=false
for arg in "$@"; do
  if [ "$arg" = "--skip-readme-names" ]; then SKIP_NAMES=true; fi
done
cd "$(dirname "$0")/.."

SKILLS=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort | grep -v '^\.system$' || true)
SKILL_COUNT=$(echo "$SKILLS" | grep -c . || echo 0)
AGENTS=$(find "$AGENTS_DIR" -maxdepth 1 -name '*.toml' -exec basename {} .toml \; | sort | sed 's/^ag-//' || true)
AGENT_COUNT=$(echo "$AGENTS" | grep -c . || echo 0)

FAIL=0

# Verificar nomes no README apenas se nao foi solicitado pular
if [ "$SKIP_NAMES" = "false" ]; then
  for s in $SKILLS; do
    if ! grep -qF "$s" "$README"; then
      echo "AUDIT FALHOU: skill '$s' existe em $SKILLS_DIR mas nao e citada em $README" >&2
      FAIL=1
    fi
  done
fi

# Contagens esperadas
if [ "$SKILL_COUNT" -ne "$EXPECT_SKILLS" ]; then
  echo "AUDIT FALHOU: esperadas $EXPECT_SKILLS skills, encontradas $SKILL_COUNT em $SKILLS_DIR" >&2
  FAIL=1
fi
if [ "$AGENT_COUNT" -ne "$EXPECT_AGENTS" ]; then
  echo "AUDIT FALHOU: esperados $EXPECT_AGENTS agentes, encontrados $AGENT_COUNT em $AGENTS_DIR" >&2
  FAIL=1
fi

if [ "$FAIL" -ne 0 ]; then
  echo "AUDITORIA AUTOMATICA: FALHOU" >&2; exit 1
fi
echo "AUDITORIA AUTOMATICA OK: $SKILL_COUNT skills e $AGENT_COUNT agentes fisicos consistentes com a documentacao."
