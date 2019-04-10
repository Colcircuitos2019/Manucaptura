package resportete;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

public class Modelo {

    //Variables
    CachedRowSet crs = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    Connection con = null;
    String Query = "";
    Conexion conexion = null;

    public Modelo() {

    }

    public CachedRowSet consultarProcesosM(int area) {
        try {
            //Establecer la conexión
            conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_ConsultarProcesoAreaReporte(?)";
            ps = con.prepareStatement(Query);
            ps.setInt(1, area);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e);
        }
        return crs;
    }

    public CachedRowSet consultarInformacionEnsambleM() {
        try {
            //Establecer la conexión
            Conexion obj = new Conexion();
            obj.establecerConexion();
            con = obj.getConexion();
            //Preparar la consulata
            Query = "CALL PA_InformeNTE()";
            ps = con.prepareStatement(Query);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            obj.cerrar(rs);
            obj.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Erro: " + e);
        }
        return crs;
    }
    
    public boolean gestionarDireccionServidor(String direccionIP, int estado) {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_GestionDireccionServerSocketReporte(?,?,?)";// pendiente procedure
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 2); // Reporte del área
            ps.setInt(3, estado); // Estado de lectura
            ps.execute();
            respuesta = true;
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }
}
