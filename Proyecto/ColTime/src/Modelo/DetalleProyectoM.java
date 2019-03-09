package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

public class DetalleProyectoM {

    //Constructores------------------------------------------------->
    public DetalleProyectoM() {

    }
    //Variables------------------------------------------------------>
    Conexion conexion = null;
    PreparedStatement ps = null;
    Connection con = null;
    CachedRowSet crs = null;
    ResultSet rs = null;
    boolean res = false;

    //Metodos----------------------------------------------------->
    public CachedRowSet consultarDetallesM(int area, int op) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarDetallesProyectosProduccion(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, area);
            ps.setInt(2, op);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }

    public int ValidarCnatidadPNCM(String numerOrden, int detalle, int op, String tipo, String negocio) {
        int cantidad = 0;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ValidarCantidadPNCOrigen(?,?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, Integer.parseInt(numerOrden));
            ps.setInt(2, detalle);
            ps.setInt(3, op);
            //Tipo de negocio
            int tipoN = numeroDelTipo(tipo);

            ps.setInt(4, tipoN);
            //Negocio
            if (negocio.equals("FE")) {
                ps.setInt(5, 1);
            } else if (negocio.equals("TE")) {
                ps.setInt(5, 2);
            } else {
                ps.setInt(5, 3);
            }

            rs = ps.executeQuery();
            rs.next();
            cantidad = rs.getInt(1);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return cantidad;
    }

    //Este metodo también funcionara para registrar y modificar los productos no conformes PNC.
    public boolean registrar_Detalle_Proycto(String cantidad, String area, String tipoProducto, int estado, String numerOrden, String material, int op, int id, int pnc, String procesoPNC) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "";
            if (op == 1) { // OP = 1 Tiene un PNC, OP != 1 No tiene PNC
                //Se valida si el proyecto ya tenia antecedentes registrados en esa misma ubicacion----
                Qry = "CALL PA_ValidarUbicacionPNC(?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, Integer.parseInt(numerOrden));
                ps.setString(2, procesoPNC);
                ps.setInt(3, id);
                rs = ps.executeQuery();
                rs.next();
                if (rs.getInt(1) != 0) {
                    //Se modifica siempre y cuando el proyecto tenga un PNC ya registrado en la misma ubicacion
                    modificarDetalleProyectos(numerOrden, rs.getInt(1), cantidad, material, area, tipoProducto, procesoPNC);
                } else {
                    //Si no se registra el producto no conforme desde 0 
                    Qry = "SELECT FU_RegistrarDetalleProyecto(?,?,?,?,?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, Integer.parseInt(numerOrden));
                    if (material.equals("GF")) { // Ya no se va a trabajar con una área de almacen, sino que almacen pasa a ser trabajado como un proceso.
                        //No se permitiran registrar productos no conformes de GF ni de componentes
                        if (area.equals("FE") && tipoProducto.equals("PCB")) {//Gran formato de la PCB del teclado
                            ps.setString(2, "PCB GF");
                        } else if (area.equals("FE") && tipoProducto.equals("Circuito")) {
                            ps.setString(2, "Circuito GF");
                        }
                        ps.setString(3, cantidad);
                        ps.setString(4, "ALMACEN");
                        ps.setInt(5, estado);
                        ps.setString(6, material);
                        ps.setInt(7, pnc);
                        ps.setString(8, procesoPNC);
                    } else {
                        ps.setString(2, tipoProducto);
                        ps.setString(3, cantidad);
                        ps.setString(4, area);
                        ps.setInt(5, estado);
                        ps.setString(6, material);
                        ps.setInt(7, pnc);
                        ps.setString(8, procesoPNC);
                    }
                    //Ejecucion de la sentencia 
                    rs = ps.executeQuery();
                    rs.next();
                    res = rs.getBoolean(1);
                    //Ebadir esta función siemmpre y cuando el negocio sea Almacen.
                    //Tipo de negocio
                    int idTipoProducto = 0;
                    if (!area.equals("ALMACEN")) {
                        idTipoProducto = numeroDelTipo(tipoProducto);
                    }
                    //...
                    switch(area){
                        case "FE": // Formato estandar
                            // ...
                            //Se registran los procesos de FE para este subproyecto.
                            if (material.equals("GF")) { // Se valida que sea GF.
                            //Negocio del almacen
                                //Se registran los procesos de GF en el almacen y se inicia la toma de tiempos. 
                                Qry = "CALL PA_RegistrarDetalleAlmacen(?,?,?)";
                                ps = con.prepareStatement(Qry);
                                ps.setInt(1, Integer.parseInt(numerOrden));
                                if (area.equals("FE") && tipoProducto.equals("PCB")) {//Gran formato de la PCB del teclado
                                    ps.setInt(2, 9);
                                } else if (area.equals("FE") && tipoProducto.equals("Circuito")) {
                                    ps.setInt(2, 8);
                                }
                                ps.setInt(3, 20);//Proceso de GF "20"
                                ps.execute();
                            } else {//tener en cuenta que los procesos se van a traer de la tabla procesos dependiendo del tipo de negocio!!
                                // ...
                                //Registro de Procesos del producto del área de formato estandar - FE
                                registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material, 1);
                                // ...
                            }
                            // ...
                            break;
                        case "TE": // Teclados
                            //Registro de Procesos del producto del área de Teclados - TE
                            registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material, 2);
                            break;
                        case "IN": // Ensamble
                            // ...
                            //Registro de Procesos del producto del área de Teclados - TE
                            registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material,3);
                            // ...
                            break;
                        default: // Almacen
                            //tener en cuenta que los procesos se van a traer de la tabla procesos dependiendo del tipo de negocio!!
                            Qry = "CALL PA_RegistrarDetalleAlmacen(?,?,?)";
                            ps = con.prepareStatement(Qry);
                            ps.setInt(1, Integer.parseInt(numerOrden));
                            if (tipoProducto.equals("Circuito COM")) {//Componentes de circuito.
                                ps.setInt(2, 10);
                            } else if (tipoProducto.equals("PCB COM")) {//Componentes de PCB.
                                ps.setInt(2, 11);
                            }
                            ps.setInt(3, 19);//Proceso de componentes "19".
                            ps.execute();
                            break;
                    }
//                    if (area.equals("IN")) {// Ya no se van a registrar PNC para los productos de EN
//                        //Se registran los procesos de IN para este subproyecto.
//                        Qry = "CALL PA_ConsultarIDProcesosTEYEN(?)";//Se van a consultar lo procesos de IN.
//                        ps = con.prepareStatement(Qry);
//                        ps.setInt(1, 3);//Área Ensamble
//                        rs = ps.executeQuery();
//                        while (rs.next()) {//Se registran todos los procesos
//                            Qry = "CALL PA_RegistrarDetalleEnsamble(?,?,?,?)";
//                            ps = con.prepareStatement(Qry);
//                            ps.setInt(1, Integer.parseInt(numerOrden));
//                            ps.setInt(2, idTipoProducto);
//                            if (procesoPNC == null) {
//                                ps.setString(3, "");
//                            } else {
//                                ps.setString(3, procesoPNC);
//                            }
//                            ps.setInt(4, rs.getInt(1));
//                            ps.execute();
//                        }
//                        Qry = "CALL PA_DetalleDeLosProcesosDeEnsamble(?,?,?)";//Me cuenta los procesos del producto y me actualiza el estado del proyecto.
//                        ps = con.prepareStatement(Qry);
//                        ps.setInt(1, Integer.parseInt(numerOrden));
//                        ps.setInt(2, idTipoProducto);
//                        if (procesoPNC == null) {
//                            ps.setString(3, "");
//                        } else {
//                            ps.setString(3, procesoPNC);
//                        }
//                        ps.execute();
//                        //Registro de Procesos del producto del área de Teclados - TE
//                        registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material,1);
//                        
//                    } else if (area.equals("TE")) {// Ya no se van a registrar PNC para los productos de TE
//                        //Se registran los procesos de TE para este subproyecto. 
//                        Qry = "CALL PA_ConsultarIDProcesosTEYEN(?)";//Se van a consultar lo procesos de TE.
//                        ps = con.prepareStatement(Qry);
//                        ps.setInt(1, 2);//Área Teclados
//                        rs = ps.executeQuery();
//                        while (rs.next()) {
//                            Qry = "CALL PA_RegistrarDetalleTeclados(?,?,?,?)";
//                            ps = con.prepareStatement(Qry);
//                            ps.setInt(1, Integer.parseInt(numerOrden));
//                            ps.setInt(2, idTipoProducto);
//                            if (procesoPNC == null) {
//                                ps.setString(3, "");
//                            } else {
//                                ps.setString(3, procesoPNC);
//                            }
//                            ps.setInt(4, rs.getInt(1));
//                            ps.execute();
//                        }
//                        //Verificacion del producto no conforme de TE
//                        Qry = "CALL PA_DetalleDeLosProcesosDeTeclados(?,?,?)";
//                        ps = con.prepareStatement(Qry);
//                        ps.setInt(1, Integer.parseInt(numerOrden));
//                        ps.setInt(2, idTipoProducto);
//                        if (procesoPNC == null) {
//                            ps.setString(3, "");
//                        } else {
//                            ps.setString(3, procesoPNC);
//                        }
//                        ps.execute();
//                        //Registro de Procesos del producto del área de Teclados - TE
//                        registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material,1);
//                        
//                    } else if (area.equals("FE")) { // Unicamente los PNC aplican para los productos de FE
//                        //Se registran los procesos de FE para este subproyecto.
//                        //Se valida que sea GF.
//                        if (material.equals("GF")) {//Negocio del almacen
//                            //Se registran los procesos de GF en el almacen y se inicia la toma de tiempos. 
//                            Qry = "CALL PA_RegistrarDetalleAlmacen(?,?,?)";
//                            ps = con.prepareStatement(Qry);
//                            ps.setInt(1, Integer.parseInt(numerOrden));
//                            if (area.equals("FE") && tipoProducto.equals("PCB")) {//Gran formato de la PCB del teclado
//                                ps.setInt(2, 9);
//                            } else if (area.equals("FE") && tipoProducto.equals("Circuito")) {
//                                ps.setInt(2, 8);
//                            }
//                            ps.setInt(3, 20);//Proceso de GF "20"
//                            ps.execute();
//                        } else {//tener en cuenta que los procesos se van a traer de la tabla procesos dependiendo del tipo de negocio!!
//                            // ...
//                            //Registro de Procesos del producto del área de formato estandar - FE
//                            registrarProcesosAreaProducto(numerOrden, idTipoProducto, procesoPNC, material,1);
////                            Qry = "SELECT FU_ConsultarelIDDetalledelproductoArea(?,?,?,?) as idDetalleProducto;";//
////                            ps = con.prepareStatement(Qry);
////                            ps.setString(1, numerOrden);
////                            ps.setInt(2, idTipoProducto);
////                            ps.setString(3, (procesoPNC==null?"":procesoPNC));
////                            ps.setInt(4, 1);
////                            rs = ps.executeQuery();
////                            rs.next();
////                            int idDetalleProducto = rs.getInt(1);
//////                          Consultar el ID de la condicion que se cumple para la asignacion de los procesos del producto...
////                            Qry = "SELECT FU_ClasificarCondicionProductoFE(?,?,?,?) as idCondicional";//
////                            ps = con.prepareStatement(Qry);
////                            ps.setString(1, numerOrden);
////                            ps.setInt(2, idTipoProducto);
////                            ps.setString(3, (procesoPNC==null?"":procesoPNC));
////                            ps.setString(4, material);
////                            rs = ps.executeQuery();
////                            rs.next();
////                            // ...
////                            int idCondicional = rs.getInt("idCondicional");
////                            // Consultar los procesos del producto que cumplio con la condición.
////                            Qry = "CALL PA_ConsultarProcesosProducto(?);";
////                            ps = con.prepareStatement(Qry);
////                            ps.setInt(1, idCondicional);
////                            rs = ps.executeQuery();
////                            // ...
////                            while(rs.next()){ //Registrar los procesos de FE que tendra el producto
////                                Qry = "CALL PA_RegistrarProcesosProductoFE(?,?,?);";
////                                ps = con.prepareStatement(Qry);
////                                ps.setInt(1, rs.getInt("idProceso"));
////                                ps.setInt(2, idDetalleProducto); //idDetalleProyecto
////                                ps.setInt(3, rs.getInt("orden"));
////                                ps.setInt(3, 1);
////                                ps.execute();
////                            }
//                        }
//                    } else {//Área del almacen Para registrar los compoennetes
//                        //tener en cuenta que los procesos se van a traer de la tabla procesos dependiendo del tipo de negocio!!
//                        Qry = "CALL PA_RegistrarDetalleAlmacen(?,?,?)";
//                        ps = con.prepareStatement(Qry);
//                        ps.setInt(1, Integer.parseInt(numerOrden));
//                        if (tipoProducto.equals("Circuito COM")) {//Componentes de circuito.
//                            ps.setInt(2, 10);
//                        } else if (tipoProducto.equals("PCB COM")) {//Componentes de PCB.
//                            ps.setInt(2, 11);
//                        }
//                        ps.setInt(3, 19);//Proceso de componentes "19".
//                        ps.execute();
//                    }
                }
            } else if (op == 2) {
                modificarDetalleProyectos(numerOrden, id, cantidad, material, area, tipoProducto, procesoPNC);
            }
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }
    
    private void registrarProcesosAreaProducto(String numerOrden, int idTipoProducto, String procesoPNC, String material, int area){
        // ...
        String Qry="";
        try {
            Qry = "SELECT FU_ConsultarelIDDetalledelproductoArea(?,?,?,?) as idDetalleProducto;";
            ps = con.prepareStatement(Qry);
            ps.setString(1, numerOrden);
            ps.setInt(2, idTipoProducto);
            ps.setString(3, (procesoPNC == null ? "" : procesoPNC));
            ps.setInt(4, area);
            rs = ps.executeQuery();
            rs.next();
            int idDetalleProducto = rs.getInt(1);
            //Consultar el ID de la condicion que se cumple para la asignacion de los procesos del producto...
            Qry = "SELECT FU_ClasificarCondicionProductoFE(?,?,?,?,?) as idCondicional";//
            ps = con.prepareStatement(Qry);
            ps.setString(1, numerOrden);
            ps.setInt(2, idTipoProducto);
            ps.setString(3, (procesoPNC == null ? "" : procesoPNC));
            ps.setString(4, material);
            ps.setInt(5, area);
            rs = ps.executeQuery();
            rs.next();
            // ...
            int idCondicional = rs.getInt("idCondicional");
            // Consultar los procesos del producto que cumplio con la condición.
            Qry = "CALL PA_ConsultarProcesosProducto(?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idCondicional);
            rs = ps.executeQuery();
            // ...
            while (rs.next()) { //Registrar los procesos de FE que tendra el producto
                Qry = "CALL PA_RegistrarProcesosProductoFE(?,?,?,?);";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, rs.getInt("idProceso"));
                ps.setInt(2, idDetalleProducto); //idDetalleProyecto
                ps.setInt(3, rs.getInt("orden"));
                ps.setInt(4, area);
                ps.execute();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // ...
    }

    private int numeroDelTipo(String tipoNegocio) {
        int tipo = 0;
        switch (tipoNegocio) {
            case "Circuito":
                tipo = 1;
                break;
            case "Conversor":
                tipo = 2;
                break;
            case "PCB":
                tipo = 7;
                break;
            case "Repujado":
                tipo = 3;
                break;
            case "Stencil":
                tipo = 6;
                break;
            case "Teclado":
                tipo = 5;
                break;
            case "Troquel":
                tipo = 4;
                break;
            case "Circuito GF":
                tipo = 8;
                break;
            case "PCB GF":
                tipo = 9;
                break;
            case "Circuito COM":
                tipo = 10;
                break;
            case "PCB COM":
                tipo = 11;
                break;
            case "Circuito-TE":
                tipo = 12;
                break;
        }
        return tipo;
    }

    public boolean validarEliminacionModificarM(int orden, int negocio, int tipo, int detalle, int accion) {//El busqueda no es necesario
        //PA_EliminarProductosNoConformes(?,?,?)
        try {
            String Qry = "";
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            ResultSet rs1 = null;
            if (accion == 2) {
                //Validar la eliminación de solo un detalle PNC
                Qry = "SELECT FU_validarEliminacion(?,?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, detalle);
                ps.setInt(2, orden);
                ps.setInt(3, tipo);
                ps.setInt(4, negocio);

                rs = ps.executeQuery();
                rs.next();
                res = rs.getBoolean(1);
            } else {
                //Validar la eliminación de muchos detalles de proyecto
                Qry = "CALL PA_EliminarProductosNoConformes(?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, orden);
                ps.setInt(2, tipo);
                ps.setInt(3, negocio);
                rs = ps.executeQuery();
                while (rs.next()) {
                    Qry = "SELECT FU_validarEliminacion(?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, rs.getInt(1));
                    ps.setInt(2, orden);
                    ps.setInt(3, tipo);
                    ps.setInt(4, negocio);

                    rs1 = ps.executeQuery();
                    rs1.next();
                    res = rs1.getBoolean(1);
                    if (!res) {
                        break;
                    }
                }
            }
            //Cierre de conexión
            conexion.cerrar(rs);
            conexion.cerrar(rs1);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, e);
        }
        return res;
    }
//----------------------------------------------
// Pendiente seguir desarrollando
    private void modificarDetalleProyectos(String numerOrden, int idDetalleProyecto, String cantidad, String material, String area, String tipoProducto, String procesoPNC) {
        //PreparedSteamate y detalle----------------------------------->
        try {
            String Qry = "";
            int idTipoProducto = numeroDelTipo(tipoProducto);
            //1-Modificar la informacion del producto detalle del proyecto
            Qry = "SELECT FU_ModificarDetalleProyecto(?,?,?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, Integer.parseInt(numerOrden));
            ps.setInt(2, idDetalleProyecto);
            ps.setString(3, cantidad);
            ps.setString(4, material);
            if (material.equals("GF")) {
                ps.setInt(5, 4);
            } else {
                if (area.equals("FE")) { //Formato estandar
                    ps.setInt(5, 1);
                } else if (area.equals("TE")) { //Teclados
                    ps.setInt(5, 2);
                } else if (area.equals("IN")) { //Ensamble
                    ps.setInt(5, 3);
                }
            }
            ps.setString(6, procesoPNC);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            // 2- Eliminar los procesos del producto del proyecto siempre y cuando <-Pendiente
            Qry="CALL PA_EliminarProcesosProducto(?);"; // <-Pendiente continuar
            ps = con.prepareStatement(Qry);
            ps.setInt(1 ,idDetalleProyecto);
            rs = ps.executeQuery();
            // ...
            Qry = "SELECT FU_ClasificarCondicionProductoFE(?,?,?,?) as idCondicional";//
            ps = con.prepareStatement(Qry);
            ps.setString(1, numerOrden);
            ps.setInt(2, idTipoProducto);
            ps.setString(3, (procesoPNC == null ? "" : procesoPNC));
            ps.setString(4, material);
            rs = ps.executeQuery();
            rs.next();
            // ...
            int idCondicional = rs.getInt("idCondicional");
            // Consultar los procesos del producto que cumplio con la condición.
            Qry = "CALL PA_ConsultarProcesosProducto(?);";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idCondicional);
            rs = ps.executeQuery();
            // ...
            while (rs.next()) { //Registrar los procesos de FE que tendra el producto
                Qry = "CALL PA_RegistrarProcesosProductoFE(?,?,?);";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, rs.getInt("idProceso"));
                ps.setInt(2, idDetalleProyecto);
                ps.setInt(3, rs.getInt("orden"));
                ps.execute();
            }
            // ...................................................................................................
            
            if (!material.equals("GF")) {
                // ...
                if (area.equals("FE") && (tipoProducto.equals("Circuito") || tipoProducto.equals("PCB"))) {
                    //Modificar procesos de formato estandar
                    //Consultar condicion que aplica para esta modificación
                    
                    //Validar que procesos se van a modificar
                    Qry = "CALL PA_ModificarDetalleFormatoEstandar(?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, Integer.parseInt(numerOrden));
                    ps.setInt(2, idDetalleProyecto);
                    ps.setString(3, material.trim());
                    rs = ps.executeQuery();
                }
            }
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null,"Error: " + e);
        }
    }

    public CachedRowSet generar_ReportesM() {//
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ReporteGeneral()";
            ps = con.prepareStatement(Qry);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }
    
    public CachedRowSet generarReporteAreaTiemposM(int area, String fechaI, String fechaF){
        try {
            conexion =new Conexion(1);
            conexion.establecerConexion();
            con=conexion.getConexion();
            //Quey------------------------------------------------------------->
            String Qry= "CALL PA_ReporteTiemposAreaProduccion(?,?,?)";
            ps=con.prepareStatement(Qry);
            ps.setInt(1, area);
            ps.setString(2, fechaI);
            ps.setString(3, fechaF);
            rs=ps.executeQuery();
            crs=new CachedRowSetImpl();
            crs.populate(rs);
            //Cirre de conexiones
            ps.close();
            con.close();
            conexion.cerrar(rs);
            conexion.destruir();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null,e);
        }
        return crs;
    }

    public CachedRowSet consultar_Detalle_Proyecto(String numeOrden, int estado) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarDetalleProyecto(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setString(1, numeOrden);
            ps.setInt(2, estado);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }

    public CachedRowSet consultarprocesosFE(int detalle) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ConsultarProcesosFE(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }

    public boolean cambiar_Estado_Detalle() {

        return true;
    }
//Este es el detalle del la orden deacuerdo en donde se encuentren los detalles

    public CachedRowSet consultarDetalleProyectoProduccion(int orden, int negocio, int vistaC) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "";
            switch (vistaC) {
                case 1:// FE
                case 2:// TE
                case 4:// Almacen
                    Qry = "CALL PA_DetalleProyectosProduccion(?,?,?)";
                    break;
                case 3:// EN
                    Qry = "CALL PA_DetalleDeProduccionProyectosActivos(?,?,?)";
                    break;
            }
            //----------------------------------------------------------------->
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            ps.setInt(2, negocio);
            if (vistaC == 1 || vistaC == 3 || vistaC == 4) {
                ps.setInt(3, 0);//Negativo para productos no conforme
            } else {
                ps.setInt(3, 1);//Positivo para un producto no conforme
            }
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }

    public boolean eliminarDetallersProyecto(int idDetalle, int numeOrden, String negocio, String tipo, int accion) {
        //Eliminar detalle del proyecto, detalle de formato estandar, detalle de teclado y detalle de ensamble
        String Qry = null;
        int n = 0;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            ResultSet rs1 = null;

            //numero de tipo de negocio
            if (negocio.equals("FE")) {
                n = 1;
            } else if (negocio.equals("TE")) {
                n = 2;
            } else if (negocio.equals("IN")) {
                n = 3;
            } else if (negocio.equals("ALMACEN")) {
                n = 4;
            }
            if (accion == 2) {
                //Eliminar un solo detalle de PNC
                eliminarDetalleProyecto(negocio, numeOrden, rs, idDetalle);
            } else {
                //Eliminar muchos detalles y PNC
                Qry = "CALL PA_EliminarProductosNoConformes(?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, numeOrden);
                //Numero del tipo de producto
                int numeroTipo = numeroDelTipo(tipo);

                ps.setInt(2, numeroTipo);

                ps.setInt(3, n);
                //Ejecucion del procedimiento almacenado
                rs = ps.executeQuery();
                while (rs.next()) {
                    eliminarDetalleProyecto(negocio, numeOrden, rs1, rs.getInt(1));
                }
            }
            //Validar detalles para validar estado del proyecto
            Qry = "CALL PA_DetallesparaValidarEstado(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, numeOrden);
            //ps.setInt(2, n);
            rs = ps.executeQuery();
            //Detalles  a validar
            while (rs.next()) {
                Qry = "CALL PA_CambiarEstadoDeProductos(?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, rs.getInt(2));
                ps.setInt(2, rs.getInt(1));
                ps.execute();
            }
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.cerrar(rs1);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    private boolean eliminarDetalleProyecto(String negocio, int numeOrden, ResultSet rs1, int detalle) {
        //Query------------------------------------------------------------>
        int n = 0;
        try {
            String Qry = "";
            switch (negocio) {
                case "FE":
                    //Quiery para eliminar el detalle de formato estandar
                    Qry = "SELECT FU_EliminarDetalleProyectoFormatoestandar(?,?)";
                    n = 1;
                    break;
                case "TE":
                    Qry = "SELECT FU_EliminarDetalleProyectoTeclados(?,?)";
                    n = 2;
                    break;
                case "IN":
                    Qry = "SELECT FU_EliminarDetalleProyectoEnsamble(?,?)";
                    n = 3;
                    break;
                case "ALMACEN":
                    Qry = "SELECT FU_EliminarDetalleProyectoAlmacen(?,?)";
                    n = 4;
                    break;
            }
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, numeOrden);
            //Ejecucion
            rs1 = ps.executeQuery();
            rs1.next();
            res = rs1.getBoolean(1);
            //No se pueden ejecutar
//            conexion.cerrar(rs);
//            conexion.destruir();
//            ps.close();
//            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;
    }

    public CachedRowSet consultarDetalleProduccion(int detalle, int negocio) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_DetalleDelDetalleDelproyecto(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, negocio);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }
    
    public boolean consultarEstadoDetalleProyectoM(int detalle) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "SELECT FU_ConsultarEstadoDetalleProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            rs = ps.executeQuery();
            rs.next();
            res=rs.getBoolean(1);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public boolean ReiniciarDetalle(int detalle, int negocio, int detalleproducto) {
        //Cuerpo del procedimiento
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "SELECT FU_ReiniciarTiempo(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, negocio);
            rs = ps.executeQuery();
            rs.next();
            res = rs.getBoolean(1);
            //Cierre de conexiones
            FE_TE_INM produccion = new FE_TE_INM();
            //Se actualiza la suma total de tiempos totales de procesos
            produccion.calculatTiempoTotalProducto(detalleproducto, negocio);
            //Se actualiza el total de producto por minuto siempre y cuando el estado del producto sea terminado
            produccion.calcularTiempoTotalPorUnidad(detalleproducto, negocio);
            //...
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    public CachedRowSet ConsultarInformacionFiltrariaDelDetalleM(int detalle) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_InformacionFiltrariaDetalleProyecto(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            rs = ps.executeQuery();
            crs = new CachedRowSetImpl();
            crs.populate(rs);
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return crs;
    }
    
    public boolean seleccionPrimerProcesoENoTEM(int detalle, int idProceso, int area){
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_selccionarPrimerProcesoProyectosENoTE(?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, idProceso);
            ps.setInt(3, area);
            res = !ps.execute();
            //Cierre de conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "¡Error!" + e);
        }
        return res;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
