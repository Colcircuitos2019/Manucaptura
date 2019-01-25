package Controlador;

import Modelo.EmpleadoM;
import javax.sql.rowset.CachedRowSet;

public class Empleado {

    public CachedRowSet consultarEmpleado(String doc,String name){
        EmpleadoM obj=new EmpleadoM();
        return obj.consultarEmpleados(doc,name);
    }
    
    public String consultarNombreLiderProyecto(String doc){
        EmpleadoM obj=new EmpleadoM();
        return obj.consultarNombreLiderProyectoM(doc);
    }
    
    public int actualizarLiderProyecto(int detalle, String doc){
         EmpleadoM obj=new EmpleadoM();
        return obj.actualizarLiderProyectoM(detalle,doc);
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
    
}
