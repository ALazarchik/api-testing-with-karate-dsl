Feature: Articles

  Background:
    * url apiUrl
    * def newArticleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * def testDataGenerator = Java.type('helpers.TestDataGenerator')
#    * set newArticleRequestBody.article.title = __gatling.Title
    * set newArticleRequestBody.article.title = testDataGenerator.getRandomArticleTitle()
    * set newArticleRequestBody.article.tagList = testDataGenerator.getRandomArticleTags()
#    * set newArticleRequestBody.article.description = __gatling.Description
    * set newArticleRequestBody.article.description = testDataGenerator.getRandomArticleDescription()
    * set newArticleRequestBody.article.body = testDataGenerator.getRandomArticleBody()

  Scenario: Create and delete new article
    Given path '/articles'
    And request newArticleRequestBody
    And header karate-name = 'Create article'
    When method Post
    Then status 201

    * karate.pause(5000)

    * def articleId = response.article.slug
    Given path '/articles/', articleId
    And header karate-name = 'Delete article'
    When method Delete
    Then status 204