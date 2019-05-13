
package Vistas;

import javax.swing.JFrame;


public class ProduccionArea extends javax.swing.JPanel {

    private static int area;
    private static int cargo;

    public ProduccionArea() {
        initComponents();
    }

    public static void setArea(int area) {
        ProduccionArea.area = area;
    }

    public static void setCargo(int cargo) {
        ProduccionArea.cargo = cargo;
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        contenido = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTInfoAreaProduccion = new javax.swing.JTable(){

            public boolean isCellEditable(int row, int column){
                return false;
            }

        };

        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setName("FE"); // NOI18N

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setPreferredSize(new java.awt.Dimension(1094, 300));

        contenido.setBackground(new java.awt.Color(255, 255, 255));
        contenido.setMaximumSize(new java.awt.Dimension(40000, 40000));
        contenido.setName("FE"); // NOI18N
        contenido.setPreferredSize(new java.awt.Dimension(0, 500));

        jTInfoAreaProduccion.setFont(new java.awt.Font("Tahoma", 1, 13)); // NOI18N
        jTInfoAreaProduccion.setForeground(new java.awt.Color(128, 128, 131));
        jTInfoAreaProduccion.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "N° Orden", "Nombre Proyecto", "Estado", "Parada"
            }
        ));
        jTInfoAreaProduccion.setFillsViewportHeight(true);
        jTInfoAreaProduccion.setFocusTraversalPolicyProvider(true);
        jTInfoAreaProduccion.setIntercellSpacing(new java.awt.Dimension(0, 0));
        jTInfoAreaProduccion.setRequestFocusEnabled(false);
        jTInfoAreaProduccion.setRowHeight(21);
        jTInfoAreaProduccion.setRowMargin(0);
        jTInfoAreaProduccion.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTInfoAreaProduccion.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTInfoAreaProduccion.setShowVerticalLines(false);
        jTInfoAreaProduccion.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTInfoAreaProduccionMouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(jTInfoAreaProduccion);

        javax.swing.GroupLayout contenidoLayout = new javax.swing.GroupLayout(contenido);
        contenido.setLayout(contenidoLayout);
        contenidoLayout.setHorizontalGroup(
            contenidoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(contenidoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 1084, Short.MAX_VALUE)
                .addContainerGap())
        );
        contenidoLayout.setVerticalGroup(
            contenidoLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(contenidoLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 507, Short.MAX_VALUE)
                .addContainerGap())
        );

        jScrollPane1.setViewportView(contenido);
        contenido.getAccessibleContext().setAccessibleParent(contenido);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 1106, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 531, Short.MAX_VALUE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jTInfoAreaProduccionMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTInfoAreaProduccionMouseClicked
        if(!evt.isPopupTrigger() && evt.getClickCount() == 2){
            // Consultar detalles del proyecto
            int orden = Integer.parseInt(jTInfoAreaProduccion.getValueAt(jTInfoAreaProduccion.getSelectedRow(), 0).toString());
            // ...
            detalleProduccion obj = new detalleProduccion(null, true, orden, area, 1, cargo);
            // ...
            obj.setLocationRelativeTo(null);
            obj.setVisible(true);
            obj.dispose();
            
        }
    }//GEN-LAST:event_jTInfoAreaProduccionMouseClicked


    // Variables declaration - do not modify//GEN-BEGIN:variables
    public static javax.swing.JPanel contenido;
    public static javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    public static javax.swing.JTable jTInfoAreaProduccion;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
