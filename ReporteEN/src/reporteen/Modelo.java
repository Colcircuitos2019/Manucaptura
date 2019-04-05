package reporteen;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

public class Modelo {

    //Variables
    Conexion conexion;
    CachedRowSet crs = null;
    ResultSet rs = null;
    PreparedStatement ps = null;
    Connection con = null;
    String Query = "";
    EN objEN;

    public Modelo(EN objEN) {
        this.objEN=objEN;
    }

    public CachedRowSet consultarProcesosM(int area) {
        try {
            //Establecer la conexión
            conexion=new Conexion(1,objEN);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
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
            conexion=new Conexion(1,objEN);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_InformeNEN()";
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
//            JOptionPane.showMessageDialog(null, "Erro: " + e);
        }
        return crs;
    }

    public boolean gestionarDireccionServidor(String direccionIP, int estado) {
        boolean respuesta = false;
        try {
            //Establecer la conexión
            conexion=new Conexion(1,objEN);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            Query = "CALL PA_GestionDireccionServerSocketReporte(?,?,?)";// pendiente procedure
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, 1); // Reporte del área
            ps.setInt(3, estado); // Estado de lectura
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
    
        public String consultarNombreLiderProyectoM(String doc){
        String empleado="";
        try {
            conexion=new Conexion(2,objEN);//Base de datos de SGN
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
//            JOptionPane.showMessageDialog(null, e);
        }
        return empleado;
    }
}
