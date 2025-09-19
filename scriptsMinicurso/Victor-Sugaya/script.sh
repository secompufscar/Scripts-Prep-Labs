# ==============================================================================
# Script de Instalação para o curso de Victor Sugaya
# Instala: Cheat Engine, dnSpyEx, Microsoft Powertoys
# ==============================================================================
$ErrorActionPreference = "Stop"
Write-Host ">>> Iniciando a instalacao para o curso de Victor Sugaya..."

# --- Verificacao de Privilegios e Preparacao ---
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Error "ERRO: Execute como Administrador."; exit 1; }
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) { Write-Host "Instalando Chocolatey..."; Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) }

# --- Funcoes de Verificacao ---
function Find-InstalledSoftware { param([string]$DisplayName, [string]$SoftwareName); $app = Get-ItemProperty @("HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*") -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "$DisplayName" }; if ($app) { Write-Host "✅ [SUCESSO] - $SoftwareName esta instalado." } else { Write-Host "❌ [FALHA]   - $SoftwareName NAO foi encontrado." } }
function Check-Path { param([string]$DirectoryPath, [string]$SoftwareName); if (Test-Path $DirectoryPath) { Write-Host "✅ [SUCESSO] - $SoftwareName foi encontrado em '$DirectoryPath'." } else { Write-Host "❌ [FALHA]   - $SoftwareName NAO foi encontrado em '$DirectoryPath'." } }

# --- Instalacao ---
Write-Host ">>> [PASSO 1/1] Instalando ferramentas..."
choco install cheatengine -y --no-progress
choco install powertoys -y --no-progress
Write-Host "Instalando dnSpyEx..."
$dnSpyDir = "C:\Program Files\dnSpyEx"
if (-not (Test-Path "$dnSpyDir\dnSpy.exe")) {
    $dnSpyUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.4.0/dnSpy-net-win64.zip"
    $dnSpyZip = "$env:TEMP\dnSpy.zip"; Invoke-WebRequest -Uri $dnSpyUrl -OutFile $dnSpyZip
    if (Test-Path $dnSpyDir) { Remove-Item $dnSpyDir -Recurse -Force }
    Expand-Archive -Path $dnSpyZip -DestinationPath $dnSpyDir; Remove-Item $dnSpyZip
    [System.Environment]::SetEnvironmentVariable('Path', [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ";$dnSpyDir", 'Machine')
} else { Write-Host "dnSpyEx ja parece estar instalado." }

# --- Verificacao ---
Write-Host ""
Write-Host "================= VERIFICACAO ================="
Find-InstalledSoftware "Cheat Engine*" "Cheat Engine"
Check-Path "C:\Program Files\dnSpyEx\dnSpy.exe" "dnSpyEx"
Find-InstalledSoftware "PowerToys*" "Microsoft PowerToys"
Write-Host "================================================="
Write-Host ">>> Instalacao concluida! REINICIE O COMPUTADOR para finalizar."
