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
    
    public CachedRowSet consultarProductos(){
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.consultarProductosM();
    }
    
    public boolean cambiarEstadoCondicionProducto(){
        
        return true;
    }
    
    public int registrarModificarCondicionProducto(int idCondicion, int producto, int area,String material, boolean antisolder, boolean ruteo){
        //1= Registrado correctamente, 0=No se pudo registrar, 2= la condicion ya existe
        Condicion_productoM modelo = new Condicion_productoM();
        // Validar la existencia de otra condicion igual...
        if(modelo.validarExistenciaOtraMismaCondicionProducto(idCondicion, producto, area, material, antisolder, ruteo)){
            // ...
            return modelo.registrarModificarCondicionProductoM(idCondicion, producto, area, material, antisolder, ruteo);
//            return 1;
        }else{
            return 2;
        }
    }
    
}
