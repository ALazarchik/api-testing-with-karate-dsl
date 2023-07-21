Feature: Authorization token

  Scenario: Get authorization token
    Given url apiUrl
    * def testDataGenerator = Java.type('helpers.TestDataGenerator')
    * def uniqueUsername = testDataGenerator.getRandomUsername()
    * def uniqueEmail = testDataGenerator.getRandomEmail(uniqueUsername)

    Given path "/users"
    And request
    """
        {
            'user':
                {
                    'email': '#(uniqueEmail)',
                    'password': 'TestPassword',
                    'username': '#(uniqueUsername)'
                }
        }
    """
    When method Post
    Then status 201
    * def authToken = response.user.token