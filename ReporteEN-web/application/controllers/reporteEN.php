<?php 
/**
 * 
 */
class reporteEN extends CI_Controller
{
	
	function __construct()
	{
		parent::__construct();
		$this->load->model('reporteENM');
	}


	public function estadoDeConexionServidor()
	{
		# code...
	}

	public function estructurarEncabezado()
	{
		$cabeza="<th>N°Orden</th><th>Cant</th><th>Lider de proyecto</th>";

		$procesos = $this->reporteENM->estructurarEncabezadoM();

		//Proceso
		foreach ($procesos as $proceso) {
			$cabeza.="<th>sub</th><th>{$proceso->nombre_proceso}</th>";
		}

		$cabeza.="<th>Terminados</th><th>Restantes</th>";

		echo $cabeza;
	}

	public function consultarInformacionCuerpoTabla()
	{
		$cuerpoHTML="";

		$infoCuerpo = $this->reporteENM->consultarInformacionCuerpoTablaM();

		
	}
}
 ?>