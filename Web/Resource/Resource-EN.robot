*** Settings ***
Library       SeleniumLibrary
Library       FakerLibrary      

*** Variables ***
${BROWSER}    chrome
${URL}        http://automationpractice.com
&{USER}       firstname=Victória     lastname=Duarte    password=12345     address1=Rodovia Amaro Antônio Vieira
...           city=Florianópolis    state=2    postcode=12345    phone_mobile=99999999
@{SUMMER_DRESSES}    Printed Summer Dress    Printed Summer Dress    Printed Chiffon Dress

*** Keywords ***
### Setup e Teardown
Open the Browser
    Open Browser    about:blank    ${BROWSER}    options=add_experimental_option('excludeSwitches',['enable-logging'])    # disable console output of chromedriver
    Maximize Browser Window

Close the Browser
    Close Browser

### Actions
Access the website's home page
    Go To               ${URL}
    Title Should Be     My Store

Enter the product name "${PRODUCT}" in the search field
    Input Text          name=search_query    ${PRODUCT}

Click on search button
    Click Element       name=submit_search

Mouse over the "${CATEGORY}" category in the top main category menu
    Mouse over                       xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"${CATEGORY}")]
    Wait until Element is enabled    xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Tops")] 
    Element Should Be Visible        xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Tops")] 
    Wait until Element is enabled    xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Dresses")]  
    Element Should Be Visible        xpath=//*[@id="block_top_menu"]//a[@class="sf-with-ul"][contains(text(),"Dresses")]  

Click on the subcategory "${SUBCATEGORY}"
    Wait until Element is enabled    xpath=//*[@id="block_top_menu"]//a[contains(text(),"${SUBCATEGORY}")]
    Click Element                    xpath=//*[@id="block_top_menu"]//a[contains(text(),"${SUBCATEGORY}")]

Click on the "Add to cart" button of the product
    Wait Until Element Is Visible     xpath=//*[@id="center_column"]//img[@alt="Faded Short Sleeve T-shirts"]
    Mouse over                        xpath=//*[@id="center_column"]//img[@alt="Faded Short Sleeve T-shirts"]
    Click Element                     xpath=//span[contains(text(), "Add to cart")]

Click on the "Proceed to checkout" button
    Wait Until Element Is Visible   xpath=//a[@title='Proceed to checkout']/span
    Click Element                   xpath=//a[@title='Proceed to checkout']/span
    
Add product "${PRODUCT}" to cart
    Enter the product name "${PRODUCT}" in the search field
    Click on search button
    Click on the "Add to cart" button of the product
    Click on the "Proceed to checkout" button

Delete product from cart
    Wait Until Element Is Visible   xpath=//a[@title='View my shopping cart']
    Click Element                   xpath=//a[@title='View my shopping cart']
    Wait Until Element Is Visible   xpath=//a[@title='Delete']
    Click Element                   xpath=//a[@title='Delete']

Click on "Sign in"
    Click Element        xpath=//*[@id="header"]//a[@class="login"][contains(text(), "Sign in")]

Enter a valid email address
    ${EMAIL}             FakerLibrary.Ascii Email
    Input Text           id=email_create      ${EMAIL}
    Log                  ${EMAIL}

Click on "Create na account"
    Click Button         id=SubmitCreate

Fill the required fields 
    Wait Until Element Is Visible   xpath=//*[@id="account-creation_form"]//h3[contains(text(),"Your personal information")]
    Click Element                   id=id_gender2
    Input Text                      id=customer_firstname    ${USER.firstname} 
    Input Text                      id=customer_lastname     ${USER.lastname}  
    Input Text                      id=passwd                ${USER.password}  
    Input Text                      id=address1              ${USER.address1}
    Input Text                      id=city                  ${USER.city}
    Set Focus To Element            id=id_state   
    Select From List By Index       id=id_state              ${USER.state}  
    Input Text                      id=postcode              ${USER.postcode}
    Input Text                      id=phone_mobile          ${USER.phone_mobile} 

Submit registration
    Click Button         id=submitAccount

### Validations
Verify if the product "${PRODUCT}" was listed on the website
    Wait Until Element Is Visible    css=#center_column > h1
    Title Should Be                  Search - My Store
    Page Should Contain Image        xpath=//*[@id="center_column"]//*[@src="${URL}/img/p/7/7-home_default.jpg"]
    Page Should Contain Link         xpath=//*[@id="center_column"]//a[@class="product-name"][contains(text(),"${PRODUCT}")]

Verify message "${ALERT_MESSAGE}"
    Wait Until Element Is Visible    css=#center_column > p
    Title Should Be                  Search - My Store
    Page Should Contain Element      xpath=//*[@id="center_column"]/p[@class="alert alert-warning"]    ${ALERT_MESSAGE}

Verify if the products of the subcategory "${SUBCATEGORY}" were shown on the page

    Title Should Be                  Summer Dresses - My Store
    Wait Until Element Is Visible    css=#center_column > h1
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[1]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[0]}"]
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[2]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[1]}"]
    Page Should Contain Element      xpath=//*[@id="center_column"]/ul/li[3]/div/div[2]/h5/a[@title="${SUMMER_DRESSES[2]}"]
  
Verify if the product "${PRODUCT}" has been added to the cart with the respective data and values
    Wait Until Element Is Visible   xpath=//*[@id="cart_title"][contains(text(),"Shopping-cart summary")]
    Element Should Contain          xpath=//*[@id="order-detail-content"]//a[normalize-space() = 'Faded Short Sleeve T-shirts']     Faded Short Sleeve T-shirts   
    Element Text Should Be          xpath=//*[@class="cart_unit"]/*[@class="price"]/span   $16.51
    Element Text Should Be          id=total_price         $18.51
    
Verify if the cart is empty
    Wait Until Element Is Visible   xpath=//*[@id="center_column"]/p[@class="alert alert-warning"]
    Element Text Should Be          xpath=//*[@id="center_column"]/p[@class='alert alert-warning']    Your shopping cart is empty.

Verify if the registration was successful
    Wait Until Element Is Visible    xpath=//*[@id="center_column"]/p
    Element Text Should Be           xpath=//*[@id="center_column"]/p
    ...    Welcome to your account. Here you can manage all of your personal information and orders.
    Element Text Should Be           xpath=//*[@id="header"]/div[2]//div[1]/a/span     Victória Duarte 

