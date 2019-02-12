$(document).ready(function() {
	// Consultar Tabla 
	$.ajax({
		url: baseURL+'reporteEN/estructurarEncabezado',
		type: 'POST',
		dataType: 'json'
	})
	.done(function(informacion) {
		// ...
		// Encabezados de la tabla
		$(".encabezado").html(informacion.cabeza);
		// ...
		$.ajax({
			url: baseURL+'reporteEN/consultarInformacionCuerpoTabla',
			type: 'POST',
			dataType: 'html',
			data: {procesos: informacion.procesos}
		})
		.done(function(datos) {
			// console.log(datos);
			$('#cuerpo').html(datos);
			$('#reporte').DataTable(configDataTable());
		})
		.fail(function(e) {
			console.log(e);
		});
		// ...
	})
	.fail(function(e) {
		console.log("error primer nivel" + e);
	});	
//Retornar la configuracion para la funcion DataTable
function configDataTable() {
    return {
        "bStateSave": true,
        "iCookieDuration": 60,
        "language": {
            "sProcessing": "Procesando...",
            "sZeroRecords": "No se encontraron resultados",
            "sLengthMenu": "Mostrar _MENU_ Registros",
            "sEmptyTable": "Ningún dato disponible en esta tabla",
            "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
            "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix": "",
            "sSearch": "Buscar:",
            "sUrl": "",
            "sInfoThousands": ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "Último",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            }
        }
    };
}

});