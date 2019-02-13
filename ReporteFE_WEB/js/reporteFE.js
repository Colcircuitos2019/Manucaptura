$(document).ready(function() {
	// Consultar Tabla 
	$.ajax({
		url: baseURL+'reporteFE/cabezaReporte',
		type: 'POST',
		dataType: 'html'
	})
	.done(function(cabezaReporte) {
		// ...
		// Encabezados de la tabla
		$(".encabezado").html(cabezaReporte);
		// ...
		$.ajax({
			url: baseURL+'reporteFE/consultarInformacionCuerpoTabla',
			type: 'POST',
			dataType: 'json'
		})
		.done(function(cuerpo) {
			// console.log(datos);
			$('#cuerpo').html(cuerpo);
			// $('#reporte').DataTable(configDataTable());
			// $('#reporte').DataTable().ajax.reload(null, false);
			// $('#reporte').DataTable().fnDestroy();
			// $('#cuerpo').empty();
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
// function configDataTable() {
//     return {
//         "bStateSave": true,
//         "iCookieDuration": 60,
//         "language": {
//             "sProcessing": "Procesando...",
//             "sZeroRecords": "No se encontraron resultados",
//             "sLengthMenu": "Mostrar _MENU_ Registros",
//             "sEmptyTable": "Ningún dato disponible en esta tabla",
//             "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
//             "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
//             "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
//             "sInfoPostFix": "",
//             "sSearch": "Buscar:",
//             "sUrl": "",
//             "sInfoThousands": ",",
//             "sLoadingRecords": "Cargando...",
//             "oPaginate": {
//                 "sFirst": "Primero",
//                 "sLast": "Último",
//                 "sNext": "Siguiente",
//                 "sPrevious": "Anterior"
//             },
//             "oAria": {
//                 "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
//                 "sSortDescending": ": Activar para ordenar la columna de manera descendente"
//             }
//         }
//     };
// }
// Consultar estado del servidor
// $.ajax({
// 	url: baseURL+'reporteEN/estadoDeConexionServidor',
// 	type: 'POST'
// })
// .done(function(e) {
// 	console.log("success" + e);
// })
// .fail(function() {
// 	console.log("error");
// })
// .always(function() {
// 	console.log("complete");
// });

});