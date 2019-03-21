package Controlador;

import java.io.File;
import java.util.ArrayList;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class generarXlsx {

    public generarXlsx(){
        
    }
    
    public boolean generarExcel(CachedRowSet crs, String ruta) {
        try {
            WorkbookSettings conf = new WorkbookSettings();
            conf.setEncoding("ISO-8859-1");
            WritableWorkbook woorBook = Workbook.createWorkbook(new File(ruta + "\\ReporteGeneral.xls"));//se busca la ruta para generar el archivo xls.
//
            WritableSheet sheet = woorBook.createSheet("Reporte General", 0);//se crea el archivo xls
            WritableFont h = new WritableFont(WritableFont.COURIER, 16, WritableFont.NO_BOLD);//Se da un formato al tipo de letra con el que se va a escribir sobre la hoja
//            h.setColour(Colour.BLUE);
            WritableCellFormat hFormat = new WritableCellFormat(h);//Se da formato a cada letra
//
            int i = 0;
            //Numero de orden
            sheet.addCell(new jxl.write.Label(0, i, "Numero de orden", hFormat));
            //Nombre del cliente
            sheet.addCell(new jxl.write.Label(1, i, "Nombre del cliente", hFormat));
            //Nombre del proyecto
            sheet.addCell(new jxl.write.Label(2, i, "Nombre del proyecto", hFormat));
            //Cantidad
            sheet.addCell(new jxl.write.Label(3, i, "Cantidad", hFormat));
            //Área de negocio
            sheet.addCell(new jxl.write.Label(4, i, "Área", hFormat));
            //Tipo negocio
            sheet.addCell(new jxl.write.Label(5, i, "Tipo de negocio", hFormat));
            //Tiempo total unidad 
            sheet.addCell(new jxl.write.Label(6, i, "Timepo total unidad", hFormat));
            //Timepo total
            sheet.addCell(new jxl.write.Label(7, i, "Timepo total", hFormat));
            i++;
            while (crs.next()) {
                //Numero de orden
                sheet.addCell(new jxl.write.Label(0, i, crs.getString(1), hFormat));
                //Nombre del cliente
                sheet.addCell(new jxl.write.Label(1, i, crs.getString(2), hFormat));
                //Nombre del proyecto
                sheet.addCell(new jxl.write.Label(2, i, crs.getString(3), hFormat));
                //Cantidad
                sheet.addCell(new jxl.write.Label(3, i, crs.getString(4), hFormat));
                //Área de negocio
                sheet.addCell(new jxl.write.Label(4, i, crs.getString(5), hFormat));
                //Tipo negocio
                sheet.addCell(new jxl.write.Label(5, i, crs.getString(6), hFormat));
                //Tiempo total unidad 
                sheet.addCell(new jxl.write.Label(6, i, crs.getString(7), hFormat));
                //Timepo total
                sheet.addCell(new jxl.write.Label(7, i, crs.getString(8), hFormat));
                i++;
            }

//            for (int i = 0; i < info.length; i++) {
//                for (int j = 0; j < info.length; j++) {
//                    sheet.addCell(new jxl.write.Label(i, j, info[i][j], hFormat));
//                }
//            }
            woorBook.write();

            woorBook.close();
            return true;
        } catch (Exception e) {
            return false;
        }

    }
    
    public boolean generarReporteTiemposAreaProduccion(CachedRowSet crs, String ruta, int area, String fechaI, String fechaF){
        try {
            WorkbookSettings conf = new WorkbookSettings();
            conf.setEncoding("ISO-8859-1");
            WritableWorkbook woorBook = Workbook.createWorkbook(new File(ruta + "\\ReporteTiempoArea_"+ clasificarAreaProduccion(area) +".xls"));//se busca la ruta para generar el archivo xls.
            // ...
            WritableSheet sheet = woorBook.createSheet("Reporte Tiempos Área", 0);//se crea el archivo xls <- Asignarle un nombre por cada área de producción (FE, TE o EN)
            WritableFont h = new WritableFont(WritableFont.ARIAL, 16, WritableFont.NO_BOLD);//Se da un formato al tipo de letra con el que se va a escribir sobre la hoja
//          h.setColour(Colour.BLUE);
            WritableCellFormat hFormat = new WritableCellFormat(h);//Se da formato a cada letra
            // ...
            //Encabezado columnas
            int x = 0, y=0, accion=0, cantP=0, cantidadProceso=0, cantidadProyecto=0, cantTerminada=0;
            // ...
            String opNew="",opOld="",prodNew="",prodOld="";
            //Fechas de inicio y de fin del reporte de tiempo de producción. 
            sheet.addCell(new jxl.write.Label(0, y, "Fecha Inicio", hFormat));
            sheet.addCell(new jxl.write.Label(1, y, fechaI, hFormat));
            // ...
            sheet.addCell(new jxl.write.Label(3, y, "Fecha Fin", hFormat));
            sheet.addCell(new jxl.write.Label(4, y, fechaF, hFormat));
            y++;
            //...
            //Numero de orden
            sheet.addCell(new jxl.write.Label(x, y, "Numero de orden", hFormat));
            x++;
            //Cantidad del proyecto
            sheet.addCell(new jxl.write.Label(x, y, "Cantidad", hFormat));
            // ...
            if (area == 1) {// Área de formato estandar - FE
                //Nombre del Tipo de producto
                x++;
                sheet.addCell(new jxl.write.Label(x, y, "Producto", hFormat));
            }
            // ...
            Condicion_producto proc=new Condicion_producto();// Pendiente revisar <-----
            //Consultar los nombre de los procesos del área...
            CachedRowSet crsP=proc.consultarProcesos(area);
            ArrayList<String> nombreProcesos=new ArrayList<String>();//Nombre de todos los proceso del área
            //Posicionar procesos en el excel
            x++;
            while (crsP.next()) {                
                //Procesos del área seleccionada
                nombreProcesos.add(crsP.getString("nombre_proceso"));
                sheet.addCell(new jxl.write.Label(x, y, crsP.getString("nombre_proceso"), hFormat));
                x++;
            }
            cantP = nombreProcesos.size();
            // Tiempo Total de la orden
            sheet.addCell(new jxl.write.Label(x, y, "Tiempo Total", hFormat));
            x++;
            // Total tiempo unidad
            sheet.addCell(new jxl.write.Label(x, y, "Tiempo Total Unidad", hFormat));
            x++;
            // Estado del proyecto
            sheet.addCell(new jxl.write.Label(x, y, "Estado", hFormat));
            x++;
            // Cantidad terminada del proyecto
            sheet.addCell(new jxl.write.Label(x, y, "Terminado", hFormat));
            x++;
            // Restantes
            sheet.addCell(new jxl.write.Label(x, y, "Restantes", hFormat));
            x++;
            // Fecha en que se termino el proyecto.
            sheet.addCell(new jxl.write.Label(x, y, "Fecha Terminacion", hFormat));
            x++;
            //Fecha en la que termino empaque de procesar por ultima vez (ultimo proceso por el cual pasa el proceso)
//            sheet.addCell(new jxl.write.Label(x, y, "Fecha T.empaque", hFormat));
//            x++; // Esta pendiente por definir
            //...
            y++;
            int columnasIniciales = (area==1?3:2);
            while(crs.next()){
                //
                if(accion == 0){
                    //Numero de orden
                    sheet.addCell(new jxl.write.Label(0, y, crs.getString("numero_orden"), hFormat));
                    //Cantidade totales del proyecto
                    cantidadProyecto = crs.getInt("canitadad_total");
                    sheet.addCell(new jxl.write.Label(1, y, String.valueOf(cantidadProyecto), hFormat));
                    //Nombre del Tipo de producto
                    if(area == 1){
                        sheet.addCell(new jxl.write.Label(2, y,crs.getString("nombre"), hFormat));
                    }
                    //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                    sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso")) + columnasIniciales,y, crs.getString("tiempo_total_por_proceso"), hFormat));
                    //Tiempo total de desarrollo del proyecto
                    sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, crs.getString("tiempo_total"), hFormat));
                    // Tiempo Total Unidad
                    sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, crs.getString("Total_timepo_Unidad"), hFormat));
                    // Estado del proyecto
                    sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, clasificacionEstado(crs.getString("estado")), hFormat));
                    // Fecha en que se termino de procesar el proyecto
                    sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+2, y, crs.getString("fecha_salida"), hFormat));
                    // ...
                    // Cantidad total que poseé el proceso
                    cantidadProceso+= crs.getInt("cantidadProceso");
                    //Viejo numero de orden seleccionado
                    opOld=crs.getString("numero_orden");
                    //Viejo producto seleccionado
                    prodOld=(area==1?crs.getString("nombre"):"");
                    accion=1;
                    columnasIniciales = (area==1?3:2);
                }else{
//                  columnasIniciales = (area == 1 ? 3 : 2);
                    opNew=crs.getString(1);//Nuevo numero de orden seleccionado
                    prodNew=(area==1?crs.getString("nombre"):"");//Nuevo producto seleccionado
                    //...
                    if (validacionDeProducto(area,opNew,opOld,prodNew,prodOld)) {
                        columnasIniciales = (area == 1 ? 3 : 2);
                        //Realiza las mismas acciones sobre la misma fila
                        opOld=opNew;//El nuevo numero de orden pasa a ser el viejo numero de orden
                        prodOld=prodNew;
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso"))+columnasIniciales,y, crs.getString("tiempo_total_por_proceso"), hFormat));
                        // Cantidad total que poseé el proceso
                        cantidadProceso+= crs.getInt("cantidadProceso");
                    } else {
                        columnasIniciales = (area == 1 ? 3 : 2);
                        //Cantidad terminada
                        cantTerminada = cantidadProyecto - cantidadProceso;
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+3, y, String.valueOf(cantTerminada), hFormat));
                        cantidadProceso = 0;
                        //Cantidad restante
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+4, y, String.valueOf(cantidadProyecto - cantTerminada), hFormat));
                        //Salta a la siguiente fila y sigue realizando el mismo proceso de ubiación...
                        y++;
                        //Numero de orden
                        sheet.addCell(new jxl.write.Label(0, y, crs.getString("numero_orden"), hFormat));
                        //Cantidade totales del proyecto
                        cantidadProyecto = crs.getInt("canitadad_total");
                        sheet.addCell(new jxl.write.Label(1, y, String.valueOf(cantidadProyecto), hFormat));
                        //Nombre del Tipo de producto
                        if (area == 1) {
                            sheet.addCell(new jxl.write.Label(2, y, crs.getString("nombre"), hFormat));
                        }
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso")) + columnasIniciales, y, crs.getString("tiempo_total_por_proceso"), hFormat));
                        //Tiempo total de desarrollo del proyecto
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, crs.getString("tiempo_total"), hFormat));
                        // Tiempo Total Unidad
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, crs.getString("Total_timepo_Unidad"), hFormat));
                        // Estado del proyecto
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales++, y, clasificacionEstado(crs.getString("estado")), hFormat));
                        // Fecha en que se termino de procesar el proyecto
                        sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+2, y, crs.getString("fecha_salida"), hFormat));
                        // Cantidad total que poseé el proceso
                        cantidadProceso += crs.getInt("cantidadProceso");
                        //...
                        opOld = crs.getString("numero_orden");//Viejo numero de orden seleccionado
                        prodOld = (area==1?crs.getString("nombre"):"");//El viejo tipo de producto seleccionado
                    }
                }
            }
            if(accion == 1){
                //Cantidad terminada
                cantTerminada = cantidadProyecto - cantidadProceso;
                sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+3, y, String.valueOf(cantTerminada), hFormat));
                cantidadProceso = 0;
                //Cantidad restante
                sheet.addCell(new jxl.write.Label(cantP + columnasIniciales+4, y, String.valueOf(cantidadProyecto - cantTerminada), hFormat));
            }
            // ...
            woorBook.write();
            // ...
            woorBook.close();
           return true;     
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e);
            return false;
        }
    }
    
    public boolean generarReporteCorteTiemposProductosProyecto(CachedRowSet Productos,CachedRowSet Procesos , String ruta, String mes) {
        Proyecto controlador = new Proyecto();
        try {
            WorkbookSettings conf = new WorkbookSettings();
            conf.setEncoding("ISO-8859-1");
            WritableWorkbook woorBook = Workbook.createWorkbook(new File(ruta + "Reporte_Corte_Tiempos_Productos_"+mes+ ".xls"));//se busca la ruta para generar el archivo xls.
            // ...
            WritableSheet sheet = woorBook.createSheet("Reporte Corte Tiempo Producto", 0);//se crea el archivo xls <- Asignarle un nombre por cada área de producción (FE, TE o EN)
            WritableFont h = new WritableFont(WritableFont.ARIAL, 16, WritableFont.NO_BOLD);//Se da un formato al tipo de letra con el que se va a escribir sobre la hoja
            WritableCellFormat hFormat = new WritableCellFormat(h);//Se da formato a cada letra
            // ...
            //Encabezado columnas
            int y = 0, cantidadProyecto = 0, tiempo_ejecucion_minutos = 0;
            String tiempo_ejecucion = "00:00:00";
            // ...
            //Fechas de inicio y de fin del reporte de tiempo de producción. 
            sheet.addCell(new jxl.write.Label(0, y, "Mes de corte:", hFormat));
            sheet.addCell(new jxl.write.Label(1, y, mes, hFormat));
            // ...
            y++;
            //Numero de orden
            sheet.addCell(new jxl.write.Label(0, y, "Numero de orden", hFormat));
            //Cantidad del producto
            sheet.addCell(new jxl.write.Label(1, y, "Cantidad", hFormat));
            // Nombre del producto
            sheet.addCell(new jxl.write.Label(2, y, "Producto", hFormat));
            // Área del producto
            sheet.addCell(new jxl.write.Label(3, y, "Área", hFormat));
            // Estado del producto
            sheet.addCell(new jxl.write.Label(4, y, "Estado", hFormat));
            // Tiempo de ejecución en minutos 
            sheet.addCell(new jxl.write.Label(5, y, "Tiempo Ejecución (min)", hFormat));
            // Tiempo de ejecución en minutos 
            sheet.addCell(new jxl.write.Label(6, y, "Tiempo Ejecución", hFormat));
            // Cantidad del producto terminado
            sheet.addCell(new jxl.write.Label(7, y, "Cantidad Terminada", hFormat));
            // Fecha de terminacion del producto del proyecto
            sheet.addCell(new jxl.write.Label(8, y, "Fecha de terminación cantidad", hFormat));
            //...
            y++;
            while (Productos.next()) {
                    // Numero de orden
                    sheet.addCell(new jxl.write.Label(0, y, Productos.getString("proyecto_numero_orden"), hFormat));
                    // Cantidade totales del producto
                    cantidadProyecto = Productos.getInt("canitadad_total");
                    sheet.addCell(new jxl.write.Label(1, y, String.valueOf(cantidadProyecto), hFormat));
                    // Nombre del producto
                    sheet.addCell(new jxl.write.Label(2, y, Productos.getString("nombre"), hFormat));
                    // Area
                    sheet.addCell(new jxl.write.Label(3, y, clasificarAreaProduccion(Integer.parseInt(Productos.getString("idArea"))), hFormat));
                    // Estado
                    sheet.addCell(new jxl.write.Label(4, y, clasificacionEstado(Productos.getString("estado")), hFormat));
                    // Tiempo de ejecución del producto en minutos
                    sheet.addCell(new jxl.write.Label(5, y, Productos.getString("tiempo"), hFormat));
                    // Tiempo de ejecución del producto en "HH:MM:SS"
                    sheet.addCell(new jxl.write.Label(6, y, Productos.getString("tiempo_proyecto_mes"), hFormat)); 
                    // Cantidad terminada del producto
                    sheet.addCell(new jxl.write.Label(7, y, Productos.getString("cantidad_terminada"), hFormat)); 
                    // Fecha en que se termino de procesar el producto
                    sheet.addCell(new jxl.write.Label(8, y, Productos.getString("fecha_terminacion_cantidad"), hFormat));
                    // ...
                    y++;
                    //Sumar tiempo minutos
                    tiempo_ejecucion_minutos += Productos.getInt("tiempo");
                    //Sumar Tiempos "HH:MM:SS"
                    if(!Productos.getString("tiempo_proyecto_mes").equals("00:00:00")){
                        tiempo_ejecucion = controlador.sumarTiempos(tiempo_ejecucion, Productos.getString("tiempo_proyecto_mes"));
                    }
            }
            // Tiempo de ejecución del producto en minutos
            sheet.addCell(new jxl.write.Label(5, y, String.valueOf(tiempo_ejecucion_minutos), hFormat));
            // Tiempo de ejecución del producto en "HH:MM:SS"
            sheet.addCell(new jxl.write.Label(6, y, tiempo_ejecucion, hFormat));
            tiempo_ejecucion_minutos = 0;
            tiempo_ejecucion = "00:00:00";
            //...
            y+=2;
            //Nombre del proceso
            sheet.addCell(new jxl.write.Label(0, y, "Procesos", hFormat));
            //Area a la cual pertenece el proceso
            sheet.addCell(new jxl.write.Label(1, y, "Área", hFormat));
            //Tiempo de Ejecucion en minutos
            sheet.addCell(new jxl.write.Label(2, y, "Tiempo Ejecución (min)", hFormat));
            //Tiempo de Ejecucion en "HH:MM:SS"
            sheet.addCell(new jxl.write.Label(3, y, "Tiempo Ejecucion", hFormat));
            y++;
            while(Procesos.next()){
                
                sheet.addCell(new jxl.write.Label(0, y, Procesos.getString("nombre_proceso"), hFormat));
                //Area a la cual pertenece el proceso
                sheet.addCell(new jxl.write.Label(1, y, clasificarAreaProduccion(Procesos.getInt("idArea")), hFormat));
                //Tiempo de Ejecucion minutos
                sheet.addCell(new jxl.write.Label(2, y, Procesos.getString("tiempo_proceso"), hFormat));
                //Tiempo de Ejecucion "HH:MM:SS"
                sheet.addCell(new jxl.write.Label(3, y, Procesos.getString("tiempo"), hFormat));
                // ...
                y++;
                //Sumar tiempo ejecucion minutos
                tiempo_ejecucion_minutos += Procesos.getInt("tiempo_proceso");
                //Sumar Tiempos "HH:MM:SS"
                if(!Procesos.getString("tiempo").equals("00:00:00")){
                    tiempo_ejecucion = controlador.sumarTiempos(tiempo_ejecucion, Procesos.getString("tiempo"));
                }
            }
            //Tiempo de Ejecucion minutos
            sheet.addCell(new jxl.write.Label(2, y, String.valueOf(tiempo_ejecucion_minutos), hFormat));
            //Tiempo de Ejecucion "HH:MM:SS"
            sheet.addCell(new jxl.write.Label(3, y, tiempo_ejecucion, hFormat));    
            // ...
            woorBook.write();
            // ...
            woorBook.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    
    private boolean validacionDeProducto(int area, String opNew, String opOld, String prodNew, String prodOld){
        boolean respuesta=false;
        switch(area){
            case 1://Validacion de formato estandar - FE
                //El viejo numero de orden selecionado="opOld" es igual al nuevo numero de orden="opNew" y el viejo producto seleccionado= "prodOld" es igual al nuevo producto="prodNew"
                if(opOld.equals(opNew) && prodOld.equals(prodNew)){
                    respuesta=true;
                }
                break;
            case 2:
            case 3://Validacion de Ensamble - EN y Teclados - TE
                //El viejo numero de orden selecionado="opOld" es igual al nuevo numero de orden="opNew"
                if(opOld.equals(opNew)){
                    respuesta=true;
                }
                break;
        }
        return respuesta;
    }
    
    private String clasificarAreaProduccion(int area){
        String mensaje="";
        switch(area){
            case 1://Formato estandar
                mensaje="FE";
                break;
            case 2://Teclados
                mensaje="TE";
                break;
            case 3://Ensamble
                mensaje="EN";
                break;
            case 4://Almacen
                mensaje="AL";
                break;
        }
        return mensaje;
    }
    
    private String clasificacionEstado(String estado){
        String nombre = "";
        switch(estado){
            case "1":
                nombre = "Por Iniciar";
                break;
            case "2":
                nombre = "Pausado";
                break;
            case "3":
                nombre = "Terminado";
                break;
            case "4":
                nombre = "Ejecución";
                break;    
        }
        return nombre;
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
