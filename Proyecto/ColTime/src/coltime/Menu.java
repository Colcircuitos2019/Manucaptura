package coltime;

import Controlador.ConexionPS;
import Controlador.DisponibilidadConexion;
import Controlador.FE_TE_IN;
import Controlador.HiloLectura;
import Controlador.Proyecto;
import Controlador.Usuario;
import Controlador.rutaQR;
import Controlador.socketCliente;
import Controlador.socketServidor;
import Vistas.CambiarContraseña;
import Vistas.ClausulasPrivacidad;
import Vistas.ControlDelTiempo;
import Vistas.DetallesAreaInfo;
import Vistas.GeneradorQRComun;
import Vistas.Producciones;
import Vistas.Inicio;
import Vistas.Procesos_Condicion;
import Vistas.Usuarios1;
import Vistas.proyecto;
import Vistas.proyecto1;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.PrintStream;
import java.util.ArrayList;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ButtonGroup;
import javax.swing.ButtonModel;
import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JRadioButtonMenuItem;
import paneles.CambiaPanel;
import rojerusan.RSNotifyAnimated;

public class Menu extends javax.swing.JFrame implements ActionListener {

    //
    public static Color cor = new Color(189, 189, 189);//girs
    public static Color corF = new Color(219, 219, 219);//Gris
    public static Color verde = new Color(4, 231, 4);//Verde
    public static Color rojo = new Color(255, 0, 0);//Rojo
    //
    public static Producciones bp = null;
    public static boolean estadoLecturaPuertoCOM = false, estadoConexionDB = true;
    static int soloUnaVez = 0;
    private ConexionPS CPS = null;
    DetallesAreaInfo informacion = null;
    public static String puertoSerialActual = "COM6";//Por defecto va a ser el Puerto COM6
    proyecto pro = null;
    rutaQR controlador = null;
    public static ArrayList<Object> serversSocketsReportes = null;// Todos los reportes abiertos en las diferentes áreas de producción.
    private int posX = 0, posY = 0;
    public static int cargo = 0;
    public static ControlDelTiempo producF = null, producT = null, producE = null;
    int px = 0, cantidad = 0, unidad = 13, py = 0, filas = 1, cont = 0;
    CachedRowSet crs = null;
    public static CambiarContraseña viewCambiarContraseña = null;
    public static PrintStream myPS;
    ButtonGroup grupoCom = null;
    public static String IP = "192.168.5.222:3306", user = "root", pass = "qblrENqllNIMvqHL";
    socketServidor server = null;
    public Menu(int cargo, String nombre, String doc) {
        initComponents();
        this.cargo = cargo;
//        consultarImagenUsuario(doc);// Pendiente por implementar...
        Animacion.Animacion.mover_derecha(935, 1135, 0, 2, jPanel3);
        new CambiaPanel(jPContenido, new Inicio(cargo));
        btnInicio.setColorHover(cor);
        btnInicio.setColorNormal(cor);
        btnInicio.setColorPressed(cor);
        this.setIconImage(new ImageIcon(getClass().getResource("/imagenesEmpresa/favicon.png")).getImage());
        this.setLocationRelativeTo(null);
        funcionalidadesUsuario(cargo, nombre);
        consultarPtoyectosTomaDeTiempoAbierta();
        InformacionAreasProduccion();
        
        if(cargo == 4 || cargo == 6){// El administrador o el gestor comercial
        
            socketCliente clienteSocket = new socketCliente(new int[]{0});// Consultar todos los servers socket de los reportes de producción
            serversSocketsReportes = clienteSocket.consultarServerSockets();
            
        }
        
        puertoSerialActual = ConsultarPuertoGurdadoUsuario(doc);
        estadoConexionDB = true;
        jLConexion.setText("-");
        DisponibilidadConexion dispo = new DisponibilidadConexion(this);// Hilo ejecucion 1
        Thread conexion = new Thread(dispo);
        conexion.setName("Disponibilidad Conexion DB");
        conexion.start();
        
        soloUnaVez = 1;// Validar que el hilo de estado de lectura solo sea ejecutado una vez cuando se inica la aplicacion
        if (cargo == 2 || cargo == 3) { // Encargado de FE o TE y Encargado de EN
            
            if (soloUnaVez == 1) {
                
                estadoLecturaPuertoCOM = true;
                
                HiloLectura lectura = new HiloLectura(this);// Hilo ejecucion 3
                Thread tomaTiempo = new Thread(lectura);
                tomaTiempo.setName("Luctura puerto serial");
                tomaTiempo.start();
                // ...
                server = new socketServidor(cargo); // Hilo ejecucion 2
                Thread serverSocket = new Thread(server);
                serverSocket.setName("Server Socket");
                serverSocket.start();
                
            }
            
        }
        
        //Mensaje de bienvenida-------------------------------------------------
        new rojerusan.RSNotifyAnimated("Bienvenido", nombre, 4, RSNotifyAnimated.PositionNotify.BottomLeft, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);

    }

    //Constructor.
    public Menu() {}

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jInternalFrame1 = new javax.swing.JInternalFrame();
        jPopupMenu1 = new javax.swing.JPopupMenu();
        jMenuItem3 = new javax.swing.JMenuItem();
        estadoLectura = new javax.swing.ButtonGroup();
        jPanel1 = new javax.swing.JPanel();
        jPSuperior = new javax.swing.JPanel();
        btnMenu = new javax.swing.JButton();
        jDocumento = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();
        jBMinimizar = new javax.swing.JButton();
        jLConexion = new javax.swing.JLabel();
        btnClausulasPrivacidad = new javax.swing.JButton();
        jPMenu = new javax.swing.JPanel();
        jLabel14 = new javax.swing.JLabel();
        jLEstadoLectura = new javax.swing.JLabel();
        jPanel4 = new javax.swing.JPanel();
        rSUsuario = new rojerusan.RSFotoCircle();
        btnProyectos = new rsbuttom.RSButtonMetro();
        btnInicio = new rsbuttom.RSButtonMetro();
        btnProduccion = new rsbuttom.RSButtonMetro();
        btnUsuarios = new rsbuttom.RSButtonMetro();
        btnProcesos = new rsbuttom.RSButtonMetro();
        btnGeneradorQR = new rsbuttom.RSButtonMetro();
        jPContenido = new javax.swing.JPanel();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        jPanel6 = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        FIngresadosHoy = new javax.swing.JLabel();
        FTerminadosHoy = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        FEjecucion = new javax.swing.JLabel();
        FPorIniciar = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jPanel7 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        TIngresadosHoy = new javax.swing.JLabel();
        TTerminadosHoy = new javax.swing.JLabel();
        TEjecucion = new javax.swing.JLabel();
        jLabel22 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        TPorIniciar = new javax.swing.JLabel();
        jPanel8 = new javax.swing.JPanel();
        jLabel7 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        EIngresadosHoy = new javax.swing.JLabel();
        ETerminadosHoy = new javax.swing.JLabel();
        EEjecucion = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jLabel29 = new javax.swing.JLabel();
        EPorIniciar = new javax.swing.JLabel();
        jPanel10 = new javax.swing.JPanel();
        jLabel18 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        AIngresadosHoy = new javax.swing.JLabel();
        ATerminadosHoy = new javax.swing.JLabel();
        Ajecucion = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jMenu3 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();
        jMLectura = new javax.swing.JMenu();
        jRLActivado = new javax.swing.JRadioButtonMenuItem();
        jRLDesactivado = new javax.swing.JRadioButtonMenuItem();
        jMenu5 = new javax.swing.JMenu();
        jMenuItem4 = new javax.swing.JMenuItem();
        rutaQR = new javax.swing.JMenuItem();
        jSeparator1 = new javax.swing.JPopupMenu.Separator();
        jMenu2 = new javax.swing.JMenu();
        jMenuItem2 = new javax.swing.JMenuItem();

        jInternalFrame1.setVisible(true);

        javax.swing.GroupLayout jInternalFrame1Layout = new javax.swing.GroupLayout(jInternalFrame1.getContentPane());
        jInternalFrame1.getContentPane().setLayout(jInternalFrame1Layout);
        jInternalFrame1Layout.setHorizontalGroup(
            jInternalFrame1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 308, Short.MAX_VALUE)
        );
        jInternalFrame1Layout.setVerticalGroup(
            jInternalFrame1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 56, Short.MAX_VALUE)
        );

        jMenuItem3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/retro.png"))); // NOI18N
        jMenuItem3.setText("Actualizar");
        jMenuItem3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem3ActionPerformed(evt);
            }
        });
        jPopupMenu1.add(jMenuItem3);

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        setMinimumSize(new java.awt.Dimension(1140, 700));
        setUndecorated(true);
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosing(java.awt.event.WindowEvent evt) {
                formWindowClosing(evt);
            }
        });
        getContentPane().setLayout(new java.awt.CardLayout());

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));
        jPanel1.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(138, 138, 138), 2));
        jPanel1.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jPSuperior.setBackground(new java.awt.Color(60, 141, 188));
        jPSuperior.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jPSuperior.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                jPSuperiorMouseDragged(evt);
            }
        });
        jPSuperior.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jPSuperiorMousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jPSuperiorMouseReleased(evt);
            }
        });

        btnMenu.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/menu.png"))); // NOI18N
        btnMenu.setBorderPainted(false);
        btnMenu.setContentAreaFilled(false);
        btnMenu.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnMenu.setFocusPainted(false);
        btnMenu.setRequestFocusEnabled(false);
        btnMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnMenuActionPerformed(evt);
            }
        });

        jDocumento.setText("jLabel1");

        jPanel9.setBackground(new java.awt.Color(60, 141, 188));
        jPanel9.setLayout(null);

        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close.png"))); // NOI18N
        jButton1.setBorderPainted(false);
        jButton1.setContentAreaFilled(false);
        jButton1.setFocusPainted(false);
        jButton1.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close1.png"))); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });
        jPanel9.add(jButton1);
        jButton1.setBounds(77, 0, 23, 24);

        jBMinimizar.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus1.png"))); // NOI18N
        jBMinimizar.setBorderPainted(false);
        jBMinimizar.setContentAreaFilled(false);
        jBMinimizar.setFocusPainted(false);
        jBMinimizar.setRolloverIcon(new javax.swing.ImageIcon(getClass().getResource("/img/minus.png"))); // NOI18N
        jBMinimizar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jBMinimizarActionPerformed(evt);
            }
        });
        jPanel9.add(jBMinimizar);
        jBMinimizar.setBounds(48, 0, 23, 24);

        jLConexion.setFont(new java.awt.Font("Tahoma", 1, 11)); // NOI18N
        jLConexion.setForeground(new java.awt.Color(51, 255, 51));
        jLConexion.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLConexion.setText("-");
        jPanel9.add(jLConexion);
        jLConexion.setBounds(20, 30, 80, 14);

        btnClausulasPrivacidad.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/estadoLectura.png"))); // NOI18N
        btnClausulasPrivacidad.setBorderPainted(false);
        btnClausulasPrivacidad.setContentAreaFilled(false);
        btnClausulasPrivacidad.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        btnClausulasPrivacidad.setFocusPainted(false);
        btnClausulasPrivacidad.setFocusable(false);
        btnClausulasPrivacidad.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnClausulasPrivacidadActionPerformed(evt);
            }
        });
        jPanel9.add(btnClausulasPrivacidad);
        btnClausulasPrivacidad.setBounds(23, 4, 20, 20);

        javax.swing.GroupLayout jPSuperiorLayout = new javax.swing.GroupLayout(jPSuperior);
        jPSuperior.setLayout(jPSuperiorLayout);
        jPSuperiorLayout.setHorizontalGroup(
            jPSuperiorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPSuperiorLayout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(btnMenu, javax.swing.GroupLayout.PREFERRED_SIZE, 62, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(275, 275, 275)
                .addComponent(jDocumento)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jPanel9, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(196, 196, 196))
        );
        jPSuperiorLayout.setVerticalGroup(
            jPSuperiorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPSuperiorLayout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addGroup(jPSuperiorLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPSuperiorLayout.createSequentialGroup()
                        .addComponent(jPanel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap())
                    .addComponent(btnMenu, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPSuperiorLayout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jDocumento))))
        );

        jPMenu.setBackground(new java.awt.Color(219, 219, 219));
        jPMenu.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        jLabel14.setFont(new java.awt.Font("Arial", 1, 12)); // NOI18N
        jLabel14.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel14.setText(" Lectura:");
        jPMenu.add(jLabel14, new org.netbeans.lib.awtextra.AbsoluteConstraints(30, 620, 50, 20));

        jLEstadoLectura.setFont(new java.awt.Font("Arial", 1, 14)); // NOI18N
        jLEstadoLectura.setForeground(new java.awt.Color(255, 0, 0));
        jLEstadoLectura.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLEstadoLectura.setText("Desactivado");
        jPMenu.add(jLEstadoLectura, new org.netbeans.lib.awtextra.AbsoluteConstraints(90, 620, -1, 20));

        jPanel4.setBackground(new java.awt.Color(219, 219, 219));
        jPanel4.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        rSUsuario.setColorBorde(new java.awt.Color(51, 51, 51));
        rSUsuario.setColorBordePopu(new java.awt.Color(204, 204, 204));
        rSUsuario.setColorButtonOptions(new java.awt.Color(128, 128, 131));
        rSUsuario.setFocusable(false);
        rSUsuario.setImagenDefault(null);
        jPanel4.add(rSUsuario, new org.netbeans.lib.awtextra.AbsoluteConstraints(40, 5, 110, 100));

        jPMenu.add(jPanel4, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 0, 190, 110));

        btnProyectos.setForeground(new java.awt.Color(128, 128, 131));
        btnProyectos.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/market.png"))); // NOI18N
        btnProyectos.setText("PROYECTOS");
        btnProyectos.setBorderPainted(false);
        btnProyectos.setColorHover(new java.awt.Color(189, 189, 189));
        btnProyectos.setColorNormal(new java.awt.Color(219, 219, 219));
        btnProyectos.setColorPressed(new java.awt.Color(189, 189, 189));
        btnProyectos.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnProyectos.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnProyectos.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnProyectos.setFocusable(false);
        btnProyectos.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnProyectos.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnProyectos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnProyectosActionPerformed(evt);
            }
        });
        jPMenu.add(btnProyectos, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 152, 190, 42));

        btnInicio.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/home.png"))); // NOI18N
        btnInicio.setText(" INICIO");
        btnInicio.setAutoscrolls(true);
        btnInicio.setBorderPainted(false);
        btnInicio.setColorHover(new java.awt.Color(189, 189, 189));
        btnInicio.setColorNormal(new java.awt.Color(219, 219, 219));
        btnInicio.setColorPressed(new java.awt.Color(189, 189, 189));
        btnInicio.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnInicio.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnInicio.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnInicio.setDefaultCapable(false);
        btnInicio.setFocusable(false);
        btnInicio.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnInicio.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnInicio.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnInicioActionPerformed(evt);
            }
        });
        jPMenu.add(btnInicio, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 110, 190, 42));

        btnProduccion.setForeground(new java.awt.Color(128, 128, 131));
        btnProduccion.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/collection.png"))); // NOI18N
        btnProduccion.setText("PRODUCCIÓN");
        btnProduccion.setBorderPainted(false);
        btnProduccion.setColorHover(new java.awt.Color(189, 189, 189));
        btnProduccion.setColorNormal(new java.awt.Color(219, 219, 219));
        btnProduccion.setColorPressed(new java.awt.Color(189, 189, 189));
        btnProduccion.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnProduccion.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnProduccion.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnProduccion.setFocusable(false);
        btnProduccion.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnProduccion.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnProduccion.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnProduccionActionPerformed(evt);
            }
        });
        jPMenu.add(btnProduccion, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 236, 190, 42));

        btnUsuarios.setForeground(new java.awt.Color(128, 128, 131));
        btnUsuarios.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-user-8-32.png"))); // NOI18N
        btnUsuarios.setText("USUARIOS");
        btnUsuarios.setBorderPainted(false);
        btnUsuarios.setColorHover(new java.awt.Color(189, 189, 189));
        btnUsuarios.setColorNormal(new java.awt.Color(219, 219, 219));
        btnUsuarios.setColorPressed(new java.awt.Color(189, 189, 189));
        btnUsuarios.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnUsuarios.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnUsuarios.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnUsuarios.setFocusable(false);
        btnUsuarios.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnUsuarios.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnUsuarios.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnUsuariosActionPerformed(evt);
            }
        });
        jPMenu.add(btnUsuarios, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 194, 190, 42));

        btnProcesos.setForeground(new java.awt.Color(128, 128, 131));
        btnProcesos.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/procesos.png"))); // NOI18N
        btnProcesos.setText("PROCESOS");
        btnProcesos.setBorderPainted(false);
        btnProcesos.setColorHover(new java.awt.Color(189, 189, 189));
        btnProcesos.setColorNormal(new java.awt.Color(219, 219, 219));
        btnProcesos.setColorPressed(new java.awt.Color(189, 189, 189));
        btnProcesos.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnProcesos.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnProcesos.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnProcesos.setFocusable(false);
        btnProcesos.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnProcesos.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnProcesos.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnProcesosActionPerformed(evt);
            }
        });
        jPMenu.add(btnProcesos, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 278, 190, 42));

        btnGeneradorQR.setForeground(new java.awt.Color(128, 128, 131));
        btnGeneradorQR.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/QRs_comun.png"))); // NOI18N
        btnGeneradorQR.setText("Generador QRs C");
        btnGeneradorQR.setBorderPainted(false);
        btnGeneradorQR.setColorHover(new java.awt.Color(189, 189, 189));
        btnGeneradorQR.setColorNormal(new java.awt.Color(219, 219, 219));
        btnGeneradorQR.setColorPressed(new java.awt.Color(189, 189, 189));
        btnGeneradorQR.setColorTextHover(new java.awt.Color(128, 128, 131));
        btnGeneradorQR.setColorTextNormal(new java.awt.Color(128, 128, 131));
        btnGeneradorQR.setColorTextPressed(new java.awt.Color(128, 128, 131));
        btnGeneradorQR.setFocusable(false);
        btnGeneradorQR.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        btnGeneradorQR.setHorizontalTextPosition(javax.swing.SwingConstants.RIGHT);
        btnGeneradorQR.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnGeneradorQRActionPerformed(evt);
            }
        });
        jPMenu.add(btnGeneradorQR, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 320, 190, 42));

        jPContenido.setLayout(new javax.swing.BoxLayout(jPContenido, javax.swing.BoxLayout.LINE_AXIS));

        jPanel2.setBackground(new java.awt.Color(255, 255, 255));
        jPanel2.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(0, 0, 0)));
        jPanel2.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));
        jPanel2.setName("holaa"); // NOI18N

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 508, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 648, Short.MAX_VALUE)
        );

        jPContenido.add(jPanel2);

        jPanel3.setBackground(new java.awt.Color(219, 219, 219));
        jPanel3.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(153, 153, 153)));
        jPanel3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jPanel3MouseReleased(evt);
            }
        });

        jPanel5.setBackground(new java.awt.Color(60, 141, 188));
        jPanel5.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(204, 204, 204)));
        jPanel5.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 11, Short.MAX_VALUE)
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));
        jPanel6.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel3.setText("Formato Estándar");
        jLabel3.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jLabel3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel3MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel3MouseExited(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel3MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jLabel3MouseReleased(evt);
            }
        });

        jLabel1.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel1.setText("P.ingresados hoy:");

        jLabel6.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel6.setText("P. Terminados hoy:");

        jLabel10.setText("-----------------------------------");

        FIngresadosHoy.setText("0");

        FTerminadosHoy.setText("0");

        jLabel13.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel13.setText("P. Ejecución:");

        FEjecucion.setText("0");

        FPorIniciar.setText("0");

        jLabel26.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel26.setText("P. por iniciar:");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addComponent(jLabel6)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(FTerminadosHoy, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addGroup(jPanel6Layout.createSequentialGroup()
                                    .addComponent(jLabel1)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                    .addComponent(FIngresadosHoy, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addComponent(jLabel10))
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jLabel13)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(FEjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel6Layout.createSequentialGroup()
                                .addComponent(jLabel26)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(FPorIniciar, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 6, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(FIngresadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(FTerminadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(FEjecucion))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel26)
                    .addComponent(FPorIniciar))
                .addContainerGap(26, Short.MAX_VALUE))
        );

        jPanel7.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));
        jPanel7.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("Teclados");
        jLabel4.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jLabel4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel4MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel4MouseExited(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel4MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jLabel4MouseReleased(evt);
            }
        });

        jLabel2.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel2.setText("P.ingresados hoy:");

        jLabel8.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel8.setText("P. Terminados hoy:");

        jLabel11.setText("-----------------------------------");

        TIngresadosHoy.setText("0");

        TTerminadosHoy.setText("0");

        TEjecucion.setText("0");

        jLabel22.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel22.setText("P. Ejecución:");

        jLabel27.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel27.setText("P. por iniciar:");

        TPorIniciar.setText("0");

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(TIngresadosHoy, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel11)
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addComponent(jLabel8)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(TTerminadosHoy, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addComponent(jLabel22)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(TEjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(jLabel27)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(TPorIniciar, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel4)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 8, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(TIngresadosHoy))
                .addGap(10, 10, 10)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(TTerminadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel22)
                    .addComponent(TEjecucion))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel27)
                    .addComponent(TPorIniciar))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel8.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));
        jPanel8.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jLabel7.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel7.setText("Ensamble");
        jLabel7.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jLabel7.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel7MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel7MouseExited(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel7MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jLabel7MouseReleased(evt);
            }
        });

        jLabel5.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel5.setText("P.ingresados hoy:");

        jLabel9.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel9.setText("P. Terminados hoy:");

        jLabel12.setText("-----------------------------------");

        EIngresadosHoy.setText("0");

        ETerminadosHoy.setText("0");

        EEjecucion.setText("0");

        jLabel24.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel24.setText("P. Ejecución:");

        jLabel29.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel29.setText("P. por iniciar:");

        EPorIniciar.setText("0");

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jLabel5)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(EIngresadosHoy, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel12)
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jLabel9)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(ETerminadosHoy, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jLabel24)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(EEjecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel8Layout.createSequentialGroup()
                                .addComponent(jLabel29)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(EPorIniciar, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 8, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5)
                    .addComponent(EIngresadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(ETerminadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel24)
                    .addComponent(EEjecucion))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel29)
                    .addComponent(EPorIniciar))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel10.setBorder(javax.swing.BorderFactory.createLineBorder(new java.awt.Color(128, 128, 131)));
        jPanel10.setCursor(new java.awt.Cursor(java.awt.Cursor.DEFAULT_CURSOR));

        jLabel18.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel18.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel18.setText("Almacen");
        jLabel18.setCursor(new java.awt.Cursor(java.awt.Cursor.HAND_CURSOR));
        jLabel18.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jLabel18MouseEntered(evt);
            }
            public void mouseExited(java.awt.event.MouseEvent evt) {
                jLabel18MouseExited(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jLabel18MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jLabel18MouseReleased(evt);
            }
        });

        jLabel19.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel19.setText("P.ingresados hoy:");

        jLabel20.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel20.setText("P. Terminados hoy:");

        jLabel21.setText("-----------------------------------");

        AIngresadosHoy.setText("0");

        ATerminadosHoy.setText("0");

        Ajecucion.setText("0");

        jLabel25.setFont(new java.awt.Font("Tahoma", 0, 10)); // NOI18N
        jLabel25.setText("P. Ejecución:");

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel18, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addComponent(jLabel19)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(AIngresadosHoy, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel21)
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jLabel20)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(ATerminadosHoy, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel10Layout.createSequentialGroup()
                                .addComponent(jLabel25)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(Ajecucion, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel18)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel21, javax.swing.GroupLayout.PREFERRED_SIZE, 8, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel19)
                    .addComponent(AIngresadosHoy))
                .addGap(10, 10, 10)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel20)
                    .addComponent(ATerminadosHoy))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel25)
                    .addComponent(Ajecucion))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel8, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel7, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jPanel6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPanel10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jPMenu, javax.swing.GroupLayout.PREFERRED_SIZE, 190, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jPContenido, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(16, 16, 16)
                .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jPSuperior, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jPSuperior, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(11, 11, 11)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPMenu, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jPContenido, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                        .addContainerGap())))
        );

        getContentPane().add(jPanel1, "card2");

        jMenuBar1.setBackground(new java.awt.Color(255, 255, 255));
        jMenuBar1.setForeground(new java.awt.Color(153, 153, 153));
        jMenuBar1.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        jMenu1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/userNav.png"))); // NOI18N
        jMenu1.setText("Cuenta");

        jMenuItem1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/password.png"))); // NOI18N
        jMenuItem1.setText("Cambiar contraseña");
        jMenuItem1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem1ActionPerformed(evt);
            }
        });
        jMenu1.add(jMenuItem1);

        jMenuBar1.add(jMenu1);

        jMenu3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/configuracion.png"))); // NOI18N
        jMenu3.setText("Configuración");

        jMenu4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/configuracion.png"))); // NOI18N
        jMenu4.setText("Puerto COM");
        jMenu4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseEntered(java.awt.event.MouseEvent evt) {
                jMenu4MouseEntered(evt);
            }
        });
        jMenu3.add(jMenu4);

        jMLectura.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/estadoLectura.png"))); // NOI18N
        jMLectura.setText("Lectura");

        estadoLectura.add(jRLActivado);
        jRLActivado.setSelected(true);
        jRLActivado.setText("Activado");
        jRLActivado.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (3).png"))); // NOI18N
        jRLActivado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRLActivadoActionPerformed(evt);
            }
        });
        jMLectura.add(jRLActivado);

        estadoLectura.add(jRLDesactivado);
        jRLDesactivado.setText("Desactivado");
        jRLDesactivado.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (4).png"))); // NOI18N
        jRLDesactivado.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRLDesactivadoActionPerformed(evt);
            }
        });
        jMLectura.add(jRLDesactivado);

        jMenu3.add(jMLectura);

        jMenu5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/db.png"))); // NOI18N
        jMenu5.setText("Conexión");

        jMenuItem4.setText("DB MySQL");
        jMenuItem4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem4ActionPerformed(evt);
            }
        });
        jMenu5.add(jMenuItem4);

        jMenu3.add(jMenu5);

        rutaQR.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/path.png"))); // NOI18N
        rutaQR.setText("Ruta QRs");
        rutaQR.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                rutaQRActionPerformed(evt);
            }
        });
        jMenu3.add(rutaQR);
        jMenu3.add(jSeparator1);

        jMenuBar1.add(jMenu3);

        jMenu2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/close1.png"))); // NOI18N
        jMenu2.setText("Salir");

        jMenuItem2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/season.png"))); // NOI18N
        jMenuItem2.setText("Cerrar sesión");
        jMenuItem2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItem2ActionPerformed(evt);
            }
        });
        jMenu2.add(jMenuItem2);

        jMenuBar1.add(jMenu2);

        setJMenuBar(jMenuBar1);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    public void estadoPertoSerialOperarios() {
        //...
        Proyecto controlador = new Proyecto();
        controlador.actualizarEstadoLecturaPuertoSerial((estadoLecturaPuertoCOM ? 1 : 0), jDocumento.getText());
        //...
    }

    private void consultarPtoyectosTomaDeTiempoAbierta() {
        //Es metodo se hace con la finalidad de saber que proyectos no pausaron/terminaron el tiempo satisfactoriamente antes de que sucediera la falla de energia.
        //Solo se le realizara esta acción a los cargos de encargado ensamble, encargado de FE y TE 
        FE_TE_IN obj = new FE_TE_IN();
        if (cargo == 2) {
            try {
                //Buscamos los proyectos de FE que estan en ejecucion.
                crs = obj.consultarProyectosEnEjecucion(1);
                while (crs.next()) {
                    if (producF == null) {
                        producF = new ControlDelTiempo();
                        producF.setName("FE");
                        producF.setTitle("Formato estandar");
                        producF.setVisible(true);
                        producF.negocioFE = 1;
                        producF.setArea(1);
                        producF.setVista(producF);
                    }
                    producF.agregarBotones(producF, Integer.parseInt(crs.getString(1)));
                }
                //Buscamos los proyectos de TE que estan en ejecucion.
                crs = obj.consultarProyectosEnEjecucion(2);
                while (crs.next()) {
                    if (producT == null) {
                        producT = new ControlDelTiempo();
                        producT.setName("TE");
                        producT.setTitle("Teclados");
                        producT.setVisible(true);
                        producT.negocioTE = 2;
                        producT.setArea(2);
                        producT.setVista(producT);
                    }
                    producT.agregarBotones(producT, Integer.parseInt(crs.getString(1)));
                }
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Error!!" + e);
            }
        } else if (cargo == 3) {
            try {
                crs = obj.consultarProyectosEnEjecucion(3);
                while (crs.next()) {
                    if (producE == null) {
                        producE = new ControlDelTiempo();
                        producE.setName("IN");
                        producE.setTitle("Ensamble");
                        producE.setVisible(true);
                        producE.negocioIN = 3;
                        producE.setArea(3);
                        producE.setVista(producE);
                    }
                    producE.agregarBotones(producE, Integer.parseInt(crs.getString(1)));
                }
            } catch (Exception e) {
                JOptionPane.showMessageDialog(null, "Error!!" + e);
            }
        }
    }

    //Queda pendiente hacerle sus respectivas validaciones.....................................................
    public static void estadoDeLectura() {
        //Se encarga de seleccionar el estado de lectura del sistema.
        if (Menu.estadoLecturaPuertoCOM) {//Activado!!
            jLEstadoLectura.setText("Activado");
            jLEstadoLectura.setForeground(verde);
        } else {//Desactivado.
            jLEstadoLectura.setText("Desactivado");
            jLEstadoLectura.setForeground(rojo);
        }
    }

    private void funcionalidadesUsuario(int cargo, String name) {
        switch (cargo) {
            case 1:
                //Gestor Técnico
                this.setTitle("Gestor Técnico: " + name);
                btnUsuarios.setEnabled(false);
                btnProcesos.setEnabled(false);
                btnGeneradorQR.setEnabled(true);
                btnProyectos.setEnabled(false);
                //ItemMenu de Estado de lectura.
                jMLectura.setVisible(false);
                rutaQR.setVisible(true);
                jLEstadoLectura.setVisible(false);
                jLabel14.setVisible(false);
                break;
            case 6:
                //Gestor Comercial
                this.setTitle("Gestor Comercial: " + name);
                btnUsuarios.setEnabled(false);
                btnProcesos.setEnabled(false);
                btnGeneradorQR.setEnabled(false);
                //ItemMenu de Estado de lectura.
                jMLectura.setVisible(false);
                rutaQR.setVisible(true);
                jLEstadoLectura.setVisible(false);
                jLabel14.setVisible(false);
                break;
            case 2: //Encargado FE y TE
            case 3: //Encargado de EN 
                this.setTitle((cargo == 2 ? "Encargado FE y TE: " : "Encargado EN: ") + name);
                btnUsuarios.setEnabled(false);
                btnProcesos.setEnabled(false);
                btnGeneradorQR.setEnabled(false);
                //ItemMenu de Estado de lectura.
                jMLectura.setVisible(true);
                rutaQR.setVisible(false);
                jLEstadoLectura.setVisible(true);
                jLabel14.setVisible(true);
                break;
            case 4:// Administrador
                this.setTitle("Administrador: " + name);
                btnGeneradorQR.setEnabled(false);
                //ItemMenu de Estado de lectura.
                jMLectura.setVisible(false);
                rutaQR.setVisible(true);
                jLEstadoLectura.setVisible(false);
                jLabel14.setVisible(false);
                break;
            case 5:
                //Almacen
                this.setTitle("Almacen: " + name);// Pendiente organizar...
                btnGeneradorQR.setEnabled(false);
                btnUsuarios.setEnabled(false);
                btnProyectos.setEnabled(false);
                btnProcesos.setEnabled(false);
                //ItemMenu de Estado de lectura.
                jMLectura.setVisible(false);
                rutaQR.setVisible(false);
                jLEstadoLectura.setVisible(false);
                jLabel14.setVisible(false);
                break;
        }
    }

    private void btnProyectosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnProyectosActionPerformed
        btnMenu.setEnabled(false);
        if (!btnProyectos.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(corF);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(cor);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(corF);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(corF);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(corF);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(corF);
            btnGeneradorQR.setColorPressed(cor);
        } else {
            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(cor);
            btnProyectos.setColorPressed(cor);
        }
        switch (cargo) {
            case 1://Getosr Técnico
            case 4://Administrador
            case 6://Gestor comercial
                cambiarpanelProyecto("proyectos");
                break;
            case 2://Encargado FE y TE 
                proyecto1.cargo = cargo;
                cambiarpanelProyecto("proyectos1");
                break;
            case 3://Encargado EN
                proyecto1.cargo = cargo;
                cambiarpanelProyecto("proyectos2");
                break;
        }
    }//GEN-LAST:event_btnProyectosActionPerformed

    private void btnProduccionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnProduccionActionPerformed
        btnMenu.setEnabled(false);
        if (!btnProduccion.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(corF);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(corF);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(corF);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(cor);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(corF);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(corF);
            btnGeneradorQR.setColorPressed(cor);
        } else {
            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(cor);
            btnUsuarios.setColorPressed(cor);
        }
        if (bp == null) {
            bp = new Producciones(cargo);
            bp.setVisible(true);
        } else {
            bp.isFocusableWindow();
        }
    }//GEN-LAST:event_btnProduccionActionPerformed

    private void btnMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnMenuActionPerformed
        int posicionX = jPMenu.getX();
        if (posicionX > -1) {
            Animacion.Animacion.mover_izquierda(0, -542, 1, 2, jPMenu);
            Animacion.Animacion.mover_izquierda(202, 10, 1, 2, jPContenido);
            Animacion.Animacion.mover_izquierda(1135, 934, 1, 2, jPanel3);
        } else {
            Animacion.Animacion.mover_derecha(-542, 0, 1, 2, jPMenu);
            Animacion.Animacion.mover_derecha(10, 202, 1, 2, jPContenido);
            Animacion.Animacion.mover_derecha(934, 1135, 1, 2, jPanel3);
        }
    }//GEN-LAST:event_btnMenuActionPerformed

    private void btnInicioActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnInicioActionPerformed
        btnMenu.setEnabled(true);
        if (!btnInicio.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(cor);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(corF);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(corF);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(corF);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(corF);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(corF);
            btnGeneradorQR.setColorPressed(cor);

        } else {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(cor);
            btnInicio.setColorPressed(cor);
        }
        if (!jPContenido.getComponent(0).getName().equals("inicio")) {
            new CambiaPanel(jPContenido, new Inicio(cargo));
            Vistas.proyecto pro = new proyecto();

            if (pro != null) {
                pro.disponibilidad = false;
                pro = null;
            }
        }
    }//GEN-LAST:event_btnInicioActionPerformed

    private void btnUsuariosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnUsuariosActionPerformed
        btnMenu.setEnabled(false);
        if (!btnUsuarios.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(corF);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(corF);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(cor);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(corF);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(corF);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(corF);
            btnGeneradorQR.setColorPressed(cor);
        } else {
            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(cor);
            btnUsuarios.setColorPressed(cor);
        }
        if (!jPContenido.getComponent(0).getName().equals("usuarios")) {
            new CambiaPanel(jPContenido, new Usuarios1());
            if (pro != null) {
                pro.disponibilidad = false;
                pro = null;
            }
        }
    }//GEN-LAST:event_btnUsuariosActionPerformed

    private void jPSuperiorMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPSuperiorMousePressed
        posX = evt.getX();
        posY = evt.getY();
    }//GEN-LAST:event_jPSuperiorMousePressed

    private void jPSuperiorMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPSuperiorMouseDragged
        this.setLocation((evt.getXOnScreen() - posX), (evt.getYOnScreen() - posY - 25));
    }//GEN-LAST:event_jPSuperiorMouseDragged

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        cerrarSesion();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jBMinimizarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jBMinimizarActionPerformed
        setExtendedState(JFrame.CROSSHAIR_CURSOR);
    }//GEN-LAST:event_jBMinimizarActionPerformed

    private void jMenuItem1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem1ActionPerformed
        if (viewCambiarContraseña == null) {
            viewCambiarContraseña = new CambiarContraseña();
            viewCambiarContraseña.setVisible(true);
        }
    }//GEN-LAST:event_jMenuItem1ActionPerformed

    private void jMenuItem2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem2ActionPerformed
        if (producE == null && producF == null && producT == null) {
            if (JOptionPane.showOptionDialog(null, "¿Seguro desea cerrar la sesión?",
                    "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                    new Object[]{"SI", "NO"}, "SI") == 0) {
                //Cierra el menu y abre el login
//                tomaTiempo.destroy();
                estadoLecturaPuertoCOM = false;//Variable del menu para los roles encargados de FE, TE y EN
                pro.disponibilidad = false;//Variable  de la vista proyecto para los roles administrativos del sistema.
                // ...
                if (bp != null) {
                    bp.jBSalir.doClick();//La vista de produccion tiene que cerrarce cuando se salga de la aplicación.
                }
                this.dispose();
                if (viewCambiarContraseña != null) {
                    viewCambiarContraseña.btnClose.doClick();
                }
                try {
                    guardarImagenMenuUsuario();//Guarda la imagen del usuario
                    sesion(0, jDocumento.getText());//Cierra el estado del ususario
                    // ...
                    socketCliente clienteSocket = new socketCliente(cargo == 2 ? new int[]{1, 2} : new int[]{3});
                    ArrayList<Object> serversSockets = clienteSocket.consultarServerSockets();
                    clienteSocket.enviarInformacionSocketserver(serversSockets, "2");// Desactivar la conexión en los reportes
                    if(server != null){
                        server.cerrarServidorSocket();  
                    }
                    estadoConexionDB = false;
                    // ...
                    Thread.sleep(290);
                    System.gc();//Garbaje collector #4
                    this.dispose();
                    new Login().setVisible(true);
                } catch (Exception e) {
                    JOptionPane.showMessageDialog(null, "Error: " + e);
                }
            }
        } else {
            new rojerusan.RSNotifyAnimated("¡Alerta!", "No puedes cerrar la aplicacion mientras un producto en ejecución.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
        }
    }//GEN-LAST:event_jMenuItem2ActionPerformed

    private void formWindowClosing(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosing
        cerrarSesion();
    }//GEN-LAST:event_formWindowClosing

    private void jPanel3MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel3MouseReleased
        if (evt.isPopupTrigger()) {
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
    }//GEN-LAST:event_jPanel3MouseReleased

    private void jMenuItem3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem3ActionPerformed
        InformacionAreasProduccion();
    }//GEN-LAST:event_jMenuItem3ActionPerformed

    private void jPSuperiorMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPSuperiorMouseReleased
        if (evt.isPopupTrigger()) {//El evento es realizado con el click derecho?
            jPopupMenu1.show(evt.getComponent(), evt.getX(), evt.getY());
        }
    }//GEN-LAST:event_jPSuperiorMouseReleased

    private void btnProcesosActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnProcesosActionPerformed
        btnMenu.setEnabled(false);
        if (!btnProduccion.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(corF);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(corF);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(corF);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(corF);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(cor);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(corF);
            btnGeneradorQR.setColorPressed(cor);
        } else {
            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(cor);
            btnProcesos.setColorPressed(cor);
        }
        if (!jPContenido.getComponent(0).getName().equals("Procesos")) {
            new CambiaPanel(jPContenido, new Procesos_Condicion());
            if (pro != null) {
                pro.disponibilidad = false;
                pro = null;
            }
        }
    }//GEN-LAST:event_btnProcesosActionPerformed

    private void jLabel3MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseEntered
        jLabel3.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel3MouseEntered

    private void jLabel3MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseExited
        jLabel3.setForeground(Color.BLACK);
    }//GEN-LAST:event_jLabel3MouseExited

    private void jLabel3MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MousePressed
        jLabel3.setForeground(Color.BLACK);
        informacion = new DetallesAreaInfo(this, true);//Formato estandar
        informacion.setTitle("Formato estandar");
        informacion.consultarDetallesDeProyectos(1);
        informacion.setLocationRelativeTo(null);
        informacion.setVisible(true);
    }//GEN-LAST:event_jLabel3MousePressed

    private void jLabel3MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel3MouseReleased
        jLabel3.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel3MouseReleased

    private void jLabel4MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseEntered
        jLabel4.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel4MouseEntered

    private void jLabel4MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseExited
        jLabel4.setForeground(Color.BLACK);
    }//GEN-LAST:event_jLabel4MouseExited

    private void jLabel4MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MousePressed
        jLabel4.setForeground(Color.BLACK);
        informacion = new DetallesAreaInfo(this, true);//Teclados
        informacion.setTitle("Teclados");
        informacion.consultarDetallesDeProyectos(2);
        informacion.setLocationRelativeTo(null);
        informacion.setVisible(true);
    }//GEN-LAST:event_jLabel4MousePressed

    private void jLabel4MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel4MouseReleased
        jLabel4.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel4MouseReleased

    private void jLabel7MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseEntered
        jLabel7.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel7MouseEntered

    private void jLabel7MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseReleased
        jLabel7.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel7MouseReleased

    private void jLabel7MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MouseExited
        jLabel7.setForeground(Color.BLACK);
    }//GEN-LAST:event_jLabel7MouseExited

    private void jLabel7MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel7MousePressed
        jLabel7.setForeground(Color.BLACK);
        informacion = new DetallesAreaInfo(this, true);//Ensamble
        informacion.setTitle("Ensamble");
        informacion.consultarDetallesDeProyectos(3);
        informacion.setLocationRelativeTo(null);
        informacion.setVisible(true);
    }//GEN-LAST:event_jLabel7MousePressed

    private void jLabel18MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel18MouseEntered
        jLabel18.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel18MouseEntered

    private void jLabel18MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel18MouseReleased
        jLabel18.setForeground(new Color(63, 179, 255));
    }//GEN-LAST:event_jLabel18MouseReleased

    private void jLabel18MouseExited(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel18MouseExited
        jLabel18.setForeground(Color.BLACK);
    }//GEN-LAST:event_jLabel18MouseExited

    private void jLabel18MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jLabel18MousePressed
        jLabel18.setForeground(Color.BLACK);
        informacion = new DetallesAreaInfo(this, true);//Almacen
        informacion.setTitle("Almacen");
        informacion.consultarDetallesDeProyectos(4);
        informacion.setLocationRelativeTo(null);
        informacion.setVisible(true);
    }//GEN-LAST:event_jLabel18MousePressed

    private void jRLActivadoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRLActivadoActionPerformed
        //
        if (!estadoLecturaPuertoCOM) {
            if (JOptionPane.showOptionDialog(null, "¿Seguro deseas reactivar el estado de lectura?",
                    "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                    new Object[]{"SI", "NO"}, "SI") == 0) {
                estadoLecturaPuertoCOM = true;
                // ...
                HiloLectura lectura = new HiloLectura(this);
                Thread tomaTiempo = new Thread(lectura);
                tomaTiempo.start();
                // ...
            } else {
                jRLDesactivado.setSelected(true);
            }
        }
        //
    }//GEN-LAST:event_jRLActivadoActionPerformed

    private void jRLDesactivadoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRLDesactivadoActionPerformed
        // 
        if (estadoLecturaPuertoCOM) {
            if (JOptionPane.showOptionDialog(null, "¿Seguro deseas desactivar el estado de lectura?",
                    "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                    new Object[]{"SI", "NO"}, "SI") == 0) {
                estadoLecturaPuertoCOM = false;//Se encarga de desactivar el estado de lectura.
                estadoDeLectura();
            }
        }
    }//GEN-LAST:event_jRLDesactivadoActionPerformed

    private void jMenu4MouseEntered(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu4MouseEntered
        //Busqueda de los puertos seriales disponibles--------------------------
        puertosSerialDisponibles();
        //fin de la busqueda de puertos-----------------------------------------
    }//GEN-LAST:event_jMenu4MouseEntered

    private void btnClausulasPrivacidadActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnClausulasPrivacidadActionPerformed
        ClausulasPrivacidad obj = new ClausulasPrivacidad(this, true);
        obj.setLocationRelativeTo(null);
        obj.setVisible(true);

    }//GEN-LAST:event_btnClausulasPrivacidadActionPerformed

    private void jMenuItem4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItem4ActionPerformed
        IP = JOptionPane.showInputDialog(this, "Cual es la dirección del servidor", IP);
        user = JOptionPane.showInputDialog(this, "Cual el usuario del servidor", user);
        pass = JOptionPane.showInputDialog(this, "Cual es la contraseña del usuario", pass);
        //...
//        System.out.println(IP);
    }//GEN-LAST:event_jMenuItem4ActionPerformed

    private void btnGeneradorQRActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnGeneradorQRActionPerformed
        btnMenu.setEnabled(true);
        if (!btnInicio.isSelected()) {
            btnInicio.setColorHover(cor);
            btnInicio.setColorNormal(corF);
            btnInicio.setColorPressed(cor);

            btnProyectos.setColorHover(cor);
            btnProyectos.setColorNormal(corF);
            btnProyectos.setColorPressed(cor);

            btnUsuarios.setColorHover(cor);
            btnUsuarios.setColorNormal(corF);
            btnUsuarios.setColorPressed(cor);

            btnProduccion.setColorHover(cor);
            btnProduccion.setColorNormal(corF);
            btnProduccion.setColorPressed(cor);

            btnProcesos.setColorHover(cor);
            btnProcesos.setColorNormal(corF);
            btnProcesos.setColorPressed(cor);

            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(cor);
            btnGeneradorQR.setColorPressed(cor);

        } else {
            btnGeneradorQR.setColorHover(cor);
            btnGeneradorQR.setColorNormal(cor);
            btnGeneradorQR.setColorPressed(cor);
        }
        if (!jPContenido.getComponent(0).getName().equals("QRsComun")) {
            new CambiaPanel(jPContenido, new GeneradorQRComun());
            Vistas.proyecto pro = new proyecto();

            if (pro != null) {
                pro.disponibilidad = false;
                pro = null;
            }
        }
    }//GEN-LAST:event_btnGeneradorQRActionPerformed

    private void rutaQRActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_rutaQRActionPerformed
        //Parent, mensaje, titulo y tipo
        if (controlador == null) {
            controlador = new rutaQR();
        }
        controlador.consultarRutaQR(jDocumento.getText());
        String path = JOptionPane.showInputDialog(this, "Ingresa la ruta donde se guardaran los QR generados", controlador.getRutaQR());
        if (path != null) {
            //...El path tiene que ser diferente a null y a vacio. El path tiene que ser 
            if (!path.equals("") && path.codePointAt(path.length() - 1) == 92) {
                //Gestionar la ruta
                controlador.setRutaQR(path);
                controlador.gestionarRutaQR(jDocumento.getText());
                //...
                if (controlador.getRespuesta()) {
                    new rojerusan.RSNotifyAnimated("¡Realizado!", "Se actualizo la ruta de generacion de QR de los proyectos.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                }
                //...
            } else {
                new rojerusan.RSNotifyAnimated("¡Alerta!", "La ruta especificada no esta bien estructurada.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            }
        }
    }//GEN-LAST:event_rutaQRActionPerformed
//Metodos de la clase menu----------------------------------------------------->
//...
//Configuracion de los puertos seriales-----------------------------------------

    public static String ConsultarPuertoGurdadoUsuario(String doc) {
        Controlador.Usuario obj = new Controlador.Usuario();
        String puerto = obj.consultarPuertoUsario(doc);
        return puerto.equals("") ? "COM6" : puerto;
    }

    public void puertosSerialDisponibles() {
        //
        try {//DELETE FROM usuariopuerto WHERE documentousario='9813053240'
            ConexionPS obj = new ConexionPS();
            jMenu4.removeAll();
            String v[] = obj.puertosDisponibles();
            grupoCom = new ButtonGroup();
            for (int i = 0; i < v.length; i++) {
                JRadioButtonMenuItem opPuerto = new JRadioButtonMenuItem(v[i]);//Boton
                opPuerto.setName(v[i]);//Nombre del componente
                opPuerto.setActionCommand(v[i]);//Acción de comando
                opPuerto.addActionListener(this);//Evento
                if (puertoSerialActual.equals(v[i])) {
                    opPuerto.setSelected(true);
                }
                //Estado del boton depende del estado de lectura.
                if (estadoLecturaPuertoCOM) {
                    opPuerto.setEnabled(false);
                }
                grupoCom.add(opPuerto);
                jMenu4.add(opPuerto);
            }
        } catch (Exception e) {
            
            JOptionPane.showMessageDialog(null, "Error: " + e);
            
        }
    }

//Action del boton cuando es activado
    @Override
    public void actionPerformed(ActionEvent e) {
        ButtonModel boton = grupoCom.getSelection();
        Usuario obj = new Usuario();
        puertoSerialActual = boton.getActionCommand();
        obj.RegistrarModificarPuertoSerialUsuario(jDocumento.getText(), boton.getActionCommand());
    }
//Fin de la configuracion de los puertos seriales-------------------------------

    public void LecturaCodigoQR(String informacion_codigo) {

        String sub_trama[] = informacion_codigo.split("_");

        String trama_QR[] = sub_trama[0].split("@");

        // ...
        for (int i = 0; i < trama_QR.length; i++) {
            // ...

            String infoProductoQR[] = null;
            if (sub_trama.length == 2) {
                infoProductoQR = (trama_QR[i] + sub_trama[1]).split(";");
            } else {
                infoProductoQR = trama_QR[i].split(";");
            }
            // ...

            //Esta validacion queda mejor a nivel de la base de datos o del modelo...
            Proyecto validar = new Proyecto();
            // Se validara primero el permiso que tiene el ususario para leer los códigos QR de esta orden y despues se validara si la orden existe o esta parada.
            if (validar.validarEliminacion(Integer.parseInt(infoProductoQR[0]))) {//Valido si la orden esta eliminada o no
                // ...
                if (validar.validarEjecucionOParada(Integer.parseInt(infoProductoQR[0]))) {//Valida que la orden no este parada

                    if (validarEstructuraCorrectaDelQR(infoProductoQR.length)) {//Se valida que si se lea el codigo QR que es necesario
                        // ...
                        switch (Integer.parseInt(infoProductoQR[2])) {
                            //Se tiene que validar el estado del proyecto a ver si permite o no registrar la toma de tiempo.
                            case 1:

                                producF = registrarTiemposEjecucionProducto(infoProductoQR, producF, "FE", "Formato estandar", 1, trama_QR.length);

                                break;
                            case 2:

                                producT = registrarTiemposEjecucionProducto(infoProductoQR, producT, "TE", "Teclados", 2, trama_QR.length);

                                break;
                            case 3:
                                // ...
                                producE = registrarTiemposEjecucionProducto(infoProductoQR, producE, "IN", "Ensmble", 3, trama_QR.length);
                                // ...
                                break;
                        }
                    }

                } else {
                    //El proyecto no puede realizar la toma de tiempo porque esta parada.
//                  enviarMensajeCelular("¡Alerta!" + "n/" + "Esta orden esta parada, no puedes realizar la toma de tiempo de esta orden.");
                    new rojerusan.RSNotifyAnimated("¡Alerta!", "Esta orden esta parada, no puedes realizar la toma de tiempo de esta orden.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                }

            } else {
                //Este mensaje se retornara al dispositivo móvil.
                //El proyecto no existe - Esta eliminado
//              enviarMensajeCelular("¡Alerta!" + "n/" + "Este numero de orden no existe.");
                new rojerusan.RSNotifyAnimated("¡Alerta!", "Este numero de orden no existe.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.WARNING).setVisible(true);
            }
        }
    }

    private boolean validarEstructuraCorrectaDelQR(int longitudInfoQR) {
        boolean repuesta = false;
        switch (cargo) {
            case 2: // Encargado de FE y TE
                if (longitudInfoQR == 6 || longitudInfoQR == 7) {
                    repuesta = true;
                }
                break;
            case 3: // Encargado de EN
                if (longitudInfoQR == 7) {
                    repuesta = true;
                }
                break;
        }
        // ...
        return repuesta;
    }

    private ControlDelTiempo registrarTiemposEjecucionProducto(String[] infoProductoQR, ControlDelTiempo view, String name, String title, int area, int cantidadProductosQR) {

        if (view == null) {
            view = new ControlDelTiempo();
            view.setName(name);
            view.setTitle(title);
            view.setVisible(true);
            view.setArea(area);
            view.setVista(view);
        }

        boolean respuesta = view.RegistrarTomaTiempoProductoProceso(infoProductoQR, cargo, view, myPS, cantidadProductosQR);

        if (respuesta) {
            
            socketCliente clienteSocket = new socketCliente(cargo==2?new int[]{1,2}:new int[]{3});// Consultar todos los servers socket de los reportes de producción
            clienteSocket.enviarInformacionSocketserver(clienteSocket.consultarServerSockets(),"true");
            
        }else{
            
            switch(area){
                case 1:// Formato estandar
                    view = producF;
                    break;
                case 2:// Teclados
                    view = producT;
                    break;
                case 3:// Ensamble
                    view = producE;
                    break;
            }
            
        }

        return view;
    }

//    public void comunicacionServerSocket(int area, String mensaje) {
//        // Envia dato a todos los reportes de produccion de las difetentes áreas de produccion para que se actualicen...
//        socketCliente cliente = new socketCliente(area);
//        CachedRowSet crs = cliente.consultarServidoresReportes();
//        consultarServerSockets(0);
//        try {
//            while (crs.next()) {
//
//                if (!cliente.enviarInformacionServerSocket(crs.getString("ipServidor"), Integer.parseInt(crs.getString("puerto")), mensaje)) {
//
//                    cliente.gestionarDireccionServidor(crs.getString("ipServidor"),area, 0, 0, crs.getString("puerto"));//
//                    
//                }
//
//            }
//        } catch (SQLException ex) {
//            Logger.getLogger(Menu.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }

    public void limpiarInformacionAreas() {
        FIngresadosHoy.setText("0");
        FEjecucion.setText("0");
        FTerminadosHoy.setText("0");
        FPorIniciar.setText("0");
        TIngresadosHoy.setText("0");
        TEjecucion.setText("0");
        TTerminadosHoy.setText("0");
        TPorIniciar.setText("0");
        EIngresadosHoy.setText("0");
        EEjecucion.setText("0");
        ETerminadosHoy.setText("0");
        EPorIniciar.setText("0");
    }

    public void cerrarSesion() {
        if (producE == null && producF == null && producT == null) {//Mientras estas ventanas esten abiertas no se puede cerrar la aplicación.
            if (JOptionPane.showOptionDialog(null, "¿Seguro desea cerrar el sistema?",
                    "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                    JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                    new Object[]{"SI", "NO"}, "SI") == 0) {
                // ...
                sesion(0, jDocumento.getText());// Cerrar Session
                if(cargo==2 || cargo==3){
                    
                    socketCliente clienteSocket = new socketCliente(cargo==2?new int[]{1,2}:new int[]{3});
                    ArrayList<Object> serversSockets= clienteSocket.consultarServerSockets();
                    clienteSocket.enviarInformacionSocketserver(serversSockets, "des");// Estado de lectura desactivado
                    clienteSocket.enviarInformacionSocketserver(serversSockets, "2");// Conexion con el servidor perdida
                    
                    Proyecto controlador = new Proyecto();
                    controlador.actualizarEstadoLecturaPuertoSerial(0, jDocumento.getText()); 
                }
                //Esto ezsta pendiente para la proxima actualización
//              guardarImagenMenuUsuario(); <--- pendiente para futuras versiones...
                System.exit(0);
            }
        } else {
            new rojerusan.RSNotifyAnimated("¡Alerta!", "No puedes cerrar la aplicacion mientras un producto en ejecución.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
            this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
        }
    }

    public void InformacionAreasProduccion() {
        Proyecto obj = new Proyecto();
        int accion = 1;
        limpiarInformacionAreas();
        try {
            while (accion <= 4) {
                crs = obj.InformacionAreasProduccion(accion);
                switch (accion) {
                    case 1:
                        //proyectos ingresados hoy----------------------------->
                        while (crs.next()) {
                            switch (crs.getInt(2)) {
                                case 1:
                                    //<Formato estandar>
                                    FIngresadosHoy.setText(crs.getString(1));
                                    break;
                                case 2:
                                    //<Teclados>
                                    TIngresadosHoy.setText(crs.getString(1));
                                    break;
                                case 3:
                                    //<Ensamble>
                                    EIngresadosHoy.setText(crs.getString(1));
                                    break;
                                default:
                                    AIngresadosHoy.setText(crs.getString(1));
                                    break;
                            }
                        }
                        crs.close();
                        //proyectos ingresados hoy----------------------------->
                        break;
                    case 2:
                        //Proyectos terminados hoy por area-------------------->
                        crs.next();
                        FTerminadosHoy.setText(crs.getString(1));
                        TTerminadosHoy.setText(crs.getString(2));
                        ETerminadosHoy.setText(crs.getString(3));
                        ATerminadosHoy.setText(crs.getString(4));
                        crs.close();
                        //Proyectos terminados hoy por area-------------------->
                        break;
                    case 3:
                        //Proyectos que se encuentran en estado de ejecución--->
                        while (crs.next()) {
                            switch (crs.getInt(2)) {
                                case 1:
                                    //<Formato estandar>
                                    FEjecucion.setText(crs.getString(1));
                                    break;
                                case 2:
                                    //<Teclados>
                                    TEjecucion.setText(crs.getString(1));
                                    break;
                                case 3:
                                    //<Ensamble>
                                    EEjecucion.setText(crs.getString(1));
                                    break;
                                default:
                                    Ajecucion.setText(crs.getString(1));
                                    break;
                            }
                        }
                        crs.close();
                        //Proyectos que se encuentran en estado de ejecución--->
                        break;
                    case 4:
                        //Proyectos que se encuentran en estado por iniciar---->
                        while (crs.next()) {
                            switch (crs.getInt(2)) {
                                case 1:
                                    //<Formato estandar>
                                    FPorIniciar.setText(crs.getString(1));
                                    break;
                                case 2:
                                    //<Teclados>
                                    TPorIniciar.setText(crs.getString(1));
                                    break;
                                case 3:
                                    //<Ensamble>
                                    EPorIniciar.setText(crs.getString(1));
                                    break;
                                default:
                                    break;
                            }
                        }
                        crs.close();
                        //Proyectos que se encuentran en estado por iniciar----->
                        break;
                }
                accion++;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error!" + e);
        }
    }

    public void sesion(int sec, String doc) {
        Controlador.Usuario obj = new Controlador.Usuario();
        obj.sesion(sec, doc);
    }

    public void cambiarpanelProyecto(String name) {
        if (!jPContenido.getComponent(0).getName().equals(name)) {
            switch (cargo) {
                case 1:
                case 4:
                case 6:
                    new CambiaPanel(jPContenido, pro = new proyecto(1));
                    break;
                case 2:
                    new CambiaPanel(jPContenido, new proyecto1(1));
                    break;
                case 3:
                    new CambiaPanel(jPContenido, new proyecto1(1));
                    break;
            }
        }
    }

    //La parte de capturar y gusrdadr la imagen de perfil no se a realizado.
    public void guardarImagenMenuUsuario() {
        Controlador.Usuario obj = new Controlador.Usuario();
        obj.imagenUsuario(rSUsuario.getRutaImagen(), jDocumento.getText());
    }

    public void consultarImagenUsuario(String doc) {
        Controlador.Usuario obj = new Controlador.Usuario();
        String rutaImagen = obj.consultarImagenUsuario(doc);
        if (rutaImagen != null && !rutaImagen.equals("")) {
            File ruta = new File(rutaImagen);
            if (ruta.exists()) {
                try {
                    //Aun no esta completo
                    ImageIcon icon = new ImageIcon(rutaImagen);
//                    rSUsuario
//                    UrSUsuario.set
//                    rSUsuario.imagenIcon.setImage(icon.getImage());
                } catch (Exception e) {
                    JOptionPane.showMessageDialog(null, e);
                }
            }
        }
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */

 /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {

            public void run() {
//                try {
//                    UIManager.setLookAndFeel(new SyntheticaBlackEyeLookAndFeel());
//                } catch (Exception e) {
//                    JOptionPane.showMessageDialog(null, e);
//                }
                new Menu(0, "", "").setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    public javax.swing.JLabel AIngresadosHoy;
    public javax.swing.JLabel ATerminadosHoy;
    public javax.swing.JLabel Ajecucion;
    public javax.swing.JLabel EEjecucion;
    public javax.swing.JLabel EIngresadosHoy;
    public javax.swing.JLabel EPorIniciar;
    public javax.swing.JLabel ETerminadosHoy;
    public javax.swing.JLabel FEjecucion;
    public javax.swing.JLabel FIngresadosHoy;
    public javax.swing.JLabel FPorIniciar;
    public javax.swing.JLabel FTerminadosHoy;
    public javax.swing.JLabel TEjecucion;
    public javax.swing.JLabel TIngresadosHoy;
    public javax.swing.JLabel TPorIniciar;
    public javax.swing.JLabel TTerminadosHoy;
    public javax.swing.JButton btnClausulasPrivacidad;
    public rsbuttom.RSButtonMetro btnGeneradorQR;
    public rsbuttom.RSButtonMetro btnInicio;
    public javax.swing.JButton btnMenu;
    public rsbuttom.RSButtonMetro btnProcesos;
    public rsbuttom.RSButtonMetro btnProduccion;
    public rsbuttom.RSButtonMetro btnProyectos;
    public rsbuttom.RSButtonMetro btnUsuarios;
    public javax.swing.ButtonGroup estadoLectura;
    public javax.swing.JButton jBMinimizar;
    public javax.swing.JButton jButton1;
    public static javax.swing.JLabel jDocumento;
    public javax.swing.JInternalFrame jInternalFrame1;
    public static javax.swing.JLabel jLConexion;
    public static javax.swing.JLabel jLEstadoLectura;
    public javax.swing.JLabel jLabel1;
    public javax.swing.JLabel jLabel10;
    public javax.swing.JLabel jLabel11;
    public javax.swing.JLabel jLabel12;
    public javax.swing.JLabel jLabel13;
    public javax.swing.JLabel jLabel14;
    public javax.swing.JLabel jLabel18;
    public javax.swing.JLabel jLabel19;
    public javax.swing.JLabel jLabel2;
    public javax.swing.JLabel jLabel20;
    public javax.swing.JLabel jLabel21;
    public javax.swing.JLabel jLabel22;
    public javax.swing.JLabel jLabel24;
    public javax.swing.JLabel jLabel25;
    public javax.swing.JLabel jLabel26;
    public javax.swing.JLabel jLabel27;
    public javax.swing.JLabel jLabel29;
    public javax.swing.JLabel jLabel3;
    public javax.swing.JLabel jLabel4;
    public javax.swing.JLabel jLabel5;
    public javax.swing.JLabel jLabel6;
    public javax.swing.JLabel jLabel7;
    public javax.swing.JLabel jLabel8;
    public javax.swing.JLabel jLabel9;
    public javax.swing.JMenu jMLectura;
    public javax.swing.JMenu jMenu1;
    public javax.swing.JMenu jMenu2;
    public javax.swing.JMenu jMenu3;
    public static javax.swing.JMenu jMenu4;
    public javax.swing.JMenu jMenu5;
    public javax.swing.JMenuBar jMenuBar1;
    public javax.swing.JMenuItem jMenuItem1;
    public javax.swing.JMenuItem jMenuItem2;
    public javax.swing.JMenuItem jMenuItem3;
    public javax.swing.JMenuItem jMenuItem4;
    public javax.swing.JPanel jPContenido;
    public javax.swing.JPanel jPMenu;
    public javax.swing.JPanel jPSuperior;
    public javax.swing.JPanel jPanel1;
    public javax.swing.JPanel jPanel10;
    public javax.swing.JPanel jPanel2;
    public javax.swing.JPanel jPanel3;
    public javax.swing.JPanel jPanel4;
    public javax.swing.JPanel jPanel5;
    public javax.swing.JPanel jPanel6;
    public javax.swing.JPanel jPanel7;
    public javax.swing.JPanel jPanel8;
    public javax.swing.JPanel jPanel9;
    public javax.swing.JPopupMenu jPopupMenu1;
    public static javax.swing.JRadioButtonMenuItem jRLActivado;
    public static javax.swing.JRadioButtonMenuItem jRLDesactivado;
    public javax.swing.JPopupMenu.Separator jSeparator1;
    public rojerusan.RSFotoCircle rSUsuario;
    public javax.swing.JMenuItem rutaQR;
    // End of variables declaration//GEN-END:variables
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

    /*
    //Modulo de reporte
        int seleccion = JOptionPane.showOptionDialog(null, "¿Qué reporte desea generar?",
                "seleccione...", JOptionPane.YES_NO_CANCEL_OPTION,
                JOptionPane.QUESTION_MESSAGE, null,// null para icono por defecto.
                new Object[]{"Coming soon...    ", "General"}, "");
        if (seleccion != -1) {
            if (seleccion == 0) {
                //Este reporte se realizo de otra forma, por ende ya no es necesario esta opción en el sistema. 
                //Reporte de tiempos 
                //Cuerpo del algoritmo esta pendiente.
            } else {
                //Reporte general Excel.
                DetalleProyecto obj = new DetalleProyecto();
                crs = obj.generar_Reportes();
                //Ruta de guardado del archivo
                JFileChooser Chocer = new JFileChooser();
                Chocer.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
                Chocer.setLocation(500, 500);
                Chocer.showOpenDialog(this);
                File guardar = Chocer.getSelectedFile();
                //Generar archivo .xlsx
                generarXlsx excel = new generarXlsx();
                if (guardar != null) {
                    if (excel.generarExcel(crs, String.valueOf(guardar))) {//Información y ruta de guardado.
                        //Documento creado correctamente
                        new rojerusan.RSNotifyAnimated("Listo!", "El reporte General de producción fue creado exitosamente.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.SUCCESS).setVisible(true);
                    } else {
                        //Error al crear el documento
                        new rojerusan.RSNotifyAnimated("¡Error!", "No puedo crear el reporte General.", 7, RSNotifyAnimated.PositionNotify.BottomRight, RSNotifyAnimated.AnimationNotify.BottomUp, RSNotifyAnimated.TypeNotify.ERROR).setVisible(true);
                    }
                }
            }
        }
     */
}
