import java.util.*;

public class findfds2 {
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
            + "CASE WHEN EXISTS ( "
            + "SELECT P1.%1$s "
            + "FROM Rentals P1, Rentals P2 "
            + "WHERE P1.%1$s = P2.%1$s AND P1.%2$s <> P2.%2$s "
            + ") THEN 'does not hold' "
            + "ELSE 'MAY HOLD' END AS VALIDITY;",
            Att1, Att2);

    System.out.println(SQLquery);
}





}
