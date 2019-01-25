package resportete;

import java.awt.Color;
import java.awt.Component;
import java.awt.Font;
import javax.swing.JTable;
import javax.swing.table.JTableHeader;
import javax.swing.table.TableCellRenderer;

public class MyRenderEN extends JTable {
//Colores

    Color orange = new Color(255, 168, 27);
    Color green = new Color(116, 251, 83);
    Color red = new Color(251, 83, 83);
    Color blueligth = new Color(1, 174, 240);

    @Override
    public Component prepareRenderer(TableCellRenderer renderer, int row, int column) {
        Component cell = super.prepareRenderer(renderer, row, column); //To change body of generated methods, choose Tools | Templates.

//        cell.setBackground(Color.white);
//        cell.setForeground(Color.BLACK);
        if (column != 1 && column != 0 && column >= 2) {
            if (column % 2 == 0) {//pares son los sub_procesos *******
                switch (getValueAt(row, column-1).toString()) {
                    case "1"://Por iniciar
                    case "":
                    case "0":
                        cell.setBackground(Color.WHITE);//white
                        break;
                    case "2"://Pausado
                        cell.setBackground(red);//Red
                        break;
                    case "3"://Terminado
                        cell.setBackground(green);//green
                        break;
                    case "4"://Ejecución
                        cell.setBackground(orange);//Orange
                        break;
                    case "*******":
                        cell.setBackground(new Color(34, 137, 254));//Orange
                        break;
                }
            }
        } else {
            if (column == 0) {
                switch (getValueAt(row, 2).toString()) {
                    case "Normal":
                        cell.setBackground(Color.WHITE);//white
                        break;
                    case "Quick":
                        cell.setBackground(blueligth);//Blueligth
                        break;
                    case "RQT":
                        cell.setBackground(Color.PINK);//Pink
                        break;
                    default:
                        cell.setBackground(Color.WHITE);//white
                        break;
                }
            } else {
                //Colores por defecto
                cell.setBackground(Color.white);
                cell.setForeground(Color.BLACK);
            }
        }

        return cell;
    }

    @Override
    public boolean isCellEditable(int row, int column) {
        return false; //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public JTableHeader getTableHeader() {
        JTableHeader cabeza = super.getTableHeader(); //To change body of generated methods, choose Tools | Templates.
        cabeza.setFont(new Font("Arial", 1, 20));
        cabeza.setForeground(Color.BLACK);
        return cabeza;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
