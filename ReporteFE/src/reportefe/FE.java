/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reportefe;

//import java.util.logging.Level;
//import java.util.logging.Logger;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;
//import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author acomercial05
 */
public class FE extends javax.swing.JFrame implements Runnable {

    /**
     * Creates new form FE
     */
    public FE() {
        if (soloUnaVez == 0) {
            initComponents();
            this.setTitle("Informe de Formato Estandar");
            this.setIconImage(new ImageIcon(getClass().getResource("/img/FE.png")).getImage());
            this.setExtendedState(FE.MAXIMIZED_BOTH);
            //Hilo de ejecución
            informe.start();
            //...
            jTReporte.getTableHeader().setReorderingAllowed(false);
            //...
            DisponibilidadConexion conexion = new DisponibilidadConexion();
            Thread conc = new Thread(conexion);
            conc.start();
        }
        soloUnaVez = 1;
    }
    //Variables
    CachedRowSet crs = null;
    int rep = 0, cantFinal = 0, cantidadProyecto = 0, entro = 0;
    int cantidadRestante = 0, cantidadPasada = 0;
    String tipo_negocio = "", producto1 = "", Orden1 = "";
    Object v[] = new Object[26];
    String NamesOrden[] = new String[5];
    static int soloUnaVez = 0;
    int P = 0, Q = 0, C = 0, CTH = 0, QUE = 0, S = 0, E = 0, C2 = 0, R = 0, M = 0;
    Thread informe = new Thread(this);//Hilo
    Object cantidadProceso[] = new Object[26];
    //Variables de conexion a la base de datos
    public static String IP = "192.168.4.1:3306";
    public static String user = "juanDavidM";
    public static String pass = "123";
    //Hilo de ejecución:
    @Override
    public void run() {
        ejecutarInforme();
    }

    private void ejecutarInforme() {
        while (true) {
            cargarTablaInformeFE();
            try {
                System.gc();//Garbaje colector
                Thread.sleep(500);//Se actualizara cada medio segundo
            } catch (InterruptedException ex) {
//                Logger.getLogger(FE.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    /* Indices del vector
                    subs_POS
                    -subP=5;
                    -subC=7;
                    -subQ=9;
                    -subQue=11;
                    -subCTH=13;
                    -subS=15;
                    -subE=17;
                    -subC2=19;
                    -subR=21;
                    -subM=23;
                    
                    Procesos_POS
                    -P=6;
                    -C=8;
                    -Q=10;
                    -Que=12;
                    -CTH=14;
                    -S=16;
                    -E=18;
                    -C2=20;
                    -R=22;
                    -M=24;
     */
    private void cargarTablaInformeFE() {
        //                                                                              6                     8                    10                   12                   14                  16                  18                  20            22                    24   
        String names[] = {"N°Orden", "M.T", "Tipo", "Cant", "TipoNegocio", "sub_P", "Perforado", "sub_Q", "Quimicos", "sub_C", "Caminos", "sub_Que", "Quemado", "sub_CTH", "C.C.TH", "sub_S", "Screen", "sub_E", "Estañado", "sub_C2", "C2", "sub_R", "Ruteo", "sub_M", "Maquinas", "PNC"};
        //...
        //Pie de la lista
        cantidadProceso[0] = "Total";
        for (int i = 1; i <= 4; i++) {
            cantidadProceso[i] = "------";
        }
        //Fin del pie de la lista
        //Cantidades por columna---
        for (int i = 0; i < 10; i++) {
            cantidadProceso[6 + (i + i)] = 0;
            cantidadProceso[5 + (i + i)] = 1;
        }
        //...
        DefaultTableModel df = new DefaultTableModel(null, names);
        ProyectoController obj = new ProyectoController();
        try {
            crs = obj.consultarProceso();
            while (crs.next()) {
                //...
                entro++;
                if (rep == 0) {//Se puede cambiar la información principal
                    reinicializarVector(crs);//Se vuleve a poner el vector en estado base
                    rep = 1;
                } else {
                    if (v[4].toString().equals(crs.getString(4)) && v[0].toString().equals(crs.getString(1)) && v[25].toString().equals(crs.getString(9) == null ? "-" : crs.getString(9))) {//Tipo de producto && Numero de orden && Producto no conforme
                        rep = 1;
                    } else {
                        organizarVector();
                        cantidadProyecto++;
                        df.addRow(v);//Información del proyecto
                        //Estado inicial del proyecto
                        reinicializarVector(crs);//Se vuleve a poner el vector en estado base
                    }
                }
                if (v[4].toString().equals(crs.getString(4)) && v[0].toString().equals(crs.getString(1)) && v[25].toString().equals(crs.getString(9) == null ? "-" : crs.getString(9))) {//Numero de orden
                    //Se valida que el nuevo numero de la orden se agrege solo una sola vez al vector
                    cantidadRestante = 0;
                    cantidadPasada = 0;
                    switch (crs.getInt(7)) {
                        case 1://Perforado
                            v[5] = crs.getInt(8);//Estado del perforado
                            cantidadRestante = crs.getInt(5) - crs.getInt(6);//Cantidad Total - Cantidad Terminada Proceso.
                            cantidadPasada = crs.getInt(5) - cantidadRestante;//Cantidad Total- Cantidad Restante Proceso
                            v[6] = cantidadRestante;//Perforado
                            v[8] = cantidadPasada;//Quimicos
                            break;
                        case 2://Quimicos
                            v[7] = crs.getInt(8);//Estado de quimicos
                            //...
                            v[10] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 3://Caminos
                            v[9] = crs.getInt(8);//Estado de Caminos
                            //...
                            v[12] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 4://Quemado
                            v[11] = crs.getInt(8);//Estado de C.C.TH
                            //...
                            v[14] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 5://C.C.TH
                            v[13] = crs.getInt(8);//Estado de quemado
                            //...
                            v[16] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 6://Screen
                            v[15] = crs.getInt(8);//Estado de Screen
                            //...
                            v[18] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 7://Estañado
                            v[17] = crs.getInt(8);//Estado de Estañado
                            //...
                            v[20] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 8://C2
                            v[19] = crs.getInt(8);//Estado de C2
                            //...
                            v[22] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 9://Ruteo
                            v[21] = crs.getInt(8);//Estado de ruteo
                            //...
                            v[24] = crs.getInt(6);//Cantidad que se le pasa al siguiente proceso
                            break;
                        case 10://Maquinas
                            v[23] = crs.getInt(8);//Estado de maquinas
                            //...
                            cantFinal = crs.getInt(6);
                            break;
                    }
                }
            }
            //Solo se ejecutara si por lo menos ingreso una vez en el loop while.
            if (entro != 0) {
                organizarVector();
                cantidadProyecto++;
                df.addRow(v);//Información del proyecto
                cantidadProceso[25] = "------";
                cantidadProceso[1] = cantidadProyecto;//Cantidad total de proyectos en el área de producción.
                df.addRow(cantidadProceso);
                for (int i = 0; i < 10; i++) {
                    cantidadProceso[6 + (i + i)] = 0;
                    cantidadProceso[5 + (i + i)] = 1;
                }
                jTReporte.setModel(df);
                jTReporte.setDefaultRenderer(Object.class, new Tabla());
            }
            //Se ejecutara siempre, no importa si entro o no entro al loop.
            columnasOcultas();
            rep = 0;
            cantFinal = 0;
            cantidadProyecto = 0;
            crs.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);//Salta error
        }
    }

    private void columnasOcultas() {
        //Sub proces------------------------------------------------------------
        //tipo de proyecto
        jTReporte.getColumnModel().getColumn(2).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(2).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(2).setMinWidth(0);
        //Perforado
        jTReporte.getColumnModel().getColumn(5).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(5).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(5).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(5).setMinWidth(0);
        //Quimicos
        jTReporte.getColumnModel().getColumn(7).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(7).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(7).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(7).setMinWidth(0);
        //Caminos
        jTReporte.getColumnModel().getColumn(9).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(9).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(9).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(9).setMinWidth(0);
        //C.C.TH
        jTReporte.getColumnModel().getColumn(11).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(11).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(11).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(11).setMinWidth(0);
        //Quemado
        jTReporte.getColumnModel().getColumn(13).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(13).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(13).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(13).setMinWidth(0);
        //Screen
        jTReporte.getColumnModel().getColumn(15).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(15).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(15).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(15).setMinWidth(0);
        //Estañado
        jTReporte.getColumnModel().getColumn(17).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(17).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(17).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(17).setMinWidth(0);
        //C2
        jTReporte.getColumnModel().getColumn(19).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(19).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(19).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(19).setMinWidth(0);
        //Ruteo
        jTReporte.getColumnModel().getColumn(21).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(21).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(21).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(21).setMinWidth(0);
        //Maquinas
        jTReporte.getColumnModel().getColumn(23).setMinWidth(0);
        jTReporte.getColumnModel().getColumn(23).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(23).setMaxWidth(0);
        jTReporte.getTableHeader().getColumnModel().getColumn(23).setMinWidth(0);
        //PNC
        jTReporte.getColumnModel().getColumn(25).setMinWidth(60);
        jTReporte.getColumnModel().getColumn(25).setMaxWidth(60);
        jTReporte.getTableHeader().getColumnModel().getColumn(25).setMaxWidth(60);
        jTReporte.getTableHeader().getColumnModel().getColumn(25).setMinWidth(60);
        //Fin de sub procesos---------------------------------------------------
        //Modifica el tamaño de las columnas de la tabla
//        //Numero de orden
//        jTReporte.getColumnModel().getColumn(0).setMinWidth(90);
//        jTReporte.getColumnModel().getColumn(0).setMaxWidth(90);
//        jTReporte.getTableHeader().getColumnModel().getColumn(0).setMaxWidth(90);
//        jTReporte.getTableHeader().getColumnModel().getColumn(0).setMinWidth(90);
//        //Material
//        jTReporte.getColumnModel().getColumn(1).setMinWidth(50);
//        jTReporte.getColumnModel().getColumn(1).setMaxWidth(50);
//        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMaxWidth(50);
//        jTReporte.getTableHeader().getColumnModel().getColumn(1).setMinWidth(50);
//        //Cantidad todal
//        jTReporte.getColumnModel().getColumn(3).setMinWidth(98);
//        jTReporte.getColumnModel().getColumn(3).setMaxWidth(98);
//        jTReporte.getTableHeader().getColumnModel().getColumn(3).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(3).setMinWidth(100);
//        //Tipo de negocio
//        jTReporte.getColumnModel().getColumn(4).setMinWidth(130);
//        jTReporte.getColumnModel().getColumn(4).setMaxWidth(130);
//        jTReporte.getTableHeader().getColumnModel().getColumn(4).setMaxWidth(130);
//        jTReporte.getTableHeader().getColumnModel().getColumn(4).setMinWidth(130);
//        //Perforado
//        jTReporte.getColumnModel().getColumn(6).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(6).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(6).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(6).setMinWidth(100);
//        //Quimicos
//        jTReporte.getColumnModel().getColumn(8).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(8).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(8).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(8).setMinWidth(100);
//        //Caminos
//        jTReporte.getColumnModel().getColumn(10).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(10).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(10).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(10).setMinWidth(100);
//        //Quemado
//        jTReporte.getColumnModel().getColumn(12).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(12).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(12).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(12).setMinWidth(100);
//        //C.C.TH
//        jTReporte.getColumnModel().getColumn(14).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(14).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(14).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(14).setMinWidth(100);
//        //Screen
//        jTReporte.getColumnModel().getColumn(16).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(16).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(16).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(16).setMinWidth(100);
//        //Estañado
//        jTReporte.getColumnModel().getColumn(18).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(18).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(18).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(18).setMinWidth(100);
//        //C2
//        jTReporte.getColumnModel().getColumn(20).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(20).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(20).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(20).setMinWidth(100);
//        //Ruteo
//        jTReporte.getColumnModel().getColumn(22).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(22).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(22).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(22).setMinWidth(100);
//        //Maquinas
//        jTReporte.getColumnModel().getColumn(24).setMinWidth(100);
//        jTReporte.getColumnModel().getColumn(24).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(24).setMaxWidth(100);
//        jTReporte.getTableHeader().getColumnModel().getColumn(24).setMinWidth(100);
    }

    private void organizarVector() {
        int cantidadPasada = 0, prceso = 8, subProceso = 7;
        //Dependiendo del proceso se organizan las cantidades
        if (v[0].toString().equals("29649")) {
            rep = rep;
        }
        if (v[4].toString().equals("Troquel") || v[4].toString().equals("Repujado")) {//Se pasan la cantidad de productos de perforado a quemado
            v[12] = v[8];
            v[8] = 0;
        } else {
            //Primeros saltos de procesos "parte numero 1"
            //------------------------------------------------------------------
            if (v[7].toString().equals("-1")) {//Cuando no lleva quimicos
                v[10] = v[8];
                v[8] = 0;
            }
            if (v[15].toString().equals("-1")) {//Cuendo no lleva Screen.
                v[18] = v[16];
                v[16] = 0;
            }
            if (v[21].toString().equals("-1")) {//Cuando no lleva ruteo
                v[24] = v[22];
                v[22] = 0;
            }
            //------------------------------------------------------------------
        }
        //----------------------------------------------------------------------
        for (int i = 0; i < 9; i++) {//Se va a repetir la cantidad de procesos totales
            //...
            if (prceso == 24) {
                v[prceso] = Integer.parseInt(v[prceso].toString()) - cantFinal;
                cantFinal = 0;
            } else {
                if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
                    //Si se cumple la condición se va a realizar el salto al siguiente proceso y se efectuara la resta con ese proceso.
                    if ((prceso == 14 && v[15].toString().equals("-1")) || (prceso == 20 && v[21].toString().equals("-1"))) {//Control calidad TH
                        //De control calidad salta a estañado o de control calida 2 salta a maquinas.
                        cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 4].toString());//Se restan las cantidades saltando un proceso
                        v[prceso] = cantidadPasada;
                    } else {
                        cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Se restan las cantidades
                        v[prceso] = cantidadPasada;
                    }
                }
            }
            //...
            prceso += 2;
            subProceso += 2;
        }
        if ((v[4].toString().equals("Troquel") || v[4].toString().equals("Repujado") || v[4].toString().equals("Stencil"))) {//Se valida que el troquel y el repujado no pasen más cantidades.
            v[14] = 0;//CTH
        }
        //Reinicialización de variables
        prceso = 8;
        subProceso = 7;
        //Esto ya no es necesario para el funcionamiento del sistema
        //Esto hace parte de los saltos de procesos. "Parte numero 2"
        //----------------------------------------------------------------------
//        if (v[15].toString().equals("-1")) {//Cuendo no lleva Screen.
//            v[16] = 0;
//        }
//        if (v[21].toString().equals("-1")) {//Cuando no lleva ruteo
//            v[22] = 0;
//        }
        //----------------------------------------------------------------------
        /* Indices del vector
                    subs_POS
                    -subP=5;
                    -subC=7;
                    -subQ=9;
                    -subQue=11;
                    -subCTH=13;
                    -subS=15;
                    -subE=17;
                    -subC2=19;
                    -subR=21;
                    -subM=23;
                    
                    Procesos_POS
                    -P=6;
                    -C=8;
                    -Q=10;
                    -Que=12;
                    -CTH=14;
                    -S=16;
                    -E=18;
                    -C2=20;
                    -R=22;
                    -M=24;
         */
//        if ((v[4].toString().equals("PCB") || v[4].toString().equals("Circuito")) && v[1].toString().equals("TH")) {//Circuito o PCB TH
//            //------------------------------------------------------------------------
//            for (int i = 0; i < 8; i++) {
//                if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
//                    cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Cantidad que tiene Quimicos
//                    v[prceso] = cantidadPasada;//Se asigna la cantidad a Quimicos
//                }
//                prceso += 2;
//                subProceso += 2;
//            }
//            prceso = 8;
//            subProceso = 7;
//            //------------------------------------------------------------------------
//        } else if (v[4].toString().equals("Circuito") && v[1].toString().equals("FV")) {//Circuito FV
//            for (int i = 0; i < 8; i++) {
//                if (!v[subProceso].toString().equals("-1") && !v[subProceso].toString().equals("1")) {//Todos los sub
//                    cantidadPasada = Integer.parseInt(v[prceso].toString()) - Integer.parseInt(v[prceso + 2].toString());//Cantidad que tiene Quimicos
//                    v[prceso] = cantidadPasada;//Se asigna la cantidad a Quimicos
//                }
//                prceso += 2;
//                subProceso += 2;
//            }
//            prceso = 8;
//            subProceso = 7;
//        }
        cantidadProceso[6] = Integer.parseInt(v[6].toString()) + Integer.parseInt(cantidadProceso[6].toString());//Perforado
        cantidadProceso[8] = Integer.parseInt(v[8].toString()) + Integer.parseInt(cantidadProceso[8].toString());//Quimicos
        cantidadProceso[10] = Integer.parseInt(v[10].toString()) + Integer.parseInt(cantidadProceso[10].toString());//Caminos
        cantidadProceso[12] = Integer.parseInt(v[12].toString()) + Integer.parseInt(cantidadProceso[12].toString());//Quemado
        cantidadProceso[14] = Integer.parseInt(v[14].toString()) + Integer.parseInt(cantidadProceso[14].toString());//Control TH
        cantidadProceso[16] = Integer.parseInt(v[16].toString()) + Integer.parseInt(cantidadProceso[16].toString());//Screen
        cantidadProceso[18] = Integer.parseInt(v[18].toString()) + Integer.parseInt(cantidadProceso[18].toString());//Estañado
        cantidadProceso[20] = Integer.parseInt(v[20].toString()) + Integer.parseInt(cantidadProceso[20].toString());//C2
        cantidadProceso[22] = Integer.parseInt(v[22].toString()) + Integer.parseInt(cantidadProceso[22].toString());//Ruteo
        cantidadProceso[24] = Integer.parseInt(v[24].toString()) + Integer.parseInt(cantidadProceso[24].toString());//Maquinas
    }

    private void reinicializarVector(CachedRowSet crs) {
        try {
            v[0] = crs.getString(1);//Numero de orden
            v[1] = crs.getString(2);//Material
            v[2] = crs.getString(3);//Tipo(Normal,Quick,RQT)
            v[3] = crs.getString(5);//Cantidad total del proyecto
            v[4] = crs.getString(4);//Tipo de negocio
            v[25] = crs.getString(9) == null ? "-" : crs.getString(9);//Producto no conforme
            //Procesoscrs.getString(9).
            v[6] = 0;
            v[8] = 0;
            v[10] = 0;
            v[12] = 0;
            v[14] = 0;
            v[16] = 0;
            v[18] = 0;
            v[20] = 0;
            v[22] = 0;
            v[24] = 0;
            //sub en estado por iniciar
            v[5] = -1;
            v[7] = -1;
            v[9] = -1;
            v[11] = -1;
            v[13] = -1;
            v[15] = -1;
            v[17] = -1;
            v[19] = -1;
            v[21] = -1;
            v[23] = -1;

        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error: " + e);
        }
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTReporte = new reportefe.MyRender();
        jTtipo2 = new javax.swing.JLabel();
        jTtipo3 = new javax.swing.JLabel();
        jTtipo4 = new javax.swing.JLabel();
        jTtipo5 = new javax.swing.JLabel();
        jTtipo6 = new javax.swing.JLabel();
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
                {null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null}
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

        jTtipo6.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jTtipo6.setForeground(new java.awt.Color(128, 128, 131));
        jTtipo6.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jTtipo6.setIcon(new javax.swing.ImageIcon(getClass().getResource("/img/iconmonstr-shape-19-16 (4).png"))); // NOI18N
        jTtipo6.setText("N/A");

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
                        .addGap(30, 30, 30)
                        .addComponent(jButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLConexion, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(5, 5, 5)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTtipo6, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 462, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTtipo6, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTtipo2, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo4, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo5, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTtipo3, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTtipo7, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLConexion, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton1))
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
    private javax.swing.JButton jButton1;
    public static javax.swing.JLabel jLConexion;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTReporte;
    private javax.swing.JLabel jTtipo2;
    private javax.swing.JLabel jTtipo3;
    private javax.swing.JLabel jTtipo4;
    private javax.swing.JLabel jTtipo5;
    private javax.swing.JLabel jTtipo6;
    private javax.swing.JLabel jTtipo7;
    private javax.swing.JLabel jTtipo8;
    private javax.swing.JLabel jTtipo9;
    // End of variables declaration//GEN-END:variables

}
