package resportete;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;

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
            e.printStackTrace();
        }
        return crs;
    }

    public CachedRowSet consultarInformacionProduccionM() {
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
            e.printStackTrace();
        }
        return crs;
    }
    
    public boolean consultarEstadoLecturaPuertoSerial() {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_ConsultarEstadoLecturaFacilitador(?)";
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
    
    public boolean gestionarDireccionServidor(String direccionIP, int puerto, int estado) {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            String Query = "CALL PA_GestionDireccionServerSocketReporte(?,?,?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 2); // Area TE - Teclados
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
    
    public int consultarPuertoComunicacionservidorM(String direccionIP) {
        int puerto = 0;
        try {
            //Establecer la conexión
            conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            Query = "SELECT FU_ConsultarPuertoComunicacionServidorSocket(?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 2); // Área TE - teclados
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
    
    public CachedRowSet consultarDireccionIPServerPrograma(int area) {
        try {
            //Establecer la conexión
            conexion = new Conexion();//Base de datos de SGN
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_ConsultarDireccionIPServidorSocketPrograma(?)";
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
    
}
