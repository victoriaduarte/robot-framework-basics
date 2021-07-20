*** Settings ***
Library       SeleniumLibrary
Library       String
Library       FakerLibrary      locale=pt_BR

*** Variables ***
${BROWSER}    chrome
${URL}        http://automationpractice.com
&{USUARIO}    nome=Victória     sobrenome=Duarte    senha=12345     endereco=Rodovia Amaro Antônio Vieira
...           cidade=Florianópolis    estado=2    postcode=12345    celular=99999999
@{SUMMER_DRESSES}    Printed Summer Dress    Printed Summer Dress    Printed Chiffon Dress

*** Keywords ***
### Setup e Teardown
Abrir navegador
    Open Browser    about:blank    ${BROWSER}    options=add_experimental_option('excludeSwitches',['enable-logging'])    # remove log do chromedriver no terminal
    Maximize Browser Window

Fechar navegador
    Close Browser

### Ações
Acessar a página home do site
    Go To               ${URL}
    Title Should Be     My Store

Digitar o nome do produto "${PRODUTO}" no campo de pesquisa
    Input Text          name=search_query    ${PRODUTO}

Clicar no botão pesquisar
    Click Element       name=submit_search

Passar o mouse por cima da categoria "${CATEGORIA}" no menu principal superior de categorias
    Mouse over                       xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"${CATEGORIA}")]
    Element Should Be Visible        xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Tops")] 
    Element Should Be Visible        xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Dresses")]  

Clicar na subcategoria "${SUBCATEGORIA}"
    Wait until Element is enabled    xpath=//*[@id="block_top_menu"]//a[contains(text(),"${SUBCATEGORIA}")]
    Click Element                    xpath=//*[@id="block_top_menu"]//a[contains(text(),"${SUBCATEGORIA}")]

Clicar no botão "Add to Cart" do produto
    Wait Until Element Is Visible     xpath=//*[@id="center_column"]//img[@alt="Faded Short Sleeve T-shirts"]
    Mouse over                        xpath=//*[@id="center_column"]//img[@alt="Faded Short Sleeve T-shirts"]
    Click Element                     xpath=//span[contains(text(), "Add to cart")]

Clicar no botão "Proceed to checkout"
    Wait Until Element Is Visible   xpath=//a[@title='Proceed to checkout']/span
    Click Element                   xpath=//a[@title='Proceed to checkout']/span
    
Adicionar o produto "${PRODUTO}" no carrinho
    Digitar o nome do produto "${PRODUTO}" no campo de pesquisa
    Clicar no botão pesquisar
    Clicar no botão "Add to Cart" do produto
    Clicar no botão "Proceed to checkout"

Excluir o produto do carrinho
    Wait Until Element Is Visible   xpath=//a[@title='View my shopping cart']
    Click Element                   xpath=//a[@title='View my shopping cart']
    Wait Until Element Is Visible   xpath=//a[@title='Delete']
    Click Element                   xpath=//a[@title='Delete']

Clicar em “Sign in”
    Click Element        xpath=//*[@id="header"]//a[@class="login"][contains(text(), "Sign in")]

Inserir um e-mail válido
    ${EMAIL}             FakerLibrary.Ascii Email
    Input Text           id=email_create      ${EMAIL}
    Log                  ${EMAIL}

Clicar em "Create na account"
    Click Button         id=SubmitCreate

Preencher os campos obrigatórios
    Wait Until Element Is Visible   xpath=//*[@id="account-creation_form"]//h3[contains(text(),"Your personal information")]
    Click Element                   id=id_gender2
    Input Text                      id=customer_firstname    ${USUARIO.nome} 
    Input Text                      id=customer_lastname     ${USUARIO.sobrenome}  
    Input Text                      id=passwd                ${USUARIO.senha}  
    Input Text                      id=address1              ${USUARIO.endereco}
    Input Text                      id=city                  ${USUARIO.cidade}
    Set Focus To Element            id=id_state   
    Select From List By Index       id=id_state              ${USUARIO.estado}  
    Input Text                      id=postcode              ${USUARIO.postcode}
    Input Text                      id=phone_mobile          ${USUARIO.celular} 

Submeter cadastro
    Click Button         id=submitAccount

### Conferências
Conferir se o produto "${PRODUTO}" foi listado no site
    Wait Until Element Is Visible    css=#center_column > h1
    Title Should Be                  Search - My Store
    Page Should Contain Image        xpath=//*[@id="center_column"]//*[@src="${URL}/img/p/7/7-home_default.jpg"]
    Page Should Contain Link         xpath=//*[@id="center_column"]//a[@class="product-name"][contains(text(),"${PRODUTO}")]

Conferir mensagem "${MENSAGEM_ALERTA}"
    Wait Until Element Is Visible    css=#center_column > p
    Title Should Be                  Search - My Store
    Page Should Contain Element      xpath=//*[@id="center_column"]/p[@class="alert alert-warning"]    ${MENSAGEM_ALERTA}

Conferir se os produtos da subcategoria ${SUBCATEGORIA}" foram mostrados na página
    Title Should Be                  Summer Dresses - My Store
    Wait Until Element Is Visible    css=#center_column > h1
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[1]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[0]}"]
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[2]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[1]}"]
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[3]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[2]}"]
  
Conferir se o produto "${PRODUTO}" foi adicionado ao carrinho com os respectivos dados e valores
    Wait Until Element Is Visible   xpath=//*[@id="cart_title"][contains(text(),"Shopping-cart summary")]
    Element Should Contain          xpath=//*[@id="order-detail-content"]//a[normalize-space() = 'Faded Short Sleeve T-shirts']     Faded Short Sleeve T-shirts   
    Element Text Should Be          xpath=//*[@class="cart_unit"]/*[@class="price"]/span   $16.51
    Element Text Should Be          id=total_price         $18.51
    
Conferir se o carrinho fica vazio
    Wait Until Element Is Visible   xpath=//*[@id="center_column"]/p[@class="alert alert-warning"]
    Element Text Should Be          xpath=//*[@id="center_column"]/p[@class='alert alert-warning']    Your shopping cart is empty.

Conferir se o cadastro foi efetuado com sucesso
    Wait Until Element Is Visible    xpath=//*[@id="center_column"]/p
    Element Text Should Be           xpath=//*[@id="center_column"]/p
    ...    Welcome to your account. Here you can manage all of your personal information and orders.
    Element Text Should Be           xpath=//*[@id="header"]/div[2]//div[1]/a/span     Victória Duarte 

