
package Modelo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class rutaQRM {
    
    private Connection con;
    private ResultSet rs;
    private PreparedStatement ps;
    private String Qry="";
    private String respuesta;
    
    public rutaQRM(){
        
    }
    
    public String consultarRutaQRM(String documento){    
        respuesta="";
        try {
            Conexion conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //...
            Qry = "SELECT rutaQRs FROM usuariopuerto WHERE documentousario=?;";
            ps = con.prepareStatement(Qry);
            ps.setString(1, documento);
            rs = ps.executeQuery();
            rs.next();
            respuesta= rs.getString(1);
            //...
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            return respuesta;   
        }
    }
    
    
    public boolean gestionarRutaQRM(String documento, String rutaQR){
        boolean res=false;
        try {
            
            Conexion conexion= new Conexion(1);
            conexion.establecerConexion();
            con=conexion.getConexion();
            
            Qry="SELECT FU_GestionarRutaQRs(?,?) as gestion;";
            ps= con.prepareStatement(Qry);
            ps.setString(1, documento);
            ps.setString(2, rutaQR);
            
            rs=ps.executeQuery();
            rs.next();
            
            res= rs.getBoolean(1);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        //...
        return res;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
    
}
