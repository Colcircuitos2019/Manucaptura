package Controlador;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.table.DefaultTableCellRenderer;

public class FormatoTabla extends DefaultTableCellRenderer {

    private int columna_patron;

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
        //Si la celda corresponde a una fila con estado FALSE, se cambia el color de fondo a rojo
        if (table.getName().equals("Proyecto")) {
            if (table.getValueAt(row, 16).toString().equals("1")) {
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
}
