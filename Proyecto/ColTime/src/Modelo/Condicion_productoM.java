package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;

public class Condicion_productoM {
    
    //Varables}
    CachedRowSet crs = null;
    PreparedStatement ps = null;
    Connection con = null;
    String Qry = "";
    ResultSet rs = null;
    
    public Condicion_productoM(){
        
    }
    
    public CachedRowSet consultarCondicionesProductosM(int idCondicion){
        try{
            Conexion conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry="CALL PA_ConsultarCondicionesProductos(?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idCondicion);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //...
            conexion.destruir();
            conexion.cerrar(rs);
            con.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return crs;
    }
    // ...
    public CachedRowSet consultarProductosM() {
        try {
            Conexion conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_ConsultarProductos();";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //...
            conexion.destruir();
            conexion.cerrar(rs);
            con.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crs;
    }
    // ...
    public int registrarModificarCondicionProductoM(int idCondicion, int producto, int area,String material, boolean antisolder, boolean ruteo) {
        int respuesta = 0;
        try {
            Conexion conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_RegistrarModificarCondicionProducto(?,?,?,?,?);";// PEndiente por crear el procedure
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idCondicion);
            ps.setInt(2, producto);
            ps.setInt(3, area);
            ps.setString(4, material);
            ps.setBoolean(5, antisolder);
            ps.setBoolean(6, ruteo);
            rs = ps.executeQuery();
            rs.next();
            respuesta = rs.getInt("respuesta"); 
            //...
            conexion.destruir();
            conexion.cerrar(rs);
            con.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }
    // ...
    
    public boolean validarExistenciaOtraMismaCondicionProducto(int idCondicion, int producto, int area,String material, boolean antisolder, boolean ruteo){
        boolean respuesta = false;
        try {
            Conexion conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_validarExistenciaOtraMismaCondicionProducto(?,?,?,?,?,?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idCondicion);
            ps.setInt(2, producto);
            ps.setInt(3, area);
            ps.setString(4, material);
            ps.setBoolean(5, antisolder);
            ps.setBoolean(6, ruteo);
            rs = ps.executeQuery();
            rs.next();
            respuesta = !rs.getBoolean("respuesta");
            //...
            conexion.destruir();
            conexion.cerrar(rs);
            con.close();
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }
}
