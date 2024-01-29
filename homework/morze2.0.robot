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
    Scroll Element Into View    //table[contains(@class, "wikitable")]

   &{dict}    Create Dictionary
   @{dots}    Create List    1
    FOR    ${i}    IN RANGE    33    43
        ${first_column_value}    Get Text    ((//tbody//tr)[${i}]/td[1]//a/span)[2]

#        ${count}    Get Element Count    (//tbody//tr)[${i}]/td[2]/span/span
#        FOR    ${j}    IN RANGE    1    ${count}
#            ${third_column_value}    Get Text    (//tbody//tr)[${i}]/td[2]/span/span[${j}]
#            @{copy_list}    Copy List    ${dots}
#            Insert Into List    ${copy_list}    ${j}    ${third_column_value}
#            Log List    ${copy_list}
#        END
        ${second_column_value}    Get Text    (//tbody//tr)[${i}]/td[2]/span
        ${third_column_value}    Get Text    (//tbody//tr)[${i}]/td[3]
        Set List Value    ${dots}    0    ${second_column_value}
        Set To Dictionary    ${dict}    Напев для цифры "${first_column_value}"="${dots}, ${third_column_value}"
    END
    Log Dictionary    ${dict}
    [Teardown]    Close Browser