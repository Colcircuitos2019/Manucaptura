<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Reporte EN</title>

	<style type="text/css">

	body {
		background-color: #CCDCE2;
		margin: 30px;
		font: 13px/20px normal Helvetica, Arial, sans-serif;
		color: #4F5155;
	}

	h1 {
		color: #444;
		background-color: transparent;
		border-bottom: 1px solid #D0D0D0;
		font-size: 20px;
		font-weight: normal;
		margin: 0 0 14px 0;
		padding: 14px 15px 10px 15px;
	}

	th{
		font-size: 16px;
	}

	#body{
		margin: 0 15px 0 15px;
		height: 38em;
	}
	
	p.footer{
		text-align: right;
		font-size: 11px;
		border-top: 1px solid #D0D0D0;
		line-height: 32px;
		padding: 0 10px 0 10px;
		margin: 20px 0 0 0;
	}
	
	#container{
		margin: 10px;
		border: 1px solid #D0D0D0;
		-webkit-box-shadow: 0 0 8px #D0D0D0;
		background: #fff;
		/*height: 10em;*/
	}

	button{
		border-radius: 15px;
		height: 2em;
		width: 2em;
	}

	.infoColores{
		display: inline-block;
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

	#estadosP{
		float: right;
	}

/*	div{
		border: solid;
	}*/

	</style>
</head>
<body>

<div id="container">
	<h1>Reporte general de ensamble</h1>

	<div id="body">
		<!-- Cuerpo del reporte -->
		<table border="1px" style="width: 100%;">
			<thead id="encabezado">
				
			</thead>
		</table>
	</div>
	<!--  -->
	<p class="footer"></p>
	<!-- elapsed_time= Esta variable me da el tiempo de render de la pagina -->
</div>

<footer>

	<div id="footer">
		<!-- Tipo proyectos -->
		<div class="infoColores">
			<button id="normal"></button>
			<label for="normal">Normal</label>
		</div>
		&nbsp;&nbsp;
		<div class="infoColores">
			<button id="quick"></button>
			<label for="quick">Quick</label>
		</div>
		&nbsp;&nbsp;
		<div class="infoColores">
			<button id="rqt"></button>
			<label for="rqt">RQT</label>
		</div>
		<!-- Estado conexion con el servidor -->
		
		<!-- Estados de procesos -->
		<div id="estadosP">
			<div class="infoColores">
				<button id="terminado"></button>
				<label for="terminado">Terminado</label>
			</div>
			&nbsp;&nbsp;
			<div class="infoColores">
				<button id="pausado"></button>
				<label for="pausado">Pausado</label>
			</div>
			&nbsp;&nbsp;
			<div class="infoColores">
				<button id="ejecucion"></button>
				<label for="ejecucion">Ejecucion</label>
			</div>
			&nbsp;&nbsp;
			<div class="infoColores">
				<button id="porIniciar"></button>
				<label for="porIniciar">Por Iniciar</label>
			</div>
		</div>			
	</div>
</footer>
	<!-- jQuery -->
	<script src="./js/jquery.js"></script>
	<!-- Acciones -->
	<script src="./js/reporteEN.js"></script>
	<!-- ... -->
	<script type="text/javascript">
		var baseURL = "<?= base_url(); ?>";
	</script>
</body>
</html>