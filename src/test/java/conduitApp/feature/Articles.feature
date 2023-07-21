@articles @all
Feature: Articles

  Background:
    * url apiUrl
    * def newArticleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def testDataGenerator = Java.type('helpers.TestDataGenerator')
    * set newArticleRequestBody.article.title = testDataGenerator.getRandomArticleTitle()
    * set newArticleRequestBody.article.tagList = testDataGenerator.getRandomArticleTags()
    * set newArticleRequestBody.article.description = testDataGenerator.getRandomArticleDescription()
    * set newArticleRequestBody.article.body = testDataGenerator.getRandomArticleBody()

  @suite2
  Scenario: Create new article
    Given path '/articles'
    And request newArticleRequestBody
    When method Post
    Then status 201
    And match response.article.title == newArticleRequestBody.article.title
    And match response.article.description == newArticleRequestBody.article.description
    And match response.article.body == newArticleRequestBody.article.body
    And match response.article.tagList contains newArticleRequestBody.article.tagList[0]
    And match response.article.tagList contains newArticleRequestBody.article.tagList[1]
    And match response.article.tagList contains newArticleRequestBody.article.tagList[2]

  @suite2
  Scenario: Create and delete new article
    Given path '/articles'
    And request newArticleRequestBody
    When method Post
    Then status 201
    And match response.article.title == newArticleRequestBody.article.title
    And match response.article.slug == '#string'

    * def articleId = response.article.slug
    Given path '/articles/', articleId
    When method Delete
    Then status 204