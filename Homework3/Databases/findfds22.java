import java.util.*;


 
public class findfds22 {   
        public static void main(String[] args) { 
        String SQLTemplate = """
            SELECT 'Rentals: %1$s --> %2$s' AS FD
            CASE WHEN COUNT(*) = COUNT(DISTINCT X.%1$s) THEN 'MAY HOLD' 
            ELSE 'does not hold' END AS VALIDITY 
            FROM ( 
            SELECT P.%1$s, P.%2$s 
            FROM Rentals P 
            GROUP BY P.%1$s, P.%2$s 
            ) X;
            """; 
                    
            
            

            String[] R = {"PID", "HID", "PN", "S", "HS", "HZ", "HC"}  ;
        

            for (String attr1 : R) {
            for (String attr2 : R) {
            if (attr1.equals(attr2)) {
            continue;
            }
            System.out.println(String.format(SQLTemplate, attr1, attr2));
            }
            }
    
    }
}
    





    





