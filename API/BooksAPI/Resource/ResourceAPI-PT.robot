*** Settings ***
Documentation   Documentação da API:  https://fakerestapi.azurewebsites.net/index.html
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
Conectar a minha API
    Create Session    fakeAPI    ${URL_API}    verify=true  # desabilita o aviso InsecureRequestWarning do Python no terminal 
    ${HEADERS}      Create Dictionary   content-type=application/json  
    Set Suite Variable    ${HEADERS}

### Ações
Requisitar todos os livros
    ${RESPOSTA}    Get On Session    fakeAPI    Books  # endpoint
    Log            ${RESPOSTA.text}  # Response Body
    Set Test Variable    ${RESPOSTA}

Requisitar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Get On Session    fakeAPI    Books/${ID_LIVRO}  
    Log            ${RESPOSTA.text}  
    Set Test Variable    ${RESPOSTA}

Cadastrar um novo livro
    ${RESPOSTA}    Post On Session     fakeAPI    Books
    ...                                data={"ID": ${BOOK_201.id},"Title": "${BOOK_201.title}","Description": "${BOOK_201.description}","PageCount": ${BOOK_201.pageCount},"Excerpt": "${BOOK_201.excerpt}","PublishDate": "${BOOK_201.publishDate}"}
    ...                                headers=${HEADERS} 
    Log            ${RESPOSTA.text}  
    Set Test Variable    ${RESPOSTA}

Alterar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Put On Session    fakeAPI    Books/${ID_LIVRO}
    ...                           data={"ID": ${BOOK_199.id},"Title": "${BOOK_199.title}","Description": "${BOOK_199.description}","PageCount": ${BOOK_199.pageCount},"Excerpt": "${BOOK_199.excerpt}","PublishDate": "${BOOK_199.publishDate}"}
    ...                           headers=${HEADERS}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}

Deletar o livro "${ID_LIVRO}"
    ${RESPOSTA}    Delete On Session    fakeAPI    Books/${ID_LIVRO}
    Log            ${RESPOSTA.text}
    Set Test Variable    ${RESPOSTA}    

### Conferências
Conferir o status code
    [Arguments]    ${STATUSCODE_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.status_code}    ${STATUSCODE_DESEJADO}

Conferir o reason
    [Arguments]    ${REASON_DESEJADO}
    Should Be Equal As Strings    ${RESPOSTA.reason}    ${REASON_DESEJADO}

Conferir se retorna uma lista com "${QTDE_LIVROS}" livros
    Length Should be    ${RESPOSTA.json()}    ${QTDE_LIVROS}

Conferir se retorna todos os dados corretos do livro "15"
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id             ${BOOK_15.id} 
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title          ${BOOK_15.title} 
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount      ${BOOK_15.pageCount} 
    Should Not Be Empty               ${RESPOSTA.json()["description"]}
    Should Not Be Empty               ${RESPOSTA.json()["excerpt"]}
    Should Not Be Empty               ${RESPOSTA.json()["publishDate"]}

Conferir se retorna todos os dados cadastrados do livro "${ID_LIVRO}"
    Conferir livro    ${ID_LIVRO}

Conferir se retorna todos os dados alterados do livro "${ID_LIVRO}"
    Conferir livro    ${ID_LIVRO}

Conferir livro
    [Arguments]     ${ID_LIVRO}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    id              ${BOOK_${ID_LIVRO}.id}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    title           ${BOOK_${ID_LIVRO}.title}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    description     ${BOOK_${ID_LIVRO}.description}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    pageCount       ${BOOK_${ID_LIVRO}.pageCount}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    excerpt         ${BOOK_${ID_LIVRO}.excerpt}
    Dictionary Should Contain Item    ${RESPOSTA.json()}    publishDate     ${BOOK_${ID_LIVRO}.publishDate}

Conferir se o livro "${ID_LIVRO}" foi deletado
    Should Be Empty     ${RESPOSTA.content}