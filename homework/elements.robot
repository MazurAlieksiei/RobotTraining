*** Settings ***
Library        BuiltIn
Library        OperatingSystem
Library        Collections
Library        String
Library        SeleniumLibrary
Library        RequestsLibrary
Resource       gk.Keywords.robot
Resource       GLOBAL_VAR.robot

*** Variables ***
${url}    https://the-internet.herokuapp.com/
${browser}    chrome
${quantity}    3
${username}    admin
${password}    admin
@{list1}    Home    About    Contact Us    Portfolio
@{list2}    Home    About    Contact Us    Portfolio    Gallery

*** Test Cases ***
1. Add/Remove elements
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Add/Remove Elements"]
    Page Should Contain Element    //*[text()="Add/Remove Elements"]

    Add Elements    ${quantity}     
    Delete All Elements
    [Teardown]    Close Browser

2. Basic Auth
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Basic Auth"]
    Go To    https://${username}:${password}@the-internet.herokuapp.com/basic_auth
    #https://serverfault.com/questions/371907/can-you-pass-user-pass-for-http-basic-authentication-in-url-parameters
    #http://username:password@example.com/
    #put before http:// "username" : "password" @ "url"
    Page Should Contain Element    //*[contains(text(),"Congratulations! You must have the proper credentials.")]
    [Teardown]    Close Browser

3. Broken Images
    #https://www.lambdatest.com/blog/find-broken-images-using-selenium-webdriver/
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Broken Images"]
    Page Should Contain Element    //img

    Set Test Variable    ${broken_images}    0
    ${broken_images}    Gk.Find Broken Images By Attribute
    Log    Broken images: ${broken_images}.
    [Teardown]    Close Browser

4. Checkboxes
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Checkboxes"]
    Page Should Contain Element    //input[@type="checkbox"]
    
    Select All Checkboxes    
    Unselect All Checkboxes    
    [Teardown]    Close Browser

5. Context Menu
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Context Menu"]
    Page Should Contain Element    //*[text()="Context Menu"]

    Open Context Menu    //*[@id="hot-spot"]
    Alert Should Be Present    You selected a context menu    action=DISMISS  #accepts alert by default 
    Handle Alert
    [Teardown]    Close Browser

6. Disappearing Elements
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Disappearing Elements"]
    Page Should Contain Element    //*[text()="Disappearing Elements"]
    Check If All Elements Appears On Page
    [Teardown]    Close Browser

7. Drag and Drop
    [Documentation]    Drags and drops element a on element b.
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Drag and Drop"]
    Page Should Contain Element    //*[text()="Drag and Drop"]

    Drag And Drop    //*[@id="column-a"]    //*[@id="column-b"]
    #not working
#    ${x_axe}    Get Vertical Position    //*[@id="column-b"]
#    ${y_axe}    Get Horizontal Position    //*[@id="column-b"]
#    Drag And Drop By Offset    //*[@id="column-a"]    ${x_axe}    ${y_axe}
    [Teardown]    Close Browser

8. Dropdown
    [Documentation]    Selects dropdown values in different ways.
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Dropdown"]
    Page Should Contain Element    //*[text()="Dropdown List"]

    Click Element    //*[@id="dropdown"]
    Click Element    //option[@value="1"]
    Page Should Contain Element    //option[@value="1" and @selected="selected"]
    Select From List By Index    //*[@id="dropdown"]    2 
    Page Should Contain Element    //option[@value="2" and @selected="selected"]
    Select From List By Value      //*[@id="dropdown"]    1
    Page Should Contain Element    //option[@value="1" and @selected="selected"]
    [Teardown]    Close Browser
    
9. Disappearing Elements 2.0    
    [Documentation]    
    ...    Checks if all elements appears on page. 
    ...    If not, reloads page until all appears. Gives number of reloading attempts.
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Disappearing Elements"]
    Page Should Contain Element    //*[text()="Disappearing Elements"]

    Set Test Variable    ${reload_attempts}    0    
    ${reload_attempts}    Check Elements Appearing or Reload If Not
    Log    Page reloaded: ${reload_attempts} time(s).
    [Teardown]    Close Browser

10. Broken Images 2.0
    [Documentation]    Finds broken images with help of GET response.
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]

    Click Element    //*[text()="Broken Images"]
    Page Should Contain Element    //img

    ${BROKEN_IMAGES}    Gk.Find Broken Images With GET
    Log    Broken images: ${broken_images}.
    [Teardown]    Close Browser

11. Dynamic Content
    [Documentation]    
    Gk.Open Browser    ${url}    ${browser}
    Page Should Contain Element    //*[text()="Welcome to the-internet"]
    
    Click Element    //*[text()="Dynamic Content"]
    Check If Content Changing
    [Teardown]    Close Browser

*** Keywords ***
Check Elements Appearing or Reload If Not
    [Documentation]  
    ...    Checks if all elements appears on page. 
    ...    If not, reloads page until all appears. Gives number of reloading attempts.  
    WHILE    True
        @{elements_texts}    Create List
        @{elements}    Get Webelements    //li//a

        FOR    ${i}    IN    @{elements}
            ${text}    Get Text    ${i}
            Append To List    ${elements_texts}    ${text}
        END
        Log List    ${elements_texts}
        
        ${status}    Run Keyword And Return Status    Should Be Equal    ${elements_texts}    ${list2}
        IF    ${status}==False
            ${reload_attempts}    Evaluate    ${reload_attempts} + 1
            Reload Page
        ELSE
            BREAK
        END
    END  
    Return From Keyword    ${reload_attempts}

Check If All Elements Appears On Page
    [Documentation]    Create list of texts of elements and checks it equality to reference list.
    @{elements_texts}    Create List
    @{elements}    Get Webelements    //li//a
    FOR    ${i}    IN    @{elements}
        ${text}    Get Text    ${i}
        Append To List    ${elements_texts}    ${text}
    END
    Log List    ${elements_texts}

    ${status}    Run Keyword And Return Status    Should Be Equal    ${elements_texts}    ${list1}
    IF    ${status}==False
        FOR    ${i}    IN    @{list1}
            Remove Values From List    ${elements_texts}    ${i}
        END
        Log    Incorrect display of items. The problem is in ${elements_texts}.
    ELSE
        Log    Elements are displayed correctly.
    END

# second variant of test, if reference list has more items (5)
#    ${status}    Run Keyword And Return Status    Should Be Equal    ${elements_texts}    ${list2}
#    IF    ${status}==False
#        FOR    ${i}    IN    @{elements_texts}
#            Remove Values From List    ${list2}    ${i}
#        END
#        Log    Incorrect display of items. The problem is in ${list2}.
#    ELSE
#        Log     Elements are displayed correctly.
#    END

Select All Checkboxes
    [Documentation]    Selects all checkboxes existing on page. 
    ${count}    Get Element Count    //input[@type="checkbox"]
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Select Checkbox    (//input[@type="checkbox"])[${i}]
        Checkbox Should Be Selected    (//input[@type="checkbox"])[${i}]
    END

Unselect All Checkboxes
    [Documentation]    Unselects all checkboxes existing on page. 
    ${count}    Get Element Count    //input[@type="checkbox"]
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Unselect Checkbox    (//input[@type="checkbox"])[${i}]
        Checkbox Should Not Be Selected    (//input[@type="checkbox"])[${i}]
    END

Add Elements
    [Documentation]    Adds elements on page by given quantity times.
    [Arguments]    ${quantity}
    FOR    ${i}    IN RANGE        ${quantity}
        Click Element    //button[text()="Add Element"]
    END

Delete All Elements
    ${count}    Get Element Count    //button[text()="Delete"]
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Click Element    (//button[text()="Delete"])[1]
    END
    Page Should Not Contain Element    //button[text()="Delete"]
    
Create List Of Images "src" Attribute 
    [Documentation]
    ...    Checks if page has broken images. IF not
    ...    creates list of "src" attribute of all images appearing on page.
    ${BROKEN_IMAGES}    Gk.Find Broken Images With GET
    IF    ${BROKEN_IMAGES} > 0
        Log    Broken images are on page!
        BREAK
    ELSE
        Gk.Find Broken Images With GET
        ${elements}    Get Webelements    //img
        @{attribute_list}    Create List
        FOR    ${i}    IN    @{elements}
            ${attribute}    Get Element Attribute    ${i}    src
            Append To List    ${attribute_list}    ${attribute}
        END
        Return From Keyword    ${attribute_list}
    END
    
Create list of elements texts 
    [Documentation]    Creates list of all elements texts appearing on page.  
    ${elements}    Get Webelements    //*[@class= "large-10 columns"]
    @{elements_texts}    Create List    
    FOR    ${i}    IN    @{elements}
        ${text}    Get Text    ${i}    
        Append To List    ${elements_texts}    ${text}
    END     
    Return From Keyword    ${elements_texts}

Check If Content Changing
    [Documentation]    
    ...    Creates list of images "src" attribute and elements texts for start page.
    ...    Then reloads page and checks if content changed. 
    @{start_images_src}    Create List Of Images "src" Attribute     
    @{start_elements_texts}    Create List Of Elements Texts 
    Log List    ${start_images_src}
    Log List    ${start_elements_texts}     
    Reload Page
    @{reloaded_images_src}    Create List Of Images "src" Attribute     
    @{reloaded_elements_texts}    Create List Of Elements Texts
    Log List    ${reloaded_images_src}
    Log List    ${reloaded_elements_texts}
    Should Not Be Equal    ${start_images_src}    ${reloaded_images_src}
    Should Not Be Equal    ${start_elements_texts}    ${reloaded_elements_texts}   