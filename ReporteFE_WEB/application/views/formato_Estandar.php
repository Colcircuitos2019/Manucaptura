<!DOCTYPE html>
<html lang="en">
<head>
	<title>Reporte FE</title>
	<!-- meta charset and meta viewport -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- CSS Bootstrap -->
	<link rel="stylesheet" href="./css/Bootstrap_4.css">
	<!-- CSS Data Table -->
	<link rel="stylesheet" type="text/css" href="./css/DataTable.css">
	<!-- Estilo personalizados -->
	<style type="text/css">
		body{
			/*		 Top Right Bot Left */
/*			padding:  0em 0em 0em 0em;
*/			background-color: #CCDCE2;
			margin: 2em;
		}

		.fondo{
			background-color: #fff;
			max-width: 1330px;
			border-radius: 5px;
			padding: 15px;
			-webkit-box-shadow: -4px 6px 36px -2px rgba(0,0,0,0.52);
			-moz-box-shadow: -4px 6px 36px -2px rgba(0,0,0,0.52);
			box-shadow: -4px 6px 36px -2px rgba(0,0,0,0.52);
		}
		
		button{
			border-radius: 15px;
			height: 2em;
			width: 2em;
		}

		/*Tipo de ejecucion*/
		#normal{
			border:  solid #fff;
			background: #fff;
		}
		
		#quick{
			border:  solid #01AEF0;
			background: #01AEF0;
		}
		
		#rqt{
			border:  solid #FFAFAF;
			background: #FFAFAF;
		}
		/*Estados de proceso*/
		
		#terminado{
			border:  solid #74FB53;
			background: #74FB53;
		}
		
		#pausado{
			border:  solid #FB5353;
			background: #FB5353;
		}
		
		#ejecucion{
			border:  solid #FFA81B;
			background: #FFA81B;
		}
		
		#porIniciar{
			border:  solid #fff;
			background: #fff;
		}
		td, th{
			text-align: center;
			text-transform: capitalize;
		}

		/* Responsividad */
		@media (min-width: 1200px)
		.container {
		    max-width: 1140px;
		}
		@media (min-width: 992px)
		.container {
		    max-width: 960px;
		}
		@media (min-width: 768px)
		.container {
		    max-width: 720px;
		}

		@media (min-width: 576px)
		.container {
		    max-width: 540px;
		}

	</style>
</head>
<body>

	<div class="container fondo">
	  	<h2>Reporte ENsamble</h2>
	  	<br>
		<!--  -->
 		<div class="table-responsive">
 		<table id="reporte" class="table table-striped table-bordered" style="width:100%">
 		        <thead class="encabezado">
 		            <!-- <tr>
 		                <th>Name</th>
 		                <th>Position</th>
 		                <th>Office</th>
 		                <th>Age</th>
 		                <th>Start date</th>
 		                <th>Salary</th>
 		            </tr> -->
 		        </thead>
				<tbody id="cuerpo">

				</tbody>
 		        <tfoot class="encabezado">
 		            <!-- <tr>
 		                <th>Name</th>
 		                <th>Position</th>
 		                <th>Office</th>
 		                <th>Age</th>
 		                <th>Start date</th>
 		                <th>Salary</th>
 		            </tr> -->
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
				<div class="col-md-2">
					<!-- Code -->
				</div>
				<!-- Colores de los estados de los procesos  -->
				<div class="col-md-6">
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
				</div>
			<!--  -->
			</div>
	</div>
	<!-- </div> -->

<!-- <div id="container">
	<h1>Reporte general de ensamble</h1>

	<div id="body">
		Cuerpo del reporte
		<table border="1px" style="width: 100%;">
			<thead id="encabezado">
				
			</thead>
		</table>
	</div>
	
	<p class="footer"></p>
	elapsed_time= Esta variable me da el tiempo de render de la pagina
</div> -->

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