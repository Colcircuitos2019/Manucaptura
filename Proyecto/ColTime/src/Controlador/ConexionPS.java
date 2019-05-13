package Controlador;

import Modelo.UsuarioM;
import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.io.File;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
//import java.io.PrintStream;
import java.util.Enumeration;
import java.util.Scanner;
import javax.swing.JComboBox;
import javax.swing.JOptionPane;
import rojerusan.RSNotifyAnimated;

public class ConexionPS {

    public String mensaje = null;
    private int existePuerto = 0;
    private String v[] = null;
    private static String puertoCOM = "COM6";//Por defecto va a ser el puerto serial COM6
    private static String usuariodoc = "";
    private static SerialPort mySPCopia = null;
    OutputStream ops;
    UsuarioM model = new UsuarioM();
    //Escribir archibo plano
    int hora, minutos, segundos;
    Date fecha = new Date();
    SimpleDateFormat formato = new SimpleDateFormat("dd_MM_YYYY");

    public static SerialPort getMySPCopia() {
        return mySPCopia;
    }

    public ConexionPS() {}

    int conexion = 0;
    
//Falta validar que el puerto este abierto y disponible para poder mandar informacion, y de no ser asì se va a notificar al usuario que no puede realizar la toma de tiempo correspondiente a si àrea de producciòn.
//Composición del código: Orden;nDetalle;Negocio;IDlector;cantidadProductos;cantidadOperarios;idProceso paso
//NOTA: Las IP a la cual se va a enviar informacion son las siguiente: EN = 192.168.0.101 con Router y AP; FE y TE = 192.168.1.101 con Router y para Comercial Interno = 192.168.4.1 siin router 

    public void enlacePuertos(Menu menu) {//Ese metodo lo utilizan los roles de encargados de FE, EN y TE
        Menu obj = new Menu();
        CommPort puerto = null;
        String valorBeta = "";
        int ErrorConexionPuerto = 0;
        SerialPort mySP = null;
        try {
            //Presenta problemas en la enumeration o en el getPortIdentifiers
            Enumeration commports;//Se traen todos los puertos disponibles
            commports = CommPortIdentifier.getPortIdentifiers();
            CommPortIdentifier myCPI = null;
            Scanner mySC;
            // ...
            while (commports.hasMoreElements()) {//Se valida que el puerto que necesito este disponible
                existePuerto = 1;//Si ingreso es porque existe un puerto.
                myCPI = (CommPortIdentifier) commports.nextElement();//...
                if (myCPI.getName().equals(obj.puertoSerialActual)) {//&& myCPI.PORT_SERIAL
                    puerto = myCPI.open("Puerto Serial Operario", 1200);//Abro el puerto y le mando dos parametros que son el nombre de la apertura y el tiempo de respuesta
                    mySP = (SerialPort) puerto;
                    //                       Baudios           Data bits               stopBists                  Parity
                    mySP.setSerialPortParams(115200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);//Configuracion del puerto serial: Velocidad de bits, Data bits, stopbits y Paridad
                    //
                    mySPCopia = mySP;
//                    ops = mySP.getOutputStream();//Forma de datos de salida del puerto serial
//                    ops.write("P&-1".getBytes());
//                    ops.close();
                    if(menu.conexionServidor){
                        cambiarEstadoESP8266(mySP, "P&-1");// -> De esto se encargara la disponibilidad de conexion
                    }
//
                    mySC = new Scanner(mySP.getInputStream());//Datos de entrada al puerto
                    
                    conexion = 1;
                    //Se selecciona el item Activado de: Menu Principal>Configuración>Lectura>Activado.
                    menu.jRLActivado.setSelected(true);
                    // Cargos = 2 - Encargado de FE y TE, Encargado de EN
                    socketCliente clienteSocket = new socketCliente(menu.cargo == 2 ? new int[]{1, 2} : new int[]{3});
                    clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "act");// Actualizar estado DB de los reportes de produccion

                    //Cambio de la etiqueta del estado de lectura en la vista de menu ubicada en el menu lateral.
                    menu.estadoDeLectura();
                    //Guardar estado de lectura del puerto serial del usuario
                    menu.estadoPertoSerialOperarios();
                    //Si la Variable no cambia de valor a 1 significa que el puerto esta ocupado por algun otro programa.
                    ErrorConexionPuerto = 1;
                    // ...
                    while (true) {//Valida el mismo puerto que se abrio!!
                        
                        while (!mySC.hasNext()) {//Valida que en el puerto serial exista alguna linea de información...
                            // ...
                            mySP.isReceiveTimeoutEnabled();
                            // ...
                            mySC.close();
                            mySC = null;
                            mySC = new Scanner(mySP.getInputStream());
                            //Se va a cerrar la conexion del puerto si el usuario se salio de la sesión.
                            if (!menu.estadoLecturaPuertoCOM) {
                                
                                mySPCopia = null;
                                cambiarEstadoESP8266(mySP,"P&-0");
                                puerto.close();
                                
                                //Guardar estado de lectura del puerto serial del usuario
                                menu.estadoPertoSerialOperarios();//Estado del puerto serial Desactivado
                                break;
                                
                            }
                        }
                        
                        if (!menu.estadoLecturaPuertoCOM) {//Si se cierra la sesion del encargado de algun area de producción tambien se tiene que cerrar el puerto, de lo contrario se seguira trabajando con el puerto. 
                            break;
                        } else {
                            //Procedimiento de toma de tiempo
                            //La trama es:"N°Orden;DetalleSistema;Área;LectorID;Cantidad;N°Operarios;Proceso-Envio-Cantidades".
                            valorBeta = mySC.next();//Valor de entrada
                            // ...
                            escribirEnArchivoPlanoRecepcionDeDatos(valorBeta, "0");
                            // ...
                            if(valorBeta.split("�").length > 1){

                                cambiarEstadoESP8266(mySP,"P&-0");
                                puerto.close();
                                
                                mySPCopia = null;

                                menu.estadoLecturaPuertoCOM = false;
                                //Cambio de la etiqueta del estado de lectura en la vista de menu ubicada en el menu lateral.
                                menu.estadoDeLectura();//Desactivado
                                //Guardar estado de lectura del puerto serial
                                menu.estadoPertoSerialOperarios();//Estado de lectura del puerto es desactivado
                                
                            }else{
                                
                                if (valorBeta.split(";").length >= 6) {
                                    //Valida que el valor de entrada sea el correcto//
                                    if (Character.isDigit(valorBeta.charAt(0))) {//->Cambiar esta validacion por algo mas veridico
                                        //...

                                        if (obj.conexionServidor) {

                                            obj.LecturaCodigoQR(valorBeta);//Se encargara de ler el codigo QR
                                            //--------------------------------------------------
                                            System.gc();//Garbage collector.

                                        } else {

                                            new rojerusan.RSNotifyAnimated("Alerta!", "No se puede efectuar una captura de tiempo del producto porque no se tiene conexion con el servidor.", 4, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);

                                        }

                                    }
                                }
                                
                            }
                            //...
                        }
                        if (!menu.estadoLecturaPuertoCOM) {
                            break;
                        }
                    }
                }
            }
            // ...
            if (conexion == 0) {// 0 =No se pudo realizar la conexion, 1: Conexion realizada correactamente.
                //Se selecciona el item Activado de: Menu Principal>Configuración>Lectura>Desactivado.
                menu.jRLDesactivado.setSelected(true);//Button radio desactivado selecionado
                if (JOptionPane.showOptionDialog(null, "Error: " + "No se pudo conectar al puerto serial " + obj.puertoSerialActual + ". " + "¿Desea seleccionar otro puerto serial disponible?",
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
                        obj.puertoSerialActual = obj.ConsultarPuertoGurdadoUsuario(obj.jDocumento.getText());
                    } else {
                        menu.estadoLecturaPuertoCOM = false;
                    }
                } else {
                    menu.estadoLecturaPuertoCOM = false;
                }
                // ...
                //Guardar estado de lectura del puerto serial del usuario
                menu.estadoPertoSerialOperarios();//Estado de lectuera del puerto serial desactivado
            }
            // ...
            if (existePuerto == 0) {
                
                //Se mostrara un mensaje diciendo que no existe ningun puerto serial disponible
                JOptionPane.showMessageDialog(null, "No existe ningun puerto serial disponible, por favor conecte el dispotitivo");
                
            } else {
                
                existePuerto = 0;
                
            }
            // ...
        } catch (Exception e) {
            
            //Si la variable ErrorConexionPuerto es igual a 1 significa que se pudo establecer conexion pero se presento algune problema con el puerto.
            if (ErrorConexionPuerto == 0) {
                
                JOptionPane.showMessageDialog(null, "El puerto " + obj.puertoSerialActual + " esta abierto, por favor cierrelo para poder realizar la operación.");
                
            } else {
                
                cambiarEstadoESP8266(mySP,"P&-0");
                
                puerto.close();
            }
            
            mySPCopia = null;
            
            menu.estadoLecturaPuertoCOM = false;
            //Cambio de la etiqueta del estado de lectura en la vista de menu ubicada en el menu lateral.
            menu.estadoDeLectura();//Desactivado
            //Guardar estado de lectura del puerto serial
            menu.estadoPertoSerialOperarios();//Estado de lectura del puerto es desactivado
            
        }
    }
    // ...

    public void cambiarEstadoESP8266(SerialPort mySP, String mensaje){
        try {

            if (mySP != null) {
                
                PrintStream myPS = new PrintStream(mySP.getOutputStream());//Datos de salia del puertoS
                myPS.print(mensaje);// Estado de lectura desactivado
                myPS.close();
                
            } else {
                
                //Abrir -> Escribir -> cerrar puerto serial...
                Enumeration commports;
                commports = CommPortIdentifier.getPortIdentifiers();
                CommPortIdentifier myCPI = null;
                Menu obj = new Menu();
                CommPort puerto = null;
                
                while (commports.hasMoreElements()) {
                
                    if (myCPI.getName().equals(obj.puertoSerialActual)) {
                        
                        puerto = myCPI.open("Puerto Serial Operario", 1200);
                        mySP = (SerialPort) puerto;
                        //...
                        mySP.setSerialPortParams(115200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);//Configuracion del puerto serial: Velocidad de bits, Data bits, stopbits y Paridad
                        // ...                        
                        cambiarEstadoESP8266(mySP, "P&-0");// -> De esto se encargara la disponibilidad de conexion
                        // ...
                        
                    }
                    
                }
                
            }
            
        } catch (Exception e) {
            
            e.printStackTrace();
            
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
            while (comports.hasMoreElements()) {
                CommPortIdentifier comportIdenti = (CommPortIdentifier) comports.nextElement();
                v[pos] = comportIdenti.getName();
                pos++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return v;
    }

    public void escribirEnArchivoPlanoRecepcionDeDatos(String QR, String area) {
        try {
            //---
            Calendar calendario = Calendar.getInstance();
            PrintWriter pw = null;
            FileWriter fw = null;
            File folder = new File("C:\\Toma_Tiempo");
            // ...
            if (!folder.exists()) {
                folder.mkdirs();
            }
            //---
            File archivo = new File("C:\\Toma_Tiempo\\" + formato.format(fecha) + "_" + area + ".txt");

            if (!archivo.exists()) {

                archivo.createNewFile();

            }
            //---
            int hora = calendario.get(Calendar.HOUR_OF_DAY);
            int minutos = calendario.get(Calendar.MINUTE);
            int segundos = calendario.get(Calendar.SECOND);
            // ...
            fw = new FileWriter(archivo, true);
            pw = new PrintWriter(fw);
            pw.println(QR + " - " + hora + ':' + minutos + ':' + segundos);
            pw.close();
            // ...
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
