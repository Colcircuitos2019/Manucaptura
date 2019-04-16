package Controlador;

import Modelo.socketServerM;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.logging.Level;
import java.util.logging.Logger;

public class socketServidor implements Runnable {
    
    private int puerto = 0;
    private int soloUnaVez = 0;
    private int cargo = 0;
    private ServerSocket servidor=null;
    private Socket cliente = null;
    
    DataInputStream input;
    DataOutputStream output;
    
    String mensaje="";
    
    public socketServidor(int cargo){
        
        //Cargos 2- Encargado de FE y TE, 3-Encargado de EN
        if(cargo==3){
            this.cargo = cargo;
        }
        
    }
   
    @Override
    public void run() {
       
//        while(true){
            
            if(soloUnaVez == 0){
                
                puerto = consultarPuertoComunicacionServidor(consultarDireccionIPServer(), 0, cargo);// --> el programa tamiben tiene que ser versatil
                soloUnaVez = 1;
                
            }
            
            if(iniciarServerSocket()){
                
                iniciarEstadoLecturaSersocket();
                
            }
            
//        }
        
    }
    
    public boolean iniciarServerSocket(){
        boolean respuesta = false;
        try {
            
            // ...
            servidor = new ServerSocket(puerto);
            gestionDireccionServidor(consultarDireccionIPServer(), cargo, String.valueOf(puerto));
            respuesta = true;
            // ...
            
        } catch (IOException ex) {
            
            Logger.getLogger(socketServidor.class.getName()).log(Level.SEVERE, null, ex);
            // El puerto se va a cambiar por seguridad ... 
            puerto =(int) (Math.random() * 1000) + 5000;
        }
        
        return respuesta;
    }
    
    public void iniciarEstadoLecturaSersocket(){
        
        try {

            while (true) {

//                System.out.println(consultarDireccionIPServer()+":"+puerto);
                cliente = servidor.accept();

                input = new DataInputStream(cliente.getInputStream());
                mensaje = input.readUTF();
                
                cliente.close();
            }
            
        } catch (IOException ex) {
            Logger.getLogger(socketServidor.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
    
    public void cerrarServidorSocket(){
        try {
            
            servidor.close();
            
        } catch (IOException ex) {
            Logger.getLogger(socketServidor.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    private boolean gestionDireccionServidor(String direccionIP, int programa, String puerto) {
        
        socketServerM modelo = new socketServerM();
        return modelo.gestionarDireccionServidorM(direccionIP, 0, programa, 0,puerto);

    }

    private String consultarDireccionIPServer() {

        String direccionIP = "";
        try {
            direccionIP = String.valueOf(InetAddress.getLocalHost()).split("/")[1];
        } catch (Exception e) {
            e.printStackTrace();
        }
        return direccionIP;
    }
    
    private int consultarPuertoComunicacionServidor(String direccionIP, int area, int programa) {
        
        socketServerM modelo = new socketServerM();
        int puerto = modelo.consultarPuertoComunicacionservidorM(direccionIP, area, programa);
        if (puerto != 0) {
            return puerto;
        } else {
            return (int) (Math.random() * 1000) + 5000;// Puerto aleatorio entre el 5000 - 6000
        }

    }
    
}
