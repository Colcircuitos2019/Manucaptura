package reporteen;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class socketServidor {
    
    private final int PUERTO = 5000;
    private ServerSocket servidor=null;
    private Socket cliente = null;
    
    DataInputStream input;
    DataOutputStream output;
    
    String mensaje="";
    
    public socketServidor(){}
    
    public void iniciarServerSocket(){
        
        try {
            
            servidor = new ServerSocket(PUERTO);
            
        } catch (IOException ex) {
            Logger.getLogger(socketServidor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    public void iniciarEstadoLecturaSersocket(){
        
        try {

            while (true) {

                cliente = servidor.accept();

                input = new DataInputStream(cliente.getInputStream());
                mensaje = input.readUTF();
                
                
            }
            
        } catch (IOException ex) {
            Logger.getLogger(socketServidor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    
}
