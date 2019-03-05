/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controlador;

import Modelo.ProcesosM;
import javax.sql.rowset.CachedRowSet;

/**
 *
 * @author PC
 */
public class Procesos {

    public Procesos() {

    }

    public boolean guardarModificarProcesos(int idProceso, String nombreProceso, int area) {
        ProcesosM obj = new ProcesosM();
        return obj.guardarModificarProcesosM(idProceso,nombreProceso,area);
    }

    public CachedRowSet consultarProcesos(int area) {
        ProcesosM obj = new ProcesosM();
        return obj.consultarProcesosM(area);
    }

    public boolean cambiarEstadoProcesos(int idProceso) {
        ProcesosM obj = new ProcesosM();
        return obj.cambiarEstadoProcesosM(idProceso);
    }

}
