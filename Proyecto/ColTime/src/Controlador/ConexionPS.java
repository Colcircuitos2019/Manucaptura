package Controlador;

import Vistas.Inicio;
import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
//import java.io.PrintStream;
import java.util.Enumeration;
import java.util.Scanner;
import javax.swing.JComboBox;
import javax.swing.JOptionPane;

public class ConexionPS {

    public String mensaje = null;
    private int existePuerto = 0;
    private String v[] = null;
    private static String puertoCOM = "COM6";//Por defecto va a ser el puerto serial COM6
    private static String usuariodoc = "";
    //Escribir archibo plano
    int hora, minutos, segundos;
    Date fecha = new Date();
    SimpleDateFormat formato = new SimpleDateFormat("dd_MM_YYYY");

    public ConexionPS() {//Constructos
    }

    int conexion = 0;
//Falta validar que el puerto este abierto y disponible para poder mandar informacion, y de no ser asì se va a notificar al usuario que no puede realizar la toma de tiempo correspondiente a si àrea de producciòn.
//Composición del código: Orden;nDetalle;Negocio;IDlector;cantidadProductos;cantidadOperarios;idProceso paso
//NOTA: Las IP a la cual se va a enviar informacion son las siguiente: EN = 192.168.0.101 con Router y AP; FE y TE = 192.168.1.101 con Router y para Comercial Interno = 192.168.4.1 siin router 
    public void enlacePuertos(Menu menu) {//Ese metodo lo utilizan los roles de encargados de FE, EN y TE
        Menu obj = new Menu();
        CommPort puerto = null;
        String valorBeta = "";
        int ErrorConexionPuerto = 0;
        try {
            //Presenta problemas en la enumeration o en el getPortIdentifiers
            Enumeration commports;//Se traen todos los puertos disponibles
            commports = CommPortIdentifier.getPortIdentifiers();
//            JOptionPane.showMessageDialog(null, "Esta en estado de lectura");
            CommPortIdentifier myCPI = null;
            Scanner mySC;
            while (commports.hasMoreElements()) {//Se valida que el puerto que necesito este disponible
                existePuerto = 1;//Si ingreso es porque existe un puerto.
                myCPI = (CommPortIdentifier) commports.nextElement();
                if (myCPI.getName().equals(obj.puertoActual)) {//&& myCPI.PORT_SERIAL
                    puerto = myCPI.open("Puerto Serial Operario", 1200);//Abro el puerto y le mando dos parametros que son el nombre de la apertura y el tiempo de respuesta
                    SerialPort mySP = (SerialPort) puerto;
                    //                       Baudios           Data bits               stopBists                  Parity
                    mySP.setSerialPortParams(115200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);//Configuracion del puerto serial: Velocidad de bits, Data bits, stopbits y Paridad
                    //
                    mySC = new Scanner(mySP.getInputStream());//Datos de entrada al puerto
                    //obj.myPS = new PrintStream(mySP.getOutputStream());//Datos de salia del puertoS
                    conexion = 1;
                    //Se selecciona el item Activado de: Menu Principal>Configuración>Lectura>Activado.
                    menu.jRLActivado.setSelected(true);
                    //Cambio de la etiqueta del estado de lectura en la vista de menu ubicada en el menu lateral.
                    menu.estadoDeLectura();
                    //Si la Variable no cambia de valor a 1 significa que el puerto esta ocupado por algun otro programa.
                    ErrorConexionPuerto = 1;
                    //
                    while (true) {//Valida el mismo puerto que se abrio!!
                        while (!mySC.hasNext()) {//Valida que en el puerto serial exista alguna linea de información...
                            //Valida que el puerto serial tenga un tiempo de respues, si no lo tiene el sistema lo dara como que el puerto serial fue desconectado del equipo.
                            //Y saltara una execión en el Try Catch
                            mySP.isReceiveTimeoutEnabled();
                            //Validar cuando se desconecta el puerto.
                            mySC.close();
                            mySC = null;
                            mySC = new Scanner(mySP.getInputStream());
                            //Se va a cerrar la conexion del puerto si el usuario se salio de la sesión.
                            if (!menu.diponible) {
                                puerto.close();
                                break;
                            }
                        }
                        if (!menu.diponible) {//Si se cierra la sesion del encargado de algun area de producción tambien se tiene que cerrar el puerto, de lo contrario se seguira trabajando con el puerto. 
                            break;
                        } else {
                            //Procedimiento de toma de tiempo                                              //
                            //La trama es:"N°Orden;DetalleSistema;Área;LectorID;Cantidad;N°Operarios;Proceso-Envio-Cantidades".
                            valorBeta = mySC.next();//Valor de entrada
                            //...
                            //Se encarga de escribir en un archivo plano los códigos que son leidos del puerto serial.
                            escribirRecepcionDatos(valorBeta);
                            //...
                            //La longitud del vector del codigo QR tiene que ser de 6 o 7 espacios, tambien el proceso que recibe tiene que ser diferente a 0 si el proceso no es 18="Empaque"
                            String infoP[] = valorBeta.split(";");//Validar Código QR
//                            if (infoP.length == 6 || (infoP.length == 7 && ((!infoP[6].equals("0") && !infoP[3].equals("18")) || ((infoP[6].equals("0") || !infoP[6].equals("18")) && infoP[3].equals("18"))))) {
                            //El codigo de operario siempre va a contener una longitud del vecto de 6 espaciós en la memoria EEPROM
                                //...
                                if (Character.isDigit(valorBeta.charAt(1))) {//Valida que el valor de entrada sea el correcto//Funcionamiento con wifi
                                    //...
                                    obj.LecturaCodigoQR(valorBeta);//Se encargara de ler el codigo QR
//                                    System.out.println(valorBeta);
                                    //--------------------------------------------------
                                    //Limpieza de la memoria RAM
                                    System.gc();//Garbage collector.  
                                }
//                            }
                            //...
                        }
                        if (!menu.diponible) {
                            break;
                        }
                    }
                }
            }
            //
            if (conexion == 0) {// 0 =No se pudo realizar la conexion, 1: Conexion realizada correactamente.
                //Se selecciona el item Activado de: Menu Principal>Configuración>Lectura>Desactivado.
                menu.jRLDesactivado.setSelected(true);//Activado
                if (JOptionPane.showOptionDialog(null, "Error: " + "No se pudo conectar al puerto serial " + obj.puertoActual + ". " + "¿Desea seleccionar otro puerto serial disponible?",
                        "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                        JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                        new Object[]{"SI", "NO"}, "SI") == 0) {
                    //Se podra modificar el puerto
                    puertosDisponibles();
                    Object dig = JOptionPane.showInputDialog(new JComboBox(),
                            "Seleccione el puerto",
                            "Selector de opciones",
                            JOptionPane.QUESTION_MESSAGE,
                            null, // null para icono defecto
                            vectorObjet(v),
                            "Cantidad proyectos área");
                    if (dig != null) {
                        Usuario reg = new Usuario();
                        //Se registra o se modifica el puerto serial COM que el usuario selecciono.
                        reg.RegistrarModificarPuertoSerialUsuario(obj.jDocumento.getText(), dig.toString());
                        //Asignamos el nuevo puerto seria COM a la variable global.
                        obj.puertoActual = obj.ConsultarPueroGurdado(obj.jDocumento.getText());
                    } else {
                        menu.diponible = false;
                    }
                } else {
                    menu.diponible = false;
                }
            }
            //
            if (existePuerto == 0) {//Se mostrara un mensaje diciendo que no existe ningun puerto serial disponible
                JOptionPane.showMessageDialog(null, "No existe ningun puerto serial disponible, por favor conecte el dispotitivo");
            } else {
                existePuerto = 0;
            }
            //
        } catch (Exception e) {
            //JOptionPane.showMessageDialog(null, "Error: " + e);
            //Si la variable ErrorConexionPuerto es igual a 1 significa que se pudo establecer conexion pero se presento algune problema con el puerto.
            if (ErrorConexionPuerto == 0) {
                JOptionPane.showMessageDialog(null, "El puerto " + obj.puertoActual + " esta abierto, por favor cierrelo para poder realizar la operación.");
            }else{
                puerto.close();
            } 
            menu.diponible = false;
            //Cambio de la etiqueta del estado de lectura en la vista de menu ubicada en el menu lateral.
            menu.estadoDeLectura();//Desactivado
            //
        }
    }

    public String[] puertosDisponibles() {
        int pos = 0;
        try {
            //Se utiliza para saber que longitud se va a realizar el vector
            Enumeration comports = CommPortIdentifier.getPortIdentifiers();
            while (comports.hasMoreElements()) {
                comports.nextElement();
                pos++;
            }
            v = new String[pos];
            pos = 0;
            comports = CommPortIdentifier.getPortIdentifiers();
            //Se a gregan lo valores al vector con longitud ya definida
//            v[0] = "Seleccione...";
            while (comports.hasMoreElements()) {
                CommPortIdentifier comportIdenti = (CommPortIdentifier) comports.nextElement();
                v[pos] = comportIdenti.getName();
                pos++;
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        return v;
    }

    public void escribirRecepcionDatos(String QR) {
        //---
        Calendar calendario = Calendar.getInstance();
        PrintWriter pw = null;
        FileWriter fw = null;
        File folder = new File("C:\\FormatoEstandar");
        if (!folder.exists()) {
            folder.mkdirs();
        }
        //---
        File archivo = new File("C:\\FormatoEstandar\\" + formato.format(fecha) + ".txt");
        if (!archivo.exists()) {
            try {
                archivo.createNewFile();
            } catch (Exception e) {
                //error
                e.printStackTrace();
            }
        }
        //---
        try {
            int hora = calendario.get(Calendar.HOUR_OF_DAY);
            int minutos = calendario.get(Calendar.MINUTE);
            int segundos = calendario.get(Calendar.SECOND);

            fw = new FileWriter(archivo, true);
            pw = new PrintWriter(fw);
            pw.println(QR + '-' + hora + ':' + minutos + ':' + segundos);
            pw.close();
            String documento = "";
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Object[] vectorObjet(String v[]) {
        Object items[] = new Object[v.length];
        for (int i = 0; i < items.length; i++) {
            items[i] = v[i];
        }
        v = null;
        return items;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
