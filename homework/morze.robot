*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    Collections
Library    String
Library    SeleniumLibrary

*** Variables ***
${url}    https://www.google.com
${browser}    chrome
${table_row_pattern}    //tbody//following-sibling::tr[number]
${first_column_value_pattern}    (//tbody//following-sibling::tr)[number]/td[1]
${fourth_column_value_pattern}    (//tbody//following-sibling::tr)[number]/td[4]
*** Test Cases ***
1. Test1
    Open Browser    ${url}    ${browser}    options=add_experimental_option("detach", True)
    Maximize Browser Window
    Click Element    //*[text()="English"]
    Page Should Contain Element    //*[@title="Search"]
    Input Text    //*[@title="Search"]    Азбука Морзе
    Click Element    (//input[@aria-label="Google Search"])[2]
    Page Should Not Contain Element     //*[@title="Search"]
    Click Element    (//h3[text()="Азбука Морзе"]/following::div)[1]
    Page Should Contain Element    //table[contains(@class, "wikitable")]

    &{dict}    Create Dictionary
    FOR    ${i}    IN RANGE    1    33
        ${first_column_value}    Get Text     (//tbody//following-sibling::tr)[${i}]/td[1]    #(//tbody//tr)[${i}]/td[1]
        ${fourth_column_value}    Get Text    (//tbody//following-sibling::tr)[${i}]/td[4]    #(//tbody//tr)[${i}]/td[4]
        Set To Dictionary    ${dict}    Напев для буквы "${first_column_value}"="${fourth_column_value}"
    END
    Log Dictionary    ${dict}

#    &{dict}    Create Dictionary
#    FOR    ${i}    IN RANGE    1    33
#        ${first_column_value}    Get Text     (//tbody//following-sibling::tr)[${i}]/td[1]    #(//tbody//tr)[${i}]/td[1]
#        ${fourth_column_value}    Get Text    (//tbody//following-sibling::tr)[${i}]/td[4]    #(//tbody//tr)[${i}]/td[4]
#        Set To Dictionary    ${dict}    ${first_column_value}=${fourth_column_value}
#    END
#    Log Dictionary    ${dict}
#
#    @{key}    Get Dictionary Keys    ${dict}    sort_keys=False
#    @{value}    Get Dictionary Values    ${dict}    sort_keys=False
#    FOR    ${i}    ${j}    IN ENUMERATE   @{key}
#        Log To Console    Напев для буквы "${key}[${i}]" : "${value}[${i}]"
#    END

#    @{letters}    Create List
#    @{songs}    Create List
#    FOR    ${i}    IN RANGE    1    33
#        ${first_column_value}    Get Text     (//tbody//following-sibling::tr)[${i}]/td[1]    #(//tbody//tr)[${i}]/td[1]
#        ${fourth_column_value}    Get Text    (//tbody//following-sibling::tr)[${i}]/td[4]    #(//tbody//tr)[${i}]/td[4]
#        Append To List    ${letters}    Напев для буквы "${first_column_value}"
#        Append To List    ${songs}    "${fourth_column_value}"
#    END
#    Log List    ${letters}
#    Log List    ${songs}
#
#    &{dict}    Create Dictionary
#    FOR    ${i}    ${j}    IN ENUMERATE   @{letters}
#         Set To Dictionary    ${dict}    ${letters}[${i}]=${songs}[${i}]
#    END
#    Log Dictionary    ${dict}
   [Teardown]    Close Browser

*** Keywords ***
