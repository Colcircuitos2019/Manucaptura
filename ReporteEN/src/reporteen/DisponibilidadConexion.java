package reporteen;

import java.awt.Color;
//import java.util.logging.Level;
//import java.util.logging.Logger;
import javax.swing.JOptionPane;

public class DisponibilidadConexion implements Runnable {

    Color green = new Color(0, 185, 0);
    EN objEN;    
    
    public DisponibilidadConexion(EN obj){
        this.objEN=obj;
    }
    
    @Override
    public void run() {// Eesta clase se va a eliminar ya no es necesaria...
//      EN vista = new EN();
        while (true) {
            Conexion conexion = new Conexion(1,objEN);
            conexion.establecerConexion();
            if (conexion.getConexion() != null) {
                objEN.jLConexion.setText("Linea");
                objEN.jLConexion.setForeground(green);
            } else {
                objEN.jLConexion.setText("Sin conexión");
                objEN.jLConexion.setForeground(Color.RED);
            }
            conexion.destruir();
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ex) {
//                JOptionPane.showMessageDialog(null, "Error: " + ex);
            }
        }
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
