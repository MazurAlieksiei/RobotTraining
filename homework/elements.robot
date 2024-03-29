*** Settings ***
Library        BuiltIn
Library        OperatingSystem
Library        Collections
Library        String
Library        SeleniumLibrary
Library        RequestsLibrary
Library        shadow_root.py
Resource       Resources/GlobalKeywords.robot
Resource       Resources/GlobalVariables.robot

*** Variables ***
${url}    https://the-internet.herokuapp.com/
${browser}    chrome
${quantity}    3
${username1}    admin
${password1}    admin
@{list1}    Home    About    Contact Us    Portfolio
@{list2}    Home    About    Contact Us    Portfolio    Gallery

*** Test Cases ***
1. Add/Remove elements
    [Documentation]    Adds specified quantity of elements and remove all them.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Add/Remove Elements"]
    Page Should Contain Element    //*[text()="Add/Remove Elements"]

    Add Elements    ${quantity}     
    Delete All Elements
    [Teardown]    Close Browser

2. Basic Auth
    [Documentation]    Passes basic auth by url.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Basic Auth"]
    Go To    https://${username1}:${password1}@the-internet.herokuapp.com/basic_auth
    #https://serverfault.com/questions/371907/can-you-pass-user-pass-for-http-basic-authentication-in-url-parameters
    #http://username:password@example.com/
    #put before http:// "username" : "password" @ "url"
    Page Should Contain Element    //*[contains(text(),"Congratulations! You must have the proper credentials.")]
    [Teardown]    Close Browser

3. Broken Images
    [Documentation]    Finds broken images on page with help of element attributes and return its quantity.
    #https://www.lambdatest.com/blog/find-broken-images-using-selenium-webdriver/
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Broken Images"]
    Page Should Contain Element    //img

    Set Test Variable    ${broken_images}    0
    ${broken_images}    Gk.Find Broken Images By Attribute
    Log    Broken images: ${broken_images}.
    [Teardown]    Close Browser

4. Checkboxes
    [Documentation]    Selects and unselects all checkboxes on page.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Checkboxes"]
    Page Should Contain Element    //input[@type="checkbox"]
    
    Select All Checkboxes    
    Unselect All Checkboxes    
    [Teardown]    Close Browser

5. Context Menu
    [Documentation]    Opens context menu on page and checks if it present.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Context Menu"]
    Page Should Contain Element    //*[text()="Context Menu"]

    Open Context Menu    //*[@id="hot-spot"]
    Alert Should Be Present    You selected a context menu    action=DISMISS  #accepts alert by default 
    Handle Alert
    [Teardown]    Close Browser

6. Disappearing Elements
    [Documentation]
    ...    Checks if all elements appears on page. Compares based on an existing list of items.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Disappearing Elements"]
    Page Should Contain Element    //*[text()="Disappearing Elements"]
    Check If All Elements Appears On Page
    [Teardown]    Close Browser

7. Drag and Drop
    [Documentation]    Drags and drops element a on element b.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

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
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

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
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Disappearing Elements"]
    Page Should Contain Element    //*[text()="Disappearing Elements"]

    Set Test Variable    ${reload_attempts}    0    
    ${reload_attempts}    Check Elements Appearing or Reload If Not
    Log    Page reloaded: ${reload_attempts} time(s).
    [Teardown]    Close Browser

10. Broken Images 2.0
    [Documentation]    Finds broken images with help of GET response.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Broken Images"]
    Page Should Contain Element    //img

    ${broken_images}    Gk.Find Broken Images With GET
    Log    Broken images: ${broken_images}.
    [Teardown]    Close Browser

11. Dynamic Content
    [Documentation]    Checks if content changing after reloading of page.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}
    
    Click Element    //*[text()="Dynamic Content"]
    Check If Content Changing
    [Teardown]    Close Browser

12. Dynamic Controls checkbox
    [Documentation]    Checks existence/non-existence  of element that changes asynchronously.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Dynamic Controls"]
    
    Page Should Contain Element    //input[@type="checkbox"]    
    Click Button    //*[@id="checkbox-example"]//button
    Wait Until Keyword Succeeds    2x    3s    Page Should Not Contain Element    //input[@type="checkbox"]
    Click Button    //*[@id="checkbox-example"]//button
    Wait Until Keyword Succeeds    2x    3s    Page Should Contain Element    //input[@type="checkbox"]
    [Teardown]    Close Browser

13. Dynamic Controls input
    [Documentation]    Checks ability/disability  of element that changes asynchronously.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Dynamic Controls"]
    
    Page Should Contain Element    //input[@type="text"]
    Element Should Be Disabled    //input[@type="text"]
    Click Button    //*[@id="input-example"]//button
    Wait Until Keyword Succeeds    2x    3s    Element Should Be Enabled    //input[@type="text"]
    Click Button    //*[@id="input-example"]//button
    Wait Until Keyword Succeeds    2x    3s    Element Should Be Disabled    //input[@type="text"]
    [Teardown]    Close Browser

14. Dynamic Loading hidden element
    [Documentation]    Checks if hidden element visible only after pressing special button.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Dynamic Loading"]
    Click Element    //*[contains(text(), "Example 1")]

    Element Should Not Be Visible    //h4[text()="Hello World!"]
    Click Button    //button[text()="Start"]
    Wait Until Keyword Succeeds    2x    3s    Wait Until Element Is Not Visible    //*[@id="loading"]
    Element Should Be Visible    //h4[text()="Hello World!"]
    [Teardown]    Close Browser

15. Dynamic Loading element rendered after
    [Documentation]    Checks if element renders only after pressing special button. 
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Dynamic Loading"]
    Click Element    //*[contains(text(), "Example 2")]

    Page Should Not Contain Element    //*[@id="finish"]    
    Click Button    //button[text()="Start"]
    Wait Until Keyword Succeeds    2x    3s    Wait Until Element Is Not Visible    //*[@id="loading"]
    Page Should Contain Element    //h4[text()="Hello World!"]
    [Teardown]    Close Browser

16. File Download
    [Documentation]    Downloads random file from page and checks existence on specified directory.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="File Download"]
    Download Random File And Check Existence    ${DOWNLOAD_DIRECTORY}
    [Teardown]    Close Browser
    
17. Floating menu
    [Documentation]    Checks if menu area is visible while scrolling. 
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}
    
    Click Element    //*[text()="Floating Menu"]
    Check If Element Visible    //*[@id="menu"]
    [Teardown]    Close Browser

    #not sure if it right way to check
#     Scroll Element Into View    (//div//p)[8]
#     Element Should Be Visible    //*[@id="menu"]

18. Form Authentication valid
    [Documentation]    Simple log in and log out with valid creds.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Form Authentication"]
    Log in    ${USERNAME}    ${PASSWORD}
    Page Should Contain Element    //*[@class="flash success"]
    Click Element    //a[@href="/logout"]
    Page Should Contain Element    //*[@class="flash success"]
    [Teardown]    Close Browser

19. Form Authentication invalid
    [Documentation]    Simple log in and log out with invalid creds.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Form Authentication"]
    Log in    sadas    asdas
    Page Should Contain Element    //*[@class="flash error"]
    [Teardown]    Close Browser

20. IFrame
    [Documentation]    Inputs text in to  special area hidden if iframe.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Frames"]
    Click Element    //*[text()="iFrame"]

    Select Frame    //*[@id="mce_0_ifr"]
    Clear Element Text    //*[@id="tinymce"]
    Input Text    //*[@id="tinymce"]    My super content.
    Unselect Frame
    Click Element    //button[@aria-label="Undo"]
    [Teardown]    Close Browser

21. Hover
    [Documentation]    Hovers over images and checks visibility of descriptions and uniqueness of text in them.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Hovers"]
    @{list}    Hover Anf Get List Of Texts
    List Should Not Contain Duplicates    ${list}
    [Teardown]    Close Browser

22. Key press
    [Documentation]    Checks equality to pressed key and appearing text.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Key Presses"]
    Press Key And Check Equality    ALT
    [Teardown]    Close Browser

23. JQuery UI Menus
    [Documentation]    Mouse over a JQuery menu items.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="JQuery UI Menus"]
    Mouse Over    //*[@id="ui-id-3"]
    Wait Until Page Contains Element    //*[@aria-expanded="true"]
    Mouse Over    //*[@id="ui-id-8"]
    Execute JavaScript    document.querySelector("#ui-id-8 > a").click()
    Page Should Contain Element    //a[text()="Menu"]
    Click Element    //a[text()="Menu"]
    Page Should Contain Element    //*[@id="menu"]
    [Teardown]    Close Browser

24. Shadow DOM
    [Documentation]    Logs text from inside shadow root element.
#    #content > my-paragraph:nth-child(4)
#    #content > my-paragraph:nth-child(4)
#    slot
    ${text}    Get Shadow Element Text    \#content > my-paragraph:nth-child(5)    slot
    Log    ${text}
    [Teardown]    Close Browser

25. Sortable Data Tables
    [Documentation]    Checks if sort action on all tables works.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Sortable Data Tables"]
    Sort All Columns And Check Equality
    [Teardown]    Close Browser
    
26. Typos
    [Documentation]    Checks if element still on page after reloading ignoring typos.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Typos"]
    Check If Element Still On Page After Reloading
    [Teardown]    Close Browser

27. Notification Messages
    [Documentation]    Logs list of notification messages after performing actions on page.
    Gk.Open Browser    ${url}    ${CHROME_BROWSER}
    Page Should Contain Element    ${INTRO}

    Click Element    //*[text()="Notification Messages"]
    Log Notification Message    5
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
        IF    '${status}' == 'False'
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
    IF    '${status}' == 'False'
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
    ${broken_images}    Gk.Find Broken Images With GET
    IF    ${broken_images} > 0
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

Log in
    [Documentation]    Simple log in with username and password.
    [Arguments]    ${username}    ${password}
    Page Should Contain Element    //*[@type="submit"]
    Input Text    //*[@id="username"]    ${username}
    Input Password    //*[@id="password"]    ${password}
    Click Button    //*[@type="submit"]

Check If Element Visible
    [Documentation]    Checks if element still in view when scrolling page.
    [Arguments]    ${element}
    ${count}    Get Element Count    //div//p
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Scroll Element Into View    (//div//p)[${i}]
        ${y_axe}    Get Vertical Position    ${element}
        Should Be True    ${y_axe}>=0
    END
    
Download Random File And Check Existence
    [Documentation]    
    ...    Gets list of files on page, downloads random file from list.
    ...    Checks if it exists in specified directory.
    ...    By default, downloaded file removes, but this can be controlled with the "remove" argument. 
    ...    Use "False"  to prevent removing.
    [Arguments]    ${path}    ${remove}=True 
    @{files}    Get Webelements    //*[@id="content"]//div//a[@href and text()]
    ${count}    Get Length    ${files}
    ${number}    Evaluate    random.randint(1, ${count})    random
    ${title}    Get Text    ${files}[${number}]    
    Click Element    ${files}[${number}]
    Wait Until Keyword Succeeds    2x    3s    File Should Exist    ${path}${title}
    IF     ${remove}
        Remove File    ${path}${title}
    END

Hover Anf Get List Of Texts  
    ${count}    Get Element Count    //*[@alt="User Avatar"]
    @{list}    Create List    
    FOR    ${i}    IN RANGE    1    ${count} + 1
        Mouse Over    (//*[@alt="User Avatar"])[${i}]
        Element Should Be Visible    (//*[@class="figcaption"])[${i}]
        ${text}    Get Text    (//h5)[${i}]
        Append To List    ${list}    ${text}
    END
    Return From Keyword    ${list}
    
Press Key and Check Equality 
    [Documentation]    Preses specified key on page and check equality to the page text. 
    [Arguments]    ${key}
    Press Keys    //input[@id="target"]    ${key}
    ${text}    Get Text    //*[@id="result"]
    Should Be Equal    You entered: ${key}    ${text}  
    
Check If Element Still On Page After Reloading    
    [Documentation]    
    ...    Checks if element still on page after reloading. 
    ...    Text of element ignored (typo independent).   
    FOR    ${i}    IN RANGE        11
        Page Should Contain Element    (//p)[2]
        Reload Page
    END

Log Notification Message
    [Documentation]    
    ...    Performs an action on the page the specified number of times (click button) 
    ...    and logs notification message with information about an action.
    [Arguments]    ${times}
    FOR    ${i}    IN RANGE        ${times} + 1
        Click Element    //*[text()="Click here"]
        ${message}    Get Text    //*[@data-alert]\
        Log    ${message}
    END

    #second variant - log list of messages
#    @{log_list}    Create List
#    FOR    ${i}    IN RANGE        ${times} + 1
#        Click Element    //*[text()="Click here"]
#        ${message}    Get Text    //*[@data-alert]\
#        Append To List    ${log_list}    ${message}
#    END
#    Log List    ${log_list}

Make Reference Sorted List
    [Documentation]    Makes reference sorted data list from specified columns.
    [Arguments]    ${cell_name}    ${table_xpath}    ${column_number}
    IF    '${cell_name}' == 'Due'
        RETURN
    ELSE
         ${elements}    Get Webelements    ${table_xpath}//td[${column_number}]
        @{reference_sorted_list}    Create List
        FOR    ${i}    IN    @{elements}
            ${text}    Get Text   ${i}
            Append To List    ${reference_sorted_list}    ${text}
        END
        Sort List    ${reference_sorted_list}
    END
    Log List    ${reference_sorted_list}
    Return From Keyword    ${reference_sorted_list}
    
Sort Cells By Page Action   
    [Documentation]     Performs an sort action on the page. Makes sorted data list from specified columns.
    [Arguments]    ${cell_name}    ${table_xpath}    ${column_number}
    IF    '${cell_name}' == 'Due'
        RETURN
    END
    Click Element    ${table_xpath}//th[${column_number}]
    ${elements}    Get Webelements    ${table_xpath}//td[${column_number}]
    @{page_sorted_list}    Create List
    FOR    ${i}    IN    @{elements}
        ${text}    Get Text   ${i}
        Append To List    ${page_sorted_list}    ${text}
    END
    Log List    ${page_sorted_list}
    Reload Page
    Return From Keyword    ${page_sorted_list}

Sort All Columns And Check Equality
    [Documentation]    Checks all columns sorting on page.
    ${count}    Get Element Count    //*[contains(@id,"table")]
    FOR    ${a}    IN RANGE    1    ${count} + 1
        FOR    ${i}    ${j}    IN ENUMERATE    @{HEADER_ROW_LIST}
            ${i}    Evaluate    ${i} + 1
            @{reference}    Make Reference Sorted List    ${j}    //*[contains(@id,"table")][${a}]    ${I}
            @{page_sorted}    Sort Cells By Page Action    ${j}    //*[contains(@id,"table")][${a}]    ${I}
            Should Be Equal    ${reference}    ${page_sorted}
        END
    END    