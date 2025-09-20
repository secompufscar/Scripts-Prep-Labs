#!/bin/bash

# ==============================================================================
# Script de Desinstalação de Softwares - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# Reverte as acoes do script de instalacao.
# ==============================================================================

# --- Verificacao de Root ---
if [ "$EUID" -ne 0 ]; then
  echo "ERRO: Por favor, execute este script como root (usando sudo)."
  exit 1
fi

# Detecta o usuário que chamou o sudo para remover configs de usuario
SUDO_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

echo ">>> Iniciando a desinstalacao completa dos softwares da SECOMP..."
echo ">>> Executando para o usuario: $SUDO_USER"

# --- 1. Desinstalacao de Ferramentas de Usuario (NVM e Pyenv) ---
echo ">>> [PASSO 1/5] Removendo NVM, Node.js, Pyenv e Python..."
if [ -d "$USER_HOME/.nvm" ]; then
    echo "Removendo NVM do diretorio $USER_HOME/.nvm..."
    rm -rf "$USER_HOME/.nvm"
fi
if [ -d "$USER_HOME/.pyenv" ]; then
    echo "Removendo Pyenv do diretorio $USER_HOME/.pyenv..."
    rm -rf "$USER_HOME/.pyenv"
fi

# Remove as configuracoes dos arquivos de shell do usuario
echo "Limpando arquivos de configuracao do shell (.bashrc e .zshrc)..."
sed -i '/NVM_DIR/d' "$USER_HOME/.bashrc" "$USER_HOME/.zshrc" 2>/dev/null || true
sed -i '/pyenv init/d' "$USER_HOME/.bashrc" "$USER_HOME/.zshrc" 2>/dev/null || true
sed -i '/PYENV_ROOT/d' "$USER_HOME/.bashrc" "$USER_HOME/.zshrc" 2>/dev/null || true

# --- 2. Desinstalacao do Podman Desktop ---
echo ">>> [PASSO 2/5] Removendo Podman Desktop..."
if flatpak list | grep -q "io.podman_desktop.PodmanDesktop"; then
    flatpak uninstall -y io.podman_desktop.PodmanDesktop
fi

# --- 3. Desinstalacao da Magalu Cloud CLI ---
echo ">>> [PASSO 3/5] Removendo a Magalu Cloud CLI e seu repositorio..."
apt-get remove --purge -y mgccli
rm -f /etc/apt/sources.list.d/magalu.list
rm -f /etc/apt/keyrings/magalu-archive-keyring.gpg

# --- 4. Desinstalacao do Docker ---
echo ">>> [PASSO 4/5] Removendo o Docker e seu repositorio..."
# Desinstala os pacotes
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Remove o repositorio e a chave
rm -f /etc/apt/sources.list.d/docker.list
rm -f /etc/apt/keyrings/docker.gpg
# Limpa os diretorios de dados
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
# Remove o usuario do grupo docker
if getent group docker > /dev/null; then
    echo "Removendo o usuario $SUDO_USER do grupo 'docker'..."
    gpasswd -d $SUDO_USER docker
fi

# --- 5. Desinstalacao dos Pacotes Base via APT ---
echo ">>> [PASSO 5/5] Removendo pacotes base..."
apt-get remove --purge -y default-jdk gedit podman flatpak
# VS Code e' removido junto com seu repositorio
apt-get remove --purge -y code
rm -f /etc/apt/sources.list.d/vscode.list
rm -f /etc/apt/keyrings/microsoft.gpg

echo "Limpando pacotes nao mais necessarios..."
apt-get autoremove -y

echo ""
echo "================================================================================"
echo ">>> DESINSTALACAO CONCLUIDA!"
echo "================================================================================"
echo ""
echo "    ACAO MANUAL NECESSARIA:"
echo "    -----------------------"
echo "    Para que as alteracoes tenham efeito completo, por favor, FECHE E REABRA SEU TERMINAL."
echo ""
