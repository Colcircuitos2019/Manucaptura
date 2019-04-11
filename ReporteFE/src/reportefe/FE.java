/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reportefe;

import java.awt.Color;
import java.awt.Font;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author acomercial05
 */
public class FE extends javax.swing.JFrame implements Runnable {

    /**
     * Creates new form FE
     */
    //Variables
    CachedRowSet crs = null;
    static int soloUnaVez = 0;
    private String direccionIP = null;
    private int puerto = 0;
    private ServerSocket servidor = null;
    private Socket cliente = null;
    private Object[] pie_pagina =null; 
    // ...
    DataInputStream input;
    DataOutputStream output;
    
    public FE() {
        
        if (soloUnaVez == 0) {
            initComponents();
            this.setTitle("Informe de Formato Estandar");
            this.setIconImage(new ImageIcon(getClass().getResource("/img/FE.png")).getImage());
            this.setExtendedState(FE.MAXIMIZED_BOTH);
            //Hilo de ejecución
            Thread informe = new Thread(this);//Hilo
            informe.start();
            //...
            jTReporte.getTableHeader().setReorderingAllowed(false);
            //...
            estadoConexionServidor();
            consultarEstadoLectura();
        }
        // ...
        soloUnaVez = 1;
    }

// Nueva forma de cargar el reporte
// -----------------------------------------------------------------------------

    private ArrayList<Object> encabezadoTabla() {

        ArrayList<Object> encabezado = new <Object>ArrayList();
        encabezado.add("N°Orden");
        encabezado.add("Ejecución");
        encabezado.add("M.T");
        encabezado.add("Cant");
        encabezado.add("Tipo producto");

        Modelo modelo = new Modelo();
        CachedRowSet crs = modelo.consultarProceso();

        try {

            while (crs.next()) {

                encabezado.add("sub_"+crs.getString("nombre_proceso"));
                encabezado.add(crs.getString("nombre_proceso"));

            }
            encabezado.add("PNC");
            
            pie_pagina = null;
            pie_pagina = new Object[encabezado.size()];

        } catch (Exception e) {

            e.printStackTrace();

            return new <Object>ArrayList();

        }

        return encabezado;
    }

    private void consultarInformacionProduccion() {

        try {

            Object encabezado[] = encabezadoTabla().toArray();
            ArrayList<Object> informacion_produccion = new <Object>ArrayList();
            Object[] row = null;
            DefaultTableModel modelo_tabla = new DefaultTableModel(null, encabezado);
            int rep = 0, cantidad_proyectos = 0, total_cantidades = 0;
            String oldNumOrden = "", oldTipoProducto = "", oldPNC = "";
            Modelo modelo = new Modelo();
            CachedRowSet crs = modelo.consultarInformacionProduccion();

            while (crs.next()) {

                Proceso proceso = new Proceso();

                if (rep == 0) {

                    informacion_produccion.add(new Object[]{crs.getString("proyecto_numero_orden"), crs.getString("tipo_proyecto"), crs.getString("ubicacion"), crs.getString("parada")});
                    informacion_produccion.add(crs.getString("material"));
                    informacion_produccion.add(crs.getString("canitadad_total"));
                    total_cantidades+=crs.getInt("canitadad_total");
                    informacion_produccion.add(crs.getString("nombre"));// nombre del producto
                    // ...
                    proceso.setNombre(crs.getString("nombreProceso"));
                    proceso.setEstado(crs.getInt("estado"));
                    proceso.setCantidad(crs.getString("cantidadProceso"));
                    // ...
                    informacion_produccion.add(proceso);
                    // ...
                    oldNumOrden = crs.getString("proyecto_numero_orden");
                    oldTipoProducto = crs.getString("nombre");
                    oldPNC = crs.getString("ubicacion");
                    rep = 1;

                } else {
                    // Pendiente revisar la validacion (campo de PNC)
                    if (oldNumOrden.equals(crs.getString("proyecto_numero_orden")) && oldTipoProducto.equals(crs.getString("nombre")) && (oldPNC == null ? (oldPNC == crs.getString("ubicacion")) : (oldPNC.equals(crs.getString("ubicacion"))))) {

                        proceso.setNombre(crs.getString("nombreProceso"));
                        proceso.setEstado(crs.getInt("estado"));
                        proceso.setCantidad(crs.getString("cantidadProceso"));
                        // ...
                        informacion_produccion.add(proceso);

                    } else {

                        row = organizarRowTabla(informacion_produccion, encabezado);

                        modelo_tabla.addRow(row);
                        cantidad_proyectos++;

                        informacion_produccion.clear();

                        // ...
                        informacion_produccion.add(new Object[]{crs.getString("proyecto_numero_orden"), crs.getString("tipo_proyecto"), crs.getString("ubicacion"), crs.getString("parada")});
                        informacion_produccion.add(crs.getString("material"));
                        informacion_produccion.add(crs.getString("canitadad_total"));
                        total_cantidades += crs.getInt("canitadad_total");
                        informacion_produccion.add(crs.getString("nombre"));// nombre del producto
                        // ...
                        proceso.setNombre(crs.getString("nombreProceso"));
                        proceso.setEstado(crs.getInt("estado"));
                        proceso.setCantidad(crs.getString("cantidadProceso"));
                        // ...
                        informacion_produccion.add(proceso);
                        // ...
                        oldNumOrden = crs.getString("proyecto_numero_orden");
                        oldTipoProducto = crs.getString("nombre");
                        oldPNC = crs.getString("ubicacion");
                    }

                }

            }

            if (rep == 1) {

                row = organizarRowTabla(informacion_produccion, encabezado);

                modelo_tabla.addRow(row);
                cantidad_proyectos++;

                informacion_produccion.clear();

            }

            pie_pagina[0] = cantidad_proyectos;
            pie_pagina[2] = "-------";
            pie_pagina[3] = total_cantidades;
            pie_pagina[4] = "-------";
            pie_pagina[pie_pagina.length-1] = "-------";
            modelo_tabla.addRow(pie_pagina);
            // ...
            jTReporte.setModel(modelo_tabla);
            jTReporte.setDefaultRenderer(Object.class, new Tabla());
            jTReporte.getTableHeader().setFont(new Font("Arial", 1, 18));
            jTReporte.getTableHeader().setForeground(Color.BLACK);
            tamañoColumnasTabla();
//            jTReporte.updateUI();
            jLContadorActualizaciones.setText(String.valueOf(Integer.parseInt(jLContadorActualizaciones.getText()) + 1));

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

    private Object[] organizarRowTabla(ArrayList<Object> informacionRow, Object[] encabezado) {

        Object[] row = new Object[encabezado.length];// ((encabezado.length - 4) * 2) + 4
        Object[] infoProyecto = (Object[]) informacionRow.get(0);// 0 = numero orden, 1 = tipo proyecto, 2 = Ubicacion, 3 = Parada
        int index = 0;
        // ...
        row[0] = infoProyecto[0];//Numero de orden
        row[1] = infoProyecto[1];//Tipo Ejecución (Normal, Quik, RQT)
        row[2] = informacionRow.get(1);//Material
        row[3] = informacionRow.get(2);//Cantidad Total
        row[4] = informacionRow.get(3);//Tipo de producto
        row[informacionRow.size() - 1] = infoProyecto[2];// Ubicacion del PNC
        // ...
        for (int i = 6; i < encabezado.length - 1; i=i+2) {

            index = 0;

            for (int j = 4; j < informacionRow.size(); j++) {// Buscar indice del proceso (ArrayList)

                Proceso proceso = (Proceso) informacionRow.get(j);

                if (encabezado[i].toString().equals(proceso.getNombre())) {

                    index = j;

                    break;

                }

            }

            if (index > 0) {

                Proceso proceso = (Proceso) informacionRow.get(index);
                // ...
                row[i-1] = (infoProyecto[3].toString().equals("true") ? proceso.getEstado() : 0);// Estado del proceso
                row[i] = proceso.getCantidad();// Cantidad del proceso
                
                if(pie_pagina[i] == null){
                    
                    pie_pagina[i] = proceso.getCantidad();
                    
                }else{
                    
                    pie_pagina[i] = Integer.parseInt(pie_pagina[i].toString()) + Integer.parseInt(proceso.getCantidad());
                    
                }
                
            }else{
                
                row[i - 1] = "-1";// Estado del proceso
                row[i] = "0";// Cantidad del proceso
                
            }

        }

        return row;
    }

    private void tamañoColumnasTabla(){
        
        // Tipo de ejecución
        jTReporte.getColumnModel().getColumn(1).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(1).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMinWidth(0); 
        // ...
        
        for (int i = 5; i < jTReporte.getColumnCount()-1; i++) {
            
            if(i % 2 == 1){
                jTReporte.getColumnModel().getColumn(i).setMinWidth(0);
                jTReporte.getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMinWidth(0);
            }
            
        }
        
    }
    
    private void estadoConexionServidor() {
        if (validarConexionServerSocket()) {
            Conexion conexion = new Conexion();
            conexion.establecerConexion();
            if (conexion.getConexion() != null) {
                jLConexion.setText("Linea");
                jLConexion.setForeground(new Color(0, 185, 0));
            } else {
                jLConexion.setText("Sin conexión");
                jLConexion.setForeground(Color.RED);
            }
            conexion.destruir();
        } else {
            jLConexion.setText("Sin conexión");
            jLConexion.setForeground(Color.RED);
        }
    }

    private void consultarEstadoLectura() {
        if (validarConexionServerSocket()) {
            Modelo modelo = new Modelo();
            if (modelo.consultarEstadoLecturaPuertoSerial()) {
                jLEstadoLectura.setText("Activado");
                jLEstadoLectura.setForeground(new Color(0, 185, 0));
            } else {
                jLEstadoLectura.setText("Desactivado");
                jLEstadoLectura.setForeground(Color.RED);
            }
        } else {
            jLEstadoLectura.setText("Desactivado");
            jLEstadoLectura.setForeground(Color.RED);
        }
    }

    private boolean validarConexionServerSocket() {

        Socket cliente = new Socket();
        Modelo modelo = new Modelo();
        boolean respuesta = false;
        CachedRowSet crs = modelo.consultarDireccionIPServerPrograma(0);// Area de ensamble - FE y TE

        try {

            while (crs.next()) {

                cliente.connect(new InetSocketAddress(crs.getString("ipServidor"), crs.getInt("puerto")), 2000);

                DataOutputStream output = new DataOutputStream(cliente.getOutputStream());
                output.writeUTF("1");

                cliente.close();
                respuesta = true;

            }

        } catch (Exception ex) {

            Logger.getLogger(FE.class.getName()).log(Level.SEVERE, null, ex);

        }

        return respuesta;
    }
    
    @Override
    public void run() {

        direccionIP = consultarDireccionIPServer();
        puerto = consultarPuertoComunicacionServidor(direccionIP);
         
        while (true) {
            try {

                servidor = new ServerSocket(puerto);

                if (gestionDireccionServidor(direccionIP, puerto, 1)) {
                    consultarInformacionProduccion();
                }

                while (true) {

//                    System.out.println(consultarDireccionIPServer()+":"+PUERTO);
                    cliente = servidor.accept();
                    // ...
                    input = new DataInputStream(cliente.getInputStream());/*2*/
                    String mensaje = input.readUTF();
                    // ...
                    switch (mensaje) {
                        case "true":// Actualizar info reporte
                            //Se genero alguna modificacion que afecta algun producto o se agregaron nuevas OP
                            consultarInformacionProduccion();
                            jPanel1.updateUI();
                            System.gc();//Garbaje collector
                            break;
                        case "1":// Existe conexion con el servidor: Linea.
                        case "2":// No existe conexion con el servidor: Sin conexión.
                            // La conexion con el servidor se modifico (Actualiza el estado de conezion DB)
                            if (mensaje.equals("1")) {
                                jLConexion.setText("Linea");
                                jLConexion.setForeground(new Color(0, 185, 0));// verde
                            } else {
                                jLConexion.setText("Sin conexión");
                                jLConexion.setForeground(Color.RED);
                            }
                            break;
                        case "act":// El estado de lectura esta activado.
                        case "des":// El estado de lectura esta desactivado
                            if (mensaje.equals("act")) {
                                jLEstadoLectura.setText("Activado");
                                jLEstadoLectura.setForeground(new Color(0, 185, 0));// verde
                            } else {
                                jLEstadoLectura.setText("Desactivado");
                                jLEstadoLectura.setForeground(Color.RED);
                            }
                            break;
                    }

                }

            } catch (IOException ex) {

                Logger.getLogger(FE.class.getName()).log(Level.SEVERE, null, ex);

            }
        }

    }
    
    private String consultarDireccionIPServer() {

        String direccionIP = "";
        try {
            direccionIP = String.valueOf(InetAddress.getLocalHost()).split("/")[1];
        } catch (Exception e) {
            e.printStackTrace();
        }
        return direccionIP;
    }
    
    private int consultarPuertoComunicacionServidor(String direccionIP) {
        Modelo modelo = new Modelo();
        int puerto = modelo.consultarPuertoComunicacionservidorM(direccionIP);
        if (puerto != 0) {
            return puerto;
        } else {
            return (int) (Math.random() * 1000) + 5000;
        }

    }
    
    private boolean gestionDireccionServidor(String direccionIP, int puerto, int estado) {

        Modelo modelo = new Modelo();    
        return modelo.gestionarDireccionServidor(direccionIP, puerto, estado);

    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTReporte = new reportefe.MyRender();
        jTtipo9 = new javax.swing.JLabel();
        jTtipo8 = new javax.swing.JLabel();
        jTtipo7 = new javax.swing.JLabel();
        jestadoConexionServer = new javax.swing.JLabel();
        jLConexion = new javax.swing.JLabel();
        jestadoConexionServer1 = new javax.swing.JLabel();
        jLEstadoLectura = new javax.swing.JLabel();
        jLContadorActualizaciones = new javax.swing.JLabel();
        jButton2 = new javax.swing.JButton();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jTtipo2 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });

        jPanel1.setBackground(new java.awt.Color(204, 220, 226));

        jTReporte.setAutoCreateRowSorter(true);
        jTReporte.setFont(new java.awt.Font("Tahoma", 1, 16)); // NOI18N
        jTReporte.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "N°Orden", "Tipo", "tipo_Proyecto", "C.T", "TipoNegocio", "sub_p", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_CTH", "C.C.TH", "sub_QUE", "Quemado", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas", "PNC"
            }
        ) {
            Class[] types = new Class [] {
                java.lang.Integer.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.String.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Integer.class, java.lang.Object.class
            };

            public Class getColumnClass(int columnIndex) {
                return types [columnIndex];
            }
        });
        jTReporte.setEnabled(false);
        jTReporte.setFocusable(false);
        jTReporte.setGridColor(new java.awt.Color(153, 153, 153));
        jTReporte.setIntercellSpacing(new java.awt.Dimension(0, 1));
        jTReporte.setRowHeight(40);
        jTReporte.setSelectionBackground(new java.awt.Color(120, 187, 253));
        jTReporte.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jTReporte.setShowVerticalLines(false);
        jScrollPane1.setViewportView(jTReporte);

        jTtipo9.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo9.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo9.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo9.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (5).png"))); // NOI18N
        jTtipo9.setText("Normal");

        jTtipo8.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo8.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo8.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo8.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (7).png"))); // NOI18N
        jTtipo8.setText("Quick");

        jTtipo7.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo7.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo7.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (6).png"))); // NOI18N
        jTtipo7.setText("RQT");

        jestadoConexionServer.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jestadoConexionServer.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jestadoConexionServer.setText("Estado DB:");

        jLConexion.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLConexion.setForeground(new java.awt.Color(0, 185, 0));
        jLConexion.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLConexion.setText("Linea");

        jestadoConexionServer1.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jestadoConexionServer1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jestadoConexionServer1.setText("Estado Lectura:");

        jLEstadoLectura.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLEstadoLectura.setForeground(new java.awt.Color(0, 185, 0));
        jLEstadoLectura.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLEstadoLectura.setText("Activado");

        jLContadorActualizaciones.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLContadorActualizaciones.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLContadorActualizaciones.setText("0");

        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update.png"))); // NOI18N
        jButton2.setBorderPainted(false);
        jButton2.setContentAreaFilled(false);
        jButton2.setFocusPainted(false);
        jButton2.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/update1.png"))); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

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

        jTtipo2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo2.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (5).png"))); // NOI18N
        jTtipo2.setText("Por iniciar");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTtipo9, javax.swing.GroupLayout.PREFERRED_SIZE, 81, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(6, 6, 6)
                        .addComponent(jTtipo8, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(6, 6, 6)
                        .addComponent(jTtipo7, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jestadoConexionServer, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLConexion, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(2, 2, 2)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGap(4, 4, 4)
                                .addComponent(jestadoConexionServer1, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLEstadoLectura, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(6, 6, 6)
                        .addComponent(jLContadorActualizaciones, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(10, 10, 10)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(6, 6, 6)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(6, 6, 6)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(6, 6, 6)
                        .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 456, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTtipo9, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo8, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo7, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jestadoConexionServer)
                        .addGap(0, 0, 0)
                        .addComponent(jLConexion, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jestadoConexionServer1)
                        .addGap(0, 0, 0)
                        .addComponent(jLEstadoLectura, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLContadorActualizaciones, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))
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

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        consultarInformacionProduccion();
        consultarEstadoLectura();
        estadoConexionServidor();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        try {
            gestionDireccionServidor(String.valueOf(InetAddress.getLocalHost()).split("/")[1], puerto, 0);
        } catch (UnknownHostException ex) {
            Logger.getLogger(FE.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_formWindowClosing

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
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(FE.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new FE().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton2;
    public static javax.swing.JLabel jLConexion;
    private javax.swing.JLabel jLContadorActualizaciones;
    public static javax.swing.JLabel jLEstadoLectura;
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
    public static javax.swing.JLabel jestadoConexionServer;
    public static javax.swing.JLabel jestadoConexionServer1;
    // End of variables declaration//GEN-END:variables

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}

class Proceso {

    public Proceso() {
    }

    private String nombre;
    private int estado;
    private String cantidad;

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
    
}
