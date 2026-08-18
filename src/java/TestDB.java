
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDB {
    public static void main(String[] args) {
        String dbName = "faculty_login";
        String url = "jdbc:mysql://localhost:3306/" + dbName;
        String user = "root";
        String[] passwords = { "", "root", "admin", "password", "1234", "123456", "keerthan@123" };

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver loaded.");

            for (String pass : passwords) {
                System.out.println("Testing password: '" + pass + "'");
                try {
                    Connection con = DriverManager.getConnection(url, user, pass);
                    System.out.println("SUCCESS! Password is: '" + pass + "'");
                    con.close();
                    return;
                } catch (SQLException e) {
                    System.out.println("Failed: " + e.getMessage());
                }
            }
            System.out.println("All passwords failed.");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
