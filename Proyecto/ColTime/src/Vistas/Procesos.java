package Vistas;

import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import rojerusan.RSNotifyAnimated;

public class Procesos extends javax.swing.JPanel {

    public Procesos() {
        initComponents();
        consultarProcesos();
        jLID.setVisible(false);
        tamañoColumnas(jTFE);
        tamañoColumnas(jTTE);
        tamañoColumnas(jTEN);
        jTFE.getTableHeader().setReorderingAllowed(false);
        jTTE.getTableHeader().setReorderingAllowed(false);
        jTEN.getTableHeader().setReorderingAllowed(false);
        estadoCampos(false);
        botonesinicio();
    }
    private CachedRowSet crs = null;
    String v[] = new String[3];
    DefaultTableModel FE = null;
    DefaultTableModel TE = null;
    DefaultTableModel EN = null;

    private void estadoCampos(boolean estado) {
        jTNombreProceso.setEnabled(estado);
        cbArea.setEnabled(estado);
    }

    private void botonesinicio() {
        btnNuevo.setEnabled(true);
        btnGuardar.setEnabled(false);
        btnUpdate.setEnabled(false);
        btnDelete.setVisible(true);
        btnDelete.setEnabled(false);
        btnActivar.setEnabled(false);
        btnActivar.setVisible(false);
        jLID.setText("ID");
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane2 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTFE = new javax.swing.JTable();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTTE = new javax.swing.JTable();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTEN = new javax.swing.JTable();
        jPanel3 = new javax.swing.JPanel();
        jTNombreProceso = new elaprendiz.gui.textField.TextFieldRoundBackground();
        cbArea = new elaprendiz.gui.comboBox.ComboBoxRound();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        btnNuevo = new javax.swing.JButton();
        btnGuardar = new javax.swing.JButton();
        btnUpdate = new javax.swing.JButton();
        btnDelete = new javax.swing.JButton();
        btnActivar = new javax.swing.JButton();
        jLID = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();

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

        jTFE = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTFE.setAutoCreateRowSorter(true);
        jTFE.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTFE.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "ID", "Nombre", "Estado"
            }
        ));
        jTFE.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jTFE.setFocusable(false);
        jTFE.setGridColor(new java.awt.Color(255, 255, 255));
        jTFE.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTFE.setName("FE"); // NOI18N
        jTFE.setRowHeight(18);
        jTFE.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTFE.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTFE.setShowHorizontalLines(false);
        jTFE.setShowVerticalLines(false);
        jTFE.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTFEMousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTFE);

        jTTE = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTTE.setAutoCreateRowSorter(true);
        jTTE.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTTE.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "ID", "Nombre", "Estado"
            }
        ));
        jTTE.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jTTE.setFocusable(false);
        jTTE.setGridColor(new java.awt.Color(255, 255, 255));
        jTTE.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTTE.setName("TE"); // NOI18N
        jTTE.setRowHeight(18);
        jTTE.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTTE.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTTE.setShowHorizontalLines(false);
        jTTE.setShowVerticalLines(false);
        jTTE.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTTEMousePressed(evt);
            }
        });
        jScrollPane3.setViewportView(jTTE);

        jTEN = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTEN.setAutoCreateRowSorter(true);
        jTEN.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jTEN.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "ID", "Nombre", "Estado"
            }
        ));
        jTEN.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jTEN.setFocusable(false);
        jTEN.setGridColor(new java.awt.Color(255, 255, 255));
        jTEN.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTEN.setName("EN"); // NOI18N
        jTEN.setRowHeight(18);
        jTEN.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTEN.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTEN.setShowHorizontalLines(false);
        jTEN.setShowVerticalLines(false);
        jTEN.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTENMousePressed(evt);
            }
        });
        jScrollPane4.setViewportView(jTEN);

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder(), "Procesos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 18), new java.awt.Color(128, 128, 131))); // NOI18N

        jTNombreProceso.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNombreProceso.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNombreProceso.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTNombreProceso.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNombreProcesoKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTNombreProcesoKeyTyped(evt);
            }
        });

        cbArea.setForeground(new java.awt.Color(102, 102, 102));
        cbArea.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Seleccione...", "Formato estandar", "Teclados", "Ensamble" }));
        cbArea.setColorDeBorde(new java.awt.Color(204, 204, 204));
        cbArea.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        cbArea.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                cbAreaItemStateChanged(evt);
            }
        });

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(128, 128, 131));
        jLabel3.setText("Nombre Proceso:");

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText("Área:");

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
        btnNuevo.setBounds(2, 2, 57, 47);

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
        btnGuardar.setBounds(59, 0, 57, 49);

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
        btnUpdate.setBounds(118, 0, 60, 49);

        btnDelete.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/delete.png"))); // NOI18N
        btnDelete.setBorderPainted(false);
        btnDelete.setContentAreaFilled(false);
        btnDelete.setFocusPainted(false);
        btnDelete.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/delete1 (2).png"))); // NOI18N
        btnDelete.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnDeleteActionPerformed(evt);
            }
        });
        jPanel5.add(btnDelete);
        btnDelete.setBounds(180, 0, 58, 49);

        btnActivar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/chek-user.png"))); // NOI18N
        btnActivar.setBorderPainted(false);
        btnActivar.setContentAreaFilled(false);
        btnActivar.setFocusPainted(false);
        btnActivar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/chek-user1.png"))); // NOI18N
        btnActivar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnActivarActionPerformed(evt);
            }
        });
        jPanel5.add(btnActivar);
        btnActivar.setBounds(180, 0, 60, 49);

        jLID.setText("ID");

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(28, 28, 28)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(142, 142, 142)
                        .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(169, 169, 169)
                        .addComponent(jLID))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTNombreProceso, javax.swing.GroupLayout.PREFERRED_SIZE, 248, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(28, 28, 28)
                        .addComponent(cbArea, javax.swing.GroupLayout.PREFERRED_SIZE, 195, javax.swing.GroupLayout.PREFERRED_SIZE))))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                    .addContainerGap(591, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 243, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(19, Short.MAX_VALUE)))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(11, 11, 11)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel3)
                            .addComponent(jLabel4)))
                    .addComponent(jLID))
                .addGap(2, 2, 2)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTNombreProceso, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(cbArea, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(19, Short.MAX_VALUE))
            .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                    .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(128, 128, 131));
        jLabel5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel5.setText("Formato estandar");

        jLabel6.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(128, 128, 131));
        jLabel6.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel6.setText("Teclados");

        jLabel7.setFont(new java.awt.Font("Tahoma", 1, 18)); // NOI18N
        jLabel7.setForeground(new java.awt.Color(128, 128, 131));
        jLabel7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel7.setText("Ensamble");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(4, 4, 4)
                                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 282, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(56, 56, 56)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 176, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 283, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 7, Short.MAX_VALUE)
                                .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 281, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(75, 75, 75)
                                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 134, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(68, 68, 68)))))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(32, 32, 32)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 44, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(jLabel7)
                    .addComponent(jLabel5))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane1)
                    .addComponent(jScrollPane3)
                    .addComponent(jScrollPane4))
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

    private void jTNombreProcesoKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreProcesoKeyReleased
        if (!jTNombreProceso.getText().equals("") && cbArea.getSelectedIndex() != 0) {
            btnGuardar.setEnabled(true);
        } else {
            btnGuardar.setEnabled(false);
        }
    }//GEN-LAST:event_jTNombreProcesoKeyReleased

    private void jTNombreProcesoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNombreProcesoKeyTyped
        char cara = evt.getKeyChar();
        if (Character.isDigit(cara) || evt.getKeyChar() == '|') {
            evt.consume();
        }
    }//GEN-LAST:event_jTNombreProcesoKeyTyped

    private void cbAreaItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_cbAreaItemStateChanged
        if (!jTNombreProceso.getText().equals("") && cbArea.getSelectedIndex() != 0) {
            if (cbArea.getSelectedIndex() == 1) {
                btnGuardar.setEnabled(false);
                JOptionPane.showMessageDialog(null, "Los procesos de FE no se pueden modificar por el momento...", "coming soon...", JOptionPane.INFORMATION_MESSAGE);
            } else {
                btnGuardar.setEnabled(true);
            }
        } else {
            btnGuardar.setEnabled(false);
        }
    }//GEN-LAST:event_cbAreaItemStateChanged

    private void btnGuardarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGuardarActionPerformed
        //Guardar
        if (guarModificarProcesos(1)) {
            jTNombreProceso.setText("");
            cbArea.setSelectedIndex(0);
            estadoCampos(false);
            botonesinicio();
            consultarProcesos();
            tamañoColumnas(jTFE);
            tamañoColumnas(jTTE);
            tamañoColumnas(jTEN);
        }

    }//GEN-LAST:event_btnGuardarActionPerformed

    private void btnUpdateActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUpdateActionPerformed
        //Modificarf
        if (guarModificarProcesos(2)) {
            jTNombreProceso.setText("");
            cbArea.setSelectedIndex(0);
            estadoCampos(false);
            botonesinicio();
            consultarProcesos();
        }

    }//GEN-LAST:event_btnUpdateActionPerformed

    private void btnDeleteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnDeleteActionPerformed
        activarODesactivar(0);//Desactivar
        consultarProcesos();
        estadoCampos(false);
        botonesinicio();
        tamañoColumnas(jTFE);
        tamañoColumnas(jTTE);
        tamañoColumnas(jTEN);
        jTNombreProceso.setText("");
        cbArea.setSelectedIndex(0);
    }//GEN-LAST:event_btnDeleteActionPerformed

    private void btnActivarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnActivarActionPerformed
        activarODesactivar(1);//Activar
        consultarProcesos();
        estadoCampos(false);
        botonesinicio();
        tamañoColumnas(jTFE);
        tamañoColumnas(jTTE);
        tamañoColumnas(jTEN);
        jTNombreProceso.setText("");
        cbArea.setSelectedIndex(0);
    }//GEN-LAST:event_btnActivarActionPerformed

    private void btnNuevoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnNuevoActionPerformed
        estadoCampos(true);
        botonesinicio();
        jTNombreProceso.setText("");
        cbArea.setSelectedIndex(0);
    }//GEN-LAST:event_btnNuevoActionPerformed

    private void activarBotonesEliminacion(int op) {
        if (op == 1) {
            btnDelete.setEnabled(true);
            btnDelete.setVisible(true);
            btnActivar.setEnabled(false);
            btnActivar.setVisible(false);
        } else {
            btnDelete.setEnabled(false);
            btnDelete.setVisible(false);
            btnActivar.setEnabled(true);
            btnActivar.setVisible(true);
        }
    }
    private void jTFEMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTFEMousePressed
        //Falta Hacer el mejoramiento a este modulo
        seleccionarProceso(jTFE);
        btnUpdate.setEnabled(false);//True
        activarBotonesEliminacion(jTFE.getValueAt(jTFE.getSelectedRow(), 2).toString().equals("Activo") ? 1 : 0);
        estadoCampos(true);
        btnGuardar.setEnabled(false);
        //...
        //Los procesos de FE no se pueden modificar hasta realizar la proxima versión del sistema de información 
        btnDelete.setEnabled(false);
        btnActivar.setEnabled(false);
    }//GEN-LAST:event_jTFEMousePressed

    private void jTTEMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTTEMousePressed
        seleccionarProceso(jTTE);
        btnUpdate.setEnabled(true);
        activarBotonesEliminacion(jTTE.getValueAt(jTTE.getSelectedRow(), 2).toString().equals("Activo") ? 1 : 0);
        estadoCampos(true);
        btnGuardar.setEnabled(false);
    }//GEN-LAST:event_jTTEMousePressed

    private void jTENMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTENMousePressed
        seleccionarProceso(jTEN);
        btnUpdate.setEnabled(true);
        activarBotonesEliminacion(jTEN.getValueAt(jTEN.getSelectedRow(), 2).toString().equals("Activo") ? 1 : 0);
        estadoCampos(true);
        btnGuardar.setEnabled(false);
    }//GEN-LAST:event_jTENMousePressed

    private void seleccionarProceso(JTable tabla) {
        int pos = tabla.getSelectedRow();
        if (pos >= 0) {
            jLID.setText(String.valueOf(tabla.getValueAt(pos, 0)));//Identificador
            jTNombreProceso.setText(String.valueOf(tabla.getValueAt(pos, 1)));//Nombre!!
            if (tabla.getName().equals("FE")) {
                cbArea.setSelectedIndex(1);
            } else if (tabla.getName().equals("TE")) {
                cbArea.setSelectedIndex(2);
            } else {
                cbArea.setSelectedIndex(3);
            }
        }
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

    private void tamañoColumnas(JTable tabla) {
        tabla.getColumnModel().getColumn(0).setMinWidth(20);
        tabla.getColumnModel().getColumn(0).setMaxWidth(20);
        tabla.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(20);
        tabla.getTableHeader().getColumnModel().getColumn(0).setMinWidth(20);
        tabla.getColumnModel().getColumn(1).setMinWidth(200);
        tabla.getColumnModel().getColumn(1).setMaxWidth(200);
        tabla.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(200);
        tabla.getTableHeader().getColumnModel().getColumn(1).setMinWidth(200);
        tabla.getColumnModel().getColumn(2).setMinWidth(60);
        tabla.getColumnModel().getColumn(2).setMaxWidth(60);
        tabla.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(60);
        tabla.getTableHeader().getColumnModel().getColumn(2).setMinWidth(60);
    }

    private void consultarProcesos() {
        try {
            String name[] = {"ID", "Nombre", "Estado"};
            FE = new DefaultTableModel(null, name);
            TE = new DefaultTableModel(null, name);
            EN = new DefaultTableModel(null, name);
            Controlador.Procesos obj = new Controlador.Procesos();
            crs = obj.consultarProcesos(0);
            while (crs.next()) {
                v[0] = crs.getString(1);//Identificador
                v[1] = crs.getString(2);//Nombre
                v[2] = crs.getString(3).equals("true") ? "Activo" : "Inactivo";//Estado
                switch (crs.getInt(4)) {
                    //Área de procesos
                    case 1://Formato estandar
                        FE.addRow(v);
                        break;
                    case 2://Teclados
                        TE.addRow(v);
                        break;
                    case 3://Ensamble
                        EN.addRow(v);
                        break;
                }
            }
            jTFE.setModel(FE);
            jTTE.setModel(TE);
            jTEN.setModel(EN);
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error" + e);
        }
    }

    private boolean guarModificarProcesos(int op) {
        int id = 0;
        if (!jLID.getText().equals("ID")) {
            id = Integer.parseInt(jLID.getText());
        }
        boolean res = false;
        if (!jTNombreProceso.getText().equals("") && cbArea.getSelectedIndex() != 0) {
            Controlador.Procesos obj = new Controlador.Procesos();
            if (obj.guardarModificarProcesos(op, jTNombreProceso.getText(), cbArea.getSelectedIndex(), id)) {//"1" es para guardar la infomación,Nombre del proceso y area del proceso.
                //Mensaje de exito!!
                res = true;
                if (op == 1) {//Registrar
                    new rojerusan.RSNotifyAnimated("Listo!", "El Proceso fue registrado exitosamente.", 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                } else {//Modificar
                    new rojerusan.RSNotifyAnimated("Listo!", "El Proceso fue modificado exitosamente.", 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                }
            } else {
                //Menasaje de error.
                if (op == 1) {//Registrar
                    new rojerusan.RSNotifyAnimated("Error!!", "Error a la hora de registrar los porcesos.", 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                } else {//Modificar
                    new rojerusan.RSNotifyAnimated("Error!!", "Error a la hora de Modificar los porcesos.", 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                }
            }
        } else {
            //Mensaje
            new rojerusan.RSNotifyAnimated("Alerta!!", "Falta algun campo por diligenciar.", 6, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
        }
        return res;
    }


    // Variables declaration - do not modify//GEN-BEGIN:variables
    public static javax.swing.JButton btnActivar;
    public static javax.swing.JButton btnDelete;
    private javax.swing.JButton btnGuardar;
    public static javax.swing.JButton btnNuevo;
    public static javax.swing.JButton btnUpdate;
    public static elaprendiz.gui.comboBox.ComboBoxRound cbArea;
    private javax.swing.JLabel jLID;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTable jTEN;
    private javax.swing.JTable jTFE;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jTNombreProceso;
    private javax.swing.JTable jTTE;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
//Metodos---------------------------------------------------------------------------------------------->  
}
