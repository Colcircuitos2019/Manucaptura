package Vistas;

import Atxy2k.CustomTextField.RestrictedTextField;
import Controlador.DetalleProyecto;
import Controlador.Proyecto;
import Controlador.ProyectoQR;
import Controlador.rutaQR;
import Controlador.socketCliente;
import coltime.Menu;
import com.barcodelib.barcode.QRCode;
import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.toedter.calendar.JTextFieldDateEditor;
import elaprendiz.gui.textField.TextFieldRoundBackground;
import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import javax.sql.rowset.CachedRowSet;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JCheckBox;
import javax.swing.JOptionPane;
import rojerusan.RSNotifyAnimated;

public class proyecto extends javax.swing.JPanel {
    //De esta forma esta estructurado el QR de proyectos.
//NumOrden; Nombre Cliente; Nombre Proyecto; Negocios implicados; Tipo de proyecto; Fecha de entrega al cliente; Cantidad del Conversos; Cantidad del Troque; Cantidad del Repujado; Cantidad del Stencil; Cantidad del Circuito_FE; Material del Circuito; ¿Antisolder del circuito_FE?; ¿Ruteo del circuito_FE?; Cantidad de la PCB_TE; Material de la PCB; ¿Antisolder de la PCB_TE?; ¿Ruteo de la PCB_TE?; Componentes de la PCB_TE; Integraciòn del PCB_TE; Cantidad de Teclados; Cantidad de ensamble; Fecha de entrega del Circuito_FE(TH,FV,GF) a ensamble; Fecha de entrega de los componentes del circuito_FE; Fecha de entrega de la PCB_TE(TH,FV,GF); Fecha de entrega de componentes de la PCB_TE  
    //Variables e instancias
    static int accion = 1; //1=Registrar, 2=Modificar
    static int componentes = 0;
    boolean v[] = new boolean[12];
    int udm = 0, resol = 100, rot = 0;
    float mi = 0.000f, md = 0.000f, ms = 0.000f, min = 0.000f, tam = 21.000f;
    static String fecha = "";
    int opmaterial = 1;
    int modificacion = 0;
    int puertoProyecto = 0;
    DateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
    public static ProyectoQR lector = null;
    public static boolean disponibilidad = false;//Cierra la conexion con el puerto serial
    //Revisar las validaciones de los botones cuando esta activo un registro y se consulta la información de otra para modificar.
    
    public proyecto() {}
    
    public proyecto(int accion) {
        if (accion == 1) {
            initComponents();
            visibilidadLabelID();
            ocultarFechas();
            componentesFechasNoEditables();
            limitesCamposFormulario();
            Notificacion1.setVisible(false);
            btnTomaTiempos.setVisible(false);
            jPEstadoProyecto.setVisible(false);
            btnActivar.setVisible(false);
            consultarEspesoresTarjeta();
            consultarColoresAntisolder();
            jRPCBCOM.setVisible(false);// Por el momento esto no va a ser visible
            // ...
            if (lector == null) {
                disponibilidad = true;
                lector = new ProyectoQR(this);
            }
        }
        limpiarCamposFormulario();
        //--------------------------------------------------------------------->
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        ParadasOEjecucion = new javax.swing.ButtonGroup();
        estadoProyecto = new javax.swing.ButtonGroup();
        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPInformacion = new javax.swing.JPanel();
        jTNorden = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel3 = new javax.swing.JLabel();
        jTNombreCliente = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel5 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jTNombreProyecto = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jPDetalles1 = new javax.swing.JPanel();
        jTTeclado = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jCTeclado = new javax.swing.JCheckBox();
        jTConversor = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jTTroquel = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jTRepujado = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jTStencil = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jCConversor = new javax.swing.JCheckBox();
        jTCircuito = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jCRepujado = new javax.swing.JCheckBox();
        jTPCBTE = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel8 = new javax.swing.JLabel();
        jCTroquel = new javax.swing.JCheckBox();
        jCCircuito = new javax.swing.JCheckBox();
        jLabel9 = new javax.swing.JLabel();
        jCPCBTE = new javax.swing.JCheckBox();
        jCStencil = new javax.swing.JCheckBox();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        cbMaterialCircuito = new elaprendiz.gui.comboBox.ComboBoxRound();
        cbMaterialPCBTE = new elaprendiz.gui.comboBox.ComboBoxRound();
        jTIntegracion = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jCIntegracion = new javax.swing.JCheckBox();
        jLPCBTE = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jCRuteoC = new javax.swing.JCheckBox();
        jLabel11 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jCRuteoP = new javax.swing.JCheckBox();
        jDFechaEntregaFE = new com.toedter.calendar.JDateChooser();
        jDFechaEntregaFECOM = new com.toedter.calendar.JDateChooser();
        jDFechaEntregaPCBEN = new com.toedter.calendar.JDateChooser();
        jLabel24 = new javax.swing.JLabel();
        jLCircuitoFE = new javax.swing.JLabel();
        jLComCircuitos = new javax.swing.JLabel();
        jRPCBCOM = new javax.swing.JRadioButton();
        jDFechaEntregaPCBCOMGF = new com.toedter.calendar.JDateChooser();
        jLpcbGF = new javax.swing.JLabel();
        jLIDCircuitoGF = new javax.swing.JLabel();
        jLIDCircuitoCOM = new javax.swing.JLabel();
        jLIDPCBCOM = new javax.swing.JLabel();
        jLIDPCBEN = new javax.swing.JLabel();
        cbEspesorCircuito = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel25 = new javax.swing.JLabel();
        cbEspesorPCB = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel26 = new javax.swing.JLabel();
        cbColorCircuito = new elaprendiz.gui.comboBox.ComboBoxRound();
        cbColorPCB = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jTTPCBEN = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jCPIntegracionPCB = new javax.swing.JCheckBox();
        jPDetalles = new javax.swing.JPanel();
        jDeEntrega = new com.toedter.calendar.JDateChooser();
        jLabel10 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        cbTipoEjecucion = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel21 = new javax.swing.JLabel();
        jLIngreso = new javax.swing.JLabel();
        jRParada = new javax.swing.JRadioButton();
        jREjecucion = new javax.swing.JRadioButton();
        jPanel5 = new javax.swing.JPanel();
        btnNuevo = new javax.swing.JButton();
        btnGuardar = new javax.swing.JButton();
        btnBuscar = new javax.swing.JButton();
        btnUpdate = new javax.swing.JButton();
        btnDelete = new javax.swing.JButton();
        btnActivar = new javax.swing.JButton();
        Notificacion1 = new javax.swing.JLabel();
        jLIDConversor = new javax.swing.JLabel();
        jLIDTroquel = new javax.swing.JLabel();
        jLIDRepujado = new javax.swing.JLabel();
        jLIDStencil = new javax.swing.JLabel();
        jLIDCircuito = new javax.swing.JLabel();
        jLIDPCB = new javax.swing.JLabel();
        jLIDTeclado = new javax.swing.JLabel();
        jLIDIntegracion = new javax.swing.JLabel();
        btnTomaTiempos = new elaprendiz.gui.button.ButtonColoredAction();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTNovedades = new javax.swing.JTextArea();
        jLEstado = new javax.swing.JLabel();
        jLNCaracteres = new javax.swing.JLabel();
        jPEstadoProyecto = new javax.swing.JPanel();
        jDNFEE = new com.toedter.calendar.JDateChooser();
        jRATiempo = new javax.swing.JRadioButton();
        jRRetraso = new javax.swing.JRadioButton();
        jLCircuitoFE1 = new javax.swing.JLabel();
        jLNovedades = new javax.swing.JLabel();
        jLNovedades2 = new javax.swing.JLabel();
        GenerarQR = new elaprendiz.gui.button.ButtonColoredAction();
        jLabel14 = new javax.swing.JLabel();

        setBackground(new java.awt.Color(219, 219, 219));
        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        setName("proyectos"); // NOI18N

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));
        jPanel1.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder(), "Proyecto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 18), new java.awt.Color(128, 128, 131))); // NOI18N
        jPanel2.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jPInformacion.setBackground(new java.awt.Color(244, 244, 244));
        jPInformacion.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(204, 204, 204)), "Información filtraria", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N

        jTNorden.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        jTNorden.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNorden.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNorden.setEnabled(false);
        jTNorden.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(128, 128, 131));
        jLabel3.setText(" Orden °N:");

        jTNombreCliente.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreCliente.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreCliente.setEnabled(false);
        jTNombreCliente.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTNombreCliente.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreClienteKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTNombreClienteKeyTyped(evt);
            }
        });

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setText("Nombre del cliente:");

        jLabel12.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel12.setForeground(new java.awt.Color(255, 51, 51));
        jLabel12.setText("*");

        jTNombreProyecto.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreProyecto.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreProyecto.setEnabled(false);
        jTNombreProyecto.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTNombreProyecto.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreProyectoKeyReleased(evt);
            }
        });

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Nombre del proyecto:");

        jLabel13.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel13.setForeground(new java.awt.Color(255, 51, 51));
        jLabel13.setText("*");

        javax.swing.GroupLayout jPInformacionLayout = new javax.swing.GroupLayout(jPInformacion);
        jPInformacion.setLayout(jPInformacionLayout);
        jPInformacionLayout.setHorizontalGroup(
            jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPInformacionLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTNombreProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 392, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTNorden, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPInformacionLayout.createSequentialGroup()
                                .addGap(37, 37, 37)
                                .addComponent(jTNombreCliente, javax.swing.GroupLayout.PREFERRED_SIZE, 248, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPInformacionLayout.createSequentialGroup()
                                .addGap(45, 45, 45)
                                .addComponent(jLabel12)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 135, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addComponent(jLabel13)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel4)))
                .addContainerGap(18, Short.MAX_VALUE))
        );
        jPInformacionLayout.setVerticalGroup(
            jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPInformacionLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jTNombreCliente, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel3)
                            .addComponent(jLabel5)
                            .addComponent(jLabel12))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTNorden, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(13, 13, 13)
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4)
                    .addComponent(jLabel13))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTNombreProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel2.add(jPInformacion, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 30, 430, 150));

        jPDetalles1.setBackground(new java.awt.Color(244, 244, 244));
        jPDetalles1.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(204, 204, 204)), "Detalles", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPDetalles1.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTTeclado.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTTeclado.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTTeclado.setEnabled(false);
        jTTeclado.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTTeclado.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTTecladoKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTTeclado, new org.netbeans.lib.awtextra.AbsoluteConstraints(616, 49, -1, 25));

        jCTeclado.setBackground(new java.awt.Color(255, 255, 255));
        jCTeclado.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCTeclado.setForeground(new java.awt.Color(102, 102, 102));
        jCTeclado.setText("Teclado");
        jCTeclado.setEnabled(false);
        jCTeclado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCTecladoActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCTeclado, new org.netbeans.lib.awtextra.AbsoluteConstraints(616, 19, -1, -1));

        jTConversor.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTConversor.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTConversor.setEnabled(false);
        jTConversor.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTConversor.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTConversorKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTConversor, new org.netbeans.lib.awtextra.AbsoluteConstraints(126, 49, -1, 25));

        jTTroquel.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTTroquel.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTTroquel.setEnabled(false);
        jTTroquel.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTTroquel.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTTroquelKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTTroquel, new org.netbeans.lib.awtextra.AbsoluteConstraints(216, 49, -1, 25));

        jTRepujado.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTRepujado.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTRepujado.setEnabled(false);
        jTRepujado.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTRepujado.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTRepujadoKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTRepujado, new org.netbeans.lib.awtextra.AbsoluteConstraints(296, 49, -1, 25));

        jTStencil.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTStencil.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTStencil.setEnabled(false);
        jTStencil.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTStencil.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTStencilKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTStencil, new org.netbeans.lib.awtextra.AbsoluteConstraints(376, 49, -1, 25));

        jCConversor.setBackground(new java.awt.Color(255, 255, 255));
        jCConversor.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCConversor.setForeground(new java.awt.Color(102, 102, 102));
        jCConversor.setText("Conversor");
        jCConversor.setEnabled(false);
        jCConversor.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCConversorActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCConversor, new org.netbeans.lib.awtextra.AbsoluteConstraints(126, 19, -1, -1));

        jTCircuito.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTCircuito.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTCircuito.setEnabled(false);
        jTCircuito.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTCircuito.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTCircuitoKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(456, 49, -1, 25));

        jCRepujado.setBackground(new java.awt.Color(255, 255, 255));
        jCRepujado.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCRepujado.setForeground(new java.awt.Color(102, 102, 102));
        jCRepujado.setText("Repujado");
        jCRepujado.setEnabled(false);
        jCRepujado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCRepujadoActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCRepujado, new org.netbeans.lib.awtextra.AbsoluteConstraints(296, 19, -1, -1));

        jTPCBTE.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTPCBTE.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTPCBTE.setEnabled(false);
        jTPCBTE.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTPCBTE.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTPCBTEActionPerformed(evt);
            }
        });
        jTPCBTE.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTPCBTEKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTPCBTE, new org.netbeans.lib.awtextra.AbsoluteConstraints(536, 49, -1, 25));

        jLabel8.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel8.setForeground(new java.awt.Color(128, 128, 131));
        jLabel8.setText("Cantidades:");
        jPDetalles1.add(jLabel8, new org.netbeans.lib.awtextra.AbsoluteConstraints(46, 49, -1, -1));

        jCTroquel.setBackground(new java.awt.Color(255, 255, 255));
        jCTroquel.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCTroquel.setForeground(new java.awt.Color(102, 102, 102));
        jCTroquel.setText("Troquel");
        jCTroquel.setEnabled(false);
        jCTroquel.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCTroquelActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCTroquel, new org.netbeans.lib.awtextra.AbsoluteConstraints(216, 19, 80, -1));

        jCCircuito.setBackground(new java.awt.Color(255, 255, 255));
        jCCircuito.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCCircuito.setForeground(new java.awt.Color(102, 102, 102));
        jCCircuito.setText("Circuito-FE");
        jCCircuito.setEnabled(false);
        jCCircuito.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCCircuitoActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(456, 19, -1, -1));

        jLabel9.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel9.setForeground(new java.awt.Color(128, 128, 131));
        jLabel9.setText("Otras ordenes:");
        jPDetalles1.add(jLabel9, new org.netbeans.lib.awtextra.AbsoluteConstraints(26, 29, -1, -1));

        jCPCBTE.setBackground(new java.awt.Color(255, 255, 255));
        jCPCBTE.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCPCBTE.setForeground(new java.awt.Color(102, 102, 102));
        jCPCBTE.setText("PCB-TE");
        jCPCBTE.setEnabled(false);
        jCPCBTE.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCPCBTEActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCPCBTE, new org.netbeans.lib.awtextra.AbsoluteConstraints(538, 19, -1, -1));

        jCStencil.setBackground(new java.awt.Color(255, 255, 255));
        jCStencil.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCStencil.setForeground(new java.awt.Color(102, 102, 102));
        jCStencil.setText("Stencil");
        jCStencil.setEnabled(false);
        jCStencil.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCStencilActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCStencil, new org.netbeans.lib.awtextra.AbsoluteConstraints(376, 19, -1, -1));

        jLabel22.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel22.setForeground(new java.awt.Color(128, 128, 131));
        jLabel22.setText("Material de la PCB TE:");
        jPDetalles1.add(jLabel22, new org.netbeans.lib.awtextra.AbsoluteConstraints(450, 97, -1, -1));

        jLabel23.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel23.setForeground(new java.awt.Color(128, 128, 131));
        jLabel23.setText("Material del Circuito:");
        jPDetalles1.add(jLabel23, new org.netbeans.lib.awtextra.AbsoluteConstraints(70, 95, -1, -1));

        cbMaterialCircuito.setForeground(new java.awt.Color(102, 102, 102));
        cbMaterialCircuito.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "TH", "FV", "GF" }));
        cbMaterialCircuito.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbMaterialCircuito.setEnabled(false);
        cbMaterialCircuito.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbMaterialCircuito.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbMaterialCircuitoItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbMaterialCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(200, 90, 150, 25));

        cbMaterialPCBTE.setForeground(new java.awt.Color(102, 102, 102));
        cbMaterialPCBTE.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "TH", "FV", "GF" }));
        cbMaterialPCBTE.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbMaterialPCBTE.setEnabled(false);
        cbMaterialPCBTE.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbMaterialPCBTE.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbMaterialPCBTEItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbMaterialPCBTE, new org.netbeans.lib.awtextra.AbsoluteConstraints(600, 92, 150, 25));

        jTIntegracion.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTIntegracion.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTIntegracion.setDescripcion(".");
        jTIntegracion.setEnabled(false);
        jTIntegracion.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTIntegracion.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTIntegracionKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTIntegracion, new org.netbeans.lib.awtextra.AbsoluteConstraints(695, 47, -1, 25));

        jCIntegracion.setBackground(new java.awt.Color(255, 255, 255));
        jCIntegracion.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCIntegracion.setForeground(new java.awt.Color(102, 102, 102));
        jCIntegracion.setText("Ensamble");
        jCIntegracion.setEnabled(false);
        jCIntegracion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCIntegracionActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCIntegracion, new org.netbeans.lib.awtextra.AbsoluteConstraints(695, 19, -1, -1));

        jLPCBTE.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLPCBTE.setForeground(new java.awt.Color(128, 128, 131));
        jLPCBTE.setText("Fecha de entrega PCB a EN");
        jPDetalles1.add(jLPCBTE, new org.netbeans.lib.awtextra.AbsoluteConstraints(440, 200, -1, -1));

        jLabel19.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel19.setForeground(new java.awt.Color(128, 128, 131));
        jLabel19.setText("¿Lleva ruteo?");
        jPDetalles1.add(jLabel19, new org.netbeans.lib.awtextra.AbsoluteConstraints(290, 135, -1, -1));

        jCRuteoC.setBackground(new java.awt.Color(255, 255, 255));
        jCRuteoC.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCRuteoC.setForeground(new java.awt.Color(102, 102, 102));
        jCRuteoC.setText("R");
        jCRuteoC.setEnabled(false);
        jPDetalles1.add(jCRuteoC, new org.netbeans.lib.awtextra.AbsoluteConstraints(310, 155, -1, -1));

        jLabel11.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel11.setForeground(new java.awt.Color(128, 128, 131));
        jLabel11.setText("Color antisolder");
        jPDetalles1.add(jLabel11, new org.netbeans.lib.awtextra.AbsoluteConstraints(430, 165, -1, -1));

        jLabel16.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel16.setForeground(new java.awt.Color(128, 128, 131));
        jLabel16.setText("¿Lleva ruteo?");
        jPDetalles1.add(jLabel16, new org.netbeans.lib.awtextra.AbsoluteConstraints(700, 135, -1, -1));

        jCRuteoP.setBackground(new java.awt.Color(255, 255, 255));
        jCRuteoP.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCRuteoP.setForeground(new java.awt.Color(102, 102, 102));
        jCRuteoP.setText("R");
        jCRuteoP.setEnabled(false);
        jPDetalles1.add(jCRuteoP, new org.netbeans.lib.awtextra.AbsoluteConstraints(720, 155, -1, -1));

        jDFechaEntregaFE.setToolTipText("");
        jDFechaEntregaFE.setDateFormatString("dd/MM/yyyy");
        jDFechaEntregaFE.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jPDetalles1.add(jDFechaEntregaFE, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 220, 140, -1));

        jDFechaEntregaFECOM.setToolTipText("");
        jDFechaEntregaFECOM.setDateFormatString("dd/MM/yyyy");
        jDFechaEntregaFECOM.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jPDetalles1.add(jDFechaEntregaFECOM, new org.netbeans.lib.awtextra.AbsoluteConstraints(230, 220, 130, 20));

        jDFechaEntregaPCBEN.setToolTipText("");
        jDFechaEntregaPCBEN.setDateFormatString("dd/MM/yyyy");
        jDFechaEntregaPCBEN.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jPDetalles1.add(jDFechaEntregaPCBEN, new org.netbeans.lib.awtextra.AbsoluteConstraints(460, 220, 130, -1));

        jLabel24.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel24.setForeground(new java.awt.Color(128, 128, 131));
        jLabel24.setText("Color antisolder");
        jPDetalles1.add(jLabel24, new org.netbeans.lib.awtextra.AbsoluteConstraints(30, 165, -1, -1));

        jLCircuitoFE.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLCircuitoFE.setForeground(new java.awt.Color(128, 128, 131));
        jLCircuitoFE.setText("Fecha de entrega Circuito a EN");
        jPDetalles1.add(jLCircuitoFE, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 200, -1, -1));

        jLComCircuitos.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLComCircuitos.setForeground(new java.awt.Color(128, 128, 131));
        jLComCircuitos.setText("Fecha de entrega COM Circuito");
        jPDetalles1.add(jLComCircuitos, new org.netbeans.lib.awtextra.AbsoluteConstraints(220, 200, -1, -1));

        jRPCBCOM.setBackground(new java.awt.Color(255, 255, 255));
        jRPCBCOM.setText("COM");
        jRPCBCOM.setEnabled(false);
        jRPCBCOM.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRPCBCOMActionPerformed(evt);
            }
        });
        jPDetalles1.add(jRPCBCOM, new org.netbeans.lib.awtextra.AbsoluteConstraints(790, 20, 20, 20));

        jDFechaEntregaPCBCOMGF.setToolTipText("");
        jDFechaEntregaPCBCOMGF.setDateFormatString("dd/MM/yyyy");
        jDFechaEntregaPCBCOMGF.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jPDetalles1.add(jDFechaEntregaPCBCOMGF, new org.netbeans.lib.awtextra.AbsoluteConstraints(640, 220, 130, -1));

        jLpcbGF.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLpcbGF.setForeground(new java.awt.Color(128, 128, 131));
        jLpcbGF.setText("Fecha de entrega COM PCB");
        jPDetalles1.add(jLpcbGF, new org.netbeans.lib.awtextra.AbsoluteConstraints(630, 200, -1, -1));

        jLIDCircuitoGF.setText("0");
        jPDetalles1.add(jLIDCircuitoGF, new org.netbeans.lib.awtextra.AbsoluteConstraints(380, 100, 10, -1));

        jLIDCircuitoCOM.setText("0");
        jPDetalles1.add(jLIDCircuitoCOM, new org.netbeans.lib.awtextra.AbsoluteConstraints(400, 100, 10, -1));

        jLIDPCBCOM.setText("0");
        jPDetalles1.add(jLIDPCBCOM, new org.netbeans.lib.awtextra.AbsoluteConstraints(780, 20, 10, -1));

        jLIDPCBEN.setText("0");
        jPDetalles1.add(jLIDPCBEN, new org.netbeans.lib.awtextra.AbsoluteConstraints(800, 60, 10, -1));

        cbEspesorCircuito.setForeground(new java.awt.Color(102, 102, 102));
        cbEspesorCircuito.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione..." }));
        cbEspesorCircuito.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbEspesorCircuito.setEnabled(false);
        cbEspesorCircuito.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbEspesorCircuito.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbEspesorCircuitoItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbEspesorCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(150, 130, 120, 25));

        jLabel25.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel25.setForeground(new java.awt.Color(128, 128, 131));
        jLabel25.setText("Espesor de la tarjeta");
        jPDetalles1.add(jLabel25, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 135, -1, -1));

        cbEspesorPCB.setForeground(new java.awt.Color(102, 102, 102));
        cbEspesorPCB.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "TH", "FV", "GF" }));
        cbEspesorPCB.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbEspesorPCB.setEnabled(false);
        cbEspesorPCB.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbEspesorPCB.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbEspesorPCBItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbEspesorPCB, new org.netbeans.lib.awtextra.AbsoluteConstraints(560, 130, 120, 25));

        jLabel26.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel26.setForeground(new java.awt.Color(128, 128, 131));
        jLabel26.setText("Espesor de la tarjeta");
        jPDetalles1.add(jLabel26, new org.netbeans.lib.awtextra.AbsoluteConstraints(420, 135, -1, -1));

        cbColorCircuito.setForeground(new java.awt.Color(102, 102, 102));
        cbColorCircuito.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione..." }));
        cbColorCircuito.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbColorCircuito.setEnabled(false);
        cbColorCircuito.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbColorCircuito.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbColorCircuitoItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbColorCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(150, 160, 120, 25));

        cbColorPCB.setForeground(new java.awt.Color(102, 102, 102));
        cbColorPCB.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione..." }));
        cbColorPCB.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbColorPCB.setEnabled(false);
        cbColorPCB.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbColorPCB.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbColorPCBItemStateChanged(evt);
            }
        });
        jPDetalles1.add(cbColorPCB, new org.netbeans.lib.awtextra.AbsoluteConstraints(560, 160, 120, 25));

        jLabel27.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel27.setForeground(new java.awt.Color(255, 51, 51));
        jLabel27.setText("*");
        jPDetalles1.add(jLabel27, new org.netbeans.lib.awtextra.AbsoluteConstraints(60, 90, -1, -1));

        jLabel28.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel28.setForeground(new java.awt.Color(255, 51, 51));
        jLabel28.setText("*");
        jPDetalles1.add(jLabel28, new org.netbeans.lib.awtextra.AbsoluteConstraints(440, 90, -1, -1));

        jTTPCBEN.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTTPCBEN.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTTPCBEN.setEnabled(false);
        jTTPCBEN.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTTPCBEN.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTTPCBENKeyTyped(evt);
            }
        });
        jPDetalles1.add(jTTPCBEN, new org.netbeans.lib.awtextra.AbsoluteConstraints(763, 103, 45, 25));

        jCPIntegracionPCB.setBackground(new java.awt.Color(255, 255, 255));
        jCPIntegracionPCB.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jCPIntegracionPCB.setForeground(new java.awt.Color(102, 102, 102));
        jCPIntegracionPCB.setText("EN");
        jCPIntegracionPCB.setEnabled(false);
        jCPIntegracionPCB.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCPIntegracionPCBActionPerformed(evt);
            }
        });
        jPDetalles1.add(jCPIntegracionPCB, new org.netbeans.lib.awtextra.AbsoluteConstraints(760, 80, 50, 20));

        jPanel2.add(jPDetalles1, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 192, 820, 250));

        jPDetalles.setBackground(new java.awt.Color(244, 244, 244));
        jPDetalles.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(204, 204, 204)), "Detalles", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N

        jDeEntrega.setToolTipText("");
        jDeEntrega.setDateFormatString("dd/MM/yyyy");
        jDeEntrega.setEnabled(false);
        jDeEntrega.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jDeEntrega.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jDeEntregaPropertyChange(evt);
            }
        });

        jLabel10.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel10.setForeground(new java.awt.Color(128, 128, 131));
        jLabel10.setText("Fecha de entrega:");

        jLabel17.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel17.setForeground(new java.awt.Color(255, 51, 51));
        jLabel17.setText("*");

        jLabel18.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel18.setForeground(new java.awt.Color(128, 128, 131));
        jLabel18.setText("Fecha de ingreso:");

        jLabel20.setFont(new java.awt.Font("Tahoma", 0, 14)); // NOI18N
        jLabel20.setForeground(new java.awt.Color(255, 51, 51));
        jLabel20.setText("*");

        cbTipoEjecucion.setForeground(new java.awt.Color(102, 102, 102));
        cbTipoEjecucion.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "Normal", "RQT", "Quick" }));
        cbTipoEjecucion.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbTipoEjecucion.setEnabled(false);
        cbTipoEjecucion.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbTipoEjecucion.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbTipoEjecucionItemStateChanged(evt);
            }
        });

        jLabel21.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel21.setForeground(new java.awt.Color(128, 128, 131));
        jLabel21.setText("Tipo de proyecto:");

        jLIngreso.setFont(new java.awt.Font("Tahoma", 1, 13)); // NOI18N
        jLIngreso.setForeground(new java.awt.Color(128, 128, 131));
        jLIngreso.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLIngreso.setText("DD-MM-YYYY");

        jRParada.setBackground(new java.awt.Color(255, 255, 255));
        ParadasOEjecucion.add(jRParada);
        jRParada.setText("Parada");
        jRParada.setEnabled(false);
        jRParada.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRParadaActionPerformed(evt);
            }
        });

        jREjecucion.setBackground(new java.awt.Color(255, 255, 255));
        ParadasOEjecucion.add(jREjecucion);
        jREjecucion.setSelected(true);
        jREjecucion.setText("Ejecución");
        jREjecucion.setEnabled(false);
        jREjecucion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jREjecucionActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPDetallesLayout = new javax.swing.GroupLayout(jPDetalles);
        jPDetalles.setLayout(jPDetallesLayout);
        jPDetallesLayout.setHorizontalGroup(
            jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPDetallesLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPDetallesLayout.createSequentialGroup()
                        .addGap(18, 18, 18)
                        .addComponent(jLabel18)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel17)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel10)
                        .addGap(15, 15, 15))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPDetallesLayout.createSequentialGroup()
                        .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPDetallesLayout.createSequentialGroup()
                                .addComponent(jLIngreso, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addGap(18, 18, 18))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPDetallesLayout.createSequentialGroup()
                                .addGap(0, 21, Short.MAX_VALUE)
                                .addComponent(jREjecucion)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jRParada)
                                .addGap(29, 29, 29)))
                        .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(cbTipoEjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 140, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPDetallesLayout.createSequentialGroup()
                                .addComponent(jLabel20)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel21, javax.swing.GroupLayout.PREFERRED_SIZE, 119, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jDeEntrega, javax.swing.GroupLayout.PREFERRED_SIZE, 158, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap())
        );
        jPDetallesLayout.setVerticalGroup(
            jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPDetallesLayout.createSequentialGroup()
                .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel10)
                    .addComponent(jLabel17)
                    .addComponent(jLabel18))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLIngreso, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jDeEntrega, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPDetallesLayout.createSequentialGroup()
                        .addGap(29, 29, 29)
                        .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jREjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jRParada, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPDetallesLayout.createSequentialGroup()
                        .addGap(18, 18, 18)
                        .addGroup(jPDetallesLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel21)
                            .addComponent(jLabel20))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(cbTipoEjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(0, 14, Short.MAX_VALUE))
        );

        jPanel2.add(jPDetalles, new org.netbeans.lib.awtextra.AbsoluteConstraints(470, 30, 370, 150));

        jPanel5.setBackground(new java.awt.Color(255, 255, 255));
        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel5.setLayout(null);

        btnNuevo.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_Proyect.png"))); // NOI18N
        btnNuevo.setBorderPainted(false);
        btnNuevo.setContentAreaFilled(false);
        btnNuevo.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnNuevo.setFocusPainted(false);
        btnNuevo.setFocusable(false);
        btnNuevo.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_prpyect_roll.png"))); // NOI18N
        btnNuevo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnNuevoActionPerformed(evt);
            }
        });
        jPanel5.add(btnNuevo);
        btnNuevo.setBounds(2, 2, 57, 45);

        btnGuardar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_proyect.png"))); // NOI18N
        btnGuardar.setBorderPainted(false);
        btnGuardar.setContentAreaFilled(false);
        btnGuardar.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnGuardar.setEnabled(false);
        btnGuardar.setFocusPainted(false);
        btnGuardar.setFocusable(false);
        btnGuardar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_roll.png"))); // NOI18N
        btnGuardar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGuardarActionPerformed(evt);
            }
        });
        jPanel5.add(btnGuardar);
        btnGuardar.setBounds(59, 0, 57, 49);

        btnBuscar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/search.png"))); // NOI18N
        btnBuscar.setBorderPainted(false);
        btnBuscar.setContentAreaFilled(false);
        btnBuscar.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnBuscar.setFocusPainted(false);
        btnBuscar.setFocusable(false);
        btnBuscar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/search_roll.png"))); // NOI18N
        btnBuscar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnBuscarActionPerformed(evt);
            }
        });
        jPanel5.add(btnBuscar);
        btnBuscar.setBounds(118, 2, 57, 45);

        btnUpdate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update.png"))); // NOI18N
        btnUpdate.setBorderPainted(false);
        btnUpdate.setContentAreaFilled(false);
        btnUpdate.setEnabled(false);
        btnUpdate.setFocusPainted(false);
        btnUpdate.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update1.png"))); // NOI18N
        btnUpdate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnUpdateActionPerformed(evt);
            }
        });
        jPanel5.add(btnUpdate);
        btnUpdate.setBounds(175, 2, 60, 45);

        btnDelete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/delete.png"))); // NOI18N
        btnDelete.setBorderPainted(false);
        btnDelete.setContentAreaFilled(false);
        btnDelete.setEnabled(false);
        btnDelete.setFocusPainted(false);
        btnDelete.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/delete1 (2).png"))); // NOI18N
        btnDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnDeleteActionPerformed(evt);
            }
        });
        jPanel5.add(btnDelete);
        btnDelete.setBounds(232, 0, 58, 49);

        btnActivar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/chek-user.png"))); // NOI18N
        btnActivar.setBorderPainted(false);
        btnActivar.setContentAreaFilled(false);
        btnActivar.setEnabled(false);
        btnActivar.setFocusPainted(false);
        btnActivar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/chek-user1.png"))); // NOI18N
        btnActivar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnActivarActionPerformed(evt);
            }
        });
        jPanel5.add(btnActivar);
        btnActivar.setBounds(230, 0, 60, 50);

        jPanel2.add(jPanel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 450, 292, 50));

        Notificacion1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        Notificacion1.setForeground(new java.awt.Color(128, 128, 131));
        Notificacion1.setText("Estado");
        jPanel2.add(Notificacion1, new org.netbeans.lib.awtextra.AbsoluteConstraints(770, 10, 90, 20));

        jLIDConversor.setText("0");
        jPanel2.add(jLIDConversor, new org.netbeans.lib.awtextra.AbsoluteConstraints(150, 180, 10, -1));

        jLIDTroquel.setText("0");
        jPanel2.add(jLIDTroquel, new org.netbeans.lib.awtextra.AbsoluteConstraints(240, 180, 10, -1));

        jLIDRepujado.setText("0");
        jPanel2.add(jLIDRepujado, new org.netbeans.lib.awtextra.AbsoluteConstraints(320, 180, 10, -1));

        jLIDStencil.setText("0");
        jPanel2.add(jLIDStencil, new org.netbeans.lib.awtextra.AbsoluteConstraints(400, 180, 10, -1));

        jLIDCircuito.setText("0");
        jPanel2.add(jLIDCircuito, new org.netbeans.lib.awtextra.AbsoluteConstraints(480, 180, 10, -1));

        jLIDPCB.setText("0");
        jPanel2.add(jLIDPCB, new org.netbeans.lib.awtextra.AbsoluteConstraints(560, 180, 10, -1));

        jLIDTeclado.setText("0");
        jPanel2.add(jLIDTeclado, new org.netbeans.lib.awtextra.AbsoluteConstraints(640, 180, 10, -1));

        jLIDIntegracion.setText("0");
        jPanel2.add(jLIDIntegracion, new org.netbeans.lib.awtextra.AbsoluteConstraints(720, 180, 10, -1));

        btnTomaTiempos.setText("Toma de tiempos");
        btnTomaTiempos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnTomaTiemposActionPerformed(evt);
            }
        });
        jPanel2.add(btnTomaTiempos, new org.netbeans.lib.awtextra.AbsoluteConstraints(20, 510, 150, -1));

        jTNovedades.setColumns(20);
        jTNovedades.setRows(5);
        jTNovedades.setWrapStyleWord(true);
        jTNovedades.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTNovedadesKeyTyped(evt);
            }
        });
        jScrollPane1.setViewportView(jTNovedades);

        jPanel2.add(jScrollPane1, new org.netbeans.lib.awtextra.AbsoluteConstraints(550, 450, 290, 150));

        jLEstado.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLEstado.setForeground(new java.awt.Color(51, 204, 0));
        jLEstado.setText("-");
        jPanel2.add(jLEstado, new org.netbeans.lib.awtextra.AbsoluteConstraints(150, 580, -1, -1));

        jLNCaracteres.setFont(new java.awt.Font("Tahoma", 1, 10)); // NOI18N
        jLNCaracteres.setForeground(new java.awt.Color(128, 128, 131));
        jLNCaracteres.setText("250");
        jPanel2.add(jLNCaracteres, new org.netbeans.lib.awtextra.AbsoluteConstraints(818, 600, -1, -1));

        jPEstadoProyecto.setBackground(new java.awt.Color(255, 255, 255));
        jPEstadoProyecto.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Estado Proyecto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Arial", 1, 11), new java.awt.Color(128, 128, 131))); // NOI18N

        jDNFEE.setToolTipText("");
        jDNFEE.setDateFormatString("dd/MM/yyyy");
        jDNFEE.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N

        jRATiempo.setBackground(new java.awt.Color(255, 255, 255));
        estadoProyecto.add(jRATiempo);
        jRATiempo.setFont(new java.awt.Font("Arial", 1, 12)); // NOI18N
        jRATiempo.setForeground(new java.awt.Color(128, 128, 131));
        jRATiempo.setText("A tiempo");

        jRRetraso.setBackground(new java.awt.Color(255, 255, 255));
        estadoProyecto.add(jRRetraso);
        jRRetraso.setFont(new java.awt.Font("Arial", 1, 12)); // NOI18N
        jRRetraso.setForeground(new java.awt.Color(128, 128, 131));
        jRRetraso.setText("Retraso");

        jLCircuitoFE1.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLCircuitoFE1.setForeground(new java.awt.Color(128, 128, 131));
        jLCircuitoFE1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLCircuitoFE1.setText("NFEE");

        javax.swing.GroupLayout jPEstadoProyectoLayout = new javax.swing.GroupLayout(jPEstadoProyecto);
        jPEstadoProyecto.setLayout(jPEstadoProyectoLayout);
        jPEstadoProyectoLayout.setHorizontalGroup(
            jPEstadoProyectoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEstadoProyectoLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPEstadoProyectoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jRATiempo, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jRRetraso, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(18, 18, 18)
                .addGroup(jPEstadoProyectoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPEstadoProyectoLayout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jDNFEE, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLCircuitoFE1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPEstadoProyectoLayout.setVerticalGroup(
            jPEstadoProyectoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEstadoProyectoLayout.createSequentialGroup()
                .addGroup(jPEstadoProyectoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPEstadoProyectoLayout.createSequentialGroup()
                        .addComponent(jRATiempo)
                        .addGap(5, 5, 5)
                        .addComponent(jRRetraso))
                    .addGroup(jPEstadoProyectoLayout.createSequentialGroup()
                        .addComponent(jLCircuitoFE1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jDNFEE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGap(23, 23, 23))
        );

        jPanel2.add(jPEstadoProyecto, new org.netbeans.lib.awtextra.AbsoluteConstraints(280, 510, 260, 80));

        jLNovedades.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLNovedades.setForeground(new java.awt.Color(128, 128, 131));
        jLNovedades.setText("Novedades:");
        jPanel2.add(jLNovedades, new org.netbeans.lib.awtextra.AbsoluteConstraints(470, 460, -1, -1));

        jLNovedades2.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLNovedades2.setForeground(new java.awt.Color(128, 128, 131));
        jLNovedades2.setText("Estado de lectura:");
        jPanel2.add(jLNovedades2, new org.netbeans.lib.awtextra.AbsoluteConstraints(30, 580, -1, -1));

        GenerarQR.setText("GenerarQR");
        GenerarQR.setEnabled(false);
        GenerarQR.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GenerarQRActionPerformed(evt);
            }
        });
        jPanel2.add(GenerarQR, new org.netbeans.lib.awtextra.AbsoluteConstraints(320, 460, -1, -1));

        jLabel14.setFont(new java.awt.Font("Arial", 1, 11)); // NOI18N
        jLabel14.setForeground(new java.awt.Color(189, 189, 189));
        jLabel14.setText("Colcircuitos");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, 863, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel14)
                .addGap(24, 24, 24))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, 606, Short.MAX_VALUE)
                .addGap(2, 2, 2)
                .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

    private void btnNuevoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevoActionPerformed
        accion = 1;
        activarComponentes();
        consultarUltimoNumeroDeOrdenDisponible();
        // ...
        consultarFechaActualServidor();
        limpiarID();
        ocultarFechas();
        // ...
        jPEstadoProyecto.setVisible(false);
    }//GEN-LAST:event_btnNuevoActionPerformed

    public void modificarInformacionProyecto() {
            int seleccion = JOptionPane.showOptionDialog(null, "¿Seguro desea modificar la información de este proyecto?",
                    "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                    new Object[]{"SI", "NO"}, "SI");
            
            if (seleccion == 0) {
                
                validarFormularioDeProyecto(accion);
                
            }
    }
    
    private void btnBuscarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnBuscarActionPerformed
        ConsutaProyecto viewConsultar = new ConsutaProyecto(this);
        viewConsultar.setLocationRelativeTo(null);
        viewConsultar.setVisible(true);
    }//GEN-LAST:event_btnBuscarActionPerformed

    private void btnUpdateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdateActionPerformed
        modificarInformacionProyecto();
    }//GEN-LAST:event_btnUpdateActionPerformed

    private void btnGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardarActionPerformed
        int seleccion = JOptionPane.showOptionDialog(null, "¿Seguro desea registrar este proyecto?",
                "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                new Object[]{"SI", "NO"}, "SI");
        // ...
        if (seleccion == 0) {
            Proyecto obj = new Proyecto();
            if (obj.validarExistenciaNumerOrden(Integer.parseInt(jTNorden.getText()))) {
                
                new rojerusan.RSNotifyAnimated("¡Alerta!", "Este numero de orden ya existe.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
            
            } else {
                
                validarFormularioDeProyecto(1);
                
            }
        }   
        // ...
    }//GEN-LAST:event_btnGuardarActionPerformed

    public void accionBtnGuardarProyecto(){
        Proyecto obj = new Proyecto();
            if (obj.validarExistenciaNumerOrden(Integer.parseInt(jTNorden.getText()))) {
                
                new rojerusan.RSNotifyAnimated("¡Alerta!", "Este numero de orden ya existe.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
                //Colocar formulario en estado inicial
                limpiarCamposFormulario();
                estadoInicialComponentesFormulario();
                estadoInicialBotonesFormulario();
                btnNuevo.setEnabled(true);
                
            } else {
                validarFormularioDeProyecto(accion);
            }
    }    
    
    private void jTNombreClienteKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreClienteKeyTyped
        char cara = evt.getKeyChar();
        if (Character.isDigit(cara) || evt.getKeyChar() == '|') {
            evt.consume();
        }
    }//GEN-LAST:event_jTNombreClienteKeyTyped

    private void jTConversorKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTConversorKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTConversorKeyTyped

    private void jTTroquelKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTTroquelKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTTroquelKeyTyped

    private void jTRepujadoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTRepujadoKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTRepujadoKeyTyped

    private void jTStencilKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTStencilKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTStencilKeyTyped

    private void jTCircuitoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTCircuitoKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTCircuitoKeyTyped

    private void jTPCBTEKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTPCBTEKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTPCBTEKeyTyped

    private void jTTecladoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTTecladoKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTTecladoKeyTyped

    private void jTIntegracionKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTIntegracionKeyTyped
        numerosT(evt);
    }//GEN-LAST:event_jTIntegracionKeyTyped

    private void btnTomaTiemposActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnTomaTiemposActionPerformed
        Menu principal = new Menu();
        detalleProduccion obj = new detalleProduccion(principal, true, Integer.parseInt(jTNorden.getText()), 5, 4, Menu.cargo);
        obj.setLocationRelativeTo(null);
        obj.setVisible(true);
    }//GEN-LAST:event_btnTomaTiemposActionPerformed

    private void btnDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnDeleteActionPerformed
        if (JOptionPane.showOptionDialog(null, "¿Seguro desea eliminar este proyecto?",
                "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                new Object[]{"SI", "NO"}, "SI") == 0) {
            Proyecto obj = new Proyecto();
            if (obj.EliminarProyecto(Integer.parseInt(jTNorden.getText()))) {
                //Eliminación fue realizada correactamente.
                //Mensaje
                new rojerusan.RSNotifyAnimated("Listo.", "El proyecto con la orden " + jTNorden.getText() + " fue eliminada exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                limpiarCamposFormulario();
                limpiarID();
                estadoInicialBotonesFormulario();
                estadoInicialComponentesFormulario();
            } else {
                //Error al realizar la eliminación del proyecto.
                //Mensaje
                new rojerusan.RSNotifyAnimated("¡Alerta!", "El proyecto no pudo ser eliminado correctamente, por favor intentalo de nuevo.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        }
    }//GEN-LAST:event_btnDeleteActionPerformed

    private void btnActivarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnActivarActionPerformed
        if (JOptionPane.showOptionDialog(null, "¿Seguro desea reactivar este proyecto?",
                "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                new Object[]{"SI", "NO"}, "SI") == 0) {
            Proyecto obj = new Proyecto();
            if (obj.ReacttivarProyecto(Integer.parseInt(jTNorden.getText()))) {
                //Eliminación fue realizada correactamente.
                //Mensaje
                new rojerusan.RSNotifyAnimated("Listo.", "El proyecto con la orden " + jTNorden.getText() + " fue reactivado coreectamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                limpiarCamposFormulario();
                limpiarID();
                estadoInicialBotonesFormulario();
                estadoInicialComponentesFormulario();
            } else {
                //Error al realizar la eliminación del proyecto.
                //Mensaje
                new rojerusan.RSNotifyAnimated("¡Alerta!", "El proyecto no pudo ser reactivado correctamente, por favor intentalo de nuevo.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        }
    }//GEN-LAST:event_btnActivarActionPerformed

    private void jCConversorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCConversorActionPerformed
        activarjTfilex(jCConversor, jTConversor);
    }//GEN-LAST:event_jCConversorActionPerformed

    private void jCTroquelActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCTroquelActionPerformed
        activarjTfilex(jCTroquel, jTTroquel);
    }//GEN-LAST:event_jCTroquelActionPerformed

    private void jCRepujadoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCRepujadoActionPerformed
        activarjTfilex(jCRepujado, jTRepujado);
    }//GEN-LAST:event_jCRepujadoActionPerformed

    private void jCStencilActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCStencilActionPerformed
        activarjTfilex(jCStencil, jTStencil);
    }//GEN-LAST:event_jCStencilActionPerformed

    private void jCCircuitoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCCircuitoActionPerformed
        activarjTfilex(jCCircuito, jTCircuito);
        boolean estado = false;
        if (jCCircuito.isSelected()) {
            estado = true;
        }
        cbMaterialCircuito.setEnabled(estado);
        cbColorCircuito.setEnabled(estado);
        cbEspesorCircuito.setEnabled(estado);
        jCRuteoC.setEnabled(estado);
        //Validacion para saber si lleva otras fechas de control.
        fechaEntregaFEoGF();
    }//GEN-LAST:event_jCCircuitoActionPerformed

    private void jCPCBTEActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCPCBTEActionPerformed
        activarjTfilex(jCPCBTE, jTPCBTE);
        if (jCPCBTE.isSelected()) {
            cbMaterialPCBTE.setEnabled(true);
            cbColorPCB.setEnabled(true);
            cbEspesorPCB.setEnabled(true);
            jCRuteoP.setEnabled(true);
        } else {
            cbMaterialPCBTE.setEnabled(false);
            cbMaterialPCBTE.setSelectedIndex(0);
            cbColorPCB.setEnabled(false);
            cbEspesorPCB.setEnabled(false);
            jCRuteoP.setEnabled(false);
            jRPCBCOM.setEnabled(false);
            jCPIntegracionPCB.setEnabled(false);
            jRPCBCOM.setSelected(false);
            jCPIntegracionPCB.setSelected(false);
            jDFechaEntregaPCBEN.setDate(null);
            jDFechaEntregaPCBEN.setVisible(false);
            jLPCBTE.setVisible(false);
            jDFechaEntregaPCBCOMGF.setDate(null);
            jDFechaEntregaPCBCOMGF.setVisible(false);
            jLpcbGF.setVisible(false);
        }
    }//GEN-LAST:event_jCPCBTEActionPerformed

    private void jCTecladoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCTecladoActionPerformed
        activarjTfilex(jCTeclado, jTTeclado);
    }//GEN-LAST:event_jCTecladoActionPerformed

    private void jCIntegracionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCIntegracionActionPerformed
        activarjTfilex(jCIntegracion, jTIntegracion);
        // ...
        fechaEntregaFEoGF();
    }//GEN-LAST:event_jCIntegracionActionPerformed

    private void jRParadaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRParadaActionPerformed
        cambiarEstadoProyectoEjecucionOParada(0);
    }//GEN-LAST:event_jRParadaActionPerformed

    private void jREjecucionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jREjecucionActionPerformed
        cambiarEstadoProyectoEjecucionOParada(1);
    }//GEN-LAST:event_jREjecucionActionPerformed

    private void cbMaterialCircuitoItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbMaterialCircuitoItemStateChanged
        //Necesito controlar esto
        if (cbMaterialCircuito.getSelectedIndex() == 3 || cbMaterialCircuito.getSelectedIndex() == 0) {//Gran formato
//            cbColorCircuito.setEnabled(false);
            cbColorCircuito.setSelectedIndex(0);
            jCRuteoC.setEnabled(false);
            jCRuteoC.setSelected(false);
        } else {
            if(accion == 1){
                cbColorCircuito.setEnabled(true);
                jCRuteoC.setEnabled(true);
            }
        }

        fechaEntregaFEoGF();
    }//GEN-LAST:event_cbMaterialCircuitoItemStateChanged

    private void cbMaterialPCBTEItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbMaterialPCBTEItemStateChanged
        if (cbMaterialPCBTE.getSelectedIndex() != 0) {
            if (cbMaterialPCBTE.getSelectedIndex() == 3) {
//                cbColorPCB.setEnabled(false);
                cbColorPCB.setSelectedIndex(0);
                jCRuteoP.setEnabled(false);
                jCRuteoP.setSelected(false);
            } else {
                if(accion==1){
                    cbColorPCB.setEnabled(true);
                    jCRuteoP.setEnabled(true);
                }
            }
            jRPCBCOM.setEnabled(true);
            jCPIntegracionPCB.setEnabled(true);
        } else {
            jRPCBCOM.setEnabled(false);
            jCPIntegracionPCB.setEnabled(false);
        }
    }//GEN-LAST:event_cbMaterialPCBTEItemStateChanged

    private void jRPCBCOMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRPCBCOMActionPerformed
        if (jRPCBCOM.isSelected()) {
            jLpcbGF.setVisible(true);
            jDFechaEntregaPCBCOMGF.setVisible(true);
        } else {
            jLpcbGF.setVisible(false);
            jDFechaEntregaPCBCOMGF.setVisible(false);
            jDFechaEntregaPCBCOMGF.setDate(null);
        }
    }//GEN-LAST:event_jRPCBCOMActionPerformed

    private void jTNombreProyectoKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreProyectoKeyReleased
        validarCampos();
    }//GEN-LAST:event_jTNombreProyectoKeyReleased

    private void jTNombreClienteKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreClienteKeyReleased
        validarCampos();
    }//GEN-LAST:event_jTNombreClienteKeyReleased

    private void jTNovedadesKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNovedadesKeyTyped
        if (jTNovedades.getText().length() >= 250) {
            evt.consume();
        }
        caracteresRestantes(jTNovedades.getText().length());
    }//GEN-LAST:event_jTNovedadesKeyTyped

    private void jDeEntregaPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jDeEntregaPropertyChange
        validarCampos();
    }//GEN-LAST:event_jDeEntregaPropertyChange

    private void cbTipoEjecucionItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbTipoEjecucionItemStateChanged
        validarCampos();
    }//GEN-LAST:event_cbTipoEjecucionItemStateChanged

    private void jTPCBTEActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTPCBTEActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTPCBTEActionPerformed

    private void GenerarQRActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_GenerarQRActionPerformed
        generarQRdeProduccion();
    }//GEN-LAST:event_GenerarQRActionPerformed

    private void cbEspesorCircuitoItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbEspesorCircuitoItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbEspesorCircuitoItemStateChanged

    private void cbEspesorPCBItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbEspesorPCBItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbEspesorPCBItemStateChanged

    private void cbColorCircuitoItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbColorCircuitoItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbColorCircuitoItemStateChanged

    private void cbColorPCBItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbColorPCBItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbColorPCBItemStateChanged

    private void jTTPCBENKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTTPCBENKeyTyped
        // TODO add your handling code here:
    }//GEN-LAST:event_jTTPCBENKeyTyped

    private void jCPIntegracionPCBActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCPIntegracionPCBActionPerformed
        activarjTfilex(jCPIntegracionPCB, jTTPCBEN);
        //...
        if (jCPIntegracionPCB.isSelected()) {
            jLPCBTE.setVisible(true);
            jDFechaEntregaPCBEN.setVisible(true);
        } else {
            jLPCBTE.setVisible(false);
            jDFechaEntregaPCBEN.setVisible(false);
            jDFechaEntregaPCBEN.setDate(null);
        }
    }//GEN-LAST:event_jCPIntegracionPCBActionPerformed
//Metodos---------------------------------------------------------------------->

    private void cambiarEstadoProyectoEjecucionOParada(int accion) {
        // Accion 1 = Activar 2 = Parar
        int seleccion = JOptionPane.showOptionDialog(null, (accion == 1) ? "¿Seguro desea poner en ejecucion este numero de orden?" : "¿Seguro desea parar este numero de orden?",
                "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                new Object[]{"SI", "NO"}, "SI");
        if (seleccion == 0) {
//            if (estadoProyecto()) {<---- Este metodo se va a eliminar
                if (estadoDeOrden(accion)) {
                    //Mensaje de cambio de estado todo un exito.
//                    modificarInformacionProyecto(1);//Modifica sin preguntar <-- Esto ya no se va a realizar acá...
                    new rojerusan.RSNotifyAnimated("Listo!", "El estado del proyecto fue cambiado exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                    limpiarCamposFormulario();
                    limpiarID();
                    estadoInicialComponentesFormulario();
                    estadoInicialBotonesFormulario();
                    ocultarFechas();
                }
//            } else {
//                new rojerusan.RSNotifyAnimated("Alerta!", "No se puede cambiar el estado del proyecto porque esta en ejecución.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
//            }
        } else {
            if (accion == 1) {//No esta parada
                jRParada.setSelected(true);
            } else {//esta parada
                jREjecucion.setSelected(true);
            }
        }
    }

//    private boolean estadoProyecto() { // Esto ya no se va a utilizar más
//        Proyecto obj = new Proyecto();
//        return obj.estadoProyecto(Integer.parseInt(jTNorden.getText()));
//    }

    private boolean estadoDeOrden(int estado) {
        Proyecto obj = new Proyecto();
        return obj.estadoDeOrden(Integer.parseInt(jTNorden.getText()), estado);
    }

    private Paragraph tipoProyecto(int tipo, int negocio) {
        Paragraph tipoPrpyecto = new Paragraph();
        String tip = "", negoci = "";
        switch (negocio) {
            case 1:
                negoci = "FE";
                break;
            case 2:
                negoci = "TE";
                break;
            case 3:
                negoci = "EN";
                break;
            default:
                break;
        }

        switch (tipo) {
            case 1:
                tip = "Circuito";
                break;
            case 2:
                tip = "Conversor";
                break;
            case 3:
                tip = "Repujado";
                break;
            case 4:
                tip = "Troquel";
                break;
            case 5:
                tip = "Teclado";
                break;
            case 6:
                tip = "Stencil";
                break;
            case 7:
                tip = "PCB";
                break;
            case 12:
                tip = "Circuito-TE";
                break;
        }
        tipoPrpyecto.setFont(new Font(Font.FontFamily.HELVETICA, 7, Font.NORMAL));
        tipoPrpyecto.add(negoci + " - " + tip + "\n");
        tipoPrpyecto.setAlignment(1);
        tipoPrpyecto.setSpacingAfter(8);
        return tipoPrpyecto;
    }

    private String tipoProyectoImagen(int tipo, int negocio) {
        String tip = "", negoci = "";
        switch (negocio) {
            case 1:
                negoci = "FE";
                break;
            case 2:
                negoci = "TE";
                break;
            case 3:
                negoci = "EN";
                break;
            default:
                break;
        }

        switch (tipo) {
            case 1:
                tip = "Circuito";
                break;
            case 2:
                tip = "Conversor";
                break;
            case 3:
                tip = "Repujado";
                break;
            case 4:
                tip = "Troquel";
                break;
            case 5:
                tip = "Teclado";
                break;
            case 6:
                tip = "Stencil";
                break;
            case 7:
                tip = "PCB";
                break;
            case 12:
                tip = "Circuito-TE";
                break;
        }

        return negoci + " " + tip;
    }

    public void fechaEntregaFEoGF() {
        if (jCIntegracion.isSelected() && jCCircuito.isSelected()) {
            if (cbMaterialCircuito.getSelectedItem().toString().equals("TH") || cbMaterialCircuito.getSelectedItem().toString().equals("FV")) {
                //Se activa la fecha de entrega de FE para ensamble
                jLCircuitoFE.setText("Fecha de entrega FE Circuito");
                jLCircuitoFE.setVisible(true);
                jDFechaEntregaFE.setVisible(true);
            } else if (cbMaterialCircuito.getSelectedItem().toString().equals("GF")) {
                jLCircuitoFE.setText("Fecha de entrega GF Circuito");
                jLCircuitoFE.setVisible(true);
                jDFechaEntregaFE.setVisible(true);
            }
            jLComCircuitos.setVisible(true);
            jDFechaEntregaFECOM.setVisible(true);
        } else {
            jLComCircuitos.setVisible(false);
            jDFechaEntregaFECOM.setVisible(false);
            jDFechaEntregaFECOM.setDate(null);
            jLCircuitoFE.setVisible(false);
            jDFechaEntregaFE.setVisible(false);
            jDFechaEntregaFE.setDate(null);
        }
    }

    public void ocultarFechas() {
        //1
        jLCircuitoFE.setVisible(false);
        jDFechaEntregaFE.setVisible(false);
        //2
        jLComCircuitos.setVisible(false);
        jDFechaEntregaFECOM.setVisible(false);
        //3
        jLPCBTE.setVisible(false);
        jDFechaEntregaPCBEN.setVisible(false);
        //4
        jLpcbGF.setVisible(false);
        jDFechaEntregaPCBCOMGF.setVisible(false);
    }

    private void generarQRdeProduccion() {
        //Se puede Cambiar la libreria con la cual se generar las QR (Fijarse en el programa generador de QR) que es mucho más facil de utilizar
        try {
            int cont = 0;
            //Validar o crear carpeta
//            String rutaFolder = System.getProperty("user.dir");// Ruta donde tengo el proyecto
            //...
//            JFileChooser Chocer = new JFileChooser();
//            Chocer.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
//            Chocer.setLocation(500, 500);
//            Chocer.showOpenDialog(this);
//            File guardar = Chocer.getSelectedFile();
//            if (guardar != null) {
                //Consultar Ruta de guardado de los QR
                rutaQR ruta=new rutaQR();
                ruta.consultarRutaQR(Menu.jDocumento.getText());
                String path= ruta.getRutaQR();
                //...
                if(path!=null){
                    //...
                    if (path.codePointAt(path.length() - 1) == 92) {//92= Código ASCII de \
                        //...
                        File folder = new File(path + "ImágenesQR");//Nombre de la carpeta
                        if (!folder.exists()) {
                            folder.mkdirs();
                        }
                        //Tamaño de la fuente    
                        Font tall = new Font();
                        tall.setSize(7);
                        //Generar codigos QR
                        //Encabezado
                        PdfPCell header = new PdfPCell();
//                      Image logo = Image.getInstance(getClass().getResource("/imagenesEmpresa/logo.png"));
//                      logo.scaleAbsolute(350, 125);
//                      logo.setAlignment(Image.ALIGN_CENTER);
                        header.setBorder(Rectangle.NO_BORDER);
                        header.setColspan(4);
//                      tabla.addCell(header);
//                      tabla.setWidthPercentage(100);
//                      tabla.setWidths(new float[]{3, 3, 3});
                        //se creo y se abrio el documento        L   R   T   B
                        Document doc = new Document(PageSize.A4, 20, 150, 30, 170);
                        //se obtine la ruta del proyecto en tiempo de ejecucion.
//                      String ruta = System.getProperty("user.dir");
                        PdfWriter pdf = PdfWriter.getInstance(doc, new FileOutputStream(path + jTNorden.getText() + ".pdf"));
                        doc.open();
//                      doc.add(logo);
                        consultarFechaActualServidor();
//                      doc.add(new Paragraph("Generado: " + fecha));
                        //Informacion del QR desde la base de datos
                        Controlador.Proyecto obj = new Controlador.Proyecto();
                        CachedRowSet crs = obj.Consultar_informacion_para_el_QR(Integer.parseInt(jTNorden.getText()));
                        while (crs.next()) {
                            //Crear tabla de codigos QR
                            PdfPTable tabla = new PdfPTable(4);
                            tabla.addCell(header);
                            tabla.setWidthPercentage(100);
                            tabla.setWidths(new float[]{3, 3, 3, 3});
                            //Creo la cadena de texto que contendra el QR
                            if (crs.getInt(3) != 4 && (crs.getString("material")==null?true:!crs.getString("material").equals("GF"))) {// Para los productos que tienen como material GF no es necesario generarles códigos QR
                                QRCode cod = new QRCode();//Libreria para los QR
                                //Numero de orden         //idDetalleProducto             //area 
                                String texto = jTNorden.getText() + ';' + crs.getInt(1) + ';' + crs.getInt(3);
                                cod.setData(texto);
                                cod.setDataMode(QRCode.MODE_BYTE);
//                              ...
                                cod.setUOM(udm);
                                cod.setLeftMargin(mi);
                                cod.setResolution(resol);
                                cod.setRightMargin(md);
                                cod.setTopMargin(ms);
                                cod.setBottomMargin(min);
                                cod.setRotate(rot);
                                cod.setModuleSize(tam);//Tamaño del QR con el cul se genera
                                cod.renderBarcode(path + "ImágenesQR\\" + jTNorden.getText() + " " + tipoProyectoImagen(crs.getInt(2), crs.getInt(3)) + ".png");
//                              ...
                                Image imagenQR = Image.getInstance(path + "ImágenesQR\\" + jTNorden.getText() + " " + tipoProyectoImagen(crs.getInt(2), crs.getInt(3)) + ".png");
                                // ...
                                imagenQR.setWidthPercentage(60);//Tamaño del QR con el cual va a ser insertado en el documento PDF
                                imagenQR.setAlignment(Image.ALIGN_CENTER);//Alineamiento de lo Codigos en las celdas
                                //Personalizar cell
                                PdfPCell celda = new PdfPCell();
//                              celda.setBorder(Rectangle.NO_BORDER);
                                //Numero de orden del proyecto
                                Paragraph orden = new Paragraph("Orden: " + jTNorden.getText(), tall);
                                orden.setAlignment(1);
                                celda.addElement(orden);
                                //Referencia de área y producto
                                celda.addElement(tipoProyecto(crs.getInt(2), crs.getInt(3)));
                                //Imagen de QR
                                celda.addElement(imagenQR);
                                //Fecha de entrega del proyecto
                                Paragraph Fecha = new Paragraph("Entrega: " + crs.getString(4), tall);
                                Fecha.setAlignment(1);
                                celda.addElement(Fecha);
                                //Nombre del proyecto
                                Paragraph proyecto = new Paragraph("Proyecto: " + crs.getString(5), tall);
                                proyecto.setAlignment(1);
                                celda.addElement(proyecto);
                                if ((crs.getInt(2) == 1 || crs.getInt(2) == 12) && (crs.getInt(2) == 1)) {
                                    //Material del equipo
                                    Paragraph material = new Paragraph("Material: " + crs.getString(7), tall);
                                    material.setAlignment(1);
                                    celda.addElement(material);
                                }
                                //Cantidad Total de equipos
                                Paragraph cantidad = new Paragraph("Cantidad: " + crs.getString(6), tall);
                                cantidad.setAlignment(1);
                                celda.addElement(cantidad);
                                
                                int j = (crs.getInt(3) == 1 ? ((crs.getInt(2) == 1 || crs.getInt(2) == 12) ? 12 : 4) : 4);
                                
                                for (int i = 0; i < j; i++) {
                                    tabla.addCell(celda);
                                }
//                              Elimina las imagenes del QR 
//                              El nombre de la imagen se puede hacer para que lo retorne una funcion para que sea una manera más optima de hacerlo
                                File QRdelet = new File(path + "ImágenesQR\\" + jTNorden.getText() + " " + tipoProyectoImagen(crs.getInt(2), crs.getInt(3)) + ".png");
                                QRdelet.delete();
                                //...
                                cont++;
                                header.setBorder(Rectangle.NO_BORDER);
                                header.addElement(new Paragraph());
                                header.setColspan(4);
                                tabla.addCell(header);
                                doc.add(tabla);
                            }
                            tabla = null;
                            //Agregar una nueva hoja de PDF
                            doc.newPage();
                        }
                        crs.close();
                        doc.close();
                        //...
                        if (cont == 0) {
                            File PDF = new File(path + jTNorden.getText() + ".pdf");
                            PDF.delete();
                        } else {
                            new rojerusan.RSNotifyAnimated("¡Listo!", "Los codigos QR de la orden N°" + jTNorden.getText() + " fueron generados exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                            System.gc();//Garbages collector.
                        }
                        //...
                    } else {
                        //... Mensaje de error
                        new rojerusan.RSNotifyAnimated("¡ERROR!", "La ruta de destino no esta bien especificada.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                    }                    
                }else{
                    //...
                    new rojerusan.RSNotifyAnimated("¡Alerta!", "No tiene una ruta de destino especificada.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
                }
                //...
//            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    private void validarFormularioDeProyecto(int accion) {
        //Validar los campos principales del proyecto-------------------------->
        if (jDeEntrega.getDate() != null && cbTipoEjecucion.getSelectedIndex() > 0 &&
            !jTNombreCliente.getText().equals("") && !jTNombreProyecto.getText().equals("") &&
            contarRadiosPresionados() == validarCantidadesIngresadasProductos() &&
            contarRadiosPresionados() > 0 && validarCantidadesIngresadasProductos() > 0 &&
            validarFechaEntregaSiguienteProceso() && validarFechaEntregaPCB()) {
            
            //Ten en cuenta que se tiene que validar cuando se vaya a modificar estos mismos campos para saber si se elimina las fechas o no se eliminan.
            registrarModificarInformacionDelProyecto(accion);
            
        } else {
            new rojerusan.RSNotifyAnimated("¡Error!", "Falta algun campo por diligenciar.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
        }
    }

    private boolean validarFechaEntregaSiguienteProceso() {//Este metodo valida los campos de fecha para evitar que esten vacios
        boolean respuesta = true;
        if (jCCircuito.isSelected() && jCIntegracion.isSelected()) {
            if (jDFechaEntregaFECOM.getDate() != null && jDFechaEntregaFE.getDate() != null) {
                respuesta = true;
            } else {
                respuesta = false;
            }
        }
        return respuesta;
    }

    private boolean validarFechaEntregaPCB() {
        boolean respues = true;
        if (jCPCBTE.isSelected()) {
            if (jCPIntegracionPCB.isSelected() && jCPCBTE.isSelected()) {
                if (jCPIntegracionPCB.isSelected() && jRPCBCOM.isSelected()) {//Integración y Componentes
                    if (jDFechaEntregaPCBCOMGF.getDate() != null && jDFechaEntregaPCBEN.getDate() != null) {
                        respues = true;
                    } else {
                        respues = false;
                    }
                } else if (jCPIntegracionPCB.isSelected()) {//Solo integración
                    if (jDFechaEntregaPCBEN.getDate() != null) {// Pre condición:jDFechaEntregaPCBCOMGF.getDate() != null &&
                        respues = true;
                    } else {
                        respues = false;
                    }
                } else if (jRPCBCOM.isSelected()) {//Solo Componentes
                    if (jDFechaEntregaPCBCOMGF.getDate() != null) {
                        respues = true;
                    } else {
                        respues = false;
                    }
                }
            }
        }
        return respues;
    }

    public int contarRadiosPresionados() {
        int cant = 0;
        if (jCConversor.isSelected()) {
            cant++;
        }
        if (jCTroquel.isSelected()) {
            cant++;
        }
        if (jCRepujado.isSelected()) {
            cant++;
        }
        if (jCStencil.isSelected()) {
            cant++;
        }
        if (jCCircuito.isSelected()) {
            cant++;
        }
        if (jCPCBTE.isSelected()) {
            cant++;
        }
        if (jCTeclado.isSelected()) {
            cant++;
        }
        if (jCIntegracion.isSelected()) {
            cant++;
        }
        if (jCPIntegracionPCB.isSelected()) {
            cant++;
        }

        return cant;
    }

    public int validarCantidadesIngresadasProductos() {
        int cant = 0;
        if (!jTConversor.getText().trim().equals("")) {
            cant++;
        }
        if (!jTTroquel.getText().trim().equals("")) {
            cant++;
        }
        if (!jTRepujado.getText().trim().equals("")) {
            cant++;
        }
        if (!jTStencil.getText().trim().equals("")) {
            cant++;
        }
        if (!jTCircuito.getText().trim().equals("") && cbMaterialCircuito.getSelectedIndex() != 0) {
            cant++;
        }
        if (!jTPCBTE.getText().trim().equals("") && cbMaterialPCBTE.getSelectedIndex() != 0) {
            cant++;
        }
        if (!jTTeclado.getText().trim().equals("")) {
            cant++;
        }
        if (!jTIntegracion.getText().trim().equals("")) {
            cant++;
        }
        if (!jTTPCBEN.getText().trim().equals("")) {
            cant++;
        }
        // ...
        return cant;
    }

    private void registrarModificarInformacionDelProyecto(int accion) {
        // accion 1 = Registrar, accion 2 = Modificar 
        
        switch(accion){
            case 1: // Registrar Proyecto
                
                    accionRegistrarModificar();
                
                break;
            case 2: // Modificar PRoyecto
                
                //Validar que los detalles del proyecto puedan ser modificados o si no el proyecto no va a poder ser modificado de ninguna manera.
                String v[] = new String[9];
                int i = 0;
                boolean respuesta = true;
                DetalleProyecto controladorProducto = new DetalleProyecto();
                // ...
                if (!jLIDCircuito.getText().equals("0") && jCCircuito.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 1, 0, 1)); // Circuito
                    i++;
                }
                if (!jLIDTeclado.getText().equals("0") && jCTeclado.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(2, Integer.parseInt(jTNorden.getText()), 5, 0, 1)); // Teclado
                    i++;
                }
                if (!jLIDPCBEN.getText().equals("0") && jCPIntegracionPCB.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(3, Integer.parseInt(jTNorden.getText()), 12, 0, 1)); // Ensamble PCB Teclado
                    i++;
                }
                if (!jLIDIntegracion.getText().equals("0") && jCIntegracion.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(3, Integer.parseInt(jTNorden.getText()), 1, 0, 1)); // Ensamble
                    i++;
                }
                if (!jLIDConversor.getText().equals("0") && jCConversor.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 2, 0, 1)); // Conversor
                    i++;
                }
                if (!jLIDTroquel.getText().equals("0") && jCTroquel.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 4, 0, 1)); //Troquel
                    i++;
                }
                if (!jLIDRepujado.getText().equals("0") && jCRepujado.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 3, 0, 1)); //Repujado
                    i++;
                }
                if (!jLIDStencil.getText().equals("0") && jCStencil.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 6, 0, 1)); //Stencil
                    i++;
                }
                if (!jLIDPCB.getText().equals("0") && jCPCBTE.isSelected() == false) {
                    v[i] = String.valueOf(controladorProducto.validarEliminacionModificar(1, Integer.parseInt(jTNorden.getText()), 7, 0, 1)); // PCB TE
                    i++;
                }
                //Se verifica que todos los proyectos se puedan eliminar
                for (int j = 0; j < v.length; j++) {
                    if (v[j] == null) {
                        break;
                    } else {
                        if (v[j].equals("false")) {
                            respuesta = false;
                            break;
                        }
                    }
                }
                
                //si es true se podran eliminar todos los proyectos y podra seguir con la modificacion de la informacion del proyecto
                if (respuesta) {
                    // ...
                    accionRegistrarModificar();
                    // ...
                } else {
                    //Se modificara solo la información filtraria y el detalle
                    new rojerusan.RSNotifyAnimated("¡Error!", "No se puede modificar el detalle de este proyecto porque ya esta en ejecución.", 8, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                    Controlador.Proyecto procet = new Controlador.Proyecto();
                    asignacionDeInformacionAlObjetoProyecto(procet);
                    
                    if (procet.registrar_Modificar_Proyecto(Menu.jDocumento.getText(), 2)) {//El dos es para poder modificar solo la informacion del proyecto
                        
                        new rojerusan.RSNotifyAnimated("Listo!!", "La informacion filtraria del proyecto con el numero de orden: " + jTNorden.getText() + " fue modificado exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                        limpiarID();
                        limpiarCamposFormulario();
                        estadoInicialComponentesFormulario();
                        estadoInicialBotonesFormulario();
                        btnNuevo.setEnabled(true);
                        ocultarFechas();
                        
                    } else {
                        
                        new rojerusan.RSNotifyAnimated("Error!", "La informacion filtraria del proyecto con el numero de orden: " + jTNorden.getText() + " no pudo ser modificado exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                    
                    }
                }
                
                break;
        }

    }

    private void asignacionDeInformacionAlObjetoProyecto(Controlador.Proyecto obj) {
        obj.setNombreCliente(jTNombreCliente.getText());
        obj.setNombreProyecto(jTNombreProyecto.getText());
        obj.setTipoProyecto(cbTipoEjecucion.getSelectedItem().toString());
        SimpleDateFormat fecha = new SimpleDateFormat("yyyy/MM/dd");
        obj.setFecha(fecha.format(jDeEntrega.getDate()));
        obj.setNum_orden(jTNorden.getText());
        obj.setNovedadProyecto(jTNovedades.getText().equals("") ? "" : jTNovedades.getText());//Novedade que se puedan presentar en el proyecto (Solo se registraran las novedades cuando se modifique un proyecto)
        // ...
        if (jRATiempo.isSelected()) {
            obj.setEstadoPRoyecto("A tiempo");
            if (jDNFEE.getDate() != null) {
                obj.setNFEE(fecha.format(jDNFEE.getDate()));//Nueva fecha de entrega
            } else {
                obj.setNFEE(null);//Nueva fecha de entrega
            }
        } else if (jRRetraso.isSelected()) {
            obj.setEstadoPRoyecto("Retraso");
            if (jDNFEE.getDate() != null) {
                obj.setNFEE(fecha.format(jDNFEE.getDate()));//Nueva fecha de entrega
            } else {
                obj.setNFEE(null);//Nueva fecha de entrega
            }
        } else {
            obj.setEstadoPRoyecto(null);
            obj.setNFEE(null);
        }
        //...
        //Fechas para el control de tiempos de entrega
        if (jDFechaEntregaFE.getDate() != null) {//Fecha de entrega de Circuito de FE a EN
            obj.setFechaCiccuitoFEoGF(fecha.format(jDFechaEntregaFE.getDate()));
        } else {
            obj.setFechaCiccuitoFEoGF(null);
        }
        if (jDFechaEntregaFECOM.getDate() != null) {//Fecha de entrega de los componentes del circuito (sea suministrados por la empresa o el cliente)
            obj.setFechaCiccuitoCOMFEoGF(fecha.format(jDFechaEntregaFECOM.getDate()));
        } else {
            obj.setFechaCiccuitoCOMFEoGF(null);
        }
        if (jDFechaEntregaPCBEN.getDate() != null) {//Fecha de la PCB del teclado a EN
            obj.setFechaPCBFEoGF(fecha.format(jDFechaEntregaPCBEN.getDate()));
        } else {
            obj.setFechaPCBFEoGF(null);
        }
        if (jDFechaEntregaPCBCOMGF.getDate() != null) {//Fecha de los componentes de la PCB (sea suministrados por la empresa o el cliente)
            obj.setFechaPCBCOMFEoGF(fecha.format(jDFechaEntregaPCBCOMGF.getDate()));
        } else {
            obj.setFechaPCBCOMFEoGF(null);
        }
    }

    private void accionRegistrarModificar() {
        Proyecto conrolador_proyecto = new Proyecto();// Controlador
        asignacionDeInformacionAlObjetoProyecto(conrolador_proyecto);//Informacion general del proyecto
        Menu menu=new Menu();
        
        //Registrar o modificar la información del proyecto
        if (conrolador_proyecto.registrar_Modificar_Proyecto(menu.jDocumento.getText(), accion)) {
            
            //accion = 1 (Registrar), accion = 2 (Modificar)
            if (RegistrarModificarDetalle(jTNorden.getText(), accion)) {
                //Mensaje de exito
                new rojerusan.RSNotifyAnimated("Listo!!", ("El Proyecto con el numero de orden: " + jTNorden.getText() + " fue " + (accion == 2 ? "modificado" : "registrada") + " exitosamente."), 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                
                socketCliente clienteSocket = new socketCliente(new int[]{0});// cambiar por un vector
                clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(), "true");
                
                if (accion == 2) {
                    
                    GenerarQR.setEnabled(false);
                    
                } else {
                    
                    conrolador_proyecto.actualizarEstadoProyecto(Integer.parseInt(jTNorden.getText()));// Actualizar el estado del proyecto <-- Esto se va hacer por el momento desde acá
                    generarQRdeProduccion();
                    
                }
                
                limpiarID();
                ocultarFechas();
                
            } else {
                //Mensaje de error
                new rojerusan.RSNotifyAnimated("¡Error!", "El detalle no pudo ser " + (accion == 2 ? "modificado" : "registrada") + " satisfactoriamente", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        } else {
            
            new rojerusan.RSNotifyAnimated("¡Error!", "El proyecto no pudo ser registrado.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
        
        }
        // ...
        System.gc();//Garbage collector
        limpiarCamposFormulario();
        estadoInicialComponentesFormulario();
        estadoInicialBotonesFormulario();
        btnNuevo.setEnabled(true);
    }

    private void estadoInicialComponentesFormulario() {
        jPInformacion.setBackground(new Color(244, 244, 244));
        jPDetalles1.setBackground(new Color(244, 244, 244));
        jPDetalles.setBackground(new Color(244, 244, 244));
        jTNorden.setEnabled(false);
        jTNombreCliente.setEnabled(false);
        jTNombreProyecto.setEnabled(false);
        jDeEntrega.setEnabled(false);
        cbTipoEjecucion.setEnabled(false);
        jCRuteoP.setEnabled(false);
        cbColorCircuito.setSelectedIndex(0);
        jCRuteoC.setEnabled(false);
        jCConversor.setEnabled(false);
        jTConversor.setEnabled(false);
        jCTroquel.setEnabled(false);
        jTTroquel.setEnabled(false);
        jCRepujado.setEnabled(false);
        jTRepujado.setEnabled(false);
        jCStencil.setEnabled(false);
        jTStencil.setEnabled(false);
        jCCircuito.setEnabled(false);
        jTCircuito.setEnabled(false);
        jCPCBTE.setEnabled(false);
        jTPCBTE.setEnabled(false);
        cbMaterialCircuito.setEnabled(false);
        cbMaterialPCBTE.setEnabled(false);
        jCTeclado.setEnabled(false);
        jTTeclado.setEnabled(false);
        jCIntegracion.setEnabled(false);
        jTIntegracion.setEnabled(false);
        jREjecucion.setEnabled(false);
        jRParada.setEnabled(false);
        jRPCBCOM.setEnabled(false);
        jCPIntegracionPCB.setEnabled(false);
        jPEstadoProyecto.setVisible(false);
    }

    private void estadoInicialBotonesFormulario() {
        btnActivar.setVisible(false);
        btnActivar.setEnabled(false);
        btnDelete.setEnabled(false);
        btnDelete.setVisible(true);
        btnUpdate.setEnabled(false);
        btnGuardar.setEnabled(false);
        GenerarQR.setEnabled(false);
        btnTomaTiempos.setVisible(false);
    }

    public void activarComponentes() {
        //Campos de texto info - proyecto
        jTNorden.setEnabled(true);
        jTNombreCliente.setEnabled(true);
        jTNombreProyecto.setEnabled(true);
        //Date - picker
        jDeEntrega.setEnabled(true);
        // Combo - box
        cbTipoEjecucion.setEnabled(true);
        //Botonos Radio productos proyecto
        estadoBotonesSeleccionProductos(true);
        //Botones radio info proyecto
        jREjecucion.setEnabled(false);
        jRParada.setEnabled(false);
        // Color de paneles
        jPInformacion.setBackground(new Color(255, 255, 255));
        jPDetalles1.setBackground(new Color(255, 255, 255));
        jPDetalles.setBackground(new Color(255, 255, 255));
        
        estadoInicialBotonesFormulario();
        limpiarCamposFormulario();
    }

    private void consultarUltimoNumeroDeOrdenDisponible() {
        Proyecto obj = new Proyecto();
        String numero = obj.consultarNumeroOrden();
        jTNorden.setText(numero);
    }

    private void activarjTfilex(JCheckBox cs, TextFieldRoundBackground tx) {
        if (cs.isSelected()) {
            tx.setEnabled(true);
            tx.setText("");
            tx.requestFocus();
        } else {
            tx.setEnabled(false);
            tx.setText("");
        }
    }

    private void validarCampos() {
        //Accion= 1-Registrar, 2-Modificar, 0-No realiza nada
        if (accion > 0) {
            if (!jTNombreCliente.getText().equals("") && !jTNombreProyecto.getText().equals("") && cbTipoEjecucion.getSelectedIndex() > 0 && jDeEntrega.getDate() != null) {
                (accion==1?btnGuardar:btnUpdate).setEnabled(true);
            } else {
                (accion==1?btnGuardar:btnUpdate).setEnabled(false);
            }
        }
    }

    private void consultarFechaActualServidor() {
        Proyecto obj = new Proyecto();
        jLIngreso.setText(obj.fecha());
        fecha = jLIngreso.getText();
    }

    private void VerificarQueSeElimina(DetalleProyecto obj) {//Falata la eliminacion Cuando se presenta una integración
        
        if (!jLIDCircuito.getText().equals("0") && jCCircuito.isSelected() == false) { // Circuito - FE
            //Eliminar el detalle del proyecto si ya no esta seleccionado
            subEliminardetalle(obj, Integer.parseInt(jLIDCircuito.getText()), Integer.parseInt(jTNorden.getText()), "FE", "Circuito");
        }
        if (!jLIDTeclado.getText().equals("0") && jCTeclado.isSelected() == false) { // Teclado
            subEliminardetalle(obj, Integer.parseInt(jLIDTeclado.getText()), Integer.parseInt(jTNorden.getText()), "TE", "Teclado");
        }
        if (!jLIDIntegracion.getText().equals("0") && jCIntegracion.isSelected() == false) { // Ensamble
            subEliminardetalle(obj, Integer.parseInt(jLIDIntegracion.getText()), Integer.parseInt(jTNorden.getText()), "EN", "Circuito");
        }
        if (!jLIDConversor.getText().equals("0") && jCConversor.isSelected() == false) { // Conversor
            subEliminardetalle(obj, Integer.parseInt(jLIDConversor.getText()), Integer.parseInt(jTNorden.getText()), "FE", "Conversor");
        }
        if (!jLIDTroquel.getText().equals("0") && jCTroquel.isSelected() == false) { // Troquel
            subEliminardetalle(obj, Integer.parseInt(jLIDTroquel.getText()), Integer.parseInt(jTNorden.getText()), "FE", "Troquel");
        }
        if (!jLIDRepujado.getText().equals("0") && jCRepujado.isSelected() == false) { // Repujado
            subEliminardetalle(obj, Integer.parseInt(jLIDRepujado.getText()), Integer.parseInt(jTNorden.getText()), "FE", "Repujado");
        }
        if (!jLIDStencil.getText().equals("0") && jCStencil.isSelected() == false) { // Stencial <- Pendiente discutir lo del material
            subEliminardetalle(obj, Integer.parseInt(jLIDStencil.getText()), Integer.parseInt(jTNorden.getText()), "FE", "Stencil");
        }
        if (!jLIDPCB.getText().equals("0") && jCPCBTE.isSelected() == false) { // PCB TE
            subEliminardetalle(obj, Integer.parseInt(jLIDPCB.getText()), Integer.parseInt(jTNorden.getText()), "FE", "PCB");
        }
        if (jCPIntegracionPCB.isSelected() == false && !jLIDPCBEN.getText().equals("0")) { // Integracion de PCB TE
            subEliminardetalle(obj, Integer.parseInt(jLIDPCBEN.getText()), Integer.parseInt(jTNorden.getText()), "EN", "Circuito-TE");
        }
        
    }

    private boolean RegistrarModificarDetalle(String numeroOrden, int op) {
        DetalleProyecto obj = new DetalleProyecto();
        boolean res = false;
        int op1 = 0;
        //Falta validar que antes de eliminar un su proyecto si se puede eliminar o no
        //Se registra el detalle del proyecto cuando el negocio es "FE/TE/IN" <--- Este campo ya no se esta implementando
        
        // Validar cuales fueron los productos seleccionados para el registro del formulario
        if (jCConversor.isSelected()) {
            //Registrar Conversor------------------------------------------>
            if (jLIDConversor.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTConversor.getText(), "FE", "Conversor", numeroOrden, "FV", op, Integer.parseInt(jLIDConversor.getText()), "0", 0, 0);
            if (jLIDConversor.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro del Conversor
        }
        
        if (jCTroquel.isSelected()) {
            //Registrar Troquel-------------------------------------------->
            if (jLIDTroquel.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTTroquel.getText(), "FE", "Troquel", numeroOrden, "FV", op, Integer.parseInt(jLIDTroquel.getText()), "0", 0, 0);
            if (jLIDTroquel.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro del Troquel
        }
        
        if (jCRepujado.isSelected()) {
            //Registrar Repujado------------------------------------------->
            if (jLIDRepujado.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTRepujado.getText(), "FE", "Repujado", numeroOrden, "FV", op, Integer.parseInt(jLIDRepujado.getText()), "0", 0, 0);
            if (jLIDRepujado.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro del Repujado
        }
        
        if (jCStencil.isSelected()) {
            //Registrar Stencil-------------------------------------------->
            if (jLIDStencil.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTStencil.getText(), "FE", "Stencil", numeroOrden, "", op, Integer.parseInt(jLIDStencil.getText()), "0", 0, 0);
            if (jLIDStencil.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro del Stencil
        }
        
        if (jCCircuito.isSelected()) {
            //Registrar Circuito de FE------------------------------------------>
                if (jLIDCircuito.getText().equals("0")) {
                    op1 = op;
                    op = 1;
                }
                res = subRegistrarModificarProyecto(obj, jTCircuito.getText(), "FE", "Circuito", numeroOrden, cbMaterialCircuito.getSelectedItem().toString(), op, Integer.parseInt(jLIDCircuito.getText()), String.valueOf(cbColorCircuito.getSelectedIndex()), (jCRuteoC.isSelected()?1:0), cbEspesorCircuito.getSelectedIndex());
                if (jLIDCircuito.getText().equals("0")) {
                    op = op1;
                }
            //Fin del registro del Circuito FE
        }
        
        if (jCPCBTE.isSelected()) {
            //Registrar PCB de TE------------------------------------------>
            if (jLIDPCB.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTPCBTE.getText(), "FE", "PCB", numeroOrden, cbMaterialPCBTE.getSelectedItem().toString(), op, Integer.parseInt(jLIDPCB.getText()), String.valueOf(cbColorPCB.getSelectedIndex()), (jCRuteoP.isSelected()?1:0), cbEspesorPCB.getSelectedIndex());
            if (jLIDPCB.getText().equals("0")) {
                op = op1;
            }
                
            // ...
            if (jLIDPCBEN.getText().equals("0")) { // Ensamble de la PCB del teclado
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTTPCBEN.getText(), "EN", "Circuito-TE", numeroOrden, "", op, Integer.parseInt(jLIDPCBEN.getText()), "0", 0, 0);
            if (jLIDPCBEN.getText().equals("0")) {
                op = op1;
            }
            //------------------------------------------------------------------------------------------------------------------------
            //Fin del registro del PCB TE
        }
        
        if (jCTeclado.isSelected()) {
            //Registrar Teclado-------------------------------------------->
            if (jLIDTeclado.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTTeclado.getText(), "TE", "Teclado", numeroOrden, "", op, Integer.parseInt(jLIDTeclado.getText()), "0", 0, 0);
            if (jLIDTeclado.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro del Teclado
        }
        if (jCIntegracion.isSelected()) {
            //Registrar Integracion---------------------------------------->
            if (jLIDIntegracion.getText().equals("0")) {
                op1 = op;
                op = 1;
            }
            res = subRegistrarModificarProyecto(obj, jTIntegracion.getText(), "EN", "Circuito", numeroOrden, "", op, Integer.parseInt(jLIDIntegracion.getText()), "0", 0, 0);
            if (jLIDIntegracion.getText().equals("0")) {
                op = op1;
            }
            //Fin del registro de Integracion
        }
        //-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        if (op != 1) {//No es necesario cuando se registra un proyecto
            VerificarQueSeElimina(obj);
        }
        //-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        return res;
    }

    private boolean subRegistrarModificarProyecto(DetalleProyecto obj, String cantidad, String area, String producto, String numeroOrden, String material, int accion, int idDetalleProducto, String color_antisolder, int ruteo, int idEspesor) {
        obj.setCantidad(cantidad);
        obj.setProducto(producto);
        obj.setArea(area);
        obj.setMaterial(material);
        return obj.registrar_Detalle_Proyecto(numeroOrden, accion, idDetalleProducto, color_antisolder, ruteo, idEspesor);
    }

    private void subEliminardetalle(DetalleProyecto obj, int idDetalle, int numerOrden, String area, String tipoProducto) {

        if (obj.eliminarDetallersProyecto(idDetalle, numerOrden, area, tipoProducto, 1)) {//Eliminación por la modificación
            //Mensaje de eliminacion exitosa
            new rojerusan.RSNotifyAnimated("Listo!!", "Se elimino el detalle del proyecto: " + tipoProducto + " " + area + " de la orden " + jTNorden.getText(), 5, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
            try {
                Thread.sleep(500);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            //Mensaje de la eliminacion no se pudo realizar por que ya comenzo su ejecucion (Esto solo se pone por seguridad) de resto no va a funcionar
            new rojerusan.RSNotifyAnimated("Listo!!", "el detalle " + tipoProducto + " " + area + " de la orden" + jTNorden.getText() + " no pudo ser eliminada porque ya esta en ejecución.", 5, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
        }
    }

    private void consultarColoresAntisolder(){
        try {
            Proyecto controlador = new Proyecto();
            CachedRowSet crs = controlador.consultarColoresAntisolder();
            DefaultComboBoxModel modelCircuito = new DefaultComboBoxModel();
            DefaultComboBoxModel modelPCB = new DefaultComboBoxModel();
            modelPCB.addElement("Seleccione...");
            modelCircuito.addElement("Seleccione...");
            while(crs.next()){
                modelCircuito.addElement(crs.getString("color"));
                modelPCB.addElement(crs.getString("color"));
            }
            cbColorCircuito.setModel(modelCircuito);
            cbColorPCB.setModel(modelPCB);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void consultarEspesoresTarjeta(){
        try {
            Proyecto controlador = new Proyecto();
            CachedRowSet crs = controlador.consultarEspesorTarjeta();
            DefaultComboBoxModel modelCircuito = new DefaultComboBoxModel();
            DefaultComboBoxModel modelPCB = new DefaultComboBoxModel();
            modelCircuito.addElement("Seleccione...");
            modelPCB.addElement("Seleccione...");
            while(crs.next()){
                modelCircuito.addElement(crs.getString("nom_espesor"));
                modelPCB.addElement(crs.getString("nom_espesor"));
            }
            cbEspesorCircuito.setModel(modelCircuito);
            cbEspesorPCB.setModel(modelPCB);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void numerosT(java.awt.event.KeyEvent evt) {
        char cara = evt.getKeyChar();
        if (Character.isLetter(cara) || evt.getKeyChar() == '.' || evt.getKeyChar() == '|') {
            evt.consume();
        }
    }
    
    // Validacion de campos del formulario!
    private void componentesFechasNoEditables() {
        JTextFieldDateEditor editor = (JTextFieldDateEditor) jDeEntrega.getDateEditor();
        editor.setEditable(false);
        JTextFieldDateEditor editor1 = (JTextFieldDateEditor) jDFechaEntregaFE.getDateEditor();
        editor1.setEditable(false);
        JTextFieldDateEditor editor2 = (JTextFieldDateEditor) jDFechaEntregaFECOM.getDateEditor();
        editor2.setEditable(false);
        JTextFieldDateEditor editor3 = (JTextFieldDateEditor) jDFechaEntregaPCBEN.getDateEditor();
        editor3.setEditable(false);
        JTextFieldDateEditor editor4 = (JTextFieldDateEditor) jDFechaEntregaPCBCOMGF.getDateEditor();
        editor4.setEditable(false);
    }

    private void visibilidadLabelID() {
        jLIDConversor.setVisible(false);
        jLIDTroquel.setVisible(false);
        jLIDRepujado.setVisible(false);
        jLIDStencil.setVisible(false);
        jLIDCircuito.setVisible(false);
        jLIDPCB.setVisible(false);
        jLIDTeclado.setVisible(false);
        jLIDIntegracion.setVisible(false);
        //Identificadores de productos de almacen
        jLIDCircuitoGF.setVisible(false);//ID del Circuito Cuando es GF
        jLIDCircuitoCOM.setVisible(false);//ID de los componenetes del circuito
//        jLIDPCBEnsamble.setVisible(false);//ID de la PCB cuando es GF
        jLIDPCBCOM.setVisible(false);//ID de los componentes del circuito
        jLIDPCBEN.setVisible(false);//ID de integracion de la PCB
    }

    private void limitesCamposFormulario() {
        RestrictedTextField obj = new RestrictedTextField(jTConversor);
        obj.setLimit(6);
        RestrictedTextField obj1 = new RestrictedTextField(jTRepujado);
        obj1.setLimit(6);
        RestrictedTextField obj2 = new RestrictedTextField(jTTroquel);
        obj2.setLimit(6);
        RestrictedTextField obj3 = new RestrictedTextField(jTCircuito);
        obj3.setLimit(6);
        RestrictedTextField obj4 = new RestrictedTextField(jTStencil);
        obj4.setLimit(6);
        RestrictedTextField obj5 = new RestrictedTextField(jTIntegracion);
        obj5.setLimit(6);
        RestrictedTextField obj6 = new RestrictedTextField(jTTeclado);
        obj6.setLimit(6);
        RestrictedTextField obj7 = new RestrictedTextField(jTPCBTE);
        obj7.setLimit(6);
        RestrictedTextField obj8 = new RestrictedTextField(jTNombreCliente);
        obj8.setLimit(150);
        RestrictedTextField obj9 = new RestrictedTextField(jTNombreProyecto);
        obj9.setLimit(150);
    }
    
    public void limpiarCamposFormulario() {
        Notificacion1.setVisible(false);
        jTNorden.setText("");
        jTNombreCliente.setText("");
        jTNombreProyecto.setText("");
        jDeEntrega.setCalendar(null);
        jDFechaEntregaPCBEN.setCalendar(null);
        jLIngreso.setText("DD-MM-YYYY");
        cbTipoEjecucion.setSelectedIndex(0);
        jCRuteoP.setSelected(false);
        jCRuteoP.setEnabled(false);
        cbColorPCB.setSelectedIndex(0);
        jCRuteoC.setSelected(false);
        jCRuteoC.setEnabled(false);
        cbColorCircuito.setSelectedIndex(0);
        cbEspesorCircuito.setSelectedIndex(0);
        cbColorPCB.setSelectedIndex(0);
        cbEspesorPCB.setSelectedIndex(0);
        cbColorCircuito.setEnabled(false);
        cbEspesorCircuito.setEnabled(false);
        cbColorPCB.setEnabled(false);
        cbEspesorPCB.setEnabled(false);
        jCConversor.setSelected(false);
        jCRepujado.setSelected(false);
        jCTroquel.setSelected(false);
        jCCircuito.setSelected(false);
        jCPCBTE.setSelected(false);
        jCTeclado.setSelected(false);
        jCStencil.setSelected(false);
        jCIntegracion.setSelected(false);
        jTIntegracion.setText(" ");
        jTConversor.setText(" ");
        jTRepujado.setText(" ");
        jTTroquel.setText(" ");
        jTCircuito.setText(" ");
        jTPCBTE.setText(" ");
        jTTeclado.setText(" ");
        jTIntegracion.setText(" ");
        jTStencil.setText(" ");
        cbMaterialCircuito.setSelectedIndex(0);
        cbMaterialPCBTE.setSelectedIndex(0);
        cbMaterialCircuito.setEnabled(false);
        cbMaterialPCBTE.setEnabled(false);
        jTIntegracion.setEditable(true);
        jTConversor.setEditable(true);
        jTRepujado.setEditable(true);
        jTTroquel.setEditable(true);
        jTCircuito.setEditable(true);
        jTPCBTE.setEditable(true);
        jTTeclado.setEditable(true);
        jTIntegracion.setEditable(true);
        jTStencil.setEditable(true);
        jTNovedades.setVisible(false);
        jScrollPane1.setVisible(false);
        jTNovedades.setText("");
        jTNovedades.setVisible(false);
        jLNovedades.setVisible(false);
        jLNCaracteres.setVisible(false);
        jScrollPane1.setVisible(false);
        jTNovedades.setLineWrap(true);
        jDFechaEntregaPCBEN.setVisible(false);
        jLPCBTE.setVisible(false);
        jLpcbGF.setVisible(false);
        jDFechaEntregaPCBCOMGF.setVisible(false);
        jCPIntegracionPCB.setSelected(false);
        jTTPCBEN.setText("");
    }
    
    public void limpiarID() {
        jLIDConversor.setText("0");
        jLIDRepujado.setText("0");
        jLIDTroquel.setText("0");
        jLIDStencil.setText("0");
        jLIDCircuito.setText("0");
        jLIDPCB.setText("0");
        jLIDTeclado.setText("0");
        jLIDIntegracion.setText("0");
        jLIDPCBEN.setText("0");
        jLIDPCBCOM.setText("0");
        jLIDCircuitoGF.setText("0");
        jLIDCircuitoCOM.setText("0");
    }
    
    public void estadoBotonesSeleccionProductos(boolean estado) {
        jCConversor.setEnabled(estado);
        jCTroquel.setEnabled(estado);
        jCRepujado.setEnabled(estado);
        jCStencil.setEnabled(estado);
        jCCircuito.setEnabled(estado);
        jCPCBTE.setEnabled(estado);
        jCIntegracion.setEnabled(estado);
        jCTeclado.setEnabled(estado);
    }
    
    private void caracteresRestantes(int cant) {
        jLNCaracteres.setText(String.valueOf(250 - cant));
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    public static elaprendiz.gui.button.ButtonColoredAction GenerarQR;
    public static javax.swing.JLabel Notificacion1;
    private javax.swing.ButtonGroup ParadasOEjecucion;
    public static javax.swing.JButton btnActivar;
    private javax.swing.JButton btnBuscar;
    public static javax.swing.JButton btnDelete;
    public static javax.swing.JButton btnGuardar;
    public static javax.swing.JButton btnNuevo;
    public static elaprendiz.gui.button.ButtonColoredAction btnTomaTiempos;
    public static javax.swing.JButton btnUpdate;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbColorCircuito;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbColorPCB;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbEspesorCircuito;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbEspesorPCB;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbMaterialCircuito;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbMaterialPCBTE;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbTipoEjecucion;
    private javax.swing.ButtonGroup estadoProyecto;
    public static javax.swing.JCheckBox jCCircuito;
    public static javax.swing.JCheckBox jCConversor;
    public static javax.swing.JCheckBox jCIntegracion;
    public static javax.swing.JCheckBox jCPCBTE;
    public static javax.swing.JCheckBox jCPIntegracionPCB;
    public static javax.swing.JCheckBox jCRepujado;
    public static javax.swing.JCheckBox jCRuteoC;
    public static javax.swing.JCheckBox jCRuteoP;
    public static javax.swing.JCheckBox jCStencil;
    public static javax.swing.JCheckBox jCTeclado;
    public static javax.swing.JCheckBox jCTroquel;
    public static com.toedter.calendar.JDateChooser jDFechaEntregaFE;
    public static com.toedter.calendar.JDateChooser jDFechaEntregaFECOM;
    public static com.toedter.calendar.JDateChooser jDFechaEntregaPCBCOMGF;
    public static com.toedter.calendar.JDateChooser jDFechaEntregaPCBEN;
    public static com.toedter.calendar.JDateChooser jDNFEE;
    public static com.toedter.calendar.JDateChooser jDeEntrega;
    public static javax.swing.JLabel jLCircuitoFE;
    public static javax.swing.JLabel jLCircuitoFE1;
    public static javax.swing.JLabel jLComCircuitos;
    public static javax.swing.JLabel jLEstado;
    public static javax.swing.JLabel jLIDCircuito;
    public static javax.swing.JLabel jLIDCircuitoCOM;
    public static javax.swing.JLabel jLIDCircuitoGF;
    public static javax.swing.JLabel jLIDConversor;
    public static javax.swing.JLabel jLIDIntegracion;
    public static javax.swing.JLabel jLIDPCB;
    public static javax.swing.JLabel jLIDPCBCOM;
    public static javax.swing.JLabel jLIDPCBEN;
    public static javax.swing.JLabel jLIDRepujado;
    public static javax.swing.JLabel jLIDStencil;
    public static javax.swing.JLabel jLIDTeclado;
    public static javax.swing.JLabel jLIDTroquel;
    public static javax.swing.JLabel jLIngreso;
    public static javax.swing.JLabel jLNCaracteres;
    public static javax.swing.JLabel jLNovedades;
    public static javax.swing.JLabel jLNovedades2;
    public static javax.swing.JLabel jLPCBTE;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel28;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    public static javax.swing.JLabel jLpcbGF;
    public static javax.swing.JPanel jPDetalles;
    public static javax.swing.JPanel jPDetalles1;
    public static javax.swing.JPanel jPEstadoProyecto;
    public static javax.swing.JPanel jPInformacion;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel5;
    public static javax.swing.JRadioButton jRATiempo;
    public static javax.swing.JRadioButton jREjecucion;
    public static javax.swing.JRadioButton jRPCBCOM;
    public static javax.swing.JRadioButton jRParada;
    public static javax.swing.JRadioButton jRRetraso;
    public static javax.swing.JScrollPane jScrollPane1;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTCircuito;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTConversor;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTIntegracion;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNombreCliente;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNombreProyecto;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNorden;
    public static javax.swing.JTextArea jTNovedades;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTPCBTE;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTRepujado;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTStencil;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTTPCBEN;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTTeclado;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTTroquel;
    // End of variables declaration//GEN-END:variables
@Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
