# ==============================================================================
# Script de Instalação para a Maratona de Programação (M@U)
# Instala: Compiladores (GCC, G++), Java (JDK) e Gedit
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao para a Maratona de Programação..."

# --- Verificacao de Privilegios e Preparacao ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Error "ERRO: Execute como Administrador."; exit 1; }
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Host "Instalando Chocolatey..."; Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

# --- Funcoes de Verificacao ---
function Check-Command { param([string]$CommandName, [string]$SoftwareName); if (Get-Command $CommandName -ErrorAction SilentlyContinue) { Write-Host "✅ [SUCESSO] - $SoftwareName ($CommandName) esta instalado."; return $true } else { Write-Host "❌ [FALHA]   - $SoftwareName ($CommandName) NAO esta instalado."; return $false } }
function Find-InstalledSoftware { param([string]$DisplayName, [string]$SoftwareName); $app = Get-ItemProperty @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "$DisplayName" }; if ($app) { Write-Host "✅ [SUCESSO] - $SoftwareName esta instalado." } else { Write-Host "❌ [FALHA]   - $SoftwareName NAO foi encontrado." } }

# --- Instalacao ---
Write-Host ">>> [PASSO 1/1] Instalando pacotes..."
choco install mingw -y --no-progress
choco install openjdk -y --no-progress
choco install gedit -y --no-progress
choco install python --version=3.13.7 -y --no-progress

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
if (Check-Command "gcc" "Compilador GCC (C)") { Write-Host "      └── Versao: $(gcc --version | Select-Object -First 1)" }
if (Check-Command "g++" "Compilador G++ (C++)") { Write-Host "      └── Versao: $(g++ --version | Select-Object -First 1)" }
if (Check-Command "java" "Java (JDK)") { Write-Host "      └── Versao: $(java -version 2>&1 | Select-Object -First 1)" }
Find-InstalledSoftware "Gedit" "Editor de texto Gedit"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida! REINICIE O COMPUTADOR para finalizar."
