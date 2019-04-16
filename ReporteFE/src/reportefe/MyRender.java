package reportefe;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableCellRenderer;

public class MyRender extends JTable {

    //Variables
    int subProceso = 5, proceso = 6;

    @Override
    public Component prepareRenderer(TableCellRenderer renderer, int row, int column) {
        
        Component cell = super.prepareRenderer(renderer, row, column);
        //Colores por defecto
        cell.setBackground(Color.white);
        cell.setForeground(Color.BLACK);
        
//        if(column > 6 && column < this.getColumnCount()-1){
//            if (this.getValueAt(row, column) == null) {
//                this.setValueAt("-1", row, column); ;
//            }
//        }
        // ...
//        System.out.println(this.getColumnCount());
        try {
            
            if(row < this.getRowCount()){
                
                if (column == 0) {// Tipo de ejecucion del producto
                    switch (this.getValueAt(row, 1).toString()) {
                        case "Normal":
                            cell.setBackground(Color.white);
                            cell.setForeground(Color.BLACK);
                            break;
                        case "Quick":
                            cell.setBackground(new Color(1, 174, 240));//Azul
                            cell.setForeground(Color.WHITE);
                            break;
                        case "RQT":
                            cell.setBackground(Color.PINK);//Rosado
                            cell.setForeground(Color.BLACK);
                            break;
                    }
                }

                if (column >= 6 && column % 2 == 0) {

                    switch (getValueAt(row, column - 1).toString()) {
                        case "-1":
                            cell.setBackground(Color.GRAY);// Parada
                            break;
                        case "1":// Por iniciar
                            cell.setBackground(Color.WHITE);
                            break;
                        case "2":// Pausada
                            cell.setBackground(Color.RED);
                            break;
                        case "3":// Terminada
                            cell.setBackground(Color.GREEN);
                            break;
                        case "4": // En ejecucion
                            cell.setBackground(Color.ORANGE);
                            break;
                    }

                }
                
            }
            
        } catch (Exception e) {
            
            e.printStackTrace();
            
        }
        
        return cell; //To change body of generated methods, choose Tools | Templates.
    }

//    @Override
//    public JTableHeader getTableHeader() {
//        JTableHeader tabla = super.getTableHeader();
//        tabla.setFont(new Font("Arial", 1, 20));
//        tabla.setForeground(Color.BLACK);
////        tabla.getTableHeader().setPreferredSize(new java.awt.Dimension(0, 0));//Cambiar el tabaño de el header de la tabla
//        return tabla; //To change body of generated methods, choose Tools | Templates.
//    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
