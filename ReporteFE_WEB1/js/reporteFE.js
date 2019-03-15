$(document).ready(function() {

// Consultar información
setInterval("produccion($(\"#cantActualizaciones\").text())",1000);
// produccion();

// Consultar conexion con servidor
setInterval("estadoDelServidorDB()",1000);

// Consultar el estado de lectura del facilitador a cargo.
setInterval("estadoLectura()",1200);

});

// Retornar la configuracion para la funcion DataTable
function configDataTable() {
    return {
    	"fixedHeader": {
    	        "header": true,
    	        "footer": true
    	},
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

// Consutar la informacion del área de produccion (FE)
function produccion(cont) {
	if (parseInt(cont) == parseInt($("#cantActualizaciones").text())) {
				$.ajax({
					url: baseURL+'reporteFE/cabezaReporte',
					type: 'POST',
					dataType: 'html'
				}).done(function(cabezaReporte) {
					// ...
					$.ajax({
						url: baseURL+'reporteFE/consultarInformacionCuerpoTabla',
						type: 'POST',
						dataType: 'html'
					})
					.done(function(cuerpo) {
						// ... table table-striped table-bordered
						$("#contentTable").empty();
						$("#contentTable").html("<table id=\"reporte\" class=\"display\" style=\"width:100%\">"+
			 		        						"<thead class=\"encabezado\">"+

			 		        						"</thead>"+
													"<tbody id=\"cuerpo\">"+

													"</tbody>"+
			 		        						"<tfoot class=\"encabezado\">"+

			 		        						"</tfoot>"+
			 									"</table>");
						// ...
						$(".encabezado").html(cabezaReporte); //Cabeza y Pie de pagina de la tabla
						// ...
						$('#cuerpo').html(cuerpo);// Tabla de información
						// ...
						$("#reporte").DataTable(configDataTable());
						// ... Aumenta uno el contado de actualizaciones
						$("#cantActualizaciones").text(parseInt($("#cantActualizaciones").text()) + 1);
						// ...
					})
					.fail(function(e) {
						console.log(e);
					});
					// ...
				})
				.fail(function(e) {
					console.log("error primer nivel" + e);
				});	
	}
} 
//...

function estadoDelServidorDB() {
		// ...
			// Consultar estado del servidor
			$.ajax({
				url: baseURL+'reporteFE/estadoDeConexionServidor',
				type: 'POST'
			})
			.done(function(estadoDB) {
				// console.log("success" + estadoDB);//Estado del servidor
				if (estadoDB == 1) {
					// Hay conexion con el motor de base de datos
					$("#estadoDB").text("Linea");
					$("#estadoDB").addClass('linea');
					$("#estadoDB").removeClass('sinLinea');
				}else{
					//No existe conexion con la base de datos
					$("#estadoDB").text("Sin linea");
					$("#estadoDB").addClass('sinLinea');
					$("#estadoDB").removeClass('linea');
				}
			})
			.fail(function() {
				console.log("error");
			});
		// ...
}
// ...

function estadoLectura() {
	$.ajax({
		url: baseURL + 'reporteFE/estadoDeLecturaPuertoSerial',
		type: 'POST'
	})
	.done(function(estadoLectura) {
		// console.log(estadoLectura);
		if (estadoLectura == 1) { //Esta de lectura del puerto serial esta "Activado"
			$("#estadoLectura").text("Activado");
			$("#estadoLectura").addClass('linea');
			$("#estadoLectura").removeClass('sinLinea');
		}else{ //Estado de lectura del puerto serial "Desactivado"
			$("#estadoLectura").text("Desactivado");
			$("#estadoLectura").addClass('sinLinea');
			$("#estadoLectura").removeClass('linea');
		}	
		// console.log("success");
	})
	.fail(function() {
		console.log("error");
	});
}