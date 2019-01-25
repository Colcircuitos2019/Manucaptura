package reporteen;

import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
//import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
//import javax.swing.JOptionPane;
//reporteen.MyRenderEN()

public class EN extends javax.swing.JFrame implements Runnable {

    public EN() {
        //...
        if (soloUnaVez == 0) {
            initComponents();
            this.setExtendedState(EN.MAXIMIZED_BOTH);
            this.setTitle("Informe de Ensamble");
            this.setIconImage(new ImageIcon(getClass().getResource("/img/EN.png")).getImage());
            jTReporte.getTableHeader().setReorderingAllowed(false);
            hilo = new Thread(this);
            hilo.start();//Hilo de consulta de la información
            //...
            DisponibilidadConexion conexion = new DisponibilidadConexion();
            Thread conec = new Thread(conexion);
            conec.start();//Hilo de validación de linea al servidor.
        }
        soloUnaVez = 1;
    }
//Variables
    CachedRowSet crs = null;
    String names[] = null;
    static String namesBeta[] = null, nombreProcesos[] = null;
    String beta = "N°Orden;Cant;Lider de proyecto", betaNames = "";
    Modelo obj = new Modelo();
    Object row[];//Proyectos
    int cantTerminada=0;
    static int posProceso = 0, rep = 0, canColumnas = 0, soloUnaVez = 0;
    Thread hilo = null;
//Variables staticas
    public static String IP = "192.168.4.1:3306";
    public static String user = "juanDavidM";
    public static String pass = "123";
    //Metodos
    @Override
    public void run() {
        try {
            while (true) {
                consultarProcesosEncabezados();
                jPanel1.updateUI();
                System.gc();//Garbaje collector
                Thread.sleep(500);//5 segundos
            }
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void consultarProcesosEncabezados() {
        try {
            String nuevaCadena = "";
            betaNames="";
            int count = 0;
            crs = obj.consultarProcesosM(3);//Ensamble=3
            while (crs.next()) {
                betaNames += count == 0 ? crs.getString(2) : ";" + crs.getString(2);//Columna numero 2
                count = 1;
            }
            namesBeta = betaNames.split(";");
            for (int i = 0; i < namesBeta.length; i++) {
                nuevaCadena += ";sub_" + namesBeta[i] + ";" + namesBeta[i];
            }
            //Columnas de cantidad total terminada
            nuevaCadena+=";relleno;Terminados;relleno;Restantes";
            //...
            names = (beta + nuevaCadena).split(";");//Encabezado de las columnas
            //...
            //Modelo de la tabla con encabezados
            DefaultTableModel df = new DefaultTableModel(null, names);
            //...
            canColumnas = names.length;
            //...
            nuevaCadena = "";
            consultarInformacionEnsamble(df);//Cuerpo del modelo...
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    private void consultarInformacionEnsamble(DefaultTableModel df) {
        try {
            int totalProyectos = 0, cantidadTotatlUnidades = 0;
            row = null;
            crs = obj.consultarInformacionEnsambleM();
            row = new Object[names.length];
            inicializarVector();//Vector en estado inicial
            while (crs.next()) {
                if (rep == 0) {
                    row[0] = crs.getString(1);//Numero de orden
                    row[1] = crs.getString(2);//Cant
//                  row[2] = crs.getString(6);//Tipo de proyecto Esto ya no existe
                    row[2] = (crs.getString(7)==null?"-":consultarNombreEmpleadoLider(crs.getString(7)));//producto
                    cantidadTotatlUnidades += crs.getInt(2);
                    //...
//                    agregarNoperariosProceso();
                      estadoProcesos();
                    rep = 1;
                } else {
                    if (row[0].toString().equals(crs.getString(1))) {
                        //...
//                        agregarNoperariosProceso();
                          estadoProcesos();
                    } else {
                        //Cancular la cantidad total terminada
                        row[names.length-3]=cantTerminada!=0?(Integer.parseInt(String.valueOf(row[1]))-cantTerminada):0;
                        //Cantidad restante del proyecto
                        row[names.length - 1] = Integer.parseInt(String.valueOf(row[1]))- Integer.parseInt(String.valueOf(row[names.length-3]));
                        cantTerminada=0;
                        //Añade la fila al modelo de la tabla...
                        df.addRow(row);
                        totalProyectos++;
                        inicializarVector();//Vector en estado inicial
                        //...
                        row[0] = crs.getString(1);//Numero de orden
                        row[1] = crs.getString(2);//Cant
//                        row[2] = crs.getString(6);//Tipo de proyecto
                        row[2] = (crs.getString(7)==null?"-":consultarNombreEmpleadoLider(crs.getString(7)));//Lider de proyecto
                        cantidadTotatlUnidades += crs.getInt(2);
                        //...
//                        agregarNoperariosProceso();
                          estadoProcesos();
                    }
                }
            }
            if (rep == 1) {
                //Calcular la cantidad terminada total del proyecto
                row[names.length-3]=cantTerminada!=0?(Integer.parseInt(String.valueOf(row[1]))-cantTerminada):0;
                //Cantidad restante del proyecto
                row[names.length-1]=Integer.parseInt(String.valueOf(row[1]))-cantTerminada;
                cantTerminada = 0;
                //Agregar la fila al modelo de la tabla...
                df.addRow(row);
                totalProyectos++;
                rep = 0;
            }
            vaciarVector();
            row[0] = totalProyectos;
            row[1] = cantidadTotatlUnidades;
            df.addRow(row);
            jTReporte.setModel(df);
            jTReporte.setDefaultRenderer(Object.class, new Tabla());
            ColumnasAOcultar();
            row = null;
            namesBeta = null;
            nombreProcesos = null;
            betaNames = "";
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }
    
    private void estadoProcesos(){//Calcular la cantidad pasada queda pendiente
        try {
            int pos=consultarPosicionProceso(crs.getString(3));// Posiciòn del proceso
            row[pos - 1] = crs.getString(5);//Estado de proceso
            row[pos] = crs.getString(9);//Cantidades terminadas del proceso
            cantTerminada+=crs.getInt(9);
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null,e);
        }
    }

    private void inicializarVector() {
        for (int i = 0; i < row.length; i++) {
            row[i] = 0;
        }
    }

    private void vaciarVector() {
        for (int i = 0; i < row.length; i++) {
            row[i] = "*******";
        }
    }

    private int consultarPosicionProceso(String nombreProceso) {
        for (int i = 2; i <= names.length-1; i++) {
            if (names[i].equals(nombreProceso)) {
                posProceso = i;
                break;
            }
        }
        return posProceso;
    }
    
    private String consultarNombreEmpleadoLider(String doc){
        String name="";
        try {
            Modelo obj=new Modelo();
            name= obj.consultarNombreLiderProyectoM(doc);
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null,e);
        }
        return name;
    }

    private void ColumnasAOcultar() {
        for (int i = 3; i <= (namesBeta.length*2)+5; i++) {
            if (i % 2 == 1) {
                jTReporte.getColumnModel().getColumn(i).setMinWidth(0);
                jTReporte.getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMinWidth(0);
            }
        }
        //...
        //Numero de orden del proyecto...
        jTReporte.getColumnModel().getColumn(0).setMinWidth(100);
        jTReporte.getColumnModel().getColumn(0).setMaxWidth(100);
        jTReporte.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(100);
        jTReporte.getTableHeader().getColumnModel().getColumn(0).setMinWidth(100);
        //Nombre del lider de proyecto
        jTReporte.getColumnModel().getColumn(2).setMinWidth(300);
        jTReporte.getColumnModel().getColumn(2).setMaxWidth(300);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(300);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMinWidth(300);
//...
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTReporte = new reporteen.MyRenderEN();
        jTtipo2 = new javax.swing.JLabel();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jTtipo7 = new javax.swing.JLabel();
        jTtipo8 = new javax.swing.JLabel();
        jTtipo9 = new javax.swing.JLabel();
        jLConexion = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jPanel1.setBackground(new java.awt.Color(204, 220, 226));

        jTReporte.setAutoCreateRowSorter(true);
        jTReporte.setFont(new java.awt.Font("Tahoma", 1, 16)); // NOI18N
        jTReporte.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {}
            },
            new String [] {

            }
        ));
        jTReporte.setFocusable(false);
        jTReporte.setGridColor(new java.awt.Color(153, 153, 153));
        jTReporte.setIntercellSpacing(new java.awt.Dimension(0, 1));
        jTReporte.setRowHeight(40);
        jTReporte.setSelectionBackground(new java.awt.Color(120, 187, 253));
        jTReporte.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTReporte.setShowVerticalLines(false);
        jScrollPane1.setViewportView(jTReporte);

        jTtipo2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo2.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (5).png"))); // NOI18N
        jTtipo2.setText("Por iniciar");

        jTtipo3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo3.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (3).png"))); // NOI18N
        jTtipo3.setText("Terminado");

        jTtipo4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo4.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (2).png"))); // NOI18N
        jTtipo4.setText("Pausado");

        jTtipo5.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo5.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo5.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (1).png"))); // NOI18N
        jTtipo5.setText("Ejecución");

        jTtipo7.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo7.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (6).png"))); // NOI18N
        jTtipo7.setText("RQT");

        jTtipo8.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo8.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo8.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (7).png"))); // NOI18N
        jTtipo8.setText("Quick");

        jTtipo9.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo9.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo9.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (5).png"))); // NOI18N
        jTtipo9.setText("Normal");

        jLConexion.setFont(new java.awt.Font("Arial", 1, 18)); // NOI18N
        jLConexion.setForeground(new java.awt.Color(0, 185, 0));
        jLConexion.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLConexion.setText("Linea");

        jButton1.setText("Conexion");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 1262, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTtipo9, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo8, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo7, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLConexion, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(154, 154, 154)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 479, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLConexion, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton1))
                    .addComponent(jTtipo7, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTtipo8, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo9, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        IP = JOptionPane.showInputDialog(this, "Cual es la dirección del servidor", IP);
        user = JOptionPane.showInputDialog(this, "Cual el usuario del servidor", user);
        pass = JOptionPane.showInputDialog(this, "Cual es la contraseña del usuario", pass);
    }//GEN-LAST:event_jButton1ActionPerformed

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
            java.util.logging.Logger.getLogger(EN.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(EN.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(EN.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(EN.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new EN().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    public static javax.swing.JLabel jLConexion;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTReporte;
    private javax.swing.JLabel jTtipo2;
    private javax.swing.JLabel jTtipo3;
    private javax.swing.JLabel jTtipo4;
    private javax.swing.JLabel jTtipo5;
    private javax.swing.JLabel jTtipo7;
    private javax.swing.JLabel jTtipo8;
    private javax.swing.JLabel jTtipo9;
    // End of variables declaration//GEN-END:variables

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
