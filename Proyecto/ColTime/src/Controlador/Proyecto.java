package Controlador;

import Modelo.ProyectoM;
import javax.sql.rowset.CachedRowSet;

public class Proyecto {

    //Constructores------------------------------------------------->
    public Proyecto() {

    }
    //Variables----------------------------------------------------->
    //Atributos de la clase proyecto-------------------------------->
    private String num_orden="", 
            nombreCliente = "", 
            nombreProyecto = "",
            tipoProyecto = "",
            fecha = "",
            fechaCiccuitoFEoGF = "",
            fechaCiccuitoCOMFEoGF = "",
            fechaPCBFEoGF = "",
            fechaPCBCOMFEoGF = "",
            novedadProyecto = "",
            estadoPRoyecto = "",
            NFEE = "";
//    private int areaImplicadas = 0;
    //Get and set------------------------------------------------>

    public void setNFEE(String NFEE) {
        this.NFEE = NFEE;
    }

    public void setEstadoPRoyecto(String estadoPRoyecto) {
        this.estadoPRoyecto = estadoPRoyecto;
    }

    public void setNovedadProyecto(String novedadProyecto) {
        this.novedadProyecto = novedadProyecto;
    }

    public void setNum_orden(String num_orden) {
        this.num_orden = num_orden;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public void setNombreProyecto(String nombreProyecto) {
        this.nombreProyecto = nombreProyecto;
    }

    public void setTipoProyecto(String tipoProyecto) {
        this.tipoProyecto = tipoProyecto;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public void setFechaCiccuitoFEoGF(String fechaCiccuitoFEoGF) {
        this.fechaCiccuitoFEoGF = fechaCiccuitoFEoGF;
    }

    public void setFechaCiccuitoCOMFEoGF(String fechaCiccuitoCOMFEoGF) {
        this.fechaCiccuitoCOMFEoGF = fechaCiccuitoCOMFEoGF;
    }

    public void setFechaPCBFEoGF(String fechaPCBFEoGF) {
        this.fechaPCBFEoGF = fechaPCBFEoGF;
    }

    public void setFechaPCBCOMFEoGF(String fechaPCBCOMFEoGF) {
        this.fechaPCBCOMFEoGF = fechaPCBCOMFEoGF;
    }

    //Metodos y funciones------------------------------------------------>
    public CachedRowSet diagrama(String inicio, String fin) {
        ProyectoM obj = new ProyectoM();
        return obj.diagramaM(inicio, fin);
    }

    public boolean estadoDeOrden(int orden, int op) {
        ProyectoM obj = new ProyectoM();
        return obj.estadoDeOrdenM(orden, op);
    }

    public boolean estadoProyecto(int orden) {
        ProyectoM obj = new ProyectoM();
        return obj.estadoProyecto(orden);
    }

    public boolean registrar_Modificar_Proyecto(String comercial, int op) {
        ProyectoM modelo = new ProyectoM();
        return modelo.registrar_Modificar_Proyecto(num_orden, comercial, nombreCliente, nombreProyecto, tipoProyecto, fecha,op,fechaCiccuitoFEoGF, fechaCiccuitoCOMFEoGF, fechaPCBFEoGF, fechaPCBCOMFEoGF, novedadProyecto, estadoPRoyecto, NFEE);
    }

    //Registrar mediante un lector de QR----------------------------------------

    public boolean registrarProyectoQR(String infoP[], String comercial) {
        ProyectoM obj = new ProyectoM();
        return obj.registrarProyectoQRM(infoP, comercial);
    }

    public boolean validarProyectoQR(int orden) {
        ProyectoM obj = new ProyectoM();
        return obj.ValidarProyectoQRM(orden);
    }

    public boolean validarDetalleProyectoQR(int orden, String area, String producto) {
        ProyectoM obj = new ProyectoM();
        return obj.validarDetalleProyectoQRM(orden, area, producto);
    }

    //Registrar mediante un lector de QR----------------------------------------
    public CachedRowSet consutalarProcesosArea(int op) {
        ProyectoM obj = new ProyectoM();
        return obj.consutalarProcesosAreaM(op);
    }

    public CachedRowSet consultar_Proyecto(String tipo) {
        Modelo.ProyectoM obj = new Modelo.ProyectoM();
        return obj.consultar_Proyecto(num_orden, nombreCliente, nombreProyecto, fecha, tipo);
    }

    public CachedRowSet consultar_ProyectoEliminados() {
        Modelo.ProyectoM obj = new Modelo.ProyectoM();
        return obj.consultar_ProyectoEliminados();
    }

    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public boolean EliminarProyecto(int orden) {//Se cambiara el estado del proyecto
        ProyectoM obj = new ProyectoM();
        return obj.EliminarProyecto(orden);
    }

    public boolean ReacttivarProyecto(int orden) {//Se cambiara el estado del proyecto
        ProyectoM obj = new ProyectoM();
        return obj.ReacttivarProyecto(orden);
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    //Información de las areas de producción
    public CachedRowSet InformacionAreasProduccion(int accion) {
        ProyectoM obj = new ProyectoM();
        return obj.InformacionAreasProduccionM(accion);
    }

    public CachedRowSet Consultar_informacion_para_el_QR(int orden) {
        ProyectoM obj = new ProyectoM();
        return obj.Consultar_informacion_para_el_QR(orden);
    }

    public boolean validarExistenciaNumerOrden(int orden) {
        ProyectoM obj = new ProyectoM();
        return obj.validarNumerOrden(orden);
    }

    public String consultarNumeroOrden() {
        ProyectoM obj = new ProyectoM();
        return obj.consultarNumeroOrden();
    }

    public String fecha() {
        ProyectoM obj = new ProyectoM();
        return obj.fecha();
    }

    public CachedRowSet fechaYdatosProduccion() {
        ProyectoM obj = new ProyectoM();
        return obj.fechaYdatosProduccion();
    }

    public CachedRowSet proyectosNegocio(int negocio, String orden, String cliente, String proyecto, String tipo) {
        ProyectoM obj = new ProyectoM();
        return obj.proyectosNegocio(negocio, orden, cliente, proyecto, tipo);
    }

    public boolean validarEliminacion(int orden) {
        ProyectoM obj = new ProyectoM();
        return obj.validarEliminacion(orden);
    }

    public boolean validarEjecucionOParada(int orden) {
        ProyectoM validar = new ProyectoM();
        return validar.validarEjecucionOParada(orden);
    }

    //Finalizacion de la clase automatica---------------------------------------------------------------->
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
