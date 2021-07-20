*** Settings ***
Documentation   API Documentation:  https://fakerestapi.azurewebsites.net/index.html
Library         RequestsLibrary
Library         Collections

*** Variable ***
${URL_API}      https://fakerestapi.azurewebsites.net/api/v1/
&{BOOK_15}      id=15
                ...    title=Book 15
                ...    pageCount=1500
&{BOOK_201}     id=201
...             title=Titulo do livro
...             description=Descricao do livro
...             pageCount=350
...             excerpt=Resumo do livro
...             publishDate=2021-07-18T20:32:08.765Z
&{BOOK_199}     id=199
...             title=Titulo do livro ALTERADO
...             description=Descricao do livro ALTERADA
...             pageCount=40
...             excerpt=Resumo do livro ALTERADO
...             publishDate=2021-01-01T12:00:00.005Z

*** Keywords ***
### Setup e Teardown
Connect to my API
    Create Session    fakeAPI    ${URL_API}    verify=true  # disable InsecureRequestWarning 
    ${HEADERS}      Create Dictionary   content-type=application/json  
    Set Suite Variable    ${HEADERS}

### Actions
Request all books
    ${RESPONSE}    Get On Session    fakeAPI    Books  # endpoint
    Log            ${RESPONSE.text}  # Response Body
    Set Test Variable    ${RESPONSE}

Request book "${BOOK_ID}"
    ${RESPONSE}    Get On Session    fakeAPI    Books/${BOOK_ID}  
    Log            ${RESPONSE.text}  
    Set Test Variable    ${RESPONSE}

Register a new book
    ${RESPONSE}    Post On Session     fakeAPI    Books
    ...                                data={"ID": ${BOOK_201.id},"Title": "${BOOK_201.title}","Description": "${BOOK_201.description}","PageCount": ${BOOK_201.pageCount},"Excerpt": "${BOOK_201.excerpt}","PublishDate": "${BOOK_201.publishDate}"}
    ...                                headers=${HEADERS} 
    Log            ${RESPONSE.text}  
    Set Test Variable    ${RESPONSE}

Change book "${BOOK_ID}"
    ${RESPONSE}    Put On Session    fakeAPI    Books/${BOOK_ID}
    ...                           data={"ID": ${BOOK_199.id},"Title": "${BOOK_199.title}","Description": "${BOOK_199.description}","PageCount": ${BOOK_199.pageCount},"Excerpt": "${BOOK_199.excerpt}","PublishDate": "${BOOK_199.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPONSE.text}
    Set Test Variable    ${RESPONSE}

Delete book "${BOOK_ID}"
    ${RESPONSE}    Delete On Session    fakeAPI    Books/${BOOK_ID}
    Log            ${RESPONSE.text}
    Set Test Variable    ${RESPONSE}    

### Validations
Check the status code
    [Arguments]    ${STATUSCODE_EXPECTED}
    Should Be Equal As Strings    ${RESPONSE.status_code}    ${STATUSCODE_EXPECTED}

Check the reason
    [Arguments]    ${REASON_EXPECTED}
    Should Be Equal As Strings    ${RESPONSE.reason}    ${REASON_EXPECTED}

Check if it returns a list with "${BOOKS_QTY}" books
    Length Should be    ${RESPONSE.json()}    ${BOOKS_QTY}

Check if it returns all the correct data from book "15"
    Dictionary Should Contain Item    ${RESPONSE.json()}    id             ${BOOK_15.id} 
    Dictionary Should Contain Item    ${RESPONSE.json()}    title          ${BOOK_15.title} 
    Dictionary Should Contain Item    ${RESPONSE.json()}    pageCount      ${BOOK_15.pageCount} 
    Should Not Be Empty               ${RESPONSE.json()["description"]}
    Should Not Be Empty               ${RESPONSE.json()["excerpt"]}
    Should Not Be Empty               ${RESPONSE.json()["publishDate"]}

Check if it returns all registered data from book "${BOOK_ID}"
    Check book    ${BOOK_ID}

Check if it returns all changed data from book "${BOOK_ID}"
    Check book    ${BOOK_ID}

Check book
    [Arguments]     ${BOOK_ID}
    Dictionary Should Contain Item    ${RESPONSE.json()}    id              ${BOOK_${BOOK_ID}.id}
    Dictionary Should Contain Item    ${RESPONSE.json()}    title           ${BOOK_${BOOK_ID}.title}
    Dictionary Should Contain Item    ${RESPONSE.json()}    description     ${BOOK_${BOOK_ID}.description}
    Dictionary Should Contain Item    ${RESPONSE.json()}    pageCount       ${BOOK_${BOOK_ID}.pageCount}
    Dictionary Should Contain Item    ${RESPONSE.json()}    excerpt         ${BOOK_${BOOK_ID}.excerpt}
    Dictionary Should Contain Item    ${RESPONSE.json()}    publishDate     ${BOOK_${BOOK_ID}.publishDate}

Check if book "${BOOK_ID}" has been deleted
    Should Be Empty     ${RESPONSE.content}