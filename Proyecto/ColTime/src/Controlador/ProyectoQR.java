package Controlador;

import Vistas.proyecto;
import coltime.Menu;
import gnu.io.CommPort;
import gnu.io.CommPortIdentifier;
import gnu.io.SerialPort;
import java.awt.Color;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Scanner;
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
//                            System.out.println(valorQR);
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
        String nombreCliente = "";
//      String valor[] = null;
        try {
            //...
            if (QRProyecto.split(";").length == 27) {//La longitud del vector siempre va a ser 28
                //Envio de información al formulario de proyecto...
                String InformacionProyecto[] = QRProyecto.split(";");
                
                viewProyecto.jTNorden.setText(InformacionProyecto[0]);//Numero de orden
                
                String infoNombreCliente[] = InformacionProyecto[1].split("-");
                for (int i = 0; i < infoNombreCliente.length; i++) {
                    nombreCliente += infoNombreCliente[i] + " ";
                }
                viewProyecto.jTNombreCliente.setText(nombreCliente);//Nombre del cliente
                nombreCliente = "";
                
                String infoNombreProyecto[] = InformacionProyecto[2].split("-");
                for (int i = 0; i < infoNombreProyecto.length; i++) {
                    nombreCliente += infoNombreProyecto[i] + " ";
                }
                viewProyecto.jTNombreProyecto.setText(nombreCliente);//Nombre del proyecto
                
                viewProyecto.cbTipoEjecucion.setSelectedItem(InformacionProyecto[3]);//Tipo de proyecto
                
                viewProyecto.jDeEntrega.setDate(formatoDelTexto.parse(InformacionProyecto[4]));//Fecha de entrega al cliente
                
                if (!InformacionProyecto[5].equals("null")) {//Conversor
                    viewProyecto.jCConversor.setSelected(true);
                    viewProyecto.jTConversor.setText(InformacionProyecto[5]);// Cantidad
                    viewProyecto.jTConversor.setEnabled(true);
                }
                
                if (!InformacionProyecto[6].equals("null")) {//Troquel
                    viewProyecto.jCTroquel.setSelected(true);
                    viewProyecto.jTTroquel.setText(InformacionProyecto[6]);// Cantidad
                    viewProyecto.jTTroquel.setEnabled(true);
                }
                
                if (!InformacionProyecto[7].equals("null")) {//Repujado
                    viewProyecto.jCRepujado.setSelected(true);
                    viewProyecto.jTRepujado.setText(InformacionProyecto[7]);// Cantidad
                    viewProyecto.jTRepujado.setEnabled(true);
                }
                
                if (!InformacionProyecto[8].equals("null")) {//Stencil
                    viewProyecto.jCStencil.setSelected(true);
                    viewProyecto.jTStencil.setText(InformacionProyecto[8]);// Cantidad
                    viewProyecto.jTStencil.setEnabled(true);
                }
                
                if (!InformacionProyecto[9].equals("null")) {//Circuito de FE
                    viewProyecto.jCCircuito.setSelected(true);
                    viewProyecto.jTCircuito.setText(InformacionProyecto[9]);// Cantidad
                    viewProyecto.jTCircuito.setEnabled(true);
                    viewProyecto.cbEspesorCircuito.setEnabled(true);
                    viewProyecto.cbMaterialCircuito.setSelectedItem(InformacionProyecto[10]); // Material del circuito
                    viewProyecto.cbMaterialCircuito.setEnabled(true);
                    viewProyecto.cbMaterialCircuito.setEnabled(true);
                    // ...
                    viewProyecto.cbColorCircuito.setSelectedItem(InformacionProyecto[11].toUpperCase());// Color antisolder
                    viewProyecto.cbEspesorCircuito.setSelectedIndex(Integer.parseInt(InformacionProyecto[12]));// Espesor
                    viewProyecto.jCRuteoC.setSelected(InformacionProyecto[13].toUpperCase().equals("SI")); // Lleva ruteo?
                }
                
                if (!InformacionProyecto[14].equals("null")) {//PCB TE
                    viewProyecto.jCPCBTE.setSelected(true);
                    viewProyecto.jTPCBTE.setText(InformacionProyecto[14]); // Cantidad
                    viewProyecto.jTPCBTE.setEnabled(true);
                    viewProyecto.cbEspesorPCB.setEnabled(true);
                    viewProyecto.cbMaterialPCBTE.setSelectedItem(InformacionProyecto[15]); // Material
                    viewProyecto.cbMaterialPCBTE.setEnabled(true);
                    viewProyecto.cbColorPCB.setSelectedItem(InformacionProyecto[16].toUpperCase()); // Color PCB TE
                    viewProyecto.cbEspesorPCB.setSelectedIndex(Integer.parseInt(InformacionProyecto[17])); // Espesor
                    viewProyecto.jCRuteoP.setSelected(InformacionProyecto[18].toUpperCase().equals("SI")); // Lleva Ruteo
                    
//                    viewProyecto.jRPCBCOM.setSelected(InformacionProyecto[18].toUpperCase().equals("SI")); // Los componentes por el momento no se van a trabajar...
//                    viewProyecto.jRPCBCOM.setEnabled(true);

//                    if (viewProyecto.jRPCBCOM.isSelected()) {//Componentes de la PCB del teclado
//                        viewProyecto.jDFechaEntregaPCBCOMGF.setVisible(true);
//                        if (!InformacionProyecto[25].equals("null")) {
//                            viewProyecto.jDFechaEntregaPCBCOMGF.setDate(formatoDelTexto.parse(InformacionProyecto[25]));//Fecha de entrega de componentes de la PCB_TE:
//                        }
//                        viewProyecto.jLpcbGF.setVisible(true);
//                    }

                    if(!InformacionProyecto[20].equals("null")){ // Ensamble PCB TE
                        
                        viewProyecto.jCPIntegracionPCB.setSelected(true);
                        viewProyecto.jTTPCBEN.setEnabled(true);
                        viewProyecto.jCPIntegracionPCB.setEnabled(true);
                        viewProyecto.jDFechaEntregaPCBEN.setVisible(true);
                        viewProyecto.jTTPCBEN.setText(InformacionProyecto[20]);
                        // ...
                        if (!InformacionProyecto[25].equals("null")) {
                            viewProyecto.jLPCBTE.setVisible(true);
                            viewProyecto.jDFechaEntregaPCBEN.setDate(formatoDelTexto.parse(InformacionProyecto[25]));//Fecha de entrega de la PCB_TE(TH,FV,GF)a ensamble:
                        }
                        
                    }
                    
                }
                
                if (!InformacionProyecto[21].equals("null")) {//Teclado
                    viewProyecto.jCTeclado.setSelected(true);
                    viewProyecto.jTTeclado.setText(InformacionProyecto[21]);
                    viewProyecto.jTTeclado.setEnabled(true);
                }
                
                if (!InformacionProyecto[22].equals("null")) {//Ensamble
                    viewProyecto.jCIntegracion.setSelected(true);
                    viewProyecto.jTIntegracion.setText(InformacionProyecto[22]);
                    viewProyecto.jTIntegracion.setEnabled(true);
                }
                
                if (viewProyecto.jCCircuito.isSelected() && viewProyecto.jCIntegracion.isSelected()) { //Fecha de entraga del circuito a EN
//                  viewProyecto.jLComCircuitos.setVisible(true);// Los Componenetes no se van a utilizar...

                    viewProyecto.jLCircuitoFE.setVisible(true); 

                    if (!InformacionProyecto[24].equals("null")) {//Fecha de entrega de los componentes del circuito_FE:
                        
                        viewProyecto.jDFechaEntregaFECOM.setVisible(true);
                        viewProyecto.jLComCircuitos.setVisible(true);
                        viewProyecto.jDFechaEntregaFECOM.setDate(formatoDelTexto.parse(InformacionProyecto[24]));
                        
                    }
                    
                    
                    if (!InformacionProyecto[23].equals("null")) {//Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble:
                        
                        viewProyecto.jDFechaEntregaFE.setVisible(true);
                        viewProyecto.jLPCBTE.setVisible(true);
                        viewProyecto.jDFechaEntregaFE.setDate(formatoDelTexto.parse(InformacionProyecto[23]));
                        
                    }
                    
                }
                
                // Esto puede ser remplazado por una funcion de la clase proyecto...
                if (viewProyecto.jTNombreCliente.getText().length() > 0 && viewProyecto.jTNombreProyecto.getText().length() > 0 && viewProyecto.jDeEntrega.getDate() != null && !(viewProyecto.cbTipoEjecucion.getSelectedIndex() == 0)) {
                    
                    viewProyecto.btnGuardar.setEnabled(true);
                    
                }
                //Me va a guardar directamente la informacion del proyecto
                viewProyecto.accionBtnGuardarProyecto(); //
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

// Estructura de la informacion del QR de proyecto
/*01-NumOrden; ---------------------------------------------     29359 
02-Nombre Cliente; -----------------------------------------     Micro-Hom-Cali-S.A.S
03-Nombre Proyecto; ----------------------------------------     Control-Planta
04-Tipo de proyecto; ---------------------------------------     Normal
05-Fecha de entrega al cliente; ----------------------------     2018/02/15
06-Cantidad del Conversos; ---------------------------------     null
07-Cantidad del Troque; ------------------------------------     null
08-Cantidad del Repujado; ----------------------------------     null
09-Cantidad del Stencil; -----------------------------------     null
10-Cantidad del Circuito_FE; -------------------------------     10
11-Material del Circuito; ----------------------------------     TH
12-Color_antisolder_Circuito; ------------------------------     VERDE
13-Espesor_circuito; ---------------------------------------     1.6 - 1 CAPA (En estos casos es mejor mandar el identificador)
14-¿Ruteo del circuito_FE?; --------------------------------     SI
15-Cantidad de la PCB_TE; ----------------------------------     15
16-Material de la PCB; -------------------------------------     FV
17-Color_antisolder_PCB; -----------------------------------     ROJO
18-Espesor_PCB; --------------------------------------------     1.6 - 1 CAPA (En estos casos es mejor mandar el identificador)
19-¿Ruteo de la PCB_TE?; -----------------------------------     no
20-Componentes de la PCB_TE; -------------------------------     null
21-Integraciòn del PCB_TE; ---------------------------------     15
22-Cantidad de Teclados; -----------------------------------     10
23-Cantidad de ensamble; -----------------------------------     10
24-Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble; --     2018/11/01
25-Fecha de entrega de los componentes del circuito_FE; ----     2018/11/01
26-Fecha de entrega de la PCB_TE(TH,FV,GF) a esamble; ------     null
27-Fecha de entrega de componentes de la PCB_TE ------------     null
     */
}
