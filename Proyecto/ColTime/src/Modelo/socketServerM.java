/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

/**
 *
 * @author sis.informacion01
 */
public class socketServerM {

    Conexion conexion = null;
    PreparedStatement ps = null;
    Connection con = null;
    CachedRowSet crs = null;
    ResultSet rs = null;
    boolean res;

    public socketServerM() {
    }

    public CachedRowSet consultarServidorSocketReporteM(int area) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Consulta-------
            String Qry = "CALL PA_ConsultarServidorSocketReporte(?);";
            ps = con.prepareCall(Qry);
            ps.setInt(1, area);
            rs = ps.executeQuery();
            //Recibimiento de la información-----------
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Finalizar conexión------------
            rs.close();
            ps.close();
            con.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crs;
    }
    
    public boolean gestionarDireccionServidorM(String direccionIP, int area, int programa, int estado, String puerto) {
        boolean respuesta = false;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            // ... 
            String Qry = "CALL PA_GestionDireccionServerSocketReporte(?,?,?,?,?);";
            ps = con.prepareCall(Qry);
            ps.setString(1, direccionIP);
            ps.setInt(2, area);
            ps.setInt(3, estado);
            ps.setString(4, puerto);
            ps.setInt(5, programa);
            ps.execute();
            respuesta = true;
            // ...
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return respuesta;
    }

        public int consultarPuertoComunicacionservidorM(String direccionIP, int area, int programa) {
        int puerto = 0;
        try {
            //Establecer la conexión
            conexion=new Conexion(1);//Base de datos de SGN
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Preparar la consulata
            String Query = "SELECT FU_ConsultarPuertoComunicacionServidorSocket(?,?,?)";
            ps = con.prepareStatement(Query);
            ps.setString(1, direccionIP); // Direccion IP del server socket
            ps.setInt(2, area); // area
            ps.setInt(3, programa); // programa
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
    
}
