package coltime;

import Modelo.Conexion;

public class ColTime {

    public static void main(String[] args) {

        //Iniciar el proyecto
        Login log = new Login();
        log.setLocationRelativeTo(null);
        log.setVisible(true);
        
//        Conexion obj=new Conexion();
//        obj.establecerConexion();
        //Finaliza el proyecto
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
