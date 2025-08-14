#!/usr/bin/env bash
set -uo pipefail
trap 'echo "❌ Erro na linha $LINENO: $BASH_COMMAND"; exit 1' ERR

# ============================
# 1. Detectar ou definir Miniconda
# ============================
if [ -x "./miniconda/bin/conda" ]; then
    MINICONDA_DIR="$(pwd)/miniconda"
elif [ -x "$HOME/miniconda/bin/conda" ]; then
    MINICONDA_DIR="$HOME/miniconda"
else
    MINICONDA_DIR="$HOME/miniconda"
fi

# ============================
# 2. Instalar Miniconda se não existir
# ============================
if [ ! -x "$MINICONDA_DIR/bin/conda" ]; then
    echo "📦 Instalando Miniconda em $MINICONDA_DIR ..."
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
    bash Miniforge3-Linux-x86_64.sh -b -p "$MINICONDA_DIR"
else
    echo "✅ Miniconda já instalada em $MINICONDA_DIR"
fi

# ============================
# 3. Inicializar conda
# ============================
export PATH="$MINICONDA_DIR/bin:$PATH"
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# ============================
# 4. Configurar conda-forge
# ============================
conda config --add channels conda-forge
conda config --set channel_priority strict

# ============================
# 5. Criar ambiente Conda com Python + SageMath + pacotes extras
# ============================
if ! conda env list | grep -q "^sage-env"; then
    echo "📦 Criando ambiente 'sage-env' com SageMath..."
    conda create -y -n sage-env python=3.12 \
        sage \
        sympy \
        numpy \
        pandas \
        matplotlib \
        jupyter \
        ipykernel \
        git
else
    echo "✅ Ambiente 'sage-env' já existe."
fi

# ============================
# 6. Ativar ambiente
# ============================
echo "🔄 Ativando ambiente..."
conda activate sage-env

# ============================
# 7. Registrar kernel Python (com Sage) no Jupyter
# ============================
python -m ipykernel install --user --name=sage-env --display-name "Python (SageMath)"

# ============================
# 8. Instalar SageMath portátil (somente Linux nativo)
# ============================
if [ "$(uname -r)" != *Microsoft* ]; then
    if [ ! -d "$HOME/sage" ]; then
        echo "📦 Baixando SageMath portátil..."

        MIRRORS=(
            "https://mirror.math.princeton.edu/pub/sage/linux/64bit/sage-10.3-Ubuntu_22.04-x86_64.tar.bz2"
            "https://mirrors.mit.edu/sage/linux/64bit/sage-10.3-Ubuntu_22.04-x86_64.tar.bz2"
        )

        SUCCESS=0
        for URL in "${MIRRORS[@]}"; do
            echo "🌐 Tentando mirror: $URL"
            if wget -c "$URL" -O /tmp/sage.tar.bz2; then
                echo "✅ Download concluído com sucesso!"
                SUCCESS=1
                break
            else
                echo "❌ Falha no download do mirror: $URL"
            fi
        done

        if [ $SUCCESS -ne 1 ]; then
            echo "❌ Todos os mirrors falharam. Não é possível continuar."
            exit 1
        fi

        echo "📦 Testando integridade do arquivo..."
        bzip2 -tvv /tmp/sage.tar.bz2

        echo "📦 Extraindo SageMath..."
        tar -xjf /tmp/sage.tar.bz2 -C "$HOME"
        mv "$HOME/sage-10.3-Ubuntu_22.04-x86_64" "$HOME/sage"
    else
        echo "✅ SageMath portátil já está em $HOME/sage"
    fi

    # Registrar kernel Sage
    if [ ! -f "$HOME/sage/sage" ]; then
        echo "❌ SageMath não encontrado, não é possível registrar kernel."
        exit 1
    fi

    echo "🔄 Registrando kernel nativo SageMath..."
    "$HOME/sage/sage" --jupyter kernel install --user --name=sagemath
else
    echo "⚠️ WSL detectado. Ignorando SageMath portátil (use Conda Sage)"
fi

# ============================
# 9. Mensagem final
# ============================
echo ""
echo "✅ Todos os ambientes prontos com sucesso!"
echo "📌 Agora no VS Code/Jupyter você verá os kernels: 'Python (SageMath)' e 'SageMath' (se Linux nativo)"
