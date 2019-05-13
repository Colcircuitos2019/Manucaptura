
package Controlador;

import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import javax.swing.JTable;
import javax.swing.SwingConstants;
import javax.swing.table.DefaultTableCellRenderer;


public class renderProduccion extends DefaultTableCellRenderer{

    private static int columna_patron_estado = 0;
    private static int columna_patron_tipo_proyecto = 0;
    
    public renderProduccion(int columna_patron_estado, int columna_patron_tipo_proyecto){
        
        this.columna_patron_estado=columna_patron_estado;
        this.columna_patron_tipo_proyecto = columna_patron_tipo_proyecto;

    }
    
    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
        
        
        setBackground(Color.white);//color de fondo
        table.setForeground(Color.black);//color de texto
        table.setCursor(new Cursor(java.awt.Cursor.HAND_CURSOR));//->Pendiente
        this.setHorizontalAlignment(SwingConstants.CENTER);
        
        switch(table.getValueAt(row, columna_patron_estado).toString()){
            case "Por iniciar":
                setBackground(Color.white);
                break;
            case "Pausado":
                setBackground(new Color(251, 83, 83));// Rojo
                break;
            case "Terminado":
                setBackground(new Color(116, 251, 83)); // verde
                break;
            case "Ejecucion":
                setBackground(new Color(255, 168, 27));//Orange
                break;
        }

        if(column == columna_patron_tipo_proyecto){
            
            switch(String.valueOf(table.getValueAt(row, column))){
                    case "Normal":
                        setBackground(Color.WHITE);//white
                        break;
                    case "Quick":
                        setBackground(new Color(1, 174, 240));//Azul
                        break;
                    case "RQT":
                        setBackground(new Color(255, 175, 175));//Rosado
                        break;
                }
            
        }
        
        return super.getTableCellRendererComponent(table, value, isSelected, hasFocus, row, column); //To change body of generated methods, choose Tools | Templates.
    }
    
    
    
}
