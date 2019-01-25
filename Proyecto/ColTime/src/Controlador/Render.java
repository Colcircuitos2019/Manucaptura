package Controlador;

import java.awt.Color;
import java.awt.Component;
import javax.swing.JButton;
import javax.swing.JRadioButton;
import javax.swing.JSpinner;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.UIManager;
import javax.swing.table.DefaultTableCellRenderer;

public class Render extends DefaultTableCellRenderer {

    int columna_patron = 0;

    public Render(int columnaPatron) {
        this.columna_patron = columnaPatron;
    }

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
        //Se da color a las filas 
        setBackground(Color.white);//color de fondo
        table.setForeground(Color.black);//color de texto
        this.setHorizontalAlignment(SwingConstants.CENTER);//CEntra la informacion de las celdas
        //Si la celda corresponde a una fila con estado FALSE, se cambia el color de fondo a rojo
        if (table.getValueAt(row, columna_patron).equals("Por iniciar")) {
            setBackground(Color.white);
        } else if (table.getValueAt(row, columna_patron).equals("Pausado")) {
            setBackground(new Color(255, 168, 27));//Orange
        } else if (table.getValueAt(row, columna_patron).equals("Terminado")) {
            setBackground(Color.GREEN);
        } else if (table.getValueAt(row, columna_patron).equals("Ejecucion")) {
            setBackground(Color.gray);
        }
        //Botones del jTable
        if (value instanceof JButton) {
            JButton btn = (JButton) value;
            //Sabe que boton se activa y cual no
            if (btn.getText().equals("Tiempo")) {
                if (table.getValueAt(row, columna_patron).equals("Terminado") || table.getValueAt(row, columna_patron).equals("Pausado")) {
                    btn.setEnabled(false);
                    btn.setActionCommand("2");
                } else if (table.getValueAt(row, columna_patron).equals("Ejecucion")) {
                    btn.setEnabled(true);
                    btn.setActionCommand("1");
                }
            } else {
                if (table.getValueAt(row, columna_patron).equals("Por iniciar") || table.getValueAt(row, columna_patron).equals("Ejecucion")) {
                    btn.setEnabled(false);
                    btn.setActionCommand("2");//2
                } else if (table.getValueAt(row, columna_patron).equals("Terminado") || table.getValueAt(row, columna_patron).equals("Pausado")) {
                    btn.setEnabled(true);
                    btn.setActionCommand("1");//1
                }
            }

            if (isSelected) {
                btn.setForeground(table.getSelectionForeground());
                btn.setBackground(table.getSelectionBackground());
            } else {
                btn.setForeground(table.getSelectionForeground());
                btn.setBackground(UIManager.getColor("Button.background"));
            }
            return btn;
        }
        
        //JRadioButton
        if(value instanceof JRadioButton){
            JRadioButton input = (JRadioButton) value;
            return input;
        }
        
        //Text Filed del jTable
//        if(value instanceof JSpinner){
//            JSpinner input=new JSpinner();
//            input.setEnabled(true);
//            //input.setActionCommand();
//            return input;
//        }

        super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column); //To change body of generated methods, choose Tools | Templates.
        return this;
    }
    
   
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
