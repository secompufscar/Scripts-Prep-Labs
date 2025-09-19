# ==============================================================================
# Script de Instalação de Softwares para Windows - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# Versao final, forcando a reinstalacao de pacotes.
# ==============================================================================

# Define o script para parar imediatamente em caso de erro
$ErrorActionPreference = "Stop"

# --- Verificação de Privilégios ---
Write-Host "Verificando privilegios de Administrador..."
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "ERRO: Este script precisa ser executado como Administrador."
    exit 1
}

# --- 1. Instalação do Chocolatey ---
Write-Host ">>> [PASSO 1/6] Verificando e instalando o Chocolatey..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey nao encontrado. Instalando..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey ja esta instalado."
}

# --- 2. Instalação das Ferramentas de Victor Sugaya ---
Write-Host ">>> [PASSO 2/6] Instalando as ferramentas de Victor Sugaya..."
choco install cheatengine -y --no-progress --force # ADICIONADO --force
choco install powertoys -y --no-progress --force # ADICIONADO --force

# dnSpyEx (Download e Extração)
Write-Host "Instalando dnSpyEx..."
$dnSpyDir = "C:\Program Files\dnSpyEx"
if (-not (Test-Path "$dnSpyDir\dnSpy.exe")) {
    $dnSpyUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.4.0/dnSpy-net-win64.zip"
    $dnSpyZip = "$env:TEMP\dnSpy.zip"
    Invoke-WebRequest -Uri $dnSpyUrl -OutFile $dnSpyZip
    if (Test-Path $dnSpyDir) { Remove-Item $dnSpyDir -Recurse -Force }
    Expand-Archive -Path $dnSpyZip -DestinationPath $dnSpyDir
    Remove-Item $dnSpyZip
    $env:Path += ";$dnSpyDir"
    [System.Environment]::SetEnvironmentVariable('Path', [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ";$dnSpyDir", 'Machine')
} else {
    Write-Host "dnSpyEx ja parece estar instalado."
}

# --- 3. Instalação de Compiladores e Ferramentas Base ---
Write-Host ">>> [PASSO 3/6] Instalando compiladores e ferramentas base via Chocolatey..."
choco install mingw -y --no-progress --force # ADICIONADO --force
choco install openjdk -y --no-progress --force # ADICIONADO --force
choco install gedit -y --no-progress --force # ADICIONADO --force
choco install vscode -y --no-progress --force # ADICIONADO --force
choco install podman-desktop -y --no-progress --force # ADICIONADO --force
choco install docker-desktop -y --no-progress --force # ADICIONADO --force

# --- 4. Instalação da Magalu Cloud CLI ---
Write-Host ">>> [PASSO 4/6] Instalando a Magalu Cloud CLI (mgccli)..."
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
    [System.Environment]::SetEnvironmentVariable("Path", [System.Environment]::GetEnvironmentVariable("Path", "User") + ";$mgcDir", "User")

    Remove-Item $mgcZip
    Write-Host "Magalu Cloud CLI instalada com sucesso."
} else {
    Write-Host "Magalu Cloud CLI ja parece estar instalada."
}

# --- 5. Instalação do Python e Node.js ---
Write-Host ">>> [PASSO 5/6] Instalando Python e Node.js..."
choco install python --version=3.13.7 -y --no-progress --force # ADICIONADO --force
choco install nvm -y --no-progress --force # ADICIONADO --force

# ATUALIZAÇÃO MANUAL DO AMBIENTE PARA NVM
$nvmHome = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'Machine')
$nvmSymlink = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'Machine')
if ($nvmHome -and $nvmSymlink) {
    $env:Path = "$nvmHome;$nvmSymlink;" + $env:Path
    $env:NVM_HOME = $nvmHome
    $env:NVM_SYMLINK = $nvmSymlink
    Write-Host "PATH da sessao atualizado para encontrar o nvm."
    
    Write-Host "Instalando a versao LTS mais recente do Node.js..."
    nvm install lts
    nvm use lts
} else {
    Write-Warning "Variaveis de ambiente do NVM nao encontradas. A instalacao do Node.js pode falhar."
}

# --- 6. Finalização ---
Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ">>> [PASSO 6/6] SCRIPT CONCLUIDO COM SUCESSO!" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "   TODOS OS SOFTWARES FORAM INSTALADOS E CONFIGURADOS." -ForegroundColor Green
Write-Host ""
Write-Host "   ACAO MANUAL NECESSARIA:" -ForegroundColor Yellow
Write-Host "   -----------------------" -ForegroundColor Yellow
Write-Host "   E ALTAMENTE RECOMENDADO REINICIAR O COMPUTADOR para que todas as" -ForegroundColor Yellow
Write-Host "   variaveis de ambiente e PATHs sejam carregados corretamente." -ForegroundColor Yellow
Write-Host ""
Write-Host "   A instalacao da extensao Thunder Client no VS Code deve ser feita manually." -ForegroundColor Yellow
Write-Host ""