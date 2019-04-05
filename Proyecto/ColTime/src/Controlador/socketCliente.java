
package Controlador;

import Modelo.socketServerM;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.rowset.CachedRowSet;

public class socketCliente {
   
    private final String ipServerSocket = "192.168.4.173";
    private Socket cliente;
    private final int puerto = 5000;
    private int mensaje =0;
    private int area =0;
    // ...
    DataOutputStream outPut = null;
    DataInputStream inPut = null;
    // ...
    
    public socketCliente(int mensaje, int area){
        this.mensaje = mensaje;
        this.area = area;
    }

    public boolean enviarInformacionServerSocket( String ipServerSocket, int puerto){
        boolean respueta = false;
        try {
            cliente = new Socket();//Establecer conexion con el serversocket
            cliente.connect(new InetSocketAddress(ipServerSocket, puerto), 500);
            
            outPut = new DataOutputStream(cliente.getOutputStream());// Enviar mensaje
            outPut.writeUTF("true");
            
            cliente.close();// Desconectar el socket cliente
            
            respueta = true;
            
        } catch (IOException ex) {
            Logger.getLogger(socketCliente.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return respueta;
    }
    
    public CachedRowSet consultarServidoresReportes(){
        socketServerM modelo = new socketServerM();
        return modelo.consultarServidorSocketReporteM(area);
    }
    
    public boolean gestionarDireccionServidor(String direccionIP, int area, int estado){
        socketServerM modelo = new socketServerM();
        return modelo.gestionarDireccionServidorM(direccionIP, area, estado);
    }
            
}
