package Controlador;

import Modelo.Condicion_productoM;
import javax.sql.rowset.CachedRowSet;

public class Condicion_producto {
    
    //Variables
    
    public Condicion_producto(){
        
    }
    
    public CachedRowSet consultarCondicionesProductos(int idCondicion){
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.consultarCondicionesProductosM(idCondicion);
    }
    
    public boolean cambiarEstadoCondicionProducto(){
        
        return true;
    }
    
    public boolean registrarModificarCondicionProducto(){
        
        return true;
    }
}
