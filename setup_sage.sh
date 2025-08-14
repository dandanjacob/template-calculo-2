#!/usr/bin/env bash
set -e

# ============================
# 1. Instalar Miniconda (silencioso)
# ============================
if ! command -v conda &> /dev/null; then
    echo "📦 Instalando Miniconda..."
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
    bash Miniforge3-Linux-x86_64.sh -b -p $HOME/miniconda
else
    echo "✅ Miniconda já instalada."
fi

# Garantir que o Conda esteja no PATH e inicializado
export PATH="$HOME/miniconda/bin:$PATH"
source $HOME/miniconda/etc/profile.d/conda.sh

# ============================
# 2. Adicionar canal conda-forge
# ============================
conda config --add channels conda-forge
conda config --set channel_priority strict

# ============================
# 3. Criar ambiente Conda com Python + SageMath (biblioteca) + pacotes extras
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
# 4. Ativar ambiente
# ============================
echo "🔄 Ativando ambiente..."
conda activate sage-env

# ============================
# 5. Adicionar kernel Python (com Sage) ao Jupyter/VS Code
# ============================
python -m ipykernel install --user --name=sage-env --display-name "Python (SageMath)"

# ============================
# 6. Instalar SageMath portátil completo e registrar kernel nativo
# ============================
if [ ! -d "$HOME/sage" ]; then
    echo "📦 Baixando SageMath portátil..."
    wget -q --show-progress https://mirrors.mit.edu/sage/linux/64bit/sage-10.3-Ubuntu_22.04-x86_64.tar.bz2 -O /tmp/sage.tar.bz2
    echo "📦 Extraindo SageMath..."
    tar -xjf /tmp/sage.tar.bz2 -C $HOME
    mv $HOME/sage-10.3-Ubuntu_22.04-x86_64 $HOME/sage
else
    echo "✅ SageMath portátil já está em $HOME/sage"
fi

echo "🔄 Registrando kernel nativo SageMath..."
$HOME/sage/sage --jupyter kernel install --user --name=sagemath

# ============================
# 7. Mensagem final
# ============================
echo ""
echo "✅ Todos os ambientes prontos!"
echo ""
echo "📌 Agora no VS Code/Jupyter você verá o kernel: SageMath"

