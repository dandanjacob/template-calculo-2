#!/usr/bin/env bash
set -uo pipefail
trap 'echo "❌ Erro na linha $LINENO: $BASH_COMMAND"' ERR

# ============================
# 1. Descobrir onde está o Miniconda
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
# 3. Garantir que estamos usando o conda certo
# ============================
export PATH="$MINICONDA_DIR/bin:$PATH"
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# ============================
# 4. Adicionar canal conda-forge
# ============================
conda config --add channels conda-forge || true
conda config --set channel_priority strict

# ============================
# 5. Criar ambiente Conda com Python + SageMath
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
# 7. Adicionar kernel Python (com Sage) ao Jupyter/VS Code
# ============================
python -m ipykernel install --user --name=sage-env --display-name "Python (SageMath)"

# ============================
# 8. Instalar SageMath portátil
# ============================
if [ ! -d "$HOME/sage" ]; then
    echo "📦 Baixando SageMath portátil..."
    wget -q --show-progress https://mirrors.mit.edu/sage/linux/64bit/sage-10.3-Ubuntu_22.04-x86_64.tar.bz2 -O /tmp/sage.tar.bz2
    echo "📦 Extraindo SageMath..."
    tar -xjf /tmp/sage.tar.bz2 -C "$HOME"
    mv "$HOME/sage-10.3-Ubuntu_22.04-x86_64" "$HOME/sage"
else
    echo "✅ SageMath portátil já está em $HOME/sage"
fi

echo "🔄 Registrando kernel nativo SageMath..."
"$HOME/sage/sage" --jupyter kernel install --user --name=sagemath

# ============================
# 9. Mensagem final
# ============================
echo ""
echo "✅ Todos os ambientes prontos!"
echo "📌 Agora no VS Code/Jupyter você verá o kernel: SageMath"
