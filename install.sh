#!/usr/bin/env bash
# AI Dev Toolkit - instalador universal (POSIX)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

show_menu() {
  echo ""
  echo "=== AI DEV TOOLKIT - Instalador ==="
  echo "1 - Instalar no Codex"
  echo "2 - Instalar no Claude Code"
  echo "3 - Instalar no Lovable (MCP oficial)"
  echo "4 - Verificar atualizacoes"
  echo "5 - Restaurar backup"
  echo "6 - Desinstalar"
  read -rp "Escolha 1-6: " choice
  echo "$choice"
}

backup_path() {
  local path="$1" backupRoot="$2" base="$3"
  [ -e "$path" ] || return 0
  local rel="${path#$base}"
  rel="${rel#/}"
  local dest="$backupRoot/$rel"
  mkdir -p "$(dirname "$dest")"
  cp -r "$path" "$dest"
  echo "  backup: $rel"
}

install_codex() {
  local codex="${CODEX_HOME:-$HOME/.codex}"
  local agentsHome="$HOME/.agents"
  local backupRoot="$codex/backup-ai-dev-toolkit-$(date +%Y%m%d-%H%M%S)"
  local skills=$(find "$here/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)
  local agents=$(find "$here/agents" -maxdepth 1 -name ''*.toml'' | wc -l)
  if [ "${APPLY:-0}" != "1" ]; then
    echo "PREVIA — nada sera escrito."
    echo "  skills: $skills"
    echo "  agentes: $agents"
    echo "  destino skills: $codex/skills"
    echo "  destino agentes: $agentsHome"
    echo "Use APPLY=1 para confirmar."
    return
  fi
  mkdir -p "$backupRoot"
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    local dst="$codex/skills/$name"
    if [ -e "$dst" ]; then backup_path "$dst" "$backupRoot" "$codex"; rm -rf "$dst"; fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$s" "$dst"
    echo "  skill: $name"
  done
  mkdir -p "$agentsHome"
  for a in "$here/agents"/*.toml; do
    local name=$(basename "$a")
    local dst="$agentsHome/$name"
    if [ -e "$dst" ]; then backup_path "$dst" "$backupRoot" "$HOME"; fi
    cp "$a" "$dst"
    echo "  agente: ${name%.toml}"
  done
  echo "Instalado. Backup em $backupRoot"
}

install_claude() {
  local claudeHome="${CLAUDE_HOME:-$HOME/.claude}"
  local backupRoot="$claudeHome/backup-ai-dev-toolkit-$(date +%Y%m%d-%H%M%S)"
  local skills=$(find "$here/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)
  if [ "${APPLY:-0}" != "1" ]; then
    echo "PREVIA — nada sera escrito."
    echo "  skills: $skills"
    echo "  destino: $claudeHome/skills"
    echo "Use APPLY=1 para confirmar."
    return
  fi
  mkdir -p "$backupRoot"
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    local dst="$claudeHome/skills/$name"
    if [ -e "$dst" ]; then backup_path "$dst" "$backupRoot" "$claudeHome"; rm -rf "$dst"; fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$s" "$dst"
    echo "  skill Claude: $name"
  done
  echo "Instalado. Backup em $backupRoot"
}

install_lovable() {
  echo "Lovable MCP oficial: https://mcp.lovable.dev"
  echo "Este script nao abre navegador nem captura credenciais."
  echo "Solicite ao agente com acesso Lovable para listar workspaces, instalar skills via MCP e preservar configuracoes."
  echo "Alternativa manual: copie skills/ para o workspace conforme documentacao oficial."
}

check_updates() {
  git -C "$here" fetch --quiet origin || true
  local local_sha=$(git -C "$here" rev-parse HEAD)
  local remote_sha=$(git -C "$here" rev-parse origin/main)
  if [ "$local_sha" = "$remote_sha" ]; then
    echo "Voce ja esta atualizado."
  else
    echo "Nova versao disponivel. Use: git pull origin main"
  fi
}

restore() {
  local backup="$1"
  [ -d "$backup" ] || { echo "Backup nao encontrado: $backup"; exit 1; }
  find "$backup" -type f | while read -r f; do
    local rel="${f#$backup}"
    rel="${rel#/}"
    local target="$HOME/$rel"
    mkdir -p "$(dirname "$target")"
    cp "$f" "$target"
    echo "  restaurado: $rel"
  done
}

uninstall() {
  local codex="${CODEX_HOME:-$HOME/.codex}"
  local agentsHome="$HOME/.agents"
  local claudeHome="${CLAUDE_HOME:-$HOME/.claude}"
  local backupRoot="$codex/backup-ai-dev-toolkit-uninstall-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backupRoot"
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    for root in "$codex" "$claudeHome"; do
      local p="$root/skills/$name"
      if [ -e "$p" ]; then backup_path "$p" "$backupRoot" "$root"; rm -rf "$p"; fi
    done
  done
  for a in "$here/agents"/*.toml; do
    local name=$(basename "$a")
    local p="$agentsHome/$name"
    if [ -e "$p" ]; then backup_path "$p" "$backupRoot" "$HOME"; rm -f "$p"; fi
  done
  echo "Desinstalado."
}

case "${1:-}" in
  codex) install_codex ;;
  claude) install_claude ;;
  lovable) install_lovable ;;
  updates) check_updates ;;
  restore) shift; restore "$1" ;;
  uninstall) uninstall ;;
  *) 
    c=$(show_menu)
    case "$c" in
      1) install_codex ;;
      2) install_claude ;;
      3) install_lovable ;;
      4) check_updates ;;
      5) read -rp "Caminho do backup: " b; restore "$b" ;;
      6) uninstall ;;
      *) echo "Opcao invalida." ;;
    esac
    ;;
esac
