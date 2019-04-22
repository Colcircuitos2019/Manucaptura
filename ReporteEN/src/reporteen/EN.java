package reporteen;

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
//import javax.swing.Timer;
import javax.swing.table.DefaultTableModel;

public class EN extends javax.swing.JFrame implements Runnable {

    //Variables
    Modelo modelo;
    Object row[] = null;//Proyectos
    static int soloUnaVez = 0;
    Thread innformacionProduccion = null;
    Object[] pie_pagina = null;

    public EN() {
        //...
        if (soloUnaVez == 0) {
            initComponents();
            modelo = new Modelo();
            this.setExtendedState(EN.MAXIMIZED_BOTH);// Extienete el jFrame a la totalidad del tamaño de la pantalla
            this.setIconImage(new ImageIcon(getClass().getResource("/img/EN.png")).getImage());// Favicon del jFrame
            jTReporte.getTableHeader().setReorderingAllowed(false);// Evita que los headers de la tabla se puedans desplazar...
            // ...
            estadoConexionServidor();
            consultarEstadoLectura();
            // ...
            innformacionProduccion = new Thread(this);
            innformacionProduccion.start();//Hilo de consulta de la información
            //...
            soloUnaVez = 1;
        }
    }

    private void estadoConexionServidor() {
        if (validarConexionServerSocket()) {
            Conexion conexion = new Conexion(1);
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
        CachedRowSet crs = modelo.consultarDireccionIPServerPrograma(3);// Area de ensamble - EN = 3

        try {

            while (crs.next()) {

                cliente.connect(new InetSocketAddress(crs.getString("ipServidor"), crs.getInt("puerto")), 2000);

                DataOutputStream output = new DataOutputStream(cliente.getOutputStream());
                output.writeUTF("1");

                cliente.close();
                respuesta = true;

            }

        } catch (Exception ex) {

            Logger.getLogger(EN.class.getName()).log(Level.SEVERE, null, ex);

        }

        return respuesta;
    }

    // Server socket Inicio-----------------------------------------------------
    private String direccionIP = consultarDireccionIPServer();
    private final int PUERTO = consultarPuertoComunicacionServidor(direccionIP);
    private ServerSocket servidor = null;
    private Socket cliente = null;
    // ...
    DataInputStream input;
    DataOutputStream output;
    // Server socket fin -------------------------------------------------------

    @Override
    public void run() {

//        while (true) {
        try {

            servidor = new ServerSocket(PUERTO);
            boolean respuesta = gestionDireccionServidor(direccionIP, PUERTO, 1);
            if (respuesta) {
                consultarInformacionProduccion();
            } else {
                jDMensaje mensaje_alerta = new jDMensaje(this, true);
                mensaje_alerta.setLocationRelativeTo(null);
                mensaje_alerta.setVisible(true);
            }

            while (true) {

                cliente = servidor.accept();
                if (!respuesta) {
                    respuesta = gestionDireccionServidor(direccionIP, PUERTO, 1);
                }
                // ...
                input = new DataInputStream(cliente.getInputStream());/*2*/
                String mensaje = input.readUTF();
                // ...
                System.out.println(mensaje);
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

            Logger.getLogger(EN.class.getName()).log(Level.SEVERE, null, ex);

        }
//        }

    }

    private boolean gestionDireccionServidor(String direccionIP, int puerto, int estado) {

        return modelo.gestionarDireccionServidor(direccionIP, puerto, estado);

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

    private String consultarDireccionIPServer() {

        String direccionIP = "";
        try {
            direccionIP = String.valueOf(InetAddress.getLocalHost()).split("/")[1];
        } catch (Exception e) {
            e.printStackTrace();
        }
        return direccionIP;
    }

    // Nueva forma de cargar el reporte...
    // -------------------------------------------------------------------------
    private ArrayList<Object> encabezadoTabla() {

        ArrayList<Object> encabezado = new <Object>ArrayList();
        encabezado.add("N°Orden");
        encabezado.add("Ejecución");
        encabezado.add("Cant");
        encabezado.add("Lider Proyecto");

        Modelo modelo = new Modelo();
        CachedRowSet crs = modelo.consultarProcesosM();

        try {

            while (crs.next()) {

                encabezado.add("sub_" + crs.getString("nombre_proceso"));
                encabezado.add(crs.getString("nombre_proceso"));

            }
            // ...
            encabezado.add("Terminado");
            encabezado.add("Restantes");

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
            int rep = 0, cantidad_proyectos = 0, total_cantidades = 0, cantidad_procesos = 0;
            String oldNumOrden = "", oldTipoProducto = "";
            Modelo modelo = new Modelo();
            CachedRowSet crs = modelo.consultarInformacionProduccionM();

            if (crs != null) {

                while (crs.next()) {

                    Proceso proceso = new Proceso();

                    if (rep == 0) {

                        informacion_produccion.add(new Object[]{crs.getString("proyecto_numero_orden"), crs.getString("tipo_proyecto"), crs.getString("parada")});
                        informacion_produccion.add(crs.getString("canitadad_total"));
                        total_cantidades += crs.getInt("canitadad_total");
                        informacion_produccion.add((crs.getString("lider_proyecto") == null ? "-" : modelo.consultarNombreLiderProyectoM(crs.getString("lider_proyecto"))));
                        // ...
                        proceso.setNombre(crs.getString("nombre_proceso"));
                        proceso.setEstado(crs.getInt("estado"));
                        proceso.setCantidad(crs.getString("cantidadProceso"));
                        cantidad_procesos += crs.getInt("cantidadProceso");
                        // ...
                        informacion_produccion.add(proceso);
                        // ...
                        oldNumOrden = crs.getString("proyecto_numero_orden");
                        oldTipoProducto = crs.getString("idProducto");
                        rep = 1;

                    } else {
                        // Pendiente revisar la validacion (campo de PNC)
                        if (oldNumOrden.equals(crs.getString("proyecto_numero_orden")) && oldTipoProducto.equals(crs.getString("idProducto"))) {

                            proceso.setNombre(crs.getString("nombre_proceso"));
                            proceso.setEstado(crs.getInt("estado"));
                            proceso.setCantidad(crs.getString("cantidadProceso"));
                            cantidad_procesos += crs.getInt("cantidadProceso");
                            // ...
                            informacion_produccion.add(proceso);

                        } else {

                            row = organizarRowTabla(informacion_produccion, encabezado, cantidad_procesos);

                            modelo_tabla.addRow(row);
                            cantidad_proyectos++;
                            cantidad_procesos = 0;

                            informacion_produccion.clear();

                            // ...
                            informacion_produccion.add(new Object[]{crs.getString("proyecto_numero_orden"), crs.getString("tipo_proyecto"), crs.getString("parada")});
                            informacion_produccion.add(crs.getString("canitadad_total"));
                            total_cantidades += crs.getInt("canitadad_total");
                            informacion_produccion.add((crs.getString("lider_proyecto") == null ? "-" : modelo.consultarNombreLiderProyectoM(crs.getString("lider_proyecto"))));
                            // ...
                            proceso.setNombre(crs.getString("nombre_proceso"));
                            proceso.setEstado(crs.getInt("estado"));
                            proceso.setCantidad(crs.getString("cantidadProceso"));
                            cantidad_procesos += crs.getInt("cantidadProceso");
                            // ...
                            informacion_produccion.add(proceso);
                            // ...
                            oldNumOrden = crs.getString("proyecto_numero_orden");
                            oldTipoProducto = crs.getString("idProducto");
                        }

                    }

                }

                if (rep == 1) {

                    row = organizarRowTabla(informacion_produccion, encabezado, cantidad_procesos);

                    modelo_tabla.addRow(row);
                    cantidad_proyectos++;

                    informacion_produccion.clear();

                }

                pie_pagina[0] = cantidad_proyectos;
                pie_pagina[2] = total_cantidades;
                pie_pagina[3] = "*******";
                pie_pagina[pie_pagina.length - 1] = "*******";
                pie_pagina[pie_pagina.length - 2] = "*******";
                // ...
                modelo_tabla.addRow(pie_pagina);
                // ...
                jTReporte.setModel(modelo_tabla);
                jTReporte.setDefaultRenderer(Object.class, new Tabla());
                jTReporte.getTableHeader().setFont(new Font("Arial", 1, 18));
                jTReporte.getTableHeader().setForeground(Color.BLACK);
                tamañoColumnasTabla();
                jLContadorActualizaciones.setText(String.valueOf(Integer.parseInt(jLContadorActualizaciones.getText()) + 1));

            } else {

//                jDMensaje = new jDMensaje();
                jDMensaje mensaje_alerta = new jDMensaje(this, true);
                mensaje_alerta.setLocationRelativeTo(null);
                mensaje_alerta.setVisible(true);

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

    }

    private void tamañoColumnasTabla() {

        // Tipo de ejecución
        jTReporte.getColumnModel().getColumn(1).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(1).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMinWidth(0);
        // ...

        for (int i = 4; i < jTReporte.getColumnCount() - 2; i++) {

            if (i % 2 == 0) {

                jTReporte.getColumnModel().getColumn(i).setMinWidth(0);
                jTReporte.getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMaxWidth(0);
                jTReporte.getTableHeader().getColumnModel().getColumn(i).setMinWidth(0);

            }

        }

    }

    private Object[] organizarRowTabla(ArrayList<Object> informacionRow, Object[] encabezado, int cantidadProcesos) {

        Object[] row = new Object[encabezado.length];// ((encabezado.length - 4) * 2) + 4
        Object[] infoProyecto = (Object[]) informacionRow.get(0);// 0 = numero orden, 1 = tipo proyecto, 2 = Parada
        int index = 0;
        // ...
        row[0] = infoProyecto[0];//Numero de orden
        row[1] = infoProyecto[1];//Tipo Ejecución (Normal, Quik, RQT)
        row[2] = informacionRow.get(1);//Cantidad Total
        row[3] = informacionRow.get(2);//Lider de producción
        int cantidad_terminada = 0;
        cantidad_terminada = (cantidadProcesos != 0 ? Integer.parseInt(informacionRow.get(1).toString()) - cantidadProcesos : 0);
        row[row.length - 2] = cantidad_terminada;//cantidad terminada
        row[row.length - 1] = Integer.parseInt(informacionRow.get(1).toString()) - cantidad_terminada;//cantidad restante

        // ...
        for (int i = 5; i < encabezado.length - 1; i = i + 2) {

            index = 0;

            for (int j = 3; j < informacionRow.size(); j++) {// Buscar indice del proceso (ArrayList)

                Proceso proceso = (Proceso) informacionRow.get(j);

                if (encabezado[i].toString().equals(proceso.getNombre())) {

                    index = j;

                    break;

                }

            }

            if (index > 0) {

                Proceso proceso = (Proceso) informacionRow.get(index);
                // ...
                row[i - 1] = (infoProyecto[2].toString().equals("true") ? proceso.getEstado() : 0);// Estado del proceso 0=parado
                row[i] = proceso.getCantidad();// Cantidad del proceso

                if (pie_pagina[i] == null) {

                    pie_pagina[i] = proceso.getCantidad();

                } else {

                    pie_pagina[i] = Integer.parseInt(pie_pagina[i].toString()) + Integer.parseInt(proceso.getCantidad());

                }
            }

        }

        return row;
    }

    private void refrescarEstadoReporte(){
        
        Modelo modelo = new Modelo();
        modelo.refrescarEstadoReporte(direccionIP, String.valueOf(PUERTO));
        
    }
    
    // -------------------------------------------------------------------------
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
        jButton2 = new javax.swing.JButton();
        jLEstadoLectura = new javax.swing.JLabel();
        jestadoConexionServer = new javax.swing.JLabel();
        jestadoConexionServer1 = new javax.swing.JLabel();
        jLContadorActualizaciones = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setTitle("Informe de ensamble");
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
                {}
            },
            new String [] {

            }
        ));
        jTReporte.setEnabled(false);
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

        jLConexion.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLConexion.setForeground(new java.awt.Color(0, 185, 0));
        jLConexion.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLConexion.setText("Linea");

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

        jLEstadoLectura.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLEstadoLectura.setForeground(new java.awt.Color(0, 185, 0));
        jLEstadoLectura.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLEstadoLectura.setText("Activado");

        jestadoConexionServer.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jestadoConexionServer.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jestadoConexionServer.setText("Estado DB:");

        jestadoConexionServer1.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jestadoConexionServer1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jestadoConexionServer1.setText("Estado Lectura:");

        jLContadorActualizaciones.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLContadorActualizaciones.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLContadorActualizaciones.setText("0");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(10, 10, 10)
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
                        .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(10, 10, 10))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 511, Short.MAX_VALUE)
                .addGap(11, 11, 11)
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
                    .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(6, 6, 6))
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

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        try {
            gestionDireccionServidor(String.valueOf(InetAddress.getLocalHost()).split("/")[1], PUERTO, 0);
        } catch (UnknownHostException ex) {
            Logger.getLogger(EN.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_formWindowClosing

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        consultarInformacionProduccion();
        consultarEstadoLectura();
        estadoConexionServidor();
        refrescarEstadoReporte();
    }//GEN-LAST:event_jButton2ActionPerformed

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
