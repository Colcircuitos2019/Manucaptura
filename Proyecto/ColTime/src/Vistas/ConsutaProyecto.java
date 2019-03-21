package Vistas;

import Controlador.DetalleProyecto;
import Controlador.FormatoTabla;
import elaprendiz.gui.textField.TextFieldRoundBackground;
import java.awt.Color;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class ConsutaProyecto extends javax.swing.JFrame {

    public ConsutaProyecto(){};
    
    public ConsutaProyecto(proyecto viewProyecto) {
        initComponents();
        jDFecha.setEnabled(false);
        jRnulo.setVisible(false);
        jTtipo.setText("");
        consultarProyectos("", "", "", "", 0);
        this.viewProyecto = viewProyecto;
        this.setIconImage(new ImageIcon(getClass().getResource("/imagenesEmpresa/favicon.png")).getImage());
        TProyecto.getTableHeader().setReorderingAllowed(false);//Tabla proyecto
        jTProcesoProducto.getTableHeader().setReorderingAllowed(false);//Tabla producto no conforme(PNC)
        TProyecto.getTableHeader().setReorderingAllowed(false);//Tabla proyecto
        jTDetalleProductos.getTableHeader().setReorderingAllowed(false);//Tabla detalle del proyecto
    }
    // View Padre
    proyecto viewProyecto = null;
    //Variables globales
    int posX = 0;
    int posY = 0;
    int count = 0;
    int estado = 1;
    int cantidadRegistros = 0;
    CachedRowSet crs;
    //Botones de radio
    String encabezadosTBProductos[] = {"idDetalle", "Área", "Producto", "Cantidad", "Estado", "Material","PNC","Antisolder","Ruteo"};//Detalle del proyecto
    String encabezadosTBProcesos[] = {"idProceso", "Nombre", "Estado", "Tiempo", "Cantidad"};//Procesos

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        fechas = new javax.swing.ButtonGroup();
        jPEncabezado = new javax.swing.JPanel();
        jButton9 = new javax.swing.JButton();
        jButton10 = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jTtipo = new javax.swing.JLabel();
        jTtipo2 = new javax.swing.JLabel();
        jPanel3 = new javax.swing.JPanel();
        jTNumerOrden = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel3 = new javax.swing.JLabel();
        jTNombreCliente = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel5 = new javax.swing.JLabel();
        jTNombreProyecto = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jDFecha = new com.toedter.calendar.JDateChooser();
        jREntrega = new javax.swing.JRadioButton();
        jRIngreso = new javax.swing.JRadioButton();
        jRSalida = new javax.swing.JRadioButton();
        jRnulo = new javax.swing.JRadioButton();
        btnEliminados = new elaprendiz.gui.button.ButtonColoredAction();
        jTtipo1 = new javax.swing.JLabel();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        TProyecto = new javax.swing.JTable();
        jTCantidadRegistros = new javax.swing.JLabel();
        jTCantidadRegistros1 = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTProcesoProducto = new javax.swing.JTable();
        jPanel6 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTDetalleProductos = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setUndecorated(true);

        jPEncabezado.setBackground(new java.awt.Color(60, 141, 188));
        jPEncabezado.setBorder(javax.swing.BorderFactory.createMatteBorder(2, 2, 0, 2, new java.awt.Color(153, 153, 153)));
        jPEncabezado.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jPEncabezado.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                jPEncabezadoMouseDragged(evt);
            }
        });
        jPEncabezado.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jPEncabezadoMousePressed(evt);
            }
        });

        jButton9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close.png"))); // NOI18N
        jButton9.setBorderPainted(false);
        jButton9.setContentAreaFilled(false);
        jButton9.setFocusPainted(false);
        jButton9.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close1.png"))); // NOI18N
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        jButton10.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus1.png"))); // NOI18N
        jButton10.setBorderPainted(false);
        jButton10.setContentAreaFilled(false);
        jButton10.setFocusPainted(false);
        jButton10.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus.png"))); // NOI18N
        jButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton10ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPEncabezadoLayout = new javax.swing.GroupLayout(jPEncabezado);
        jPEncabezado.setLayout(jPEncabezadoLayout);
        jPEncabezadoLayout.setHorizontalGroup(
            jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEncabezadoLayout.createSequentialGroup()
                .addGap(1163, 1163, 1163)
                .addComponent(jButton10, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(6, 6, 6)
                .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPEncabezadoLayout.setVerticalGroup(
            jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPEncabezadoLayout.createSequentialGroup()
                .addGap(11, 11, 11)
                .addGroup(jPEncabezadoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton10)
                    .addComponent(jButton9))
                .addContainerGap(25, Short.MAX_VALUE))
        );

        jPanel4.setBackground(new java.awt.Color(255, 255, 255));
        jPanel4.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153), 2));
        jPanel4.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTtipo.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo.setText("-");
        jPanel4.add(jTtipo, new org.netbeans.lib.awtextra.AbsoluteConstraints(1140, 110, 71, -1));

        jTtipo2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo2.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (2).png"))); // NOI18N
        jTtipo2.setText("Parada");
        jPanel4.add(jTtipo2, new org.netbeans.lib.awtextra.AbsoluteConstraints(330, 100, 120, 30));

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(204, 204, 204)), "Busqueda", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel3.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTNumerOrden.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNumerOrden.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNumerOrden.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNumerOrdenKeyReleased(evt);
            }
        });
        jPanel3.add(jTNumerOrden, new org.netbeans.lib.awtextra.AbsoluteConstraints(38, 51, 90, 25));

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(128, 128, 131));
        jLabel3.setText(" Orden °N:");
        jPanel3.add(jLabel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(38, 30, 71, -1));

        jTNombreCliente.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreCliente.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreCliente.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreClienteKeyReleased(evt);
            }
        });
        jPanel3.add(jTNombreCliente, new org.netbeans.lib.awtextra.AbsoluteConstraints(154, 51, 239, 25));

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setText("Nombre del cliente:");
        jPanel3.add(jLabel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(154, 30, 129, -1));

        jTNombreProyecto.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreProyecto.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreProyecto.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreProyectoKeyReleased(evt);
            }
        });
        jPanel3.add(jTNombreProyecto, new org.netbeans.lib.awtextra.AbsoluteConstraints(409, 51, 250, 25));

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Nombre del proyecto:");
        jPanel3.add(jLabel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(409, 30, -1, -1));

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/retro.png"))); // NOI18N
        jButton1.setToolTipText("");
        jButton1.setContentAreaFilled(false);
        jButton1.setFocusable(false);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        jPanel3.add(jButton1, new org.netbeans.lib.awtextra.AbsoluteConstraints(1178, 12, 20, 20));

        jDFecha.setToolTipText("");
        jDFecha.setDateFormatString("dd/MM/yyyy");
        jDFecha.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jDFecha.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                jDFechaPropertyChange(evt);
            }
        });
        jPanel3.add(jDFecha, new org.netbeans.lib.awtextra.AbsoluteConstraints(680, 50, 140, -1));

        jREntrega.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jREntrega);
        jREntrega.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jREntrega.setForeground(new java.awt.Color(128, 128, 131));
        jREntrega.setText("E");
        jREntrega.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jREntregaMouseClicked(evt);
            }
        });
        jPanel3.add(jREntrega, new org.netbeans.lib.awtextra.AbsoluteConstraints(680, 20, -1, -1));

        jRIngreso.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRIngreso);
        jRIngreso.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRIngreso.setForeground(new java.awt.Color(128, 128, 131));
        jRIngreso.setText("I");
        jRIngreso.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRIngresoMouseClicked(evt);
            }
        });
        jPanel3.add(jRIngreso, new org.netbeans.lib.awtextra.AbsoluteConstraints(730, 20, -1, -1));

        jRSalida.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRSalida);
        jRSalida.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRSalida.setForeground(new java.awt.Color(128, 128, 131));
        jRSalida.setText("S");
        jRSalida.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRSalidaMouseClicked(evt);
            }
        });
        jPanel3.add(jRSalida, new org.netbeans.lib.awtextra.AbsoluteConstraints(780, 20, -1, -1));

        jRnulo.setBackground(new java.awt.Color(255, 255, 255));
        fechas.add(jRnulo);
        jRnulo.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jRnulo.setForeground(new java.awt.Color(128, 128, 131));
        jRnulo.setText("null");
        jRnulo.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jRnuloMouseClicked(evt);
            }
        });
        jPanel3.add(jRnulo, new org.netbeans.lib.awtextra.AbsoluteConstraints(830, 20, -1, -1));

        btnEliminados.setText("Eliminados");
        btnEliminados.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnEliminadosActionPerformed(evt);
            }
        });
        jPanel3.add(btnEliminados, new org.netbeans.lib.awtextra.AbsoluteConstraints(1080, 50, 110, -1));

        jPanel4.add(jPanel3, new org.netbeans.lib.awtextra.AbsoluteConstraints(11, 12, 1203, 92));

        jTtipo1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo1.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo1.setText("Tipo:");
        jPanel4.add(jTtipo1, new org.netbeans.lib.awtextra.AbsoluteConstraints(1090, 110, 60, -1));

        jTtipo3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo3.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (3).png"))); // NOI18N
        jTtipo3.setText("Terminado");
        jPanel4.add(jTtipo3, new org.netbeans.lib.awtextra.AbsoluteConstraints(14, 100, 100, 30));

        jTtipo4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo4.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (1).png"))); // NOI18N
        jTtipo4.setText("Pausado");
        jPanel4.add(jTtipo4, new org.netbeans.lib.awtextra.AbsoluteConstraints(110, 100, 120, 30));

        jTtipo5.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo5.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (4).png"))); // NOI18N
        jTtipo5.setText("Ejecución");
        jPanel4.add(jTtipo5, new org.netbeans.lib.awtextra.AbsoluteConstraints(220, 100, 120, 30));

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "Proyecto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel2.setLayout(new java.awt.CardLayout());

        TProyecto = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        TProyecto.setAutoCreateRowSorter(true);
        TProyecto.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        TProyecto.setForeground(new java.awt.Color(128, 128, 131));
        TProyecto.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "Orden °N", "Registro de", "Nombre Cliente", "Nombre  Proyecto", "Fecha Ingreso", "Fecha Entrega", "Fecha Salida", "Estado", "Tipo ejecucion", "Parada", "fecha1", "fecha2", "fecha3", "fecha4", "novedades", "EstadoProyecto", "NFEE"
            }
        ));
        TProyecto.setFillsViewportHeight(true);
        TProyecto.setFocusTraversalPolicyProvider(true);
        TProyecto.setIntercellSpacing(new java.awt.Dimension(0, 0));
        TProyecto.setName("Proyecto"); // NOI18N
        TProyecto.setRequestFocusEnabled(false);
        TProyecto.setRowHeight(18);
        TProyecto.setSelectionBackground(new java.awt.Color(63, 179, 255));
        TProyecto.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        TProyecto.setShowVerticalLines(false);
        TProyecto.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                TProyectoMousePressed(evt);
            }
        });
        jScrollPane2.setViewportView(TProyecto);

        jPanel2.add(jScrollPane2, "card2");

        jPanel4.add(jPanel2, new org.netbeans.lib.awtextra.AbsoluteConstraints(11, 122, 1203, 300));

        jTCantidadRegistros.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTCantidadRegistros.setForeground(new java.awt.Color(128, 128, 131));
        jTCantidadRegistros.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTCantidadRegistros.setText("1000000");
        jPanel4.add(jTCantidadRegistros, new org.netbeans.lib.awtextra.AbsoluteConstraints(1140, 417, 70, 30));

        jTCantidadRegistros1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTCantidadRegistros1.setForeground(new java.awt.Color(128, 128, 131));
        jTCantidadRegistros1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTCantidadRegistros1.setText("Cantidad de registros:");
        jPanel4.add(jTCantidadRegistros1, new org.netbeans.lib.awtextra.AbsoluteConstraints(965, 417, 180, 30));

        jPanel5.setBackground(new java.awt.Color(255, 255, 255));
        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "Procesos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel5.setLayout(new java.awt.CardLayout());

        jTProcesoProducto = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTProcesoProducto.setAutoCreateRowSorter(true);
        jTProcesoProducto.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTProcesoProducto.setForeground(new java.awt.Color(128, 128, 131));
        jTProcesoProducto.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "idProceso", "Nombre", "Estado", "Tiempo", "Cantidad"
            }
        ));
        jTProcesoProducto.setFillsViewportHeight(true);
        jTProcesoProducto.setFocusTraversalPolicyProvider(true);
        jTProcesoProducto.setFocusable(false);
        jTProcesoProducto.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTProcesoProducto.setName("Detalle"); // NOI18N
        jTProcesoProducto.setRowHeight(18);
        jTProcesoProducto.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTProcesoProducto.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTProcesoProducto.setShowVerticalLines(false);
        jScrollPane1.setViewportView(jTProcesoProducto);

        jPanel5.add(jScrollPane1, "card2");

        jPanel4.add(jPanel5, new org.netbeans.lib.awtextra.AbsoluteConstraints(650, 440, 560, 190));

        jPanel6.setBackground(new java.awt.Color(255, 255, 255));
        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createTitledBorder(null, "", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 0, 11), new java.awt.Color(153, 153, 153)), "Detalle del proyecto - Productos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(204, 204, 204))); // NOI18N
        jPanel6.setLayout(new java.awt.CardLayout());

        jTDetalleProductos = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTDetalleProductos.setAutoCreateRowSorter(true);
        jTDetalleProductos.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTDetalleProductos.setForeground(new java.awt.Color(128, 128, 131));
        jTDetalleProductos.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "idDetalle", "Área", "Producto", "Cantidad", "Estado", "Material", "PNC"
            }
        ));
        jTDetalleProductos.setFillsViewportHeight(true);
        jTDetalleProductos.setFocusTraversalPolicyProvider(true);
        jTDetalleProductos.setFocusable(false);
        jTDetalleProductos.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTDetalleProductos.setName("Detalle"); // NOI18N
        jTDetalleProductos.setRowHeight(18);
        jTDetalleProductos.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTDetalleProductos.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTDetalleProductos.setShowVerticalLines(false);
        jTDetalleProductos.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTDetalleProductosMouseReleased(evt);
            }
        });
        jScrollPane3.setViewportView(jTDetalleProductos);

        jPanel6.add(jScrollPane3, "card2");

        jPanel4.add(jPanel6, new org.netbeans.lib.awtextra.AbsoluteConstraints(10, 440, 600, 190));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPEncabezado, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 1225, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPEncabezado, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, 642, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed
        this.dispose();
    }//GEN-LAST:event_jButton9ActionPerformed

    private void jButton10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton10ActionPerformed
        setExtendedState(JFrame.CROSSHAIR_CURSOR);
    }//GEN-LAST:event_jButton10ActionPerformed

    private void jPEncabezadoMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPEncabezadoMouseDragged
        this.setLocation(evt.getXOnScreen() - posX, evt.getYOnScreen() - posY);
    }//GEN-LAST:event_jPEncabezadoMouseDragged

    private void jPEncabezadoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPEncabezadoMousePressed
        posX = evt.getX();
        posY = evt.getY();
    }//GEN-LAST:event_jPEncabezadoMousePressed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        estadoInicialTabla(0);
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jTNumerOrdenKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNumerOrdenKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNumerOrdenKeyReleased

    private void jTNombreClienteKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreClienteKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNombreClienteKeyReleased

    private void jTNombreProyectoKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreProyectoKeyReleased
        controlBusqueda();
    }//GEN-LAST:event_jTNombreProyectoKeyReleased

    private void jREntregaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jREntregaMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jREntregaMouseClicked

    private void jRIngresoMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRIngresoMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jRIngresoMouseClicked

    private void jRSalidaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRSalidaMouseClicked
        jRnulo.setVisible(true);
        jDFecha.setEnabled(true);
        action();
    }//GEN-LAST:event_jRSalidaMouseClicked

    private void jRnuloMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jRnuloMouseClicked
        jRnulo.setVisible(false);
        jDFecha.setEnabled(false);
        jDFecha.setDate(null);
        consultarProyectos(jTNumerOrden.getText(), jTNombreCliente.getText(), jTNombreProyecto.getText(), "", 0);
    }//GEN-LAST:event_jRnuloMouseClicked

    private void jDFechaPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_jDFechaPropertyChange
        if ((jRIngreso.isSelected() || jREntrega.isSelected() || jRSalida.isSelected()) && jDFecha.getDate() != null) {
            controlBusqueda();
        }
    }//GEN-LAST:event_jDFechaPropertyChange

    private void TProyectoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_TProyectoMousePressed
        if (TProyecto.getSelectedRow() >= 0) {
            if (evt.getClickCount() == 1) {
                if (TProyecto.getRowCount() > 0) {
                    int row = TProyecto.getSelectedRow();
                    //----------------------------------------------------------
                    String valor = TProyecto.getValueAt(row, 8).toString();
                    jTtipo.setText(valor);
                    //Tipo de ejecucion del proyecto...
                    if (valor.equals("Normal")) {
                        jTtipo.setForeground(new Color(128, 128, 131));
                    } else if (valor.equals("Quick")) {
                        jTtipo.setForeground(new Color(1, 174, 240));
                    } else if (valor.equals("RQT")) {
                        jTtipo.setForeground(new Color(255, 175, 175));
                    }
                    // ...
                    consultarProductosDetalleProyecto(TProyecto.getValueAt(row, 0).toString(), TProyecto.getValueAt(row, 9).toString());
                    //----------------------------------------------------------
                    jTProcesoProducto.setModel(new DefaultTableModel(null, encabezadosTBProcesos));
                }
            }
            // ...
            if (evt.getClickCount() == 2) {
                if (TProyecto.getRowCount() > 0) {
                    
                    SimpleDateFormat fecha = new SimpleDateFormat("yyyy-MM-dd");
                    Date fechaEntrega = null;
                    viewProyecto.setFocusable(true);
                    viewProyecto.limpiarCamposFormulario();
                    viewProyecto.estadoBotonesSeleccionProductos(true);
                    viewProyecto.limpiarID();
                    viewProyecto.btnGuardar.setEnabled(false);
                    viewProyecto.accion=2;// Accion de editar
                    
                    try {
                        int f = TProyecto.getSelectedRow();
                        //Activar componentes
                        activarCamposproyecto();
                        //Asignar valores a componentes
                        viewProyecto.jTNorden.setText(TProyecto.getValueAt(f, 0).toString());
                        viewProyecto.jTNombreCliente.setText(TProyecto.getValueAt(f, 2).toString());
                        viewProyecto.jTNombreProyecto.setText(TProyecto.getValueAt(f, 3).toString());
                        String fechaP[] = TProyecto.getValueAt(f, 4).toString().split(" ");
                        viewProyecto.jLIngreso.setText(fechaP[0]);
                        fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 5).toString());
                        viewProyecto.jDeEntrega.setDate(fechaEntrega);
                        viewProyecto.cbTipoEjecucion.setSelectedItem(TProyecto.getValueAt(f, 8).toString());
                        //Estado proyecto
                        if (TProyecto.getValueAt(f, 15).toString() != null && !TProyecto.getValueAt(f, 15).toString().equals("null")) {//Estado del proyecto
                            viewProyecto.jPEstadoProyecto.setVisible(true);
                            if (TProyecto.getValueAt(f, 15).toString().equals("A tiempo")) {
                                viewProyecto.jRATiempo.setSelected(true);
                            } else {
                                viewProyecto.jRRetraso.setSelected(true);
                            }
                            if (TProyecto.getValueAt(f, 16).toString() != null && !TProyecto.getValueAt(f, 16).toString().equals("") && !TProyecto.getValueAt(f, 16).toString().equals("null")) {
                                fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 16).toString());
                                viewProyecto.jDNFEE.setDate(fechaEntrega);
                            } else {
                                viewProyecto.jDNFEE.setDate(null);
                            }
                        } else {
                            viewProyecto.jPEstadoProyecto.setVisible(false);
                        }
                        //Estado
                        viewProyecto.Notificacion1.setVisible(true);
                        // ...
                        //POendiente la clasificacion de los colores para esta parte del código...
                        switch(Integer.parseInt(TProyecto.getValueAt(f, 9).toString())){
                            case 1:
                                switch (TProyecto.getValueAt(f, 7).toString()) {
                                    case "Por iniciar":
                                        viewProyecto.Notificacion1.setForeground(Color.GRAY);
                                        viewProyecto.Notificacion1.setText("Por Inciar");
                                        viewProyecto.btnTomaTiempos.setVisible(false);//Es false
                                        viewProyecto.btnDelete.setEnabled(true);
                                        viewProyecto.jRParada.setEnabled(true);
                                        break;
                                    case "Pausado":
                                        viewProyecto.Notificacion1.setForeground(Color.ORANGE);
                                        viewProyecto.Notificacion1.setText("Pausado");
                                        viewProyecto.btnTomaTiempos.setVisible(false);//Es false
                                        viewProyecto.btnDelete.setEnabled(true);
                                        viewProyecto.jRParada.setEnabled(true);
                                        break;
                                    case "Terminado":
                                        viewProyecto.Notificacion1.setForeground(Color.GREEN);
                                        viewProyecto.Notificacion1.setText("Terminado");
                                        viewProyecto.btnUpdate.setEnabled(false);
                                        viewProyecto.btnTomaTiempos.setVisible(true);
                                        viewProyecto.GenerarQR.setEnabled(false);
                                        viewProyecto.btnDelete.setEnabled(true);
                                        viewProyecto.jRParada.setEnabled(false);
                                        break;
                                    case "Ejecucion":
                                        viewProyecto.Notificacion1.setForeground(Color.GRAY);
                                        viewProyecto.Notificacion1.setText("Ejecucion");
                                        viewProyecto.btnTomaTiempos.setVisible(false);//Es false
                                        viewProyecto.btnDelete.setEnabled(false);
                                        viewProyecto.jRParada.setEnabled(true);
                                        break;
                                }
                                break;
                            default:
                                //El proyecto se paro su ejecución
                                viewProyecto.Notificacion1.setText("Parada");
                                viewProyecto.Notificacion1.setForeground(Color.RED);
                                viewProyecto.jREjecucion.setSelected(false);
                                viewProyecto.jREjecucion.setEnabled(true);
                                viewProyecto.jRParada.setSelected(true);
                                viewProyecto.btnUpdate.setEnabled(false);
                                break;
                        }
                        viewProyecto.jRPCBCOM.setSelected(false);
                        viewProyecto.jRPIntegracion.setSelected(false);
                        
                        //Enviar Informacion del detalle de los productos...
                        for (int i = 0; i < jTDetalleProductos.getRowCount(); i++) {
                            //Buscamos que detalles tiene este proyecto para enviar a la vista de proyecto
//                          Todo esto se puede remplazar por un switch
                            if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Conversor")) {
                                
                                viewProyecto.jLIDConversor.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCConversor.setSelected(true);
                                viewProyecto.jTConversor.setText(jTDetalleProductos.getValueAt(i, 3).toString());// Cantidades
                                // Button Radio,  Text Field, estado producto
                                validarEstadoComponentesProductos(viewProyecto.jCConversor, viewProyecto.jTConversor, jTDetalleProductos.getValueAt(i, 4).toString());// El ultimo parametro es el estado del producto
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Troquel")) {
                                
                                viewProyecto.jLIDTroquel.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCTroquel.setSelected(true);
                                viewProyecto.jTTroquel.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                validarEstadoComponentesProductos(viewProyecto.jCTroquel, viewProyecto.jTTroquel, jTDetalleProductos.getValueAt(i, 4).toString());
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Repujado")) {
                                
                                viewProyecto.jLIDRepujado.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCRepujado.setSelected(true);
                                viewProyecto.jTRepujado.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                validarEstadoComponentesProductos(viewProyecto.jCRepujado, viewProyecto.jTRepujado, jTDetalleProductos.getValueAt(i, 4).toString());
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Stencil")) {
                                
                                viewProyecto.jLIDStencil.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCStencil.setSelected(true);
                                viewProyecto.jTStencil.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                validarEstadoComponentesProductos(viewProyecto.jCStencil, viewProyecto.jTStencil, jTDetalleProductos.getValueAt(i, 4).toString());
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB") || jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB GF")) {
                                if (jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB GF")) {
                                    
                                    viewProyecto.jLIDPCBGF.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                    
                                } else {
                                    viewProyecto.jLIDPCB.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                    
                                    validarEstadoComponentesProductos(viewProyecto.jCPCBTE, viewProyecto.jTPCBTE, jTDetalleProductos.getValueAt(i, 4).toString());
                                    
                                }
                                // ...
                                boolean estado = (jTDetalleProductos.getValueAt(i, 4).toString().equals("Por iniciar"));
                                viewProyecto.jCPCBTE.setSelected(true);
                                viewProyecto.jCRuteoP.setEnabled(estado);
                                viewProyecto.cbColorPCB.setEnabled(estado);
                                viewProyecto.cbMaterialPCBTE.setEnabled(estado);
                                viewProyecto.cbColorPCB.setSelectedItem(Boolean.valueOf(jTDetalleProductos.getValueAt(i, 7).toString()));//Pendiente cambiar por el indice...
                                viewProyecto.jCRuteoP.setSelected(Boolean.valueOf(jTDetalleProductos.getValueAt(i, 8).toString()));
                                viewProyecto.cbMaterialPCBTE.setSelectedItem(jTDetalleProductos.getValueAt(i, 5).toString());
                                viewProyecto.jLMaterialPCB.setText(jTDetalleProductos.getValueAt(i, 5).toString());
                                viewProyecto.jTPCBTE.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                // ...
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito") && jTDetalleProductos.getValueAt(i, 1).toString().equals("EN")) {
                                
                                viewProyecto.jLIDIntegracion.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCIntegracion.setSelected(true);
                                viewProyecto.jTIntegracion.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                validarEstadoComponentesProductos(viewProyecto.jCIntegracion, viewProyecto.jTIntegracion, jTDetalleProductos.getValueAt(i, 4).toString());

                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito-TE") && jTDetalleProductos.getValueAt(i, 1).toString().equals("EN")) {
                                
                                viewProyecto.jLIDPCBEN.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jRPIntegracion.setSelected(true);
                                
                                
                            } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Teclado") && jTDetalleProductos.getValueAt(i, 1).toString().equals("TE")) {
                                
                                viewProyecto.jLIDTeclado.setText(jTDetalleProductos.getValueAt(i, 0).toString());
                                viewProyecto.jCTeclado.setSelected(true);
                                viewProyecto.jTTeclado.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                validarEstadoComponentesProductos(viewProyecto.jCTeclado, viewProyecto.jTTeclado, jTDetalleProductos.getValueAt(i, 4).toString());

                                
                            } else if ((jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito") || jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito GF")) && (jTDetalleProductos.getValueAt(i, 1).toString().equals("ALMACEN") || jTDetalleProductos.getValueAt(i, 1).toString().equals("FE"))) {
                                if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito GF")) {
                                    
                                    viewProyecto.jLIDCircuitoGF.setText(jTDetalleProductos.getValueAt(i, 0).toString());//Detalle de proyecto
                                    
                                } else {
                                    
                                    viewProyecto.jLIDCircuito.setText(jTDetalleProductos.getValueAt(i, 0).toString());//Detalle de proyecto
                                    validarEstadoComponentesProductos(viewProyecto.jCCircuito, viewProyecto.jTCircuito, jTDetalleProductos.getValueAt(i, 4).toString());
                                    
                                }
                                // ...
                                boolean estado= (jTDetalleProductos.getValueAt(i, 4).toString().equals("Por iniciar"));
//                                viewProyecto.jCRuteoC.setEnabled(estado);
//                                viewProyecto.jCAntisolderC.setEnabled(estado);
//                                viewProyecto.jCAntisolderC.setSelected(Boolean.valueOf(jTDetalleProductos.getValueAt(i, 7).toString()));
//                                viewProyecto.jCAntisolderC.setEnabled(estado);
                                viewProyecto.jCRuteoC.setSelected(Boolean.valueOf(jTDetalleProductos.getValueAt(i, 8).toString()));
                                viewProyecto.jCRuteoC.setEnabled(estado);
                                viewProyecto.jCCircuito.setSelected(true);
                                viewProyecto.jTCircuito.setText(jTDetalleProductos.getValueAt(i, 3).toString());
                                viewProyecto.cbMaterialCircuito.setEnabled(estado);
                                viewProyecto.cbMaterialCircuito.setSelectedItem(jTDetalleProductos.getValueAt(i, 5).toString());
                                viewProyecto.jLMaterialCircuito.setText(jTDetalleProductos.getValueAt(i, 5).toString());
                                // ...
                            } else {//Componentes del almacen
                                // ...    
                                if (jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito COM")) {
                                    viewProyecto.jLIDCircuitoCOM.setText(jTDetalleProductos.getValueAt(i, 0).toString());//Detalle de proyecto
                                } else if (jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB COM")) {
                                    viewProyecto.jRPCBCOM.setSelected(true);
                                    viewProyecto.jLIDPCBCOM.setText(jTDetalleProductos.getValueAt(i, 0).toString());//Detalle de proyecto
                                }
                                // ...
                            }
                        }
                        //Fechas de entrega a otros procesos.
                        if (!TProyecto.getValueAt(f, 10).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 17).toString());//Fecha de entrega FE Circuito
                            viewProyecto.jDFechaEntregaFE.setDate(fechaEntrega);
                            viewProyecto.jDFechaEntregaFE.setVisible(true);
                            viewProyecto.jLCircuitoFE.setVisible(true);
                        }
                        if (!TProyecto.getValueAt(f, 11).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 18).toString());//Fecha de entrega COM Circuito
                            viewProyecto.jDFechaEntregaFECOM.setDate(fechaEntrega);
                            viewProyecto.jDFechaEntregaFECOM.setVisible(true);
                            viewProyecto.jLComCircuitos.setVisible(true);
                        }

                        if (!TProyecto.getValueAt(f, 12).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 19).toString());//Fecha de entrega PCB GF
                            viewProyecto.jDFechaEntregaPCBGF.setDate(fechaEntrega);
                            viewProyecto.jDFechaEntregaPCBGF.setVisible(true);
                            viewProyecto.jLCircuitoGF.setVisible(true);
                        }

                        if (!TProyecto.getValueAt(f, 13).toString().equals("null")) {
                            fechaEntrega = fecha.parse(TProyecto.getValueAt(f, 20).toString());//Fecha de entrega COM GF
                            viewProyecto.jDFechaEntregaPCBCOMGF.setDate(fechaEntrega);
                            viewProyecto.jDFechaEntregaPCBCOMGF.setVisible(true);
                            viewProyecto.jLpcbGF.setVisible(true);
                        }
                        //Validación de edición
//                        validarEdiciones(viewProyecto);
                        //
                        viewProyecto.jScrollPane1.setVisible(true);
                        viewProyecto.jLNovedades.setVisible(true);
                        viewProyecto.jTNovedades.setVisible(true);
                        viewProyecto.jLNCaracteres.setVisible(true);
                        //texto de novedades del proyecto
                        if(!TProyecto.getValueAt(f, 14).toString().equals("null")){
                            viewProyecto.jTNovedades.setText(TProyecto.getValueAt(f, 14).toString());//Mensaje de alguna novedad 
                        }else{
                            viewProyecto.jTNovedades.setText("");//Mensaje de alguna novedad
                        }
                        //Cantidad de caracteres.
                           viewProyecto.jLNCaracteres.setText(String.valueOf(250 - TProyecto.getValueAt(f, 14).toString().length()));
                        // ...
                        this.dispose();
                    } catch (Exception e) {
                        //Si se genera algun error a la hora del paso de informacion a la vista
                        JOptionPane.showMessageDialog(null, "Error! " + e);
                    }
                }
            }
        }
    }//GEN-LAST:event_TProyectoMousePressed

    //Este procedimiento va a permitir saber que proyectos se pueden modificar y cuales no<----- esto no es necesario
//    private void validarEdiciones() {// <- Eliminar
//        //Componentes del almacen
//        for (int i = 0; i < jTDetalleProductos.getRowCount(); i++) {
//            if (jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Conversor")) {
//                //Se valida el estado del Conversor de FE 
//                estadoModificacion(i, viewProyecto.jCConversor, viewProyecto.jTConversor);
//            } else {
//                if (jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Troquel")) {
//                    //Se valida el estado del Troquel de FE 
//                    estadoModificacion(i, viewProyecto.jCTroquel, viewProyecto.jTTroquel);
//                } else {
//                    if (jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Repujado")) {
//                        //Se valida el estado del Repujado de FE 
//                        estadoModificacion(i, viewProyecto.jCRepujado, viewProyecto.jTRepujado);
//                    } else {
//                        if (jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Stencil")) {
//                            //Se valida el estado del Stencil de FE 
//                            estadoModificacion(i, viewProyecto.jCStencil, viewProyecto.jTStencil);
//                        } else {
//                            if (jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito")) {
//                                //Se valida el estado del Circuito de FE 
//                                estadoModificacion(i, viewProyecto.jCCircuito, viewProyecto.jTCircuito);
//
//                            } else {
//                                if ((jTDetalleProductos.getValueAt(i, 1).toString().equals("FE") || jTDetalleProductos.getValueAt(i, 1).toString().equals("ALMACEN")) && (jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB") || jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB GF") || jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB COM"))) {
//                                    //Se valida el estado del PCB de FE 
//                                    if (jTDetalleProductos.getValueAt(i, 2).toString().equals("PCB COM")) {
//                                        if (jTDetalleProductos.getValueAt(i, 4).toString().equals("Terminado")) {
//                                            viewProyecto.jRPCBCOM.setEnabled(false);
//                                        } else {
//                                            viewProyecto.jRPCBCOM.setEnabled(true);
//                                        }
//                                    }
//                                } else {
//                                    if (jTDetalleProductos.getValueAt(i, 1).toString().equals("TE") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Teclado")) {
//                                        //Se valida el estado del Teclado de TE 
//                                        estadoModificacion(i, viewProyecto.jCTeclado, viewProyecto.jTTeclado);
//                                    } else {
//                                        if (jTDetalleProductos.getValueAt(i, 1).toString().equals("IN") && jTDetalleProductos.getValueAt(i, 2).toString().equals("Circuito")) {
//                                            //Se valida el estado del Circuito de IN 
//                                            estadoModificacion(i, viewProyecto.jCIntegracion, viewProyecto.jTIntegracion);
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }

    private void validarEstadoComponentesProductos(JCheckBox check, TextFieldRoundBackground text, String estado) {
        if (!estado.equals("Por iniciar")) {
            //No se permitira modificar nada del producto
            check.setEnabled(false);
            text.setEnabled(false);
            text.setEditable(false);
            count++;
        } else {
            // Se podra modificar el campo seleccionado
            check.setEnabled(true);
            text.setEnabled(true);
            text.setEditable(true);
        }
    }

    private void btnEliminadosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnEliminadosActionPerformed
        //Arreglar el boton de consultar eliminados------------------------------------------>
        estadoInicialTabla(1);
        //------------------------------------------------------------------------------------>
    }//GEN-LAST:event_btnEliminadosActionPerformed

    private void jTDetalleProductosMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTDetalleProductosMouseReleased
        if(!evt.isPopupTrigger()){
            if(evt.getClickCount() == 1){
                //Consultar procesos del producto...
                try {
                    int row = jTDetalleProductos.getSelectedRow();
                    // ...
                    DetalleProyecto controlador = new DetalleProyecto();
                    crs = controlador.consultarProcesosProducto(jTDetalleProductos.getValueAt(row, 0),jTDetalleProductos.getValueAt(row, 1));// Id detalle del produto y area
                    DefaultTableModel procesos = new DefaultTableModel(null, encabezadosTBProcesos);
                    String registro[] = new String[5];
                    // ...
                    while (crs.next()) {

                        registro[0] = crs.getString("idproceso");
                        registro[1] = crs.getString("nombre_proceso");
                        registro[2] = clasificarEstado(Integer.parseInt(crs.getString("estado")));
                        registro[3] = crs.getString("tiempo_total_por_proceso");
                        registro[4] = crs.getString("cantidadProceso");
                        // ...
                        procesos.addRow(registro);
                        
                    }
                    
                    jTProcesoProducto.setModel(procesos);
                    FormatoTabla ft = new FormatoTabla(2);
                    jTProcesoProducto.setDefaultRenderer(Object.class, ft);
                    
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }//GEN-LAST:event_jTDetalleProductosMouseReleased

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ConsutaProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ConsutaProyecto().setVisible(true);
            }
        });
    }
//Metodos---------------------------------------------------------------------->
    private void activarCamposproyecto() {
        viewProyecto.btnNuevo.setEnabled(true);
        viewProyecto.jTNombreCliente.setEnabled(true);
        viewProyecto.jTNombreProyecto.setEnabled(true);
        viewProyecto.jDeEntrega.setEnabled(true);
        viewProyecto.cbTipoEjecucion.setEnabled(true);
        viewProyecto.jTIntegracion.setEnabled(true);
        viewProyecto.jPInformacion.setBackground(new Color(255, 255, 255));
        viewProyecto.jPDetalles1.setBackground(new Color(255, 255, 255));
        viewProyecto.jPDetalles.setBackground(new Color(255, 255, 255));
        if (estado == 1) {//Activo
            viewProyecto.btnDelete.setEnabled(true);
            viewProyecto.btnDelete.setVisible(true);
            viewProyecto.btnActivar.setVisible(false);
            viewProyecto.GenerarQR.setEnabled(true);
            viewProyecto.btnUpdate.setEnabled(true);
        } else {//Eliminado
            viewProyecto.btnActivar.setEnabled(true);
            viewProyecto.btnDelete.setVisible(false);
            viewProyecto.btnActivar.setVisible(true);
            viewProyecto.GenerarQR.setEnabled(false);
            viewProyecto.btnUpdate.setEnabled(false);
        }
    }

//Se valida que si se pueda ejecutar la consulta sin tener ningun problema
    private void action() {
        if ((jRIngreso.isSelected() || jREntrega.isSelected() || jRSalida.isSelected()) && jDFecha.getDate() != null) {
            controlBusqueda();
        }
    }

    private void controlBusqueda() {
        String fecha = "";
        if (jDFecha.getDate() != null) {
            DateFormat formato = new SimpleDateFormat("YYYY-MM-dd");
            fecha = formato.format(jDFecha.getDate());
        }
        consultarProyectos(jTNumerOrden.getText(), jTNombreCliente.getText(), jTNombreProyecto.getText(), fecha, 0);
    }

    private void consultarProyectos(String numerOrden, String nombrecliente, String nombreProyecto, String fecha, int eliminados) {
        Controlador.Proyecto obj = new Controlador.Proyecto();
        if (eliminados == 1) {
            //Proyectos que estan desactivados
            crs = obj.consultar_ProyectoEliminados();
        } else {
            if (!numerOrden.equals("")) {
                obj.setNum_orden(numerOrden);
            } else {
                obj.setNum_orden("");
            }
            obj.setNombreCliente(nombrecliente);
            obj.setNombreProyecto(nombreProyecto);
            obj.setFecha(fecha);
            String tipo = "";
            // ---
            if (jRIngreso.isSelected()) {//<-- Remplazar esto por un switch
                tipo = "Ingreso";
            } else if (jREntrega.isSelected()) {
                tipo = "Entrega";
            } else if (jRSalida.isSelected()) {
                tipo = "Salida";
            }
            //No estan eliminados
            crs = obj.consultar_Proyecto(tipo);
        }
        try {
            String row[] = {"N° Orden", // 0
                "Registro de", // 1
                "Nombre Cliente", // 2
                "Nombre Proyecto", // 3
                "Fecha Ingreso", // 4
                "Fecha Entrega", // 5
                "Fecha Salida", // 6
                "Estado", // 7
                "Tipo Ejecucion", // 8
                "Parada", // 9
                "Fecha1", // 10
                "Fecha2", // 11
                "Fecha3", // 12
                "Fecha4", // 13
                "Novedad", // 14
                "EstadoProyec", // 15
                "NFEE"}; // 16
            DefaultTableModel model = new DefaultTableModel(null, row);
            // ...
            while (crs.next()) {
                cantidadRegistros++;
                row[0] = crs.getString("numero_orden");
                row[1] = crs.getString("nombres");
                row[2] = crs.getString("nombre_cliente");
                row[3] = crs.getString("nombre_proyecto");
                row[4] = crs.getString("ingreso");
                row[5] = crs.getString("fecha_entrega");
                row[6] = crs.getString("salida");
                if (crs.getBoolean("parada")) {// 
                    row[7] = clasificarEstado(crs.getInt("estado"));//Estado
                } else {
                    row[7] = "Parada";
                }
                row[8] = crs.getString("tipo_proyecto");
                row[9] = String.valueOf(crs.getBoolean("parada")?1:0);
                row[10] = String.valueOf(crs.getString("entregaCircuitoFEoGF"));//Fecha1
                row[11] = String.valueOf(crs.getString("entregaCOMCircuito"));//Fecha2
                row[12] = String.valueOf(crs.getString("entregaPCBFEoGF"));//Fecha3
                row[13] = String.valueOf(crs.getString("entregaPCBCom"));//Fecha4
                row[14] = String.valueOf(crs.getString("novedades"));//Novedad
                row[15] = String.valueOf(crs.getString("estadoEmpresa"));//Estado Proyecto
                row[16] = String.valueOf(crs.getString("NFEE"));//NFEE
                //...
                model.addRow(row);
            }
            //Cantidad de registros
            jTCantidadRegistros.setText(String.valueOf(cantidadRegistros));
            cantidadRegistros = 0;
            crs.close();
            TProyecto.setModel(model);
            Objeto_tabla[] columnas = {new Objeto_tabla(0,100),
                                       new Objeto_tabla(1,0),
                                       new Objeto_tabla(2,195),
                                       new Objeto_tabla(3,250),
                                       new Objeto_tabla(4,180),
                                       new Objeto_tabla(5,120),
                                       new Objeto_tabla(6,120),
                                       new Objeto_tabla(7,100),
                                       new Objeto_tabla(8,130),
                                       new Objeto_tabla(9,0),
                                       new Objeto_tabla(10,0),
                                       new Objeto_tabla(11,0),
                                       new Objeto_tabla(12,0),
                                       new Objeto_tabla(13,0),
                                       new Objeto_tabla(14,0),
                                       new Objeto_tabla(15,0),
                                       new Objeto_tabla(16,0)};
            tamañoColumnasTabla(TProyecto, columnas);//<--- pendiente
            FormatoTabla ftProyect = new FormatoTabla(7);
            TProyecto.setDefaultRenderer(Object.class, ftProyect);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error! " + e);
        }
    }
    

    private void consultarProductosDetalleProyecto(String numer_Orden, String estadoProyectoParado) {
        DetalleProyecto obj = new DetalleProyecto();
        try {
            crs = obj.consultar_Detalle_Proyecto(numer_Orden);
            DefaultTableModel productos = new DefaultTableModel(null, encabezadosTBProductos);
            String registro[] = new String[9];
            //...
            while (crs.next()) {
                    //Detalles del proyecto o productos...
                    registro[0] = crs.getString("idDetalle_proyecto");//idDetalle del proyecto
                    registro[1] = crs.getString("nom_area");// Área de produccion
                    registro[2] = crs.getString("nombre");// Nombre producto
                    registro[3] = crs.getString("canitadad_total");//Cantidad
                    if (estadoProyectoParado.equals("1")) {
                        registro[4] = clasificarEstado(crs.getInt("estado"));//Estado de ejecucion
                    } else {
                        registro[4] = "Parada";//Estado parado
                    }
                    registro[5] = crs.getString("material");//Material
                    registro[6] = crs.getString("PNC");// PNC (Aplica o no aplica como Producto no conforme)
                    registro[7] = crs.getString("Antisolder");// 
                    registro[8] = crs.getString("Ruteo");// 
                    // ...
                    productos.addRow(registro);
            }
            crs.close();
            jTDetalleProductos.setModel(productos);
            tamañoColumnasTabla(jTDetalleProductos,new Objeto_tabla[]{new Objeto_tabla(7,0), new Objeto_tabla(8,0)});
            FormatoTabla formato = new FormatoTabla(4);
            jTDetalleProductos.setDefaultRenderer(Object.class, formato);
            //...
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    private void limpiarCampos() {
        jTNumerOrden.setText("");
        jTNombreCliente.setText("");
        jTNombreProyecto.setText("");
        jDFecha.setDate(null);
        jDFecha.setEnabled(false);
        jRnulo.setSelected(true);
        jRnulo.setVisible(false);
    }

    private void tamañoColumnasTabla(JTable tabla,Objeto_tabla[] columnas) {
        // ...
        for (Objeto_tabla columna : columnas) {
            tabla.getColumnModel().getColumn(columna.indexColumn).setMinWidth(columna.width);
            tabla.getColumnModel().getColumn(columna.indexColumn).setMaxWidth(columna.width);
            tabla.getTableHeader().getColumnModel().getColumn(columna.indexColumn).setMaxWidth(columna.width);
            tabla.getTableHeader().getColumnModel().getColumn(columna.indexColumn).setMinWidth(columna.width);
        }
        // ...
    }

    private String clasificarEstado(int estado) {
        String respuesta = "";
        switch (estado) {
            case 1: // Por iniciar
                respuesta = "Por iniciar";
                break;
            case 2: // Pausado
                respuesta = "Pausado";
                break;
            case 3: // terminado
                respuesta = "Terminado";
                break;
            case 4: // Ejecucion
                respuesta = "Ejecucion";
                break;
        }
        return respuesta;
    }
    
    private void estadoInicialTabla(int estadoSeleccionado){
        consultarProyectos("", "", "", "", estadoSeleccionado);
        jTDetalleProductos.setModel(new DefaultTableModel(null, encabezadosTBProductos));
        jTProcesoProducto.setModel(new DefaultTableModel(null, encabezadosTBProcesos));
        tamañoColumnasTabla(jTDetalleProductos,new Objeto_tabla[]{new Objeto_tabla(7,0), new Objeto_tabla(8,0)});
        limpiarCampos();
        jTNumerOrden.setEnabled(estadoSeleccionado==0);
        jTNombreCliente.setEnabled(estadoSeleccionado==0);
        jTNombreProyecto.setEnabled(estadoSeleccionado==0);
        jREntrega.setEnabled(estadoSeleccionado==0);
        jRSalida.setEnabled(estadoSeleccionado==0);
        jRIngreso.setEnabled(estadoSeleccionado==0);
        jTtipo.setText("");
        estado = estadoSeleccionado==1?0:1;
    }
//Metodo de finalizacion de clase---------------------------------------------->
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable TProyecto;
    public static elaprendiz.gui.button.ButtonColoredAction btnEliminados;
    private javax.swing.ButtonGroup fechas;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton10;
    private javax.swing.JButton jButton9;
    private com.toedter.calendar.JDateChooser jDFecha;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPEncabezado;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JRadioButton jREntrega;
    private javax.swing.JRadioButton jRIngreso;
    private javax.swing.JRadioButton jRSalida;
    private javax.swing.JRadioButton jRnulo;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JLabel jTCantidadRegistros;
    private javax.swing.JLabel jTCantidadRegistros1;
    private javax.swing.JTable jTDetalleProductos;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNombreCliente;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNombreProyecto;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNumerOrden;
    private javax.swing.JTable jTProcesoProducto;
    private javax.swing.JLabel jTtipo;
    private javax.swing.JLabel jTtipo1;
    private javax.swing.JLabel jTtipo2;
    private javax.swing.JLabel jTtipo3;
    private javax.swing.JLabel jTtipo4;
    private javax.swing.JLabel jTtipo5;
    // End of variables declaration//GEN-END:variables
}

