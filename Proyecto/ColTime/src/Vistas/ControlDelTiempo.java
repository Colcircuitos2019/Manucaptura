package Vistas;

import Controlador.FE_TE_IN;
import coltime.Menu;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.PrintStream;
import javax.sql.rowset.CachedRowSet;
import javax.swing.Icon;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import rojerusan.RSNotifyAnimated;

public class ControlDelTiempo extends javax.swing.JFrame implements ActionListener {
//Actualizar cada cierto tiempo la vista de proyectos
    public ControlDelTiempo() {
        initComponents();
        this.setExtendedState(ControlDelTiempo.MAXIMIZED_BOTH);
        this.setIconImage(new ImageIcon(getClass().getResource("/imagenesEmpresa/favicon.png")).getImage());
//        jButton1.setVisible(false);
    }

    //Variables---------------------------------------------------------------->
    int px = 0;
    int py = 0;
    private int negocio=0;
    static int cantidad = 0, filas = 1, unidad = 14, conta = 8;
    boolean res = false;
    private ControlDelTiempo vista = null;
    CachedRowSet crs = null;
    public static int negocioFE = 0;
    public static int negocioTE = 0;
    public static int negocioIN = 0;
    Object VistaLeida = null;

    public void setNegocio(int negocio) {
        this.negocio = negocio;
    }

    public void setVista(ControlDelTiempo vista) {
        this.vista = vista;
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        contenidoFE = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new java.awt.Dimension(1456, 1456));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        jScrollPane1.setPreferredSize(new java.awt.Dimension(1094, 300));

        contenidoFE.setBackground(new java.awt.Color(255, 255, 255));
        contenidoFE.setMaximumSize(new java.awt.Dimension(40000, 40000));
        contenidoFE.setPreferredSize(new java.awt.Dimension(0, 500));

        javax.swing.GroupLayout contenidoFELayout = new javax.swing.GroupLayout(contenidoFE);
        contenidoFE.setLayout(contenidoFELayout);
        contenidoFELayout.setHorizontalGroup(
            contenidoFELayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 808, Short.MAX_VALUE)
        );
        contenidoFELayout.setVerticalGroup(
            contenidoFELayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 500, Short.MAX_VALUE)
        );

        jScrollPane1.setViewportView(contenidoFE);

        jPanel2.setBackground(new java.awt.Color(63, 179, 255));
        jPanel2.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/refresh.png"))); // NOI18N
        jButton1.setBorderPainted(false);
        jButton1.setContentAreaFilled(false);
        jButton1.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jButton1.setFocusPainted(false);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(804, Short.MAX_VALUE)
                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(19, Short.MAX_VALUE)
                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 32, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                .addContainerGap())
            .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 338, Short.MAX_VALUE)
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
            .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        if (this.contenidoFE.getComponentCount() == 0) {
            this.dispose();
            //Si la ventana es cerrada la variable de instancia es igualada a null
            if (Menu.producF == vista) {
                Menu.producF = null;
            } else if (Menu.producE == vista) {
                Menu.producE = null;
            } else if (Menu.producT == vista) {
                Menu.producT = null;
            }
        } else {
            new rojerusan.RSNotifyAnimated("¡Alerta!", "No puedes cerrar esta ventana mientras esta en ejecucion la toma de tiempos", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
            this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        }
    }//GEN-LAST:event_formWindowClosing

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        validarExitenciadeBotones(negocio, vista);//Actualizar la vista
    }//GEN-LAST:event_jButton1ActionPerformed
    //Metodos para la campura del tiempo--------------------------------------->
//    validarExitenciadeBotones(3,vista); Actualizar autimaticamente la vista, esta pendiente para una futura versión...
    //
    //Se valida que el bono no exista en el panle para no reprtirlo***  
    public void validarExitenciadeBotones(int negocio, ControlDelTiempo vista) {
        FE_TE_IN obj = new FE_TE_IN();
        //Buscamos los proyectos que estan en ejecucion.
        crs = obj.consultarProyectosEnEjecucion(negocio);
        //Se sulven a posicionar todos los botones.
        try {
            //Se vuleven a reiniciar las variables con los valores predeterminados
            px = 0;
            py = 0;
            this.cantidad = 0;
            filas = 1;
            unidad = 14;
            conta = 8;
            //Se limpa el panel para volver a organizar los botones
            vista.contenidoFE.removeAll();
            vista.contenidoFE.updateUI();
            //Se posicionan todos los botones
            while (crs.next()) {
                agregarBotones(vista, Integer.parseInt(crs.getString(1)));
            }
            crs.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
        }
    }

    public void RegistrarTomaTiempoNegocio(String datos[], int cargo, ControlDelTiempo vista, PrintStream myPS) {
        FE_TE_IN obj = new FE_TE_IN();
        this.vista = vista;
//#------------------------------------------------------------------
//Restricciones de permisos
/*FE=1 TE=2 EN=3 AL=4*/
        if (cargo == 2 && (Integer.parseInt(datos[2]) == 1 || Integer.parseInt(datos[2]) == 2)) {//Tiene permiso de leer FE y TE
            res = obj.iniciar_Pausar_Reiniciar_Toma_Tiempo(Integer.parseInt(datos[0]), Integer.parseInt(datos[1]), Integer.parseInt(datos[2]), Integer.parseInt(datos[3]), Integer.parseInt(datos[4]), Integer.parseInt(datos[5]), myPS, (datos.length==7?Integer.parseInt(datos[6]):0));
        } else if (cargo == 3 && (Integer.parseInt(datos[2]) == 3 || Integer.parseInt(datos[2]) == 2)) {//Tiene permiso de leer EN y TE
            res = obj.iniciar_Pausar_Reiniciar_Toma_Tiempo(Integer.parseInt(datos[0]), Integer.parseInt(datos[1]), Integer.parseInt(datos[2]), Integer.parseInt(datos[3]), Integer.parseInt(datos[4]), Integer.parseInt(datos[5]), myPS,(datos.length==7?Integer.parseInt(datos[6]):0));
        } else {
            new rojerusan.RSNotifyAnimated("¡Alerta!", "No tienes permiso de leer el QR", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
            if (Menu.producF == vista) {//Se valida que la vista que no se este utilizando se apunte a null y se finalice
                Menu.producF = null;
            } else if (Menu.producT == vista) {
                Menu.producT = null;
            } else if (Menu.producE == vista) {
                Menu.producE = null;
            }
            vista.dispose();
        }
//        if (res) {
            validarExitenciadeBotones(Integer.parseInt(datos[2]), vista);
            negocio=Integer.parseInt(datos[2]);
//        }
//#------------------------------------------------------------------
    }
    
    public void agregarBotones(ControlDelTiempo vista, int orden) {
        JButton obj = new JButton(String.valueOf(orden));
        obj.setActionCommand(String.valueOf(orden));
        obj.setName(String.valueOf(orden));
        obj.setFont(new Font("Tahoma", 1, 15));
        obj.setText(String.valueOf(orden));
        obj.setBounds(px, py, 100, 100);
        obj.addActionListener(this);
        obj.setHorizontalTextPosition(JButton.CENTER);
        //Icono del boton
        ImageIcon icono = new ImageIcon(getClass().getResource("/produccion/DetalleTime.png"));
        Icon imagen = new ImageIcon(icono.getImage().getScaledInstance(obj.getWidth() - 6, obj.getHeight() - 6, Image.SCALE_DEFAULT));
        obj.setIcon(imagen);
        px += 101;
        cantidad++;
        if (cantidad == unidad * filas) {
            py += 101;
            px = 0;
            filas++;
            if (cantidad == unidad * conta) {
                vista.contenidoFE.setPreferredSize(new Dimension(vista.contenidoFE.getWidth(), vista.contenidoFE.getHeight() + 496));
                conta += 8;
            }
            vista.contenidoFE.updateUI();
        }
        vista.contenidoFE.add(obj);
        vista.contenidoFE.updateUI();
    }

    @Override
    public void actionPerformed(ActionEvent e) {//Estas linean van a mostrar un jDialog pero solo los detalles del proyecto que estan en ejecución "2"
        int orden = Integer.parseInt(e.getActionCommand());
        String name = this.getName();
        int n = 0;
        switch (name) {
            case "FE":
                //------------------------------------------
                n = 1;
                break;
            case "TE":
                n = 2;
                break;
            case "IN":
                n = 3;
                break;
        }
        detalleProduccion obj = new detalleProduccion(this, true, orden, n, 3, Menu.cargo);
        obj.setLocationRelativeTo(null);
        obj.setVisible(true);
        obj.dispose();
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
            java.util.logging.Logger.getLogger(ControlDelTiempo.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(ControlDelTiempo.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(ControlDelTiempo.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);

        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(ControlDelTiempo.class
                    .getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new ControlDelTiempo().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    public javax.swing.JPanel contenidoFE;
    private javax.swing.JButton jButton1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    public static javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
