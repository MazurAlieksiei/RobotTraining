*** Settings ***
Library    BuiltIn
Library    OperatingSystem
Library    Collections
Library    String
Library    SeleniumLibrary

*** Variables ***

*** Test Cases ***
1. List 
    @{list}    Create List        
    FOR    ${i}    IN RANGE    10
        ${random_value}    Generate Random String    
        Append To List    ${list}    ${random_value}
    END
    Log List    ${list}
    @{copy_list}    Copy List    ${list}
    Sort List    ${list}
    ${count}    Count Values In List    ${list}    a
    Log    ${count}

    ${status}    Run Keyword And Return Status    Lists Should Be Equal    ${list}    ${copy_list}
    IF    ${status} == False
         Reverse List    ${copy_list}
         @{comdined_list}    Combine Lists    ${copy_list}    ${list}
         @{comdined_list}    Remove Duplicates    ${comdined_list}
         List Should Not Contain Duplicates    ${comdined_list}    
    END

    ${value}    Get From List    ${comdined_list}    5
    Remove Values From List    ${comdined_list}    ${value}   
    List Should Not Contain Value    ${comdined_list}    ${value}
    ${index}    Get Index From List    ${comdined_list}    ${value}
    ${status}    Run Keyword And Return Status    Lists Should Contain Value    ${comdined_list}    ${value}
    IF    ${status} == False
        Log    ${comdined_list}    
        #Insert Into List     ${comdined_list}    5    ${value}   #вставляет по заданному индексу
        Set List Value    ${comdined_list}    5    ${value}  #заменяет значение в списке 
        List Should Contain Value    ${comdined_list}    ${value}
        Log    ${comdined_list}
    END
    ${slice}    Get Slice From List    ${comdined_list}    3
    List Should Contain Sub List    ${comdined_list}    ${slice}

2. Dict
    &{dict}    Create Dictionary            
    FOR    ${i}    IN RANGE    10
        ${random_value}    Generate Random String
        ${i}    Convert To String    ${i}
        Set To Dictionary    ${dict}    ${i}=${random_value}
    END
    Log Dictionary    ${dict}
    
    &{copied_dict}    Copy Dictionary    ${dict}
    Dictionaries Should Be Equal    ${dict}    ${copied_dict}
    
    Remove From Dictionary    ${copied_dict}    3    8    1
    Dictionary Should Not Contain Key    ${copied_dict}    8
    Dictionary Should Contain Sub Dictionary    ${dict}    ${copied_dict}

    ${value}    Pop From Dictionary    ${copied_dict}    8    No such key
    IF    '${value}' == 'No such key'
        ${values}    Get Dictionary Values    ${copied_dict}
    END