<!DOCTYPE html>
<html lang="en">
<head>
	<title>Reporte FE</title>
	<link rel="icon" type="image/png" href="./images/manucaptura.png">
	<!-- meta charset and meta viewport -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- CSS Bootstrap -->
	<link rel="stylesheet" href="./css/Bootstrap_4.css">
	<!-- CSS Data Table -->
	<link rel="stylesheet" type="text/css" href="./css/DataTable.css">
	<!-- Estilo personalizados -->
	<link rel="stylesheet" type="text/css" href="./css/styleFrom.css">
</head>
<body>
<!-- .-.-. -->
	<div class="container fondo">
		<div class="row">
			<div class="col-md-10">
	  			<h1>Reporte Formato Estandar</h2>
			</div>
			<div class="col-md-2 float-right">
				<h6>Conexion DB: <small id="estadoDB"></small></h6>
				<h6>Estado Lectura: <small id="estadoLectura"></small></h6>
			</div>				
		</div>
	  	<br>
		<!--  -->
 		<div class="table-responsive" id="contentTable">
 		<table id="reporte" class="table table-striped table-bordered" style="width:100%">
 		        <thead class="encabezado">
					<!--  -->
 		        </thead>
				<tbody id="cuerpo">
					<!--  -->
				</tbody>
 		        <tfoot class="encabezado">
					<!--  -->
 		        </tfoot>
 		</table>
 		</div>
		<!--  -->
	</div><br>
	<div class="container">
		<div class="row">
				<!-- Colores tipo de proyecto -->
				<div class="infoColores col-md-4">
					<!-- Color normal -->
					<button id="normal"></button>
					<label for="normal">Normal</label>
					&nbsp;&nbsp;
					<!-- Color Quick -->
					<button id="quick"></button>
					<label for="quick">Quick</label>
					&nbsp;&nbsp;
					<!-- Colo RQT -->
					<button id="rqt"></button>
					<label for="rqt">RQT</label>
				</div>
				<!-- Conexion con el servidor y estado de lectura del sistema -->
				<div class="col-md-1">
					<!-- Code -->
				</div>
				<!-- Colores de los estados de los procesos  -->
				<div class="col-md-7">
					<!-- Terminado -->
					<button id="terminado"></button>
					<label for="terminado">Terminado</label>
					&nbsp;
					<!-- Pausado -->
					<button id="pausado"></button>
					<label for="pausado">Pausado</label>
					&nbsp;
					<!-- Ejecucion -->
					<button id="ejecucion"></button>
					<label for="ejecucion">Ejecucion</label>
					&nbsp;
					<!-- Por iniciar -->
					<button id="porIniciar"></button>
					<label for="porIniciar">Por Iniciar</label>
					<!-- No aplica N/A -->
					&nbsp;
					<button id="NA"></button>
					<label for="NA">NA</label>
				</div>
			<!--  -->
			</div>
	</div>
	<!-- </div> -->

<!-- jQuery 3.3.1 -->
<script src="./js/jQuery_3.js"></script>
<!-- Popper 1.14.6 -->
<script src="./js/Popper.js"></script>
<!-- js Bootstrap 4.2.1 -->
<script src="./js/Bootstrap_4.js"></script>
<!-- JS Data Table -->
<script type="text/javascript" charset="utf8" src="./js/DataTable.js"></script>
<!-- Acciones -->
<script src="./js/reporteFE.js"></script>
<!-- ... -->
<script type="text/javascript">
	var baseURL = "<?= base_url(); ?>";
</script>
<!--  -->
</body>
</html>