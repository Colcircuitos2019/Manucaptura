package reporteen;

import java.awt.Color;
//import java.util.logging.Level;
//import java.util.logging.Logger;
import javax.swing.JOptionPane;

public class DisponibilidadConexion implements Runnable {

    Color green = new Color(0, 185, 0);

    @Override
    public void run() {
        EN vista = new EN();
        while (true) {
            Conexion obj = new Conexion(1);
            obj.establecerConexion();
            if (obj.getConexion() != null) {
                vista.jLConexion.setText("Linea");
                vista.jLConexion.setForeground(green);
            } else {
                vista.jLConexion.setText("Sin conexión");
                vista.jLConexion.setForeground(Color.RED);
            }
            obj.destruir();
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
