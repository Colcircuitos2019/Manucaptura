<?php 

// Conexion con la base de datos
function conexion(){

 $conexion = new mysqli("localhost","root","SaAFjmXlMRvppyqW","coltime") or die('No se puedo conectar: '.mysql_error());

 if($conexion->connect_errno){

 	printf("Error al conectar: %s\n",$conexion->connect_error);
 	exit();
 }

 return $conexion;
}


function cerraConexion($conexion){

	$conexion->close();

}
// Metodos de la secuencia (Ejecucion)


// $fecha_corte_tiempo = mesCorteTiempoProcesosTodaAreaProduccion(); // Primer paso

$procesos = consultarProcesoAreas(); // Segundo paso

sumatoriaTiempoEjecucionPorProceso($procesos);

//--------------------------------------------------------------------------------------------------------------------------------------------------------------



//Se encargada de ir a buscar de los detalles de las áreas de produccion los procesos que aun no se han terminado y tienen un estado diferente a por iniciar...
function mesCorteTiempoProcesosTodaAreaProduccion(){ //step 1
	$conexion = conexion();

	$conexion->query("CALL PA_CorteTiempoProcesosMes();");

	cerraConexion($conexion);
}

// Realizar la sumatoria de los tiempo de los mismo proceso de cada área para conocer el tiempo total trabajado (minutos) por el proceso en ese rango de tiempo...
function consultarProcesoAreas(){ // step 2

	$conexion = conexion();

	$procesos = $conexion->query("CALL PA_ConsultarProcesos(0);"); // Consulta todos los procesos registrados en el sistema sin importar el estado en que se encuentren (activos o inactivos).
	cerraConexion($conexion);

	return $procesos;

}


function sumatoriaTiempoEjecucionPorProceso($procesos){ // step 3

	foreach ($procesos as $proceso) {

		$conexion = conexion();		
		$tiempo_total="00:00";

		if ($proceso["idArea"]!=4) { // area de almacen = 4
			// echo $proceso["idproceso"]." - ".$proceso["idArea"]."<br>";

			$tiempos_procesos = $conexion->query("CALL PA_ConsultarTiempoProcesoAreaProduccion({$proceso["idproceso"]}, {$proceso["idArea"]});");
			
			// ...
			if(mysqli_num_rows($tiempos_procesos) > 0){


				foreach ($tiempos_procesos as $tiempo_proceso) {

					$tiempo_total = sumarTiempos($tiempo_total, $tiempo_proceso["tiempo_total_por_proceso"]);

				}

				cerraConexion($conexion);
				$conexion = conexion();

				//Actualizar tiempo en la basa se tados de tiempo proceso mes...

				$conexion->query("CALL PA_GestionarTiempoInvertidoProcesoMes({$proceso["idproceso"]}, {$tiempo_total});");

				// echo  $proceso["idproceso"].' - '.$tiempo_total. "<br>";

			}
			cerraConexion($conexion);
		}

	}


	// cerraConexion($conexion);

}

function sumarTiempos($total_tiempo, $tiempo_proceso){

	// echo  $total_tiempo." - ".$tiempo_proceso."<br>";


	if($tiempo_proceso != "00:00"){

			// ...

			$minutos = 0;
			$segundos = 0;
			// ...
			$fraccion_tiempo_total = explode(":", $total_tiempo);
			$fraccion_tiempo_proceso = explode(":", $tiempo_proceso);
			// ...
			$minutos = (int) $fraccion_tiempo_total[0];
			$minutos += (int) $fraccion_tiempo_proceso[0];
			$segundos = (int) $fraccion_tiempo_total[1];
			$segundos += (int) $fraccion_tiempo_proceso[1];
			// ...

			while ($segundos >= 60) {
				
				$minutos++;
				$segundos-=60;

			}

			$total_tiempo =  ($minutos < 9?"0".$minutos:$minutos).":".($segundos < 9?"0".$segundos:$segundos);		

			// echo $total_tiempo;

	}

	return $total_tiempo;
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

 ?>

 <!-- BEGIN

DECLARE mes varchar(2);
DECLARE año varchar(5);

IF EXISTS(SELECT * FROM tiempo_invertido_mes_proceso tmp WHERE tmp.idproceso = idProceso AND tmp.año_corte=año AND tmp.mes_corte=mes) THEN
#Si existe va actualizar el registro del proceso del corte de tiempo del mes correspondiente... (se resta con el mes anterior)

	#SELECT 2; # Actualizar
	UPDATE tiempo_invertido_mes_proceso tmp SET tmp.tiempo`=tiempo WHERE tmp.idproceso = idProceso AND tmp.año_corte=año AND tmp.mes_corte=mes;

ELSE
# si no existe insertar el registro... (se resta con la del mes anterior) 
 	#SELECT 1; #Insertar 
    INSERT INTO `tiempo_invertido_mes_proceso`(`año_corte`, `mes_corte`, `idproceso`, `tiempo`) VALUES (año, mes, idProceso, tiempo);
    
END IF;

END -->