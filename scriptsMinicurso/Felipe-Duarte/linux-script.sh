#!/bin/bash
# ==============================================================================
# Script de Instalação para o curso de Felipe Duarte
# Instala: Podman e Podman Desktop
# ==============================================================================
set -e
echo ">>> Iniciando a instalacao para o curso de Felipe Duarte..."

# --- Verificacao de Root e Preparacao ---
if [ "$EUID" -ne 0 ]; then echo "ERRO: Por favor, execute como root."; exit 1; fi
echo ">>> Atualizando pacotes..."
apt-get update
apt-get install -y podman flatpak

# --- Funcoes de Verificacao ---
check_version() { if command -v "$1" &>/dev/null; then echo -n "✅ [SUCESSO] - $2 ($1) esta instalado. Versao: "; "$1" -v 2>/dev/null | head -n 1; else echo "❌ [FALHA] - $2 ($1) NAO esta instalado."; fi; }
check_flatpak() { if flatpak list | grep -q "$1"; then echo "✅ [SUCESSO] - $2 esta instalado via Flatpak."; else echo "❌ [FALHA] - $2 NAO esta instalado via Flatpak."; fi; }

# --- Instalacao ---
echo ">>> [PASSO 1/1] Instalando Podman Desktop via Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.podman_desktop.PodmanDesktop

# --- Verificacao ---
echo ""
echo "================= VERIFICACAO ================="
check_version "podman" "Podman"
check_flatpak "io.podman_desktop.PodmanDesktop" "Podman Desktop"
echo "================================================="
echo ">>> Instalacao concluida!"
