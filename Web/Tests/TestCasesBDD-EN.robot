*** Settings ***
Resource         ../Resource/Resource-EN.robot
Test Setup       Open the browser
Test Teardown    Close the browser

### SETUP is executed before a test case 
### TEARDOWN is executed after a test case 

*** Test Case ***
Scenario 01: Search existing product
    Given I am on the home page of the site
    When I search for the product "Blouse"
    Then the product "Blouse" should be listed on the search result page

Scenario 02: Search nonexistent product
    Given I am on the home page of the site
    When I search for the product "NonexistentProduct"
    Then the page should display the message "No results were found for your search "NonexistentProduct""

Scenario 03: List products
    Given I am on the home page of the site
    When I access the "Women" category
    And consult the subcategory "Summer Dresses"  
    Then the page should display the products from the subcategory "Summer Dresses"

Scenario 04: Add products to cart
    Given I am on the home page of the site
    When I search for the product "t-shirt" 
    And add the product "t-shirt" to the cart
    Then the product "t-shirt" must be displayed in the cart with the respective data and values

Scenario 05: Delete products
    Given I am on the home page of the site
    And there is the product "t-shirt" added to the cart
    When I delete the product from the cart
    Then the page should display the message "Your shopping cart is empty."

Scenario 06: Add customer
    Given I am on the home page of the site
    When I request a new customer registration
    Then the registration must be successful

*** Keywords ***  
Given I am on the home page of the site
    Access the website's home page

When I search for the product "${PRODUCT}"
    Enter the product name "${PRODUCT}" in the search field
    Click on search button

Then the product "${PRODUCT}" should be listed on the search result page
    Verify if the product "${PRODUCT}" was listed on the website

Then the page should display the message "No results were found for your search "${ALERT_MESSAGE}""
    Verify message "${ALERT_MESSAGE}"

When I access the "${CATEGORY}" category
    Mouse over the "${CATEGORY}" category in the top main category menu

And consult the subcategory "${SUBCATEGORY}"
    Click on the subcategory "${SUBCATEGORY}"

Then the page should display the products from the subcategory "${SUBCATEGORY}"
    Verify if the products of the subcategory "${SUBCATEGORY}" were shown on the page

And add the product "${PRODUCT}" to the cart
    Click on the "Add to cart" button of the product
    Click on the "Proceed to checkout" button

Then the product "${PRODUCT}" must be displayed in the cart with the respective data and values
    Verify if the product "${PRODUCT}" has been added to the cart with the respective data and values

And there is the product "${PRODUCT}" added to the cart
    Enter the product name "${PRODUCT}" in the search field
    Click on search button
    Click on the "Add to cart" button of the product
    Click on the "Proceed to checkout" button

When I delete the product from the cart
    Delete product from cart

Then the page should display the message "Your shopping cart is empty."
    Verify if the cart is empty

When I request a new customer registration
    Click on "Sign in"
    Enter a valid email address
    Click on "Create na account"
    Fill the required fields 
    Submit registration

Then the registration must be successful
    Verify if the registration was successful
