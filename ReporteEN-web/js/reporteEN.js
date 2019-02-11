$(document).ready(function() {
	// Consultar Tabla 
	$.ajax({
		url: baseURL+'reporteEN/estructurarEncabezado',
		type: 'POST',
		dataType: 'html'
	})
	.done(function(encabezados) {
		// ...
		// Encabezados de la tabla
		$("#encabezado").html(encabezados);
		// ...
		$.ajax({
			url: baseURL+'reporteEN/consultarInformacionCuerpoTabla',
			type: 'POST',
			dataType: 'html'
		})
		.done(function() {
			console.log("success");
		})
		.fail(function() {
			console.log("error");
		});
		// ...
	})
	.fail(function(e) {
		console.log("error primer nivel" + e);
	});	
// ...
});