package helpers;

import com.github.javafaker.Faker;

public class TestDataGenerator {
    public static String getRandomUsername() {
        Faker faker = new Faker();
        return (faker.name().username().toLowerCase() + System.currentTimeMillis());
    }

    public static String getRandomEmail(String username) {
        return username + "@testmail.moc";
    }

    public static String getRandomArticleTitle() {
        Faker faker = new Faker();
        return faker.gameOfThrones().character();
    }

    public static String getRandomArticleDescription() {
        Faker faker = new Faker();
        return faker.gameOfThrones().city();
    }

    public static String getRandomArticleBody() {
        Faker faker = new Faker();
        return faker.gameOfThrones().quote();
    }

    public static String[] getRandomArticleTags() {
        Faker faker = new Faker();
        return new String[]{faker.beer().name(), faker.beer().name(), faker.beer().name()};
    }
}
