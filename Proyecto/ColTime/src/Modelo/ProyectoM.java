package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

public class ProyectoM {

    //Constructores------------------------------------------------->
    public ProyectoM() {

    }
    //Variables------------------------------------------------------>
    public CachedRowSet crsP = null;
    Conexion conexion = null;
    PreparedStatement ps = null;
    Connection con = null;
    ResultSet rs = null;
    boolean res;
    String orden = "";
    String fecha = "";

    //Metodos y funciones------------------------------------------------>
    public boolean estadoDeOrdenM(int orden, int op) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "";
//            if (op == 1) { // Ejecutar nuevamente los procesos <-- ya no es necesario
//                Qry = "CALL PA_DetallesEnEjecucion(?,?)";// Esto se va a eliminar...
//                ps = con.prepareStatement(Qry);
//                ps.setInt(1, orden);
//                ps.setInt(2, 2);
//                rs = ps.executeQuery();
//                while (rs.next()) {
//                    //Activas detalles del almacen...  
//                    Qry = "CALL PA_IniciarTomaTiempoDetalleAlmacen(?)";//Esto se va a eliminar
//                    ps = con.prepareStatement(Qry);
//                    ps.setInt(1, rs.getInt(1));
//                    ps.execute();
//                }
//            }
            Qry = "CALL PA_EjecucionoParada(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            ps.setInt(2, op);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean("respuesta");
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public boolean estadoProyecto(int orden) {// Esto ya no se va a realizar más...
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            //PA_DetallesEnEjecucion
            String Qry = "CALL PA_DetallesEnEjecucion(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            ps.setInt(2, 4);
            rs = ps.executeQuery();
            res = true;
            int cont = 0;
            int v[] = new int[4];
            while (rs.next()) {
                if (rs.getInt(2) == 4) {
                    res = true;
                    v[cont] = rs.getInt(1);
                    cont++;
                } else {
                    res = false;
                    break;
                }
            }
            if (res) {
                //Se cambia el estado de los detalles de almacen a paunsados.
                for (int i = 0; i < v.length; i++) {
                    if (v[i] != 0) {
                        Qry = "CALL PA_PararTomaDeTiempoAlmacen(?,?,?,?)";
                        ps = con.prepareStatement(Qry);
                        ps.setInt(1, v[i]);//Detalle
                        ps.setInt(2, 0);//Proceso
                        ps.setInt(3, 0);//Cantidad
                        ps.setInt(4, 2);//Estado pausado
                        ps.execute();
                    } else {
                        break;
                    }
                }
            }
            Qry = "SELECT FU_EstadoDeProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;
    }

    public CachedRowSet diagramaM(String inicio, String fin) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_Diagramas(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, inicio);
            ps.setString(2, fin);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return crsP;
    }

    public CachedRowSet InformacionAreasProduccionM(int accion) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "";
            switch (accion) {
                case 1:
                    Qry = "CALL PA_CantidadProyectosIngresadosArea()";
                    break;
                case 2:
                    Qry = "CALL PA_CantidadProyectosterminadosHoy()";
                    break;
                case 3:
                    Qry = "CALL PA_CantidadProyectosEjecucion()";
                    break;
                case 4:
                    Qry = "CALL PA_CantidadProyectosPorIniciar()";
                    break;
            }
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return crsP;
    }

    public boolean registrar_Modificar_Proyecto(String num_orden, String comercial, String cliente, String proyecto, String tipo, String fechaEntrega,int accion, String fechaCircuito1, String fechaCircuito2, String fechaPCB1, String fechaPCB2, String novedades, String estado, String nuevaFechaEntrega) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = " SELECT FU_RegistrarModificarProyecto(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, num_orden);
            ps.setString(2, comercial);
            ps.setString(3, cliente);
            ps.setString(4, proyecto);
            ps.setString(5, tipo);
            ps.setString(6, fechaEntrega);
            ps.setInt(7, accion);//1) Registrar, 2)Modificar
            ps.setString(8, fechaCircuito1);
            ps.setString(9, fechaCircuito2);
            ps.setString(10, fechaPCB1);
            ps.setString(11, fechaPCB2);
            ps.setString(12, novedades);
            ps.setString(13, estado);
            ps.setString(14, nuevaFechaEntrega);
            //Ejecución del Query---------------------------------------------->
            rs = ps.executeQuery();
            if (rs.next()) {
                res = rs.getBoolean(1);
            } else {
                res = false;
            }
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error! Registro Modificacion info_proyecto: " + e);
            e.printStackTrace();
        }
        return res;
    }

    public boolean registrarProyectoQRM(String infoP[], String comercial) {
        //Cuerpo del la función...
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = Qry = "SELECT FU_RegistrarModificarProyecto(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, comercial);
            ps.setString(2, infoP[3]);//Nombre del cliente
            ps.setString(3, infoP[4]);//Nombre del proyecto
            ps.setString(4, infoP[6]);//Tipo de ejecución
            ps.setBoolean(5, false);
            ps.setBoolean(6, false);
            ps.setBoolean(7, false);
            ps.setBoolean(8, false);
            ps.setBoolean(9, false);
            ps.setBoolean(10, false);
            ps.setBoolean(11, false);
            ps.setBoolean(12, false);
            ps.setBoolean(13, false);
            ps.setBoolean(14, false);
            ps.setString(15, infoP[10]);//Fecha de entrega
            ps.setBoolean(16, false);
            ps.setBoolean(17, false);
            ps.setInt(18, Integer.parseInt(infoP[0]));//Numero de orden
            ps.setInt(19, 1);//1) Registrar, 2)Modificar
            ps.setBoolean(20, false);
            ps.setBoolean(21, false);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            conexion.cerrar(rs);
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public boolean ValidarProyectoQRM(int orden) {
        //Cuerpo del la función...
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ValidarProyectoQR(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            conexion.cerrar(rs);
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public boolean validarDetalleProyectoQRM(int orden, String area, String producto) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ValidarDetalleProyectoQR(?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            ps.setInt(2, nArea(area));
            ps.setInt(3, nProducto(producto));
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            conexion.cerrar(rs);
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }
    
    public void actualizarEstadoProyectoM(int num_orden) {

        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_CambiarEstadoDeProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, num_orden);
            ps.execute();
            //Cierre de conexiones
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private int nArea(String area) {
        int n = 0;
        switch (area.toUpperCase()) {
            case "FE":
                n = 1;
                break;
            case "TE":
                n = 2;
                break;
            case "IN":
                n = 3;
                break;
        }
        return n;
    }

    private int nProducto(String producto) {
        int n = 0;
        switch (producto.toUpperCase()) {
            case "CIRCUITO":
                n = 1;
                break;
            case "CONVERSOR":
                n = 2;
                break;
            case "REPUJADO":
                n = 3;
                break;
            case "TROQUEL":
                n = 4;
                break;
            case "TECLADO":
                n = 5;
                break;
            case "STENCIL":
                n = 6;
                break;
            case "PCB":
                n = 7;
                break;
        }
        return n;
    }

    public CachedRowSet consultar_Proyecto(String numerOrden, String nombreCliente, String nombreProyecto, String fecha, String TipoFecha) {
        //Pendiente cambiar el tipo de dato el numero de orden en los procedimientos almacenados de la base de datos...<-------
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>Buscar otar forma de hacer esta consulta más eficiente.
            String Qry="";
            switch(TipoFecha){
                case "Ingreso":
                    Qry = "CALL PA_ConsultarProyectosIngreso(?,?,?,?)";
                    break;
                case "Entrega":
                    Qry = "CALL PA_ConsultarProyectosEntrega(?,?,?,?)";
                    break;
                case "Salida":
                    Qry = "CALL PA_ConsultarProyectosSalida(?,?,?,?)";
                    break;
                default:
                    Qry = "CALL PA_ConsultarProyectosIngreso(?,?,?,?)";
                    break;
            }
            //...
            ps = con.prepareStatement(Qry);
            ps.setString(1, numerOrden);
            ps.setString(2, nombreCliente);
            ps.setString(3, nombreProyecto);
            ps.setString(4, fecha);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crsP;
    }

    public CachedRowSet consultar_ProyectoEliminados() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarProyectosEliminados()";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            ps.close();
            con.close();
            conexion.destruir();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crsP;
    }

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //Solo se elimina cierta información, mucho cuidado al ejecutarlo por cualquier razon.
    public boolean EliminarProyecto(int orden) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            //PA_DetallesAEliminar
            String Qry = "CALL PA_EliminarCambiarEstadoProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            res = !ps.execute();

            //Cierre de conexion y finalizacion de variables.
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    public boolean ReacttivarProyecto(int orden) {//Se cambiara el estado del proyecto
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            //PA_DetallesAEliminar
            String Qry = "CALL PA_ReactivarProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            res = !ps.execute();

            //Cierre de conexion y finalizacion de variables.
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;
    }

    public CachedRowSet Consultar_informacion_para_el_QR(int orden) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_InformacionQR(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return crsP;
    }
    
//    public CachedRowSet consultar_Info_Basica_ProyectoQR(int orden){
//        conexion = new Conexion();
//        conexion.establecerConexion();
//        con= conexion.getConexion();
//        //Query---------------------------------------------------------------->
//        String Qry="CALL InfoBasicaProyecto";
//        return crsP;
//    }

    public String consultarNumeroOrden() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarNumeroOrden()";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            if (rs.next()) {
                orden = String.valueOf(rs.getInt(11));
            } else {
                orden = "N#Error";
            }
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return orden;
    }

    public String fecha() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_FechaServidor()";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            if (rs.next()) {
                fecha = String.valueOf(rs.getString(1));
            }
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return fecha;
    }

    public CachedRowSet fechaYdatosProduccion() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_InformacionDeTodaElAreaDeProduccion()";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crsP;
    }

    public CachedRowSet proyectosNegocio(int negocio, String orden, String cliente, String proyecto, String tipo) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_InformacionProyectosProduccion(?,?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, negocio);
            if (!orden.equals("")) {
                ps.setInt(2, Integer.parseInt(orden));
            } else {
                ps.setInt(2, 0);
            }
            ps.setString(3, cliente);
            ps.setString(4, proyecto);
            if (!tipo.equals("Seleccione...")) {
                ps.setString(5, tipo);
            } else {
                ps.setString(5, "");
            }
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crsP;
    }

    public boolean validarNumerOrden(int orden) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "SELECT FU_ValidarNumerOrden(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public boolean validarEliminacion(int orden) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "SELECT FU_ValidarEstadoEliminado(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public CachedRowSet consutalarProcesosAreaM(int op) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_DiagramaFETEEN(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, op);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crsP;
    }

    public boolean validarEjecucionOParada(int orden) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "SELECT FU_ValidarEstadoProyectoEjecucionOParada(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }
    // Hace falta recibir como parametro el mes y el año en que se van a realizar los cortes del tiempo de los productos y los procesos
    public CachedRowSet reporteCorteTiemposProductoProyectosM(String fecha) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ReporteTiemposProduccionProductos(?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, fecha);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crsP;
    }
    
    // Hace falta recibir como parametro el mes y el año en que se van a realizar los cortes del tiempo de los productos y los procesos
    public CachedRowSet reporteCorteTiemposProcesosM(String fecha) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ReporteCorteTiemposProcesosMes(?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, fecha);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crsP;
    }
    
    public String sumarTiemposM(String tiempo_total, String tiempo_a_sumar) {
        String tiempo_sumado="";
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_SumarTiempos(?,?);";
            ps = con.prepareStatement(Qry);
            ps.setString(1, tiempo_total);
            ps.setString(2, tiempo_a_sumar);
            rs = ps.executeQuery();
            if(rs.next()){
                tiempo_sumado = rs.getString("total_tiempo");
            }
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tiempo_sumado;
    }   
    
    public CachedRowSet consultarColoresAntisolderM() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarColoresAntisolder();";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crsP;
    }      
    
    public CachedRowSet consultarEspesorTarjetaM() {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarEspesorTarjeta();";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            //Cierre de conexiones
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return crsP;
    }        
            
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
