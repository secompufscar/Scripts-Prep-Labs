# ==============================================================================
# Script de Instalação para o curso de Raphael Mantilha
# Instala: Python, Node.js, Visual Studio Code e Docker Desktop
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao para o curso de Raphael Mantilha..."

# --- Verificacao de Privilegios e Preparacao ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Error "ERRO: Execute como Administrador."; exit 1; }
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Host "Instalando Chocolatey..."; Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

# --- Funcoes de Verificacao ---
function Check-Command { param([string]$CommandName, [string]$SoftwareName); if (Get-Command $CommandName -ErrorAction SilentlyContinue) { Write-Host "✅ [SUCESSO] - $SoftwareName ($CommandName) esta instalado."; return $true } else { Write-Host "❌ [FALHA]   - $SoftwareName ($CommandName) NAO esta instalado."; return $false } }
function Find-InstalledSoftware { param([string]$DisplayName, [string]$SoftwareName); $app = Get-ItemProperty @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "$DisplayName" }; if ($app) { Write-Host "✅ [SUCESSO] - $SoftwareName esta instalado." } else { Write-Host "❌ [FALHA]   - $SoftwareName NAO foi encontrado." } }

# --- Instalacao ---
Write-Host ">>> [PASSO 1/4] Instalando Python 3.13.7..."
choco install python --version=3.13.7 -y --no-progress

Write-Host ">>> [PASSO 2/4] Instalando Node.js e NVM..."
choco install nvm -y --no-progress
# ATUALIZAÇÃO MANUAL DO AMBIENTE PARA NVM
$nvmHome = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'Machine'); $nvmSymlink = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'Machine')
if ($nvmHome -and $nvmSymlink) { $env:Path = "$nvmHome;$nvmSymlink;" + $env:Path; $env:NVM_HOME = $nvmHome; $env:NVM_SYMLINK = $nvmSymlink; nvm install lts; nvm use lts }

Write-Host ">>> [PASSO 3/4] Instalando Visual Studio Code..."
choco install vscode -y --no-progress

Write-Host ">>> [PASSO 4/4] Instalando Docker Desktop..."
choco install docker-desktop -y --no-progress

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
if (Check-Command "python" "Python") { Write-Host "      └── Versao: $(python --version)" }
if (Check-Command "node" "Node.js") { Write-Host "      └── Versao: $(node -v)" }
Check-Command "code" "Visual Studio Code"
if (Check-Command "docker" "Docker") { Write-Host "      └── Versao: $(docker --version)" }
Find-InstalledSoftware "Docker Desktop" "Docker Desktop"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida! REINICIE O COMPUTADOR para finalizar."
