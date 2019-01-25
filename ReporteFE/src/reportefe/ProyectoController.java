package reportefe;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
//import javax.swing.JOptionPane;

public class ProyectoController {
//Variables

    CachedRowSet crs = null;
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    //--------------------------------------
    protected CachedRowSet consultarProceso() {
        //PA_ReporteDeFE
        try {
            Conexion conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement("CALL PA_InformeNFE");
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        return crs;
    }
}
