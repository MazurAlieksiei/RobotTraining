*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    Collections
Library    String
Library    SeleniumLibrary

*** Variables ***
${string}    abrakadabra make secret string

*** Test Cases ***
1. String encoding
    ${start_string}    Generate Random String    20      [LETTERS]
    Log    ${start_string}
    Should Be String    ${start_string}    'Not a string'
    ${start_string}    Convert To Title Case    ${start_string}
    Should Be Title Case    ${start_string}
    ${start_string}    Convert To Upper Case  ${start_string}
    Should Be Upper Case    ${start_string}
    ${start_string}    Replace String    ${start_string}    ${SPACE}    _
    Log    ${start_string}
    ${start_string}    Replace String Using Regexp   ${start_string}    [A-Z]    *
    Log    ${start_string}
    @{splited_string}    Split String     ${start_string}    _
    Log    ${splited_string}
    Should Not Be String   ${splited_string}

2. From file
    ${file_as_string}    Get File    Аленький цветочек.txt
    Should Be String    ${file_as_string}
    Log   ${file_as_string}

    Get Word Count In File    Аленький цветочек.txt    цветочек
    Log To Console    ${count}

    ${line}    Get Line    ${file_as_string}    55
    ${lines}    Get Lines Containing String    ${file_as_string}    цветочек
    ${line_count}    Get Line Count   ${lines}

    ${lines}    Replace String    ${lines}    цветочек    flower
    Log    ${lines}

    ${lines}    Remove String Using Regexp    ${lines}    [a-z]
    Log    ${lines}

    ${sub_string}    Get Substring    ${lines}    44    80
    Log    ${sub_string}
    
    ${stripped_string}    Strip String    ${sub_string}
    Log     ${stripped_string}
    
    ${left_fetch_string}    Fetch From Left    ${stripped_string}    ${SPACE}   
    Log    ${left_fetch_string}

*** Keywords ***
Get word count in file
    [Arguments]    ${file_path}    ${word}
    ${file_as_string}    Get File    ${file_path}
    Should Be String    ${file_as_string}
    Log   ${file_as_string}
    ${count}    Get Count    ${file_as_string}    ${word}    
    Set Test Variable    ${count}
    #Return From Keyword    ${count}
    #[Return]    ${count}
