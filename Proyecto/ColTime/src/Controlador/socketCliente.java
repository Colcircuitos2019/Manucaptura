
package Controlador;

import Modelo.socketServerM;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.rowset.CachedRowSet;

public class socketCliente {
   
    private Socket cliente;
    private int area =0;
    /* Área:
        0 = Todas las areas de producción
        1 = Reportes abiertos de FE - Formato Estandar
        2 = Reportes abiertos de TE - Teclados 
        3 = Reportes abiertos de EN - Ensamble 
    */
    // ...
    DataOutputStream outPut = null;
    DataInputStream inPut = null;
    // ...
    
    public socketCliente(int area){
        this.area = area;
    }
    public socketCliente(){}
 
    public void enviarInformacionSocketserver(ArrayList infoSocketServer, String mensaje) {
        try {
            if (infoSocketServer != null) {
                for (int i = 0; i < infoSocketServer.size(); i++) {

                    String servidor[] = (String[]) infoSocketServer.get(i);

                    cliente = new Socket();//Establecer conexion con el serversocket
                    cliente.connect(new InetSocketAddress(servidor[0], Integer.parseInt(servidor[1])), 2000);//Ruta de conexion(IP y puerto) y tiempo de espera
                    // ...
                    outPut = new DataOutputStream(cliente.getOutputStream());// Enviar mensaje
                    outPut.writeUTF(mensaje);
                    // ...
                    cliente.close();
                    
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public ArrayList<Object> consultarServerSockets() {// Son todos los server sockets de los reportes en general independientemente del área
        // ...
        ArrayList<Object> serverScoekts = null;
        // ...
        CachedRowSet crs = consultarServidoresReportes();
        if (crs != null) {

            serverScoekts = new ArrayList<Object>();

            try {
                while (crs.next()) {

                    serverScoekts.add(new String[]{crs.getString("ipServidor"), (crs.getString("puerto"))});

                }
            } catch (Exception ex) {
                Logger.getLogger(socketCliente.class.getName()).log(Level.SEVERE, null, ex);
            }
            // ...
        }
        return serverScoekts;
    }
    
    public CachedRowSet consultarServidoresReportes(){
        
        socketServerM modelo = new socketServerM();
        return modelo.consultarServidorSocketReporteM(area);
        
    }
    
    public boolean gestionarDireccionServidor(String direccionIP, int area, int programa ,int estado, String puerto){
        
        socketServerM modelo = new socketServerM();
        return modelo.gestionarDireccionServidorM(direccionIP, area, programa, estado, puerto);
        
    }
            
}
