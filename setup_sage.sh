#!/usr/bin/env bash

# ============================
# 1. Instalar Miniconda (silencioso)
# ============================
if ! command -v conda &> /dev/null; then
    echo "📦 Instalando Miniconda..."
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
    bash miniconda.sh -b -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    conda init bash
    source ~/.bashrc
else
    echo "✅ Miniconda já instalada."
fi

# ============================
# 2. Criar ambiente com Sage + Jupyter + bibliotecas úteis
# ============================
if ! conda env list | grep -q "^sage-env"; then
    echo "📦 Criando ambiente 'sage-env'..."
    conda create -y -n sage-env python=3.11 \
        sagemath \
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
# 3. Ativar ambiente
# ============================
echo "🔄 Ativando ambiente..."
source $HOME/miniconda/bin/activate sage-env

# ============================
# 4. Adicionar kernel no Jupyter/VS Code
# ============================
python -m ipykernel install --user --name=sage-env --display-name "Python (SageMath)"

echo ""
echo "✅ Ambiente SageMath pronto!"
echo "Abra o VS Code, selecione o kernel 'Python (SageMath)' e abra a pasta 'template-calculo-2'."
