package Controlador;

import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.border.Border;
import javax.swing.plaf.BorderUIResource;
import javax.swing.table.DefaultTableCellRenderer;

public class FormatoTabla extends DefaultTableCellRenderer {

    private static int columna_patron;

    public FormatoTabla(int Colpatron) {
        this.columna_patron = Colpatron;
    }
    Color orange = new Color(255, 168, 27);
    Color green = new Color(116, 251, 83);
    Color gray = new Color(176, 176, 176);
    Color red = new Color(251, 83, 83);

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean selected, boolean focused, int row, int column) {
        setBackground(Color.white);//color de fondo
        table.setForeground(Color.black);//color de texto
        table.setCursor(new Cursor(java.awt.Cursor.HAND_CURSOR));
//        table.setBorder(new BorderUIResource(noFocusBorder));
        this.setHorizontalAlignment(SwingConstants.CENTER);
        //Si la celda corresponde a una fila con estado FALSE, se cambia el color de fondo a rojo
        if (table.getName().equals("Proyecto")) {
            if (table.getValueAt(row, 9).toString().equals("1")) {
                if (table.getValueAt(row, columna_patron).equals("Por iniciar")) {
                    setBackground(Color.white);
                } else if (table.getValueAt(row, columna_patron).equals("Pausado")) {
                    setBackground(orange);//Orange
                } else if (table.getValueAt(row, columna_patron).equals("Terminado")) {
                    setBackground(green);//Green
                } else if (table.getValueAt(row, columna_patron).equals("Ejecucion")) {
                    setBackground(gray);//Gray
                }
            } else {
                setBackground(red);
            }
            // ...
            if(column == 8){
                switch(String.valueOf(table.getValueAt(row, column))){
                    case "Quick":
                        setBackground(new Color(1, 174, 240));//Azul
                        break;
                    case "RQT":
                        setBackground(new Color(255, 175, 175));//Rosado
                        break;
                }
            }
        } else {
            if (table.getValueAt(row, columna_patron).equals("Por iniciar")) {
                setBackground(Color.white);
            } else if (table.getValueAt(row, columna_patron).equals("Pausado")) {
                setBackground(orange);//Orange
            } else if (table.getValueAt(row, columna_patron).equals("Terminado")) {
                setBackground(green);//Green
            } else if (table.getValueAt(row, columna_patron).equals("Ejecucion")) {
                setBackground(gray);//Gray
            } else if (table.getValueAt(row, columna_patron).equals("Parada")) {
                setBackground(red);//Red
            }
        }
        
        table.getTableHeader().setFont(new Font("Arial",1,15));
        
        super.getTableCellRendererComponent(table, value, selected, focused, row, column);
        return this;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }
    /*
    String row[] = {"N° Orden", 0
                "Registro de", 1 
                "Nombre Cliente", 2
                "Nombre Proyecto", 3
                "Fecha Ingreso", 4
                "Fecha Entrega", 5
                "Fecha Salida", 6
                "Estado", 7
                "Tipo Ejecucion", 8
                "Parada", 9
                "Fecha1", 10
                "Fecha2", 11
                "Fecha3", 12
                "Fecha4", 13
                "Novedad", 14
                "EstadoProyec", 15
                "NFEE"}; 16
    */
}
