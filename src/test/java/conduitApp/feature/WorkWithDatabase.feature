@ignore
Feature: Work with DB

  Background: connect to DB
    * def dbHandler = Java.type("helpers.DBHandler")

  Scenario: Add a new job to database
#    pass required job name
    * eval dbHandler.addNewJobWithName("Some Job Name")

  Scenario: Get a job's levels from database
    * def levels = dbHandler.getMinAndMaxLevelsForJob("Some Job Name")
    * print levels.minLvl
    * print levels.maxLvl