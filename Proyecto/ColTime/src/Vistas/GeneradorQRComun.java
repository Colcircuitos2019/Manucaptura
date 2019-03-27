package Vistas;

import Controlador.DetalleProyecto;
import Controlador.FormatoTabla;
import Controlador.rutaQR;
import static Vistas.proyecto.jTNorden;
import coltime.Menu;
import com.barcodelib.barcode.QRCode;
import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.awt.Font;
import java.io.File;
import java.io.FileOutputStream;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import rojerusan.RSNotifyAnimated;

public class GeneradorQRComun extends javax.swing.JPanel {

    public GeneradorQRComun() {
        initComponents();
        jTDetalleProductosSeleccionados.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        consultarProductosDetalleProyecto("");
    }
    //Variables
    String inicio = "";
    String finali = "";
    CachedRowSet crs = null;//Cantidad de proyectos para cada área respectiva
    String encabezadosTBProductos[] = {"N° Orden", "idDetalle", "Área", "Producto", "Cantidad", "Estado", "Material", "PNC", "C.Antisolder", "Ruteo", "Espesor"};//Detalle del proyecto
    int udm = 0, resol = 100, rot = 0;
    float mi = 0.000f, md = 0.000f, ms = 0.000f, min = 0.000f, tam = 21.000f;
    //Metodos de la calse inicio
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTDetalleProductosSeleccionados = new javax.swing.JTable(){

            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }

        };
        jPanel4 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTDetalleProductos = new javax.swing.JTable(){
            public boolean isCellEditable(int rowIndex, int colIndex) {
                return false; //Disallow the editing of any cell
            }
        };
        jTNumerOrden = new elaprendiz.gui.textField.TextFieldRoundBackground();
        jLabel4 = new javax.swing.JLabel();
        btnGenerarQRComun = new javax.swing.JButton();
        btnEliminarProductoSeleccionado = new javax.swing.JButton();

        setBackground(new java.awt.Color(219, 219, 219));
        setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        setName("QRsComun"); // NOI18N

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder(javax.swing.BorderFactory.createEtchedBorder(), "Generador de QRs Comunes", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 18), new java.awt.Color(128, 128, 131))); // NOI18N

        jPanel3.setBackground(new java.awt.Color(255, 255, 255));
        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Productos seleccionados", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 12), new java.awt.Color(128, 128, 131))); // NOI18N

        jTDetalleProductosSeleccionados.setAutoCreateRowSorter(true);
        jTDetalleProductosSeleccionados.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jTDetalleProductosSeleccionados.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "N°Orden", "Área", "Producto", "Cantidad", "Material", "C.Antisolder", "Ruteo", "Espesor"
            }
        ));
        jTDetalleProductosSeleccionados.setFillsViewportHeight(true);
        jTDetalleProductosSeleccionados.setFocusTraversalPolicyProvider(true);
        jTDetalleProductosSeleccionados.setFocusable(false);
        jTDetalleProductosSeleccionados.setName("Detalle"); // NOI18N
        jTDetalleProductosSeleccionados.setRowHeight(18);
        jTDetalleProductosSeleccionados.setRowMargin(1);
        jTDetalleProductosSeleccionados.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTDetalleProductosSeleccionados.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTDetalleProductosSeleccionados.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jTDetalleProductosSeleccionadosMouseReleased(evt);
            }
        });
        jScrollPane3.setViewportView(jTDetalleProductosSeleccionados);

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 718, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 124, Short.MAX_VALUE)
                .addContainerGap())
        );

        jPanel4.setBackground(new java.awt.Color(255, 255, 255));
        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Productos", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Tahoma", 1, 12), new java.awt.Color(128, 128, 131))); // NOI18N

        jTDetalleProductos.setAutoCreateRowSorter(true);
        jTDetalleProductos.setFont(new java.awt.Font("Tahoma", 0, 12)); // NOI18N
        jTDetalleProductos.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "N°orden", "idDetalle", "Área", "Producto", "Cantidad", "Estado", "Material", "PNC", "Color Antisolder", "Ruteo", "Espesor"
            }
        ));
        jTDetalleProductos.setFillsViewportHeight(true);
        jTDetalleProductos.setFocusTraversalPolicyProvider(true);
        jTDetalleProductos.setFocusable(false);
        jTDetalleProductos.setName("Detalle"); // NOI18N
        jTDetalleProductos.setRowHeight(18);
        jTDetalleProductos.setRowMargin(1);
        jTDetalleProductos.setSelectionBackground(new java.awt.Color(63, 179, 255));
        jTDetalleProductos.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTDetalleProductos.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTDetalleProductosMouseClicked(evt);
            }
        });
        jScrollPane5.setViewportView(jTDetalleProductos);

        jTNumerOrden.setColorDeBorde(new java.awt.Color(204, 204, 204));
        jTNumerOrden.setColorDeTextoBackground(new java.awt.Color(255, 255, 255));
        jTNumerOrden.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                jTNumerOrdenKeyPressed(evt);
            }
            public void keyReleased(java.awt.event.KeyEvent evt) {
                jTNumerOrdenKeyReleased(evt);
            }
        });

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 12)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(128, 128, 131));
        jLabel4.setText(" Orden °N:");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 787, Short.MAX_VALUE)
                .addContainerGap())
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(19, 19, 19)
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTNumerOrden, javax.swing.GroupLayout.PREFERRED_SIZE, 90, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(8, 8, 8)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTNumerOrden, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 205, Short.MAX_VALUE)
                .addContainerGap())
        );

        btnGenerarQRComun.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/QRcode.png"))); // NOI18N
        btnGenerarQRComun.setBorderPainted(false);
        btnGenerarQRComun.setContentAreaFilled(false);
        btnGenerarQRComun.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnGenerarQRComun.setEnabled(false);
        btnGenerarQRComun.setFocusPainted(false);
        btnGenerarQRComun.setFocusable(false);
        btnGenerarQRComun.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/QRcode1.png"))); // NOI18N
        btnGenerarQRComun.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGenerarQRComunActionPerformed(evt);
            }
        });

        btnEliminarProductoSeleccionado.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minusBlue.png"))); // NOI18N
        btnEliminarProductoSeleccionado.setBorderPainted(false);
        btnEliminarProductoSeleccionado.setContentAreaFilled(false);
        btnEliminarProductoSeleccionado.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnEliminarProductoSeleccionado.setEnabled(false);
        btnEliminarProductoSeleccionado.setFocusPainted(false);
        btnEliminarProductoSeleccionado.setFocusable(false);
        btnEliminarProductoSeleccionado.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minusRed.png"))); // NOI18N
        btnEliminarProductoSeleccionado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnEliminarProductoSeleccionadoActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(btnGenerarQRComun, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(btnEliminarProductoSeleccionado, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(17, 17, 17))
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup()
                    .addGap(20, 20, 20)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addContainerGap()))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addGap(313, 313, 313)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(btnGenerarQRComun)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(btnEliminarProductoSeleccionado, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(jPanel2Layout.createSequentialGroup()
                    .addGap(21, 21, 21)
                    .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(189, Short.MAX_VALUE)))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
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

    private void jTDetalleProductosSeleccionadosMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTDetalleProductosSeleccionadosMouseReleased
        if(!evt.isPopupTrigger()){
            
            if(jTDetalleProductosSeleccionados.getSelectedRow()>-1){
                
                btnEliminarProductoSeleccionado.setEnabled(true);
                
            }else{
                
                btnEliminarProductoSeleccionado.setEnabled(false);
                
            }
                    
        }
    }//GEN-LAST:event_jTDetalleProductosSeleccionadosMouseReleased

    private void jTNumerOrdenKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNumerOrdenKeyReleased
        
//        if(Character.isDigit(evt.getKeyChar())){
            consultarProductosDetalleProyecto(jTNumerOrden.getText());
//        }
        
    }//GEN-LAST:event_jTNumerOrdenKeyReleased

    private void btnGenerarQRComunActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGenerarQRComunActionPerformed
        generarQRdeProduccion();
    }//GEN-LAST:event_btnGenerarQRComunActionPerformed

    private void btnEliminarProductoSeleccionadoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnEliminarProductoSeleccionadoActionPerformed
        DefaultTableModel modelo_tabla = clasesColumnas();
        // ...
        Object registro[] = new Object[11];
        int rowSeleted = jTDetalleProductosSeleccionados.getSelectedRow();
        
        for (int row = 0; row < jTDetalleProductosSeleccionados.getRowCount(); row++) {
            
            if(rowSeleted != row){
                
                modelo_tabla.addRow(informacionFilaSeleccionada(jTDetalleProductosSeleccionados, registro, row)); 
             
            }
            
        }
        // ...
        jTDetalleProductosSeleccionados.setModel(modelo_tabla);
        personalizacionJTable(jTDetalleProductosSeleccionados);
        jTDetalleProductosSeleccionados.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
        validarEstadoBtnGenerarQRComun();
        btnEliminarProductoSeleccionado.setEnabled(false);
        
    }//GEN-LAST:event_btnEliminarProductoSeleccionadoActionPerformed

    private void jTNumerOrdenKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTNumerOrdenKeyPressed
        if(Character.isLetter(evt.getKeyChar())){
            evt.consume();
        }
    }//GEN-LAST:event_jTNumerOrdenKeyPressed

    private void jTDetalleProductosMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTDetalleProductosMouseClicked
        
        if(!evt.isPopupTrigger()){
            if(evt.getClickCount() == 2){
               
                DefaultTableModel modelo_tabla = clasesColumnas();// Pendiente agregarle las clases para determinar el tipo de dato de cada columna
                Object registro[] = new Object[11];
                // ...
                if(jTDetalleProductosSeleccionados.getRowCount() == 0){
                //Ingresa el registro sin validar
                   int row = jTDetalleProductos.getSelectedRow();
                   // ...
                   modelo_tabla.addRow(informacionFilaSeleccionada(jTDetalleProductos, registro, row));
                   // ...
                   jTDetalleProductosSeleccionados.setModel(modelo_tabla);
                   personalizacionJTable(jTDetalleProductosSeleccionados);
                   jTDetalleProductosSeleccionados.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
                   // ...
                   validarEstadoBtnGenerarQRComun();
                }else{
                    //Validacion 1= Validar que el producto seleecionado no este replicado en la otra tabla step 1
                    int rowSelected = jTDetalleProductos.getSelectedRow();
                    String idDetalleProducto = jTDetalleProductos.getValueAt(rowSelected, 1).toString();
                    Boolean validacion1=true, validacion2=true;
                    for (int row = 0; row < jTDetalleProductosSeleccionados.getRowCount(); row++) {
                        if(jTDetalleProductosSeleccionados.getValueAt(row, 1).toString().equals(idDetalleProducto)){
                            validacion1=false;
                            break;
                        }
                    }
                    //Validacion 2= Validar que los registros seleccionados sean del mismo tipo... <Pendiente> step 2
                    if(jTDetalleProductosSeleccionados.getRowCount() > 0){
                        String producto="", material="",cAntisolder="", espesor="", cantidad="";
                        // ...
                        //Preguntarle a doña Viviana Si la cantidad puede ser igual o diferente de los productos...
                        producto = jTDetalleProductosSeleccionados.getValueAt(0, 3).toString();
                        cantidad = jTDetalleProductosSeleccionados.getValueAt(0, 4).toString();
                        material = (jTDetalleProductosSeleccionados.getValueAt(0, 6)==null?"":jTDetalleProductosSeleccionados.getValueAt(0, 6).toString());
                        cAntisolder = (jTDetalleProductosSeleccionados.getValueAt(0, 8)==null?"":jTDetalleProductosSeleccionados.getValueAt(0, 8).toString());
                        espesor = (jTDetalleProductosSeleccionados.getValueAt(0, 10)==null?"":jTDetalleProductosSeleccionados.getValueAt(0, 10).toString());
                        // ...
                        if(!(producto.equals(jTDetalleProductos.getValueAt(rowSelected, 3).toString()) &&
                                cantidad.equals(jTDetalleProductos.getValueAt(rowSelected, 4).toString()) &&
                           material.equals((jTDetalleProductos.getValueAt(rowSelected, 6)==null?"":jTDetalleProductos.getValueAt(rowSelected, 6).toString())) &&
                           cAntisolder.equals((jTDetalleProductos.getValueAt(rowSelected, 8)==null?"":jTDetalleProductos.getValueAt(rowSelected, 8).toString())) &&
                           espesor.equals(jTDetalleProductos.getValueAt(rowSelected, 10)==null?"":jTDetalleProductos.getValueAt(rowSelected, 10).toString()))){
                            
                            validacion2=false;
                            
                        }
                        // ...
                    }
                    // ...
                    if(validacion1 && validacion2){
                        for (int row = 0; row < jTDetalleProductosSeleccionados.getRowCount(); row++) {

                            modelo_tabla.addRow(informacionFilaSeleccionada(jTDetalleProductosSeleccionados, registro, row));

                        }
                        // ...
                        modelo_tabla.addRow(informacionFilaSeleccionada(jTDetalleProductos, registro, rowSelected));
                        // ...
                        jTDetalleProductosSeleccionados.setModel(modelo_tabla);
                        personalizacionJTable(jTDetalleProductosSeleccionados);
                        jTDetalleProductosSeleccionados.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12)); 
                    }
                    
                }
            }
        }
    }//GEN-LAST:event_jTDetalleProductosMouseClicked
    
    // Mis metodos de la clase
    private Object[] informacionFilaSeleccionada(JTable tabla,Object registro[], int row){
        
        registro[0] = tabla.getValueAt(row,0);// Numero de orden
        registro[1] = tabla.getValueAt(row,1); // ID Detalle del producto
        registro[2] = tabla.getValueAt(row,2); // Área
        registro[3] = tabla.getValueAt(row,3); // Producto
        registro[4] = tabla.getValueAt(row,4); // Cantidad
        registro[5] = tabla.getValueAt(row,5); // Estado
        registro[6] = tabla.getValueAt(row,6); // Material
        registro[7] = tabla.getValueAt(row,7); // PNC
        registro[8] = tabla.getValueAt(row,8); // Color antisolder
        registro[9] = tabla.getValueAt(row,9); // Ruteo
        registro[10] = tabla.getValueAt(row,10); // Espesor
        
        return registro;
    }
    
    private DefaultTableModel clasesColumnas(){
        return  new DefaultTableModel(null, encabezadosTBProductos){
            
            Class[] type = new Class[]{
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Object.class,
                java.lang.Boolean.class,
                java.lang.Object.class
            };
            
            public Class getColumnClass(int indexColumn){
                return type[indexColumn];
            }
        };
    }
    
    private void consultarProductosDetalleProyecto(String numer_Orden) {
        DetalleProyecto obj = new DetalleProyecto();
        try {
            crs = obj.consultar_Detalle_Proyecto(numer_Orden);
            DefaultTableModel productos = clasesColumnas();
            Object registro[] = new Object[11];
            //...
            while (crs.next()) {
                
                if(!Boolean.valueOf(crs.getString("PNC")) && crs.getInt("estado")==1 && crs.getString("nom_area").equals("FE")){
                
                    //Detalles del proyecto o productos...
                    registro[0] = crs.getString("numero_orden");//Numero de orden
                    registro[1] = crs.getString("idDetalle_proyecto");//idDetalle del proyecto
                    registro[2] = crs.getString("nom_area");// Área de produccion
                    registro[3] = crs.getString("nombre");// Nombre producto
                    registro[4] = crs.getString("canitadad_total");//Cantidad
                    if (!crs.getString("parada").equals("1")) {
                        registro[5] = clasificarEstado(crs.getInt("estado"));//Estado de ejecucion
                    } else {
                        registro[5] = "Parada";//Estado parado
                    }
                    registro[6] = crs.getString("material");//Material
                    registro[7] = crs.getString("PNC");// PNC (Aplica o no aplica como Producto no conforme)
                    registro[8] = crs.getString("color_antisodler");// 
                    registro[9] = crs.getBoolean("Ruteo");// 
                    registro[10] = crs.getString("espesor");// 
                    // ...
                    productos.addRow(registro);
                    // ...
                }
            }
            crs.close();
            jTDetalleProductos.setModel(productos);
            personalizacionJTable(jTDetalleProductos);
            jTDetalleProductos.getTableHeader().setFont(new Font("Arial", Font.BOLD, 12));
            //...
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void personalizacionJTable(JTable tabla){
        tamañoColumnasTabla(tabla,
                            new Objeto_tabla[]{new Objeto_tabla(1, 0),
                                               new Objeto_tabla(5, 0),
                                               new Objeto_tabla(7, 0)});
        FormatoTabla formato = new FormatoTabla(5);
        tabla.setDefaultRenderer(Object.class, formato);
    }
    
    private void validarEstadoBtnGenerarQRComun(){
        if(jTDetalleProductosSeleccionados.getRowCount()>0){
            btnGenerarQRComun.setEnabled(true);
        }else{
            btnGenerarQRComun.setEnabled(false);
        }
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
    
    private void tamañoColumnasTabla(JTable tabla, Objeto_tabla[] columnas) {
        // ...
        for (Objeto_tabla columna : columnas) {
            tabla.getColumnModel().getColumn(columna.indexColumn).setMinWidth(columna.width);
            tabla.getColumnModel().getColumn(columna.indexColumn).setMaxWidth(columna.width);
            tabla.getTableHeader().getColumnModel().getColumn(columna.indexColumn).setMaxWidth(columna.width);
            tabla.getTableHeader().getColumnModel().getColumn(columna.indexColumn).setMinWidth(columna.width);
        }
        // ...
    }
    
    private void generarQRdeProduccion() {
        //Se puede Cambiar la libreria con la cual se generar las QR (Fijarse en el programa generador de QR)
        try {
            int cont = 0;
            //Consultar Ruta de guardado de los QR
            rutaQR ruta = new rutaQR();
            ruta.consultarRutaQR(Menu.jDocumento.getText());
            String path = ruta.getRutaQR();
            //...
            if (path != null) {
                //...
                if (path.codePointAt(path.length() - 1) == 92) {//92= Código ASCII de \
                    //...
                    File folder = new File(path + "ImágenesQR");//Nombre de la carpeta
                    if (!folder.exists()) {
                        folder.mkdirs();
                    }
                    //Tamaño de la fuente del PDF
                    com.itextpdf.text.Font tall = new com.itextpdf.text.Font();
                    tall.setSize(7);
                    //Encabezado del PDF
                    PdfPCell header = new PdfPCell();
                    header.setBorder(Rectangle.NO_BORDER);
                    header.setColspan(4);
                    //se creo y se abrio el documento        L   R   T   B
                    Document doc = new Document(PageSize.A4, 20, 150, 30, 170);

                    // Trama para el QR comun, el caracter en comun por el cual van a ser separados es un @
                    String trama="";
                    String name_PDF="";
                    
                    for (int row = 0; row < jTDetalleProductosSeleccionados.getRowCount(); row++) {
                        trama += jTDetalleProductosSeleccionados.getValueAt(row,0).toString()+";"+// Numero de Orden
                                 jTDetalleProductosSeleccionados.getValueAt(row,1).toString()+";"+// ID Producto
                                 clasificarIndiceArea(jTDetalleProductosSeleccionados.getValueAt(row,2).toString())+"@";// Área
                        
                        name_PDF+=jTDetalleProductosSeleccionados.getValueAt(row,0).toString()+"_";// Nombre del PDF
                    }
                    //...
                    trama = trama.substring(0,trama.length()-1);
                    trama += "_";
                    name_PDF = name_PDF.substring(0,name_PDF.length()-1);
                    
                    //se obtine la ruta del proyecto en tiempo de ejecucion.
                    PdfWriter pdf = PdfWriter.getInstance(doc, new FileOutputStream(path + name_PDF + ".pdf"));// Cambiar El nombre de documento
                    doc.open();
                    
                    //Crear tabla de codigos QR
                    PdfPTable tabla = new PdfPTable(4);
                    tabla.addCell(header);
                    tabla.setWidthPercentage(100);
                    tabla.setWidths(new float[]{3, 3, 3, 3});
                    //Creo la cadena de texto que contendra el QR
                    QRCode cod = new QRCode();//Libreria para los QR
                    
                    cod.setData(trama);
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
                    cod.renderBarcode(path + "ImágenesQR\\" + name_PDF + ".png");
//                              ...
                    Image imagenQR = Image.getInstance(path + "ImágenesQR\\" + name_PDF + ".png");
                    // ...
                    imagenQR.setWidthPercentage(60);//Tamaño del QR con el cual va a ser insertado en el documento PDF
                    imagenQR.setAlignment(Image.ALIGN_CENTER);//Alineamiento de lo Codigos en las celdas
                    //Personalizar cell
                    PdfPCell celda = new PdfPCell();
                    //celda.setBorder(Rectangle.NO_BORDER);
                    //Numero de orden del proyecto
                    Paragraph orden = new Paragraph("Ordenes: " + name_PDF, tall);
                    orden.setAlignment(1);
                    celda.addElement(orden);
                    // Referencia de área y producto
                    Paragraph tipo = new Paragraph();
                    tipo.setSpacingAfter(8);
                    celda.addElement(tipo);
                    // Imagen de QR
                    celda.addElement(imagenQR);
                    // Tipo de Material
                    Paragraph Fecha = new Paragraph("Material: " + (jTDetalleProductosSeleccionados.getValueAt(0,6)==null?"": jTDetalleProductosSeleccionados.getValueAt(0,6).toString()), tall);
                    Fecha.setAlignment(1);
                    celda.addElement(Fecha);
                    // Nombre del proyecto
                    Paragraph proyecto = new Paragraph("Espesor: " + (jTDetalleProductosSeleccionados.getValueAt(0,10)==null?"": jTDetalleProductosSeleccionados.getValueAt(0,10).toString()), tall);
                    proyecto.setAlignment(1);
                    celda.addElement(proyecto);
                    // Cantidad Total de equipos
                    Paragraph cantidad = new Paragraph("Cantidad: " + jTDetalleProductosSeleccionados.getValueAt(0,4).toString(), tall);
                    cantidad.setAlignment(1);
                    celda.addElement(cantidad);
                    // ...
                    for (int i = 0; i < 4; i++) {
                        tabla.addCell(celda);
                    }
                    // Elimina las imagenes del QR 
                    // El nombre de la imagen se puede hacer para que lo retorne una funcion para que sea una manera más optima de hacerlo
                    File QRdelet = new File(path + "ImágenesQR\\" + name_PDF + ".png");
                    QRdelet.delete();
                    //...
                    cont++;
                    header.setBorder(Rectangle.NO_BORDER);
                    header.addElement(new Paragraph());
                    header.setColspan(4);
                    tabla.addCell(header);
                    doc.add(tabla);
                    
                    tabla = null;    
                    //Agregar una nueva hoja de PDF
                    doc.newPage();
                    doc.close();
                    //...
                    if (cont == 0) {
                        File PDF = new File(path + name_PDF + ".pdf");
                        PDF.delete();
                    } else {
                        new rojerusan.RSNotifyAnimated("¡Listo!", "El QR en común de las ordenes: "+ name_PDF + "fue generado correctamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                        System.gc();//Garbages collector.
                        jTDetalleProductosSeleccionados.setModel(clasesColumnas());
                        personalizacionJTable(jTDetalleProductosSeleccionados);
                        btnGenerarQRComun.setEnabled(false);
                    }
                    //...
                } else {
                    //... Mensaje de error
                    new rojerusan.RSNotifyAnimated("¡ERROR!", "La ruta de destino no esta bien especificada.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                }
            } else {
                //...
                new rojerusan.RSNotifyAnimated("¡Alerta!", "No tiene una ruta de destino especificada.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
            }
            //...
//            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }
    
    private String clasificarIndiceArea(String area){
        
        switch(area){
            case "FE":
                area="1";
                break;
            case "TE":
                area="2";
                break;
            case "EN":
                area="3";
                break;
        }
        
        return area;
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    public static javax.swing.JButton btnEliminarProductoSeleccionado;
    public static javax.swing.JButton btnGenerarQRComun;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane5;
    private static javax.swing.JTable jTDetalleProductos;
    private static javax.swing.JTable jTDetalleProductosSeleccionados;
    private elaprendiz.gui.textField.TextFieldRoundBackground jTNumerOrden;
    // End of variables declaration//GEN-END:variables
 @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
