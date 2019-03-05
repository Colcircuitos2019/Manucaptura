package Vistas;

import Controlador.Condicion_producto;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import rojerusan.RSNotifyAnimated;

public class Procesos_1 extends javax.swing.JPanel {// Dimensiones 905x673

    public Procesos_1() {
        initComponents();
        consultarCondicionesProductosProcesos(0);
//        consultarProcesosArea();
        //...
    }
    // Variables
    String header[] = {"ID Proceso","Nombre proceso","Estado"};
    CachedRowSet informacion= null;
    // ...
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jDialog1 = new javax.swing.JDialog();
        jPanel1 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jLID = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        btnNuevo = new javax.swing.JButton();
        btnGuardar = new javax.swing.JButton();
        btnUpdate = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTCondicion = new javax.swing.JTable();
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
        jTBProcesos = new javax.swing.JTabbedPane();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTFE = new javax.swing.JTable();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTTE = new javax.swing.JTable();
        jScrollPane6 = new javax.swing.JScrollPane();
        jTEN = new javax.swing.JTable();
        jScrollPane7 = new javax.swing.JScrollPane();
        jTGlobal = new javax.swing.JTable();
        btnNuevoProceso = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTable3 = new javax.swing.JTable();
        btnGuardar1 = new javax.swing.JButton();
        btnUpdate1 = new javax.swing.JButton();
        btnNuevo2 = new javax.swing.JButton();

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

        javax.swing.GroupLayout jDialog1Layout = new javax.swing.GroupLayout(jDialog1.getContentPane());
        jDialog1.getContentPane().setLayout(jDialog1Layout);
        jDialog1Layout.setHorizontalGroup(
            jDialog1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        jDialog1Layout.setVerticalGroup(
            jDialog1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        setBackground(new java.awt.Color(219, 219, 219));
        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setToolTipText("");
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

        jTCondicion = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex == 4 && colIndex == 5 && colIndex == 6){
                    return true;
                }else{
                    return false; //Disallow the editing of any cell
                }
            }
        };
        jTCondicion.setAutoCreateRowSorter(true);
        jTCondicion.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTCondicion.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID Condicion", "Area", "Producto", "Material", "Antisolder", "Ruteo", "¿Asignado procesos?"
            }
        ));
        jTCondicion.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jTCondicion.setDropMode(javax.swing.DropMode.INSERT_ROWS);
        jTCondicion.setFocusable(false);
        jTCondicion.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTCondicion.setName("FE"); // NOI18N
        jTCondicion.setRowHeight(18);
        jTCondicion.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTCondicion.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane1.setViewportView(jTCondicion);

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
                .addGap(26, 30, Short.MAX_VALUE))
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
        jPanel2.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTBProcesos.setBackground(new java.awt.Color(63, 179, 255));
        jTBProcesos.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        jTBProcesos.setToolTipText("");
        jTBProcesos.setFocusCycleRoot(true);
        jTBProcesos.setName(""); // NOI18N
        jTBProcesos.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTBProcesosMouseClicked(evt);
            }
        });

        jTFE = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex == 2){
                    return true;
                }else{
                    return false;
                }
            }
        };
        jTFE.setFont(new java.awt.Font("Tahoma", 0, 12));
        jTFE.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Estado"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, true
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTFE.setName("FE"); // NOI18N
        jTFE.setRowHeight(18);
        jTFE.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTFE.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTFE.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTFEMouseReleased(evt);
            }
        });
        jScrollPane3.setViewportView(jTFE);

        jTBProcesos.addTab("FE", jScrollPane3);

        jTTE = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex == 2){
                    return true;
                }else{
                    return false;
                }
            }
        };
        jTTE.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jTTE.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Estado"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTTE.setName("TE"); // NOI18N
        jTTE.setRowHeight(18);
        jTTE.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTTE.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTTEMouseReleased(evt);
            }
        });
        jScrollPane5.setViewportView(jTTE);

        jTBProcesos.addTab("TE", jScrollPane5);

        jTEN = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex == 2){
                    return true;
                }else{
                    return false;
                }
            }
        };
        jTEN.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jTEN.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Estado"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };
            boolean[] canEdit = new boolean [] {
                false, false, true
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        jTEN.setName("EN"); // NOI18N
        jTEN.setRowHeight(18);
        jTEN.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTEN.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTENMouseReleased(evt);
            }
        });
        jScrollPane6.setViewportView(jTEN);

        jTBProcesos.addTab("EN", jScrollPane6);

        jTGlobal = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                if(colIndex == 2){
                    return true;
                }else{
                    return false;
                }
            }
        };
        jTGlobal.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jTGlobal.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Estado"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTGlobal.setName("GBL"); // NOI18N
        jTGlobal.setRowHeight(18);
        jTGlobal.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTGlobal.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTGlobalMouseReleased(evt);
            }
        });
        jScrollPane7.setViewportView(jTGlobal);

        jTBProcesos.addTab("Globales", jScrollPane7);

        jPanel2.add(jTBProcesos, new org.netbeans.lib.awtextra.AbsoluteConstraints(16, 30, 351, 205));

        btnNuevoProceso.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_Proyect.png"))); // NOI18N
        btnNuevoProceso.setActionCommand("0");
        btnNuevoProceso.setBorderPainted(false);
        btnNuevoProceso.setContentAreaFilled(false);
        btnNuevoProceso.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnNuevoProceso.setFocusPainted(false);
        btnNuevoProceso.setFocusable(false);
        btnNuevoProceso.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_prpyect_roll.png"))); // NOI18N
        btnNuevoProceso.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnNuevoProcesoActionPerformed(evt);
            }
        });
        jPanel2.add(btnNuevoProceso, new org.netbeans.lib.awtextra.AbsoluteConstraints(330, 240, 36, -1));

        jPanel4.setBackground(new java.awt.Color(255, 255, 255));
        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Seleccion de procesos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 14), new java.awt.Color(128, 128, 131))); // NOI18N
        jPanel4.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jTCondicion = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTable3.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {"1", "Perforado",  new Boolean(true)},
                {"2", "Quimicos", null},
                {"3", "Caminos",  new Boolean(true)},
                {"4", "Quemado", null},
                {"5", "C.C.TH", null},
                {"6", "Screen", null},
                {"7", "Estañado", null},
                {"8", "CC2", null},
                {"9", "Ruteo", null},
                {"10", "Maquinas", null}
            },
            new String [] {
                "ID Proceso", "Nombre del proceso", "Orden"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTable3.setRowHeight(18);
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

        btnNuevo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_Proyect.png"))); // NOI18N
        btnNuevo2.setBorderPainted(false);
        btnNuevo2.setContentAreaFilled(false);
        btnNuevo2.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnNuevo2.setFocusPainted(false);
        btnNuevo2.setFocusable(false);
        btnNuevo2.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/add_prpyect_roll.png"))); // NOI18N
        btnNuevo2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnNuevo2ActionPerformed(evt);
            }
        });
        jPanel4.add(btnNuevo2, new org.netbeans.lib.awtextra.AbsoluteConstraints(370, 230, 40, -1));

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

    private void btnNuevoProcesoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevoProcesoActionPerformed
          mostrarVistaGestionProcesos(0,"");
          //jDialog1 Pendiente ver como se muestra esto desde acá 
    }//GEN-LAST:event_btnNuevoProcesoActionPerformed

    private void cbArea3ItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbArea3ItemStateChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_cbArea3ItemStateChanged

    private void btnGuardar1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardar1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnGuardar1ActionPerformed

    private void btnUpdate1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdate1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnUpdate1ActionPerformed

    private void btnNuevo2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevo2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_btnNuevo2ActionPerformed

    private void jTBProcesosMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTBProcesosMouseClicked
        consultarProcesosArea();
    }//GEN-LAST:event_jTBProcesosMouseClicked

    private void jTFEMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTFEMouseReleased
        ejecutarAccionesSeleecionTabla(evt);
    }//GEN-LAST:event_jTFEMouseReleased

    private void jTTEMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTTEMouseReleased
        ejecutarAccionesSeleecionTabla(evt);
    }//GEN-LAST:event_jTTEMouseReleased

    private void jTENMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTENMouseReleased
        ejecutarAccionesSeleecionTabla(evt);
    }//GEN-LAST:event_jTENMouseReleased

    private void jTGlobalMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTGlobalMouseReleased
       ejecutarAccionesSeleecionTabla(evt);
    }//GEN-LAST:event_jTGlobalMouseReleased

    private void ejecutarAccionesSeleecionTabla(java.awt.event.MouseEvent evt){
        JTable tabla = clasificarTablaProcesos();
        if(!evt.isPopupTrigger() && tabla.getSelectedRow() > 0){
            int idProceso = Integer.parseInt(String.valueOf(tabla.getValueAt(tabla.getSelectedRow(), 0)));
            //Modificar el nombre del proceso
            if (evt.getClickCount() == 2 && tabla.getSelectedColumn() == 1) {
                // ...
                mostrarVistaGestionProcesos(idProceso, String.valueOf(tabla.getValueAt(tabla.getSelectedRow(), 1)));
            }
            //Cambiar el estado del proceso
            if (evt.getClickCount() == 1 && tabla.getSelectedColumn() == 2) {
                Controlador.Procesos procesos = new Controlador.Procesos();
                if(procesos.cambiarEstadoProcesos(idProceso)){
                    new rojerusan.RSNotifyAnimated("Realizado!", "El cambio de estado fue realizado correctamente", 6, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                }else{
                    new rojerusan.RSNotifyAnimated("Alerta!", "Ocurrio un problema a la hora de ejecutar la acción", 6, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
                }
            }   
        }
    }
    
    private void mostrarVistaGestionProcesos(int idProceso,String nombreProceso){
        //Los procesos globales aun no estan funcionando.
        GestionProcesos formulario = new GestionProcesos(null, true, idProceso, jTBProcesos.getSelectedIndex() + 1, nombreProceso,this);
        formulario.setLocationRelativeTo(this);
        formulario.setVisible(true);
    }
    
    private void consultarCondicionesProductosProcesos(int idCondicion){
        Condicion_producto condicion = new Condicion_producto();
        try {
          CachedRowSet crs = condicion.consultarCondicionesProductos(idCondicion);
          Object[] cuerpoTabla = new Object[7];
          DefaultTableModel contenido = new DefaultTableModel(null, new String[]{"ID Condicion", "Área", "Producto", "Material", "Antisolder", "Ruteo", "¿Procesos asignados?"}){
              Class[] types = new Class[]{
                  java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class, java.lang.Boolean.class, java.lang.Boolean.class
              };
              // ...
              public Class getColumnClass(int columnIndex) {
                  return types[columnIndex];
              }
          };
          // ...
          while(crs.next()){
              cuerpoTabla[0]= crs.getString("idCondicion");
              cuerpoTabla[1]= crs.getString("nombre");
              cuerpoTabla[2]= crs.getString("nombre");
              cuerpoTabla[3]= crs.getString("material");
              cuerpoTabla[4]= crs.getBoolean("antisorder");
              cuerpoTabla[5]= crs.getBoolean("ruteo");
              cuerpoTabla[6]= crs.getBoolean("asignado");
              
              contenido.addRow(cuerpoTabla);
          }
          // ...
          jTCondicion.setModel(contenido);
          jTCondicion.updateUI();
          
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void consultarProcesosArea(){
        JTable tabla=null;
        int index = jTBProcesos.getSelectedIndex() + 1;
        DefaultTableModel ObjectTBL = new DefaultTableModel(null, header){
            Class[] types = new Class[]{
                java.lang.Object.class, java.lang.Object.class, java.lang.Boolean.class
            };

            public Class getColumnClass(int columnIndex) {
                return types[columnIndex];
            }
        };
        Object registro[]= new Object[3];
        // ...
        tabla = clasificarTablaProcesos();
        // ...
        Controlador.Procesos procesos = new Controlador.Procesos();
        informacion = procesos.consultarProcesos(index);
        // ...
        try {
            // ...
            while (informacion.next()) {
                
                registro[0] = informacion.getString("idproceso");
                registro[1] = informacion.getString("nombre_proceso");
                registro[2] = informacion.getBoolean("estado");
                
                ObjectTBL.addRow(registro);
                
            }
            // ...
            tabla.setModel(ObjectTBL);
            tabla.updateUI();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        // ...
    }
    
    private JTable clasificarTablaProcesos(){
        JTable tabla=null;
        // ...
        int index = jTBProcesos.getSelectedIndex() + 1;
        switch (index) {
            case 1: // FE
                tabla = jTFE;
                break;
            case 2: // TE
                tabla = jTTE;
                break;
            case 3: // EN
                tabla = jTEN;
                break;
            default: // Globales
                tabla = jTGlobal;
                break;
        }
        // ...
        return tabla;
    }
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnGuardar;
    private javax.swing.JButton btnGuardar1;
    public static javax.swing.JButton btnNuevo;
    public static javax.swing.JButton btnNuevo2;
    public static javax.swing.JButton btnNuevoProceso;
    public static javax.swing.JButton btnUpdate;
    public static javax.swing.JButton btnUpdate1;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea2;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea3;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JDialog jDialog1;
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
    private javax.swing.JTabbedPane jTBProcesos;
    private javax.swing.JTable jTCondicion;
    private javax.swing.JTable jTEN;
    private javax.swing.JTable jTFE;
    private javax.swing.JTable jTGlobal;
    private javax.swing.JTable jTTE;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable3;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
//Metodos---------------------------------------------------------------------------------------------->  
}
