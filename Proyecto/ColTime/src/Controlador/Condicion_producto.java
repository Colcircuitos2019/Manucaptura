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
    
    // Clase de procesos 
    public boolean guardarModificarProcesos(int idProceso, String nombreProceso, int area) {
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.guardarModificarProcesosM(idProceso, nombreProceso, area);
    }

    public CachedRowSet consultarProcesos(int area) {
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.consultarProcesosM(area);
    }

    public boolean cambiarEstadoProcesos(int idProceso) {
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.cambiarEstadoProcesosM(idProceso);
    }
    
    public boolean validarExistenciaProcesoSelecionado(int idProceso) {
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.validarExistenciaProcesoSelecionadoM(idProceso);
    }
    
    // .................
    
    public CachedRowSet consultarProcesosSeleeccionCondicionProducto(String idCondicion){
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.consultarProcesosSeleeccionCondicionProductoM(Integer.parseInt(idCondicion));
    }
    
    public boolean cambiarEstadoCondicionProducto(){ // Esto no se va aplicar por el momento
        
        return true;
    }
    
    public boolean registrarModificarSeleccionDeProcesosCondicionProducto(int idProceso, int idCondicion, int orden, int idProceso_producto){
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.registrarModificarSeleccionDeProcesosCondicionProductoM(idProceso, idCondicion, orden, idProceso_producto);
//        return true;
    }
    
    public boolean eliminarSeleccionDeProcesoCondicionProducto(int idProceso_producto){
        Condicion_productoM modelo = new Condicion_productoM();
        return modelo.eliminarSeleccionDeProcesoCondicionProductoM(idProceso_producto);
    }
    
    public int registrarModificarCondicionProducto(int idCondicion, int producto, int area,String material, boolean antisolder, boolean ruteo){
        //1= Registrado correctamente, 0=No se pudo registrar, 2= la condicion ya existe
        Condicion_productoM modelo = new Condicion_productoM();
        //Mensaje de confirmación de acción...  
        // Validar la existencia de otra condicion igual...
        if(modelo.validarExistenciaOtraMismaCondicionProductoM(idCondicion, producto, area, material, antisolder, ruteo)){
            // ...
            return modelo.registrarModificarCondicionProductoM(idCondicion, producto, area, material, antisolder, ruteo);
            // ...
        }else{
            return 2;
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
    
    
    
}
