Feature: Add likes

  Background:
    * url apiUrl

  Scenario: add likes
    Given path "articles", slug, "favorite"
    When method Post
    Then status 200
    * def likesCount = response.article.favoritesCount