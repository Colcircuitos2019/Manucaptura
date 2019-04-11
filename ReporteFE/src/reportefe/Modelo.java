package reportefe;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
//import javax.swing.JOptionPane;

public class Modelo {
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
            ps = con.prepareStatement("CALL PA_ConsultarProcesoAreaReporte(?)");
            ps.setInt(1, 1);// Consultar los procesos de FE - formato estandar
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            
            e.printStackTrace();
            
        }
        return crs;
    }
    
    protected CachedRowSet consultarInformacionProduccion() {
        //PA_ReporteDeFE
        try {
            Conexion conexion = new Conexion();
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement("CALL PA_InformeNFE()");// Actualizar esta información en el servidor... 
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            
            e.printStackTrace();
            
        }
        return crs;
    }
    
    public boolean consultarEstadoLecturaPuertoSerial() {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            Conexion conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            String Query = "CALL PA_ConsultarEstadoLecturaFacilitador(?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, "43975208");
            rs = ps.executeQuery();
            if (rs.next()) {
                respuesta = rs.getBoolean("estadoLectura");
            }
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
    
    public CachedRowSet consultarDireccionIPServerPrograma(int area) {
        try {
            //Establecer la conexión
            Conexion conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            String Query = "CALL PA_ConsultarDireccionIPServidorSocketPrograma(?)";
            ps = con.prepareStatement(Query);
            ps.setInt(1, area); // Area del programa...
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crs;
    }
 
    public int consultarPuertoComunicacionservidorM(String direccionIP) {
        int puerto = 0;
        try {
            //Establecer la conexión
            Conexion conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            String Query = "SELECT FU_ConsultarPuertoComunicacionServidorSocket(?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 1); // Area de FE - Formato estandar
            ps.setInt(3, 0); // programa
            rs = ps.executeQuery();
            while (rs.next()) {
                
                puerto = rs.getInt(1);
                
            }
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return puerto;
    }
    
    public boolean gestionarDireccionServidor(String direccionIP, int puerto, int estado) {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            Conexion conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            String Query = "CALL PA_GestionDireccionServerSocketReporte(?,?,?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 1); // Área de produccion FE - Formato estandar
            ps.setInt(3, estado); // Estado de lectura
            ps.setInt(4, puerto); // puerto
            ps.setInt(5, 0); // programa
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
