#!/bin/bash
# ==============================================================================
# Script de Instalação para o curso de Daniel Augusto Moschetto
# Instala: Node.js, NPM, Visual Studio Code
# ==============================================================================
set -e
echo ">>> Iniciando a instalacao para o curso de Daniel Augusto Moschetto..."

# --- Verificacao de Root e Preparacao ---
if [ "$EUID" -ne 0 ]; then echo "ERRO: Por favor, execute como root."; exit 1; fi
SUDO_USER=${SUDO_USER:-$(whoami)}
echo ">>> Atualizando pacotes..."
apt-get update
apt-get install -y curl wget gpg

# --- Funcoes de Verificacao ---
check_command() { if command -v "$1" &>/dev/null; then echo "✅ [SUCESSO] - $2 ($1) esta instalado."; else echo "❌ [FALHA] - $2 ($1) NAO esta instalado."; fi; }
check_version() { if command -v "$1" &>/dev/null; then echo -n "      └── Versao: "; "$1" --version 2>/dev/null | head -n 1; fi; }

# --- Instalacao ---
echo ">>> [PASSO 1/2] Instalando Node.js e NPM..."
sudo -u "$SUDO_USER" bash <<'EOF'
set -e
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts && nvm use --lts && nvm alias default 'lts/*'
EOF

echo ">>> [PASSO 2/2] Instalando o Visual Studio Code..."
# Adiciona o repositorio da Microsoft se nao existir
if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
    apt-get update
fi
apt-get install -y code

# --- Verificacao ---
echo ""
echo "================= VERIFICACAO ================="
export NVM_DIR="/home/$SUDO_USER/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
check_version "node" "Node.js"
check_version "npm" "NPM"
check_command "code" "Visual Studio Code"
echo "================================================="
echo "Lembre-se de reiniciar o terminal para os comandos funcionarem."
echo "E instale a extensao Thunder Client manualmente no VS Code." [cite: 10]
echo ">>> Instalacao concluida!"
