<?php 

//Este documento PHP Siempre hay que ejecutarlo para el corte de los tiempo de producción obligatoriamente 
//una vez cada mes(De esto se encargara el programador de tareas) y opcionalmente las veces que queramos en el mes...
//Los proceso una vez sea terminados el proceso se le debe colocar la fecha de corte... <Pendiente>

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


mesCorteTiempoProcesosTodaAreaProduccion(); // step 1

$procesos = consultarProcesosAreas(); // step 2

sumatoriaTiempoEjecucionPorProceso($procesos); // step 3

corteDeTiempoDeEjecucionPorProducto();// step 4

//--------------------------------------------------------------------------------------------------------------------------------------------------------------


//Se encargada de ir a buscar de los detalles de las áreas de produccion los procesos que aun no se han terminado y tienen un estado diferente a por iniciar...
function mesCorteTiempoProcesosTodaAreaProduccion(){ //step 1
	$conexion = conexion();

	$conexion->query("CALL PA_CorteTiempoProcesosMes();");

	cerraConexion($conexion);
}

function consultarProcesosAreas(){ // step 2

	$conexion = conexion();

	$procesos = $conexion->query("CALL PA_ConsultarProcesos(0);"); // Consulta todos los procesos registrados en el sistema sin importar el estado en que se encuentren (activos o inactivos).
	cerraConexion($conexion);

	return $procesos;

}

function sumatoriaTiempoEjecucionPorProceso($procesos){ // step 3

	foreach ($procesos as $proceso) {

		$conexion = conexion();		
		$tiempo_total="00:00:00";

		if ($proceso["idArea"]!=4) { // area de almacen = 4 (Por el momento como el área de almacen va a cambiar no se va a llevar el control de los proceso de esto).

			$tiempos_procesos = $conexion->query("CALL PA_ConsultarTiempoProcesoAreaProduccion({$proceso["idproceso"]}, {$proceso["idArea"]});");// Todos sin importar la fecha
			
			// ...
			if(mysqli_num_rows($tiempos_procesos) > 0){


				foreach ($tiempos_procesos as $tiempo_proceso) {

					$tiempo_total = sumarTiempos($tiempo_total, $tiempo_proceso["tiempo_total_por_proceso"]);

				}

				cerraConexion($conexion);
				$conexion = conexion();

				//Validar si existe uno o más cortes de tiempo de produccion de un proceso para restarle al tiempo actual...
				$tiempo_meses_anteriores_proceso = $conexion->query("CALL PA_ConsultarExistenciaCortesTiemposPorProcesoAnteriores({$proceso["idproceso"]});");

				if (mysqli_num_rows($tiempo_meses_anteriores_proceso) > 0) {
					
					$tiempo_total_meses_anteriores = "00:00:00";

					foreach ($tiempo_meses_anteriores_proceso as $tiempo_mes_anterior_proceso) {
						
						$tiempo_total_meses_anteriores = sumarTiempos($tiempo_total_meses_anteriores, $tiempo_mes_anterior_proceso["tiempo"]);

					}

					$tiempo_total = restarTiemposProduccion($tiempo_total, $tiempo_total_meses_anteriores);

				}

				cerraConexion($conexion);
				$conexion = conexion();

				//Actualizar tiempo en la basa se tados de tiempo proceso mes...
				$conexion->query("CALL PA_GestionarTiempoInvertidoProcesoMes({$proceso["idproceso"]}, \"{$tiempo_total}\");");
				
			}

			cerraConexion($conexion);
		}
	}
}

// ...
function sumarTiempos($total_tiempo, $tiempo_proceso){

	$total_tiempo_sumado = "";
	if($tiempo_proceso != "00:00:00"){
	
			$conexion = Conexion();
			$tiempo_sumado= $conexion->query("CALL PA_SumarTiempos('{$total_tiempo}','{$tiempo_proceso}')");

			if(mysqli_num_rows($tiempo_sumado) > 0){

				foreach ($tiempo_sumado as $tiempo) {
					
					$total_tiempo_sumado = $tiempo["total_tiempo"];

				}

			}
		cerraConexion($conexion);
		$total_tiempo = $total_tiempo_sumado;	
	}

	return $total_tiempo;
}


function restarTiemposProduccion($tiempo_total, $tiempo_restar){

	$total_tiempo_restado = "";
	if($tiempo_restar != "00:00:00"){
	
			$conexion = Conexion();
			$tiempo_restado= $conexion->query("CALL PA_RestarTiempos('{$tiempo_total}','{$tiempo_restar}')");

			if(mysqli_num_rows($tiempo_restado) > 0){

				foreach ($tiempo_restado as $tiempo) {
					
					$total_tiempo_restado = $tiempo["total_tiempo"];
					
				}

			}
		cerraConexion($conexion);
		$tiempo_total =	$total_tiempo_restado;
	}


	return $tiempo_total;

}


function corteDeTiempoDeEjecucionPorProducto(){// Step 4

	$conexion = Conexion();
	$tiempo_producto_proyecto_mes = "";
	//Clasificar los meses de corte de todas los productos de las diferentes áreas...
	$conexion->query("CALL PA_CorteTiempoProductos();");
	

	cerraConexion($conexion);
	$conexion = Conexion();

	//Consultar los productos de los proyectos que tiene un mes de corte de tiempo asignado... //idDetalle_proyecto - tiempo_total
	$productos_proyectos = $conexion->query("CALL PA_ConsultarProductosProyectosMesDeCorte();");//<- me trae el ID del producto y el tiempo total de ejecución del producto.
	cerraConexion($conexion);

	if(mysqli_num_rows($productos_proyectos) > 0){

		foreach ($productos_proyectos as $producto) {
			$conexion = Conexion();	

			$tiempo_corte_mes_anterior = $conexion->query("CALL PA_ConsultarDetallesDeCortesTiempoMesAnteriorProducto({$producto["idDetalle_proyecto"]});");


			if (mysqli_num_rows($tiempo_corte_mes_anterior) > 0) {
				
				foreach ($tiempo_corte_mes_anterior as $tiempo_anterior) {
					
					$tiempo_producto_proyecto_mes = restarTiemposProduccion($producto["tiempo_total"], $tiempo_anterior["tiempo_proyecto_mes"]);

				}

			}else{

				$tiempo_producto_proyecto_mes = $producto["tiempo_total"];

			}

			cerraConexion($conexion);
			$conexion = Conexion();

			//Actualizar o registrar tiempo de corte del mes
			$conexion->query("CALL PA_GestionarMesCorteTiempoProductoProyecto({$producto["idDetalle_proyecto"]},'{$tiempo_producto_proyecto_mes}');");//<-- El problemas es este procedure almacenado...

			// echo  $tiempo_producto_proyecto_mes."<br>";

			$tiempo_producto_proyecto_mes = "";

			cerraConexion($conexion);
		}

	}

	

}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------

 ?>
