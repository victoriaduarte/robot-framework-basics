*** Settings ***
Resource         ../Resource/Resource-PT.robot
Test Setup       Abrir navegador
Test Teardown    Fechar navegador

### SETUP executa keyword antes da suite ou antes de um teste
### TEARDOWN executa keyword depois de uma suite ou de um teste

*** Test Case ***
Cenário 01: Pesquisar produto existente
    Dado que estou na página home do site
    Quando eu pesquisar pelo produto "Blouse"
    Então o produto "Blouse" deve ser listado na página de resultado da busca

Cenário 02: Pesquisar produto não existente
    Dado que estou na página home do site
    Quando eu pesquisar pelo produto "produtoNãoExistente"
    Então a página deve exibir a mensagem "No results were found for your search "produtoNãoExistente""

Cenário 03: Listar produtos
    Dado que estou na página home do site
    Quando eu acessar a categoria "Women"
    E consultar a subcategoria "Summer Dresses"
    Então a página deve exibir os produtos da subcategoria "Summer Dresses"

Cenário 04: Adicionar produtos no carrinho
    Dado que estou na página home do site
    Quando eu pesquisar pelo produto "t-shirt"
    E adicionar o produto "t-shirt" ao carrinho
    Então o produto "t-shirt" deve ser exibido no carrinho com os respectivos dados e valores

Cenário 05: Remover produtos
    Dado que estou na página home do site   
    E existe o produto "t-shirt" adicionado no carrinho
    Quando eu excluir o produto do carrinho
    Então a página deve exibir a mensagem "Your shopping cart is empty."

Cenário 06: Adicionar cliente
    Dado que estou na página home do site
    Quando eu solictar cadastro de novo cliente
    Então o cadastro deve ser efetuado com sucesso

*** Keywords ***  # reaproveitar as keywords dos casos de testes procedurais
Dado que estou na página home do site
    Acessar a página home do site

Quando eu pesquisar pelo produto "${PRODUTO}"
    Digitar o nome do produto "${PRODUTO}" no campo de pesquisa
    Clicar no botão pesquisar

Então o produto "${PRODUTO}" deve ser listado na página de resultado da busca
    Conferir se o produto "${PRODUTO}" foi listado no site

Então a página deve exibir a mensagem "${MENSAGEM_ALERTA}"
    Conferir mensagem "${MENSAGEM_ALERTA}"

Quando eu acessar a categoria "${CATEGORIA}"
    Passar o mouse por cima da categoria "${CATEGORIA}" no menu principal superior de categorias

E consultar a subcategoria "${SUBCATEGORIA}"
    Clicar na subcategoria "${SUBCATEGORIA}"

Então a página deve exibir os produtos da subcategoria "${SUBCATEGORIA}"
    Conferir se os produtos da subcategoria ${SUBCATEGORIA}" foram mostrados na página

E adicionar o produto "${PRODUTO}" ao carrinho
    Clicar no botão "Add to cart" do produto
    Clicar no botão "Proceed to checkout"

Então o produto "${PRODUTO}" deve ser exibido no carrinho com os respectivos dados e valores
    Conferir se o produto "${PRODUTO}" foi adicionado ao carrinho com os respectivos dados e valores

E existe o produto "${PRODUTO}" adicionado no carrinho
    Digitar o nome do produto "${PRODUTO}" no campo de pesquisa
    Clicar no botão pesquisar
    Clicar no botão "Add to cart" do produto
    Clicar no botão "Proceed to checkout"

Quando eu excluir o produto do carrinho
    Excluir o produto do carrinho

Então a página deve exibir a mensagem "Your shopping cart is empty."
    Conferir se o carrinho fica vazio

Quando eu solictar cadastro de novo cliente
    Clicar em “Sign in”
    Inserir um e-mail válido
    Clicar em "Create na account"
    Preencher os campos obrigatórios
    Submeter cadastro

Então o cadastro deve ser efetuado com sucesso
    Conferir se o cadastro foi efetuado com sucesso
