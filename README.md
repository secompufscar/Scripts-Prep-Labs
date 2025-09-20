# Scripts de Preparação de Ambiente para Laboratórios da SECOMP UFSCar 2025

Este repositório contém uma coleção de scripts para automatizar a instalação e configuração de todos os softwares necessários para os minicursos e laboratórios da **SECOMP UFSCar**. O objetivo é simplificar e agilizar a preparação do ambiente de desenvolvimento para os participantes, tanto em sistemas Linux (Debian/Ubuntu) quanto em Windows.

---

## 📂 Estrutura do Repositório

O repositório está organizado da seguinte forma:

* **/scriptGeral**: Contém os scripts que instalam, desinstalam e verificam **todos** os softwares de uma vez.
    * `/linux`: Scripts para sistemas baseados em Debian (Kali, Ubuntu, etc.).
    * `/windows`: Scripts para sistemas Windows (via PowerShell).
* **/scriptsMinicurso**: Contém scripts modulares e independentes, um para cada curso/instrutor. Use estes se você precisa apenas do software para um minicurso específico.
    * `/Daniel-Moschetto`: Focado em Node.js e VS Code.
    * `/Felipe-Duarte`: Focado em Podman e Podman Desktop.
    * `/MagaluCloud`: Focado na CLI da Magalu Cloud.
    * `/Raphael-Mantilha`: Focado em Python, Node.js, VS Code e Docker.
    * `/Victor-Sugaya`: Focado em ferramentas para Windows (Cheat Engine, PowerToys, etc.).
* **M@U**: Focado em compiladores para maratonas de programação (GCC, G++, Java, etc.) e documentações que serão utilizadas.


---

## 🚀 Como Usar

Escolha o script correspondente ao seu sistema operacional e à sua necessidade (geral ou específico de um minicurso).

### 🐧 Para Linux (Debian, Ubuntu, Kali, etc.)

1.  **Clone o Repositório:**
    ```bash
    git clone [https://github.com/secompufscar/Scripts-Prep-Labs.git](https://github.com/secompufscar/Scripts-Prep-Labs.git)
    cd Scripts-Prep-Labs
    ```

2.  **Navegue até a Pasta do Script Desejado:**
    ```bash
    # Exemplo para o script geral
    cd scriptGeral/linux
    ```
    
    ```bash
    # Exemplo para um script de minicurso
    cd scriptsMinicurso/Raphael-Mantilha
    ```

3.  **Dê Permissão de Execução ao Script:**
    ```bash
    chmod +x linux-script.sh
    ```

4.  **Execute o Script com `sudo`:**
    ```bash
    sudo ./linux-script.sh
    ```
    O script irá pedir a sua senha e cuidará de todo o resto.

5.  **Reinicie o Terminal:** Após a conclusão, feche e abra uma nova janela de terminal para que todos os comandos (`nvm`, `pyenv`, `docker`, `mgc`) fiquem disponíveis.

6.  **Dê Permissão de Execução ao Script de Verificação:**
    ```bash
    chmod +x linux-verificacao.sh
    ```
    
7. **Execute o Script de Verificação com `sudo`:**
    ```bash
    sudo ./linux-verificacao.sh
    

**Após isso os softwares estarão prontos para uso!**

---

### 🪟 Para Windows

1.  **Clone o Repositório ou Baixe o ZIP:**
    Você pode usar `git clone` se tiver o Git instalado, ou baixar o repositório como um arquivo ZIP e descompactá-lo.

2.  **Abra o PowerShell como Administrador:**
    * Clique no Menu Iniciar e digite `PowerShell`.
    * Clique com o botão direito em "Windows PowerShell" e selecione **"Executar como Administrador"**.

3.  **Navegue até a Pasta do Script Desejado:**
    Use o comando `cd` para entrar na pasta onde o script está. Exemplo:
    ```powershell
    # Exemplo para o script geral
    cd C:\caminho\para\Scripts-Prep-Labs\scriptGeral\windows
    
    # Exemplo para um script de minicurso
    cd C:\caminho\para\Scripts-Prep-Labs\scriptsMinicurso\Daniel-Moschetto
    ```

4.  **Permita a Execução de Scripts (apenas uma vez):**
    No terminal de Administrador, execute os seguintes comandos:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope Process -Force
    ```

    ```powershell
    powershell.exe -ExecutionPolicy Bypass -File ".\windows-script.ps1"
    ```

    ```powershell
    powershell.exe -ExecutionPolicy Bypass -File ".\windows-verificacao.ps1"
    ```

5.  **Execute o Script de Instalação:**
    ```powershell
    .\windows-script.ps1
    ```

6.  **Reinicie o Computador:** Após a instalação, é **altamente recomendado reiniciar o computador**. Isso garante que todos os programas e variáveis de ambiente sejam carregados corretamente.

7.  **Execute o Script de verificação:**
    ```powershell
    .\windows-verificacao.ps1
    ```

   **Após isso os softwares estarão prontos para uso!**

---

## 🛠️ Softwares Inclusos nos Scripts Gerais

| Categoria                | Software                        | SO       |
| ------------------------ | ------------------------------- | -------- |
| **Desenvolvimento Web** | Node.js (via NVM), NPM          | Ambos    |
| **Desenvolvimento Geral**| Python 3.13.7 (via Pyenv/Choco) | Ambos    |
|                          | Git                             | Ambos    |
|                          | VS Code                         | Ambos    |
| **Compiladores** | GCC, G++ (MinGW no Windows)     | Ambos    |
|                          | Java (OpenJDK)                  | Ambos    |
| **Contêineres** | Docker & Docker Desktop         | Ambos    |
|                          | Podman & Podman Desktop         | Ambos    |
| **Cloud** | Magalu Cloud CLI                | Ambos    |
| **Utilitários Windows** | Cheat Engine, dnSpyEx, PowerToys| Windows  |
| **Editores** | Gedit                           | Ambos    |
