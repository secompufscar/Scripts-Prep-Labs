#!/bin/bash

# ==============================================================================
# Script de Instalação de Softwares - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# Versao final com limpeza profunda de versoes antigas do Docker.
# ==============================================================================

# Encerra o script imediatamente se um comando falhar.
set -e

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "ERRO: Por favor, execute este script como root (usando sudo)."
  exit 1
fi

# Detecta o usuário que chamou o sudo para instalar NVM e Pyenv no local correto
SUDO_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

echo ">>> Script executado como root, para o usuário: $SUDO_USER (Home: $USER_HOME)"

# --- 1. Atualização e Instalação de Pacotes do Sistema (APT) ---
echo ">>> [PASSO 1/7] Atualizando repositórios e instalando pacotes base via APT..."
apt-get update

apt-get install -y ca-certificates curl git build-essential default-jdk gedit podman flatpak wget gpg apt-transport-https \
libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm \
libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl

# --- 2. Instalação do Docker ---
echo ">>> [PASSO 2/7] Configurando o repositório e instalando o Docker..."

# ETAPA DE LIMPEZA PROFUNDA: Remove pacotes antigos ou conflitantes do Docker
echo "Removendo versoes antigas ou conflitantes do Docker..."
apt-get remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras docker.io docker-doc docker-compose podman-docker containerd runc docker-buildx || true

# Garante que os diretorios antigos sejam removidos
rm -rf /var/lib/docker
rm -rf /var/lib/containerd

# Adiciona a chave GPG oficial do Docker sem pedir confirmacao
install -m 0755 -d /etc/apt/keyrings
rm -f /etc/apt/keyrings/docker.gpg # Remove a chave antiga para evitar o prompt
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Adiciona o repositório do Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  bookworm stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Instala o Docker Engine e plugins
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker instalado com sucesso."

# Adiciona o usuario ao grupo docker para executar sem sudo
echo "Adicionando o usuário $SUDO_USER ao grupo 'docker'..."
usermod -aG docker $SUDO_USER


# --- 3. Instalação da Magalu Cloud CLI (via APT) ---
echo ">>> [PASSO 3/7] Configurando o repositório APT e instalando a Magalu Cloud CLI (mgccli)..."
# Download da chave de verificação
rm -f /etc/apt/keyrings/magalu-archive-keyring.gpg # Remove chave antiga para evitar prompt
gpg --yes --keyserver keyserver.ubuntu.com --recv-keys 0C59E21A5CB00594 && gpg --export --armor 0C59E21A5CB00594 | gpg --dearmor -o /etc/apt/keyrings/magalu-archive-keyring.gpg

# Adiciona repositório APT na lista de repositórios
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/magalu-archive-keyring.gpg] https://packages.magalu.cloud/apt stable main" | tee /etc/apt/sources.list.d/magalu.list > /dev/null

# Instala a MGC CLI
apt-get update
apt-get install -y mgccli
echo "Magalu Cloud CLI instalada com sucesso."

# --- 4. Instalação do Visual Studio Code ---
echo ">>> [PASSO 4/7] Instalando o Visual Studio Code..."
apt-get install -y code

# --- 5. Instalação do Podman Desktop ---
echo ">>> [PASSO 5/7] Configurando o Flatpak e instalando o Podman Desktop..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub io.podman_desktop.PodmanDesktop

# --- 6. Instalação de Ferramentas de Desenvolvimento (NVM e Pyenv) ---
echo ">>> [PASSO 6/7] Instalando NVM (Node.js) e Pyenv (Python) para o usuário $SUDO_USER..."

# Instala NVM (Node Version Manager) e a última versão LTS do Node
sudo -u "$SUDO_USER" bash <<'EOF'
set -e
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    echo "Instalando NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
echo "Instalando a versão LTS mais recente do Node.js..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'
EOF

# Instala Pyenv e a versão 3.13.7 do Python
sudo -u "$SUDO_USER" bash <<'EOF'
set -e
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if [ ! -d "$PYENV_ROOT" ]; then
    echo "Instalando Pyenv..."
    curl https://pyenv.run | bash
fi
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

if ! pyenv versions --bare | grep -q "^3.13.7$"; then
    echo "Instalando Python 3.13.7... (Este processo pode demorar varios minutos)"
    pyenv install 3.13.7
else
    echo "Python 3.13.7 já está instalado."
fi
pyenv global 3.13.7
EOF

# --- 7. Finalização e Instruções ---
echo ""
echo "================================================================================"
echo ">>> [PASSO 7/7] SCRIPT CONCLUÍDO COM SUCESSO!"
echo "================================================================================"
echo ""
echo "    TODOS OS SOFTWARES FORAM INSTALADOS E CONFIGURADOS AUTOMATICAMENTE."
echo ""
echo "    AÇÃO MANUAL NECESSÁRIA (APENAS UMA VEZ POR MÁQUINA):"
echo "    ----------------------------------------------------"
echo "    Para que os comandos 'nvm', 'node', 'pyenv', 'mgc' e 'docker' funcionem corretamente"
echo "    no seu terminal interativo, você PRECISA FECHAR ESTA JANELA E ABRIR UMA NOVA."
echo ""
echo "    A instalação da extensão Thunder Client no VS Code, deve ser feita manualmente:"
echo "    Abra o VS Code e procure a extensão e faça a instalação manual"
echo ""
echo "================================================================================"
