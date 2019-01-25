package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

public class EmpleadoM {
    Conexion conexion=null;
    CachedRowSet crs=null;
    Connection con=null;
    PreparedStatement ps=null;
    ResultSet rs=null;
    
    public CachedRowSet consultarEmpleados(String doc,String name){
        try {
            conexion = new Conexion(2);//Base de datos SGN donde estan los empleados
            conexion.establecerConexion();
            con=conexion.getConexion();
            //...
            String Qry= "CALL PA_ConsultarEmpleadosColtime(?,?);";
            ps=con.prepareStatement(Qry);
            ps.setString(1, doc);
            ps.setString(2, name);
            rs=ps.executeQuery();
            crs=new CachedRowSetImpl();
            crs.populate(rs);
            //...
            ps.close();
            con.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }
        return crs;
    }
    
    public String consultarNombreLiderProyectoM(String doc){
        String empleado="";
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
                empleado="  "+rs.getString(2).substring(0,1).toUpperCase()+rs.getString(2).substring(1)+" "+
                    (!rs.getString(3).equals("")?rs.getString(3).substring(0,1).toUpperCase()+rs.getString(3).substring(1):"")+" "+
                    rs.getString(4).substring(0,1).toUpperCase()+rs.getString(4).substring(1)+" "+
                    (!rs.getString(5).equals("")?rs.getString(5).substring(0,1).toUpperCase()+rs.getString(5).substring(1):"");
            }
            con.close();
            ps.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }
        return empleado;
    }
    
    public int actualizarLiderProyectoM(int detalle, String doc){
        int res=0;
        try {
            conexion=new Conexion(1);
            conexion.establecerConexion();
            con=conexion.getConexion();
            //...
            String Qry="SELECT FU_ActualizarLiderProyectoEnsamble(?,?);";
            ps=con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setString(2, doc);
            if (ps.execute()) {
                res=1;
            }
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,e);
        }
        return res;
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
