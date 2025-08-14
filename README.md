# template-calculo-2

Para simplificar o desenvolvimento dos exercícios computacionais da Disciplina de Cálculo 2 - IMPA TECH

## Instruções Iniciais

Usando:

- GoogleColab para edição, versionamento e armazenamento de código em nuvem;
- SymPy em Jupyter Notebook Python;
- NÃO usa GitHub.

Orientações disponíveis [aqui](https://colab.research.google.com/drive/13ws9oL20oPFgBouHfnE10ujx-AahW9Di?usp=sharing).

## Instruções avançadas

Usando:

- VSCode para edição local de código.
- Git para versionamento de código.
- GitHub para armazenamento de código em nuvem.
- Sympy, Jupyter Notebook, Python, Sage, etc.

Para aqueles que desejam gerenciar o código direto pelo GitHub, segue um tutorial simples de como lidar com o problema frequente de reset de arquivos locais dos computadores do laboratório.
Fizemos um script que já prepara um ambiente com todas as ferramentas necessárias para que o aluno possa desenvolver as listas, mas algumas etapas de configuração ainda são necessárias

# 1. Execute o script

Abra um terminal do bash e execute

```bash
bash <(wget -qO- https://github.com/dandanjacob/template-calculo-2/setup_sage.sh)
```

Isso vai preparar o ambiente com as ferramentas neessárias.
Não feche o terminal, vamos precisar dele depois.

# 2. Configure o git local

O git configurado vai ser necessário para poder subir as modificações locais do código.

```bash
git config --global user.name "Nome do Aluno"
git config --global user.email "email@aluno.com"
```

# 3. Importar repositório

Se ainda não tiver um repositório para a disciplina, basta acessar sua conta do GitHub, clicar em `Repositório`, `Novo`, dar um nome, `Criar repositório`.
Agora, tendo o repositório clique em `Código`, `HTTPS` e copie o link.
Volte para o terminal do bash e execute

```bash
git clone LINK-COPIADO
```

Isso vai gerar um repositório local baseado no remoto que foi criado.
execute `ls` para listar todos os subdiretórios dentro do diretório atual em que está, lá vai ter uma pasta com o nome do seu repositório que acabou de criar no GitHub.
Acesse ele executando

```bash
cd NOME-DO-REPOSITORIO
```

e então

```bash
code .
```

para abrir o VSCode já dentro do seu repositório.
Sugiro manter o terminal aberto, ele vai ser útil depois.

Agora o ambiente está pronto pra uso! Mão na massa!

# 4. Salvar e subir as modificações

Depois do trabalho duro resolvendo os exercícios, podemos subir as modificações para o GitHub

**Importante:** Verifique se salvou (`Ctrl+S`) todos os arquivos.

Depois de salvar as modificações, precisamos adicionar elas ao versionamento do código:

```bash
git add .

git commit -m "MENSAGEM-DO-COMMIT"
```

Isso vai fazer com que as modificações locais que você fez sejam oficializadas como alterações de código dentro do histórico de versionamento, mas ainda é apenas local. Para subir as alterações pra versão do GitHub use

```bash
git push origin main
```

Agora o código atualizado está disponível no GitHub!
