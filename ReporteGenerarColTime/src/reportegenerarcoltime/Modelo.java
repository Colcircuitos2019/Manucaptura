package reportegenerarcoltime;

import com.sun.org.apache.xerces.internal.impl.xpath.regex.Match;
import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
//import javax.swing.JOptionPane;

public class Modelo {

    //Variables globales
    CachedRowSet crs = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Conexion conexion = null;

    public CachedRowSet informacionInformeGeneral() {
        String Qry = "CALL PA_InformeGeneralColtime()";
        try {
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            ps.close();
            con.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        return crs;
    }

//    public int[] cantidadTotalProyecto(String orden) {
//        String Qry = "CALL PA_CantidadUnidadesProyecto(?)";
//        int cantidadTotal[]=new int[2];
//        try {
//            conexion = new Conexion();
//            conexion.establecerConexion();
//            con = conexion.getConexion();
//            ps = con.prepareStatement(Qry);
//            ps.setString(1, orden);
//            rs = ps.executeQuery();
//            rs.next();
//            cantidadTotal[0]=rs.getInt(1);
//            cantidadTotal[1]=rs.getInt(2);
//            ps.close();
//            con.close();
//            conexion.cerrar(rs);
//            conexion.destruir();
//        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
//        }
//        return cantidadTotal;
//    }
    public CachedRowSet procesos() {
        String Qry = "CALL PA_ConsultarProcesos()";
        try {
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            ps.close();
            con.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        return crs;
    }
}
