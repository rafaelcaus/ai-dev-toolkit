#!/usr/bin/env bash
set -euo pipefail
MATRIX="${1:-TRACEABILITY_MATRIX.md}"
MIN_ROWS=10
if [ ! -f "$MATRIX" ]; then echo "GATE FALHOU: matriz nao encontrada" >&2; exit 1; fi
PHYSICAL_LINES=$(wc -l < "$MATRIX")
if [ "$PHYSICAL_LINES" -lt "$MIN_ROWS" ]; then echo "GATE FALHOU: apenas $PHYSICAL_LINES linhas fisicas (minimo $MIN_ROWS)" >&2; exit 1; fi
WIDE_LINE=$(awk -F'|' 'NF>100 {print NR; exit}' "$MATRIX")
if [ -n "$WIDE_LINE" ]; then echo "GATE FALHOU: linha $WIDE_LINE achatada" >&2; exit 1; fi
VALID_ROWS=$(awk -F'|' 'NF>=4 && $2 !~ /ID/ && $2 !~ /^[-: ]*$/ {c++} END {print c+0}' "$MATRIX")
if [ "$VALID_ROWS" -lt "$MIN_ROWS" ]; then echo "GATE FALHOU: apenas $VALID_ROWS requisitos validos" >&2; exit 1; fi
FAILED=$(awk -F'|' 'NF>=4 && $4 ~ /\xe2\x9d\x8c/ {c++} END {print c+0}' "$MATRIX")
if [ "$FAILED" -gt 0 ]; then
  echo "GATE FALHOU: $FAILED reprovado(s)" >&2
  awk -F'|' 'NF>=4 && $4 ~ /\xe2\x9d\x8c/ {gsub(/^[ \t]+|[ \t]+$/, "", $3); print " PENDENTE: " $3}' "$MATRIX" >&2
  exit 1
fi
echo "GATE OK: $VALID_ROWS requisitos validos, nenhum reprovado"
