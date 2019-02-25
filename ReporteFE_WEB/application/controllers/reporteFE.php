<?php 
/**
 * 
 */
class reporteFE extends CI_Controller
{

	function __construct()
	{
		parent::__construct();
		$this->load->model('reporteFEM');
	}

	// Metodos y funciones de la clase
	public function estadoDeConexionServidor()
	{
		echo $this->reporteFEM->estadoDeConexionServidorM();
	}

	public function estadoDeLecturaPuertoSerial()
	{
		echo $this->reporteFEM->estadoDeLecturaPuertoSerialM();
	}

	public function cabezaReporte()
	{
		//EN un futuro los procesos van a ser versatiles, entonces se tendran que consultar, por el momento van ha estar quemados en el código.
		$cabeza="<tr>
					<th>N°Orden</th>
					<th>M.T</th>
					<th>Cant</th>
					<th>Tipo producto</th>
					<th>Perforado</th>
					<th>Quimicos</th>
					<th>Caminos</th>
					<th>Quemado</th>
					<th>C.C.TH</th>
					<th>Screen</th>
					<th>Estañado</th>
					<th>C2</th>
					<th>Ruteo</th>
					<th>Maquinas</th>
					<th>PNC</th>
				</tr>";


		echo $cabeza;
	}

	public function consultarInformacionCuerpoTabla()
	{
		//Procesos de formato estandar
		$procesosProyecto = $this->ProcesosEstadoInicial();
		// ...
		$camposValidacion = array('num_Orden' => "", 'tipo_producto' => "", 'PNC' => "", "cantidadTotal" => "" );
		// ...
		$cuerpoHTML="";
		$rowProyectoHTML="";
		$rep=0;	
		// ...
		$infoProduccion = $this->reporteFEM->consultarInformacionCuerpoTablaM();
		// ...
		foreach ($infoProduccion as $infoProyecto) {
			if($rep==0){//Es la primera vez que ingresa al ciclo?
				$rowProyectoHTML.="<tr>
									 <td style=\"background-color:".$this->clasificacionColoTipoDesarrolloProyecto($infoProyecto->tipo_proyecto).";\">".$infoProyecto->proyecto_numero_orden."</td>
									 <td>".$infoProyecto->material."</td>
									 <td>".$infoProyecto->canitadad_total."</td>
									 <td>".$infoProyecto->nombre."</td>";
			// variables de validación
			$camposValidacion["num_Orden"] = $infoProyecto->proyecto_numero_orden;// Numero de la orden
			$camposValidacion["tipo_producto"] = $infoProyecto->nombre;// Tipo de producto (Circuito, Stencil, etc...)
			$camposValidacion["PNC"] = $infoProyecto->ubicacion;// Producto no conforme
			$camposValidacion["cantidadTotal"] = $infoProyecto->canitadad_total;// Cantidad total del proyecto
				// Estado en que se encuentra el proceso 
				$procesosProyecto[$infoProyecto->idproceso]["estado"] =  (int)$infoProyecto->estado;
				// Cantidad de equipos que posee el proceso}
				$procesosProyecto[$infoProyecto->idproceso]["cantidadP"] = (int)$infoProyecto->cantidadProceso;
			// }
			// ...
			$rep=1;
			//...
			}else{//No es la primera vez que ingresa al ciclo
			//...	
			//  El numero de orden del row anteriror es el mismo que el siguiente row
				if ($camposValidacion["num_Orden"] === $infoProyecto->proyecto_numero_orden && $camposValidacion["tipo_producto"] == $infoProyecto->nombre && $camposValidacion["PNC"] == $infoProyecto->ubicacion) {//Es un proceso del mismo proyecto
					// ...
					// Estado en que se encuentra el proceso 
						$procesosProyecto[$infoProyecto->idproceso]["estado"] = (int)$infoProyecto->estado;
					// Cantidad terminada por el proceso
						$procesosProyecto[$infoProyecto->idproceso]["cantidadP"] = (int)$infoProyecto->cantidadProceso;
					// ...
				}else{//Es el proceso de otro proyecto
					// ...
			// 		// Crear html de los procesos
					$rowProyectoHTML.= $this->construccionRowProyecto($procesosProyecto, $camposValidacion["PNC"]);
					// ...
					$cuerpoHTML.= $rowProyectoHTML;
			// 		// ...
			// 		// Estado inicial de las varialbes
					$procesosProyecto = $this->ProcesosEstadoInicial();
					// ...
					$camposValidacion = array('num_Orden' => "", 'tipo_producto' => "", 'PNC' => "", "cantidadTotal" => "" );
					// ...
					$rowProyectoHTML="";
					// ...
					$rowProyectoHTML.="<tr>
										 <td style=\"background-color:".$this->clasificacionColoTipoDesarrolloProyecto($infoProyecto->tipo_proyecto).";\">".$infoProyecto->proyecto_numero_orden."</td>
										 <td>".$infoProyecto->material."</td>
										 <td>".$infoProyecto->canitadad_total."</td>
										 <td>".$infoProyecto->nombre."</td>";
					// Recopilar la informacion del siguiente proceso
					$procesosProyecto = $this->ProcesosEstadoInicial();
					// variables de validación
					$camposValidacion["num_Orden"] = $infoProyecto->proyecto_numero_orden;// Numero de la orden
					$camposValidacion["tipo_producto"] = $infoProyecto->nombre;// Tipo de producto (Circuito, Stencil, etc...)
					$camposValidacion["PNC"] = $infoProyecto->ubicacion;// Producto no conforme
					$camposValidacion["cantidadTotal"] = (int)$infoProyecto->canitadad_total;// Cantidad total del proyecto
					// ... 
					// Estado en que se encuentra el proceso 
					$procesosProyecto[$infoProyecto->idproceso]["estado"] =  (int)$infoProyecto->estado;
					// Cantidad terminada por el proceso
					$procesosProyecto[$infoProyecto->idproceso]["cantidadP"] = (int)$infoProyecto->cantidadProceso;
				// ...
				}
			//...
			}
		//...
		}
		// ...
		if ($rep=1) {
			// ...
			$rowProyectoHTML.= $this->construccionRowProyecto($procesosProyecto, $camposValidacion["PNC"]);
			// ...
			$cuerpoHTML.= $rowProyectoHTML;
			// ...
			$res=0;
		}
		// Retorna el cuerpo de la informacion
		echo $cuerpoHTML;
	}

	public function ProcesosEstadoInicial()
	{
		return array(
					  "1" => array("estado" => 0, "cantidadP" => 0), // Perforado
					  "2" => array("estado" => 0, "cantidadP" => 0), // Quimicos
					  "3" => array("estado" => 0, "cantidadP" => 0), // Caminos
					  "4" => array("estado" => 0, "cantidadP" => 0), // Quemado
					  "5" => array("estado" => 0, "cantidadP" => 0), // C.C.TH
					  "6" => array("estado" => 0, "cantidadP" => 0), // Screen
					  "7" => array("estado" => 0, "cantidadP" => 0), // Estañado
					  "8" => array("estado" => 0, "cantidadP" => 0), // C.C2
					  "9" => array("estado" => 0, "cantidadP" => 0), // Ruteo
					  "10" => array("estado" => 0, "cantidadP" => 0), // Maquinas
					);
	}

	public function construccionRowProyecto($procesos, $PNC)
	{	$cuerpoHTML="";
		// ... 
		foreach ($procesos as $proceso) {
			# ...
			if(isset($proceso["estado"])){
				$cuerpoHTML.="<td style=\"background-color:".$this->clasificarColorEstoProcesos($proceso["estado"]).";\">". ($proceso["estado"]=="0"?0:$proceso["cantidadP"]) ."</td>";
			}
			# ...
		}
		// ...
		$cuerpoHTML.="<td>".($PNC==null?"-":$PNC)."</td></tr>";
		// ...
		return $cuerpoHTML;
	}

	public function clasificarColorEstoProcesos($estado)
	{
		$color="";
		switch ($estado) {
			case 2://Pausado
				$color="#FB5353";//Rojo
				break;
			case 3://Terminado
				$color="#74FB53";//Verde
				break;
			case 4://Ejecucion
				$color="#FFA81B";//Naranjado
				break;
			case 1://Por iniciar
				$color="#FFF";//Blanco
				break;
			default: // N/A no aplica 
				$color="#B0B0B0";//Gris
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