package Vistas;

import Controlador.DetalleProyecto;
import Controlador.Empleado;
import Controlador.FE_TE_IN;
import Controlador.Tabla;
import java.util.ArrayList;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import rojerusan.RSNotifyAnimated;

public class detalleProyecto extends javax.swing.JDialog {

    public detalleProyecto(java.awt.Frame parent, boolean modal, int detalle, int negocio, String orden, int permiso, int cargo) {//Falta organizar la variable "tipo" para que traiga el valor correspondiente
        super(parent, modal);
        initComponents();
        if (negocio == 1) {
            this.setTitle(orden + " - " + "Formato estándar");
        } else if (negocio == 2) {
            this.setTitle(orden + " - " + "Teclados");
        } else if (negocio == 3) {
            this.setTitle(orden + " - " + "Ensamble");
        } else {
            this.setTitle(orden + " - " + "Almacen");
        }

        this.detalle = detalle;
        this.negocio = negocio;
        this.setLocationRelativeTo(null);
        this.permiso = permiso;
        this.cargo = cargo;
        jLiderProyecto.setText(" ");
        cargarTabla();
        jTNombreCliente.setEditable(false);
        jTNombreProyecto.setEditable(false);
        jTFechaEntrega.setEditable(false);
        jTFechaIngreso.setEditable(false);
        jTCantidadTotal.setEditable(false);
        jTTimepoTotal.setEditable(false);
        jTTimepoTotalUnidad.setEditable(false);
        jTFechaIngreso1.setEditable(false);
        jTFechaIngreso2.setEditable(false);
        jTFechaIngreso3.setEditable(false);
        jTFechaIngreso4.setEditable(false);
        jLiderProyecto.setEditable(false);
        TDetalleProduccion.getTableHeader().setReorderingAllowed(false);
        if(cargo==3 && negocio==3){
           jLiderProyecto.setVisible(true);
           jBAgregarLider.setVisible(true);
           jLabel15.setVisible(true);
        }else{
           jLiderProyecto.setVisible(false);
           jBAgregarLider.setVisible(false);
           jLabel15.setVisible(false);
           this.setSize(1380, 460);
        }
        //jTTimepoTotalUnidad
        this.setIconImage(new ImageIcon(getClass().getResource("/imagenesEmpresa/favicon.png")).getImage());
    }
    
    public detalleProyecto(){
    }
    //variables
    private CachedRowSet crs = null;
    protected static int detalle = 0, cargo = 0;
    private static int negocio = 0, permiso = 0;
    int rows = -1;

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        popMenu = new javax.swing.JPopupMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jPanel1 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        TDetalleProduccion = new javax.swing.JTable();
        jPInformacion = new javax.swing.JPanel();
        jTNombreCliente = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel5 = new javax.swing.JLabel();
        jTNombreProyecto = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        jTFechaEntrega = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTFechaIngreso = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jTCantidadTotal = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel8 = new javax.swing.JLabel();
        jTTimepoTotal = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jTFechaIngreso1 = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel11 = new javax.swing.JLabel();
        jTFechaIngreso2 = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel12 = new javax.swing.JLabel();
        jTFechaIngreso3 = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel13 = new javax.swing.JLabel();
        jTFechaIngreso4 = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel14 = new javax.swing.JLabel();
        jTTimepoTotalUnidad = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jBAgregarLider = new javax.swing.JButton();
        jLiderProyecto = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel15 = new javax.swing.JLabel();

        jMenuItem1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/retro.png"))); // NOI18N
        jMenuItem1.setText("Actualizar");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        popMenu.add(jMenuItem1);

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new java.awt.Dimension(1348, 432));

        jPanel1.setPreferredSize(new java.awt.Dimension(1285, 416));

        TDetalleProduccion = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex==15){
                    return false;
                }else{
                    return false;
                }
            }
        };
        TDetalleProduccion.setAutoCreateRowSorter(true);
        TDetalleProduccion.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        TDetalleProduccion.setForeground(new java.awt.Color(128, 128, 131));
        TDetalleProduccion.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
            },
            new String [] {
                "Proceso", "Fecha inicio", "Fecha fin", "Restantes", "Cantidad Procesada", "Tiempo total min", "Tiempo por unidad min", "Estado", "Hora Ejecucion", "Tiempo Ejecucion", "Hora Terminacion", "N°Op", "reiniciar", "IDdetalle", "Tiempo"
            }
        ));
        TDetalleProduccion.setFillsViewportHeight(true);
        TDetalleProduccion.setFocusTraversalPolicyProvider(true);
        TDetalleProduccion.setFocusable(false);
        TDetalleProduccion.setGridColor(new java.awt.Color(255, 255, 255));
        TDetalleProduccion.setIntercellSpacing(new java.awt.Dimension(0, 0));
        TDetalleProduccion.setMinimumSize(new java.awt.Dimension(900, 300));
        TDetalleProduccion.setName("TDetalleProduccion"); // NOI18N
        TDetalleProduccion.setRowHeight(18);
        TDetalleProduccion.setSelectionBackground(new java.awt.Color(63, 179, 255));
        TDetalleProduccion.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        TDetalleProduccion.setShowHorizontalLines(false);
        TDetalleProduccion.setShowVerticalLines(false);
        TDetalleProduccion.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                TDetalleProduccionMouseClicked(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                TDetalleProduccionMouseReleased(evt);
            }
        });
        TDetalleProduccion.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                TDetalleProduccionPropertyChange(evt);
            }
        });
        jScrollPane3.setViewportView(TDetalleProduccion);

        jPInformacion.setBackground(new java.awt.Color(255, 255, 255));
        jPInformacion.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder(), "Información del detalle"));

        jTNombreCliente.setBorder(null);
        jTNombreCliente.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreCliente.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreCliente.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setText("Nombre del cliente:");

        jTNombreProyecto.setBorder(null);
        jTNombreProyecto.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreProyecto.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreProyecto.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Nombre del proyecto:");

        jTFechaEntrega.setBorder(null);
        jTFechaEntrega.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaEntrega.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaEntrega.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel6.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(128, 128, 131));
        jLabel6.setText("Fecha de entrega:");

        jLabel7.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel7.setForeground(new java.awt.Color(128, 128, 131));
        jLabel7.setText("Fecha de ingreso:");

        jTFechaIngreso.setBorder(null);
        jTFechaIngreso.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaIngreso.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaIngreso.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jTCantidadTotal.setBorder(null);
        jTCantidadTotal.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTCantidadTotal.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTCantidadTotal.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel8.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel8.setForeground(new java.awt.Color(128, 128, 131));
        jLabel8.setText("Cantidad:");

        jTTimepoTotal.setBorder(null);
        jTTimepoTotal.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTTimepoTotal.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTTimepoTotal.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel9.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel9.setForeground(new java.awt.Color(128, 128, 131));
        jLabel9.setText("Tiempo Total:");

        jLabel10.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel10.setForeground(new java.awt.Color(128, 128, 131));
        jLabel10.setText("Tiempo total por unidad :");

        jTFechaIngreso1.setBorder(null);
        jTFechaIngreso1.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaIngreso1.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaIngreso1.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel11.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel11.setForeground(new java.awt.Color(128, 128, 131));
        jLabel11.setText("Fecha de entrega Circuito FE o GF");

        jTFechaIngreso2.setBorder(null);
        jTFechaIngreso2.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaIngreso2.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaIngreso2.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel12.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel12.setForeground(new java.awt.Color(128, 128, 131));
        jLabel12.setText("Fecha de entrega COM Circuito FE o GF");

        jTFechaIngreso3.setBorder(null);
        jTFechaIngreso3.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaIngreso3.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaIngreso3.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jTFechaIngreso3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTFechaIngreso3ActionPerformed(evt);
            }
        });

        jLabel13.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel13.setForeground(new java.awt.Color(128, 128, 131));
        jLabel13.setText("Fecha de entrega PCB FE o GF:");

        jTFechaIngreso4.setBorder(null);
        jTFechaIngreso4.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTFechaIngreso4.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTFechaIngreso4.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel14.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel14.setForeground(new java.awt.Color(128, 128, 131));
        jLabel14.setText("Fecha de entrega COM PCB FE o GF:");

        jTTimepoTotalUnidad.setBorder(null);
        jTTimepoTotalUnidad.setText(" ");
        jTTimepoTotalUnidad.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTTimepoTotalUnidad.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTTimepoTotalUnidad.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jTTimepoTotalUnidad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTTimepoTotalUnidadActionPerformed(evt);
            }
        });

        jBAgregarLider.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/addBoos.png"))); // NOI18N
        jBAgregarLider.setBorderPainted(false);
        jBAgregarLider.setContentAreaFilled(false);
        jBAgregarLider.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jBAgregarLider.setFocusPainted(false);
        jBAgregarLider.setFocusable(false);
        jBAgregarLider.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/addBossRelease.png"))); // NOI18N
        jBAgregarLider.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBAgregarLiderActionPerformed(evt);
            }
        });

        jLiderProyecto.setBorder(null);
        jLiderProyecto.setText("   ");
        jLiderProyecto.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jLiderProyecto.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jLiderProyecto.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N

        jLabel15.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel15.setForeground(new java.awt.Color(128, 128, 131));
        jLabel15.setText("Lider del proyecto EN");

        javax.swing.GroupLayout jPInformacionLayout = new javax.swing.GroupLayout(jPInformacion);
        jPInformacion.setLayout(jPInformacionLayout);
        jPInformacionLayout.setHorizontalGroup(
            jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPInformacionLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 135, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTNombreCliente, javax.swing.GroupLayout.PREFERRED_SIZE, 416, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, Short.MAX_VALUE)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel4)
                            .addComponent(jTNombreProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, 18)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTCantidadTotal, javax.swing.GroupLayout.PREFERRED_SIZE, 79, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTFechaIngreso, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel7))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTFechaEntrega, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6))
                        .addGap(38, 38, 38))
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTTimepoTotal, javax.swing.GroupLayout.PREFERRED_SIZE, 101, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 101, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(26, 26, 26)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel10)
                            .addGroup(jPInformacionLayout.createSequentialGroup()
                                .addGap(10, 10, 10)
                                .addComponent(jTTimepoTotalUnidad, javax.swing.GroupLayout.PREFERRED_SIZE, 121, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(62, 62, 62)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTFechaIngreso1, javax.swing.GroupLayout.PREFERRED_SIZE, 203, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(15, 15, 15)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel12)
                            .addComponent(jTFechaIngreso2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(18, 18, 18)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTFechaIngreso3, javax.swing.GroupLayout.PREFERRED_SIZE, 206, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 206, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jTFechaIngreso4, javax.swing.GroupLayout.PREFERRED_SIZE, 216, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(94, 94, 94))
                    .addGroup(jPInformacionLayout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLiderProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 428, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel15))
                        .addGap(18, 18, 18)
                        .addComponent(jBAgregarLider, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(43, 43, 43))))
        );
        jPInformacionLayout.setVerticalGroup(
            jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPInformacionLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5)
                    .addComponent(jLabel7)
                    .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jTNombreCliente, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                            .addComponent(jLabel4)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTNombreProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTCantidadTotal, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                            .addComponent(jLabel8)
                            .addGap(31, 31, 31))
                        .addComponent(jTFechaIngreso, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                            .addComponent(jLabel6)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jTFechaEntrega, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 15, Short.MAX_VALUE)
                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                        .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPInformacionLayout.createSequentialGroup()
                                    .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                        .addComponent(jLabel10)
                                        .addComponent(jLabel9))
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jTTimepoTotalUnidad, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGroup(jPInformacionLayout.createSequentialGroup()
                                    .addGap(21, 21, 21)
                                    .addComponent(jTTimepoTotal, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jTFechaIngreso1, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPInformacionLayout.createSequentialGroup()
                                        .addComponent(jLabel11)
                                        .addGap(31, 31, 31)))
                                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jTFechaIngreso2, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPInformacionLayout.createSequentialGroup()
                                        .addComponent(jLabel12)
                                        .addGap(31, 31, 31)))
                                .addGroup(jPInformacionLayout.createSequentialGroup()
                                    .addGap(21, 21, 21)
                                    .addComponent(jTFechaIngreso3, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addComponent(jTFechaIngreso4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                                .addGroup(jPInformacionLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel14)
                                    .addComponent(jLabel13))
                                .addGap(31, 31, 31)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel15)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLiderProyecto, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(21, 21, 21))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPInformacionLayout.createSequentialGroup()
                        .addComponent(jBAgregarLider)
                        .addContainerGap())))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPInformacion, javax.swing.GroupLayout.PREFERRED_SIZE, 1344, Short.MAX_VALUE)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.TRAILING))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPInformacion, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 1364, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, 484, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void TDetalleProduccionMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_TDetalleProduccionMouseClicked
        //Botones de seguridad//El boton de reiniciar proceso hay que organizarlos procesos de ensamble
        String[] botones = {" SI ", " NO "};
        String v[];
        rows = TDetalleProduccion.rowAtPoint(evt.getPoint());

        int column = TDetalleProduccion.getColumnModel().getColumnIndexAtX(evt.getX());
        int row = evt.getY() / TDetalleProduccion.getRowHeight();

        if (row < TDetalleProduccion.getRowCount() && row >= 0 && column < TDetalleProduccion.getColumnCount() && column >= 0) {
            Object value = TDetalleProduccion.getValueAt(row, column);
            if (value instanceof JButton) {
                JButton boton;
                boton = (JButton) value;
                if (boton.getText().equals("Tiempo") && !TDetalleProduccion.getValueAt(row, 7).toString().equals("Pausado")) {
                    //Finalizar la toma de tiempo de los procesos del almacen(Solo lo pueden realizar los encargado de almacen)
                    if (boton.getActionCommand().equals("1")) {
                        FE_TE_IN almacen = new FE_TE_IN();
                        String idDetalle = "";
                        //<Gran formato>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                        if (TDetalleProduccion.getValueAt(row, 0).toString().equals("GF")) {
                            //Se pide la cantidad que se recibio del gran formato.
                            String cantidad = JOptionPane.showInputDialog("Cantidades recibidas:");
                            if (cantidad != null) {//Presiona el botono "NO"
                                if (!cantidad.equals("") && Integer.parseInt(cantidad) >= 1) {//Validar la cantidad cuendo presiona el boton "SI"
                                    idDetalle = String.valueOf(TDetalleProduccion.getValueAt(row, 13));//Identificador
                                    int proceso = 0;
                                    if (TDetalleProduccion.getValueAt(row, 0).toString().equals("GF")) {
                                        proceso = 20;//Proceso de gran formato.
                                    }
                                    String orden[] = this.getTitle().split("-");                                                  //Cantidad//   
                                    if (almacen.pararTiempoAlmacen(Integer.parseInt(orden[0].trim()), Integer.parseInt(idDetalle), Integer.parseInt(cantidad), detalle, proceso)) {
                                        //Mensaje de confirmación.
                                        new rojerusan.RSNotifyAnimated("¡Listo!", "Mensaje", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                                        cargarTabla();
                                    }
                                } else {
                                    //Mensaje de ingresar una cantidad valida.
                                    new rojerusan.RSNotifyAnimated("¡Alerta!", "Por favor ingrese una cantidad validad.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
                                }
                            }
                        } else {//Si presiona el boton SI
                            //<Componentes>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                            //Registro te tiempo de componentes
                            if (JOptionPane.showOptionDialog(null, "¿Seguro desea terminar la toma de tiempos de los componentes.", "Seguridad", JOptionPane.YES_NO_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE, null/*icono*/, botones, botones[0]) == 0) {
                                idDetalle = String.valueOf(TDetalleProduccion.getValueAt(row, 13));//Identificador
                                String orden[] = this.getTitle().split("-");                                         //Cantidad//      Proceso  
                                almacen.pararTiempoAlmacen(Integer.parseInt(orden[0].trim()), Integer.parseInt(idDetalle), 0, detalle, 19);//
                                //Mensaje de confirmación de la terminación de la toma de tiempo
                                new rojerusan.RSNotifyAnimated("¡Listo!", "Toma de tiempo finalizada correctamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                                cargarTabla();
                            }
                        }
                    }
                    //------------------------------------------------------------
                } else {
                    //Boton para reiniciar la toma de tiempo(Solo lo puede realizar el administrador)
                    if (boton.getActionCommand().equals("1")) {
                        if (JOptionPane.showOptionDialog(null, "¿Seguro desea reinicializar la toma de tiempo? Perdera toda esta información.", "Seguridad", JOptionPane.YES_NO_CANCEL_OPTION, JOptionPane.QUESTION_MESSAGE, null/*icono*/, botones, botones[0]) == 0) {
                            String idDetalle = String.valueOf(TDetalleProduccion.getValueAt(row, 13));//Identificador!!
                            DetalleProyecto obj = new DetalleProyecto();
                            if (obj.ReiniciarDetalle(Integer.parseInt(idDetalle), negocio, detalle)) {///Pendiente???¿¿¿???¿¿¿XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
                                new rojerusan.RSNotifyAnimated("¡Listo!", "El proceso: " + TDetalleProduccion.getValueAt(row, 0) + " fue reinicializado corresctamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                                cargarTabla();
                            } else {
                                new rojerusan.RSNotifyAnimated("¡Error!", "El proceso: " + TDetalleProduccion.getValueAt(row, 0) + " no pudo ser reinicializado.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
                            }
                        }
                    }
                }
            }else if(value instanceof JRadioButton){
                JRadioButton radioBoton= (JRadioButton) value;
                if(!radioBoton.isSelected() && radioBoton.isEnabled()){//Validar si se puede modificar el proceso inial para poder ejecutar la toma de tiempo
                    //Seleccionar Primer proceso del área...
                    DetalleProyecto obj = new DetalleProyecto();
                    v = radioBoton.getActionCommand().split("-");// Vector de una log maxima siempre de 2
                    obj.seleccionPrimerProcesoEnsamble(Integer.parseInt(v[1]), Integer.parseInt(v[0]));
                    radioBoton.setSelected(true);
                    radioBoton.updateUI();
                    TDetalleProduccion.updateUI();
                }
            }
        }
    }//GEN-LAST:event_TDetalleProduccionMouseClicked

    private void TDetalleProduccionMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_TDetalleProduccionMouseReleased
        if (negocio != 4) {
            if (evt.isPopupTrigger()) {
                popMenu.show(evt.getComponent(), evt.getX(), evt.getY());
            }
        }
    }//GEN-LAST:event_TDetalleProduccionMouseReleased
    //one day baby, i thiking but
    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        cargarTabla();
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jTFechaIngreso3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTFechaIngreso3ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTFechaIngreso3ActionPerformed

    private void jTTimepoTotalUnidadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTTimepoTotalUnidadActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTTimepoTotalUnidadActionPerformed

    private void jBAgregarLiderActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBAgregarLiderActionPerformed
        Empleados obj=new Empleados(null,true);
        obj.setLocationRelativeTo(null);
        obj.setVisible(true);
    }//GEN-LAST:event_jBAgregarLiderActionPerformed

    private void TDetalleProduccionPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_TDetalleProduccionPropertyChange
    }//GEN-LAST:event_TDetalleProduccionPropertyChange

    private void cargarTabla() {
        Tabla personalizar = new Tabla();
        personalizar.visualizar(TDetalleProduccion, detalle, negocio);//Consulta de la informacion de los proceso
        try {
            DetalleProyecto obj = new DetalleProyecto();
            crs = obj.ConsultarInformacionFiltrariaDelDetalle(detalle);//Consulta la información filtraria.
            crs.next();
            jTNombreCliente.setText("  " + crs.getString(1));//Orden
            jTNombreProyecto.setText("  " + crs.getString(2));//Nombre proyecto
            jTFechaIngreso.setText("  " + crs.getString(3));//Fecha de ingreso
            jTFechaEntrega.setText("  " + crs.getString(4));//Fecha de entraga
            jTCantidadTotal.setText("  " + crs.getString(5));//cantidad total
            jTTimepoTotal.setText(crs.getString(6) == null ? "  00:00" : "  " + crs.getString(6));//Timepo total
            jTTimepoTotalUnidad.setText(crs.getString(7) == null ? "  00:00" : "  " + crs.getString(7));//Timepo total por unidad
            jTFechaIngreso1.setText("  " + (crs.getString(8) == null ? "" : crs.getString(8)));//fecha numero 1
            jTFechaIngreso2.setText("  " + (crs.getString(9) == null ? "" : crs.getString(9)));//fecha numero 2
            jTFechaIngreso3.setText("  " + (crs.getString(10) == null ? "" : crs.getString(10)));//fecha numero 3
            jTFechaIngreso4.setText("  " + (crs.getString(11) == null ? "" : crs.getString(11)));//fecha numero 4
            //Consultar Nombre del lider de produccion
            if(cargo==3){
                if (crs.getString(12) != null) {
                    Empleado emp = new Empleado();
                    jLiderProyecto.setText(emp.consultarNombreLiderProyecto(crs.getString(12)));//Nombre del empleado que es lider del proyecto
                } else {
                    jLiderProyecto.setText("");
                }   
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error!! " + e);
        }

        if (permiso == 1 || negocio == 4) {
            if (negocio == 4) {
                //Tiempo por unidad
                TDetalleProduccion.getColumnModel().getColumn(6).setMinWidth(0);
                TDetalleProduccion.getColumnModel().getColumn(6).setMaxWidth(0);
                TDetalleProduccion.getTableHeader().getColumnModel().getColumn(6).setMaxWidth(0);
                TDetalleProduccion.getTableHeader().getColumnModel().getColumn(6).setMinWidth(0);
            }
        }
        //Boton reiniciar
        if(cargo!=4){
            editarTamañoColumnas();
        }
        //Seleccion de orden de proceso inicial
        if(cargo!=3){
            //orden
            TDetalleProduccion.getColumnModel().getColumn(15).setMinWidth(0);
            TDetalleProduccion.getColumnModel().getColumn(15).setMaxWidth(0);
            TDetalleProduccion.getTableHeader().getColumnModel().getColumn(15).setMaxWidth(0);
            TDetalleProduccion.getTableHeader().getColumnModel().getColumn(15).setMinWidth(0);
        }
        
        //Boton parar toma de tiempo para almacen
        if (negocio != 4 || cargo !=5) {
            TDetalleProduccion.getColumnModel().getColumn(14).setMinWidth(0);
            TDetalleProduccion.getColumnModel().getColumn(14).setMaxWidth(0);
            TDetalleProduccion.getTableHeader().getColumnModel().getColumn(14).setMaxWidth(0);
            TDetalleProduccion.getTableHeader().getColumnModel().getColumn(14).setMinWidth(0);
        }
        //ID detalle del almacen
        TDetalleProduccion.getColumnModel().getColumn(13).setMinWidth(0);
        TDetalleProduccion.getColumnModel().getColumn(13).setMaxWidth(0);
        TDetalleProduccion.getTableHeader().getColumnModel().getColumn(13).setMaxWidth(0);
        TDetalleProduccion.getTableHeader().getColumnModel().getColumn(13).setMinWidth(0);
    }

    public void editarTamañoColumnas() {
        TDetalleProduccion.getColumnModel().getColumn(12).setMinWidth(0);
        TDetalleProduccion.getColumnModel().getColumn(12).setMaxWidth(0);
        TDetalleProduccion.getTableHeader().getColumnModel().getColumn(12).setMaxWidth(0);
        TDetalleProduccion.getTableHeader().getColumnModel().getColumn(12).setMinWidth(0);
    }

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
            java.util.logging.Logger.getLogger(detalleProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(detalleProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(detalleProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(detalleProyecto.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the dialog */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                detalleProyecto dialog = new detalleProyecto(new javax.swing.JFrame(), true, 0, 0, "", 0, 0);
                dialog.addWindowListener(new java.awt.event.WindowAdapter() {
                    @Override
                    public void windowClosing(java.awt.event.WindowEvent e) {
                        System.exit(0);
                    }
                });
                dialog.setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable TDetalleProduccion;
    private javax.swing.JButton jBAgregarLider;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jLiderProyecto;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JPanel jPInformacion;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane3;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTCantidadTotal;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaEntrega;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaIngreso;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaIngreso1;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaIngreso2;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaIngreso3;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTFechaIngreso4;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNombreCliente;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNombreProyecto;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTTimepoTotal;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTTimepoTotalUnidad;
    private javax.swing.JPopupMenu popMenu;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
