package Controlador;

import coltime.Menu;
import java.awt.Color;
import java.util.ArrayList;
import javax.swing.JOptionPane;

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
                    vista.serversSockets = vista.consultarServerSockets();
                    enviarInformacionSocket(vista.serversSockets, "1");//
                }
            } else {
                if (!vista.jLConexion.getText().equals("Sin conexión")) {
                    vista.jLConexion.setText("Sin conexión");
                    vista.jLConexion.setForeground(Color.RED);
                    vista.serversSockets = vista.consultarServerSockets();
                    enviarInformacionSocket(vista.serversSockets, "2");//
                }
            }
            obj.destruir();
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ex) {
//                JOptionPane.showMessageDialog(null, "Error: " + ex);
            }
        }
    }

    private void enviarInformacionSocket(ArrayList infoSocket, String mensaje){
        socketCliente cliente = new socketCliente();
        try {
            if(infoSocket!=null){
                for (int i = 0; i < infoSocket.size(); i++) {

                    String servidor[] = (String[])infoSocket.get(i);
                    // Direccion IP, Puerto de comunicación y mensaje a enviar al servidor...
                    cliente.enviarInformacionServerSocket(servidor[0], Integer.parseInt(servidor[1]), mensaje);
                } 
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}

//class socketC {
//
//    private String direccionIP ="";
//    private int area = 0;
//    public socketC(){}
//
//    public String getDireccionIP() {
//        return direccionIP;
//    }
//
//    public int getArea() {
//        return area;
//    }
//
//}