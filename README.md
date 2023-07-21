This repository contains sample API tests with Karate DSL and performance tests with Gatling tools

1. To run all API tests you should install this project to your local machine,
create your new account at https://angular.realworld.io and run the following command from the Terminal using credentials
of your new account:

    test "-Dkarate.options=--tags @all" -Demail=!!!YOUR_EMAIL!!! -Dpassword=!!!YOUR_PASSWORD!!!

    Test reports for API tests will be saved in target/karate-reports folder. Open karate-summary.html or other specific html file to see it.

2. To run performance tests you should run the following command from the Terminal:

    mvn clean test-compile gatling:test

    Test report for performance tests will be saved in target/gatling/perftest-* folder. Open corresponding index.html file to see it.
