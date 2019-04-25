package Controlador;

import coltime.Menu;
import java.awt.Color;

public class DisponibilidadConexion implements Runnable {

    Menu menu = null;

    public DisponibilidadConexion(Menu menu) {
        this.menu = menu;
    }    
    
    @Override
    public void run() {
        
        while (menu.estadoConexionDB) {
            
            Modelo.Conexion obj = new Modelo.Conexion(1);
            obj.establecerConexion();
            
            if (obj.getConexion() != null) {
                
                if (!menu.jLConexion.getText().equals("Linea")) {
                    
                    menu.jLConexion.setText("Linea");
                    menu.jLConexion.setForeground(Color.GREEN);
                    menu.conexionServidor = true;
                    if(menu.cargo==2 || menu.cargo==3 ){
                        // Cargos = 2= Encargado de FE y TE, 3 = encargado de EN
                        socketCliente clienteSocket = new socketCliente(menu.cargo == 2 ? new int[]{1, 2} : new int[]{3});
                        menu.serversSocketsReportes = clienteSocket.consultarServerSockets();
                        clienteSocket.enviarInformacionSocketserver(menu.serversSocketsReportes, "1");// Actualizar estado DB de los reportes de produccion
                    }
                }
                
            } else {
                
                if (!menu.jLConexion.getText().equals("Sin conexión")) {
                    
                    menu.jLConexion.setText("Sin conexión");
                    menu.jLConexion.setForeground(Color.RED);
                    menu.conexionServidor = false;
                    if (menu.cargo == 2 || menu.cargo == 3) {
                        // Cargos = 2= Encargado de FE y TE, 3 = encargado de EN
                        socketCliente clienteSocket = new socketCliente(menu.cargo == 2 ? new int[]{1, 2} : new int[]{3});
                        clienteSocket.enviarInformacionSocketserver(menu.serversSocketsReportes, "2");// Actualizar estado DB de los reportes de produccion
                    }
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
