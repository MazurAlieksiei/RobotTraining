*** Settings ***
#https://qaautomation.expert/2023/05/15/data-driven-testing-in-robot-framework/#prerequisite
Library        BuiltIn
Library        OperatingSystem
Library        Collections
Library        String
Library        SeleniumLibrary
Library        RequestsLibrary
Test Teardown    Close Browser
Test Template    Validate Downloading From Menu

*** Variables ***
${url}    https://the-internet.herokuapp.com/
${browser}    chrome
${download_directory}    /Users/Alex/Downloads/

*** Test Cases ***    element_js    file_title
Downloading PDF       \#ui-id-5      menu.pdf
Downloading CVS       \#ui-id-6      menu.csv
Downloading Excel     \#ui-id-7      menu.xls
    
    
*** Keywords ***
Validate Downloading From Menu
    [Arguments]     ${element_js}    ${file_title}
    Open Start Page
    CLick JQuery Ui Element    ${element_js}
    Validate Downloading    ${file_title}            
    Close Browser

Open start page
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Page Should Contain Element    //*[text()="Welcome to the-internet"]
    Click Element    //*[text()="JQuery UI Menus"]

CLick JQuery Ui Element 
    [Arguments]    ${element_js}
    Open Start Page
    Mouse Over    //*[@id="ui-id-3"]
    Wait Until Page Contains Element    //*[@aria-expanded="true"]
    Mouse Over    //*[@id="ui-id-4"]
    Execute JavaScript    document.querySelector("${element_js} > a").click()

Validate Downloading 
    [Arguments]    ${file_title}    ${remove}=True
    Wait Until Keyword Succeeds    2x    3s    File Should Exist    ${download_directory}${file_title}
    IF     ${remove}
        Remove File    ${download_directory}${file_title}
    END
