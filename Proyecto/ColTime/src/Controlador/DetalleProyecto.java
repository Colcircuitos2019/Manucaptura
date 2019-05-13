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
    private String area = "";
    private String producto = "";
    private int estado = 0;
    private String material = "";

    //Set-------------------------------------------------------->
    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getProducto() {
        return producto;
    }

    public void setProducto(String producto) {
        this.producto = producto;
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
    public boolean registrar_Detalle_Proyecto(String numerOrden, int accion, int idDetalleProducto, String idColor_antisolder, int ruteo, int idEspesor) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.registrar_Detalle_Proycto(cantidad, area, producto, 1, numerOrden, material, accion, idDetalleProducto, 0, null, idColor_antisolder, ruteo, idEspesor);
    }

    //Se encarga de los  PNC <--- esto ya no se va a utilizar por el momento en ninguna área... <Pendiente>
    public boolean registrarModificarPNC(String numerOrden, int op, int id, String ubicacion) { // Todo lo relacionado con los productos no conforme va a cambiar...
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.registrar_Detalle_Proycto(cantidad, area, producto, 1, numerOrden, material, op, id, 1, ubicacion, "0", 0, 0);
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
    public CachedRowSet generarReporteAreaTiempos(int area,String fechaI, String fechaF){
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.generarReporteAreaTiemposM(area, fechaI, fechaF);
    }

    //Consulta los detalles del proyecto
    public CachedRowSet consultar_Detalle_Proyecto(String numerOrden) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultar_Detalle_Proyecto(numerOrden);
    }
    
    public CachedRowSet consultarProcesosProducto(Object idDetalleProducto, Object area) {
        DetalleProyectoM modelo = new DetalleProyectoM();
        return modelo.consultarProcesosProductoM(String.valueOf(idDetalleProducto), String.valueOf(area));
    }

    //Consulta solo los procesos de  FE(Formato estandar).
    public CachedRowSet consultarProcesosFE(int detalle) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarprocesosFE(detalle);
    }

    //Valida el estado del detalle del proyecto y del proyecto para saber si lo modifica o cambia el estado.
    public boolean validarEliminacionModificar(int area, int orden, int tipo, int detalle, int accion) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.validarEliminacionModificarM(orden, area, tipo, detalle, accion);
    }

//  Reiniciar toma de tiempo
    public boolean ReiniciarDetalle(int idDetalleProceso, int area, int idDetalleProducto) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.ReiniciarDetalle(idDetalleProceso, area, idDetalleProducto);
    }

    //Elimina los detalles del proyecto de la base de datos (solo los que son PNC).
    public boolean eliminarDetallersProyecto(int idDetalle, int numerOrden, String negocio, String tipo, int accion) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.eliminarDetallersProyecto(idDetalle, numerOrden, negocio, tipo, accion);
    }

    //Consultar los procesos que tiene un detalle del proyecto.
    public CachedRowSet consultarDetalleProyectoProduccion(int orden, int area, int vistaC) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarDetalleProyectoProduccion(orden, area, vistaC);
    }

    //Consulta los detalles del proyecto que estan en producción.    
    public CachedRowSet consultarDetalleProduccion(int detalle, int area) {
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.consultarDetalleProduccion(detalle, area);
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
    public boolean seleccionPrimerProcesoEnoTE(int detalle, int idProceso, int area){
        DetalleProyectoM obj = new DetalleProyectoM();
        return obj.seleccionPrimerProcesoENoTEM(detalle, idProceso, area);
    }
    
    @Override
    protected void finalize() throws Throwable {
        super.finalize(); //To change body of generated methods, choose Tools | Templates.
    }

}
