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
 * @author PC
 */
public class ProcesosM {

    public ProcesosM() {

    }
    Conexion conexion = null;
    CachedRowSet crs = null;
    Connection con = null;
    PreparedStatement pps = null;
    ResultSet rs = null;
    boolean res = false;

    public boolean guardarModificarProcesosM(int op, String nombre, int area, int id) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("SELECT FU_RegistrarModificarProcesos(?,?,?,?)");//op,nombre del proceso y area a la que aplica.
            pps.setInt(1, op);
            pps.setString(2, nombre);
            pps.setInt(3, area);
            pps.setInt(4, id);
            rs = pps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
            JOptionPane.showMessageDialog(null, e);
        }
        return res;
    }

    public CachedRowSet consultarProcesosM(int area) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("CALL PA_ConsultarProcesos(?)");
            pps.setInt(1, area);
            crs = new CachedRowSetImpl();
            rs = pps.executeQuery();
            crs.populate(rs);
            //Cierre de conexiones
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return crs;
    }

    public boolean cambiarEstadoProcesosM(int estado, int id) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            pps = con.prepareStatement("SELECT FU_CambiarEstadoProcesos(?,?)");//op,nombre del proceso y area a la que aplica.
            pps.setInt(1, id);
            pps.setInt(2, estado);
            rs = pps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            rs.close();
            pps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {//Errores
        }
        return res;
    }
}
