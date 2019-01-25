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
    
    public boolean generarReporteTiemposAreaProduccion(CachedRowSet crs, String ruta, int area){
        try {
            WorkbookSettings conf = new WorkbookSettings();
            conf.setEncoding("ISO-8859-1");
            WritableWorkbook woorBook = Workbook.createWorkbook(new File(ruta + "\\ReporteTiempoArea.xls"));//se busca la ruta para generar el archivo xls.
//
            WritableSheet sheet = woorBook.createSheet("Reporte Tiempos Área", 0);//se crea el archivo xls
            WritableFont h = new WritableFont(WritableFont.COURIER, 16, WritableFont.NO_BOLD);//Se da un formato al tipo de letra con el que se va a escribir sobre la hoja
//          h.setColour(Colour.BLUE);
            WritableCellFormat hFormat = new WritableCellFormat(h);//Se da formato a cada letra
//
            //Encabezado columnas
            int x = 0;
            int y=0;
            int accion=0;
            String opNew="",opOld="";
            //Numero de orden
            sheet.addCell(new jxl.write.Label(x, y, "Numero de orden", hFormat));
            //Cantidad del proyecto
            x++;
            sheet.addCell(new jxl.write.Label(x, y, "Cantidad", hFormat));
            //Procesos del área seleccionada
            Procesos proc=new Procesos();
            CachedRowSet crsP=proc.consultarProcesos(area);//Esto diene que ser una variable dinamica
            ArrayList<String> nombreProcesos=new ArrayList<String>();//Nombre de todos los proceso del área
            //Posicionar procesos en el excel
            x++;
            while (crsP.next()) {                
                //Nombre del proceso
                nombreProcesos.add(crsP.getString(1));
                sheet.addCell(new jxl.write.Label(x, y, crsP.getString(1), hFormat));
                x++;
            }
            //Tiempo Total de la orden
            sheet.addCell(new jxl.write.Label(x, y, "Tiempo Total", hFormat));
            //...
            y++;
            while(crs.next()){
                //
                if(accion==0){
                    //Numero de orden
                    sheet.addCell(new jxl.write.Label(0, y, crs.getString(1), hFormat));
                    //Cantidade totales del proyecto
                    sheet.addCell(new jxl.write.Label(1, y, crs.getString(6), hFormat));
                    //Tiempo total de desarrollo del proyecto= Esta es igual a la suma de todos los tiempos de produccion de los procesos del área...
                    sheet.addCell(new jxl.write.Label(nombreProcesos.size()+2, y, crs.getString(5), hFormat));
                    //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                    sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString(3))+2,y, crs.getString(4), hFormat));
                    //...
                    opOld=crs.getString(1);//Viejo numero de orden seleccionado
                    accion=1;
                }else{
                    opNew=crs.getString(1);//Nuevo numero de orden seleccionado
                    //...
                    if (opOld.equals(opNew)) {//El viejo numero de orden selecionado="opOld" es igual al nuevo numero de orden="opNew"
                        //Realiza las mismas acciones sobre la misma fila
                        opOld=opNew;//El nuevo numero de orden pasa a ser el viejo numero de orden
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString(3))+2,y, crs.getString(4), hFormat));
                    } else {
                        //Salta a la siguiente fila y sigue realizando el mismo proceso de ubiación...
                        //...
                        y++;
                        //Numero de orden
                        sheet.addCell(new jxl.write.Label(0, y, crs.getString(1), hFormat));
                        //Cantidade totales del proyecto
                        sheet.addCell(new jxl.write.Label(1, y, crs.getString(6), hFormat));
                        //Tiempo total de desarrollo del proyecto= Esta es igual a la suma de todos los tiempos de produccion de los procesos del área...
                        sheet.addCell(new jxl.write.Label(nombreProcesos.size()+2, y, crs.getString(5), hFormat));
                        //Seleccionar el proceso y ubicar el tiempo de produccion y el total
                        sheet.addCell(new jxl.write.Label(nombreProcesos.indexOf(crs.getString(3))+2, y, crs.getString(4), hFormat));
                        //...
                        opOld = crs.getString(1);//Viejo numero de orden seleccionado
                    }
                }
            }

            woorBook.write();

            woorBook.close();
           return true;     
        } catch (Exception e) {
            return false;
        }
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
