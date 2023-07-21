@all
Feature: Tests for the Home page

  Background:
    Given url apiUrl

  @suite1
  Scenario: Get all tags
    Given path '/tags'
    When method Get
    Then status 200
    And match response.tags contains ['welcome', 'ipsum']
    And match response.tags !contains 'ipsum1'
    And match response.tags contains any ['politics', 'economics', 'welcome']
    And match response.tags == '#array'
    And match each response.tags == '#string'

  @suite2
  Scenario: Get 5 articles from the Home page
    * def timeValidator = read('classpath:helpers/timeValidator.js')

#    Given param limit = 5
#    Given param offset = 0
    Given params { limit: 5, offset: 0 }
    Given path '/articles'
    When method Get
    Then status 200
    And match response.articles == '#[5]'
    And match response == { 'articles': '#array', 'articlesCount': '#number' }
#    And match response.articles[0].createdAt contains '2023'
#    And match each response..favoritesCount == '#number'
#    And match each response..bio == '##string'
#    And match each response..following == '#boolean'
    And match each response.articles ==
    """
      {
        'title': '#string',
        'slug': '#string',
        'body': '#string',
        'createdAt': '#? timeValidator(_)',
        'updatedAt': '#? timeValidator(_)',
        'tagList': '#array',
        'description': '#string',
        'author':
          {
            'username': '#string',
            'bio': '##string',
            'image': '##string',
            'following': '#boolean'
          },
          'favorited': '#boolean',
          'favoritesCount': '#number'
      }
    """

  Scenario: Conditional logic
    Given params { limit: 5, offset: 0 }
    Given path '/articles'
    When method Get
    Then status 200
    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]

#    * if (favoritesCount != 0) karate.call("classpath:helpers/AddLikes.feature", article)
    * def result = favoritesCount != 0 ? karate.call("classpath:helpers/AddLikes.feature", article).likesCount : favoritesCount

    Given params { limit: 5, offset: 0 }
    Given path '/articles'
    When method Get
    Then status 200
    And match response.articles[0].favoritesCount == result

      #the following scenario always fails. Just an example of using retry
  @ignore
  Scenario: Retry call
    * configure retry = { count: 3, interval: 2000 }
    Given params { limit: 5, offset: 0 }
    Given path '/articles'
    And retry until response.articles[0].favoritesCount == 2000
    When method Get
    Then status 200

  Scenario: Sleep call
    * def sleep = function(pause){ java.lang.Thread.sleep(pause) }

    Given params { limit: 5, offset: 0 }
    Given path '/articles'
    When method Get
    * eval sleep(5000)
    Then status 200

  Scenario: Number to string conversion
    * def foo = 10
    * def json = { "bar": #(foo + "") }
    * match json == { "bar": "10" }

  Scenario: String to number conversion
    * def foo = "10"

    * def json1 = { "bar": #(foo * 1) }
    * match json1 == { "bar": 10 }

    * def json2 = { "bar": #(~~parseInt(foo)) }
    * match json2 == { "bar": 10 }