package Controlador;

import com.barcodelib.barcode.a.j;
import java.awt.Cursor;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;

public class Tabla {

    private boolean[] editable = {false, false, false, false, false, false, false, false, false, false, false, false,true};//Que celdas son editables
    private static int detalle = 0, negocio = 0;
    private CachedRowSet crs = null;

    //Se encarga de generar la tabla con la informacion traida de la base de datos
    public void visualizar(JTable tabla, int detalle, int negocio) {
        this.detalle = detalle;
        this.negocio = negocio;
        tabla.setDefaultRenderer(Object.class, new Render(7));
        String encabezado[] = {"Proceso", "Fecha inicio", "Fecha fin", "Restante", "Cantidad procesada", "Tiempo total min", "Tiempo unidad min", "Estado", "Hora de ejecución", "Tiempo Ejecución", "Hora de Terminación", "N°OP", "Reiniciar", "IDdetalle", "Tiempo","Orden"};
        DefaultTableModel ds = new DefaultTableModel(null, encabezado) {

            Class[] types = new Class[]{
                java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class,
                java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class, java.lang.Object.class};

            public Class getColumnClass(int columnIndex) {
                return types[columnIndex];
            }

            public boolean isCellEditable(int row, int column) {
                return editable[column];
            }
        };

        ButtonGroup grupo=new ButtonGroup();
        Object v[] = new Object[16];
        
        try {
            crs = consuldateDetalleProduccion();
            boolean estadoDetalleP=consultarEstadoDetalleProyecto();
            while (crs.next()) {
                JButton btn = new JButton("Reiniciar");
                JButton tiempo = new JButton("Tiempo");
//                btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
                v[0] = crs.getString(1);//Nombre del proceso
                v[1] = crs.getString(2);//Fecha en que se inicio el proceso
                v[2] = crs.getString(3);//Fecha en que se termino el proceso
                v[3] = negocio != 4 ? crs.getString(negocio==3?17:13) : "0";//Cantidades restantes
                v[4] = String.valueOf(crs.getInt(4));//Cantidad total Procesada
                v[5] = crs.getString(5);//Tiempo total del proceso en minutos
                v[6] = crs.getString(6);//Tiempo total del proceso por unidad en minutos
                v[7] = crs.getString(7);//Estado del producto
                v[8] = crs.getString(8);//Hora en que se empezo a ejecutar el proceso
                if (crs.getString(11) != null) {//Tiempo de ejecucion del proceso
                    v[9] = crs.getString(11);
                } else {
                    v[9] = crs.getString(9);
                }
                v[10] = crs.getString(10);//Hora en que se termino de ejecutar el proceso
                v[11] = negocio != 4 ? crs.getString(14) : "0";//Numero de operarios---
                v[12] = btn;//Este boton se utiliza para que el administrador pueda reiniciar la toma de tiempo de los procesos de  FE/TE/EN
                v[13] = crs.getString(12);//IDDetalle
                v[14] = tiempo;//Este boton se utiliza para parar el tiempo de los procesos de almacen.
                if(negocio==3){//Seleccion del primer proceso
                      JRadioButton inicio= new JRadioButton();
                      inicio.setEnabled(estadoDetalleP);//El estado me lo retorna la base de datos
                      inicio.setActionCommand(crs.getString(16)+"-"+detalle);//ID del proceso de ensamble-ID detalle del proyecto de ensamble
                      if(Integer.parseInt(crs.getString(15))==0){
                          //Desactivado el Radio Button
                          inicio.setSelected(false);
                      }else{
                          //Activdo el Radio Button
                          inicio.setSelected(true);
                      }
                      inicio.setCursor(new Cursor(Cursor.HAND_CURSOR));
                      grupo.add(inicio);
                    //
//                    v[15] = Integer.parseInt(crs.getString(15));//Columna de orden
                    v[15] = inicio;
//                    v[16] = crs.getInt(16);//ID del detalle del proceso de ensamble
                }
                ds.addRow(v);//Filas de la tabla
            }
            tabla.setModel(ds);
//            FormatoTabla ft = new FormatoTabla(6);
//            tabla.setDefaultRenderer(Object.class, ft);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error!" + e);
        }
    }

    //Se encarga de traer la informacion de la base de datos
    private CachedRowSet consuldateDetalleProduccion() {
        DetalleProyecto obj = new DetalleProyecto();
        return obj.consultarDetalleProduccion(detalle, negocio);
    }
    
    //Consultar el estado del detalle del proyecto
    private boolean consultarEstadoDetalleProyecto(){
        DetalleProyecto obj = new DetalleProyecto();
        return obj.consultarEstadoDetalleProyecto(detalle);
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
}
