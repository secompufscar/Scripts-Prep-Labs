# ==============================================================================
# Script de Instalação para o curso de Felipe Duarte
# Instala: Podman Desktop
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao para o curso de Felipe Duarte..."

# --- Verificacao de Privilegios e Preparacao ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Error "ERRO: Execute como Administrador."; exit 1; }
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Host "Instalando Chocolatey..."; Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

# --- Funcoes de Verificacao ---
function Find-InstalledSoftware { param([string]$DisplayName, [string]$SoftwareName); $app = Get-ItemProperty @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "$DisplayName" }; if ($app) { Write-Host "✅ [SUCESSO] - $SoftwareName esta instalado." } else { Write-Host "❌ [FALHA]   - $SoftwareName NAO foi encontrado." } }

# --- Instalacao ---
Write-Host ">>> [PASSO 1/1] Instalando Podman Desktop..."
choco install podman-desktop -y --no-progress

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
if (Get-Command podman -ErrorAction SilentlyContinue) { Write-Host "✅ [SUCESSO] - O comando 'podman' esta disponivel."; Write-Host "      └── Versao: $(podman -v)" } else { Write-Host "ℹ️  [INFO] - O comando 'podman' estara disponivel apos a primeira execucao do Podman Desktop."}
Find-InstalledSoftware "Podman Desktop" "Podman Desktop"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida! REINICIE O COMPUTADOR para finalizar."
