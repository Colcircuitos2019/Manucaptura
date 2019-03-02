<?php 
/**
 * 
 */
class reporteEN extends CI_Controller
{
	// Variables clase
	// private $variable = array( "ordenProcesos" => array());

	function __construct()
	{
		parent::__construct();
		$this->load->model('reporteENM');
	}

	// Metodos y funciones de la clase
	public function estadoDeConexionServidor()
	{
		echo $this->reporteENM->estadoDeConexionServidorM();
	}

	public function estadoDeLecturaPuertoSerial()
	{
		echo $this->reporteENM->estadoDeLecturaPuertoSerialM();
	}

	public function estructurarEncabezado()
	{
		$cabeza="<tr><th>N°Orden</th><th>Cant</th><th>Lider de proyecto</th>";

		$procesos = $this->reporteENM->estructurarEncabezadoM();

		$ordenProcesos= array();
		//Proceso
		foreach ($procesos as $proceso) {
			$cabeza.="<th>{$proceso->nombre_proceso}</th>";
			array_push($ordenProcesos, $proceso->nombre_proceso);
		}

		$cabeza.="<th>Terminados</th><th>Restantes</th></tr>";

		$componentes = array('procesos' => $ordenProcesos, 'cabeza' => $cabeza);

		echo json_encode($componentes);
	}

	public function consultarInformacionCuerpoTabla()
	{
		$procesos = $this->input->post('procesos');
		$ordenProcesos=array();
		$num_Orden="";
		$cuerpoHTML="";
		$cantidadTotal=0;
		$cantidadTermianda=0;
		$cantidadProceso=0;
		$cantidadRestante=0;
		$rowProyectoHTML="";
		$rep=0;	

		$infoProduccion = $this->reporteENM->consultarInformacionCuerpoTablaM();
		// ...
		// var_dump($procesos);
		foreach ($infoProduccion as $infoProyecto) {
			if($rep==0){//Es la primera vez que ingresa al ciclo?
				$cantidadTotal = (int) $infoProyecto->canitadad_total;
				$rowProyectoHTML.="<tr>
									 <td style=\"background-color: ".$this->clasificacionColoTipoDesarrolloProyecto($infoProyecto->tipo_proyecto).";\">".$infoProyecto->proyecto_numero_orden."</td>
									 <td>".$cantidadTotal."</td>
									 <td>".($infoProyecto->lider_proyecto==null?'-':$this->consultarNombreLiderProyectoEN($infoProyecto->lider_proyecto))."</td>";
				// ...
				$num_Orden=$infoProyecto->proyecto_numero_orden;
				$ordenProcesos[$infoProyecto->nombre_proceso] = array('estado'=> $infoProyecto->estado,'cantidad_proceso'=> $infoProyecto->cantidadProceso);
				// ...
				$cantidadProceso += (int) $infoProyecto->cantidadProceso;//Cantidad terminada del proceso
				// ...
				$rep=1;
			}else{//No es la primera vez que ingresa al ciclo
				//...
				if ($num_Orden === $infoProyecto->proyecto_numero_orden) {//Es un proceso del mismo proyecto
					// ...
					$ordenProcesos[$infoProyecto->nombre_proceso] = array('estado'=> $infoProyecto->estado,'cantidad_proceso'=> $infoProyecto->cantidadProceso);
					// ...
					$cantidadProceso += (int) $infoProyecto->cantidadProceso;//Cantidad terminada del proceso
					// ...
				}else{//Es el proceso de otro proyecto

					// Crear html de los procesos
					for ($i=0; $i < count($procesos); $i++) { 
						$rowProyectoHTML.="<td style=\"background-color: ".$this->clasificarColorEstoProcesos($ordenProcesos[$procesos[$i]]['estado']).";\">". $ordenProcesos[$procesos[$i]]['cantidad_proceso']."</td>";
					}
					//Cantidades terminadas del proyecto
					// 				                   Cantidad terminada                          Restantes
					$rowProyectoHTML.="<td>".($cantidadProceso!=0? $cantidadTermianda = ($cantidadTotal-$cantidadProceso):0)."</td>";
					//Cantidades restantes del proyecto
					$rowProyectoHTML.="<td>".($cantidadTotal-$cantidadTermianda)."</td></tr>";

					// Agregar la fila a la tabla
					$cuerpoHTML.=$rowProyectoHTML;
					// ...
					// Estado inicial de las varialbes
					$rowProyectoHTML="";
					$cantidadTotal=0;
					$cantidadTermianda=0;
					$cantidadProceso=0;
					$cantidadRestante=0;
					$ordenProcesos=array();
					// ...
					$cantidadTotal = (int) $infoProyecto->canitadad_total;
					$rowProyectoHTML.="<tr>
										 <td style=\"background-color: ".$this->clasificacionColoTipoDesarrolloProyecto($infoProyecto->tipo_proyecto).";\">".$infoProyecto->proyecto_numero_orden."</td>
										 <td>".$cantidadTotal."</td>
										 <td>".($infoProyecto->lider_proyecto==null?'-':$this->consultarNombreLiderProyectoEN($infoProyecto->lider_proyecto))."</td>";
					// ...
					$num_Orden=$infoProyecto->proyecto_numero_orden;
					$ordenProcesos[$infoProyecto->nombre_proceso] = array('estado'=> $infoProyecto->estado,'cantidad_proceso'=> $infoProyecto->cantidadProceso);
					// ...
					$cantidadProceso += (int) $infoProyecto->cantidadProceso;//Cantidad terminada del proceso
					// break;
				}
				//...
			}
		}
		// ...
		if ($rep === 1) {
			// Crear html de los procesos
			for ($i=0; $i < count($procesos); $i++) { 
				$rowProyectoHTML.="<td style=\"background-color: ".$this->clasificarColorEstoProcesos($ordenProcesos[$procesos[$i]]['estado']).";\">". $ordenProcesos[$procesos[$i]]['cantidad_proceso']."</td>";
			}
			//Cantidades terminadas del proyecto
			// 				                   Cantidad terminada                          Restantes
			$rowProyectoHTML.="<td>".($cantidadProceso!=0? $cantidadTermianda = ($cantidadTotal-$cantidadProceso):0)."</td>";

			//Cantidades restantes del proyecto
			$rowProyectoHTML.="<td>".($cantidadTotal-$cantidadTermianda)."</td></tr>";

			// Agregar la fila a la tabla
			$cuerpoHTML.=$rowProyectoHTML;
			$res=0;
		}
		// Retorna el cuerpo de la informacion
		echo $cuerpoHTML;
	}

	public function consultarNombreLiderProyectoEN($documento)
	{
		$names = $this->reporteENM->consultarNombreLiderProyectoENM($documento);

		return $names->nombre1.' '.$names->nombre2.' '.$names->apellido1.' '.$names->apellido2;//No olvidar capitalizar este string
	}

	public function clasificarColorEstoProcesos($estado)
	{
		$color="";
		switch ($estado) {
			case 2://Pausado
				$color="#FB5353";
				break;
			case 3://Terminado
				$color="#74FB53";
				break;
			case 4://Ejecucion
				$color="#FFA81B";
				break;
			default://Por iniciar
				$color="#FFF";
				break;	
		}

		return $color;
	}

	public function clasificacionColoTipoDesarrolloProyecto($desarrollo)
	{
		$color="";
		switch ($desarrollo) {
			case 'RQT':
				$color="#FFAFAF";//Rosado
				break;
			case "Quick":
				$color="#01AEF0";//Azul
				break;
			case "Normal":
				$color="#FFF";//Blanco
				break;
		}
		// 
		return $color;
	}

}
 ?>