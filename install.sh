#!/usr/bin/env bash
# AI Dev Toolkit - instalador universal (POSIX)
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
APPLY=0
UNINSTALL=0
RESTORE=""
TARGET=""
while [ $# -gt 0 ]; do
  case "$1" in
    --apply) APPLY=1; shift ;;
    --uninstall) UNINSTALL=1; shift ;;
    --restore) RESTORE="$2"; shift 2 ;;
    --target) TARGET="$2"; shift 2 ;;
    --help|-h) echo "Uso: ./install.sh [--target codex|claude|lovable] [--apply] [--uninstall] [--restore CAMINHO]"; exit 0 ;;
    *) echo "Argumento invalido: $1"; exit 1 ;;
  esac
done

get_home(){
  case "$1" in
    codex)  echo "${CODEX_HOME:-$HOME/.codex}" ;;
    claude) echo "${CLAUDE_HOME:-$HOME/.claude}" ;;
    *) echo "alvo invalido: $1" >&2; exit 1 ;;
  esac
}

get_agents_home(){
  case "$1" in
    codex)  if [ -n "${CODEX_HOME:-}" ]; then dirname "$CODEX_HOME" | xargs -I{} echo "{}/.agents"; else echo "$HOME/.agents"; fi ;;
    claude) echo "$(get_home claude)/agents" ;;
  esac
}

compute_hash(){
  if [ -d "$1" ]; then
    ( cd "$1" && find . -type f -print0 | sort -z | xargs -0 sha256sum | sha256sum | cut -d" " -f1 )
  else
    sha256sum "$1" | cut -d" " -f1
  fi
}

backup_existing(){
  local t="$1" broot="$2"
  local home agentsHome count=0
  home=$(get_home "$t"); agentsHome=$(get_agents_home "$t")
  local entries="[]"
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    local p="$home/skills/$name"
    if [ -e "$p" ]; then
      local dest="$broot/skills/$name"
      mkdir -p "$(dirname "$dest")"; cp -r "$p" "$dest"
      count=$((count+1))
    fi
  done
  local srcExt="toml"
  local srcDir="$here/agents"
  if [ "$t" = "claude" ]; then srcExt="md"; srcDir="$here/agents/claude"; fi
  for a in "$srcDir"/*.$srcExt; do
    [ -e "$a" ] || continue
    local name=$(basename "$a")
    local p="$agentsHome/$name"
    if [ -e "$p" ]; then
      mkdir -p "$broot"
      cp "$p" "$broot/$name"
      count=$((count+1))
    fi
  done
  cat > "$broot/MANIFEST.json" <<EOF
{"timestamp":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","target":"$t","entries_count":$count}
EOF
  echo "  backup: $count entradas registradas"
}

install_target(){
  local t="$1"
  local home agentsHome broot
  home=$(get_home "$t"); agentsHome=$(get_agents_home "$t")
  if [ "$APPLY" != "1" ]; then
    echo "PREVIA - nada sera escrito."
    echo "  alvo: $t"
    echo "  skills: $(find "$here/skills" -mindepth 1 -maxdepth 1 -type d | wc -l)"
    echo "  agentes: $(find "$here/agents" -maxdepth 1 -type f | wc -l)"
    echo "  destino skills: $home/skills"
    echo "  destino agentes: $agentsHome"
    echo "Use --apply para confirmar."
    return
  fi
  broot="$home/backup-ai-dev-toolkit-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$broot"
  backup_existing "$t" "$broot"
  local installed=()
  mkdir -p "$home/skills"
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    local dst="$home/skills/$name"
    rm -rf "$dst"; cp -r "$s" "$dst"
    installed+=("skills/$name")
    echo "  skill instalada: $name"
  done
  local srcExt="toml"
  local srcDir="$here/agents"
  if [ "$t" = "claude" ]; then srcExt="md"; srcDir="$here/agents/claude"; fi
  mkdir -p "$agentsHome"
  for a in "$srcDir"/*.$srcExt; do
    [ -e "$a" ] || continue
    local name=$(basename "$a")
    cp "$a" "$agentsHome/$name"
    installed+=("$name")
    echo "  agente instalado: ${name%.*}"
  done
  local ownership="$home/OWNERSHIP.json"
  if [ -e "$ownership" ]; then
    echo "OWNERSHIP.json ja existe; atualizando entradas (simplificado)" >&2
  fi
  cat > "$ownership" <<EOF
{"installed_by":"ai-dev-toolkit","version":"1.7.1","timestamp":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","target":"$t","files":[]}
EOF
  echo "Instalacao concluida. Backup em $broot"
}

uninstall_target(){
  local t="$1"
  local home agentsHome ownership
  home=$(get_home "$t"); agentsHome=$(get_agents_home "$t")
  ownership="$home/OWNERSHIP.json"
  if [ "$APPLY" != "1" ]; then
    echo "PREVIA de desinstalacao - nada sera escrito."
    echo "  alvo: $t"
    echo "Use --apply para confirmar."
    return
  fi
  if [ ! -e "$ownership" ]; then
    echo "Nenhum OWNERSHIP.json. Nada seguro a desinstalar." >&2; return 1
  fi
  local broot="$home/backup-ai-dev-toolkit-uninstall-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$broot"
  local count=0
  for s in "$here/skills"/*/; do
    local name=$(basename "$s")
    local p="$home/skills/$name"
    if [ -e "$p" ]; then
      mkdir -p "$broot/skills"
      cp -r "$p" "$broot/skills/"
      rm -rf "$p"
      count=$((count+1))
      echo "  removido: skills/$name"
    fi
  done
  local srcExt="toml"
  local srcDir="$here/agents"
  if [ "$t" = "claude" ]; then srcExt="md"; srcDir="$here/agents/claude"; fi
  for a in "$srcDir"/*.$srcExt; do
    [ -e "$a" ] || continue
    local name=$(basename "$a")
    local p="$agentsHome/$name"
    if [ -e "$p" ]; then
      cp "$p" "$broot/$name"
      rm -f "$p"
      echo "  removido: $name"
    fi
  done
  cp "$ownership" "$broot/OWNERSHIP.json"
  rm -f "$ownership"
  cat > "$broot/MANIFEST.json" <<EOF
{"timestamp":"$(date -u +%Y-%m-%dT%H:%M:%SZ)","target":"$t","action":"uninstall","entries_count":$count}
EOF
  echo "Desinstalacao concluida."
}

restore_backup(){
  local bk="$1" t="${2:-}"
  local home agentsHome
  if [ "$APPLY" != "1" ]; then
    echo "PREVIA de restauracao - nada sera escrito."
    echo "  backup: $bk"
    echo "Use --apply para confirmar."
    return
  fi
  [ -d "$bk" ] || { echo "Backup nao encontrado: $bk" >&2; exit 1; }
  # Derivar target do MANIFEST se t vazio
  if [ -z "$t" ] && [ -e "$bk/MANIFEST.json" ]; then
    t=$(grep -o '"target":"[^"]*"' "$bk/MANIFEST.json" | head -1 | cut -d'"' -f4)
  fi
  [ -z "$t" ] && t="codex"
  home=$(get_home "$t"); agentsHome=$(get_agents_home "$t")
  # Restaurar skills do backup
  if [ -d "$bk/skills" ]; then
    for s in "$bk/skills"/*/; do
      [ -e "$s" ] || continue
      local name=$(basename "$s")
      mkdir -p "$home/skills"
      rm -rf "$home/skills/$name"
      cp -r "$s" "$home/skills/$name"
      echo "  restaurado: skills/$name"
    done
  fi
  # Restaurar arquivos soltos (agentes, OWNERSHIP)
  for f in "$bk"/*; do
    [ -f "$f" ] || continue
    local name=$(basename "$f")
    case "$name" in
      MANIFEST.json|OWNERSHIP.json) cp "$f" "$home/$name"; echo "  restaurado: $name" ;;
      *.toml|*.md) cp "$f" "$agentsHome/$name" 2>/dev/null || true; echo "  restaurado: $name" ;;
    esac
  done
  echo "Restauracao concluida."
}

check_updates(){
  git -C "$here" fetch --quiet origin 2>/dev/null || true
  local local_sha remote_sha
  local_sha=$(git -C "$here" rev-parse HEAD)
  remote_sha=$(git -C "$here" rev-parse origin/main 2>/dev/null || echo "")
  if [ -z "$remote_sha" ]; then echo "Sem repositorio remoto acessivel." >&2; return 1; fi
  if [ "$local_sha" = "$remote_sha" ]; then
    echo "Voce ja esta na versao mais recente."
  else
    echo "Nova versao disponivel."
    echo "  local:  $local_sha"
    echo "  remote: $remote_sha"
    echo "Este script NAO executa codigo remoto automaticamente."
    echo "Para atualizar: git pull origin main"
  fi
}

show_lovable(){
  echo "Lovable MCP oficial: https://mcp.lovable.dev"
  echo ""
  echo "Este script nao abre navegador nem captura credenciais."
  echo "Fluxo recomendado via agente com MCP Lovable conectado:"
  echo "  1. Listar workspaces"
  echo "  2. Selecionar workspace (proprietario/admin)"
  echo "  3. Backup antes de sobrescrita"
  echo "  4. Instalar skills via create_workspace_skill"
  echo "  5. Atualizar instrucoes via set_workspace_knowledge"
  echo ""
  echo "Alternativa manual: copie skills/ para o workspace conforme documentacao oficial."
}

show_menu(){
  echo ""
  echo "=== AI DEV TOOLKIT - Instalador Universal ==="
  echo "1 - Instalar no Codex"
  echo "2 - Instalar no Claude Code"
  echo "3 - Instalar no Lovable (MCP oficial)"
  echo "4 - Verificar atualizacoes"
  echo "5 - Restaurar backup"
  echo "6 - Desinstalar"
  read -rp "Escolha 1-6: " choice
  echo "$choice"
}

# Fluxo principal
if [ -n "$RESTORE" ]; then
  restore_backup "$RESTORE" "$TARGET"
  exit 0
fi
if [ "$UNINSTALL" = "1" ]; then
  [ -z "$TARGET" ] && TARGET="codex"
  uninstall_target "$TARGET"
  exit 0
fi
if [ -n "$TARGET" ]; then
  case "$TARGET" in
    codex|claude) install_target "$TARGET" ;;
    lovable) show_lovable ;;
    *) echo "Alvo invalido: $TARGET"; exit 1 ;;
  esac
  exit 0
fi
show_menu
case "$choice" in
  1) install_target "codex" ;;
  2) install_target "claude" ;;
  3) show_lovable ;;
  4) check_updates ;;
  5) read -rp "Caminho do backup: " b; read -rp "Alvo (codex/claude ou vazio): " t; restore_backup "$b" "$t" ;;
  6) read -rp "Alvo (codex/claude): " t; uninstall_target "$t" ;;
  *) echo "Opcao invalida." ;;
esac
