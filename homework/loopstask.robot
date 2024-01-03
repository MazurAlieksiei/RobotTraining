*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    Collections
Library    String
Library    SeleniumLibrary

*** Variables ***
${string}     Он услышал ее в детстве во время своей болезни.

*** Test Cases ***
1. Test1
    ${splited_string}    Replce "space" And Split String To Characters    ${string}
    @{splited_string}    Replace Space Char To Word    ${splited_string}
    Get Length    ${splited_string}  
    Log    ${splited_string}
    FOR    ${i}    ${j}   IN ENUMERATE         @{splited_string}
        ${position}    Evaluate    ${i} + 1
        Log To Console    ${position} символ - "${j}"
    END
    
2. Test2
    ${splited_string}    Replce "space" And Split String To Characters    ${string}
    @{splited_string}    Replace Space Char To Word    ${splited_string}
    ${lenght}    Get Length    ${splited_string}  
    Log    ${splited_string}
    FOR    ${i}    IN RANGE    ${lenght}
        ${position}    Evaluate    ${i} + 1
        Log To Console    ${position} символ - "${splited_string}[${i}]"
    END    
    
3. Test3
    ${splited_string}    Replce "space" And Split String To Characters    ${string}
    @{splited_string}    Replace Space Char To Word    ${splited_string}
    ${lenght}    Get Length    ${splited_string}  
    Log    ${splited_string}
    Set Test Variable    ${x}    0
    FOR    ${i}    IN    @{splited_string}
        ${x}    Evaluate    ${x} + 1
        Log To Console    ${x} символ - "${i}"
    END
    
4. Test4
    ${splited_string}    Replce "space" And Split String To Characters    ${string}
    @{splited_string}    Replace Space Char To Word    ${splited_string}
    ${lenght}    Get Length    ${splited_string}  
    Log    ${splited_string}
    Set Test Variable    ${x}    0
    Set Test Variable    ${i}    0
    WHILE    ${x} < ${lenght}
        ${x}    Evaluate    ${x} + 1
        Log To Console    ${x} символ - "${splited_string}[${i}]"
        ${i}    Evaluate    ${i} + 1
    END

5. Test5
    # эмуляция цикла do...while
    ${splited_string}    Replce "space" And Split String To Characters    ${string}        
    @{splited_string}    Replace Space Char To Word    ${splited_string}
    ${lenght}    Get Length    ${splited_string}
    Log    ${splited_string}
    Set Test Variable    ${x}    0
    Set Test Variable    ${i}    0
    WHILE    True
        ${x}    Evaluate    ${x} + 1
        Log To Console    ${x} символ - "${splited_string}[${i}]"
        ${i}    Evaluate    ${i} + 1
        IF    ${lenght} <= ${x}
            BREAK
        END
    END

*** Keywords ***
Replace space char to word 
    [Documentation]   Replace used 'space' char to word 'пробел'
    [Arguments]    ${splited_string}
    ${temp_List}    Create List
    FOR    ${i}    IN    @{splited_string}
        IF    '${i}' == '_'
            ${i}    Replace String    ${i}    _    пробел
        END
        Append To List    ${temp_List}    ${i}
    END
    Log    ${temp_List}
    [Return]     ${temp_List}

Replce "space" and split string to characters 
    [Arguments]    ${string}
    Should Be String    ${string}
    ${string}    Replace String    ${string}    ${SPACE}    _
    Log    ${string}
    @{splited_string}    Split String To Characters    ${string}
    Return From Keyword    ${splited_string}  