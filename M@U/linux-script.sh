#!/bin/bash
# ==============================================================================
# Script de Instalação para a Maratona de Programação (M@U)
# Instala: Compiladores (GCC, G++), Java (JDK) e Gedit
# ==============================================================================
set -e
echo ">>> Iniciando a instalacao para a Maratona de Programação..."

# --- Verificacao de Root e Preparacao ---
if [ "$EUID" -ne 0 ]; then echo "ERRO: Por favor, execute como root."; exit 1; fi
echo ">>> Atualizando pacotes..."
apt-get update

# --- Funcoes de Verificacao ---
check_command() { if command -v "$1" &>/dev/null; then echo "✅ [SUCESSO] - $2 ($1) esta instalado."; else echo "❌ [FALHA] - $2 ($1) NAO esta instalado."; fi; }
check_version() { if command -v "$1" &>/dev/null; then echo -n "      └── Versao: "; "$1" --version 2>/dev/null | head -n 1; fi; }

# --- Instalacao ---
echo ">>> [PASSO 1/1] Instalando pacotes..."
apt-get install -y build-essential default-jdk gedit

# --- Verificacao ---
echo ""
echo "================= VERIFICACAO ================="
check_version "gcc" "Compilador GCC (C)"
check_version "g++" "Compilador G++ (C++)"
check_version "java" "Java (JDK)"
check_command "gedit" "Editor de texto Gedit"
echo "================================================="
echo ">>> Instalacao concluida!"
