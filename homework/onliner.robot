*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    Collections
Library    String
Library    SeleniumLibrary

*** Variables ***
${url}    https://www.onliner.by/
${browser}    chrome
@{checkbox_values}    Apple    Samsung
${filter_row_title}    Производитель
${filter_row_pattern}    
...    //*[contains(@class, "form__label")]/*[contains(text(), "title")]//ancestor::*[contains(@class, "form__group")]
${checkbox_pattern}    //*[contains(@class, "form__checkbox-sign")][contains(text(), 'value')]

*** Test Cases ***
1. Test
    Open Browser    ${url}    ${browser}    options=add_experimental_option("detach", True)
    Maximize Browser Window
    Page Should Contain Element    //*[@class="onliner_logo"]
    Click Element    //span[text()="Смартфоны"]
    Page Should Contain Element    //*[@class="catalog-form__header"]//h1   #что-то не ищет путь с текстом
    
    ${status}    Run Keyword And Return Status    
    ...    Page Should Contain Element    //*[contains(@class, "form__tag-list")]/div
    Run Keyword If     ${status}    Disable Of Filters

    Chose Value For Specified Filter    ${filter_row_title}    @{checkbox_values}
    #Wait Until Page Does Not Contain Element    //*[contains(@class, "catalog-form__offers_processing")]
    Wait Until Page Does Not Contain Element    //*[contains(@class, "catalog-interaction__state_animated")]
    Sleep    1s    
    #без этого неправильно считает количество элементов, 
    #много чего пробовал - не успевает дождаться полной загрузки

    FOR    ${i}    IN    @{checkbox_values}
        &{dict}    Create Dictionary
        Create Dictionary From Title And Price    ${dict}    ${i}
        Log Dictionary    ${dict}
    END
    [Teardown]    Close Browser

*** Keywords ***
Disable Of Filters
    ${count}    Get Element Count    //*[contains(@class, "form__tag-list")]/div
    Scroll Element Into View    //*[contains(@class, "form__tag-list")]/div
    FOR    ${i}    IN RANGE    ${count}
       Click Element    //*[contains(@class, "form__tag-list")]/div[1]
    END

Chose Value For Specified Filter
    [Documentation]
    ...    Choosing of filter row by title and choosing checkbox by value
    ...    ${filter_to_select} - filter title
    ...    ${checkbox_values} - checkbox value
    [Arguments]    ${filter_to_select}    @{checkbox_values}
    ${filter_row_xpath}    Replace String    ${filter_row_pattern}    title    ${filter_to_select}
    Page Should Contain Element    ${filter_row_xpath}
    
    Scroll Element Into View     ${filter_row_xpath}
    FOR    ${i}    ${j}    IN ENUMERATE        @{checkbox_values}
        ${checkbox_value_xpath}     Replace String    
        ...    ${filter_row_xpath}${checkbox_pattern}    value    ${checkbox_values}[${i}]
        JS Click Element        ${checkbox_value_xpath}
    END
    
JS Click Element
    [Arguments]     ${element_xpath}
    # escape " characters of xpath
    ${element_xpath}=       Replace String      ${element_xpath}        \"  \\\"
    Execute JavaScript  document.evaluate("${element_xpath}", document, null, 
    ...    XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();

Create Dictionary From Title And Price 
    [Arguments]    ${dict}    ${checkbox_value}
    ${count}    Get Element Count    //*[contains(@class, "form__offers-part_data")]/div[1]/a
    FOR    ${i}    IN RANGE   1     ${count}
#        Scroll Element Into View    (//*[contains(@class, "form__offers-part_data")]/div[1]/a)[${i}]   
        #с ним тест длится +- 1 минуту, без 16 сек
        ${product_title_value}    Get Text    (//*[contains(@class, "form__offers-part_data")]/div[1]/a)[${i}]
        ${product_price_value}    Get Text    (//*[contains(@class, "form__offers-part_control")]//div/a/span[2])[${i}]
        ${product_price_correct_value}    Remove String Using Regexp    ${product_price_value}    [а-яА-Я]\.
        ${status}    Run Keyword And Return Status    Should Contain    ${product_title_value}    ${checkbox_value}
        Run Keyword If    ${status}    
        ...    Set To Dictionary    ${dict}    ${product_title_value}=${product_price_correct_value}
    END