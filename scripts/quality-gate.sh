#!/usr/bin/env bash
set -euo pipefail
MATRIX="${1:-TRACEABILITY_MATRIX.md}"
ALLOW_WARNINGS="${2:-}"
MIN_ROWS=20
if [ ! -f "$MATRIX" ]; then
  echo "GATE FALHOU: matriz nao encontrada: $MATRIX" >&2
  exit 1
fi
PHYSICAL_LINES=$(wc -l < "$MATRIX")
if [ "$PHYSICAL_LINES" -lt "$MIN_ROWS" ]; then
  echo "GATE FALHOU: apenas $PHYSICAL_LINES linhas fisicas (minimo $MIN_ROWS). Matriz achatada ou incompleta." >&2
  exit 1
fi
WIDE_LINE=$(awk -F'|' 'NF>100 {print NR; exit}' "$MATRIX")
if [ -n "$WIDE_LINE" ]; then
  echo "GATE FALHOU: linha fisica $WIDE_LINE tem mais de 100 colunas. Matriz achatada." >&2
  exit 1
fi
VALID_ROWS=$(awk -F'|' 'NF>=5 && $2 !~ /ID/ && $2 !~ /^[-: ]*$/ && $2 !~ /^$/ {c++} END {print c+0}' "$MATRIX")
if [ "$VALID_ROWS" -lt "$MIN_ROWS" ]; then
  echo "GATE FALHOU: apenas $VALID_ROWS requisitos validos (minimo $MIN_ROWS). Matriz vazia ou malformada." >&2
  exit 1
fi
REPROVED=$(awk -F'|' 'NF>=5 && $4 ~ /\xe2\x9d\x8c/ {c++} END {print c+0}' "$MATRIX")
PARTIAL=$(awk -F'|' 'NF>=5 && $4 ~ /\xe2\x9a\xa0/ {c++} END {print c+0}' "$MATRIX")
if [ "$REPROVED" -gt 0 ]; then
  echo "GATE FALHOU: $REPROVED requisito(s) REPROVADO(S) na matriz:" >&2
  awk -F'|' 'NF>=5 && $4 ~ /\xe2\x9d\x8c/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  REPROVADO: " $2}' "$MATRIX" >&2
  exit 1
fi
if [ "$ALLOW_WARNINGS" != "--allow-warnings" ] && [ "$PARTIAL" -gt 0 ]; then
  echo "GATE FALHOU: $PARTIAL requisito(s) PARCIAL(IAIS) na matriz (estado ?? bloqueia conclusao):" >&2
  awk -F'|' 'NF>=5 && $4 ~ /\xe2\x9a\xa0/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  PARCIAL: " $2}' "$MATRIX" >&2
  echo "Conclusao BLOQUEADA. Resolva os itens acima com evidencia verificavel." >&2
  exit 1
fi
NO_EVIDENCE=$(awk -F'|' 'NF>=5 && $2 !~ /ID/ && $5 !~ /./ {c++} END {print c+0}' "$MATRIX")
if [ "$NO_EVIDENCE" -gt 0 ]; then
  echo "GATE FALHOU: $NO_EVIDENCE requisito(s) sem evidencia:" >&2
  awk -F'|' 'NF>=5 && $2 !~ /ID/ && $5 !~ /./ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  SEM EVIDENCIA: " $2}' "$MATRIX" >&2
  exit 1
fi
echo "GATE OK: $VALID_ROWS requisitos validos, 0 reprovados, 0 parciais, todas as evidencias presentes."
