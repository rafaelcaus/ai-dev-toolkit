#requires -Version 7.0
param(
    [switch]$Apply,
    [string]$RestoreBackup,
    [switch]$Uninstall,
    [string]$Target,
    [switch]$CheckUpdates,
    [switch]$Yes
)
$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function Show-Menu {
    Write-Host ""
    Write-Host "=== AI DEV TOOLKIT - Instalador Universal ==="
    Write-Host "1 - Instalar no Codex"
    Write-Host "2 - Instalar no Claude Code"
    Write-Host "3 - Instalar no Lovable (MCP oficial)"
    Write-Host "4 - Verificar atualizacoes"
    Write-Host "5 - Restaurar backup"
    Write-Host "6 - Desinstalar"
    return (Read-Host "Escolha 1-6")
}

function Get-HomeDir([string]$Target) {
    switch ($Target) {
        "codex"  { if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $destHome ".codex" } }
        "claude" { if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $destHome ".claude" } }
        default  { throw "Alvo invalido: $Target" }
    }
}

function Get-AgentsHome([string]$Target) {
    switch ($Target) {
        "codex"  { Join-Path $destHome ".agents" }
        "claude" { Join-Path (Get-HomeDir "claude") "agents" }
        default  { throw "Alvo invalido: $Target" }
    }
}

function Get-SkillsSource([string]$Target) {
    if ($Target -eq "claude") { return (Join-Path $here "skills") }
    return (Join-Path $here "skills")
}

function Get-AgentsSource([string]$Target) {
    if ($Target -eq "claude") { return (Join-Path $here "agents/claude") }
    return (Join-Path $here "agents")
}

function Compute-Hash([string]$Path) {
    if ((Get-Item -LiteralPath $Path).PSIsContainer) {
        $rows = @(Get-ChildItem -LiteralPath $Path -Recurse -File | Sort-Object FullName | ForEach-Object { ($_.FullName.Substring($Path.Length) + "=" + (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()) })
        $text = $rows -join [Environment]::NewLine
        $sha = [Security.Cryptography.SHA256]::Create()
        try { return ([BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($text))).Replace("-", "").ToLowerInvariant()) } finally { $sha.Dispose() }
    }
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}
function Write-Manifest([string]$ManifestPath, [hashtable]$Data) {
    $Data | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ManifestPath -Encoding UTF8
}

function Read-Manifest([string]$ManifestPath) {
    if (-not (Test-Path -LiteralPath $ManifestPath)) { return $null }
    Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json -AsHashtable
}

function Backup-Existing([string]$Target, [string]$BackupRoot) {
    $skillsSrc = Get-ChildItem (Get-SkillsSource $Target) -Directory
    $agentsSrc = @(Get-ChildItem (Get-AgentsSource $Target) -Filter "*.*")
    $destHome = Get-HomeDir $Target
    $agentsHome = Get-AgentsHome $Target
    $entries = @()
    foreach ($s in $skillsSrc) {
        $p = Join-Path $destHome ("skills/" + $s.Name)
        if (Test-Path -LiteralPath $p) {
            $rel = ("skills/" + $s.Name)
            $dest = Join-Path $BackupRoot $rel
            New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
            Copy-Item -LiteralPath $p -Destination $dest -Recurse -Force
            $entries += @{ path = $rel; hash = Compute-Hash $p }
        }
    }
    foreach ($a in $agentsSrc) {
        $p = Join-Path $agentsHome $a.Name
        if (Test-Path -LiteralPath $p) {
            $rel = $a.Name
            $dest = Join-Path $BackupRoot $rel
            New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
            Copy-Item -LiteralPath $p -Destination $dest -Force
            $entries += @{ path = $rel; hash = Compute-Hash $p }
        }
    }
    $manifest = @{
        timestamp = (Get-Date -Format "o")
        target    = $Target
        backup_of = $home
        entries   = $entries
    }
    $manifestPath = Join-Path $BackupRoot "MANIFEST.json"
    Write-Manifest $manifestPath $manifest
    Write-Host ("  backup: " + $entries.Count + " entradas registradas")
    return $manifest
}

function Install-Target([string]$Target) {
    if (-not $Apply) {
        $destHome = Get-HomeDir $Target
        $agentsHome = Get-AgentsHome $Target
        $skillsCount = (Get-ChildItem (Get-SkillsSource $Target) -Directory).Count
        $agentsCount = (Get-ChildItem (Get-AgentsSource $Target) -File).Count
        Write-Host "PREVIA - nada sera escrito."
        Write-Host ("  alvo: " + $Target)
        Write-Host ("  skills: " + $skillsCount)
        Write-Host ("  agentes: " + $agentsCount)
        Write-Host ("  destino skills: " + (Join-Path $destHome "skills"))
        Write-Host ("  destino agentes: " + $agentsHome)
        Write-Host "Use -Apply para confirmar."
        return
    }
    $destHome = Get-HomeDir $Target
    $agentsHome = Get-AgentsHome $Target
    $backupRoot = Join-Path $destHome ("backup-ai-dev-toolkit-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    New-Item -ItemType Directory -Force $backupRoot | Out-Null
    $manifest = Backup-Existing $Target $backupRoot
    $installed = @()
    New-Item -ItemType Directory -Force (Join-Path $destHome "skills") | Out-Null
    foreach ($s in (Get-ChildItem (Get-SkillsSource $Target) -Directory)) {
        $dst = Join-Path $destHome ("skills/" + $s.Name)
        if (Test-Path -LiteralPath $dst) { Remove-Item -LiteralPath $dst -Recurse -Force }
        Copy-Item -LiteralPath $s.FullName -Destination $dst -Recurse -Force
        $installed += ("skills/" + $s.Name)
        Write-Host ("  skill instalada: " + $s.Name)
    }
    New-Item -ItemType Directory -Force $agentsHome | Out-Null
    foreach ($a in (Get-ChildItem (Get-AgentsSource $Target) -File)) {
        $dst = Join-Path $agentsHome $a.Name
        if (Test-Path -LiteralPath $dst) { Remove-Item -LiteralPath $dst -Force }
        Copy-Item -LiteralPath $a.FullName -Destination $dst -Force
        $installed += $a.Name
        Write-Host ("  agente instalado: " + $a.BaseName)
    }
    $ownership = @{
        installed_by = "ai-dev-toolkit"
        version      = "1.7"
        timestamp    = (Get-Date -Format "o")
        target       = $Target
        files        = $installed
    }
    $ownershipPath = Join-Path $destHome "OWNERSHIP.json"
    $existing = Read-Manifest $ownershipPath
    if ($existing) {
        $existing.files = @($existing.files) + $installed | Select-Object -Unique
        $existing.timestamp = $ownership.timestamp
        $existing.version = $ownership.version
        Write-Manifest $ownershipPath $existing
    } else {
        Write-Manifest $ownershipPath $ownership
    }
    Write-Host ("Instalacao concluida. Backup em " + $backupRoot) -ForegroundColor Green
}

function Restore-FromBackup([string]$Backup, [string]$Target) {
    if (-not $Apply -and -not $Yes) {
        Write-Host "PREVIA de restauracao - nada sera escrito."
        Write-Host ("  backup: " + $Backup)
        if ($Target) { Write-Host ("  alvo: " + $Target) }
        Write-Host "Use -Apply para confirmar."
        return
    }
    if (-not (Test-Path -LiteralPath $Backup)) { throw "Backup nao encontrado: " + $Backup }
    $manifestPath = Join-Path $Backup "MANIFEST.json"
    $manifest = Read-Manifest $manifestPath
    if (-not $manifest) { throw "MANIFEST.json ausente ou invalido em " + $Backup }
    $restoreTarget = if ($Target) { $Target } else { $manifest.target }
    $destHome = Get-HomeDir $restoreTarget
    $agentsHome = Get-AgentsHome $restoreTarget
    foreach ($entry in $manifest.entries) {
        $rel = $entry.path
        if ($rel -like "skills/*") {
            $dst = Join-Path $destHome $rel
        } else {
            $dst = Join-Path $agentsHome $rel
        }
        $src = Join-Path $Backup $rel
        if (Test-Path -LiteralPath $src) {
            New-Item -ItemType Directory -Force (Split-Path -Parent $dst) | Out-Null
            if ((Get-Item $src).PSIsContainer) {
                if (Test-Path -LiteralPath $dst) { Remove-Item -LiteralPath $dst -Recurse -Force }
                Copy-Item -LiteralPath $src -Destination $dst -Recurse -Force
            } else {
                Copy-Item -LiteralPath $src -Destination $dst -Force
            }
            Write-Host ("  restaurado: " + $rel)
        } else {
            if (Test-Path -LiteralPath $dst) {
                Remove-Item -LiteralPath $dst -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host ("  removido (nao existia no backup): " + $rel)
            }
        }
    }
    $ownBk = Join-Path $Backup "OWNERSHIP.json"
    if (Test-Path -LiteralPath $ownBk) {
        Copy-Item -LiteralPath $ownBk -Destination (Join-Path $destHome "OWNERSHIP.json") -Force
        Write-Host "  OWNERSHIP.json restaurado"
    }
    Write-Host "Restauracao concluida." -ForegroundColor Green
}

function Uninstall-Target([string]$Target) {
    if (-not $Apply -and -not $Yes) {
        Write-Host "PREVIA de desinstalacao - nada sera escrito."
        Write-Host ("  alvo: " + $Target)
        Write-Host "Use -Apply para confirmar."
        return
    }
    $destHome = Get-HomeDir $Target
    $agentsHome = Get-AgentsHome $Target
    $ownershipPath = Join-Path $destHome "OWNERSHIP.json"
    $ownership = Read-Manifest $ownershipPath
    if (-not $ownership -or $ownership.installed_by -ne "ai-dev-toolkit") {
        Write-Host "Nenhum manifesto de propriedade encontrado. Nada a desinstalar de forma segura." -ForegroundColor Yellow
        return
    }
    $backupRoot = Join-Path $destHome ("backup-ai-dev-toolkit-uninstall-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    New-Item -ItemType Directory -Force $backupRoot | Out-Null
    $entries = @()
    foreach ($rel in $ownership.files) {
        $p = if ($rel -like "skills/*") { Join-Path $destHome $rel } else { Join-Path $agentsHome $rel }
        if (Test-Path -LiteralPath $p) {
            $dest = Join-Path $backupRoot $rel
            New-Item -ItemType Directory -Force (Split-Path -Parent $dest) | Out-Null
            Copy-Item -LiteralPath $p -Destination $dest -Recurse -Force
            $entries += @{ path = $rel; hash = Compute-Hash $p }
            Remove-Item -LiteralPath $p -Recurse -Force
            Write-Host ("  removido: " + $rel)
        }
    }
    $manifest = @{
        timestamp = (Get-Date -Format "o")
        target    = $Target
        action    = "uninstall"
        entries   = $entries
    }
    Write-Manifest (Join-Path $backupRoot "MANIFEST.json") $manifest
    Copy-Item -LiteralPath $ownershipPath -Destination (Join-Path $backupRoot "OWNERSHIP.json") -Force
    Remove-Item -LiteralPath $ownershipPath -Force
    Write-Host "Desinstalacao concluida. Backup disponivel para restauracao." -ForegroundColor Green
}

function Check-Updates {
    git -C $here fetch --quiet origin 2>$null
    $local  = git -C $here rev-parse HEAD
    $remote = git -C $here rev-parse origin/main
    if ($local -eq $remote) {
        Write-Host "Voce ja esta na versao mais recente." -ForegroundColor Green
    } else {
        Write-Host "Nova versao disponivel." -ForegroundColor Yellow
        Write-Host ("  local:  " + $local)
        Write-Host ("  remote: " + $remote)
        Write-Host "Para atualizar manualmente: git pull origin main"
        Write-Host "Este script NAO executa codigo remoto automaticamente."
    }
}

function Show-Lovable {
    Write-Host "Lovable MCP oficial: https://mcp.lovable.dev" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Este script nao abre navegador, nao captura credenciais e nao automatiza o MCP."
    Write-Host ""
    Write-Host "Fluxo recomendado via agente com MCP Lovable conectado:"
    Write-Host "  1. Listar workspaces disponiveis"
    Write-Host "  2. Selecionar workspace alvo (requer permissao de proprietario ou admin)"
    Write-Host "  3. Fazer backup das skills existentes no workspace"
    Write-Host "  4. Instalar as 16 skills genericas via create_workspace_skill"
    Write-Host "  5. Atualizar instrucoes globais via set_workspace_knowledge (preservando as existentes)"
    Write-Host "  6. Verificar a instalacao e apresentar resultado"
    Write-Host ""
    Write-Host "Alternativa manual:"
    Write-Host ("  git clone https://github.com/rafaelcaus/ai-dev-toolkit.git")
    Write-Host "  Copie o conteudo de skills/ para o workspace Lovable conforme documentacao oficial."
}

# Fluxo principal
if ($CheckUpdates) { Check-Updates; exit 0 }
if ($RestoreBackup) { Restore-FromBackup $RestoreBackup $Target; exit 0 }
if ($Uninstall) {
    if (-not $Target) { $Target = "codex" }
    Uninstall-Target $Target
    exit 0
}
if ($Target -in @("codex","claude")) { Install-Target $Target; exit 0 }
if ($Target -eq "lovable") { Show-Lovable; exit 0 }
if (-not $Target) {
    $c = Show-Menu
    switch ($c) {
        "1" { Install-Target "codex" }
        "2" { Install-Target "claude" }
        "3" { Show-Lovable }
        "4" { Check-Updates }
        "5" { $b = Read-Host "Caminho do backup"; $t = Read-Host "Alvo (codex/claude, ou vazio para detectar do MANIFEST)"; Restore-FromBackup $b $t }
        "6" { $t = Read-Host "Alvo (codex/claude)"; Uninstall-Target $t }
        default { Write-Host "Opcao invalida." -ForegroundColor Red }
    }
}
