package Controlador;

import java.awt.Cursor;
import javax.sql.rowset.CachedRowSet;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JRadioButton;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class Tabla {

    private boolean[] editable = {false, false, false, false, false, false, false, false, false, false, false, false,true};//Que celdas son editables
    private static int detalle = 0, area = 0;
    private CachedRowSet crs = null;

    //Se encarga de generar la tabla con la informacion traida de la base de datos
    public void visualizar(JTable tabla, int detalle, int area) {
        this.detalle = detalle;
        this.area = area;
        tabla.setDefaultRenderer(Object.class, new Render(7));
        //                         1            2              3           4                5                    6                   7               8              9                   10                    11              12      13         14            15         16                       
        String encabezado[] = {"Proceso", "Fecha inicio", "Fecha fin", "Restante", "Procesadas", "Tiempo total min", "Tiempo unidad min", "Estado", "Hora de ejecución", "Tiempo Ejecución", "Hora de Terminación", "N°OP", "Orden", "Reiniciar", "IDdetalle", "Tiempo"};
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
        // ...
        try {
            crs = consuldateDetalleProduccion();
            boolean estadoDetalleP=consultarEstadoDetalleProyecto();
            while (crs.next()) {
                JButton btn = new JButton("Reiniciar");
                JButton tiempo = new JButton("Tiempo");
//                btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
                v[0] = crs.getString("nombre_proceso");//Nombre del proceso
                v[1] = crs.getString("inicio");//Fecha en que se inicio el proceso
                v[2] = crs.getString("fin");//Fecha en que se termino el proceso
                v[3] = crs.getString("cantidadProceso");//Cantidades restantes <- Pendiente revisar
                v[4] = crs.getInt("cantidad_terminada");//Cantidad total Procesada
                v[5] = crs.getString("tiempo_total_por_proceso");//Tiempo total del proceso en minutos
                v[6] = crs.getString("tiempo_por_unidad");//Tiempo total del proceso por unidad en minutos
                v[7] = clasificarEstado(crs.getInt("estado"));//Estado del producto
                v[8] = crs.getString("horaInicio");//Hora en que se empezo a ejecutar el proceso
                if (crs.getString("InicioTerminadoIntervalo") != null) {//Tiempo de ejecucion del proceso
                    v[9] = crs.getString("InicioTerminadoIntervalo");
                } else {
                    v[9] = crs.getString("tiempoActual");
                }
                v[10] = crs.getString("hora_terminacion");//Hora en que se termino de ejecutar el proceso
                v[11] = crs.getString("noperarios");//Numero de operarios
                v[12] = crs.getInt(13);//Orden de ejecucion de los procesos
                v[13] = btn;//Este boton se utiliza para que el administrador pueda reiniciar la toma de tiempo de los procesos de  FE/TE/EN
                v[14] = crs.getInt(12); //IDDetalle <- No recibe el nombre de la columna
                v[15] = tiempo;//Este boton se utiliza para parar el tiempo de los procesos de almacen.
                if(area==3 || area==2){//Seleccion del primer proceso
                      JRadioButton inicio= new JRadioButton();
                      inicio.setEnabled(estadoDetalleP);//El estado me lo retorna la base de datos
                      inicio.setActionCommand(crs.getString(12)+"-"+detalle);//ID del proceso de ensamble-ID detalle del proyecto de ensamble
                      if(crs.getInt(13) == 0){
                          //Desactivado el Radio Button
                          inicio.setSelected(false);
                      }else{
                          //Activdo el Radio Button
                          inicio.setSelected(true);
                      }
                      inicio.setCursor(new Cursor(Cursor.HAND_CURSOR));
                      grupo.add(inicio);
                    //
                    v[12] =  inicio;
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
    
    //Se encarga de traer la informacion de la base de datos
    private CachedRowSet consuldateDetalleProduccion() {
        DetalleProyecto obj = new DetalleProyecto();
        return obj.consultarDetalleProduccion(detalle, area);
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
