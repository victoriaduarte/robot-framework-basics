*** Settings ***
Documentation   API Documentation:  https://fakerestapi.azurewebsites.net/index.html
Resource         ../Resource/ResourceAPI-EN.robot
Suite Setup     Connect to my API

*** Test Case ***
Search the listing of all books (GET on all books)
    Request all books
    Check the status code    200
    Check the reason    OK
    Check if it returns a list with "200" books

Search for a specific book (GET in a specific book)   
    Request book "15"
    Check the status code    200
    Check the reason    OK
    Check if it returns all the correct data from book "15"

Register a new book (POST)   
    Register a new book
    Check the status code    200
    Check the reason    OK
    Check if it returns all registered data from book "201"

Change a book (PUT)
    Change book "199"
    Check the status code    200
    Check the reason    OK
    Check if it returns all changed data from book "199"

Delete a book (DELETE)
    Delete book "100"
    Check the status code    200
    Check the reason    OK
    Check if book "100" has been deleted

