// public class PrintSql {

//   public static void main(String[] args) {
//     String SQLTemplate =
//       "Select 'Rentals: %s --> %s' as FD,\n" +
//       "CASE when count(*)=0 THEN 'May hold'\n" +
//       "ELSE 'Does not hold' END as Validity\n" +
//       "from (\n" +
//       "Select R.%s\n" +
//       "from Rentals R\n" +
//       "group by R.%s\n" +
//       "Having count(Distinct R.%s) > 1\n" +
//       ") X;\n";

//     String[] R = { "PID", "HID", "PN", "S", "HS", "HZ", "HC" };

//     for (String attr1 : R) {
//       for (String attr2 : R) {
//         if (attr1.equals(attr2)) {
//           continue;
//         }
//         System.out.printf(
//           String.format(SQLTemplate, attr1, attr2, attr1, attr1, attr2)
//         );
//       }
//     }
//   }
// }

// for relation write  "relation r" and substitute person with relation and p with r

public class PrintSQL {
  public static String query(String att1, String att2) {
    return String.format("SELECT 'rentals %s --> %s' AS FD,\n" +
        "CASE WHEN COUNT(*)=0 THEN 'MAY HOLD'\n" +
        "ELSE 'does not hold' END AS VALIDITY\n" +
        "FROM (\n" +
        "SELECT r.%s\n" +
        "FROM rentals r\n" +
        "GROUP BY r.%s\n" +
        "HAVING COUNT(DISTINCT r.%s)>1\n" +
        ")X;\n", att1, att2, att1, att1, att2);
  }

  public static void main(String[] args) {

    String[] R = { "PID", "HID", "PN", "S", "HS", "HZ", "HC" };

    for (String attr1 : R) {
      for (String attr2 : R) {
        if (attr1.equals(attr2)) {
          continue;
        }
        System.out.printf(
            query(attr1, attr2));
      }
    }
  }
}

// for relation write "relation r" and substitute person with relation and p
// with r