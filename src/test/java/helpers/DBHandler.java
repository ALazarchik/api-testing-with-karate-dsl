package helpers;

import net.minidev.json.JSONObject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBHandler {
    private static final String connectionUrl = "jdbc:sqlserver://localhost:14330;database=Pubs;user=sa;password=PaSSw0rd";   //specify path and connection data for your database.
    public static void addNewJobWithName(String jobName){
        try(Connection connection = DriverManager.getConnection(connectionUrl)) {
            connection.createStatement().execute("+jobName+");   //specify SQL request passing required data
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    public static JSONObject getMinAndMaxLevelsForJob(String jobName) {
        JSONObject json = new JSONObject();
        try(Connection connection = DriverManager.getConnection(connectionUrl)) {
            ResultSet result = connection.createStatement().executeQuery("+jobName+");   //specify SQL request passing required data
            result.next();
            json.put("minLvl", result.getString("min_lvl"));
            json.put("maxLvl", result.getString("max_lvl"));
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return json;
    }
}
