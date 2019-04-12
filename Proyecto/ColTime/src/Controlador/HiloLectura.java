package Controlador;

import coltime.Menu;

public class HiloLectura implements Runnable {


    Menu menu = null;
    
    public HiloLectura(Menu menu){
       this.menu=menu; 
    }
    
    @Override
    public void run() {
        
        ConexionPS CPS = new ConexionPS();//Establecemos la conecion con el puerto serial(COM)
        
        while (true) {
            
            //El puerto es asignado desde esta variable "puertoActual".
            CPS.enlacePuertos(menu);//Si detecta algo en el puerto COM va a tomar o detener el tiempo!!
            // ...
            if (!menu.estadoLecturaPuertoCOM) {
                
                //Se selecciona el item Activado de: Menu Principal>Configuración>Lectura>Desactivado.
                menu.jRLDesactivado.setSelected(true);
                // Cargos = 2 - Encargado de FE y TE, Encargado de EN
                socketCliente clienteSocket = new socketCliente(menu.cargo==2?new int[]{1,2}:new int[]{3});
                clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "des");// Actualizar estado DB de los reportes de produccion
                
                menu.estadoPertoSerialOperarios();
                break;
            
            }
            
        }
        
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
