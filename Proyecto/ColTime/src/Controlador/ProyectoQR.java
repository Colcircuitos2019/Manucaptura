package Controlador;

import Vistas.proyecto;
import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.awt.Color;
//import gnu.io.SerialPortEvent;
//import gnu.io.SerialPortEventListener;
//import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Scanner;
//import static javax.print.attribute.Size2DSyntax.MM;
import javax.swing.JOptionPane;
import rojerusan.RSNotifyAnimated;
//Organizar esta clase porque esta demasiado desorganizada.
public class ProyectoQR implements Runnable {
//Se encarga de realizar la conexion del el puerto serial COM para el ingreso de proyectos mediante QR de proyectos.
    //Variables 
    Thread QRProyecto = null;
    public CommPort puerto = null;
    int puertoProyecto = 0;
    proyecto obj = new proyecto();
    SimpleDateFormat formatoDelTexto = new SimpleDateFormat("yyyy/MM/dd");
    Menu menu = new Menu();
    proyecto pro = null;

    //...
    public ProyectoQR(proyecto pro) {
        Thread QRProyecto = new Thread(this);
        this.pro = pro;
        QRProyecto.start();
    }
    //La direccion IP que va a enviar informacion al modulo del administrador es siempre: 192.168.4.1
    @Override
    public void run() {
        proyectoQR();
//        int abierto = 1;
//        while (abierto == 1) {
//            String valor = proyectoQR();
//            if (!this.pro.disponibilidad) {
//                break;
//            }
//            if (puertoProyecto == 1) {
//                puertoProyecto = 0;
//                llenarCamposFormProyectos(valor);
//                abierto = 1;
//            } else {
//                //No se pudo establecer la conexión con el puerto COM, desea cambiarlo o volver a intentar? 
//                if (JOptionPane.showOptionDialog(null, "No se pudo establecer la conexión con el puerto COM, ¿desea volver a intentarlo?",
//                        "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
//                        JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
//                        new Object[]{"SI", "NO"}, "SI") == 0) {
//                    abierto = 1;
//                } else {
//                    abierto = 0;
//                    //QRProyecto.isInterrupted();
//                }
//            }
//        }
//        obj.jLEstado.setText("Desactivado");
//        obj.jLEstado.setForeground(new Color(255,0,51));//red
//        obj.lector = null;
    }

    private void proyectoQR() {
        String valorQR = "";
        int ErrorConexionPuerto =0;
        try {
            Enumeration commports = CommPortIdentifier.getPortIdentifiers();//Enumeracion de todos los puertos.
            CommPortIdentifier myCPI = null;
            Scanner mySC;
            while (commports.hasMoreElements()) {
                myCPI = (CommPortIdentifier) commports.nextElement();
                if (myCPI.getName().equals(menu.puertoActual)) {//Localización del puerto 
                    puertoProyecto = 1;
                    puerto = myCPI.open("Puerto serial Proyecto", 1000);//Apertura Time y nombre del puerto
                    SerialPort mySP = (SerialPort) puerto;
                    //Configuracion del puerto
                    mySP.setSerialPortParams(115200, SerialPort.DATABITS_8, SerialPort.STOPBITS_1, SerialPort.PARITY_NONE);
                    mySC = new Scanner(mySP.getInputStream());//Datos de entrada al puerto
                    ErrorConexionPuerto=1;
                    obj.jLEstado.setText("Activado");
                    obj.jLEstado.setForeground(new Color(51,204,0));//Green- estos colores pueden ser variables estaticas
                    //----------------------------------------------------------
                    while (true) {
                        while (!mySC.hasNext()) {//Valida la informacion que va a ingresar!!
                            //Verificara el tiempo de espera para leer el puerto. si se demora más de lo debido significa que el dispositivo de comunicacion serial esta desconectado
                            //Automaticamente esto se cumpla, esto saltara al try catch
                            mySP.isReceiveTimeoutEnabled();
                            //...
                            mySC.close();
                            mySC = null;
                            mySC = new Scanner(mySP.getInputStream());
//                            Thread.sleep(4);
                            if (!this.pro.disponibilidad) {//Si ya no se va a esperar nada del puerto se va a cerrar
                                puerto.close();
                                break;
                            }
                        }
                        if (!this.pro.disponibilidad) {//se sale de la espera del dato en el puerto
                            break;
                        } else {
                            valorQR = mySC.next();
//                            String sub = valor.substring(0, 1);
                            System.out.println(valorQR);
                            //...
//                            String cadenaCompleata = "";
//                            cadenaCompleata = cadenaCompleata + valor + "\n";
//                            System.out.println(cadenaCompleata);
//                            System.out.println(valor.split(";").length + " " + valor);
                            if (Character.isDigit(valorQR.charAt(1))) {
                                //Procesar informacion QR
                                llenarCamposFormProyectos(valorQR);
                            }
                        }
                    }
                    //----------------------------------------------------------
                }
                if (!this.pro.disponibilidad) {
                    break;
                }
            }
            //...
            if(puertoProyecto==0){
                obj.jLEstado.setText("Desactivado");
                obj.jLEstado.setForeground(new Color(255, 0, 51));//red
                obj.lector = null;
            }else{
                obj.lector = null;
            }
        } catch (Exception e) {
            //Error al leer por el puerto serial.
            this.pro.disponibilidad=false;
//            puerto.close();
            if (ErrorConexionPuerto == 0) {
                JOptionPane.showMessageDialog(null, "El puerto " + menu.puertoActual + " esta abierto, por favor cierrelo para poder realizar la operación.");
            } else {
                puerto.close();
                obj.jLEstado.setText("Desactivado");
                obj.jLEstado.setForeground(new Color(255, 0, 51));//red
                obj.lector = null;
            } 
        }
//        return valorQR;
    }

    public void llenarCamposFormProyectos(String QRProyecto) {
        //Registro de proyecto mediante lectura de codigo QR (Actual)
        //29359;Micro Hom Cali S.A.S;Control Planta;FE;Normal;15/01/2018;null;null;null;null;25;TH;SI;SI;null;null;NO;NO;null;null;null;null;null;null;null;null
        String nombreCliente = "";
//      String valor[] = null;
        try {
//            String cadena = "";
//            if (valor.length == 26) {
//                for (int i = 1; i <= 4; i++) {
//                    if (i == 4) {
//                        cadena = cadena + valor[i];
//                    } else {
//                        cadena = cadena + valor[i] + "/";
//                    }
//                }
//            }
            //...
//            System.out.println(QRProyecto.split(";").length);
            //...
            if (QRProyecto.split(";").length == 26) {//La longitud del vector siempre va a ser 26
//                valor = QRProyecto.split("/");//Quita el primer "/" de la trama ingresada
//                //...
//                for (int i = 1; i <= 4; i++) {
//                    if (i == 4) {
//                        cadena = cadena + valor[i];
//                    } else {
//                        cadena = cadena + valor[i] + "/";
//                    }
//                }
                //Envio de información...
                String InformacionProyecto[] = QRProyecto.split(";");
                obj.jTNorden.setText(InformacionProyecto[0]);//Numero de orden
                String infoC[] = InformacionProyecto[1].split("-");
                for (int i = 0; i < infoC.length; i++) {
                    nombreCliente += infoC[i] + " ";
                }
                obj.jTNombreCliente.setText(nombreCliente);//Nombre del cliente
                nombreCliente = "";
                String infoP[] = InformacionProyecto[2].split("-");
                for (int i = 0; i < infoP.length; i++) {
                    nombreCliente += infoP[i] + " ";
                }
                obj.jTNombreProyecto.setText(nombreCliente);//Nombre del proyecto
                obj.cbNegocio.setSelectedItem(InformacionProyecto[3]);//Negocios implicados
                obj.cbTipo.setSelectedItem(InformacionProyecto[4]);//Tipo de proyecto
                obj.jDentrega.setDate(formatoDelTexto.parse(InformacionProyecto[5]));//Fecha de entrega al cliente
                if (!InformacionProyecto[6].equals("null")) {//Conversor
                    obj.jCConversor.setSelected(true);
                    obj.jTConversor.setText(InformacionProyecto[6]);
                    obj.jTConversor.setEnabled(true);
                }
                if (!InformacionProyecto[7].equals("null")) {//Troquel
                    obj.jCTroquel.setSelected(true);
                    obj.jTTroquel.setText(InformacionProyecto[7]);
                    obj.jTTroquel.setEnabled(true);
                }
                if (!InformacionProyecto[8].equals("null")) {//Repujado
                    obj.jCRepujado.setSelected(true);
                    obj.jTRepujado.setText(InformacionProyecto[8]);
                    obj.jTRepujado.setEnabled(true);
                }
                if (!InformacionProyecto[9].equals("null")) {//Stencil
                    obj.jCStencil.setSelected(true);
                    obj.jTStencil.setText(InformacionProyecto[9]);
                    obj.jTStencil.setEnabled(true);
                }
                if (!InformacionProyecto[10].equals("null")) {//Circuito de FE
                    obj.jCCircuito.setSelected(true);
                    obj.jTCircuito.setText(InformacionProyecto[10]);
                    obj.jTCircuito.setEnabled(true);
                    obj.cbMaterialCircuito.setSelectedItem(InformacionProyecto[11]);
                    obj.cbMaterialCircuito.setEnabled(true);
                    obj.jCAntisolderC.setSelected(InformacionProyecto[12].toUpperCase().equals("SI"));
                    obj.jCRuteoC.setSelected(InformacionProyecto[13].toUpperCase().equals("SI"));
                }
                if (!InformacionProyecto[14].equals("null")) {//PCB TE
                    obj.jCPCBTE.setSelected(true);
                    obj.jTPCBTE.setText(InformacionProyecto[14]);
                    obj.jTPCBTE.setEnabled(true);
                    obj.cbMaterialPCBTE.setSelectedItem(InformacionProyecto[15]);
                    obj.cbMaterialPCBTE.setEnabled(true);
                    obj.jCAntisolderP.setSelected(InformacionProyecto[16].toUpperCase().equals("SI"));
                    obj.jCRuteoP.setSelected(InformacionProyecto[17].toUpperCase().equals("SI"));
                    obj.jRPCBCOM.setSelected(InformacionProyecto[18].toUpperCase().equals("SI"));
                    obj.jRPCBCOM.setEnabled(true);
                    obj.jRPIntegracion.setSelected(InformacionProyecto[19].toUpperCase().equals("SI"));
                    obj.jRPIntegracion.setEnabled(true);
                    if (obj.jRPCBCOM.isSelected()) {//Componentes de la PCB del teclado
                        obj.jDFechaEntregaPCBCOMGF.setVisible(true);
                        if (!InformacionProyecto[25].equals("null")) {
                            obj.jDFechaEntregaPCBCOMGF.setDate(formatoDelTexto.parse(InformacionProyecto[25]));//Fecha de entrega de componentes de la PCB_TE:
                        }
                        obj.jLpcbGF.setVisible(true);
                    }
                    if (obj.jRPIntegracion.isSelected()) {//Integración de la PCB del teclado 
                        obj.jDFechaEntregaPCBGF.setVisible(true);
                        if (!InformacionProyecto[24].equals("null")) {
                            obj.jDFechaEntregaPCBGF.setDate(formatoDelTexto.parse(InformacionProyecto[24]));//Fecha de entrega de la PCB_TE(TH,FV,GF)a ensamble:
                        }
                        obj.jLCircuitoGF.setVisible(true);
                    }
                }
                if (!InformacionProyecto[20].equals("null")) {//Teclado
                    obj.jCTeclado.setSelected(true);
                    obj.jTTeclado.setText(InformacionProyecto[20]);
                    obj.jTTeclado.setEnabled(true);
                }
                if (!InformacionProyecto[21].equals("null")) {//Ensamble
                    obj.jCIntegracion.setSelected(true);
                    obj.jTIntegracion.setText(InformacionProyecto[21]);
                    obj.jTIntegracion.setEnabled(true);
                }
                if (obj.jCCircuito.isSelected() && obj.jCIntegracion.isSelected()) {//Esto se le conoce como integración.
                    obj.jLComCircuitos.setVisible(true);
                    if (!InformacionProyecto[23].equals("null")) {
                        obj.jDFechaEntregaFECOM.setDate(formatoDelTexto.parse(InformacionProyecto[23]));//Fecha de entrega de los componentes del circuito_FE:
                    }
                    obj.jDFechaEntregaFECOM.setVisible(true);
                    obj.jLCircuitoFE.setVisible(true);
                    if (!InformacionProyecto[22].equals("null")) {
                        obj.jDFechaEntregaFE.setDate(formatoDelTexto.parse(InformacionProyecto[22]));//Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble:
                    }
                    obj.jDFechaEntregaFE.setVisible(true);
                }
                if (obj.jTNombreCliente.getText().length() > 0 && obj.jTNombreProyecto.getText().length() > 0 && obj.jDentrega.getDate() != null && !obj.cbNegocio.getSelectedItem().toString().equals("Seleccione...")
                        && !obj.cbTipo.getSelectedItem().toString().equals("Seleccione...")) {
                    obj.btnGuardar.setEnabled(true);
                }
                //Me va a guardar directamente la informacion del proyecto
                obj.accionBtnGuardarProyecto();
                //...
            } else {
                //Mensaje...
                //Al QR del proyecto le falta información para poder realizar el registro
                new rojerusan.RSNotifyAnimated("¡Alerta!", "El código QR esta mal estructurado.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        obj.lector = null;
        //Fin de la lectura del Código QR del proyecto.
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
//    Trama que me envia el modulo wifi al puerto COM.
//GET /29359;Micro-Hom-Cali-S.A.S;Control-Planta;FE/TE;Normal;15/02/2018;2;null;null;null;null;null;no;no;null;null;no;no;null;null;null;null;null;null;null;null HTTP/1.1
//.Host: 192.168.4.1
//.Connection: keep-alive
//.Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
//.User-Agent: Mozilla/5.0 (Linux; Android 4.4.2; SM-G313ML Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36
//.Accept-Encoding: gzip,deflate
//.Accept-Language: es-US,en-US;q=0.8
//.X-Requested-With: appinventor.ai_Adimaro_montoya.Manucaptura_WIFI

}
