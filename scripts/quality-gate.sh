#!/usr/bin/env bash
set -euo pipefail
MATRIX="${1:-TRACEABILITY_MATRIX.md}"
ALLOW_WARNINGS="${2:-}"
MIN_ROWS=20
if [ ! -f "$MATRIX" ]; then echo "GATE FALHOU: matriz nao encontrada" >&2; exit 1; fi
PHYSICAL_LINES=$(wc -l < "$MATRIX")
if [ "$PHYSICAL_LINES" -lt "$MIN_ROWS" ]; then echo "GATE FALHOU: apenas $PHYSICAL_LINES linhas fisicas (achatamento)" >&2; exit 1; fi
WIDE_LINE=$(awk -F'|' 'NF>100 {print NR; exit}' "$MATRIX")
if [ -n "$WIDE_LINE" ]; then echo "GATE FALHOU: linha $WIDE_LINE achatada" >&2; exit 1; fi
REQUIRED_ROWS=$(awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+[[:space:]]*$/ {c++} END {print c+0}' "$MATRIX")
if [ "$REQUIRED_ROWS" -lt "$MIN_ROWS" ]; then echo "GATE FALHOU: apenas $REQUIRED_ROWS requisitos com ID valido (minimo $MIN_ROWS)" >&2; exit 1; fi
REPROVED=$(awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $5 ~ /\xe2\x9d\x8c/) || ($2 !~ /^[[:space:]]*B/ && $4 ~ /\xe2\x9d\x8c/)) {c++} END {print c+0}' "$MATRIX")
if [ "$REPROVED" -gt 0 ]; then
  echo "GATE FALHOU: $REPROVED reprovado(s):" >&2
  awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $5 ~ /\xe2\x9d\x8c/) || ($2 !~ /^[[:space:]]*B/ && $4 ~ /\xe2\x9d\x8c/)) {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  REPROVADO: " $2}' "$MATRIX" >&2
  exit 1
fi
if [ "$ALLOW_WARNINGS" != "--allow-warnings" ]; then
  PARTIAL=$(awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $5 ~ /\xe2\x9a\xa0/) || ($2 !~ /^[[:space:]]*B/ && $4 ~ /\xe2\x9a\xa0/)) {c++} END {print c+0}' "$MATRIX")
  if [ "$PARTIAL" -gt 0 ]; then
    echo "GATE FALHOU: $PARTIAL parcial(is):" >&2
    awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $5 ~ /\xe2\x9a\xa0/) || ($2 !~ /^[[:space:]]*B/ && $4 ~ /\xe2\x9a\xa0/)) {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  PARCIAL: " $2}' "$MATRIX" >&2
    exit 1
  fi
fi
NO_EVIDENCE=$(awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $6 !~ /[^[:space:]]/) || ($2 !~ /^[[:space:]]*B/ && $5 !~ /[^[:space:]]/)) {c++} END {print c+0}' "$MATRIX")
if [ "$NO_EVIDENCE" -gt 0 ]; then
  echo "GATE FALHOU: $NO_EVIDENCE sem evidencia:" >&2
  awk -F'|' 'NF>=5 && $2 ~ /^[[:space:]]*(R|C|B)[0-9]+/ && (($2 ~ /^[[:space:]]*B/ && $6 !~ /[^[:space:]]/) || ($2 !~ /^[[:space:]]*B/ && $5 !~ /[^[:space:]]/)) {gsub(/^[ \t]+|[ \t]+$/, "", $2); print "  SEM EVIDENCIA: " $2}' "$MATRIX" >&2
  exit 1
fi
echo "GATE OK: $REQUIRED_ROWS requisitos com ID valido, 0 reprovados, evidencias presentes."
