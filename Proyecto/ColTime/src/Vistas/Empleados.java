/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Vistas;

import Controlador.Empleado;
import coltime.Menu;
import java.awt.Font;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author sis.informacion01
 */
public class Empleados extends javax.swing.JDialog {

    /**
     * Creates new form Empleados
     */
    public Empleados(java.awt.Frame parent, boolean modal) {
        super(parent, modal);
        initComponents();
        consultarEmpleadosOperarios("","");
    }
    //Variables...
    CachedRowSet crs;
    
    private void consultarEmpleadosOperarios(String doc, String name){
        Empleado obj=new Empleado();
        crs= obj.consultarEmpleado(doc,name);
        //
        try {
            String v[]={"Numero Documento","Nombre Empleado"};//Header de la tabla
            DefaultTableModel dft=new DefaultTableModel(null,v);
            //...
            while(crs.next()){
               v[0]=crs.getString(1);//Documento
               v[1]=crs.getString(2).substring(0,1).toUpperCase()+crs.getString(2).substring(1)+" "+
                    (!crs.getString(3).equals("")?crs.getString(3).substring(0,1).toUpperCase()+crs.getString(3).substring(1):"")+" "+
                    crs.getString(4).substring(0,1).toUpperCase()+crs.getString(4).substring(1)+" "+
                    (!crs.getString(5).equals("")?crs.getString(5).substring(0,1).toUpperCase()+crs.getString(5).substring(1):"");//Nombres y apellidos
               dft.addRow(v);
            }
            jTblEmpleado.setModel(dft);
            jTblEmpleado.getTableHeader().setFont(new Font("Arial",1,16));
            sizeColumnas();
            //...
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }
    }
    
    private void sizeColumnas(){
        //Numnero de documento
        jTblEmpleado.getColumnModel().getColumn(0).setMinWidth(150);
        jTblEmpleado.getColumnModel().getColumn(0).setMaxWidth(150);
        jTblEmpleado.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(150);
        jTblEmpleado.getTableHeader().getColumnModel().getColumn(0).setMinWidth(150);
        //Nombre del empleado
        jTblEmpleado.getColumnModel().getColumn(1).setMinWidth(580);
        jTblEmpleado.getColumnModel().getColumn(1).setMaxWidth(580);
        jTblEmpleado.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(580);
        jTblEmpleado.getTableHeader().getColumnModel().getColumn(1).setMinWidth(580);
    }
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTblEmpleado = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jPanel2 = new javax.swing.JPanel();
        jLiderProyectoDocumento = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        jLiderProyectoName = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel5 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jTblEmpleado.setFont(new java.awt.Font("Arial", 0, 14)); // NOI18N
        jTblEmpleado.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Numero Documento", "Nombre"
            }
        ));
        jTblEmpleado.setFocusable(false);
        jTblEmpleado.setGridColor(new java.awt.Color(255, 255, 255));
        jTblEmpleado.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTblEmpleado.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTblEmpleado.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTblEmpleadoMousePressed(evt);
            }
        });
        jScrollPane1.setViewportView(jTblEmpleado);

        jPanel2.setBackground(new java.awt.Color(60, 141, 188));

        jLiderProyectoDocumento.setBorder(null);
        jLiderProyectoDocumento.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        jLiderProyectoDocumento.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jLiderProyectoDocumento.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jLiderProyectoDocumento.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLiderProyectoDocumento.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jLiderProyectoDocumentoKeyPressed(evt);
            }
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jLiderProyectoDocumentoKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jLiderProyectoDocumentoKeyTyped(evt);
            }
        });

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setText("Numero de documento:");

        jLiderProyectoName.setBorder(null);
        jLiderProyectoName.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        jLiderProyectoName.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jLiderProyectoName.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jLiderProyectoName.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLiderProyectoName.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jLiderProyectoNameKeyReleased(evt);
            }
        });

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel5.setText("Nombre empleado:");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLiderProyectoDocumento, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, 178, Short.MAX_VALUE))
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 178, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLiderProyectoName, javax.swing.GroupLayout.PREFERRED_SIZE, 252, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLiderProyectoName, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLiderProyectoDocumento, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 696, Short.MAX_VALUE)
                .addContainerGap())
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 261, Short.MAX_VALUE)
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jLiderProyectoDocumentoKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jLiderProyectoDocumentoKeyReleased
        if (!jLiderProyectoDocumento.getText().equals("") || !jLiderProyectoName.getText().equals("")) {
            consultarEmpleadosOperarios(jLiderProyectoDocumento.getText(),jLiderProyectoName.getText());
        }else{
            consultarEmpleadosOperarios("","");
        }
    }//GEN-LAST:event_jLiderProyectoDocumentoKeyReleased

    private void jLiderProyectoDocumentoKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jLiderProyectoDocumentoKeyPressed
        
    }//GEN-LAST:event_jLiderProyectoDocumentoKeyPressed

    private void jLiderProyectoDocumentoKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jLiderProyectoDocumentoKeyTyped
        char v= evt.getKeyChar();
        if (Character.isLetter(v)) {
            evt.consume();
        }
    }//GEN-LAST:event_jLiderProyectoDocumentoKeyTyped

    private void jTblEmpleadoMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTblEmpleadoMousePressed
        //Se encarga de enviar la informacion a la vista de detalles.
        if (jTblEmpleado.getSelectedRow() >= 0) {//Valda que si este parado sobre una fila valida de la tabla.
            if(evt.getClickCount()==2){//Valida la cantidad de click que se dieron en la tabla.
                detalleProyecto detalleProducto= new detalleProyecto();
                //Actualizar lider de produccion
                Empleado empleado= new Empleado();
                empleado.actualizarLiderProyecto(detalleProducto.idDetalleProducto,String.valueOf(jTblEmpleado.getValueAt(jTblEmpleado.getSelectedRow(), 0)));//ID detalle del proyecto y numero de documento del lider del proyecto
                detalleProducto.jLiderProyecto.setText("  "+String.valueOf(jTblEmpleado.getValueAt(jTblEmpleado.getSelectedRow(),1)));//Nombre del lider del proyecto
                // ...
                Menu menu = new Menu();
                menu.comunicacionServerSocket(3, "true");
                // ...
                this.dispose();
            }
        }
    }//GEN-LAST:event_jTblEmpleadoMousePressed

    private void jLiderProyectoNameKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jLiderProyectoNameKeyReleased
        if (!jLiderProyectoDocumento.getText().equals("") || !jLiderProyectoName.getText().equals("")) {
            consultarEmpleadosOperarios(jLiderProyectoDocumento.getText(), jLiderProyectoName.getText());
        } else {
            consultarEmpleadosOperarios("", "");
        }
    }//GEN-LAST:event_jLiderProyectoNameKeyReleased

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
            java.util.logging.Logger.getLogger(Empleados.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Empleados.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Empleados.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Empleados.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the dialog */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                Empleados dialog = new Empleados(new javax.swing.JFrame(), true);
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

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jLiderProyectoDocumento;
    public static elaprendiz.gui.textField.TextFieldRoundBackground jLiderProyectoName;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTblEmpleado;
    // End of variables declaration//GEN-END:variables
}
