*** Settings ***
Resource         ../Resource/Resource-EN.robot
Test Setup       Open the browser
Test Teardown    Close the browser

### SETUP is executed before a test case 
### TEARDOWN is executed after a test case 

*** Test Case ***
Test Case 01: Search existing product
    Access the website's home page
    Enter the product name "Blouse" in the search field
    Click on search button
    Verify if the product "Blouse" was listed on the website

Test Case 02: Search nonexistent product
    Access the website's home page
    Enter the product name "NonexistentProduct" in the search field
    Click on search button
    Verify message "No results were found for your search "NonexistentProduct""

Test Case 03: List products
    Access the website's home page
    Mouse over the "Women" category in the top main category menu
    Click on the subcategory "Summer Dresses"
    Verify if the products of the subcategory "Summer Dresses" were shown on the page

Test Case 04: Add products to cart
    Access the website's home page
    Enter the product name "t-shirt" in the search field
    Click on search button
    Click on the "Add to cart" button of the product
    Click on the "Proceed to checkout" button
    Verify if the product "t-shirt" has been added to the cart with the respective data and values

Test Case 05: Delete products
    Access the website's home page
    Add product "t-shirt" to cart
    Delete product from cart
    Verify if the cart is empty
    
Test Case 06: Add customer
    Access the website's home page
    Click on "Sign in"
    Enter a valid email address
    Click on "Create na account"
    Fill the required fields    
    Submit registration
    Verify if the registration was successful