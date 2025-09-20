#!/bin/bash
# ==============================================================================
# Script de Instalação para o minicurso da Magalu Cloud
# Instala: Magalu Cloud CLI (mgccli)
# ==============================================================================
set -e
echo ">>> Iniciando a instalacao da Magalu Cloud CLI..."

# --- Verificacao de Root e Preparacao ---
if [ "$EUID" -ne 0 ]; then echo "ERRO: Por favor, execute como root."; exit 1; fi
echo ">>> Atualizando pacotes..."
apt-get update
apt-get install -y curl gpg wget

# --- Funcoes de Verificacao ---
check_version() {
    if command -v "$1" &>/dev/null; then
        echo "✅ [SUCESSO] - $2 ($1) esta instalado."
        echo -n "      └── Versao: "
        "$1" --version 2>/dev/null | head -n 1
    else
        echo "❌ [FALHA] - $2 ($1) NAO esta instalado."
    fi
}

# --- Instalacao ---
echo ">>> [PASSO 1/1] Configurando o repositorio APT e instalando a Magalu Cloud CLI..."
# Download da chave de verificação
gpg --yes --keyserver keyserver.ubuntu.com --recv-keys 0C59E21A5CB00594 && gpg --export --armor 0C59E21A5CB00594 | gpg --dearmor -o /etc/apt/keyrings/magalu-archive-keyring.gpg

# Adiciona repositório APT na lista de repositórios
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/magalu-archive-keyring.gpg] https://packages.magalu.cloud/apt stable main" | tee /etc/apt/sources.list.d/magalu.list > /dev/null

# Instala a MGC CLI
apt-get update
apt-get install -y mgccli

# --- Verificacao ---
echo ""
echo "================= VERIFICACAO ================="
check_version "mgc" "Magalu Cloud CLI"
echo "================================================="
echo ">>> Instalacao concluida!"
echo "Lembre-se de reiniciar o terminal para o comando 'mgc' funcionar."
