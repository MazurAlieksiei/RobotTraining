*** Settings ***
Library        BuiltIn
Library        OperatingSystem
Library        Collections
Library        String
Library        SeleniumLibrary
Library        RequestsLibrary

*** Keywords ***
gk.Open Browser
    [Arguments]    ${url}    ${browser}
    Open Browser    ${url}    ${browser}    options=add_experimental_option("detach", True)
    Maximize Browser Window
    
gk.Find Broken Images With GET
    [Documentation]    
    ...    Finds broken images with the help of get response. 
    ...    Returns number of broken images.
    ${elements}    Get Webelements    //img
    FOR    ${i}    IN    @{elements}
        ${request}    Get Element Attribute    ${i}    src
        ${response}    GET    ${request}        expected_status=Anything
        ${status}    Run Keyword And Return Status    Status Should Be    200    ${response}
        IF    '${status}' == 'False'
             ${attribute}    Get Element Attribute    ${i}    outerHTML
             Log    ${attribute} is broken.
             ${broken_images}    Evaluate    ${BROKEN_IMAGES} + 1
        END
    END
    Return From Keyword    ${broken_images}

gk.Find Broken Images By Attribute
    [Documentation]
    ...    Finds broken images by attribute("naturalWidth").
    ...    Returns number of broken images.
    ${elements}    Get Webelements    //img
    FOR    ${i}    IN    @{elements}
        ${attribute1}    Get Element Attribute    ${i}    naturalWidth
        ${status}    Run Keyword And Return Status    Should Not Be Equal    ${attribute1}    0
        IF    '${status}' == 'False'
             ${attribute2}    Get Element Attribute    ${i}    outerHTML
             Log    ${attribute2} is broken.
             ${broken_images}    Evaluate    ${BROKEN_IMAGES} + 1
        END
    END
    Return From Keyword    ${broken_images}

gk.JS Click Element
    [Arguments]     ${element_xpath}
    # escape " characters of xpath
    ${element_xpath}=       Replace String      ${element_xpath}        \"  \\\"
    Execute JavaScript  document.evaluate("${element_xpath}", document, null,
    ...    XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();