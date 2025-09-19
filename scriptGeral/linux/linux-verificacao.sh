#!/bin/bash

# ==============================================================================
# Script de Verificacao de Softwares v4 (Final) - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# ==============================================================================

# --- Inicializacao Manual para Scripts Nao-Interativos ---
# Carrega o NVM para que os comandos node/npm fiquem disponiveis
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  . "$NVM_DIR/nvm.sh"
fi

# Carrega o Pyenv para que o python correto seja encontrado
export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi
# --- Fim da Inicializacao ---


# --- Funcoes de Verificacao ---

# Funcao para checar a existencia de um comando
check_command() {
    local command_name="$1"
    local software_name="$2"
    if command -v "$command_name" &> /dev/null; then
        echo "✅ [SUCESSO] - $software_name ($command_name) esta instalado."
        return 0
    else
        echo "❌ [FALHA]   - $software_name ($command_name) NAO esta instalado."
        return 1
    fi
}

# Funcao para checar a versao de um comando
check_version() {
    local command_name="$1"
    local software_name="$2"
    local version_arg="${3:---version}"
    if check_command "$command_name" "$software_name"; then
        echo -n "      └── Versao: "
        # Redireciona a saida de erro para /dev/null para comandos como 'java' que imprimem em stderr
        "$command_name" "$version_arg" 2>/dev/null | head -n 1
    fi
}

echo "======================================================"
echo "    Iniciando Verificacao de Softwares Instalados     "
echo "======================================================"
echo ""

# --- Daniel Augusto Moschetto ---
echo "--- Secao: Daniel Augusto Moschetto ---"
check_version "node" "Node.js"
check_version "npm" "NPM (Node Package Manager)"
check_command "code" "Visual Studio Code"
echo ""

# --- Raphael Mantilha ---
echo "--- Secao: Raphael Mantilha ---"
echo "Verificando a versao global do Python (gerenciada pelo pyenv)..."
if check_command "pyenv" "pyenv"; then
    CURRENT_PYTHON_VERSION=$(pyenv global)
    if [[ "$CURRENT_PYTHON_VERSION" == "3.13.7" ]]; then
        echo "✅ [SUCESSO] - Versao global do Python e 3.13.7, conforme esperado."
        check_version "python" "Python"
    else
        echo "⚠️  [AVISO]   - A versao global do Python e '$CURRENT_PYTHON_VERSION'. Para corrigir, rode: pyenv global 3.13.7"
    fi
else
    echo "❌ [FALHA]   - pyenv nao encontrado. Nao e possivel verificar a versao do Python."
fi
echo ""


# --- M@U ---
echo "--- Secao: M@U ---"
check_version "gcc" "Compilador GCC (C)"
check_version "g++" "Compilador G++ (C++)"
check_version "java" "Java (JDK)"
check_command "gedit" "Editor de texto Gedit"
echo ""

# --- Felipe Duarte ---
echo "--- Secao: Felipe Duarte ---"
check_version "podman" "Podman" "-v"
echo "Verificando o Podman Desktop (Flatpak)..."
if flatpak list | grep -q "io.podman_desktop.PodmanDesktop"; then
    echo "✅ [SUCESSO] - Podman Desktop esta instalado via Flatpak."
else
    echo "❌ [FALHA]   - Podman Desktop NAO esta instalado via Flatpak."
fi
echo ""

# --- Docker ---
echo "--- Secao: Docker ---"
check_version "docker" "Docker Engine"
# Verifica o plugin Docker Compose
if docker compose version &> /dev/null; then
    echo "✅ [SUCESSO] - Docker Compose (plugin) esta instalado."
    echo -n "      └── Versao: "
    docker compose version
else
    echo "❌ [FALHA]   - Docker Compose (plugin) NAO esta instalado."
fi
echo ""

# --- Magalu Cloud ---
echo "--- Secao: Magalu Cloud ---"
check_version "mgc" "Magalu Cloud CLI"
echo ""

# --- Outros ---
echo "--- Secao: Outros Softwares (nao instalaveis via script) ---"
echo "ℹ️  [INFO]    - Cheat Engine, dnSpyEx, Microsoft Powertoys sao para Windows."
echo ""


echo "======================================================"
echo "                 Verificacao Concluida                "
echo "======================================================"
