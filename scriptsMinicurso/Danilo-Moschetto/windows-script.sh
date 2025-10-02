# ==============================================================================
# Script de Instalação para o curso de Daniel Augusto Moschetto
# Instala: Node.js, NPM, Visual Studio Code
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao para o curso de Daniel Augusto Moschetto..."

# --- Verificacao de Privilegios e Preparacao ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Error "ERRO: Execute como Administrador."; exit 1; }
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Host "Instalando Chocolatey..."; Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

# --- Funcoes de Verificacao ---
function Check-Command { param([string]$CommandName, [string]$SoftwareName); if (Get-Command $CommandName -ErrorAction SilentlyContinue) { Write-Host "✅ [SUCESSO] - $SoftwareName ($CommandName) esta instalado."; return $true } else { Write-Host "❌ [FALHA]   - $SoftwareName ($CommandName) NAO esta instalado."; return $false } }

# --- Instalacao ---
Write-Host ">>> [PASSO 1/2] Instalando Node.js e NVM..."
choco install nvm -y --no-progress
# ATUALIZAÇÃO MANUAL DO AMBIENTE PARA NVM
$nvmHome = [System.Environment]::GetEnvironmentVariable('NVM_HOME', 'Machine'); $nvmSymlink = [System.Environment]::GetEnvironmentVariable('NVM_SYMLINK', 'Machine')
if ($nvmHome -and $nvmSymlink) { $env:Path = "$nvmHome;$nvmSymlink;" + $env:Path; $env:NVM_HOME = $nvmHome; $env:NVM_SYMLINK = $nvmSymlink; nvm install lts; nvm use lts }

Write-Host ">>> [PASSO 2/2] Instalando Visual Studio Code..."
choco install vscode -y --no-progress

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
if (Check-Command "node" "Node.js") { Write-Host "      └── Versao: $(node -v)" }
if (Check-Command "npm" "NPM") { Write-Host "      └── Versao: $(npm -v)" }
Check-Command "code" "Visual Studio Code"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida! REINICIE O COMPUTADOR para finalizar."
