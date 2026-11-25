#requires -Version 7.0
param(
    [switch]$Apply,
    [string]$RestoreBackup,
    [switch]$Uninstall,
    [string]$Target
)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Show-Menu {
    Write-Host ""
    Write-Host "=== AI DEV TOOLKIT - Instalador ==="
    Write-Host "1 - Instalar no Codex"
    Write-Host "2 - Instalar no Claude Code"
    Write-Host "3 - Instalar no Lovable (MCP oficial)"
    Write-Host "4 - Verificar atualizacoes"
    Write-Host "5 - Restaurar backup"
    Write-Host "6 - Desinstalar"
    return (Read-Host "Escolha 1-6")
}

function Backup-Path([string]$Path,[string]$BackupRoot,[string]$Base) {
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $rel = $Path.Substring($Base.Length).TrimStart("/","\")
    $dest = Join-Path $BackupRoot $rel
    New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
    Copy-Item -LiteralPath $Path -Destination $dest -Recurse -Force
    Write-Host ("  backup: " + $rel)
}

function Install-Codex {
    $codex = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
    $agentsHome = Join-Path $HOME ".agents"
    $backupRoot = Join-Path $codex ("backup-ai-dev-toolkit-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    $skills = @(Get-ChildItem (Join-Path $here "skills") -Directory)
    $agents = @(Get-ChildItem (Join-Path $here "agents") -Filter "*.toml")
    if (-not $Apply) {
        Write-Host "PREVIA - nada sera escrito."
        Write-Host ("  skills: " + $skills.Count)
        Write-Host ("  agentes: " + $agents.Count)
        Write-Host ("  destino skills: " + (Join-Path $codex "skills"))
        Write-Host ("  destino agentes: " + $agentsHome)
        Write-Host "Use -Apply para confirmar."
        return
    }
    New-Item -ItemType Directory -Force $backupRoot | Out-Null
    foreach ($s in $skills) {
        $dst = Join-Path $codex ("skills/" + $s.Name)
        if (Test-Path -LiteralPath $dst) { Backup-Path $dst $backupRoot $codex; Remove-Item -LiteralPath $dst -Recurse -Force }
        New-Item -ItemType Directory -Force (Split-Path -Parent $dst) | Out-Null
        Copy-Item -LiteralPath $s.FullName -Destination $dst -Recurse -Force
        Write-Host ("  skill: " + $s.Name)
    }
    foreach ($a in $agents) {
        New-Item -ItemType Directory -Force $agentsHome | Out-Null
        $dst = Join-Path $agentsHome $a.Name
        if (Test-Path -LiteralPath $dst) { Backup-Path $dst $backupRoot $HOME }
        Copy-Item -LiteralPath $a.FullName -Destination $dst -Force
        Write-Host ("  agente: " + $a.BaseName)
    }
    Write-Host ("Instalado. Backup em " + $backupRoot)
}

function Install-Claude {
    $claudeHome = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME ".claude" }
    $backupRoot = Join-Path $claudeHome ("backup-ai-dev-toolkit-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    $skills = @(Get-ChildItem (Join-Path $here "skills") -Directory)
    if (-not $Apply) {
        Write-Host "PREVIA - nada sera escrito."
        Write-Host ("  skills: " + $skills.Count)
        Write-Host ("  destino: " + (Join-Path $claudeHome "skills"))
        Write-Host "Use -Apply para confirmar."
        return
    }
    New-Item -ItemType Directory -Force $backupRoot | Out-Null
    foreach ($s in $skills) {
        $dst = Join-Path $claudeHome ("skills/" + $s.Name)
        if (Test-Path -LiteralPath $dst) { Backup-Path $dst $backupRoot $claudeHome; Remove-Item -LiteralPath $dst -Recurse -Force }
        New-Item -ItemType Directory -Force (Split-Path -Parent $dst) | Out-Null
        Copy-Item -LiteralPath $s.FullName -Destination $dst -Recurse -Force
        Write-Host ("  skill Claude: " + $s.Name)
    }
    Write-Host ("Instalado. Backup em " + $backupRoot)
}

function Install-Lovable {
    Write-Host "Lovable MCP oficial: https://mcp.lovable.dev"
    Write-Host "Este script nao abre navegador nem captura credenciais."
    Write-Host "Para instalar via MCP, solicite ao agente com acesso Lovable:"
    Write-Host "  1. Listar workspaces"
    Write-Host "  2. Selecionar workspace alvo (requer proprietario/admin)"
    Write-Host "  3. Instalar as 16 skills via create_workspace_skill"
    Write-Host "  4. Atualizar instrucoes globais via set_workspace_knowledge"
    Write-Host "  5. Fazer backup antes de qualquer sobrescrita"
    Write-Host ""
    Write-Host "Alternativa manual:"
    Write-Host "  git clone https://github.com/rafaelcaus/ai-dev-toolkit.git"
    Write-Host "  copie skills/ para o workspace conforme documentacao oficial do Lovable."
}

function Check-Updates {
    git -C $here fetch --quiet origin 2>$null
    $local = git -C $here rev-parse HEAD
    $remote = git -C $here rev-parse origin/main
    if ($local -eq $remote) { Write-Host "Voce ja esta atualizado." }
    else { Write-Host "Nova versao disponivel. Use: git pull origin main" }
}

function Restore-FromBackup([string]$Backup) {
    if (-not (Test-Path -LiteralPath $Backup)) { throw "Backup nao encontrado: " + $Backup }
    Get-ChildItem -LiteralPath $Backup -Recurse -File | ForEach-Object {
        $rel = $_.FullName.Substring($Backup.Length).TrimStart("/","\")
        $target = Join-Path $HOME $rel
        New-Item -ItemType Directory -Force (Split-Path -Parent $target) | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $target -Force
        Write-Host ("  restaurado: " + $rel)
    }
}

function Uninstall-All {
    $codex = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
    $agentsHome = Join-Path $HOME ".agents"
    $claudeHome = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $HOME ".claude" }
    $backupRoot = Join-Path $codex ("backup-ai-dev-toolkit-uninstall-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    New-Item -ItemType Directory -Force $backupRoot | Out-Null
    foreach ($s in (Get-ChildItem (Join-Path $here "skills") -Directory)) {
        foreach ($root in @($codex,$claudeHome)) {
            $p = Join-Path $root ("skills/" + $s.Name)
            if (Test-Path -LiteralPath $p) { Backup-Path $p $backupRoot $root; Remove-Item -LiteralPath $p -Recurse -Force }
        }
    }
    foreach ($a in (Get-ChildItem (Join-Path $here "agents") -Filter "*.toml")) {
        $p = Join-Path $agentsHome $a.Name
        if (Test-Path -LiteralPath $p) { Backup-Path $p $backupRoot $HOME; Remove-Item -LiteralPath $p -Force }
    }
    Write-Host "Desinstalado."
}

if ($RestoreBackup) { Restore-FromBackup $RestoreBackup; exit 0 }
if ($Uninstall) { Uninstall-All; exit 0 }
if ($Target -eq "codex") { Install-Codex; exit 0 }
if ($Target -eq "claude") { Install-Claude; exit 0 }
if ($Target -eq "lovable") { Install-Lovable; exit 0 }
if (-not $Target) {
    $c = Show-Menu
    switch ($c) {
        "1" { Install-Codex }
        "2" { Install-Claude }
        "3" { Install-Lovable }
        "4" { Check-Updates }
        "5" { $b = Read-Host "Caminho do backup"; Restore-FromBackup $b }
        "6" { Uninstall-All }
        default { Write-Host "Opcao invalida." }
    }
}