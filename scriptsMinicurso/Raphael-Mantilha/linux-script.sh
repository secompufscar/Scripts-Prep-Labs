#!/bin/bash
# ==============================================================================
# Script de Instalação para o curso de Raphael Mantilha
# Instala: Python (via pyenv), Node.js, Visual Studio Code e Docker
# ==============================================================================
set -e
echo ">>> Iniciando a instalacao para o curso de Raphael Mantilha..."

# --- Verificacao de Root e Preparacao ---
if [ "$EUID" -ne 0 ]; then echo "ERRO: Por favor, execute como root."; exit 1; fi
SUDO_USER=${SUDO_USER:-$(whoami)}
echo ">>> Atualizando pacotes e instalando dependencias..."
apt-get update
apt-get install -y ca-certificates curl git build-essential wget gpg libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl

# --- Funcoes de Verificacao ---
check_command() { if command -v "$1" &>/dev/null; then echo "✅ [SUCESSO] - $2 ($1) esta instalado."; else echo "❌ [FALHA] - $2 ($1) NAO esta instalado."; fi; }
check_version() { if command -v "$1" &>/dev/null; then echo -n "      └── Versao: "; "$1" --version 2>/dev/null | head -n 1; fi; }

# --- Instalacao ---
echo ">>> [PASSO 1/4] Instalando Python 3.13.7 via Pyenv..."
sudo -u "$SUDO_USER" bash <<'EOF'
set -e
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if [ ! -d "$PYENV_ROOT" ]; then curl https://pyenv.run | bash; fi
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
if ! pyenv versions --bare | grep -q "^3.13.7$"; then pyenv install 3.13.7; fi
pyenv global 3.13.7
EOF

echo ">>> [PASSO 2/4] Instalando Node.js e NPM..."
sudo -u "$SUDO_USER" bash <<'EOF'
set -e
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts && nvm use --lts && nvm alias default 'lts/*'
EOF

echo ">>> [PASSO 3/4] Instalando o Visual Studio Code..."
if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/microsoft.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
    apt-get update
fi
apt-get install -y code

echo ">>> [PASSO 4/4] Configurando o repositorio e instalando o Docker..."
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras docker.io docker-doc docker-compose podman-docker containerd runc docker-buildx || true
rm -rf /var/lib/docker && rm -rf /var/lib/containerd
install -m 0755 -d /etc/apt/keyrings
rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker $SUDO_USER

# --- Verificacao ---
echo ""
echo "================= VERIFICACAO ================="
export PYENV_ROOT="/home/$SUDO_USER/.pyenv"; export PATH="$PYENV_ROOT/bin:$PATH"; eval "$(pyenv init -)"
export NVM_DIR="/home/$SUDO_USER/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
check_version "python" "Python"
check_version "node" "Node.js"
check_command "code" "Visual Studio Code"
check_version "docker" "Docker Engine"
if docker compose version &> /dev/null; then echo "✅ [SUCESSO] - Docker Compose (plugin) esta instalado."; else echo "❌ [FALHA]   - Docker Compose (plugin) NAO esta instalado."; fi
echo "================================================="
echo "Lembre-se de reiniciar o terminal para os comandos funcionarem."
echo ">>> Instalacao concluida!"
