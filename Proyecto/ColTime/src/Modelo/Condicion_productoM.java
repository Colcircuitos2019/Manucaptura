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
}
