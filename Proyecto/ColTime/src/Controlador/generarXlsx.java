package Controlador;

import java.io.File;
import java.util.ArrayList;
import javax.sql.rowset.CachedRowSet;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.Colour;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class generarXlsx {

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
            WritableWorkbook woorBook = Workbook.createWorkbook(new File(ruta + "\\ReporteTiempoArea.xls"));//se busca la ruta para generar el archivo xls.
            // ...
            WritableSheet sheet = woorBook.createSheet("Reporte Tiempos Área", 0);//se crea el archivo xls
            WritableFont h = new WritableFont(WritableFont.ARIAL, 16, WritableFont.NO_BOLD);//Se da un formato al tipo de letra con el que se va a escribir sobre la hoja
//          h.setColour(Colour.BLUE);
            WritableCellFormat hFormat = new WritableCellFormat(h);//Se da formato a cada letra
            // ...
            //Encabezado columnas
            int x = 0, y=0, accion=0, cantP=0, cantidadProceso=0, cantidadProyecto=0, cantTerminada=0;
            // ... 
            String opNew="",opOld="";
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
            //Procesos del área seleccionada
            Procesos proc=new Procesos();
            CachedRowSet crsP=proc.consultarProcesos(area);// ... 
            ArrayList<String> nombreProcesos=new ArrayList<String>();//Nombre de todos los proceso del área
            //Posicionar procesos en el excel
            x++;
            while (crsP.next()) {                
                //Consultar los nombre de los procesos del área.
                nombreProcesos.add(crsP.getString(1));
                sheet.addCell(new jxl.write.Label(x, y, crsP.getString(1), hFormat));
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
            //Fecha en la que termino empaque de procesar por ultima vez
//            sheet.addCell(new jxl.write.Label(x, y, "Fecha T.empaque", hFormat));
//            x++; // Esta pendiente por definir
            //...
            y++;
            while(crs.next()){
                //
                if(accion == 0){
                    //Numero de orden
                    sheet.addCell(new jxl.write.Label(0, y, crs.getString("numero_orden"), hFormat));
                    //Cantidade totales del proyecto
                    cantidadProyecto = crs.getInt("canitadad_total");
                    sheet.addCell(new jxl.write.Label(1, y, String.valueOf(cantidadProyecto), hFormat));
                    //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                    sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso"))+2,y, crs.getString("tiempo_total_por_proceso"), hFormat));
                    //Tiempo total de desarrollo del proyecto
                    sheet.addCell(new jxl.write.Label(cantP + 2, y, crs.getString("tiempo_total"), hFormat));
                    // Tiempo Total Unidad
                    sheet.addCell(new jxl.write.Label(cantP + 3, y, crs.getString("Total_timepo_Unidad"), hFormat));
                    // Estado del proyecto
                    sheet.addCell(new jxl.write.Label(cantP + 4, y, clasificacionEstado(crs.getString("estado_idestado")), hFormat));
                    // Fecha en que se termino de procesar el proyecto
                    sheet.addCell(new jxl.write.Label(cantP + 7, y, crs.getString("fecha_salida"), hFormat));
                    // ...
                    // Cantidad total que poseé el proceso
                    cantidadProceso+= crs.getInt("cantidadProceso");
                    opOld=crs.getString(1);//Viejo numero de orden seleccionado
                    accion=1;
                }else{
                    opNew=crs.getString(1);//Nuevo numero de orden seleccionado
                    //...
                    if (opOld.equals(opNew)) {//El viejo numero de orden selecionado="opOld" es igual al nuevo numero de orden="opNew"
                        //Realiza las mismas acciones sobre la misma fila
                        opOld=opNew;//El nuevo numero de orden pasa a ser el viejo numero de orden
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso"))+2,y, crs.getString("tiempo_total_por_proceso"), hFormat));
                        // Cantidad total que poseé el proceso
                        cantidadProceso+= crs.getInt("cantidadProceso");
                    } else {
                        //Cantidad terminada
                        cantTerminada = cantidadProyecto - cantidadProceso;
                        sheet.addCell(new jxl.write.Label(cantP + 5, y, String.valueOf(cantTerminada), hFormat));
                        cantidadProceso = 0;
                        //Cantidad restante
                        sheet.addCell(new jxl.write.Label(cantP + 6, y, String.valueOf(cantidadProyecto - cantTerminada), hFormat));
                        //Salta a la siguiente fila y sigue realizando el mismo proceso de ubiación...
                        y++;
                        //Numero de orden
                        sheet.addCell(new jxl.write.Label(0, y, crs.getString("numero_orden"), hFormat));
                        //Cantidade totales del proyecto
                        cantidadProyecto = crs.getInt("canitadad_total");
                        sheet.addCell(new jxl.write.Label(1, y, String.valueOf(cantidadProyecto), hFormat));
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString("nombre_proceso")) + 2, y, crs.getString("tiempo_total_por_proceso"), hFormat));
                        //Tiempo total de desarrollo del proyecto
                        sheet.addCell(new jxl.write.Label(cantP + 2, y, crs.getString("tiempo_total"), hFormat));
                        // Tiempo Total Unidad
                        sheet.addCell(new jxl.write.Label(cantP + 3, y, crs.getString("Total_timepo_Unidad"), hFormat));
                        // Estado del proyecto
                        sheet.addCell(new jxl.write.Label(cantP + 4, y, clasificacionEstado(crs.getString("estado_idestado")), hFormat));
                        // Fecha en que se termino de procesar el proyecto
                        sheet.addCell(new jxl.write.Label(cantP + 7, y, crs.getString("fecha_salida"), hFormat));
                        // Cantidad total que poseé el proceso
                        cantidadProceso += crs.getInt("cantidadProceso");
                        //...
                        opOld = crs.getString("numero_orden");//Viejo numero de orden seleccionado
                    }
                }
            }
            if(accion == 1){
                //Cantidad terminada
                cantTerminada = cantidadProyecto - cantidadProceso;
                sheet.addCell(new jxl.write.Label(cantP + 5, y, String.valueOf(cantTerminada), hFormat));
                cantidadProceso = 0;
                //Cantidad restante
                sheet.addCell(new jxl.write.Label(cantP + 6, y, String.valueOf(cantidadProyecto - cantTerminada), hFormat));
            }
            // ...
            woorBook.write();
            // ...
            woorBook.close();
           return true;     
        } catch (Exception e) {
            return false;
        }
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
