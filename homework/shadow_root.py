from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By


def get_shadow_element_text(shadow_root_element: str, inside_root_element: str):
    driver = Chrome()
    driver.get('https://the-internet.herokuapp.com/shadowdom')

    # shadow_host = driver.find_element(By.CSS_SELECTOR, 'my-paragraph:nth-child(4)')
    # shadow_root = shadow_host.shadow_root
    # time.sleep(2)
    # shadow_content = shadow_root.find_elements(By.XPATH, '//*')
    #
    # assert shadow_content.text == "Let's have some different text!"
    host = driver.find_element(By.CSS_SELECTOR, shadow_root_element)
    shadow_root = driver.execute_script("return arguments[0].shadowRoot", host)
    shadow_content = shadow_root.find_element(By.CSS_SELECTOR, inside_root_element)
    text = shadow_content.text
    return text
