package Modelo;

import com.sun.rowset.CachedRowSetImpl;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.sql.rowset.CachedRowSet;
import javax.swing.JOptionPane;

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
    String T_Total = "";
    int cantidadAntigua = 0;
    int estado = 0;
    boolean accion=true;

    //Metodos------------------------------------------------->
    //No se te olvide tener en cuenta el id del lector y concatenar a la informacion despues de leer el código QR***
    //Depurar esta seccion de còdigo para optimizarlo...
public boolean iniciar_Pausar_Reiniciar_Toma_Tiempo(int orden, int detalle, int negocio, int lector, int cantidadTerminada, int operarios, PrintStream myPS, int procesoPasoCantidades) {
        //Falta hacer que se puedan poner varias tomas de tiempo del mismo proceso al mismo tiempo.
        //Realizar una validacion adicional, el sistema no me va a dejar iniciar la toma de tiempo del proceso si no se le a pasado cantidades terminadas de un proceso anterior. Tener en cuenta teclados.
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
            //Query------------------------------------------------------------>
            String Qry = "Select FU_ValidarTomaDeTiempo(?,?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, orden);
            ps.setInt(2, detalle);
            ps.setInt(3, lector);
            ps.setInt(4, negocio);
            rs = ps.executeQuery();
            rs.next();
            if (rs.getBoolean(1)) {//Pausar O IniciarToma de tiempos
                //-------------------------------------------------------------->
                if(negocio==3){
                    //Validar el sub proceso al cual se va a enviar la informacion
//                    if((procesoPasoCantidades!=0 && lector!=18) || ((procesoPasoCantidades==0 || procesoPasoCantidades!=18) && lector==18)){
                        //Validar que la cantidad ingresada por el operario sea igual o menor a la cantidad que tiene disponible este proceso para trabajar
                        Qry = "SELECT FU_ValidarCantidadParaProcesosEnsamble(?,?);";
                        ps = con.prepareStatement(Qry);
                        ps.setInt(1, detalle);
                        ps.setInt(2, lector);
                        rs = ps.executeQuery();
                        if (rs.next()) {
                            if (cantidadTerminada <= rs.getInt(1)) {
                                accion = true;
                            } else {
                                accion = false;
                            }
                        }   
//                    }else{
//                        accion=false;
//                    }
                }
                //...
                int restante=0;
                //...
                if(accion){
                    if(negocio!=3){//Si el área de produccion es "1"=Formato estandar o "2"=Teclados el estado se calcula desde el modelo
                        Qry = "CALL PA_ValidarCantidadDetalleProyecto(?,?,?,?)";//Esto me trae tres cosas: Cantidad total del proyecto
                        ps = con.prepareStatement(Qry);
                        ps.setInt(1, orden);
                        ps.setInt(2, detalle);
                        ps.setInt(3, lector);
                        ps.setInt(4, negocio);
                        rs = ps.executeQuery();
                        rs.next();
                        //Tener en cuenta que tienes que mostrar un mensaje en el celular.(Pendiente para futuras versiones)
                        //Si la cantidad terminada ingresada es menos a la cantidad que en total se deben realizar un registro sin ningun problema.
                        if (rs.getInt(2) + cantidadTerminada < rs.getInt(1)) {
                            //Si la afirmación es correcta se ejecutara el procedimiento para parar el tiempo.
                            cantidadAntigua = rs.getInt(2);
                            estado = 2;
                            //Si la cantidad terminada ingresada es igual a la cantidad que en total se deben realizar un registro sin ningun problema.
                        } else if (rs.getInt(2) + cantidadTerminada == rs.getInt(1)) {
                            cantidadAntigua = rs.getInt(2);
                            estado = 3;
                            //Calcular cantidad por unidad.
                            //Si la cantidad terminada ingresada es mayor a la cantidad que en total se deben realizar no se debe realizar ninguna acción.
                        } else {
                            cantidadAntigua = rs.getInt(2);
                            estado = 0;
                        }
                        //---------
                        restante = rs.getInt(1) - (cantidadTerminada + cantidadAntigua);//Esta es la cantidad restante del proceso.
                        //---------
                        operarios = rs.getInt(3);//El numero de operarios que va a trabajar en el proceso.
                        //---------
//                int pasadas=rs.getInt(1)-restante;//El numero de las cantidades disponibles para que el otro proyecto las pueda trabajar.
                        //---------
                        // si el estado es dos o tres (2 o 3) procedera a realizar la actualización. 31344;2;3;16;1;1  
                    }else{//Si el área de produccion es "3"=Ensamble entonces no va a realizar el calcular el estado del proceso desde el modelos sino desde la base de datos de una manera diferente.
                        estado=2;
                    }
                  //...
                }else{
                    estado=0;
                }
                //Validar que el proceso si tenga cantidades para pasar...
                if (estado != 0) {
                    //...
                    Qry = "CALL PA_CalcularTiempoMinutos(?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, orden);
                    ps.setInt(2, detalle);
                    ps.setInt(3, lector);
                    ps.setInt(4, negocio);
                    rs = ps.executeQuery();
                    rs.next();
                    T_Total = convertirHorasAMinutos(rs.getString(1).split(":"), rs.getString(2).split(":"), operarios);
                    //...
                    Qry = "CALL PA_PausarTomaDeTiempoDeProcesos(?,?,?,?,?,?,?,?,?,?)";//NOTA: Para el área de ensamble se van a enviar dos procesos el cual al primero se le van a restar las cantidades terminadas y al segundo se le van a sumar las cantidades terminadas
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, orden);
                    ps.setInt(2, detalle);
                    ps.setInt(3, lector);
                    ps.setInt(4, negocio);
                    ps.setString(5, String.valueOf(T_Total));
//                    ps.setInt(6, (cantidadTerminada+cantidadAntigua));
                    ps.setInt(6, cantidadTerminada);
                    ps.setInt(7, cantidadAntigua);
                    ps.setInt(8, estado);
                    ps.setInt(9, restante);//Cantidad de productos restantes!!
                    ps.setInt(10, procesoPasoCantidades);
                    ps.execute();//Respuesta es igual a True para poder agregar los botones, Ya no es necesario esta respuesta para buscar los botones
                    res=true;
                    //Promedio de producto por minuto.
                    cantidadProductoMinuto(detalle, negocio, lector);
                    //Tiempo total del proceso.
                    actualizarTotalTiempoProyecto(detalle, negocio);
                    //Timepo total por unidad...
                    totalTiempoPorUnidad(detalle, negocio);
                    //Si no cumple la condición va a retornar un falso y monstrara una mensaje de advertencia.
                    //...
                } else {
                    res = false;
                    //Se enviara desde acá el mensaje al lector diciendo que la cantidad para el proyecto no es la adecuada(Al celular)...................................
//                 enviarMensajeCelular("Mensaje", cps);//Mensaje para el celular
                    //Esta por definir por que medio se enviara el mensaje al celular.
                }
            } else {
                //Si no existe se ejecutara el procedimiento para iniciar o renaudar el tiempo
                //...
                if(negocio==3){//Validar que este proyecto ya se tenga un proceso selccionado para iniciar
                    //Para ensamble: Validar que si no tiene un orden establecido en los procesos no se puede iniciar ningun proceso de ensamble
//                    Pendiente realizar esta validacion
                    Qry = "SELECT FU_ValidarProcesoInicioProcesoEnsamble(?)";//Pendiente generar la funcion
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, detalle);
                    rs = ps.executeQuery();
                    rs.next();
                    if(rs.getInt(1)==1){//Si tiene selccionado el proceso inicial de ensamble retornara un 1 si no retornara un 0
                        //Para ensamble: Validar si tiene cantidades para procesar, sino tiene entonces no se iniciaria el proceso.
                        Qry = "SELECT FU_ValidarCantidadParaProcesosEnsamble(?,?);";
                        ps = con.prepareStatement(Qry);
                        ps.setInt(1, detalle);
                        ps.setInt(2, lector);
                        rs = ps.executeQuery();
                        if (rs.next()) {
                            if (Integer.parseInt(rs.getString(1)) > 0) {
                                accion = true;
                            } else {
                                accion = false;
                            }
                        }
                    }else{
                        accion=false;
                    }
                }
                //...
                if(accion){
                    Qry = "CALL PA_IniciarRenaudarTomaDeTiempoProcesos(?,?,?,?,?)";
                    ps = con.prepareStatement(Qry);
                    ps.setInt(1, orden);
                    ps.setInt(2, detalle);
                    ps.setInt(3, lector);
                    ps.setInt(4, negocio);
                    ps.setInt(5, operarios);
                    res = !ps.execute();//Respuesta es igual a True para poder agregar los botones  
                }else{
                    res=false;
                }
                //...
            }
            con.close();
            conexion.destruir();
            conexion.cerrar(rs);
            ps.close();
            System.gc();//Garbage collector...
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;
    }

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

            }
            //Pendiente.........................................................
            //Cerrar conexiones
            conexion.cerrar(rs);
            conexion.destruir();
            ps.close();
            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return res;//Falta asignarle este true a una variable
    }

    public void totalTiempoPorUnidad(int detalle, int negocio) {
        try {
            String Qry = "CALL PA_ValidarEstadoProyecto(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, negocio);
            rs = ps.executeQuery();
            String tiempoTotalProducto = totalTiempoProyectoyProducto(rs);
            if (!tiempoTotalProducto.equals("00:00")) {
                Qry = "CALL PA_ActualizarTiempoTotalPorUnidad(?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, detalle);
                ps.setString(2, String.valueOf(tiempoTotalProducto));
                ps.executeQuery();
            } else {
                //Actualizar el tiempo total por unidad a null
            }
            //Cierre de conexiones
            //No se puede cerra la conexion desde acá
//            conexion.cerrar(rs);
//            conexion.destruir();
//            ps.close();
//            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    private String totalTiempoProyectoyProducto(ResultSet crsT) {
        int minutos = 0;
        int segundos = 0;
        String tiempo[] = null;
        String cadena = "00:00";
        try {
            while (crsT.next()) {
                tiempo = crsT.getString(1).split(":");
                segundos += Integer.parseInt(tiempo[1]);
                minutos += Integer.parseInt(tiempo[0]);
            }
            //Convrtir minutos a segundos
            while (segundos >= 60) {
                minutos++;
                segundos = segundos - 60;
            }
            //Cadena de String
            cadena = (((minutos <= 9) ? "0" : "") + minutos + ":" + ((segundos <= 9) ? "0" : "") + segundos);
        } catch (Exception e) {
            //Mensaje de error---
        }
        return cadena;
    }

    public void actualizarTotalTiempoProyecto(int detalle, int negocio) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
//          Query------------------------------------------------------------>
            String Qry = "CALL PA_TiempoProceso(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, negocio);
            rs = ps.executeQuery();
            String cadena = totalTiempoProyectoyProducto(rs);

            //Código...
            Qry = "CALL PA_ActualizarTiempoTotalProducto(?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setString(2, cadena);
            ps.execute();
            //...
            //No se puede ejecutar el cierre de conexiones
            //Cierre de conexiones
//            conexion.cerrar(rs);
//            conexion.destruir();
//            ps.close();
//            con.close();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    private void cantidadProductoMinuto(int detalle, int negocio, int lector) {
        try {
            conexion = new Conexion(1);
            conexion.establecerConexion();
            con = conexion.getConexion();
//            Query------------------------------------------------------------>
            String Qry = "CALL PA_PromedioProductoPorMinuto(?,?,?)";
            ps = con.prepareStatement(Qry);
            ps.setInt(1, detalle);
            ps.setInt(2, negocio);
            ps.setInt(3, lector);
            rs = ps.executeQuery();

            if (rs.next()) {
                String timeP = porMinuto(rs.getString(1), Integer.parseInt(rs.getString(2)));
                //Código...
                Qry = "CALL PA_ActualizarProductoPorMinuto(?,?,?,?)";
                ps = con.prepareStatement(Qry);
                ps.setInt(1, detalle);
                ps.setInt(2, negocio);
                ps.setInt(3, lector);
                ps.setString(4, timeP);
                ps.execute();
                //...
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
    }

    public String porMinuto(String timepo, int cantidad) {
        String ms[] = timepo.split(":");
        //Se convierte todo en segundos
        int segundos = (Integer.parseInt(ms[0]) * 60) + Integer.parseInt(ms[1]);
        //Se realiza el promedio
        int promedioEntero = (int) Math.ceil(segundos / cantidad);
        //Se convertira a minutos y segundos otra vez...
        String resultado = "";
        int minutos = 0;
        while (promedioEntero >= 60) {

            minutos++;
            promedioEntero = promedioEntero - 60;

        }
        resultado = ((minutos <= 9) ? "0" : "") + minutos + ":" + ((promedioEntero <= 9) ? "0" : "") + promedioEntero;

        return resultado;
    }

    private String convertirHorasAMinutos(String total[], String hora[], int operarios) {
        int h = 0, m = 0, s = 0, ma = 0, sa = 0;
        String tiempoMS = "";
        //Horas, minutos y segundos
        h = Integer.parseInt(hora[0]);
        m = Integer.parseInt(hora[1]);
        s = Integer.parseInt(hora[2]);
        //Minutos y segundos antiguos
        ma = Integer.parseInt(total[0]);
        sa = Integer.parseInt(total[1]);
        if (h >= 1) {
            //Vamos a convertir las horas en minutos siempre y cuando las horas sean mayores a 0 le sumaremos los minutos antiguos.
            m += (h * 60);
        }
        //Tiempo * Numero de operarios----------------------------------------->
        m = m * operarios;//Se multiplican los minutos trabajados por la cantidad de operarios que trabajaron en ese proceso de un proyecto asignado.
        s = s * operarios;//Igualmente se hace con los segundos.
        //--------------------------------------------------------------------->
        //Sumamos los segundos nuevos con los segundos antiguos
        s += sa;
        m += ma;
        while (s >= 60) {
            s = (s - 60);
            m += 1;
        }
        tiempoMS = ((m <= 9) ? "0" : "") + m + ":" + ((s <= 9) ? "0" : "") + s;

        return tiempoMS;
    }

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
            JOptionPane.showMessageDialog(null, "Error! " + e);
        }
        return crsP;
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();//Este metodo obliga a la intancia se elimine sola y libere el espacio en el puntero.
    }

}
