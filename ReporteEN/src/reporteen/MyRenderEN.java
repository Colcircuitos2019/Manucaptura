package reporteen;

import java.awt.Color;
import java.awt.Component;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;

public class MyRenderEN extends JTable {
//Colores

    Color orange = new Color(255, 168, 27);
    Color green = new Color(116, 251, 83);
    Color red = new Color(251, 83, 83);
    Color blueligth = new Color(1, 174, 240);
    int col = 0;

    @Override
    public Component prepareRenderer(TableCellRenderer renderer, int row, int column) {
        Component cell = super.prepareRenderer(renderer, row, column); //To change body of generated methods, choose Tools | Templates.

        cell.setBackground(Color.WHITE);
        cell.setForeground(Color.BLACK);
        
//        System.out.println(this.getColumnCount());
        
        try {

            if (row < this.getRowCount() - 1) {

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

                if (column >= 5 && column % 2 == 1) {

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

        return cell;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
