<?php 
/**
 * 
 */
class reporteFE extends CI_Controller
{
	// Variables clase
	// private $variable = array( "ordenProcesos" => array());

	function __construct()
	{
		parent::__construct();
		$this->load->model('reporteFEM');
	}

	// Metodos y funciones de la clase
	public function estadoDeConexionServidor()
	{
		echo $this->reporteENM->estadoDeConexionServidorM();
	}

	public function cabezaReporte()
	{
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
		// $procesos = $this->input->post('procesos');
		// $ordenProcesos=array();
		//Procesos de formato estandar
		$procesosProyecto = $this->ProcesosEstadoInicial();
		// ...
		$camposValidacion = array('num_Orden' => "", 'tipo_producto' => "", 'PNC' => "" );
		// ...
		$cuerpoHTML="";
		$rowProyectoHTML="";
		$rep=0;	

		$infoProduccion = $this->reporteFEM->consultarInformacionCuerpoTablaM();
		// ...
		// var_dump($procesos);
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
			// if (intval($infoProyecto->Procesos_idproceso) =! 10) {
				// Estado en que se encuentra el proceso 
				$procesosProyecto[$infoProyecto->Procesos_idproceso]["estado"] =  (int)$infoProyecto->estado_idestado;
				// Cantidad terminada por el proceso
				$procesosProyecto[intval($infoProyecto->Procesos_idproceso)+1]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
				// $procesosProyecto[$infoProyecto->Procesos_idproceso]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
			// }
			// ...
			$rep=1;
			//...
			}else{//No es la primera vez que ingresa al ciclo
			//...	
			//     El numero de orden del row anteriror es el mismo que el siguiente row
				if ($camposValidacion["num_Orden"] === $infoProyecto->proyecto_numero_orden && $camposValidacion["tipo_producto"] == $infoProyecto->nombre && $camposValidacion["PNC"] == $infoProyecto->ubicacion) {//Es un proceso del mismo proyecto
			// 		// ...

					// Estado en que se encuentra el proceso 
					// if (intval($infoProyecto->Procesos_idproceso) =! 10) {
						$procesosProyecto[$infoProyecto->Procesos_idproceso]["estado"] = (int)$infoProyecto->estado_idestado;
					// Cantidad terminada por el proceso
					// $procesosProyecto[$infoProyecto->Procesos_idproceso]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
					// $procesosProyecto[intval($infoProyecto->Procesos_idproceso) + (intval($infoProyecto->Procesos_idproceso) != 10?1:0)]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
						$procesosProyecto[intval($infoProyecto->Procesos_idproceso) + 1]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
					// }

			// 		// ...
				}else{//Es el proceso de otro proyecto
					// break;
					// var_dump($camposValidacion);
					// var_dump($procesosProyecto);
					// var_dump($this->pasosDeCantidadesProcesos($procesosProyecto, $camposValidacion["cantidadTotal"]));
			// 		// Crear html de los procesos
					$rowProyectoHTML.= $this->construccionRowProyecto($this->pasosDeCantidadesProcesos($procesosProyecto, $camposValidacion["cantidadTotal"]));
					// $rowProyectoHTML.= $this->construccionRowProyecto($procesosProyecto);
					// $procesosProyecto = $this->pasosDeCantidadesProcesos($procesosProyecto,10);
					// var_dump($procesosProyecto);
					// ...
					$cuerpoHTML.= $rowProyectoHTML;
			// 		// ...
			// 		// Estado inicial de las varialbes
					$procesosProyecto = $this->ProcesosEstadoInicial();
					// ...
					$camposValidacion = array('num_Orden' => "", 'tipo_producto' => "", 'PNC' => "" );
					// ...
					$cuerpoHTML="";
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

					// Estado en que se encuentra el proceso 
					$procesosProyecto[$infoProyecto->Procesos_idproceso]["estado"] =  (int)$infoProyecto->estado_idestado;
					// Cantidad terminada por el proceso
					$procesosProyecto[$infoProyecto->Procesos_idproceso]["cantidadPT"] = (int)$infoProyecto->cantidad_terminada;
				// ...
				}
			//...
			}
		//...
		}
		// ...
		if ($rep=1) {
			// ...
			$rowProyectoHTML.= $this->construccionRowProyecto($this->pasosDeCantidadesProcesos($procesosProyecto, $camposValidacion["cantidadTotal"]));
			// ...
			$cuerpoHTML.= $rowProyectoHTML;
			// ...
			$res=0;
		}
		// Retorna el cuerpo de la informacion
		echo $cuerpoHTML;
		// echo json_encode($procesosProyecto);
	}

	public function ProcesosEstadoInicial()
	{
		return array(
					  "1" => array("estado" => 0, "cantidadPT" => 0), // Perforado
					  "2" => array("estado" => 0, "cantidadPT" => 0), // Quimicos
					  "3" => array("estado" => 0, "cantidadPT" => 0), // Caminos
					  "4" => array("estado" => 0, "cantidadPT" => 0), // Quemado
					  "5" => array("estado" => 0, "cantidadPT" => 0), // C.C.TH
					  "6" => array("estado" => 0, "cantidadPT" => 0), // Screen
					  "7" => array("estado" => 0, "cantidadPT" => 0), // Estañado
					  "8" => array("estado" => 0, "cantidadPT" => 0), // C.C2
					  "9" => array("estado" => 0, "cantidadPT" => 0), // Ruteo
					  "10" => array("estado" => 0, "cantidadPT" => 0), // Maquinas
					);
	}

	public function pasosDeCantidadesProcesos($procesoCantidad, $cantidadTotalProyecto)
	{
		$cantidadSiguienteP = 0;
		// Mover las cantidades terminadas del proceso anterior al siguiente proceso que le sigue
		// for ($i=1; $i <= count($procesoCantidad) ; $i++) {
		for ($i=1; $i < count($procesoCantidad); $i++) { 
			if ($procesoCantidad[$i]["estado"] == "0") {
				$procesoCantidad[$i+1]["cantidadPT"] = $procesoCantidad[$i]["cantidadPT"];
				$procesoCantidad[$i]["cantidadPT"] = 0;
			}
		}
		// Calcular las cantidades que van a quedar en cada proceso
		for ($i=1; $i < count($procesoCantidad); $i++) { 
			// if ($procesoCantidad[$i]["estado"] == "0") {
			if ($i == 1) { //Perforado 
				# ...
				if ($procesoCantidad[$i]["estado"] == "0") {
					// ...
					$procesoCantidad[$i]["cantidadPT"]= $cantidadTotalProyecto - $procesoCantidad[$i+1]["cantidadPT"];// La cantidad de perforado es igual a la cantidad total del proyecto menos la cantidad pasada de perforado a quimicos 
				}else{
					// ...
					$procesoCantidad[$i]["cantidadPT"]= $cantidadTotalProyecto - $procesoCantidad[$i+2]["cantidadPT"];// La cantidad de perforado es igual a la cantidad total del proyecto menos la cantidad pasada de perforado a quimicos 
				}
				// ...
			}else{
				// ...
				if($i == 5 || $i == 8){ // Aplica unicamente para Screen y
					if ($procesoCantidad[$i+1]["estado"] == "0") {
						// ...
						$procesoCantidad[$i]["cantidadPT"] = $procesoCantidad[$i]["cantidadPT"] - $procesoCantidad[$i+1]["cantidadPT"];
					}else{
						// ... 
						$procesoCantidad[$i]["cantidadPT"] = $procesoCantidad[$i]["cantidadPT"] - $procesoCantidad[$i+1]["cantidadPT"];
					}

				}else{
					$procesoCantidad[$i]["cantidadPT"] = $procesoCantidad[$i]["cantidadPT"] - $procesoCantidad[$i+1]["cantidadPT"]; //La cantidad total del proceso N es igual a la cantidad pasada del proceso anterior - la cantidad del proceso N siguiente.
				}
				// }
			}
		} 
			# ... Primer paso de cantidades
			// $cantidadSiguienteP = $procesoCantidad[2]["cantidadPT"]; // cantidad terminada de quimicos
			// $procesoCantidad[2]["cantidadPT"]= $procesoCantidad[1]["cantidadPT"]; // Cantidad terminada en perforado pasa a Quimicos
			// # ... Segundo paso de cantidades
			// $procesoCantidad[3]["cantidadPT"]= $cantidadSiguienteP; // Cantidad terminadas de Quimicos pasan a caminos
			// $cantidadSiguienteP = $procesoCantidad[2]["cantidadPT"]; // cantidad terminada de quimicos
			# ...
		// }
		/*Orden de los procesos
			1-Perforado
			2-Quimicos
			3-Caminos
			4-Quemado
			5-C.C.TH
			6-Screen
			7-Estañado
			8-C.C2
			9-Ruteo
			10-Maquinas*/
		//...
		// for ($i=1; $i <= count($procesoCantidad) ; $i++) {
		// 	# ...
		// 	if ($i == 1) {//Proceso de perforado
		// 		# ...Mover las cantidades terminadas del proceso anterior al siguiente proceso que le sigue
		// 		$procesoCantidad[$i+1]["cantidadPT"]=
		// 		# ...
		// 		$procesoCantidad[$i]["cantidadPT"] = ($cantidadTotalProyecto - $procesoCantidad[$i]["cantidadPT"]);//Cantidad inicial en perforado
		// 		// break;
		// 	}else{
		// 		// $procesoCantidad[$i]["cantidadPT"] = $cantidadTotalProyecto - $procesoCantidad[$i-1]["cantidadPT"];
		// 		// var_dump($procesoCantidad[$i-1]["cantidadPT"]);
		// 		// var_dump($procesoCantidad[$i]["cantidadPT"]);
		// 	}
		// 	# ...
		// }
 
		return $procesoCantidad;
	}

	public function construccionRowProyecto($procesos)
	{	$cuerpoHTML="";
		// ... 
		foreach ($procesos as $proceso) {
			# ...
			if(isset($proceso["estado"])){
				$cuerpoHTML.="<td style=\"background-color:".$this->clasificarColorEstoProcesos($proceso["estado"]).";\">". $proceso["cantidadPT"] ."</td>";
				// var_dump($proceso);  ($proceso["estado"]=="0"?0:$proceso["cantidadPT"])
			}
			# ...
		}
		// ...
		$cuerpoHTML.="<td>PNC</td></tr>";
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