package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.sql.rowset.CachedRowSet;

public class FE_TE_INM {

    //Constructores--------------------------------------------->
    public FE_TE_INM() {

    }
//variables--------------------------------------------------->
    public CachedRowSet crsP = null;
    Conexion conexion = null;
    PreparedStatement ps = null;
    Connection con = null;
    ResultSet rs = null;
    boolean res;
    String orden = "";
    String fecha = "";
//    String Tiempo_Total = "";
    int cantidadAntigua = 0;
    int estado = 0;
    boolean accion = true;

    //Metodos------------------------------------------------->
    //No se te olvide tener en cuenta el id del lector y concatenar a la informacion despues de leer el código QR***
    //Depurar esta seccion de còdigo para optimizarlo...
    public boolean iniciar_Pausar_Reiniciar_Toma_Tiempo(int numeroOrden, int idDetalle, int area, int idLector, int cantidadTerminada, int operarios, PrintStream myPS, int procesoPasoCantidades, int cantiProductosQR) {
        // Queda pendiente la toma de tiempos del área de almacen
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "Select FU_ValidarTomaDeTiempo(?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, numeroOrden);
            ps.setInt(2, idDetalle);
            ps.setInt(3, idLector);
            ps.setInt(4, area);
            rs = ps.executeQuery();
            rs.next();
            if (rs.getBoolean(1)) {//Pausar O IniciarToma de tiempos
                //-------------------------------------------------------------->
                // Queda pendiente la forma de realizar la toma de tiempos del área del almacen!!!!
                if (area != 4) {
                    //Validar que la cantidad ingresada por el operario sea igual o menor a la cantidad que tiene disponible este proceso para trabajar
                    Qry = "SELECT FU_ValidarCantidadProcesoAreasProduccion(?,?,?);";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, idDetalle);
                    ps.setInt(2, idLector);
                    ps.setInt(3, area);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        if (cantidadTerminada <= rs.getInt(1)) {
                            accion = true;
                        } else {
                            accion = false;
                        }
                    }
                }
                //...
                int cantidadProceso = 0;
                //...
                //Validar que el proceso si tenga cantidades para pasar...
                if (accion) {
                    //...
                    Qry = "CALL PA_CalcularTiempoEjecucionProceso(?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, idDetalle);
                    ps.setInt(2, idLector);
                    ps.setInt(3, area);
                    ps.setInt(4, cantiProductosQR);
                    rs = ps.executeQuery();
                    rs.next();
                    // ...
                    //Si el proceso que pasa la cantidades es igual al proceso que recibe las cantidades entonces el proceso al que pasa las cantidades va a ser 0
                    if (idLector == procesoPasoCantidades) {//Se hace para evitar que me coloque las cantidades terminadas en el mismo proceso
                        procesoPasoCantidades = 0;
                    }
                    // ...
                    Qry = "CALL PA_PausarTomaDeTiempoDeProcesos(?,?,?,?,?,?,?,?,?)";// <- Revisar procedimiento almacenado para eliminar el parametro de estado.
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, numeroOrden);
                    ps.setInt(2, idDetalle);
                    ps.setInt(3, idLector);
                    ps.setInt(4, area);
                    ps.setString(5, rs.getString("tiempoTotal"));
                    ps.setInt(6, cantidadTerminada);
                    ps.setInt(7, cantidadAntigua);
                    ps.setInt(8, cantidadProceso);
                    ps.setInt(9, procesoPasoCantidades);
                    ps.execute();//Respuesta es igual a True para poder agregar los botones, Ya no es necesario esta respuesta para buscar los botones
                    res = true;
                    // ...
                    calcularPromedioProductoPorMinuto(idDetalle, area, idLector);// Terminado <- pendiente probar correciones
                    // ...
                    calculatTiempoTotalProducto(idDetalle, area);// terminado <- Pendiente probar correcciones
                    // ...
                    calcularTiempoTotalPorUnidad(idDetalle, area);// Esto va a cambiar
                    //...
                } else {
                    res = accion;
                    //Se enviara desde acá el mensaje al lector diciendo que la cantidad para el proyecto no es la adecuada(Al celular)...................................
//                 enviarMensajeCelular("Mensaje", cps);//Mensaje para el celular v2.0
                    //El mensaje a celular se retornara mediante un HTTPresponse...
                }
            } else {
                //Si no existe se ejecutara el procedimiento para iniciar o renaudar el tiempo
                //...
                if (area != 4) {//El área tiene que ser diferente al "4"=Almacen
                    //Validar que el procesos que se quiere iniciar tenca cantidades para procesar
                    Qry = "SELECT FU_ValidarCantidadProcesoAreasProduccion(?,?,?);";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, idDetalle);
                    ps.setInt(2, idLector);
                    ps.setInt(3, area);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        if (Integer.parseInt(rs.getString(1) != null ? rs.getString(1) : "0") > 0) {
                            accion = true;
                        } else {
                            accion = false;
                        }
                    }
                }
                //...
                if (accion) {
                    Qry = "CALL PA_IniciarRenaudarTomaDeTiempoProcesos(?,?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, numeroOrden);
                    ps.setInt(2, idDetalle);
                    ps.setInt(3, idLector);
                    ps.setInt(4, area);
                    ps.setInt(5, operarios);
                    res = ps.execute();// retorna true si la funcion fue ejecutada correctamente  
                } else {
                    res = false;
                }
                //...
            }
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
            //Garbage collector...
            System.gc();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    // Esto va a cambiar <-- Pendiente
    public boolean pararTiempoAlmacen(int orden, int detalle, int cantidad, int detalleproducto, int proceso) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Falta calcular el estado
            String Qry = "";
            if (proceso == 20) {//El proceso de gran formato es el "20"
                Qry = "CALL PA_ValidarCantidadDetalleProyecto(?,?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, orden);
                ps.setInt(2, detalleproducto);
                ps.setInt(3, proceso);
                ps.setInt(4, 4);//Negocio de almacen
                rs = ps.executeQuery();
                rs.next();
                //Si la cantidad terminada ingresada es menos a la cantidad que en total se deben realizar.
                if (rs.getInt(2) + cantidad < rs.getInt(1)) {
                    //Si la afirmación es correcta se ejecutara el procedimiento para parar el tiempo.
                    cantidadAntigua = rs.getInt(2);
                    estado = 4;
                    //Si la cantidad terminada ingresada es igual a la cantidad que en total se deben realizar.
                } else if (rs.getInt(2) + cantidad == rs.getInt(1)) {
                    cantidadAntigua = rs.getInt(2);
                    estado = 3;
                    //Si la cantidad terminada ingresada es mayor a la cantidad que en total se deben realizar.
                } else {
                    cantidadAntigua = rs.getInt(2);
                    estado = 0;
                }
            } else {
                //estado terminado de los componentes del almacen.
                estado = 3;
            }

            if (estado != 0) {
                Qry = "CALL PA_PararTomaDeTiempoAlmacen(?,?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, detalleproducto);
                ps.setInt(2, proceso);
                ps.setInt(3, cantidad + cantidadAntigua);
                ps.setInt(4, estado);
                res = !ps.execute();

            } else {
                //Mensaje que la cantidad no es la optima para realizar el procedimiento(Al computador).............................
                // ...
            }
            //Pendiente.........................................................
            //Cerrar conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error! " + e);
            e.printStackTrace();
        }
        return res;//Falta asignarle este true a una variable
    }

    public void calcularTiempoTotalPorUnidad(int idDetalleProducto, int area) {// Esto genera un error
        ResultSet rs = null;
        try {
            String Qry = "CALL PA_ConsultarTiempoPorUnidadProcesosTerminados(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idDetalleProducto);
            ps.setInt(2, area);
            rs = ps.executeQuery();
            // ...
            String tiempoTotalProducto = sumarTiempos(rs);//
            // ...
            if (!tiempoTotalProducto.equals("00:00:00")) {
                
                Qry = "CALL PA_ActualizarTiempoTotalPorUnidad(?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, idDetalleProducto);
                ps.setString(2, tiempoTotalProducto);
                ps.executeQuery();
                
            }
            // ...
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

////  Esto lo puede realizar la base de datos
    private String sumarTiempos(ResultSet rsTiempos) {
        ResultSet rs = null;
        String tiempo = "00:00:00";
        //...
        try {
            if (rsTiempos.next()) {
                do {
                    ps = con.prepareStatement("CALL PA_SumarTiempos(?,?);");
                    ps.setString(1, tiempo);
                    ps.setString(2, rsTiempos.getString(1));
                    rs = ps.executeQuery();
                    if (rs.next()) {

                        tiempo = rs.getString("total_tiempo");

                    }
                } while (rsTiempos.next());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        // ...
        return tiempo;
    }

    public void calculatTiempoTotalProducto(int idDetalleProducto, int area) {
        ResultSet rs = null;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
//          Query------------------------------------------------------------>
            String Qry = "CALL PA_TiempoEjecucionProceso(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idDetalleProducto);
            ps.setInt(2, area);
            rs = ps.executeQuery();
            // ...
            String tiempo_total = sumarTiempos(rs);// sumarTiempos
            // ...
            Qry = "CALL PA_ActualizarTiempoTotalProducto(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idDetalleProducto);
            ps.setString(2, tiempo_total);
            ps.execute();
            //...
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void calcularPromedioProductoPorMinuto(int idDetalleProyecto, int area, int idLector) {// Revisar...
        ResultSet rs = null;
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
//          Query------------------------------------------------------------>
            String Qry = "CALL PA_PromedioProductoPorMinuto(?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, idDetalleProyecto);
            ps.setInt(2, area);
            ps.setInt(3, idLector);
            rs = ps.executeQuery();
            // ...
            if (rs.next()) {
                //...
                Qry = "CALL PA_ActualizarProductoPorMinuto(?,?,?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, idDetalleProyecto);
                ps.setInt(2, area);
                ps.setInt(3, idLector);
                ps.setString(4, rs.getString("tiempo_total_por_proceso"));
                ps.setInt(5, rs.getInt("cantidad_terminada"));
                ps.execute();
                //... SELECT SEC_TO_TIME(ROUND((TIME_TO_SEC("00:05:00")/2),0))
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

//    public String procesoPorMinuto(String timepo, int cantidad) {
//        String ms[] = timepo.split(":");// 0= Minutos, 1= Segundos
//        //Se convierte todo en segundos
//        int segundos = (Integer.parseInt(ms[0]) * 60) + Integer.parseInt(ms[1]);
//        //Promedio de tiempo en segundos
//        segundos = (int) Math.ceil(segundos / cantidad);
//        //Se convertira a minutos y segundos otra vez...
//        int minutos = 0;
//        while (segundos >= 60) {
//
//            minutos++;
//            segundos = segundos - 60;
//
//        }
//        // ...
//        return construirCadenaDeTiempo(minutos, segundos);
//    }
// Lo que hace esta funcion lo puede realizar la base de datos directamente
//    private String convertirHorasAMinutosYSumarTiempos(String total[], String hora[]) {
//        int h, m, s, ma, sa;
//        Horas, minutos y segundos nuevo tiempo
//        h = Integer.parseInt(hora[0]);
//        m = Integer.parseInt(hora[1]);
//        s = Integer.parseInt(hora[2]);
//        Minutos antigos y segundos antiguos
//        ma = Integer.parseInt(total[0]);
//        sa = Integer.parseInt(total[1]);
//        if (h >= 1) {
//            Vamos a convertir las horas en minutos siempre y cuando las horas sean mayores a 0 le sumaremos los minutos antiguos.
//            m += (h * 60);
//        }
//        --------------------------------------------------------------------->
//        Sumamos los segundos nuevos con los segundos antiguos
//        s += sa;
//        m += ma;
//        while (s >= 60) {
//            s = (s - 60);
//            m += 1;
//        }
//         Tiempo convertido a Minutos y segundos    
//        return ((m <= 9) ? "0" : "") + m + ":" + ((s <= 9) ? "0" : "") + s;
//    }
    public CachedRowSet consultarProyectosEnEjecucion(int negocio) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "CALL PA_ProyectosEnEjecucion(?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, negocio);
            rs = ps.executeQuery();
            crsP = new CachedRowSetImpl();
            crsP.populate(rs);
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
        } catch (Exception e) {
//            JOptionPane.showMessageDialog(null, "Error! " + e);
            e.printStackTrace();
        }
        return crsP;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();//Este metodo obliga a la intancia se elimine sola y libere el espacio en el puntero.
    }

}
