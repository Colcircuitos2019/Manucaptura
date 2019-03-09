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
    Conexion conexion= null;
    
    public Condicion_productoM(){
        
    }
    
    public CachedRowSet consultarCondicionesProductosM(int idCondicion){
        try{
            conexion = new Conexion(1);// DB coltime
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
            conexion = new Conexion(1);// DB coltime
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
    public CachedRowSet consultarProcesosSeleeccionCondicionProductoM(int idCondicion){
        try {
            conexion = new Conexion(1);// DB coltime
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_ConsultarSeleccionDeProcesoCondicionProducto(?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1,idCondicion);
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
            conexion = new Conexion(1);// DB coltime
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_RegistrarModificarCondicionProducto(?,?,?,?,?,?);";
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
    public boolean registrarModificarSeleccionDeProcesosCondicionProductoM(int idProceso, int idCondicion, int orden, int idProceso_producto) {
        boolean respuesta = false;
        try {
            conexion = new Conexion(1);// DB coltime
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_registrarModificarSeleccionProcesos(?,?,?,?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idProceso);
            ps.setInt(2, idCondicion);
            ps.setInt(3, orden);
            ps.setInt(4, idProceso_producto);
            rs = ps.executeQuery();
            rs.next();
            respuesta = rs.getBoolean("respuesta");
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
    public boolean eliminarSeleccionDeProcesoCondicionProductoM(int idProceso_producto) {
        boolean respuesta = false;
        try {
            conexion = new Conexion(1);// DB coltime
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            Qry = "CALL PA_EliminarProcesosCondicionProducto(?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idProceso_producto);
            rs = ps.executeQuery();
            rs.next();
            respuesta = rs.getBoolean("respuesta");
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
    public boolean validarExistenciaOtraMismaCondicionProductoM(int idCondicion, int producto, int area,String material, boolean antisolder, boolean ruteo){
        boolean respuesta = false;
        try {
            conexion = new Conexion(1);// DB coltime
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
    
    // Modelo Procesos
    
    public boolean guardarModificarProcesosM(int idProceso, String nombreProceso, int area) {
        boolean respuesta= false;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement("SELECT FU_RegistrarModificarProcesos(?,?,?)");//op,nombre del proceso y area a la que aplica.
            ps.setInt(1, idProceso);
            ps.setString(2, nombreProceso);
            ps.setInt(3, area);
            rs = ps.executeQuery();
            rs.next();
            respuesta = rs.getBoolean(1);
            //Cierre de conexiones
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
            e.printStackTrace();
        }
        return respuesta;
    }

    public CachedRowSet consultarProcesosM(int area) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement("CALL PA_ConsultarProcesos(?)");
            ps.setInt(1, area);
            crs = new CachedRowSetImpl();
            rs = ps.executeQuery();
            crs.populate(rs);
            //Cierre de conexiones
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return crs;
    }

    public boolean cambiarEstadoProcesosM(int idProceso) {
        boolean respuesta = false;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            ps = con.prepareStatement("SELECT FU_CambiarEstadoProcesos(?)");//op,nombre del proceso y area a la que aplica.
            ps.setInt(1, idProceso);
            rs = ps.executeQuery();
            rs.next();
            respuesta = rs.getBoolean(1);
            //Cierre de conexiones
            rs.close();
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return respuesta;
    }
    
    // ................
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
