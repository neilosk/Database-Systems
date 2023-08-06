import java.util.*;

public class SQLQuery {
    public static void main(String[] args) {
        String[] R = {"PID", "HID", "PN", "S", "HS", "HZ", "HC"};

        for (int i = 0; i < R.length; i++) {
            for (int j = 0; j < R.length; j++) {
                if (i != j) {
                    printSQL(R[i], R[j]);
                }
            }
        }
    }

public static void printSQL(String Att1, String Att2) {
    String SQLquery = String.format("SELECT 'Rentals: %1$s --> %2$s' AS FD, "
            + "CASE WHEN COUNT(*) = COUNT(DISTINCT X.%1$s) THEN 'MAY HOLD' "
            + "ELSE 'does not hold' END AS VALIDITY "
            + "FROM ( "
            + "SELECT P.%1$s, P.%2$s "
            + "FROM Rentals P "
            + "GROUP BY P.%1$s, P.%2$s "
            + ") X;",
            Att1, Att2);

    System.out.println(SQLquery);
}





}