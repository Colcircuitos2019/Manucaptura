package Vistas;

import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import rojerusan.RSNotifyAnimated;

public class Procesos_1 extends javax.swing.JPanel {

    public Procesos_1() {
        initComponents();

    }
    private CachedRowSet crs = null;
    String v[] = new String[3];
    DefaultTableModel FE = null;
    DefaultTableModel TE = null;
    DefaultTableModel EN = null;

    private void estadoCampos(boolean estado) {
        cbArea.setEnabled(estado);
    }

    private void botonesinicio() {
        btnNuevo.setEnabled(true);
        btnGuardar.setEnabled(false);
        btnUpdate.setEnabled(false);
        jLID.setText("ID");
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel1 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jLID = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        btnNuevo = new javax.swing.JButton();
        btnGuardar = new javax.swing.JButton();
        btnUpdate = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTFE = new javax.swing.JTable();
        jPanel6 = new javax.swing.JPanel();
        cbArea = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel4 = new javax.swing.JLabel();
        cbArea2 = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel3 = new javax.swing.JLabel();
        cbArea3 = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel5 = new javax.swing.JLabel();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanel2 = new javax.swing.JPanel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTable4 = new javax.swing.JTable();
        jScrollPane6 = new javax.swing.JScrollPane();
        jTable5 = new javax.swing.JTable();
        jScrollPane7 = new javax.swing.JScrollPane();
        jTable6 = new javax.swing.JTable();
        btnNuevo1 = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTable3 = new javax.swing.JTable();
        btnGuardar1 = new javax.swing.JButton();
        btnUpdate1 = new javax.swing.JButton();

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane2.setViewportView(jTable1);

        setBackground(new java.awt.Color(219, 219, 219));
        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setToolTipText("usuarios");
        setName("Procesos"); // NOI18N

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder(), "Condicion producto", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 18), new java.awt.Color(128, 128, 131))); // NOI18N

        jLID.setText("ID");

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
        btnNuevo.setBounds(0, 0, 40, 48);

        btnGuardar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_proyect.png"))); // NOI18N
        btnGuardar.setBorderPainted(false);
        btnGuardar.setContentAreaFilled(false);
        btnGuardar.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnGuardar.setFocusPainted(false);
        btnGuardar.setFocusable(false);
        btnGuardar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_roll.png"))); // NOI18N
        btnGuardar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGuardarActionPerformed(evt);
            }
        });
        jPanel5.add(btnGuardar);
        btnGuardar.setBounds(40, 0, 40, 48);

        btnUpdate.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update.png"))); // NOI18N
        btnUpdate.setBorderPainted(false);
        btnUpdate.setContentAreaFilled(false);
        btnUpdate.setFocusPainted(false);
        btnUpdate.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update1.png"))); // NOI18N
        btnUpdate.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnUpdateActionPerformed(evt);
            }
        });
        jPanel5.add(btnUpdate);
        btnUpdate.setBounds(80, 0, 40, 48);

        jTFE = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTFE.setAutoCreateRowSorter(true);
        jTFE.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTFE.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "FE", "Circuito", "TH", "SI", "NO", "NO"},
                {null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null},
                {null, null, null, null, null, null, null}
            },
            new String [] {
                "ID Condicion", "Area", "Producto", "Material", "Antisolder", "Ruteo", "¿Asignado procesos?"
            }
        ));
        jTFE.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jTFE.setFocusable(false);
        jTFE.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTFE.setName("FE"); // NOI18N
        jTFE.setRowHeight(18);
        jTFE.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTFE.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane1.setViewportView(jTFE);

        jPanel6.setBackground(new java.awt.Color(255, 255, 255));
        jPanel6.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder()));

        cbArea.setForeground(new java.awt.Color(102, 102, 102));
        cbArea.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "Formato estandar", "Teclados", "Ensamble" }));
        cbArea.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbArea.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbArea.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbAreaItemStateChanged(evt);
            }
        });

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Productos:");

        cbArea2.setForeground(new java.awt.Color(102, 102, 102));
        cbArea2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "Formato estandar", "Teclados", "Ensamble" }));
        cbArea2.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbArea2.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbArea2.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbArea2ItemStateChanged(evt);
            }
        });

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(128, 128, 131));
        jLabel3.setText("Material:");

        cbArea3.setForeground(new java.awt.Color(102, 102, 102));
        cbArea3.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "Formato estandar", "Teclados", "Ensamble" }));
        cbArea3.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbArea3.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbArea3.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbArea3ItemStateChanged(evt);
            }
        });

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setText("Área:");

        jCheckBox2.setBackground(new java.awt.Color(255, 255, 255));
        jCheckBox2.setText("Ruteo");

        jCheckBox1.setBackground(new java.awt.Color(255, 255, 255));
        jCheckBox1.setText("Antisolder");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jCheckBox1)
                        .addGap(67, 67, 67)
                        .addComponent(jCheckBox2))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel4)
                            .addComponent(cbArea, javax.swing.GroupLayout.PREFERRED_SIZE, 195, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(cbArea2, javax.swing.GroupLayout.PREFERRED_SIZE, 195, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(cbArea3, javax.swing.GroupLayout.PREFERRED_SIZE, 195, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(25, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addGap(6, 6, 6)
                        .addComponent(cbArea3, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addGap(5, 5, 5)
                        .addComponent(cbArea2, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addGap(5, 5, 5)
                        .addComponent(cbArea, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox2))
                .addContainerGap(14, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(14, 14, 14)
                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(20, 20, 20)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLID)
                    .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1)
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(30, 30, 30)
                        .addComponent(jLID)
                        .addGap(6, 6, 6)
                        .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(7, 7, 7)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 172, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Procesos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(128, 128, 131))); // NOI18N

        jTable2.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado"},
                {"2", "Quimicos"},
                {"3", "Caminos"},
                {"4", "Quemado"},
                {"5", "C.C.TH"},
                {"6", "Screen"},
                {"7", "Estañado"},
                {"8", "CC2"},
                {"9", "Ruteo"},
                {"10", "Maquinas"}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso"
            }
        ));
        jScrollPane3.setViewportView(jTable2);

        jTabbedPane1.addTab("FE", jScrollPane3);

        jTable4.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado"},
                {"2", "Quimicos"},
                {"3", "Caminos"},
                {"4", "Quemado"},
                {"5", "C.C.TH"},
                {"6", "Screen"},
                {"7", "Estañado"},
                {"8", "CC2"},
                {"9", "Ruteo"},
                {"10", "Maquinas"}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso"
            }
        ));
        jScrollPane5.setViewportView(jTable4);

        jTabbedPane1.addTab("TE", jScrollPane5);

        jTable5.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado"},
                {"2", "Quimicos"},
                {"3", "Caminos"},
                {"4", "Quemado"},
                {"5", "C.C.TH"},
                {"6", "Screen"},
                {"7", "Estañado"},
                {"8", "CC2"},
                {"9", "Ruteo"},
                {"10", "Maquinas"}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso"
            }
        ));
        jScrollPane6.setViewportView(jTable5);

        jTabbedPane1.addTab("EN", jScrollPane6);

        jTable6.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado"},
                {"2", "Quimicos"},
                {"3", "Caminos"},
                {"4", "Quemado"},
                {"5", "C.C.TH"},
                {"6", "Screen"},
                {"7", "Estañado"},
                {"8", "CC2"},
                {"9", "Ruteo"},
                {"10", "Maquinas"}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso"
            }
        ));
        jScrollPane7.setViewportView(jTable6);

        jTabbedPane1.addTab("Globales", jScrollPane7);

        btnNuevo1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_Proyect.png"))); // NOI18N
        btnNuevo1.setBorderPainted(false);
        btnNuevo1.setContentAreaFilled(false);
        btnNuevo1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnNuevo1.setFocusPainted(false);
        btnNuevo1.setFocusable(false);
        btnNuevo1.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_prpyect_roll.png"))); // NOI18N
        btnNuevo1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnNuevo1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addGap(0, 0, Short.MAX_VALUE)
                .addComponent(btnNuevo1, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(btnNuevo1))
        );

        jPanel4.setBackground(new java.awt.Color(255, 255, 255));
        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Seleccion de procesos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(128, 128, 131))); // NOI18N
        jPanel4.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTable3.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado", "TextField"},
                {"2", "Quimicos", "TextField"},
                {"3", "Caminos", "TextField"},
                {"4", "Quemado", "TextField"},
                {"5", "C.C.TH", "TextField"},
                {"6", "Screen", "TextField"},
                {"7", "Estañado", "TextField"},
                {"8", "CC2", "TextField"},
                {"9", "Ruteo", "TextField"},
                {"10", "Maquinas", "TextField"}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Orden"
            }
        ));
        jScrollPane4.setViewportView(jTable3);

        jPanel4.add(jScrollPane4, new org.netbeans.lib.awtextra.AbsoluteConstraints(16, 30, 430, 190));

        btnGuardar1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_proyect.png"))); // NOI18N
        btnGuardar1.setBorderPainted(false);
        btnGuardar1.setContentAreaFilled(false);
        btnGuardar1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnGuardar1.setFocusPainted(false);
        btnGuardar1.setFocusable(false);
        btnGuardar1.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/save_roll.png"))); // NOI18N
        btnGuardar1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGuardar1ActionPerformed(evt);
            }
        });
        jPanel4.add(btnGuardar1, new org.netbeans.lib.awtextra.AbsoluteConstraints(410, 230, 40, -1));

        btnUpdate1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update.png"))); // NOI18N
        btnUpdate1.setBorderPainted(false);
        btnUpdate1.setContentAreaFilled(false);
        btnUpdate1.setFocusPainted(false);
        btnUpdate1.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update1.png"))); // NOI18N
        btnUpdate1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnUpdate1ActionPerformed(evt);
            }
        });
        jPanel4.add(btnUpdate1, new org.netbeans.lib.awtextra.AbsoluteConstraints(410, 230, 40, -1));

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, 460, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, 288, Short.MAX_VALUE)
                    .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
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

    private void cbAreaItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbAreaItemStateChanged
    }//GEN-LAST:event_cbAreaItemStateChanged

    private void btnGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardarActionPerformed

    }//GEN-LAST:event_btnGuardarActionPerformed

    private void btnUpdateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdateActionPerformed

    }//GEN-LAST:event_btnUpdateActionPerformed

    private void btnNuevoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevoActionPerformed
    }//GEN-LAST:event_btnNuevoActionPerformed

    private void cbArea2ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbArea2ItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbArea2ItemStateChanged

    private void btnNuevo1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevo1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnNuevo1ActionPerformed

    private void cbArea3ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbArea3ItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbArea3ItemStateChanged

    private void btnGuardar1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardar1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnGuardar1ActionPerformed

    private void btnUpdate1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdate1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnUpdate1ActionPerformed

    private void seleccionarProceso(JTable tabla) {
    }

    private void activarODesactivar(int op) {
        String mensaje1 = "";
        String mensaje2 = "";
        Controlador.Procesos obj = new Controlador.Procesos();
        if (obj.cambiarEstadoProcesos(op, Integer.parseInt(jLID.getText()))) {//"0" es para cambiar el estado a inactivo
            //Mensaje de exito!!
            mensaje1 = "Listo!";
            if (op == 1) {
                mensaje2 = "Se cambio el estado a Activo.";
            } else {
                mensaje2 = "Se cambio el estado a Inactivo.";
            }
        } else {
            //Menasaje de error.
            mensaje1 = "Error!!";
            mensaje2 = "No se pudo cambiar el estado del proceso.";
        }
        new rojerusan.RSNotifyAnimated(mensaje1, mensaje2, 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
    }


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnGuardar;
    private javax.swing.JButton btnGuardar1;
    public static javax.swing.JButton btnNuevo;
    public static javax.swing.JButton btnNuevo1;
    public static javax.swing.JButton btnUpdate;
    public static javax.swing.JButton btnUpdate1;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea2;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea3;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JLabel jLID;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JTable jTFE;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTable jTable3;
    private javax.swing.JTable jTable4;
    private javax.swing.JTable jTable5;
    private javax.swing.JTable jTable6;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
//Metodos---------------------------------------------------------------------------------------------->  
}
