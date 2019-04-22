package reporteen;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;

public class Modelo {

    //Variables
    Conexion conexion;
    CachedRowSet crs = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    Connection con = null;
    String Query = "";

    public Modelo() {}

    public CachedRowSet consultarProcesosM() {
        try {
            //Establecer la conexión
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_ConsultarProcesoAreaReporte(?)";
            ps = con.prepareStatement(Query);
            ps.setInt(1, 3);
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
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_InformeNEN()";// Actualizar este procedure en el servidor
            ps = con.prepareStatement(Query);
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
    
    public boolean consultarEstadoLecturaPuertoSerial() {
        boolean respuesta= false;
        try {
            //Establecer la conexión
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_ConsultarEstadoLecturaFacilitador(?)";
            ps = con.prepareStatement(Query);
            ps.setString(1,"1037587834");
            rs = ps.executeQuery();
            if(rs.next()){
                respuesta =rs.getBoolean("estadoLectura");
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
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            String Query = "CALL PA_GestionDireccionServerSocketReporte(?,?,?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 3); // Área EN - Ensamble
            ps.setInt(3, estado); // Estado de lectura
            ps.setInt(4, puerto); // puerto
            ps.setInt(5, 0); // programa
            ps.execute();
            respuesta= true;
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
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "SELECT FU_ConsultarPuertoComunicacionServidorSocket(?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 3); // area ---> Esto tiene que ser versatil
            ps.setInt(3, 0); // programa
            rs = ps.executeQuery();
            while(rs.next()){
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
    
    public void refrescarEstadoReporte(String direccionIP, String puerto) {
        try {
            conexion=new Conexion(1);
            conexion.establecerConexion();
            con=conexion.getConexion();
            // ...
            Query = "CALL PA_RefrescarEstadoServerSocketReporteProduccion(?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP);
            ps.setString(2, puerto);
            ps.execute();
            //Cierre de conexiones
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            
            e.printStackTrace();
            
        }
    }
    
    public CachedRowSet consultarDireccionIPServerPrograma(int area) {
        try {
            //Establecer la conexión
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
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
    
    
    public String consultarNombreLiderProyectoM(String doc){
        String empleado=null;
        try {
            conexion=new Conexion(2);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //...
            String Qry= "CALL PA_ConsultarEmpleadosColtime(?,?);";
            ps=con.prepareStatement(Qry);
            ps.setString(1, doc);
            ps.setString(2, "");
            rs=ps.executeQuery();
            //Estraer el nombre del empleado del resultado de la base de datos
            if(rs.next()){
                empleado=rs.getString(2).substring(0,1).toUpperCase()+rs.getString(2).substring(1)+" "+
                    (!rs.getString(3).equals("")?rs.getString(3).substring(0,1).toUpperCase()+rs.getString(3).substring(1):"")+" "+
                    rs.getString(4).substring(0,1).toUpperCase()+rs.getString(4).substring(1)+" "+
                    (!rs.getString(5).equals("")?rs.getString(5).substring(0,1).toUpperCase()+rs.getString(5).substring(1):"");
            }
            con.close();
            ps.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return empleado;
    }
}
