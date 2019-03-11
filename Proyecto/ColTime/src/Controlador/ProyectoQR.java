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
    proyecto viewProyecto = new proyecto();
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
                    viewProyecto.jLEstado.setText("Activado");
                    viewProyecto.jLEstado.setForeground(new Color(51,204,0));//Green- estos colores pueden ser variables estaticas
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
                viewProyecto.jLEstado.setText("Desactivado");
                viewProyecto.jLEstado.setForeground(new Color(255, 0, 51));//red
                viewProyecto.lector = null;
            }else{
                viewProyecto.lector = null;
            }
        } catch (Exception e) {
            //Error al leer por el puerto serial.
            this.pro.disponibilidad=false;
//            puerto.close();
            if (ErrorConexionPuerto == 0) {
                JOptionPane.showMessageDialog(null, "El puerto " + menu.puertoActual + " esta abierto, por favor cierrelo para poder realizar la operación.");
            } else {
                puerto.close();
                viewProyecto.jLEstado.setText("Desactivado");
                viewProyecto.jLEstado.setForeground(new Color(255, 0, 51));//red
                viewProyecto.lector = null;
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
            //...
            if (QRProyecto.split(";").length == 26) {//La longitud del vector siempre va a ser 26 <---- LA estructura del QR va a cambiar...
                //Envio de información...
                String InformacionProyecto[] = QRProyecto.split(";");
                viewProyecto.jTNorden.setText(InformacionProyecto[0]);//Numero de orden
                String infoC[] = InformacionProyecto[1].split("-");
                for (int i = 0; i < infoC.length; i++) {
                    nombreCliente += infoC[i] + " ";
                }
                viewProyecto.jTNombreCliente.setText(nombreCliente);//Nombre del cliente
                nombreCliente = "";
                String infoP[] = InformacionProyecto[2].split("-");
                for (int i = 0; i < infoP.length; i++) {
                    nombreCliente += infoP[i] + " ";
                }
                viewProyecto.jTNombreProyecto.setText(nombreCliente);//Nombre del proyecto
                viewProyecto.cbTipoEjecucion.setSelectedItem(InformacionProyecto[4]);//Tipo de proyecto
                viewProyecto.jDeEntrega.setDate(formatoDelTexto.parse(InformacionProyecto[5]));//Fecha de entrega al cliente
                if (!InformacionProyecto[6].equals("null")) {//Conversor
                    viewProyecto.jCConversor.setSelected(true);
                    viewProyecto.jTConversor.setText(InformacionProyecto[6]);
                    viewProyecto.jTConversor.setEnabled(true);
                }
                if (!InformacionProyecto[7].equals("null")) {//Troquel
                    viewProyecto.jCTroquel.setSelected(true);
                    viewProyecto.jTTroquel.setText(InformacionProyecto[7]);
                    viewProyecto.jTTroquel.setEnabled(true);
                }
                if (!InformacionProyecto[8].equals("null")) {//Repujado
                    viewProyecto.jCRepujado.setSelected(true);
                    viewProyecto.jTRepujado.setText(InformacionProyecto[8]);
                    viewProyecto.jTRepujado.setEnabled(true);
                }
                if (!InformacionProyecto[9].equals("null")) {//Stencil
                    viewProyecto.jCStencil.setSelected(true);
                    viewProyecto.jTStencil.setText(InformacionProyecto[9]);
                    viewProyecto.jTStencil.setEnabled(true);
                }
                if (!InformacionProyecto[10].equals("null")) {//Circuito de FE
                    viewProyecto.jCCircuito.setSelected(true);
                    viewProyecto.jTCircuito.setText(InformacionProyecto[10]);
                    viewProyecto.jTCircuito.setEnabled(true);
                    viewProyecto.cbMaterialCircuito.setSelectedItem(InformacionProyecto[11]);
                    viewProyecto.cbMaterialCircuito.setEnabled(true);
                    viewProyecto.jCAntisolderC.setSelected(InformacionProyecto[12].toUpperCase().equals("SI"));
                    viewProyecto.jCRuteoC.setSelected(InformacionProyecto[13].toUpperCase().equals("SI"));
                }
                if (!InformacionProyecto[14].equals("null")) {//PCB TE
                    viewProyecto.jCPCBTE.setSelected(true);
                    viewProyecto.jTPCBTE.setText(InformacionProyecto[14]);
                    viewProyecto.jTPCBTE.setEnabled(true);
                    viewProyecto.cbMaterialPCBTE.setSelectedItem(InformacionProyecto[15]);
                    viewProyecto.cbMaterialPCBTE.setEnabled(true);
                    viewProyecto.jCAntisolderP.setSelected(InformacionProyecto[16].toUpperCase().equals("SI"));
                    viewProyecto.jCRuteoP.setSelected(InformacionProyecto[17].toUpperCase().equals("SI"));
                    viewProyecto.jRPCBCOM.setSelected(InformacionProyecto[18].toUpperCase().equals("SI"));
                    viewProyecto.jRPCBCOM.setEnabled(true);
                    viewProyecto.jRPIntegracion.setSelected(InformacionProyecto[19].toUpperCase().equals("SI"));
                    viewProyecto.jRPIntegracion.setEnabled(true);
                    if (viewProyecto.jRPCBCOM.isSelected()) {//Componentes de la PCB del teclado
                        viewProyecto.jDFechaEntregaPCBCOMGF.setVisible(true);
                        if (!InformacionProyecto[25].equals("null")) {
                            viewProyecto.jDFechaEntregaPCBCOMGF.setDate(formatoDelTexto.parse(InformacionProyecto[25]));//Fecha de entrega de componentes de la PCB_TE:
                        }
                        viewProyecto.jLpcbGF.setVisible(true);
                    }
                    if (viewProyecto.jRPIntegracion.isSelected()) {//Integración de la PCB del teclado 
                        viewProyecto.jDFechaEntregaPCBGF.setVisible(true);
                        if (!InformacionProyecto[24].equals("null")) {
                            viewProyecto.jDFechaEntregaPCBGF.setDate(formatoDelTexto.parse(InformacionProyecto[24]));//Fecha de entrega de la PCB_TE(TH,FV,GF)a ensamble:
                        }
                        viewProyecto.jLCircuitoGF.setVisible(true);
                    }
                }
                if (!InformacionProyecto[20].equals("null")) {//Teclado
                    viewProyecto.jCTeclado.setSelected(true);
                    viewProyecto.jTTeclado.setText(InformacionProyecto[20]);
                    viewProyecto.jTTeclado.setEnabled(true);
                }
                if (!InformacionProyecto[21].equals("null")) {//Ensamble
                    viewProyecto.jCIntegracion.setSelected(true);
                    viewProyecto.jTIntegracion.setText(InformacionProyecto[21]);
                    viewProyecto.jTIntegracion.setEnabled(true);
                }
                if (viewProyecto.jCCircuito.isSelected() && viewProyecto.jCIntegracion.isSelected()) {//Esto se le conoce como integración.(Una parte se encarga FE y otra parte se encarga EN)
                    viewProyecto.jLComCircuitos.setVisible(true);
                    if (!InformacionProyecto[23].equals("null")) {
                        viewProyecto.jDFechaEntregaFECOM.setDate(formatoDelTexto.parse(InformacionProyecto[23]));//Fecha de entrega de los componentes del circuito_FE:
                    }
                    viewProyecto.jDFechaEntregaFECOM.setVisible(true);
                    viewProyecto.jLCircuitoFE.setVisible(true); 
                    if (!InformacionProyecto[22].equals("null")) {
                        viewProyecto.jDFechaEntregaFE.setDate(formatoDelTexto.parse(InformacionProyecto[22]));//Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble:
                    }
                    viewProyecto.jDFechaEntregaFE.setVisible(true);
                }
                if (viewProyecto.jTNombreCliente.getText().length() > 0 && viewProyecto.jTNombreProyecto.getText().length() > 0 && viewProyecto.jDeEntrega.getDate() != null && !(viewProyecto.cbTipoEjecucion.getSelectedIndex() == 0)) {
                    viewProyecto.btnGuardar.setEnabled(true);
                }
                //Me va a guardar directamente la informacion del proyecto
//                obj.accionBtnGuardarProyecto();
                //...
            } else {
                //Al QR del proyecto le falta información para poder realizar el registro
                new rojerusan.RSNotifyAnimated("¡Alerta!", "El código QR esta mal estructurado.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
        viewProyecto.lector = null;
        //Fin de la lectura del Código QR del proyecto.
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
// Trama que me envia el modulo wifi al puerto COM.
//GET /29359;Micro-Hom-Cali-S.A.S;Control-Planta;FE/TE;Normal;15/02/2018;2;null;null;null;null;null;no;no;null;null;no;no;null;null;null;null;null;null;null;null HTTP/1.1
//.Host: 192.168.4.1
//.Connection: keep-alive
//.Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
//.User-Agent: Mozilla/5.0 (Linux; Android 4.4.2; SM-G313ML Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.0.0.0 Mobile Safari/537.36
//.Accept-Encoding: gzip,deflate
//.Accept-Language: es-US,en-US;q=0.8
//.X-Requested-With: appinventor.ai_Adimaro_montoya.Manucaptura_WIFI

}
