
package Controlador;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class socketCliente {
   
    private final String ipServerSocket = "192.168.4.234";
    private Socket cliente;
    private final int puerto = 5000;
    private int mensaje =0;
    // ...
    DataOutputStream outPut = null;
    DataInputStream inPut = null;
    // ...
    
    public socketCliente(int mensaje){
        this.mensaje = mensaje;
    }

    public boolean enviarInformacionServerSocket(){
        boolean respueta = false;
        try {
            cliente = new Socket(ipServerSocket, puerto);//Establecer conexion con el serversocket
            
            outPut = new DataOutputStream(cliente.getOutputStream());// Enviar mensaje
            outPut.writeUTF("true");
            
            cliente.close();// Desconectar el socket cliente
            
            respueta = true;
            
        } catch (IOException ex) {
            Logger.getLogger(socketCliente.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return respueta;
    }
    
    // Getter and Setter
//    public int getMensaje() {
//        return mensaje;
//    }
//
//    public void setMensaje(int mensaje) {
//        this.mensaje = mensaje;
//    }
    
    
    
}
