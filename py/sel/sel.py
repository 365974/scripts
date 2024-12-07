from selenium import webdriver
from selenium.webdriver.common.by import By
import time

driver = webdriver.Firefox()
driver.install_addon("/root/dir/veepn_free_fast_security_vpn-2.5.5.xpi")
driver.get("https://www.selenium.dev/selenium/web/blank.html")

# Создаем задержку в 1 секунду
time.sleep(20)

#injected = driver.find_element(webdriver.common.by.By.ID, "webextensions-selenium-example")

driver.quit()
