@signup @all
Feature: Sign Up new user

  Background: Preconditions
    Given url apiUrl
    * def testDataGenerator = Java.type('helpers.TestDataGenerator')
    * def uniqueUsername = testDataGenerator.getRandomUsername()
    * def uniqueEmail = testDataGenerator.getRandomEmail(uniqueUsername)
    * def newUniqueUsername = testDataGenerator.getRandomUsername()
    * def newUniqueEmail = testDataGenerator.getRandomEmail(newUniqueUsername)

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

  Scenario: New user Sign Up

    And match response ==
    """
    {
      "user": {
        "email": '#(uniqueEmail)',
        "username": '#(uniqueUsername)',
        "bio": null,
        "image": '#string',
        "token": '#string'
        }
    }
    """

    Scenario Outline: Validate Sign Up error messages

      Given path "/users"
      And request
    """
    {
      'user':
        {
          'email': '<email>',
          'password': '<password>',
          'username': '<username>'
        }
    }
    """
      When method Post
      Then status 422
      And match response == <errorResponse>

  Examples:
    | email             | password     | username             | errorResponse                                                                         |
    | #(uniqueEmail)    | TestPassword | #(uniqueUsername)    | {"errors":{"email":["has already been taken"],"username":["has already been taken"]}} |
    | #(uniqueEmail)    | TestPassword | #(newUniqueUsername) | {"errors":{"email":["has already been taken"]}}                                       |
    | #(newUniqueEmail) | TestPassword | #(uniqueUsername)    | {"errors":{"username":["has already been taken"]}}                                    |
    |                   | TestPassword | #(newUniqueUsername) | {"errors":{"email":["can't be blank"]}}                                               |
    | #(newUniqueEmail) |              | #(newUniqueUsername) | {"errors":{"password":["can't be blank"]}}                                            |
    | #(newUniqueEmail) | TestPassword |                      | {"errors":{"username":["can't be blank"]}}                                            |
