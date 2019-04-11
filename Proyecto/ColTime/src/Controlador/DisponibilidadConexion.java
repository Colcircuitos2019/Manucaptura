package Controlador;

import coltime.Menu;
import java.awt.Color;
import java.util.ArrayList;

public class DisponibilidadConexion implements Runnable {

    @Override
    public void run() {
        
        Menu menu = new Menu();
        while (true) {
            
            Modelo.Conexion obj = new Modelo.Conexion(1);
            obj.establecerConexion();
            
            if (obj.getConexion() != null) {
                
                if (!menu.jLConexion.getText().equals("Linea")) {
                    
                    menu.jLConexion.setText("Linea");
                    menu.jLConexion.setForeground(Color.GREEN);
                    // Cargos = 2= Encargado de FE y TE, 3 = encargado de EN
                    socketCliente clienteSocket = new socketCliente(menu.cargo==2?new int[]{1,2}:new int[]{3});
                    clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "1");// Actualizar estado DB de los reportes de produccion
                    
                }
                
            } else {
                
                if (!menu.jLConexion.getText().equals("Sin conexión")) {
                    
                    menu.jLConexion.setText("Sin conexión");
                    menu.jLConexion.setForeground(Color.RED);
                    // Cargos = 2= Encargado de FE y TE, 3 = encargado de EN
                    socketCliente clienteSocket = new socketCliente(menu.cargo==2?new int[]{1,2}:new int[]{3});
                    clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "2");// Actualizar estado DB de los reportes de produccion
                    
                }
                
            }
            
            obj.destruir();
            
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
            
        }
        
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
