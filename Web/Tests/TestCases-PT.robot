*** Settings ***
Resource         ../Resource/Resource-PT.robot
Test Setup       Abrir navegador
Test Teardown    Fechar navegador

### SETUP executa keyword antes da suite ou antes de um teste
### TEARDOWN executa keyword depois de uma suite ou de um teste

*** Test Case ***
Caso de Teste 01: Pesquisar produto existente
    Acessar a página home do site
    Digitar o nome do produto "Blouse" no campo de pesquisa
    Clicar no botão pesquisar
    Conferir se o produto "Blouse" foi listado no site

Caso de Teste 02: Pesquisar produto não existente
    Acessar a página home do site
    Digitar o nome do produto "produtoNãoExistente" no campo de pesquisa
    Clicar no botão pesquisar
    Conferir mensagem "No results were found for your search "produtoNãoExistente""

Caso de Teste 03: Listar produtos
    Acessar a página home do site
    Passar o mouse por cima da categoria "Women" no menu principal superior de categorias
    Clicar na subcategoria "Summer Dresses"
    Conferir se os produtos da subcategoria "Summer Dresses" foram mostrados na página

Caso de Teste 04: Adicionar produtos no carrinho
    Acessar a página home do site  
    Digitar o nome do produto "t-shirt" no campo de pesquisa
    Clicar no botão pesquisar
    Clicar no botão "Add to cart" do produto
    Clicar no botão "Proceed to checkout"
    Conferir se o produto "t-shirt" foi adicionado ao carrinho com os respectivos dados e valores

Caso de Teste 05: Remover produtos
    Acessar a página home do site  
    Adicionar o produto "t-shirt" no carrinho
    Excluir o produto do carrinho
    Conferir se o carrinho fica vazio

Caso de Teste 06: Adicionar cliente
    Acessar a página home do site  
    Clicar em “Sign in”
    Inserir um e-mail válido
    Clicar em "Create na account"
    Preencher os campos obrigatórios
    Submeter cadastro
    Conferir se o cadastro foi efetuado com sucesso
