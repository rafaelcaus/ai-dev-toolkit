#!/usr/bin/env bash
# Gate de qualidade: valida TRACEABILITY_MATRIX.md antes de permitir conclusao.
# Falha (exit 1) se existir requisito com status ❌ na coluna de status.
# Uso: ./scripts/quality-gate.sh [caminho-da-matriz]
set -euo pipefail
MATRIX="${1:-TRACEABILITY_MATRIX.md}"
if [ ! -f "$MATRIX" ]; then
 echo "GATE FALHOU: matriz nao encontrada: $MATRIX" >&2
 exit 1
fi
# Conta linhas de tabela onde a 3a coluna (status) contem ❌
# Formato: | ID | Requisito | STATUS | Evidencia | Commit |
# Usamos awk para extrair a 3a coluna e verificar se contem ❌
FAILED=$(awk -F'|' 'NF>=4 && $4 ~ /❌/ {count++} END {print count+0}' "$MATRIX")
if [ "$FAILED" -gt 0 ]; then
 echo "GATE FALHOU: $FAILED item(ns) com status NAO ATENDIDO na matriz." >&2
 awk -F'|' 'NF>=4 && $4 ~ /❌/ {gsub(/^[ \t]+|[ \t]+$/, "", $3); print " PENDENTE: " $3}' "$MATRIX" >&2
 echo "Conclusao BLOQUEADA ate os itens acima serem resolvidos com evidencia." >&2
 exit 1
fi
echo "GATE OK: nenhum item reprovado na matriz. Conclusao liberada para revisao independente."
