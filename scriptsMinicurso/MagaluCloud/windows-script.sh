# ==============================================================================
# Script de Instalação para a Magalu Cloud CLI (Windows)
# Instala e verifica a CLI da Magalu Cloud.
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao da Magalu Cloud CLI..."

# --- Verificacao de Privilegios ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "ERRO: Este script precisa ser executado como Administrador."
    exit 1
}

# --- Funcoes de Verificacao ---
function Check-Command {
    param([string]$CommandName, [string]$SoftwareName)
    if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
        Write-Host "✅ [SUCESSO] - $SoftwareName ($CommandName) esta instalado."
        Write-Host "      └── Versao: $(& $CommandName --version | Select-Object -First 1)"
    } else {
        Write-Host "❌ [FALHA]   - $SoftwareName ($CommandName) NAO esta instalado."
    }
}

# --- Instalacao ---
Write-Host ">>> [PASSO 1/1] Instalando a Magalu Cloud CLI (mgccli)..."
$mgcDir = "C:\mgc"
if (-not (Test-Path "$mgcDir\mgc.exe")) {
    Write-Host "Buscando a URL da ultima versao da Magalu Cloud CLI..."
    $apiUrl = "https://api.github.com/repos/MagaluCloud/mgccli/releases/latest"
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl
    $asset = $releaseInfo.assets | Where-Object { $_.name -like "*windows_amd64.zip" }
    
    if (-not $asset) {
        Write-Error "Nao foi possivel encontrar o arquivo de download para a CLI da Magalu (windows-amd64)."
        exit 1
    }
    
    $mgcUrl = $asset.browser_download_url
    $mgcZip = "$env:TEMP\mgccli.zip"
    
    Write-Host "Baixando a CLI da Magalu Cloud de: $mgcUrl"
    Invoke-WebRequest -Uri $mgcUrl -OutFile $mgcZip
    
    if (-not (Test-Path $mgcDir)) {
        New-Item -Path $mgcDir -ItemType Directory
    }
    
    Write-Host "Extraindo arquivos..."
    Expand-Archive -Path $mgcZip -DestinationPath $mgcDir -Force
    
    Write-Host "Adicionando ao PATH do sistema..."
    # Adiciona ao PATH do usuario de forma persistente
    $currentUserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    [System.Environment]::SetEnvironmentVariable("Path", $currentUserPath + ";$mgcDir", "User")

    Remove-Item $mgcZip
} else {
    Write-Host "Magalu Cloud CLI ja parece estar instalada."
}

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
# Adiciona o diretorio ao PATH da sessao atual para a verificacao funcionar
$env:Path += ";$mgcDir"
Check-Command "mgc" "Magalu Cloud CLI"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida!"
Write-Host "REINICIE O TERMINAL para que o comando 'mgc' funcione em novas sessoes."
