package reportefe;

import java.sql.*;
import javax.swing.JOptionPane;

public class Conexion{

    private Connection conexion;
    static String bd = "coltime";
    static String user = "juanDavidM";
    static String password = "123";
    static String server = "jdbc:mysql://192.168.4.1:3306/" + bd;
    //192.168.0.103

    public Conexion() {
        FE obj=new FE();
        user = obj.user;
        password = obj.pass;
        server = "jdbc:mysql://"+obj.IP+"/" + bd;
    }

    public void establecerConexion() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conexion = DriverManager.getConnection(server, user, password);
//            if (conexion != null) {
//                JOptionPane.showMessageDialog(null, "Conexion exitosa");
//            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Imposible realizar conexion con la BD" + e);
            e.printStackTrace();
        }
    }

    public Connection getConexion() {
        return conexion;
    }

    public void cerrar(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (Exception e) {
                System.out.print("No es posible cerrar la Conexion");
            }
        }
    }

    public void destruir() {

        if (conexion != null) {

            try {
                conexion.close();
            } catch (Exception e) {
            }
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
