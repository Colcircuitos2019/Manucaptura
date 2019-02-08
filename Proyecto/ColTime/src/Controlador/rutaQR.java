
package Controlador;

import Modelo.rutaQRM;

public class rutaQR {
    
    public rutaQR(){
    
    }
    //Variables...
    private String rutaQR = "";
    private boolean res=false;
    private rutaQRM model;
    
    
    //Get and Set
    public String getRutaQR() {
        return rutaQR;
    }
    
    public boolean getRespuesta() {
        return res;
    }

    public void setRutaQR(String rutaQR) {
        this.rutaQR = rutaQR;
    }
    
    
    //Function
    public void consultarRutaQR(String documento){
        model= new rutaQRM();
        rutaQR= model.consultarRutaQRM(documento);
    }  
    
    public void gestionarRutaQR(String documento){
        model= new rutaQRM();
        res= model.gestionarRutaQRM(documento, rutaQR);
    }
    
}
