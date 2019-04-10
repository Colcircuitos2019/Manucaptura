package Controlador;

import coltime.Menu;
import java.awt.Color;
import java.util.ArrayList;

public class DisponibilidadConexion implements Runnable {

    @Override
    public void run() {
        
        Menu vista = new Menu();
        while (true) {
            
            Modelo.Conexion obj = new Modelo.Conexion(1);
            obj.establecerConexion();
            
            if (obj.getConexion() != null) {
                
                if (!vista.jLConexion.getText().equals("Linea")) {
                    
                    vista.jLConexion.setText("Linea");
                    vista.jLConexion.setForeground(Color.GREEN);
                    socketCliente clienteSocket = new socketCliente(3);
                    clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "1");// Actualizar estado DB de los reportes de produccion
                    
                }
                
            } else {
                
                if (!vista.jLConexion.getText().equals("Sin conexión")) {
                    
                    vista.jLConexion.setText("Sin conexión");
                    vista.jLConexion.setForeground(Color.RED);
                    socketCliente clienteSocket = new socketCliente(3);
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
