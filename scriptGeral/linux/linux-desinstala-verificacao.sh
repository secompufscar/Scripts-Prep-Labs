#!/bin/bash

# ==============================================================================
# Script de Verificacao de DESINSTALACAO - SECOMP XIII
#
# Autor: Murilo de Miranda Silva
# Verifica se os softwares foram removidos com sucesso.
# ==============================================================================

# --- Funcoes de Verificacao ---

# Funcao para checar se um comando NAO existe
check_command_removed() {
    local command_name="$1"
    local software_name="$2"
    if command -v "$command_name" &> /dev/null; then
        echo "❌ [FALHA]   - $software_name ($command_name) AINDA esta instalado."
        return 1
    else
        echo "✅ [SUCESSO] - $software_name ($command_name) foi removido."
        return 0
    fi
}

# Funcao para checar se um diretorio NAO existe
check_dir_removed() {
    local dir_path="$1"
    local software_name="$2"
    if [ -d "$dir_path" ]; then
        echo "❌ [FALHA]   - O diretorio do $software_name ($dir_path) AINDA existe."
    else
        echo "✅ [SUCESSO] - O diretorio do $software_name foi removido."
    fi
}


echo "======================================================"
echo "    Iniciando Verificacao da Desinstalacao de Softwares     "
echo "======================================================"
echo ""

# --- Ferramentas de Usuario ---
echo "--- Secao: Ferramentas de Usuario ---"
check_command_removed "node" "Node.js"
check_command_removed "npm" "NPM"
check_command_removed "python" "Python (versao do pyenv)"
check_command_removed "pyenv" "Pyenv"
check_dir_removed "$HOME/.nvm" "NVM"
check_dir_removed "$HOME/.pyenv" "Pyenv"
echo ""

# --- Ferramentas de Sistema ---
echo "--- Secao: Ferramentas de Sistema ---"
check_command_removed "docker" "Docker Engine"
check_command_removed "mgc" "Magalu Cloud CLI"
check_command_removed "code" "Visual Studio Code"
check_command_removed "podman" "Podman"
check_command_removed "gcc" "Compilador GCC (C)"
check_command_removed "g++" "Compilador G++ (C++)"
check_command_removed "java" "Java (JDK)"
check_command_removed "gedit" "Editor de texto Gedit"
echo ""

# --- Verificacao de Repositorios ---
echo "--- Secao: Verificacao de Repositorios ---"
if [ -f "/etc/apt/sources.list.d/docker.list" ]; then
    echo "❌ [FALHA]   - Repositorio do Docker AINDA existe."
else
    echo "✅ [SUCESSO] - Repositorio do Docker foi removido."
fi
if [ -f "/etc/apt/sources.list.d/magalu.list" ]; then
    echo "❌ [FALHA]   - Repositorio da Magalu Cloud AINDA existe."
else
    echo "✅ [SUCESSO] - Repositorio da Magalu Cloud foi removido."
fi
if [ -f "/etc/apt/sources.list.d/vscode.list" ]; then
    echo "❌ [FALHA]   - Repositorio do VS Code AINDA existe."
else
    echo "✅ [SUCESSO] - Repositorio do VS Code foi removido."
fi
echo ""

echo "======================================================"
echo "                 Verificacao Concluida                "
echo "======================================================"
