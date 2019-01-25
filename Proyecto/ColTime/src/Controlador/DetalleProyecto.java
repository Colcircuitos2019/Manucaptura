package Controlador;

import Modelo.DetalleProyectoM;
import javax.sql.rowset.CachedRowSet;

public class DetalleProyecto {

    //Constructores------------------------------------------------->
    public DetalleProyecto() {

    }
    //Variables------------------------------------------------------>
    private CachedRowSet crs = null;
    //Atributos------------------------------------------------------>
    private String cantidad = "";
    private String negocio = "";
    private String tipoNegocio = "";
    private int estado = 0;
    private String material = "";

    //Set-------------------------------------------------------->
    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getNegocio() {
        return negocio;
    }

    public void setNegocio(String negocio) {
        this.negocio = negocio;
    }

    public String getTipoNegocio() {
        return tipoNegocio;
    }

    public void setTipoNegocio(String tipoNegocio) {
        this.tipoNegocio = tipoNegocio;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public CachedRowSet getCrs() {
        return crs;
    }

    public void setCrs(CachedRowSet crs) {
        this.crs = crs;
    }

    public void setMaterial(String material) {
        this.material = material;
    }

    //Metodos----------------------------------------------------->
    public boolean registrar_Detalle_Proycto(String numerOrden, int op, int id) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.registrar_Detalle_Proycto(cantidad, negocio, tipoNegocio, 1, numerOrden, material, op, id, 0, null);
    }

    //Se encarga de los  PNC
    public boolean registrarModificarPNC(String numerOrden, int op, int id, String ubicacion) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.registrar_Detalle_Proycto(cantidad, negocio, tipoNegocio, 1, numerOrden, material, op, id, 1, ubicacion);
    }

    //Validar el estado del PNC para saber si se puede modificar o eliminar.
    public int ValidarCnatidadPNC(String numerOrden, int detalle, int op, String tipo, String negocio) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.ValidarCnatidadPNCM(numerOrden, detalle, op, tipo, negocio);
    }

    public CachedRowSet consultarDetalles(int area,int op) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarDetallesM(area,op);
    }

    //Reporte general sobre el status del proyecto
    public CachedRowSet generar_Reportes() {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.generar_ReportesM();
    }
    
    //Reporte de tiempos de cada una de las áreas de producción.
    public CachedRowSet generarReporteAreaTiempos(int area){
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.generarReporteAreaTiemposM(area);
    }

    //Consulta los detalles del proyecto
    public CachedRowSet consultar_Detalle_Proyecto(String numerOrden, int estado) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultar_Detalle_Proyecto(numerOrden, estado);
    }

    //Consulta solo los procesos de  FE(Formato estandar).
    public CachedRowSet consultarProcesosFE(int detalle) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarprocesosFE(detalle);
    }

    //Valida el estado del detalle del proyecto y del proyecto para saber si lo modifica o cambia el estado.
    public boolean validarEliminacionModificar(int negocio, int orden, int tipo, int detalle, int accion) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.validarEliminacionModificarM(orden, negocio, tipo, detalle, accion);
    }

//  Reiniciar toma de tiempo
    public boolean ReiniciarDetalle(int detalle, int negocio, int detalleproducto) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.ReiniciarDetalle(detalle, negocio, detalleproducto);
    }

    //Elimina los detalles del proyecto de la base de datos (solo los que son PNC).
    public boolean eliminarDetallersProyecto(int idDetalle, int numerOrden, String negocio, String tipo, int accion) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.eliminarDetallersProyecto(idDetalle, numerOrden, negocio, tipo, accion);
    }

    //Consultar los procesos que tiene un detalle del proyecto.
    public CachedRowSet consultarDetalleProyectoProduccion(int orden, int negocio, int vistaC) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarDetalleProyectoProduccion(orden, negocio, vistaC);
    }

    //Consulta los detalles del proyecto que estan en producción.    
    public CachedRowSet consultarDetalleProduccion(int detalle, int negocio) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarDetalleProduccion(detalle, negocio);
    }
    
    //Consultar el estado del detalle del proyecto para clasificar el estado de los botones para seleccionar el "orden"
    public boolean consultarEstadoDetalleProyecto(int detalle){
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarEstadoDetalleProyectoM(detalle);
    }

    //Consulta la información que se necesita ver los encargados en la vista de detalles del proyecto.
    public CachedRowSet ConsultarInformacionFiltrariaDelDetalle(int detalle) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.ConsultarInformacionFiltrariaDelDetalleM(detalle);
    }
    
    //Seleccionar el proceso del área de ensamble por el cual va a iniciar el desarrollo de ese procesos
    public boolean seleccionPrimerProcesoEnsamble(int detalle, int idProceso){
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.seleccionPrimerProcesoEnsambleM(detalle,idProceso);
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
