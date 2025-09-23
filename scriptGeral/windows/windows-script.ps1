# ==============================================================================
# Script de Instalação de Softwares para Windows - SECOMP XIII (Versão Final)
#
# Autor: Murilo de Miranda Silva
# Versão otimizada para evitar reinstalações e com saída de log limpa.
# ==============================================================================

# Define o script para parar imediatamente em caso de erro
$ErrorActionPreference = "Stop"

# --- Verificação de Privilégios ---
Write-Host "Verificando privilégios de Administrador..."
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "ERRO: Este script precisa ser executado como Administrador."
    exit 1
}

# --- Função para Instalar Pacotes Apenas se Necessário ---
function Install-ChocoPackage {
    param(
        [string]$PackageName,
        [string]$Version = ""
    )
    $localPackage = choco list --local-only --exact $PackageName | ForEach-Object { ($_ -split '\|')[0] }
    if ($localPackage -eq $PackageName) {
        Write-Host "Pacote '$PackageName' já está instalado. Pulando."
    } else {
        Write-Host "Instalando '$PackageName'..."
        if ($Version) {
            choco install $PackageName --version=$Version -y --no-progress
        } else {
            choco install $PackageName -y --no-progress
        }
    }
}

# --- 1. Instalação do Chocolatey ---
Write-Host ">>> [PASSO 1/6] Verificando e instalando o Chocolatey..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey não encontrado. Instalando..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey já está instalado."
}

# --- 2. Instalação das Ferramentas de Victor Sugaya ---
Write-Host ">>> [PASSO 2/6] Instalando as ferramentas de Victor Sugaya..."
Install-ChocoPackage "cheatengine"
Install-ChocoPackage "powertoys"

# dnSpyEx (Download e Extração)
$dnSpyDir = "C:\Program Files\dnSpyEx"
if (-not (Test-Path "$dnSpyDir\dnSpy.exe")) {
    Write-Host "Instalando dnSpyEx..."
    $dnSpyUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.4.0/dnSpy-net-win64.zip"
    $dnSpyZip = "$env:TEMP\dnSpy.zip"
    Invoke-WebRequest -Uri $dnSpyUrl -OutFile $dnSpyZip
    if (Test-Path $dnSpyDir) { Remove-Item $dnSpyDir -Recurse -Force -ErrorAction SilentlyContinue }
    Expand-Archive -Path $dnSpyZip -DestinationPath $dnSpyDir
    Remove-Item $dnSpyZip

    # Atualiza PATH da máquina e da sessão atual
    $currentMachinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    if ($currentMachinePath -notlike "$dnSpyDir") {
        [System.Environment]::SetEnvironmentVariable('Path', "$currentMachinePath;$dnSpyDir", 'Machine')
    }
    $env:Path = "$env:Path;$dnSpyDir"
} else {
    Write-Host "dnSpyEx já parece estar instalado."
}

# --- 3. Instalação de Compiladores e Ferramentas Base ---
Write-Host ">>> [PASSO 3/6] Instalando compiladores e ferramentas base..."
Install-ChocoPackage "mingw"
Install-ChocoPackage "openjdk"
Install-ChocoPackage "gedit"
Install-ChocoPackage "vscode"
Install-ChocoPackage "podman-cli"
Install-ChocoPackage "podman-desktop"
Install-ChocoPackage "docker-desktop"

# --- 4. Instalação da Magalu Cloud CLI ---
Write-Host ">>> [PASSO 4/6] Instalando a Magalu Cloud CLI (mgccli)..."
$mgcDir = "C:\mgc"
if (-not (Test-Path "$mgcDir\mgc.exe")) {
    Write-Host "Buscando a URL da última versão da Magalu Cloud CLI..."
    $apiUrl = "https://api.github.com/repos/MagaluCloud/mgccli/releases/latest"
    $releaseInfo = Invoke-RestMethod -Uri $apiUrl
    $asset = $releaseInfo.assets | Where-Object { $_.name -like "*windows_amd64.zip" }
    
    if (-not $asset) {
        Write-Error "Não foi possível encontrar o arquivo de download para a CLI da Magalu (windows-amd64)."
        exit 1
    }
    
    $mgcUrl = $asset.browser_download_url
    $mgcZip = "$env:TEMP\mgccli.zip"
    
    Write-Host "Baixando a CLI da Magalu Cloud de: $mgcUrl"
    Invoke-WebRequest -Uri $mgcUrl -OutFile $mgcZip
    
    if (Test-Path $mgcDir) { Remove-Item $mgcDir -Recurse -Force -ErrorAction SilentlyContinue }
    New-Item -Path $mgcDir -ItemType Directory -Force | Out-Null
    
    Write-Host "Extraindo arquivos..."
    Expand-Archive -Path $mgcZip -DestinationPath $mgcDir
    
    Write-Host "Adicionando ao PATH do sistema..."
    $currentMachinePath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    if ($currentMachinePath -notlike "$mgcDir") {
       [System.Environment]::SetEnvironmentVariable("Path", "$currentMachinePath;$mgcDir", "Machine")
    }

    # Atualiza PATH da sessão atual
    $env:Path = "$env:Path;$mgcDir"

    Remove-Item $mgcZip
    Write-Host "Magalu Cloud CLI instalada com sucesso."
} else {
    Write-Host "Magalu Cloud CLI já parece estar instalada."
}

# --- 5. Instalação do Python e Node.js ---
Write-Host ">>> [PASSO 5/6] Instalando Python e Node.js..."
$pythonVersion = "3.13.7"
Install-ChocoPackage "python" $pythonVersion
Install-ChocoPackage "nvm"

# ATUALIZAÇÃO DO AMBIENTE PARA NVM
$nvmHome = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'Machine')
$nvmSymlink = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'Machine')
if ($nvmHome -and $nvmSymlink) {
    $env:Path = "$nvmHome;$nvmSymlink;" + $env:Path
    $env:NVM_HOME = $nvmHome
    $env:NVM_SYMLINK = $nvmSymlink
    Write-Host "PATH da sessão atualizado para encontrar o nvm."
    
    Write-Host "Buscando a versão LTS mais recente do Node.js..."
    $nodeReleases = Invoke-RestMethod "https://nodejs.org/dist/index.json"
    $ltsVersion = ($nodeReleases | Where-Object { $_.lts } | Select-Object -First 1).version.TrimStart("v")

    Write-Host "Instalando Node.js versão LTS $ltsVersion..."
    nvm install $ltsVersion
    nvm use $ltsVersion
} else {
    Write-Warning "Variáveis de ambiente do NVM não encontradas. A instalação do Node.js pode falhar."
}

# Corrige conflito entre npm.ps1 e npm.cmd no PowerShell
$npmPs1 = Join-Path $env:NVM_SYMLINK "npm.ps1"
if (Test-Path $npmPs1) {
    Write-Host "Removendo wrapper npm.ps1 para evitar conflitos..."
    Remove-Item $npmPs1 -Force
}

# --- 6. Finalização ---
Write-Host ""
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ">>> [PASSO 6/6] SCRIPT CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "   TODOS OS SOFTWARES FORAM INSTALADOS E CONFIGURADOS." -ForegroundColor Green
Write-Host ""
Write-Host "   AÇÃO MANUAL NECESSÁRIA:" -ForegroundColor Yellow
Write-Host "   -----------------------" -ForegroundColor Yellow
Write-Host "   É ALTAMENTE RECOMENDADO REINICIAR O COMPUTADOR para que todas as" -ForegroundColor Yellow
Write-Host "   variáveis de ambiente e PATHs sejam carregados corretamente." -ForegroundColor Yellow
Write-Host ""
Write-Host "   A instalação da extensão Thunder Client no VS Code deve ser feita manualmente." -ForegroundColor Yellow
Write-Host ""
