#!/usr/bin/env bash
set -uo pipefail
trap 'echo "❌ Erro na linha $LINENO: $BASH_COMMAND"' ERR

# ============================
# 1. Garantir uso do Miniconda local
# ============================
export PATH="$HOME/miniconda/bin:$PATH"

# Função para inicializar conda
init_conda() {
    if [ -f "$HOME/miniconda/etc/profile.d/conda.sh" ]; then
        source "$HOME/miniconda/etc/profile.d/conda.sh"
    else
        echo "⚠️ Arquivo conda.sh não encontrado, verifique instalação do Miniconda."
        exit 1
    fi
}

# ============================
# 2. Instalar Miniconda (se não existir)
# ============================
if ! [ -x "$HOME/miniconda/bin/conda" ]; then
    echo "📦 Instalando Miniconda..."
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
    bash Miniforge3-Linux-x86_64.sh -b -p "$HOME/miniconda"
else
    echo "✅ Miniconda já instalada em $HOME/miniconda"
fi

# Inicializar conda
init_conda

# ============================
# 3. Configurar conda-forge
# ============================
conda config --add channels conda-forge || true
conda config --set channel_priority strict

# ============================
# 4. Criar ambiente Conda com Python + SageMath
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
# 5. Ativar ambiente
# ============================
echo "🔄 Ativando ambiente..."
conda activate sage-env

# ============================
# 6. Registrar kernel Python (com Sage) no Jupyter/VS Code
# ============================
python -m ipykernel install --user --name=sage-env --display-name "Python (SageMath)"

# ============================
# 7. Instalar SageMath portátil completo
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
# 8. Mensagem final
# ============================
echo ""
echo "✅ Todos os ambientes prontos!"
echo "📌 Agora no VS Code/Jupyter você verá os kernels: 'Python (SageMath)' e 'SageMath'"
