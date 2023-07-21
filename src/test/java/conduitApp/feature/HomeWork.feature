@all @homeWork
Feature: Home Work

  Background: Preconditions
    * url apiUrl
    * def testDataGenerator = Java.type("helpers.TestDataGenerator")
    * def timeValidator = read("classpath:helpers/timeValidator.js")

  Scenario: Favorite articles
    * def articleItemSchema = read("classpath:helpers/schemas/articleItem.json")
    * def favoritedByItemSchema = read("classpath:helpers/schemas/favoritedBy.json")
        # Step 1: Get articles of the global feed
    Given path "/articles"
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
        # Step 2: Get the favorites count and slug ID for the first article, save it to variables
    * def articleFavoritesCount = response.articles[0].favoritesCount
    * def articleSlugId = response.articles[0].slug
        # Step 3: Make POST request to increase favorites count for the first article
    Given path "/articles/" + articleSlugId + "/favorite"
    When method Post
    Then status 200
        # Step 4: Verify response schema
    * def favoritedByItem = favoritedByItemSchema
    And match response ==
      """
        {
            "article": {
                "id": "#number",
                "slug": "#string",
                "title": "#string",
                "description": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "authorId": "#number",
                "tagList": "#[] #string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                },
                "favoritedBy": "#[] favoritedByItem",
                "favorited": "#boolean",
                "favoritesCount": "#number"
            }
        }
      """
        # Step 5: Verify that favorites article incremented by 1
    And match response.article.favoritesCount == articleFavoritesCount + 1
        # Step 6: Get all favorite articles
    Given path "/articles"
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
        # Step 7: Verify response schema
    * def articleItem = articleItemSchema
    And match response ==
      """
        {
          "articles": "#[] articleItem",
          "articlesCount": "#number"
        }
      """
        # Step 8: Verify that slug ID from Step 2 exist in one of the favorite articles
    And match response.articles[*].slug contains articleSlugId

  Scenario: Comment articles
    * def commentItemSchema = read("classpath:helpers/schemas/commentItem.json")
        # Step 1: Get articles of the global feed
    Given path "/articles"
    And params { limit: 10, offset: 0 }
    When method Get
    Then status 200
        # Step 2: Get the slug ID for the first article, save it to variable
    * def articleSlugId = response.articles[0].slug
        # Step 3: Make a GET call to "comments" end-point to get all comments
    Given path "/articles/" + articleSlugId + "/comments"
    When method Get
    Then status 200
        # Step 4: Verify response schema
    * def commentsItem = commentItemSchema
    And match response ==
      """
        {
          "comments": "#[] commentsItem"
        }
      """
        # Step 5: Get the count of the comments array length and save to variable
    * def initialCommentsCount = response.comments.length
    * def newArticleComment = testDataGenerator.getRandomArticleBody()
        # Step 6: Make a POST request to publish a new comment
    Given path "/articles/" + articleSlugId + "/comments"
    And request { "comment": { "body": "#(newArticleComment)" } }
    When method Post
    Then status 200
        # Step 7: Verify response schema that should contain posted comment text
    And match response ==
      """
        {
          "comment": "#(commentsItem)"
        }
      """
    And match response.comment.body contains newArticleComment
    * def newCommentId = response.comment.id
        # Step 8: Get the list of all comments for this article one more time
    Given path "/articles/" + articleSlugId + "/comments"
    When method Get
    Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
    * def currentCommentsCount = response.comments.length
    And match currentCommentsCount == initialCommentsCount + 1
        # Step 10: Make a DELETE request to delete comment
    Given path "/articles/" + articleSlugId + "/comments/" + newCommentId
    When method Delete
    Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
    Given path "/articles/" + articleSlugId + "/comments"
    When method Get
    Then status 200
    * def commentsCountAfterDelete = response.comments.length
    And match commentsCountAfterDelete == initialCommentsCount