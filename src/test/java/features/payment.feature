Feature: Login Page UI Test

  Background: 
  
    # Call driver configuration files
    * def config = karate.callSingle('classpath:karate-config.js')
    * configure driver = { type: 'chrome', start: true, maximize: true }
    # Call Java classes
    * def CommonActions = Java.type('utils.CommonActions')
    * def Utils = Java.type('utils.Utils')
    # Call locators files
    * def loginPageLocators = read('classpath:locators/loginPage.json')
    * def paymentPageLocators = read('classpath:locators/paymentPage.json')
    # Call Data files
    * def creditCardData = read('classpath:data/creditCardData.json')
    * def creditCardData = creditCardData[config.env]



    # Generate new email and password
    * def newEmail = Utils.generateEmail()
    * def password = Utils.generatePassword()
    # Configure headers
    * configure headers = config.headersConfig
    # Check Email Availability (Before Creation)
    * def body = null
    Given url config.apiBaseURL + '/users/email/check/' + newEmail
    When method get
    Then assert responseStatus == 200 || responseStatus == 409
    # Read request body from JSON file
    * def requestBody = read('classpath:createAccountRequestBody.json')
    * eval requestBody.email = newEmail
    * eval requestBody.password = password
    # Create new Cafeyn account via API
    Given url config.apiBaseURL + '/users/infos'
    And request requestBody
    When method post
    Then status 201
    # Extract the access_token from the secret field
    * def access_token = response.secret
    # Send verification email
    Given url config.apiBaseURL + '/users/me/validation/resend/' + access_token
    When method get
    Then status 200
    # Validate email verification token
    Given url config.apiBaseURL + '/users/me/validate/' + access_token
    When method get
    Then status 200
    * def validationToken = response.access_token

  Scenario: Open Offers Page and Login
    Given driver config.uiBaseURL
    And driver.maximize()
    And waitFor(loginPageLocators.acceptCookiesButton)
    Then click(loginPageLocators.acceptCookiesButton)
    And waitFor(loginPageLocators.loginButton)
    Then click(loginPageLocators.loginButton)
    And waitFor(loginPageLocators.emailTextbox)
    And input(loginPageLocators.emailTextbox, newEmail)
    Then click(loginPageLocators.continueButton)
    And waitFor(loginPageLocators.passwordTextbox)
    And input(loginPageLocators.passwordTextbox, password)
    Then click(loginPageLocators.signinButton)
    Then click(loginPageLocators.tryForFreeButton)
    And click(loginPageLocators.creditCardRadioButton)
    # Enter Credit Card Information
    * def creditCard = creditCardData[0]
    # Fill card name
    And waitFor(paymentPageLocators.creditCardFullNameTextbox)
    And input(paymentPageLocators.creditCardFullNameTextbox, creditCard.cardHolderName)
    # Fill card number inside iframe
    And waitFor(paymentPageLocators.cardNumberIframe)
    Then switchFrame(paymentPageLocators.cardNumberIframe)
    And input(paymentPageLocators.creditCardNumberTextbox, creditCard.cardNumber)
    Then switchFrame(null)
    # Fill expiration date inside iframe
    And waitFor(paymentPageLocators.expDateIframe)
    Then switchFrame(paymentPageLocators.expDateIframe)
    And input(paymentPageLocators.creditCardExpDateTextbox, creditCard.expiryDate)
    Then switchFrame(null)
    # Fill CVC inside iframe
    And waitFor(paymentPageLocators.cvcIframe)
    Then switchFrame(paymentPageLocators.cvcIframe)
    And input(paymentPageLocators.creditCardCVCTextbox, creditCard.cvv)
    Then switchFrame(null)
    Then click(paymentPageLocators.termsAndConditionsCheckbox)
    Then click(paymentPageLocators.paymentSubmitButton)
    # Switch to 3DS iframe and fill in password
    And waitFor(paymentPageLocators.treeDSIFrame)
    Then switchFrame(paymentPageLocators.treeDSIFrame)
    And waitFor(paymentPageLocators.treeDSTextboxe)
    And input(paymentPageLocators.treeDSTextboxe, creditCard.treeDSPassword)
    Then click(paymentPageLocators.treeDSSubmitButton)
    Then switchFrame(null)
    Then CommonActions.sleep(10)