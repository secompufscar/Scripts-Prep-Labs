# ==============================================================================
# Script de Verificacao de Softwares para Windows - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# Versao final com deteccao aprimorada.
# ==============================================================================

# --- Funcoes de Verificacao ---
function Check-Command {
    param (
        [string]$CommandName,
        [string]$SoftwareName
    )
    if (Get-Command $CommandName -ErrorAction SilentlyContinue) {
        Write-Host "[SUCESSO] - $SoftwareName ($CommandName) esta instalado."
        return $true
    } else {
        Write-Host "[FALHA]   - $SoftwareName ($CommandName) NAO esta instalado."
        return $false
    }
}

function Find-InstalledSoftware {
    param (
        [string]$DisplayName,
        [string]$SoftwareName
    )
    $uninstallPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    $app = Get-ItemProperty $uninstallPaths -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "$DisplayName" }
    
    if ($app) {
        Write-Host "[SUCESSO] - $SoftwareName esta instalado."
    } else {
        Write-Host "[FALHA]   - $SoftwareName NAO foi encontrado no registro de programas."
    }
}

Write-Host "======================================================"
Write-Host "    Iniciando Verificacao de Softwares Instalados     "
Write-Host "======================================================"
Write-Host ""

# --- Secao: Victor Sugaya ---
Write-Host "--- Secao: Victor Sugaya ---"
Find-InstalledSoftware "Cheat Engine*" "Cheat Engine"
if (Test-Path "C:\Program Files\dnSpyEx\dnSpy.exe") {
    Write-Host "[SUCESSO] - dnSpyEx foi encontrado em 'C:\Program Files\dnSpyEx'."
} else {
    Write-Host "[FALHA]   - dnSpyEx NAO foi encontrado em 'C:\Program Files\dnSpyEx'."
}
Find-InstalledSoftware "PowerToys*" "Microsoft PowerToys"
Write-Host ""

# --- Secao: Daniel Augusto Moschetto & Raphael Mantilha ---
Write-Host "--- Secao: Daniel Augusto Moschetto & Raphael Mantilha ---"
if (Check-Command "node" "Node.js") {
    Write-Host "       Versao: $(node -v)"
}
if (Check-Command "npm" "NPM") {
    Write-Host "       Versao: $(npm -v)"
}
if (Check-Command "python" "Python") {
    Write-Host "       Versao: $(python --version)"
}
Check-Command "code" "Visual Studio Code"
Write-Host ""

# --- Secao: M@U ---
Write-Host "--- Secao: M@U ---"
if (Check-Command "gcc" "Compilador GCC (C)") {
    Write-Host "       Versao: $(gcc --version | Select-Object -First 1)"
}
if (Check-Command "g++" "Compilador G++ (C++)") {
    Write-Host "       Versao: $(g++ --version | Select-Object -First 1)"
}
if (Check-Command "java" "Java (JDK)") {
    Write-Host "      Versao: $(java -version 2>&1 | Select-Object -First 1)"
}
Find-InstalledSoftware "Gedit" "Editor de texto Gedit"
Write-Host ""

# --- Secao: Magalu Cloud ---
Write-Host "--- Secao: Magalu Cloud ---"
if (Check-Command "mgc" "Magalu Cloud CLI") {
    Write-Host "       Versao: $(mgc --version | Select-Object -First 1)"
}
Write-Host ""

# --- Secao: Felipe Duarte (Podman & Docker) ---
Write-Host "--- Secao: Felipe Duarte (Podman & Docker) ---"
if (Get-Command podman -ErrorAction SilentlyContinue) {
    Write-Host "[SUCESSO] - O comando 'podman' esta instalado e disponivel."
    Write-Host "      Versao: $(podman -v)"
} else {
    Write-Host "[INFO]    - O comando 'podman' ainda nao esta disponivel."
    Write-Host "     ACAO: Abra o Podman Desktop uma vez para que ele seja configurado."
}
Find-InstalledSoftware "Podman Desktop" "Podman Desktop"
Write-Host ""

if (Check-Command "docker" "Docker") {
    Write-Host "       Versao: $(docker --version)"
    if (docker compose version 2>$null) {
        Write-Host "[SUCESSO] - Docker Compose (plugin) esta instalado."
        Write-Host "       Versao: $(docker compose version)"
    } else {
        Write-Host "[FALHA]   - Docker Compose (plugin) NAO esta instalado."
    }
}
Find-InstalledSoftware "Docker Desktop" "Docker Desktop"
Write-Host ""

Write-Host "======================================================"
Write-Host "                 Verificacao Concluida                "
Write-Host "======================================================"