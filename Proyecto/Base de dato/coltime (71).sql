-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-04-2019 a las 16:53:39
-- Versión del servidor: 10.1.29-MariaDB
-- Versión de PHP: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `coltime`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarProductoPorMinuto` (IN `idDetalleProducto` INT, IN `area` INT, IN `idLector` INT, IN `tiempo` VARCHAR(20), IN `cantidad_terminada` INT)  NO SQL
BEGIN
# ...
IF area=1 THEN # Formato estandar - FE

	UPDATE detalle_formato_estandar d SET d.tiempo_por_unidad=(SEC_TO_TIME(ROUND((TIME_TO_SEC(tiempo)/cantidad_terminada),0))) WHERE d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=idLector;

ELSE
 IF area=2 THEN # Teclados - TE
  
 	UPDATE detalle_teclados d SET d.tiempo_por_unidad=(SEC_TO_TIME(ROUND((TIME_TO_SEC(tiempo)/cantidad_terminada),0))) WHERE d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=idLector;
 
 ELSE # Ensamble - EN
  
 	UPDATE detalle_ensamble d SET d.tiempo_por_unidad=(SEC_TO_TIME(ROUND((TIME_TO_SEC(tiempo)/cantidad_terminada),0))) WHERE d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=idLector;
 
 END IF;
END IF;
# ...
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalPorUnidad` (IN `detalle` INT, IN `tiempo` VARCHAR(20))  NO SQL
UPDATE detalle_proyecto dp SET dp.Total_timepo_Unidad=tiempo WHERE dp.idDetalle_proyecto=detalle$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalProducto` (IN `idDetalleProducto` INT, IN `tiempo_total_producto` VARCHAR(20))  NO SQL
BEGIN

UPDATE detalle_proyecto dp SET dp.tiempo_total=tiempo_total_producto WHERE dp.idDetalle_proyecto = idDetalleProducto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualziarCantidadProcesosEnsamble` (IN `ID` INT, IN `cantidades` VARCHAR(10))  NO SQL
BEGIN
#Cantidad que tiene el proceso de ensamble para procesar.
UPDATE detalle_ensamble e SET e.cantidadProceso=cantidades WHERE e.idDetalle_ensamble=ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CalcularTiempoEjecucionProceso` (IN `detalle` INT, IN `lector` INT, IN `area` INT, IN `cantidadProductosQR` TINYINT)  NO SQL
BEGIN
DECLARE idDetalleProceso int;
DECLARE timpo_total_proceso varchar(10);
DECLARE tiempo_ejecucion varchar(10);
DECLARE numero_operarios tinyint(3);
# ...
IF area=1 THEN

SET idDetalleProceso=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.idproceso=lector);

UPDATE detalle_formato_estandar f SET  f.hora_terminacion=now() WHERE f.idDetalle_formato_estandar=idDetalleProceso;

# Tiempo total del proceso
SET timpo_total_proceso = (SELECT f.tiempo_total_por_proceso from detalle_formato_estandar f WHERE f.idDetalle_formato_estandar=idDetalleProceso);

# Tiempo de ejecucion del proceso en formato "HH:MM:SS"
SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') from detalle_formato_estandar f WHERE f.idDetalle_formato_estandar=idDetalleProceso);

# Numero de operarios que trabajan en el proceso de la OP
SET numero_operarios = (SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.idDetalle_formato_estandar = idDetalleProceso);

#SELECT CONVERT(ADDTIME(timpo_total_proceso,(SELECT sec_to_time(ROUND((time_to_sec(tiempo_ejecucion) * numero_operarios))/cantidadProductosQR),0)),char(10)) AS tiempoTotal;

# ...
ELSE
 IF area=2 THEN
 
	SET idDetalleProceso=(SELECT t.idDetalle_teclados from detalle_teclados t JOIN detalle_proyecto d on t.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and t.idproceso=lector);

	UPDATE detalle_teclados t SET  t.hora_terminacion=now() WHERE t.idDetalle_teclados=idDetalleProceso;

	# Tiempo total del proceso
	SET timpo_total_proceso = (SELECT t.tiempo_total_por_proceso from detalle_teclados t WHERE t.idDetalle_teclados=idDetalleProceso);

	# Tiempo de ejecucion del proceso en formato "HH:MM:SS"
	SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(t.hora_terminacion,t.hora_ejecucion),'%H:%i:%s') from detalle_teclados t WHERE t.idDetalle_teclados = idDetalleProceso);

	# Numero de operarios que trabajan en el proceso de la OP
	SET numero_operarios = (SELECT t.noperarios FROM detalle_teclados t WHERE t.idDetalle_teclados = idDetalleProceso);

	#SELECT CONVERT(ADDTIME(timpo_total_proceso,(SELECT sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios))),char(10)) AS tiempoTotal;


 ELSE
  IF area=3 THEN
  
  	SET idDetalleProceso=(SELECT e.idDetalle_ensamble from detalle_ensamble e JOIN detalle_proyecto d on e.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and e.idproceso=lector);

 	UPDATE detalle_ensamble e SET  e.hora_terminacion=now() WHERE e.idDetalle_ensamble=idDetalleProceso;
  
  # Tiempo total del proceso
	SET timpo_total_proceso = (SELECT e.tiempo_total_por_proceso from detalle_ensamble e WHERE e.idDetalle_ensamble=idDetalleProceso);

	# Tiempo de ejecucion del proceso en formato "HH:MM:SS"
	SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(e.hora_terminacion,e.hora_ejecucion),'%H:%i:%s') from detalle_ensamble e WHERE e.idDetalle_ensamble = idDetalleProceso);

	# Numero de operarios que trabajan en el proceso de la OP
	SET numero_operarios = (SELECT e.noperarios FROM detalle_ensamble e WHERE e.idDetalle_ensamble = idDetalleProceso);

	#SELECT CONVERT(ADDTIME(timpo_total_proceso,(SELECT sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios))),char(10)) AS tiempoTotal;
  
  END IF;
 
 END IF;
# ... Queda pendiente Almacen - AL
END IF;

# ...
#SELECT CONVERT(ADDTIME(timpo_total_proceso,(SEC_TO_TIME(ROUND(((TIME_TO_SEC(tiempo_ejecucion) * numero_operarios)/cantidadProductosQR),0)),char(10))))) AS  tiempoTotal;

SELECT  CONVERT(ADDTIME(timpo_total_proceso, (SEC_TO_TIME(ROUND(((TIME_TO_SEC(tiempo_ejecucion)*numero_operarios)/cantidadProductosQR),0)))), char(10)) AS tiempoTotal;
# ...


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProductos` (IN `area` INT, IN `idDetalleProducto` INT)  NO SQL
BEGIN
DECLARE iniciar int;
DECLARE pausar int;
DECLARE terminar int;
DECLARE ejecucion int;
SET iniciar=(SELECT d.pro_porIniciar FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProducto);
SET pausar=(SELECT d.pro_Pausado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProducto);
SET ejecucion=(SELECT d.pro_Ejecucion FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProducto);
SET terminar=(SELECT d.pro_Terminado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProducto);

IF area=1 OR area=4 THEN # el área numero 4 = almacen ya no se va a utilizar más

	IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  		UPDATE detalle_proyecto d SET d.estado=1 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Por iniciar
	ELSE
 		IF ejecucion>=1 THEN
  			UPDATE detalle_proyecto d SET d.estado=4 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Ejecución
 		ELSE
  			IF pausar!=0 and ejecucion=0 and (terminar=0 or terminar!=0) THEN
  				UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Pausado 
  			ELSE
   				IF pausar=0 and ejecucion=0 and terminar!=0 AND iniciar!=0 THEN
   					UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Pausado
   				ELSE
        			IF (iniciar+pausar+ejecucion+terminar)=terminar AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  						UPDATE detalle_proyecto d SET d.estado = 3, d.fecha_salida = (SELECT now()), d.mes_de_corte = CURDATE() WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Terminado
                        #CALL PA_GestionarMesCorteTiempoProductoProyecto(idDetalleProducto,Tiempo);<---- Por el momento esto no se va a realizar acá...
                        
    				END IF;
   				END IF;
  			END IF;
 		END IF;
	END IF;  
 

ELSE

 	IF area=2 OR area=3 THEN #área de Ensamble - EN y Teclados - TE

  		IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
        
  			UPDATE detalle_proyecto d SET d.estado=1 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: inicial
            
  		END IF;

		IF ejecucion >= 1  THEN
        
			UPDATE detalle_proyecto d SET d.estado=4 WHERE d.idDetalle_proyecto=idDetalleProducto; # Estado: Ejecucion
            
		ELSE
 			IF pausar!=0 and ejecucion=0 and (terminar!=0 or terminar=0) THEN
            
    			UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=idDetalleProducto;# Estado: Pausado
                
 			ELSE
  				IF terminar!=0 AND ejecucion=0 AND pausar=0 THEN
                
        			CALL PA_CambiarEstadoTerminadoTEIN(area,idDetalleProducto);# Estado: Terminado
                    
   				END IF;
 			END IF;
		END IF;
 	END IF;
    
END IF;

CALL PA_CambiarEstadoDeProyecto((SELECT d.proyecto_numero_orden FROM detalle_proyecto d where d.idDetalle_proyecto=idDetalleProducto));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProyecto` (IN `orden` INT)  NO SQL
BEGIN

DECLARE iniciar int;
DECLARE pausar int;
DECLARE ejecucion int;
DECLARE terminado int;
DECLARE fecha date;
DECLARE estado varchar(13);

SET iniciar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado=1);
SET pausar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado=2);
SET terminado=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado=3);
SET ejecucion=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado=4);
SET fecha=(SELECT p.NFEE FROM proyecto p WHERE p.numero_orden=orden);
SET estado=(SELECT p.estadoEmpresa FROM proyecto p WHERE p.numero_orden=orden);

IF estado IS null OR (estado !='Retraso' AND estado !='A tiempo') THEN
   UPDATE proyecto p SET p.estadoEmpresa='A tiempo' WHERE p.numero_orden = orden;
END IF;

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminado=0 THEN
  UPDATE proyecto p SET p.estado=1, p.fecha_salidal=null WHERE p.numero_orden = orden;
	UPDATE proyecto p SET p.estadoEmpresa=null WHERE p.numero_orden = orden;
ELSE
 IF ejecucion>=1 THEN
  UPDATE proyecto p SET p.estado=4, p.fecha_salidal=null WHERE p.numero_orden = orden;

 ELSE
   IF pausar!=0 and ejecucion=0 and (terminado=0 or terminado!=0) THEN
  UPDATE proyecto p SET p.estado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

  ELSE
   IF pausar=0 and ejecucion=0 and terminado!=0 AND iniciar!=0 THEN
   UPDATE proyecto p SET p.estado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

   ELSE
        IF (iniciar+pausar+ejecucion+terminado)=terminado AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  	UPDATE proyecto p SET p.estado=3, p.fecha_salidal=(SELECT NOW()) WHERE p.numero_orden = orden; 

    END IF;
   END IF;
  END IF;
 END IF;
END IF; 


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoTerminadoTEIN` (IN `area` INT, IN `idDetalleProducto` INT)  NO SQL
BEGIN
DECLARE res boolean;

IF area=2 THEN
  IF EXISTS(SELECT d.estado FROM detalle_teclados d where d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=(SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto,area)) AND d.estado=3) THEN

 SET res= true;
 
 ELSE 

 SET res = false;

 END IF;

ELSE 
  IF area=3 THEN
 	IF EXISTS(SELECT d.estado FROM detalle_ensamble d where d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=(SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto,area)) AND d.estado=3) THEN

 		SET res= true;
 
 	ELSE 

 		SET res = false;
  
  	END IF; 
  END IF;
END IF;


IF res THEN # Proceso Terminado

 UPDATE detalle_proyecto p SET p.estado=3, p.fecha_salida = (SELECT now()), p.mes_de_corte = CURDATE()  where p.idDetalle_proyecto=idDetalleProducto;

ELSE

  UPDATE detalle_proyecto p SET p.estado=2 where p.idDetalle_proyecto=idDetalleProducto;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosEjecucion` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.idArea FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado=4 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.idArea;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosIngresadosArea` ()  NO SQL
BEGIN

SELECT COUNT(dp.idDetalle_proyecto) as catidadIngresada ,dp.idArea FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(p.fecha_ingreso,'%Y -%m -%d')=DATE_FORMAT(CURDATE(),'%Y -%m -%d')  and p.eliminacion=1 GROUP BY dp.idArea;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosPorIniciar` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.idArea FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado=1 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.idArea;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosterminadosHoy` ()  NO SQL
BEGIN
DECLARE FE INT;
DECLARE TE INT;
DECLARE EN INT;
DECLARE AL INT;

SET FE =(SELECT COUNT(*) FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(df.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND df.idproceso=10 AND dp.estado=3 AND df.estado=3 and p.eliminacion=1);

SET TE =(SELECT COUNT(*) FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(dt.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dt.idproceso=14 AND dp.estado=3 AND dt.estado=3 and p.eliminacion=1);

SET EN =(SELECT COUNT(*) FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND de.idproceso=18 AND dp.estado=3 AND de.estado=3 and p.eliminacion=1);

SET AL =(SELECT COUNT(*) FROM almacen de JOIN detalle_proyecto dp ON de.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dp.estado=3 AND de.estado=3 and p.eliminacion=1);

SELECT FE,TE,EN,AL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadUnidadesProyecto` (IN `orden` INT)  NO SQL
BEGIN
DECLARE total int;

SET total=(SELECT SUM(sp.canitadad_total) FROM detalle_proyecto sp WHERE sp.proyecto_numero_orden=orden AND sp.idArea!=4);

SELECT total;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarColoresAntisolder` ()  NO SQL
BEGIN

	SELECT * FROM color_antisolder;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarCondicionesProductos` (IN `idCondicion` INT)  NO SQL
BEGIN
#Falta agregar el campo del área a la que aplica el producto
IF idCondicion = 0 THEN# Consultar todos
	SELECT cp.idCondicion, cp.area, p.nombre, cp.material, cp.antisorder, cp.ruteo, EXISTS(SELECT * FROM procesos_producto pp WHERE pp.idCondicion=cp.idCondicion) AS asignado FROM  condicion_producto cp JOIN producto p ON cp.idProducto=p.idproducto;
ELSE# Consultar por idCondicion
	SELECT cp.idCondicion, cp.area, p.nombre, cp.material, cp.antisorder, cp.ruteo, EXISTS(SELECT * FROM procesos_producto pp WHERE pp.idCondicion=cp.idCondicion) AS asignado FROM  condicion_producto cp JOIN producto p ON cp.idProducto=p.idproducto WHERE cp.idCondicion=idCondicion;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetalleProyecto` (IN `orden` VARCHAR(11))  NO SQL
BEGIN

IF orden = "" THEN

	SELECT p.numero_orden, d.idDetalle_proyecto, n.nom_area, t.nombre, d.canitadad_total, d.estado, d.PNC, d.material, (SELECT c.color FROM color_antisolder c WHERE c.idColor_antisolder=d.antisolder) AS color_antisodler, d.antisolder, d.ruteo, d.ubicacion, p.parada, (SELECT e.nom_espesor FROM espesor e WHERE e.idEspesor=d.idEspesor) AS espesor,d.idEspesor FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden;

ELSE

	SELECT p.numero_orden, d.idDetalle_proyecto, n.nom_area, t.nombre, d.canitadad_total, d.estado, d.PNC, d.material, (SELECT c.color FROM color_antisolder c WHERE c.idColor_antisolder=d.antisolder) AS color_antisodler, d.antisolder, d.ruteo, d.ubicacion, p.parada, (SELECT e.nom_espesor FROM espesor e WHERE e.idEspesor=d.idEspesor) AS espesor, d.idEspesor FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden LIKE CONCAT(orden,'%');

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetallesDeCortesTiempoMesAnteriorProducto` (IN `idDetalleProducto` INT)  NO SQL
BEGIN

	SELECT tvmp.tiempo_proyecto_mes, tvmp.cantidad_terminada FROM tiempo_invertido_producto_mes tvmp WHERE tvmp.idDetalle_proyecto = idDetalleProducto AND DATE_FORMAT(DATE_ADD(tvmp.mes, INTERVAL 1 MONTH),'%Y-%m') = DATE_FORMAT(CURDATE(), '%Y-%m');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetallesProyectosProduccion` (IN `area` INT, IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN
 #Estados del proyecto solo numero 1
SELECT d.proyecto_numero_orden,t.nombre,d.estado,p.tipo_proyecto FROM producto t JOIN detalle_proyecto d ON t.idProducto=d.idProducto JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.idArea=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado=1;

ELSE
 IF op=3 THEN
#Estados del proyecto numero 3
SELECT d.proyecto_numero_orden,t.nombre,d.estado,p.tipo_proyecto FROM producto t JOIN detalle_proyecto d ON t.idProducto=d.idProducto JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.idArea=area AND DATE_FORMAT(d.fecha_salida,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND d.PNC=0 AND p.eliminacion=1;

 ELSE
  IF op=2 THEN
  #Esados del proyecto solo numero 2
 SELECT d.proyecto_numero_orden,t.nombre,d.estado,p.tipo_proyecto FROM producto t JOIN detalle_proyecto d ON t.idProducto=d.idProducto JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.idArea=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado=2;
  ELSE
   #Esados del proyecto solo numero 4
 SELECT d.proyecto_numero_orden,t.nombre,d.estado,p.tipo_proyecto FROM producto t JOIN detalle_proyecto d ON t.idProducto=d.idProducto JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.idArea=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado=4;
  END IF;
  
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDireccionIPServidorSocketPrograma` (IN `area` TINYINT(1))  NO SQL
BEGIN

	SELECT s.ipServidor,s.puerto FROM servidor_reporte s WHERE s.programa=area LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarEspesorTarjeta` ()  NO SQL
BEGIN

	SELECT * FROM espesor;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarEstadoLecturaFacilitador` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.estadoLectura FROM usuariopuerto u WHERE u.documentousario= doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarExistenciaCortesTiemposPorProcesoAnteriores` (IN `idProceso` INT)  NO SQL
BEGIN
	
	SELECT tmp.tiempo FROM tiempo_invertido_mes_proceso tmp WHERE DATE_FORMAT(tmp.mes_corte,'%Y-%m') < DATE_FORMAT(CURDATE(),'%Y-%m') AND tmp.idproceso = idProceso;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarIDProcesosTEYEN` (IN `area` INT)  NO SQL
BEGIN

SELECT p.idproceso FROM procesos p WHERE p.idArea=area and p.estado=1; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarImagenUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.imagen from usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarIndormacionQR` (IN `orden` INT)  NO SQL
BEGIN
select p.idDetalle_proyecto,d.idDetalle_formato_estandar,d.idproceso from detalle_proyecto p INNER JOIN detalle_formato_estandar d ON p.idDetalle_proyecto=d.idDetalle_proyecto where p.proyecto_numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarNumeroOrden` ()  NO SQL
SHOW TABLE STATUS like 'proyecto'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesoAreaReporte` (IN `op` INT)  NO SQL
BEGIN
# Ensamble=3; teclados=2; Formato estandar=1
#...
SELECT * FROM procesos p WHERE p.idArea=op AND p.estado=1 ORDER BY p.orden_mostrar ASC;
#...
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesoProductoEnsamble` (IN `idDetalle` INT)  NO SQL
BEGIN
#se encarga de consultar los proceso de ensamble en el orden que se les asigno la ejecución por el detalle del producto del proyecto.
SELECT e.idDetalle_ensamble,e.idproceso,e.orden,e.cantidad_terminada FROM detalle_ensamble e WHERE e.idDetalle_proyecto=idDetalle AND e.orden>0 ORDER BY e.orden ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesos` (IN `area` INT)  NO SQL
BEGIN

IF area=0 THEN
#Consultar todos los procesos en general
	SELECT * FROM procesos p ORDER BY p.idproceso ASC;
ELSE
# Consultar por área de produccion
	SELECT p.nombre_proceso,p.idproceso,p.estado FROM procesos p WHERE p.idArea=area ORDER BY p.idproceso ASC;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosFE` (IN `detalle` INT)  NO SQL
begin

SELECT p.nombre_proceso FROM detalle_formato_estandar f JOIN procesos p on f.idproceso=p.idproceso WHERE f.idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosProducto` (IN `idCondicional` INT)  NO SQL
BEGIN

SELECT c.idProceso,c.orden,c.procesoFinal FROM procesos_producto c WHERE c.idCondicion=idCondicional;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosProductoProyecto` (IN `idDetalleProducto` VARCHAR(11), IN `area` VARCHAR(2))  NO SQL
BEGIN

IF area = "FE" THEN # Formato estandar - FE

	SELECT f.idproceso,p.nombre_proceso,f.estado,f.tiempo_total_por_proceso,f.cantidadProceso FROM detalle_formato_estandar f JOIN procesos p ON f.idproceso=p.idproceso WHERE f.idDetalle_proyecto=idDetalleProducto;

ELSE

  IF area = "TE" THEN # Teclados - TE
  
  	SELECT t.idproceso, p.nombre_proceso, t.estado, t.tiempo_total_por_proceso, t.cantidadProceso FROM detalle_teclados t JOIN procesos p ON t.idproceso=p.idproceso WHERE t.idDetalle_proyecto=idDetalleProducto;
  
  ELSE # Ensamble - EN
  
  	SELECT e.idproceso,p.nombre_proceso,e.estado,e.tiempo_total_por_proceso,e.cantidadProceso FROM detalle_ensamble e JOIN procesos p ON e.idproceso=p.idproceso WHERE e.idDetalle_proyecto=idDetalleProducto;
  
  END IF;
  
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProductos` ()  NO SQL
BEGIN

	SELECT * FROM producto p;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProductosProyectosMesDeCorte` ()  NO SQL
BEGIN

	SELECT p.idDetalle_proyecto,p.tiempo_total,p.cantidad_terminada,p.fecha_terminacion_cantidad FROM detalle_proyecto p WHERE DATE_FORMAT(p.mes_de_corte,'%Y-%m') = (DATE_FORMAT(CURDATE(),'%Y-%m'));

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEliminados` ()  NO SQL
BEGIN

SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEntrega` (IN `orden` VARCHAR(11), IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,oFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') and 
p.eliminacion=1;
              ELSE 
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosIngreso` (IN `orden` VARCHAR(11), IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN 

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1; 
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosSalida` (IN `orden` VARCHAR(11), IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
                                   END IF;
                                 END IF;
                               END IF;
                            END IF;
                         END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
         END IF;
      END IF; 
    END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarPuertoSerialUsuario` (IN `documento` VARCHAR(13))  NO SQL
BEGIN

IF (EXISTS(SELECT * FROM usuariopuerto up WHERE up.documentousario=documento)) THEN

SELECT up.usuarioPuerto FROM usuariopuerto up WHERE up.documentousario=documento;

ELSE
#No existe ningun ususario que guarda alguen puerto serial
SELECT '' AS vacio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarSeleccionDeProcesoCondicionProducto` (IN `idCondicion` INT)  NO SQL
BEGIN

DECLARE area tinyint(1);
SET area = (SELECT cp.area FROM condicion_producto cp WHERE cp.idCondicion=idCondicion LIMIT 1);

SELECT p.idproceso,p.nombre_proceso,(EXISTS(SELECT pp.orden FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=idCondicion)) AS seleccion, (SELECT pp.orden FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=idCondicion) AS orden, (SELECT pp.idProceso_producto FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=idCondicion) AS idProceso_producto FROM procesos p WHERE p.idArea=area AND p.estado=1;

#SELECT p.idproceso,p.nombre_proceso,(EXISTS(SELECT pp.orden FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=1)) AS seleccion, (SELECT pp.orden FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=1) AS orden, (SELECT pp.idProceso_producto FROM procesos_producto pp WHERE pp.idProceso=p.idproceso AND pp.idCondicion=1) AS idProceso_producto FROM procesos p WHERE p.idArea=1 AND p.estado=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarServidorSocketReporte` (IN `area` INT)  NO SQL
BEGIN

IF area = 0 THEN
#Consultar General

	SELECT s.ipServidor, s.puerto, CONVERT(s.reporte, int) AS area FROM servidor_reporte s WHERE s.estado=1 AND s.programa IS null;

ELSE
# Consultar respectivamente por el reporte que se va acrualizar...
 
	SELECT s.ipServidor, s.puerto, CONVERT(s.reporte, int) AS area FROM servidor_reporte s WHERE s.reporte=area AND s.estado = 1 AND s.programa is null;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarTiempoPorUnidadProcesosTerminados` (IN `idDetalle` INT, IN `area` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.estado=3 AND dp.idDetalle_proyecto=idDetalle)  THEN

 IF area=1 THEN # Formato Estandar - FE
 
    SELECT df.tiempo_por_unidad FROM detalle_formato_estandar df WHERE df.idDetalle_proyecto=idDetalle AND df.tiempo_por_unidad!='00:00:00';
    
 ELSE
  IF area=2 THEN # Teclados - TE
  
      SELECT df.tiempo_por_unidad FROM detalle_teclados df WHERE df.idDetalle_proyecto=idDetalle AND df.tiempo_por_unidad!='00:00:00';
      
   ELSE # Ensamble
   
      SELECT df.tiempo_por_unidad FROM detalle_ensamble df WHERE df.idDetalle_proyecto=idDetalle AND df.tiempo_por_unidad!='00:00:00';
      
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarTiempoProcesoAreaProduccion` (IN `idProceso` INT, IN `idArea` TINYINT)  NO SQL
BEGIN

	IF idArea = 1 THEN #Formato estandar - FE
    
    	SELECT f.tiempo_total_por_proceso FROM detalle_formato_estandar f WHERE f.idproceso=idProceso;
    
    ELSE
    
    	IF idArea = 2 THEN # Teclados - TE
        
        	SELECT t.tiempo_total_por_proceso FROM detalle_teclados t WHERE t.idproceso=idProceso;
        
        ELSE #Ensamble - EN
        
        	SELECT e.tiempo_total_por_proceso FROM detalle_ensamble e WHERE e.idproceso=idProceso;
        
        END IF;
    
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarUsuarios` (IN `doc` VARCHAR(13), IN `nombreApe` VARCHAR(50), IN `cargo` TINYINT)  NO SQL
IF doc='' AND nombreApe='' and cargo=0 THEN
SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo;
ELSE
  IF doc!='' AND nombreApe='' and cargo=0 THEN
	SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.numero_documento LIKE CONCAT(doc, '%');
 ELSE
     IF doc='' AND nombreApe!='' and cargo=0 THEN 
	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
     ELSE
        IF doc='' AND nombreApe='' and cargo!=0 THEN
        	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo;
        ELSE
            IF doc='' AND nombreApe!='' and cargo!=0 THEN
            	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
             ELSE
              IF doc!='' AND nombreApe!='' and cargo!=0 THEN
                          	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.numero_documento LIKE CONCAT(doc, '%') AND (u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%'));         ELSE
                  IF doc!='' AND nombreApe='' and cargo!=0 THEN
                                        	  SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.cargo_idcargo =cargo AND u.numero_documento LIKE CONCAT(doc, '%');
                    ELSE
                    IF doc!='' AND nombreApe!='' and cargo=0 THEN
                     SELECT u.numero_documento,u.tipo_documento,u.nombres,u.apellidos,c.nombre,u.imagen,u.estado,u.recuperacion,u.sesion FROM usuario u INNER JOIN cargo c on u.cargo_idcargo=c.idcargo WHERE u.numero_documento LIKE CONCAT(doc, '%') AND u.nombres like CONCAT('%', nombreApe, '%') or u.apellidos like CONCAT('%', nombreApe, '%');
                    END IF;
                  END IF;
              END IF;
            END IF;
        END IF;
    END IF;
  END IF;
END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CorteTiempoProcesosMes` ()  NO SQL
BEGIN

UPDATE detalle_formato_estandar f SET f.mes_de_corte = CURDATE() WHERE f.mes_de_corte='0000-00-00' AND f.estado != 1;
UPDATE detalle_teclados t SET t.mes_de_corte = CURDATE() WHERE t.mes_de_corte='0000-00-00' AND t.estado != 1;
UPDATE detalle_ensamble e SET e.mes_de_corte = CURDATE() WHERE e.mes_de_corte='0000-00-00' AND e.estado != 1;

SELECT DATE_FORMAT(now(),'%m') AS "month", DATE_FORMAT(now(),'%y') AS "year";

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CorteTiempoProductos` ()  NO SQL
BEGIN

UPDATE detalle_proyecto d SET d.mes_de_corte = CURDATE() WHERE d.mes_de_corte = "0000-00-00"; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDelDetalleDelproyecto` (IN `detalle` INT, IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN # Formato estandar - FE
	SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') as inicio,Date_format(f.fecha_fin,'%d-%M-%Y') as fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad ,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') as hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%S') as InicioTerminadoIntervalo,f.idDetalle_formato_estandar,CONVERT(f.orden, int) AS orden,f.noperarios, f.cantidadProceso FROM detalle_formato_estandar f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
ELSE
  IF area=2 THEN # Teclados - TE
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') AS inicio,Date_format(f.fecha_fin,'%d-%M-%Y') AS fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S')as tiempoActual,
TIME_FORMAT(f.hora_terminacion,'%r') AS hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') AS InicioTerminadoIntervalo,f.idDetalle_teclados,CONVERT(f.orden, int),f.noperarios, f.cantidadProceso FROM detalle_teclados f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
  ELSE
   IF area=3 THEN # Ensamble - EN 
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') AS inicio,Date_format(f.fecha_fin,'%d-%M-%Y') AS fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') AS hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') AS InicioTerminadoIntervalo ,f.idDetalle_ensamble,CONVERT(f.orden,int) AS orden,f.noperarios,f.cantidadProceso FROM detalle_ensamble f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
   ELSE
    IF area=4 THEN # Esta parte ya no se va a utilizar más...
    SELECT p.nombre_proceso,Date_Format(al.fecha_inicio,'%d-%M-%Y'),Date_format(al.fecha_fin,'%d-%M-%Y'),al.cantidad_recibida,al.tiempo_total_proceso,al.tiempo_total_proceso,f.estado,TIME_FORMAT(al.hora_registro,'%r'),datediff(CURRENT_DATE,al.fecha_inicio) as dias,TIME_FORMAT(al.hora_llegada,'%r'),datediff(al.fecha_fin,al.fecha_inicio),al.idalmacen AS idDetalleProceso FROM almacen al JOIN procesos p on al.idproceso=p.idproceso where al.idDetalle_proyecto=detalle ORDER BY al.idproceso ASC;
    END IF;
   END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=3 AND dd.ubicacion=ubic));

END IF;


UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_ensamble) FROM detalle_ensamble e WHERE e.idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(3,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=2 AND dd.ubicacion=ubic));

END IF;

UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_teclados) FROM detalle_teclados e WHERE e.idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(2,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeProduccionProyectosActivos` (IN `orden` INT, IN `area` INT, IN `pnc` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto,t.nombre,d.estado,d.idArea  FROM detalle_proyecto d JOIN producto t on d.idProducto=t.idProducto WHERE d.proyecto_numero_orden=orden and d.idArea=area AND d.PNC=pnc AND d.estado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleProyectosProduccion` (IN `orden` INT, IN `area` INT, IN `pnc` INT)  NO SQL
BEGIN
IF area >=1 AND area <=4 THEN
	SELECT d.idDetalle_proyecto,t.nombre,d.estado,d.idArea  FROM detalle_proyecto d JOIN producto t on d.idProducto=t.idProducto WHERE d.proyecto_numero_orden=orden and d.idArea=area AND d.PNC=pnc;

ELSE
	SELECT d.idDetalle_proyecto,t.nombre,d.estado,d.idArea  FROM detalle_proyecto d JOIN producto t on d.idProducto=t.idProducto WHERE d.proyecto_numero_orden=orden AND d.PNC=pnc;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesEnEjecucion` (IN `orden` INT, IN `estado` INT)  NO SQL
BEGIN

IF estado=4 THEN
SELECT dp.idDetalle_proyecto,dp.idArea FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado=estado;


ELSE

SELECT dp.idDetalle_proyecto,dp.idArea FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado=estado AND dp.idArea=4;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesparaValidarEstado` (IN `orden` INT)  NO SQL
BEGIN

SELECT dp.idDetalle_proyecto,dp.idArea FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DiagramaFETEEN` (IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN

SELECT df.idproceso,COUNT(*),df.estado FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE df.estado!=3 AND p.eliminacion=1 GROUP BY df.idproceso,df.estado ORDER BY df.idproceso ASC;

ELSE

IF op=2 THEN
SELECT dt.idproceso,COUNT(*),dt.estado FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dt.estado!=3 AND p.eliminacion=1 AND dp.estado!=3 GROUP BY dt.idproceso,dt.estado ORDER BY dt.idproceso ASC;

END IF;
SELECT de.idproceso,COUNT(*),de.estado FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE de.estado!=3 AND dp.estado!=3 AND p.eliminacion=1 GROUP BY de.idproceso,de.estado ORDER BY de.idproceso ASC;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Diagramas` (IN `inicio` VARCHAR(11), IN `fin` VARCHAR(11))  NO SQL
BEGIN

IF inicio='' AND fin='' THEN
SELECT COUNT(*),d.idArea FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 GROUP BY d.idArea;
ELSE
 IF inicio!='' AND fin='' THEN
  SELECT COUNT(*),d.idArea FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y')= DATE_FORMAT(inicio,'%d-%M-%Y') GROUP BY d.idArea;
 ELSE
  IF inicio!='' AND fin!='' THEN
  SELECT COUNT(*),d.idArea FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') BETWEEN DATE_FORMAT(inicio,'%d-%M-%Y') AND DATE_FORMAT(fin,'%d-%M-%Y')  GROUP BY d.idArea; 
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EjecucionoParada` (IN `orden` INT, IN `op` INT)  NO SQL
BEGIN

UPDATE proyecto p SET p.parada=op WHERE p.numero_orden=orden;

SELECT 1 AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarCambiarEstadoProyecto` (IN `orden` INT)  NO SQL
BEGIN
UPDATE proyecto p SET p.eliminacion=0 WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProcesoProducto` (IN `idDetalleProducto` INT, IN `area` INT)  NO SQL
BEGIN

DECLARE num_orden int;

IF area = 1 THEN # Formato estandar

	DELETE FROM detalle_formato_estandar WHERE idDetalle_proyecto = idDetalleProducto;

ELSE

	IF area = 2 THEN # Teclados
    
    	DELETE FROM detalle_teclados WHERE idDetalle_proyecto = idDetalleProducto;
    
    ELSE # Ensamble
    
    	DELETE FROM detalle_ensamble WHERE idDetalle_proyecto = idDetalleProducto;
    
    END IF;

END IF;

SET num_orden = (SELECT d.proyecto_numero_orden FROM detalle_proyecto d WHERE d.idDetalle_proyecto = idDetalleProducto);

DELETE FROM detalle_proyecto WHERE idDetalle_proyecto = idDetalleProducto;

#CALL PA_CambiarEstadoDeProyecto(num_orden);

SELECT 1 AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProcesosCondicionProducto` (IN `idProcesoP` INT)  NO SQL
BEGIN
	# Cuidado con lo que se elimina
	DELETE FROM procesos_producto WHERE idProceso_producto=idProcesoP;
	# ...
    SELECT 1 AS respuesta;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProcesosProducto` (IN `idDetalleProducto` INT, IN `area` TINYINT(1))  NO SQL
BEGIN

IF area = 1 THEN# Formato estandar 
	DELETE FROM detalle_formato_estandar WHERE idDetalle_formato_estandar=idDetalleProducto;
ELSE
 IF area = 2 THEN # teclados
 	DELETE FROM detalle_teclados WHERE idDetalle_teclados=idDetalleProducto;
 ELSE # Ensamble
 	DELETE FROM detalle_ensamble WHERE idDetalle_ensamble=idDetalleProducto;
 END IF; # <- Queda pendiente el area de almacen    
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProcesosProductoProyecto` (IN `idDetalleProducto` INT, IN `area` INT)  NO SQL
BEGIN

IF area = 1 THEN # Formato estandar

	DELETE FROM detalle_formato_estandar WHERE idDetalle_proyecto=idDetalleProducto;

ELSE

	IF area = 2 THEN # Teclados

		DELETE FROM detalle_teclados WHERE idDetalle_proyecto=idDetalleProducto;

	ELSE #Ensamble

		DELETE FROM detalle_ensamble WHERE idDetalle_proyecto=idDetalleProducto;

    END IF;

END IF;

SELECT 1 AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProductosNoConformes` (IN `numeroOrden` INT, IN `tipo` INT, IN `area` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=numeroOrden AND d.idProducto=tipo AND d.idArea=area;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_FechaServidor` ()  NO SQL
SELECT DATE_FORMAT(CURDATE(),'%d-%M-%Y')$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_GestionarMesCorteTiempoProductoProyecto` (IN `idDetalleProducto` INT, IN `tiempo_proyecto` VARCHAR(20), IN `cantidadTerminada` INT, IN `fecha_terminacion` VARCHAR(10))  NO SQL
BEGIN

	IF (EXISTS(SELECT * FROM tiempo_invertido_producto_mes t WHERE t.idDetalle_proyecto = idDetalleProducto AND DATE_FORMAT(t.mes,'%Y-%m') = DATE_FORMAT(CURDATE(),'%Y-%m'))) THEN
    
    	#Actualizar la informacion del tiempo
        UPDATE tiempo_invertido_producto_mes t SET t.tiempo_proyecto_mes=tiempo_proyecto, t.cantidad_terminada = cantidadTerminada, t.fecha_terminacion_cantidad = fecha_terminacion WHERE t.idDetalle_proyecto = idDetalleProducto AND DATE_FORMAT(t.mes,'%Y-%m') = DATE_FORMAT(CURDATE(),'%Y-%m');
    
    ELSE
    
    	#Insertar la informacion del tiempo
        INSERT INTO `tiempo_invertido_producto_mes`(`idDetalle_proyecto`, `mes`, `tiempo_proyecto_mes`, `cantidad_terminada`, `fecha_terminacion_cantidad`) VALUES (idDetalleProducto, (SELECT CURDATE()), tiempo_proyecto, cantidadTerminada, fecha_terminacion);
    
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_GestionarTiempoInvertidoProcesoMes` (IN `idProceso` INT, IN `tiempo` VARCHAR(45))  NO SQL
BEGIN

DECLARE mes varchar(10);


SET mes = (SELECT CURDATE());


IF EXISTS(SELECT * FROM tiempo_invertido_mes_proceso tmp WHERE tmp.idproceso = idProceso AND DATE_FORMAT(tmp.mes_corte,'%Y-%m') = DATE_FORMAT(CURDATE(),'%Y-%m')) THEN
#Si existe va actualizar el registro del proceso del corte de tiempo del mes correspondiente... (se resta con el mes anterior)

	#SELECT 2; # Actualizar
	UPDATE tiempo_invertido_mes_proceso tmp SET tmp.tiempo=tiempo WHERE tmp.idproceso = idProceso AND tmp.mes_corte=mes;

ELSE
# si no existe insertar el registro... (se resta con la del mes anterior) 
 	#SELECT 1; #Insertar 
    INSERT INTO `tiempo_invertido_mes_proceso`(`mes_corte`, `idproceso`, `tiempo`) VALUES (mes, idProceso, tiempo);
    
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_GestionDireccionServerSocketReporte` (IN `direccionIP` VARCHAR(16), IN `reporte` TINYINT(2), IN `estado` TINYINT(1), IN `puerto` VARCHAR(4), IN `programaP` TINYINT(2))  NO SQL
BEGIN

IF reporte > 0 THEN # servidor de reporte...

	IF EXISTS(SELECT * FROM servidor_reporte s WHERE s.ipServidor = direccionIP AND s.reporte=reporte AND s.puerto=puerto) THEN
	# Modificar

		UPDATE servidor_reporte s SET s.estado = estado WHERE s.ipServidor = direccionIP AND s.reporte=reporte AND s.puerto=puerto;

	else
	# Insertar

		INSERT INTO servidor_reporte(ipServidor, reporte, puerto) VALUES(direccionIP, reporte, puerto); 

	END IF;

ELSE # servidor del programa del facilitador...

	IF !EXISTS(SELECT * FROM servidor_reporte s WHERE s.ipServidor = direccionIP AND s.programa=programaP) THEN
		
        # eliminar antecesores
        DELETE FROM servidor_reporte WHERE programa=programaP;
        
        # Insertar
		INSERT INTO servidor_reporte(ipServidor, programa, puerto) VALUES(direccionIP, programaP, puerto); 
	
	END IF;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ImagenUsuario` (IN `ruta` VARCHAR(250), IN `doc` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.imagen=ruta WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionDeTodaElAreaDeProduccion` ()  NO SQL
BEGIN
DECLARE cantidadP int;
SET cantidadP=(SELECT COUNT(numero_orden) FROM proyecto p WHERE p.eliminacion=1);

SELECT  DATE_FORMAT(CURDATE(),'%d-%M-%Y') as fecha,COUNT(*) as cantidad,cantidadP,d.idArea FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden WHERE d.PNC=0 AND p.eliminacion=1 GROUP BY d.idArea ORDER BY d.idArea ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionFiltrariaDetalleProyecto` (IN `iddetalle` INT)  NO SQL
BEGIN

SELECT p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') as fechaIngreso,DATE_FORMAT(p.fecha_entrega,'%d-%M-%Y')AS fechaEntrega,dp.canitadad_total,dp.tiempo_total,dp.Total_timepo_Unidad,DATE_FORMAT(p.entregaCircuitoFEoGF,'%d-%M-%Y') AS fecha1,DATE_FORMAT(p.entregaCOMCircuito,'%d-%M-%Y') AS fecha2,DATE_FORMAT(p.entregaPCBFEoGF,'%d-%M-%Y') AS fecha3,DATE_FORMAT(p.entregaPCBCom,'%d-%M-%Y') AS fecha4,dp.lider_proyecto FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden WHERE dp.idDetalle_proyecto=iddetalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionProyectosProduccion` (IN `area` INT, IN `orden` INT, IN `clien` VARCHAR(40), IN `proyecto` VARCHAR(40), IN `tipo` VARCHAR(6))  NO SQL
BEGIN

IF orden=0 AND clien='' AND proyecto='' AND tipo='' THEN
  SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) and p.eliminacion=1;
ELSE
 IF orden!=0 AND clien='' AND proyecto='' AND tipo='' THEN
 	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') and p.eliminacion=1;
 ELSE
  IF orden=0 AND clien!='' AND proyecto='' AND tipo='' THEN
SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where  ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) and p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
  ELSE
   IF orden=0 AND clien='' AND proyecto!='' AND tipo='' THEN
   	  SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
   ELSE
    IF orden=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.tipo_proyecto=tipo and p.eliminacion=1;
    ELSE
     IF orden!=0 AND clien!='' AND proyecto='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
     ELSE 
      IF orden!=0 AND clien='' AND proyecto!='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
      ELSE
       IF orden!=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
       ELSE
        IF orden=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
          SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
        ELSE
         IF orden=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
         ELSE
          IF orden=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
            SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.nombre_proyecto LIKE    CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
          ELSE
           IF orden!=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
           ELSE
            IF orden=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
             SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND p.tipo_proyecto=tipo AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
            ELSE
             IF orden!=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
             ELSE
              IF orden!=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
              ELSE
               IF orden!=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.idArea=area AND (d.estado=1 or d.estado=2 OR d.estado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
CONCAT('%',clien,'%') AND p.nombre_cliente LIKE CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND                             p.eliminacion=1;
               END IF;
              END IF;
             END IF;
            END IF; 
           END IF;
          END IF; 
         END IF; 
        END IF;
       END IF;
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionQR` (IN `orden` INT)  NO SQL
BEGIN
SELECT d.idDetalle_proyecto,d.idProducto,d.idArea,DATE_FORMAT(p.fecha_entrega,'%d-%m-%Y') AS fecha_entrega,p.nombre_proyecto,d.canitadad_total,d.material,(SELECT c.color FROM color_antisolder c WHERE c.idColor_antisolder = d.antisolder) AS color_antisolder, d.ruteo, (SELECT e.nom_espesor FROM espesor e WHERE e.idEspesor = d.idEspesor) AS espesor from proyecto p JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN producto t ON d.idProducto=t.idProducto where d.proyecto_numero_orden=orden and d.PNC=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionEN` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(de.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estadoestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idProducto WHERE dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND de.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(de.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estadoestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idProducto WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND de.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionFE` (IN `orden` INT)  NO SQL
BEGIN


IF orden= 0 THEN
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(df.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idProducto WHERE dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND df.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(df.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idProducto WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND df.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionTE` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(dt.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idproducto WHERE dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND dt.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_area,tn.nombre,MAX(dt.idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.idDetalle_proyecto JOIN area n ON dp.idArea=n.idArea JOIN producto tn ON dp.idProducto=tn.idproducto WHERE dp.proyecto_numero_orden LIKE CONCAT(ordproductoen,'%') AND dp.PNC=0 AND p.estado!=3 AND p.eliminacion=1 AND dt.estado!=1 GROUP BY dp.proyecto_numero_orden, dp.idProducto;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeFinalColtime` ()  NO SQL
BEGIN

SELECT p.numero_orden AS orden,p.nombre_cliente AS cliente,dp.idDetalle_proyecto AS proyecto,dp.idProducto AS producto,p.fecha_ingreso AS ingreso,p.fecha_entrega AS entrega,dp.estado AS estadoDetalle,df.idproceso AS formatoEstandar,df.cantidad_terminada,dt.idproceso as Teclados,dt.cantidad_terminada,de.idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeGeneralColtime` ()  NO SQL
BEGIN

#SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.idArea AS negocio,DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d') AS ingreso,p.fecha_entrega AS entrega,p.estadoEmpresa AS subEstado,p.NFEE AS NFEE,dp.estado AS estadoDetalle,dp.idProducto AS tipoNegocio,df.idproceso AS formatoEstandar,df.cantidad_terminada,dt.idproceso as Teclados,dt.cantidad_terminada,de.idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto;

SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.idArea AS negocio,DATE_FORMAT(p.fecha_ingreso,'%d/%m/%Y') AS ingreso,DATE_FORMAT(p.fecha_entrega,'%d/%m/%Y') AS entrega,p.estadoEmpresa AS subEstado,DATE_FORMAT(p.NFEE,'%d/%m/%Y') AS NFEE,dp.estado AS estadoDetalle,dp.idProducto AS tipoNegocio,df.idproceso AS formatoEstandar,df.cantidad_terminada,dt.idproceso as Teclados,dt.cantidad_terminada,de.idproceso as Ensamble,de.cantidad_terminada,dp.canitadad_total FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto WHERE p.estado!=3 and dp.idArea!=4 and p.eliminacion!=0  ORDER BY p.numero_orden,df.idDetalle_formato_estandar,dt.idproceso,de.idproceso,dp.idProducto,dp.estado;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNEN` ()  NO SQL
BEGIN

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado,pp.tipo_proyecto,dp.lider_proyecto,en.cantidad_terminada,en.cantidadProceso,en.orden, pp.parada,dp.idProducto FROM detalle_ensamble en LEFT JOIN detalle_proyecto dp ON en.idDetalle_proyecto=dp.idDetalle_proyecto JOIN procesos p ON en.idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden JOIN producto t ON dp.idProducto=t.idproducto WHERE  dp.idArea=3 AND pp.estado!=3 AND dp.estado!=3 AND pp.eliminacion!=0 ORDER BY dp.proyecto_numero_orden,dp.idProducto,en.orden;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNFE` ()  NO SQL
BEGIN

#SELECT p.numero_orden,d.material,p.tipo_proyecto,tn.nombre as tipoNegocio,d.canitadad_total,df.cantidad_terminada,df.idproceso,df.estado,d.PNC FROM proyecto p RIGHT JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN detalle_formato_estandar df ON d.idDetalle_proyecto=df.idDetalle_proyecto JOIN producto tn on d.idProducto=tn.idproducto WHERE d.idArea=1 AND p.eliminacion=1 AND d.estado!=3 GROUP BY d.idDetalle_proyecto,df.idproceso ORDER BY d.proyecto_numero_orden ASC;
SELECT d.proyecto_numero_orden,d.material,p.tipo_proyecto,tn.nombre,d.canitadad_total,df.cantidad_terminada,df.cantidadProceso,df.idproceso,(SELECT pp.nombre_proceso FROM procesos pp WHERE pp.idproceso=df.idproceso) AS nombreProceso,df.estado,d.ubicacion,p.parada FROM detalle_formato_estandar df RIGHT JOIN detalle_proyecto d ON df.idDetalle_proyecto=d.idDetalle_proyecto LEFT JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden JOIN producto tn on d.idProducto=tn.idproducto where d.idArea=1 AND p.eliminacion=1 AND d.estado!=3 AND df.cantidad_terminada is not null GROUP BY d.idDetalle_proyecto,df.idproceso ORDER BY d.proyecto_numero_orden,tn.nombre,d.PNC,d.ubicacion;
# AND df.fecha_fin is null
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNTE` ()  NO SQL
BEGIN

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,t.noperarios,t.estado,pp.tipo_proyecto,t.cantidad_terminada,t.cantidadProceso,t.orden,pp.parada,dp.idProducto FROM detalle_teclados t LEFT JOIN detalle_proyecto dp ON t.idDetalle_proyecto=dp.idDetalle_proyecto LEFT JOIN procesos p ON t.idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden WHERE pp.estado!=3 AND dp.estado!=3 AND pp.eliminacion!=0 AND dp.idArea=2 ORDER BY dp.proyecto_numero_orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarRenaudarTomaDeTiempoProcesos` (IN `orden` INT, IN `idDetalleProducto` INT, IN `idLector` INT, IN `area` INT, IN `cantOperarios` INT(3))  NO SQL
BEGIN
DECLARE id int;
DECLARE id1 int;
DECLARE cantidadp int;

IF area=1 THEN

	set id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=1);

	set id1=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=2);

	IF id !='null' THEN
		#Cuando se iniciar el proceso por primera vez
		UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=cantOperarios WHERE f.idDetalle_formato_estandar=id;
	END IF;

	IF id1 !='null' THEN
		#Cuando se inicia el proceso por segunda o más veces
		UPDATE detalle_formato_estandar f SET  f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=cantOperarios WHERE f.idDetalle_formato_estandar=id1;
	END IF;

	SELECT FU_CantidadProcesosProducto(idDetalleProducto,area);

ELSE
  IF area=2 THEN
  
  	set id=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=1);

	set id1=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=2);

	IF id !='null' THEN
	#Cuando se iniciar el proceso por primera vez
		UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=cantOperarios WHERE f.idDetalle_teclados=id ;
	END IF;

	IF id1 !='null' THEN
	#Cuando se inicia el proceso por segunda o más veces
		UPDATE detalle_teclados f SET f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=cantOperarios WHERE f.idDetalle_teclados=id1 ;
	END IF;
  
  SELECT FU_CantidadProcesosProducto(idDetalleProducto,area);
  
  ELSE 
    IF area =3 THEN
    
		set id=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=1);

		set id1=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=2); 

		IF id !='null' THEN
		#Cuando se iniciar el proceso por primera vez
			UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=cantOperarios WHERE f.idDetalle_ensamble=id;
		END IF;

		IF id1 !='null' THEN
		#Cuando se inicia el proceso por segunda o más veces
			UPDATE detalle_ensamble f SET  f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=cantOperarios WHERE f.idDetalle_ensamble=id1 ;
		END IF;
  
    END IF;  
  END IF;
END IF;

			SELECT FU_CantidadProcesosProducto(idDetalleProducto,area);

            CALL PA_CambiarEstadoDeProductos(area, idDetalleProducto);# Actualizar el estado de los producto del proyecto
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarTomaTiempoDetalleAlmacen` (IN `detalle` INT)  NO SQL
BEGIN

UPDATE almacen a SET a.estado=4 WHERE a.idDetalle_proyecto=detalle;

 UPDATE detalle_proyecto dp SET pro_Pausado=0,pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ModificarDetalleFormatoEstandar` (IN `orden` INT, IN `detalle` INT, IN `material` VARCHAR(2))  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_formato_estandar d  WHERE d.idDetalle_proyecto=detalle AND d.idproceso=2) THEN   
  IF material = 'FV' then
        DELETE FROM detalle_formato_estandar  WHERE idDetalle_proyecto=detalle and idproceso=2; 
              END IF;
ELSE
    IF material='TH' then
              INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES ('00:00','00:00','0',detalle,2,1);
   END IF;
END IF;

  

IF (SELECT idProducto from detalle_proyecto WHERE proyecto_numero_orden=orden and idDetalle_proyecto=detalle
)=1  THEN


  IF (SELECT ruteoC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.idDetalle_proyecto=detalle and f.idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.idDetalle_proyecto=detalle and f.idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE idDetalle_proyecto=detalle and idproceso=9; 
      END IF;
    
  END IF;
  
 IF (SELECT antisolderC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.idDetalle_proyecto=detalle and f.idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.idDetalle_proyecto=detalle and f.idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE idDetalle_proyecto=detalle and idproceso=6; 
      END IF;
    
  END IF;


    ELSE
    

  IF (SELECT ruteoP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.idDetalle_proyecto=detalle and f.idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.idDetalle_proyecto=detalle and f.idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE idDetalle_proyecto=detalle and idproceso=9; 
      END IF;
    
  END IF;

 IF (SELECT antisolderP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.idDetalle_proyecto=detalle and f.idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.idDetalle_proyecto=detalle and f.idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE idDetalle_proyecto=detalle and idproceso=6; 
      END IF;
    
  END IF;

END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NombreUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.nombres FROM usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NumeroOperarios` (IN `detalle` INT, IN `lector` INT, IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN
SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector;
ELSE
 IF area=2 THEN
  SELECT f.noperarios FROM detalle_teclados f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector;
 ELSE
  SELECT f.noperarios FROM detalle_ensamble f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PararTomaDeTiempoAlmacen` (IN `detalle` INT, IN `proceso` INT, IN `cantidad` INT, IN `estado` INT)  NO SQL
BEGIN
DECLARE fecha varchar(11);
IF estado=3 THEN
SET fecha=(SELECT datediff(CURRENT_DATE,al.fecha_inicio) FROM almacen al WHERE al.idDetalle_proyecto=detalle AND al.idproceso=proceso);

UPDATE almacen a SET a.fecha_fin=CURRENT_DATE, a.hora_llegada=CURRENT_TIME,a.cantidad_recibida=cantidad,a.estado=3,a.tiempo_total_proceso=datediff(CURRENT_DATE,a.fecha_inicio) WHERE a.idDetalle_proyecto=detalle AND a.idproceso=proceso;

UPDATE detalle_proyecto SET pro_Terminado=1 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto  SET pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto dp SET dp.tiempo_total=fecha WHERE dp.idDetalle_proyecto=detalle; 

ELSE
 IF estado=2 THEN
  UPDATE almacen a SET a.estado=2 WHERE a.idDetalle_proyecto=detalle;
 UPDATE detalle_proyecto dp SET pro_Pausado=1,pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle; 
 
 else
UPDATE almacen a SET a.cantidad_recibida=cantidad,a.estado=4 WHERE a.idDetalle_proyecto=detalle AND a.idproceso=proceso;

UPDATE detalle_proyecto  SET pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 
 
 END IF;
END IF;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PausarTomaDeTiempoDeProcesos` (IN `num_orden` INT, IN `idDetalleProducto` INT, IN `idLector` INT, IN `area` INT, IN `tiempo` VARCHAR(10), IN `cantidadTerminada` INT, IN `cantidadAntiguaTermianda` INT, IN `res` INT(6), IN `procesoPasar` INT(6))  NO SQL
BEGIN
DECLARE idDetalleProceso int;
DECLARE idDetalleProceso2 int;
DECLARE lector int;
DECLARE ordenProcesos tinyint;
DECLARE cantidadp int;
DECLARE primero int;
DECLARE segundo int;
DECLARE restanteProcesoA int;
#se encarga de hacer la diferencia de tiempo de un dia para otro y tener el formato de hora aplicado.
#SELECT SEC_TO_TIME(TIMESTAMPDIFF(MINUTE, '2018-10-10 11:00:00','2018-10-11 12:00:00')*60)

IF area=1 THEN#La variable busqueda hace referencia al area de produccion
 
# Nueva forma de manejo de las cantidades...
SET idDetalleProceso=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=4);#ID del proceso primario
#...
SET ordenProcesos=(SELECT f.orden from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=4)+1;
#...
#Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
UPDATE detalle_formato_estandar f SET f.cantidadProceso=(CONVERT(f.cantidadProceso, int)-cantidadTerminada),f.cantidad_terminada=(f.cantidad_terminada+cantidadTerminada), f.noperarios=0, f.tiempo_total_por_proceso=tiempo WHERE f.idDetalle_formato_estandar=idDetalleProceso;
# ...
SET idDetalleProceso2=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and f.orden=ordenProcesos);#ID del proceso secundario
#...
#Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
UPDATE detalle_formato_estandar f SET f.cantidadProceso=(CONVERT(f.cantidadProceso, int)+cantidadTerminada) WHERE f.idDetalle_formato_estandar=idDetalleProceso2;
#...
SET lector = (SELECT MAX(d.idproceso) FROM detalle_formato_estandar d WHERE d.idDetalle_proyecto=idDetalleProducto);#Consultar el ID del ultimo proceso asignado para el producto...
IF (idLector = lector AND cantidadTerminada > 0) THEN #Actualizar la cantidad terminada todal del producto y la fecha en que se termino
  
   UPDATE detalle_proyecto p SET p.cantidad_terminada=(CONVERT(p.cantidad_terminada, int)+cantidadTerminada), p.fecha_terminacion_cantidad=CURDATE() WHERE p.idDetalle_proyecto=idDetalleProducto;
  
  END IF;
#...
#Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=idDetalleProducto);
  SELECT FU_ClasificarEstadoProcesos(idDetalleProceso,idDetalleProceso2,cantidadp,area);
  #...
ELSE
 IF area=2 THEN
 #... El proceso final se tiene que buscar el proceso con orden mayor para saber que ese es el proceso final.
  SET lector = (SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto, area));
  IF procesoPasar=0 AND idLector!=lector THEN# #Consultar el proceso final de la OP
  
  	SET cantidadTerminada=0;
    
  END IF;
  # ...
  IF idLector = lector THEN #Actualizar la cantidad terminada todal del producto y la fecha en que se termino
  
   UPDATE detalle_proyecto p SET p.cantidad_terminada=(CONVERT(p.cantidad_terminada, int)+cantidadTerminada), p.fecha_terminacion_cantidad=CURDATE() WHERE p.idDetalle_proyecto=idDetalleProducto;
  
  END IF;
  # ...
  SET idDetalleProceso=(SELECT t.idDetalle_teclados from detalle_teclados t JOIN detalle_proyecto d on t.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and t.idproceso=idLector and t.estado=4);#ID del proceso primario
  #Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
  UPDATE detalle_teclados t SET t.cantidadProceso=(CONVERT(t.cantidadProceso, int)-cantidadTerminada),t.cantidad_terminada=(t.cantidad_terminada+cantidadTerminada), t.noperarios=0,t.tiempo_total_por_proceso=tiempo WHERE t.idDetalle_teclados=idDetalleProceso;
  #...
  IF procesoPasar!=0 THEN#Si el proceso que se envia las cantidades es igual a 0 entonces no se van a sumar cantidades
  	SET idDetalleProceso2=(SELECT t.idDetalle_teclados from detalle_teclados t JOIN detalle_proyecto d on t.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and t.idproceso=procesoPasar);#ID del proceso secundario
  #Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
  UPDATE detalle_teclados t SET t.cantidadProceso=(CONVERT(t.cantidadProceso, int)+cantidadTerminada) WHERE t.idDetalle_teclados=idDetalleProceso2;
  ELSE
  	SET idDetalleProceso2=0;
  END IF;
  #...
  #Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(d.canitadad_total,int) FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProducto);
  SELECT FU_ClasificarEstadoProcesos(idDetalleProceso,idDetalleProceso2,cantidadp,area);
 
 ELSE
  IF area=3 THEN
  #...
  SET lector = (SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto, area));
  IF procesoPasar=0 AND idLector!= lector THEN #Consultar el proceso final de la OP
  
  	SET cantidadTerminada=0;
    
  END IF;
  # ...
  IF idLector = lector THEN #Actualizar la cantidad terminada todal del producto y la fecha en que se termino
  
   UPDATE detalle_proyecto p SET p.cantidad_terminada=(CONVERT(p.cantidad_terminada, int)+cantidadTerminada), p.fecha_terminacion_cantidad=CURDATE() WHERE p.idDetalle_proyecto=idDetalleProducto;
  
  END IF;
  #...
  SET idDetalleProceso=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=idLector and f.estado=4);#ID del proceso primario
  #Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)-cantidadTerminada),e.cantidad_terminada=(e.cantidad_terminada+cantidadTerminada), e.noperarios=0,e.tiempo_total_por_proceso=tiempo WHERE e.idDetalle_ensamble=idDetalleProceso;
  #...
  IF procesoPasar!=0 THEN#Si el proceso que se envia las cantidades es igual a 0 entonces no se van a sumar cantidades
  	SET idDetalleProceso2=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=num_orden AND d.idDetalle_proyecto=idDetalleProducto and f.idproceso=procesoPasar);#ID del proceso secundario
  #Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)+cantidadTerminada) WHERE e.idDetalle_ensamble=idDetalleProceso2;
  ELSE
  
  	SET idDetalleProceso2=0;
    
  END IF;
  #...
  #Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=idDetalleProducto);
  SELECT FU_ClasificarEstadoProcesos(idDetalleProceso,idDetalleProceso2,cantidadp,area);
  #...
  END IF; 
 END IF;
END IF;

#Cantidad de proceso en los diferentes estados de las diferentes áreas

   SELECT FU_CantidadProcesosProducto(idDetalleProducto, area);

   CALL PA_CambiarEstadoDeProductos(area,idDetalleProducto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PromedioProductoPorMinuto` (IN `idDetalleProducto` INT, IN `area` INT, IN `idLector` INT)  NO SQL
BEGIN
IF area=1 THEN

	SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_formato_estandar d WHERE d.idDetalle_proyecto=idDetalleProducto AND d.idproceso=idLector AND d.estado=3;

ELSE
 IF area=2 THEN

	SELECT t.tiempo_total_por_proceso, t.cantidad_terminada FROM detalle_teclados t WHERE t.idDetalle_proyecto = idDetalleProducto AND t.idproceso = idLector AND t.estado=3;

 ELSE
  
 	SELECT e.tiempo_total_por_proceso, e.cantidad_terminada FROM detalle_ensamble e WHERE e.idDetalle_proyecto=idDetalleProducto AND e.idproceso=idLector AND e.estado=3;
 
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ProyectosEnEjecucion` (IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN

SELECT d.proyecto_numero_orden FROM detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;


else
 IF area=2 THEN

SELECT d.proyecto_numero_orden FROM detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;

 ELSE
  IF area=3 THEN

SELECT d.proyecto_numero_orden FROM detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;

  END IF;
 END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReactivarProyecto` (IN `orden` INT)  NO SQL
BEGIN

UPDATE proyecto p SET p.eliminacion=1 WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RecuperaContraseñaUser` (IN `rec` VARCHAR(10))  NO SQL
BEGIN

IF EXISTS(SELECT u.numero_documento FROM usuario u WHERE u.recuperacion=rec) THEN

SELECT u.numero_documento,u.contraeña FROM usuario u WHERE u.recuperacion=rec;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RefrescarEstadoServerSocketReporteProduccion` (IN `direccionIP` VARCHAR(16), IN `puerto` VARCHAR(4))  NO SQL
BEGIN

	UPDATE servidor_reporte ss SET ss.estado = 1 WHERE ss.ipServidor = direccionIP AND ss.puerto = puerto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleAlmacen` (IN `orden` INT, IN `tipo` INT, IN `proceso` INT)  NO SQL
BEGIN
DECLARE detalle int;
DECLARE cantidad int;

set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=4));

INSERT INTO `almacen`(`tiempo_total_proceso`, `cantidad_recibida`, `fecha_inicio`,`idDetalle_proyecto`, `idproceso`, `estado`, `hora_registro`) VALUES ('0','0',now(),detalle,proceso,4,CURRENT_TIME);

SET cantidad= (SELECT COUNT(*) FROM almacen a WHERE  a.idDetalle_proyecto=detalle AND a.estado=4);


UPDATE detalle_proyecto d SET d.pro_Ejecucion=cantidad WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=3 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_ensamble`(`idDetalle_proyecto`, `idproceso`) VALUES (detalle,proceso);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleProyectoQR` (IN `orden` INT, IN `area` INT, IN `producto` INT, IN `cantidad` VARCHAR(25), IN `material` VARCHAR(25), IN `ruteo` INT, IN `antisolder` INT)  NO SQL
BEGIN

IF producto=1 AND area=1 THEN
UPDATE proyecto p SET p.FE=1,p.pcb_FE=1,p.antisolderC=antisolder,p.ruteoC=ruteo WHERE p.numero_orden=orden;
ELSE
 IF producto=1 AND area=3 THEN
  UPDATE proyecto p SET p.IN=1 WHERE p.numero_orden=orden;
 ELSE
  IF producto=5 THEN
    UPDATE proyecto p SET p.TE=1 WHERE p.numero_orden=orden;
  ELSE
   IF producto=2 THEN
   	   UPDATE proyecto p SET p.TE=1,p.FE=1,p.Conversor=1 WHERE p.numero_orden=orden;
   ELSE 
    IF producto=3 THEN
         UPDATE proyecto p SET p.TE=1,p.FE=1,p.Repujado=1 WHERE p.numero_orden=orden;
    ELSE
     IF producto=4 THEN
           UPDATE proyecto p SET p.TE=1,p.FE=1,p.troquel=1 WHERE p.numero_orden=orden;
     ELSE
      IF producto=6 THEN
              UPDATE proyecto p SET p.FE=1,p.IN=1,p.stencil=1 WHERE p.numero_orden=orden;
       ELSE
        IF producto=7 THEN
                 UPDATE proyecto p SET p.FE=1,p.TE=1,p.pcb_TE=1,p.antisolderP=antisolder,p.ruteoP=ruteo WHERE p.numero_orden=orden;
        END IF;
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
 END IF;
END IF;
IF material != '' THEN
INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`material`,`PNC`) VALUES (producto,cantidad,orden,area,1,material,0);
SELECT 1;
ELSE
INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`PNC`) VALUES (producto,cantidad,orden,area,1,0);
SELECT 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=2 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_teclados`(`idDetalle_proyecto`, `idproceso`)VALUES
(detalle,proceso);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarModificarCondicionProducto` (IN `idCondicion` INT, IN `producto` TINYINT, IN `area` TINYINT, IN `material` VARCHAR(2), IN `antisolder` TINYINT(1), IN `ruteo` TINYINT(1))  NO SQL
BEGIN

IF EXISTS(SELECT * FROM condicion_producto cp WHERE cp.idCondicion=idCondicion) THEN# Actualizar
 
	UPDATE condicion_producto p SET p.idProducto=producto,p.area=area,p.material=material,p.antisorder=antisolder,p.ruteo=ruteo WHERE p.idCondicion=idCondicion;	

ELSE# Registrar

	INSERT INTO `condicion_producto`(`idProducto`, `area`, `material`, `antisorder`, `ruteo`) VALUES (producto,area,material,antisolder,ruteo);

END IF;

SELECT 1 AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarModificarPuertoSerialUsuario` (IN `documento` VARCHAR(13), IN `com` VARCHAR(6))  NO SQL
BEGIN

IF (EXISTS(SELECT * FROM usuariopuerto up WHERE up.documentousario=documento)) THEN
#Modificar

UPDATE usuariopuerto up SET up.usuarioPuerto=com WHERE up.documentousario=documento;

ELSE
#registrar

INSERT INTO usuariopuerto VALUES (documento,com);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_registrarModificarSeleccionProcesos` (IN `idProceso` INT, IN `idCondicion` INT, IN `orden` INT, IN `idProceso_producto` INT)  NO SQL
BEGIN

IF idProceso_producto>0 THEN
#Actualizar información 
UPDATE procesos_producto p SET p.orden=orden, p.idProceso=idProceso WHERE p.idProceso_producto=idProceso_producto;

ELSE
#Registrar información
INSERT INTO procesos_producto(idCondicion,orden,idProceso) VALUES(idCondicion,orden,idProceso);	

END IF;

SELECT 1 AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarProcesosProductos` (IN `idProceso` INT, IN `idDetalleProyecto` INT, IN `ordenEjecucion` TINYINT, IN `area` TINYINT(1), IN `procesoFinal` TINYINT)  NO SQL
BEGIN
#
IF area = 1 THEN # Formato estandar

	IF ordenEjecucion=1 THEN
	# ...
		INSERT INTO `detalle_formato_estandar`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`) VALUES (idDetalleProyecto, idProceso,ordenEjecucion, (SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProyecto));
	# ...
	ELSE
	# ...
		INSERT INTO `detalle_formato_estandar`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`) VALUES (idDetalleProyecto, idProceso, ordenEjecucion, 0);
	# ...
END IF;

ELSE

	IF area = 2 THEN # Teclados
    
    	INSERT INTO `detalle_teclados`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`,`proceso_final`) VALUES (idDetalleProyecto, idProceso, ordenEjecucion, 0, procesoFinal);
    
    ELSE # Ensamble
    
    	INSERT INTO `detalle_ensamble`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`,`proceso_final`) VALUES (idDetalleProyecto, idProceso, ordenEjecucion, 0, procesoFinal);
    
    END IF;

END IF;

#
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReiniciarTiempo` (IN `idDetalleProceso` INT, IN `area` INT)  NO SQL
BEGIN
DECLARE cantidadp int;
DECLARE idDetalleProducto int;
DECLARE respuesta int;


IF area=1 THEN # Formato Estandar - FE

	UPDATE detalle_formato_estandar f SET f.tiempo_por_unidad= "00:00:00", f.tiempo_total_por_proceso="00:00:00", f.cantidad_terminada=0, f.fecha_inicio=null, f.fecha_fin=null, f.estado=1, f.hora_ejecucion=null,f.hora_terminacion=null WHERE f.idDetalle_formato_estandar=idDetalleProceso;

	SET idDetalleProducto =(SELECT d.idDetalle_proyecto FROM detalle_formato_estandar d WHERE d.idDetalle_formato_estandar=idDetalleProceso);

	SET respuesta = (SELECT FU_CantidadProcesosProducto(idDetalleProducto, area));

	CALL PA_CambiarEstadoDeProductos(area, idDetalleProducto);

ELSE
 IF area=2 THEN # Teclados - TE
 	UPDATE detalle_teclados t SET t.tiempo_por_unidad= "00:00:00",t.tiempo_total_proceso="00:00:00",t.cantidad_terminada=0,t.fecha_inicio=null,t.fecha_fin=null,t.estado=1,t.hora_ejecucion=null,t.hora_terminacion=null WHERE t.idDetalle_teclados=idDetalleProceso;
 
	SET idDetalleProducto =(SELECT d.idDetalle_proyecto FROM detalle_teclados d WHERE d.idDetalle_teclados=idDetalleProceso);

	SET respuesta = (SELECT FU_CantidadProcesosProducto(idDetalleProducto, area));

	CALL PA_CambiarEstadoDeProductos(area, idDetalleProducto);

 ELSE #Ensamble - EN
  UPDATE detalle_ensamble e SET e.tiempo_por_unidad= "00:00:00",e.tiempo_total_por_proceso="00:00:00",e.cantidad_terminada=0,e.fecha_inicio=null,e.fecha_fin=null,e.estado=1,e.hora_ejecucion=null,e.hora_terminacion=null WHERE `idDetalle_ensamble`=idDetalleProceso;
  
	SET idDetalleProducto =(SELECT d.idDetalle_proyecto FROM detalle_ensamble d WHERE d.idDetalle_ensamble=idDetalleProceso);

	SET respuesta = (SELECT FU_CantidadProcesosProducto(idDetalleProducto, area));

	CALL PA_CambiarEstadoDeProductos(area, idDetalleProducto);

 END IF;
END IF;

SELECT respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteCorteTiemposProcesosMes` (IN `fecha_entrega` VARCHAR(7))  NO SQL
BEGIN

SELECT p.nombre_proceso,p.idArea,ROUND((TIME_TO_SEC(t.tiempo)/60),0) AS tiempo_proceso,t.tiempo FROM procesos p LEFT JOIN tiempo_invertido_mes_proceso t ON p.idproceso=t.idproceso WHERE DATE_FORMAT(t.mes_corte,'%Y-%m') = fecha_entrega;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteGeneral` ()  NO SQL
BEGIN

SELECT p.numero_orden,p.nombre_cliente,p.nombre_proyecto,dp.canitadad_total,n.nom_area,t.nombre,dp.Total_timepo_Unidad,dp.tiempo_total FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden JOIN area n on dp.idArea=n.idArea JOIN producto t ON dp.idProducto=t.idproducto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteTiemposAreaProduccion` (IN `area` INT, IN `fechaI` VARCHAR(10), IN `fechaF` VARCHAR(10))  NO SQL
BEGIN

IF area=1 THEN#Formato Estandar
SELECT p.numero_orden,pd.nombre AS producto, df.idproceso,pro.nombre_proceso,df.tiempo_total_por_proceso,dp.tiempo_total,dp.Total_timepo_Unidad,dp.estado,dp.canitadad_total, df.cantidadProceso,dp.fecha_salida  FROM proyecto p LEFT JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.idDetalle_proyecto LEFT JOIN procesos pro ON df.idproceso=pro.idproceso JOIN producto pd ON dp.idProducto=pd.idproducto WHERE dp.idArea=1 AND p.eliminacion=1 AND (DATE_FORMAT(p.fecha_ingreso, '%Y-%m-%d') between fechaI AND fechaF) AND df.idproceso is not null ORDER BY p.numero_orden,dp.idProducto;
ELSE
 IF area=2 THEN#Teclados
 SELECT p.numero_orden, de.idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.Total_timepo_Unidad,dp.canitadad_total,dp.tiempo_total,dp.estado,dp.canitadad_total,de.cantidadProceso,dp.fecha_salida FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados de ON dp.idDetalle_proyecto=de.idDetalle_proyecto join procesos pro ON de.idproceso=pro.idproceso WHERE dp.idArea=2 AND p.eliminacion=1 AND dp.estado=3 AND (DATE_FORMAT(p.fecha_ingreso, '%Y-%m-%d') between fechaI AND fechaF) ORDER BY p.numero_orden;
 ELSE
  IF area=3 THEN#Ensamble
   SELECT p.numero_orden, de.idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.Total_timepo_Unidad,dp.estado,dp.canitadad_total, de.cantidadProceso,dp.fecha_salida  FROM proyecto p LEFT JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto LEFT JOIN procesos pro ON de.idproceso=pro.idproceso WHERE dp.idArea=3 AND p.eliminacion=1 AND (DATE_FORMAT(p.fecha_ingreso, '%Y-%m-%d') between fechaI AND fechaF) ORDER BY p.numero_orden;
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteTiemposProduccionProductos` (IN `fecha_corte` VARCHAR(7))  NO SQL
BEGIN

SELECT d.proyecto_numero_orden,d.canitadad_total,p.nombre,d.idArea,d.estado,ROUND((TIME_TO_SEC(t.tiempo_proyecto_mes)/60),0) AS tiempo,t.tiempo_proyecto_mes,t.cantidad_terminada,t.fecha_terminacion_cantidad FROM detalle_proyecto d JOIN tiempo_invertido_producto_mes t ON d.idDetalle_proyecto=t.idDetalle_proyecto JOIN producto p ON d.idProducto=p.idproducto WHERE DATE_FORMAT(t.mes,'%Y-%m') = fecha_corte;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RestarTiempos` (IN `tiempo1` VARCHAR(10), IN `tiempo2` VARCHAR(10))  NO SQL
BEGIN

	SELECT SUBTIME(tiempo1,tiempo2) AS total_tiempo;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_selccionarPrimerProcesoProyectosENoTE` (IN `detalle` INT, IN `idproceso` INT, IN `area` TINYINT)  NO SQL
BEGIN

IF area=3 THEN #Ensamble
	#Reiniciar el orden de todos los procesos que tiene el detalle 
	UPDATE detalle_ensamble e SET e.orden=0,e.cantidadProceso=0 WHERE e.idDetalle_proyecto=detalle;

	#Seleccionar el primer proceso
	UPDATE detalle_ensamble e SET e.orden=1,e.cantidadProceso=(SELECT p.canitadad_total FROM detalle_proyecto p WHERE p.idDetalle_proyecto=detalle LIMIT 1) WHERE e.idDetalle_ensamble=idproceso;
ELSE# Teclados
	#Reiniciar el orden de todos los procesos que tiene el detalle
	UPDATE detalle_teclados t SET t.orden=0,t.cantidadProceso=0 WHERE t.idDetalle_proyecto=detalle;

	#Seleccionar el primer proceso
	UPDATE detalle_teclados t SET t.orden=1,t.cantidadProceso=(SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle LIMIT 1) WHERE t.idDetalle_teclados =idproceso;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Sesion` (IN `sec` INT, IN `ced` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.sesion=sec WHERE u.numero_documento=ced;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_SumarTiempos` (IN `tiempo1` VARCHAR(10), IN `tiempo2` VARCHAR(10))  NO SQL
BEGIN

SELECT ADDTIME(tiempo1, tiempo2) AS total_tiempo;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TiempoEjecucionProceso` (IN `idDetalleProducto` INT, IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN# Formato estandar - FE
	SELECT df.tiempo_total_por_proceso FROM detalle_formato_estandar df WHERE df.idDetalle_proyecto=idDetalleProducto AND df.estado!=1;
ELSE
 IF area=2 THEN# Teclados - TE
    SELECT dt.tiempo_total_por_proceso FROM detalle_teclados dt WHERE dt.idDetalle_proyecto=idDetalleProducto AND dt.estado!=1;
 ELSE# Ensamble - EN
    SELECT de.tiempo_total_por_proceso FROM detalle_ensamble de WHERE de.idDetalle_proyecto=idDetalleProducto AND de.estado!=1;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TodosLosDetallesEnEjecucion` (IN `orden` INT)  NO SQL
BEGIN
SELECT dp.idDetalle_proyecto,dp.idArea FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadPNCOrigen` (IN `orden` INT, IN `detalle` INT, IN `op` INT, IN `tipo` INT, IN `area` INT)  NO SQL
BEGIN

IF op=1 THEN


 SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.idDetalle_proyecto=detalle;

else

SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.PNC=0 and d.idArea=area AND d.idProducto=tipo;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarDetalleProyectoQR` (IN `orden` INT, IN `area` INT, IN `producto` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.idArea=area AND dp.idProducto=producto) THEN
SELECT 0;
ELSE
SELECT 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_validarExistenciaOtraMismaCondicionProducto` (IN `idCondicion` INT, IN `producto` TINYINT(4), IN `area` TINYINT(1), IN `material` VARCHAR(3), IN `antisolder` TINYINT(1), IN `ruteo` TINYINT(1))  NO SQL
BEGIN

SELECT EXISTS(SELECT * FROM condicion_producto cp WHERE cp.idProducto=producto AND cp.area=area AND cp.material=material AND cp.antisorder=antisolder AND cp.ruteo=ruteo AND cp.idCondicion!=idCondicion) AS respuesta;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_validarPNC` (IN `orden` INT, IN `proceso` VARCHAR(30))  NO SQL
BEGIN

SELECT p.idDetalle_proyecto FROM detalle_proyecto p WHERE p.ubicacion=proceso and p.proyecto_numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarProyectoQR` (IN `orden` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden) THEN
SELECT 0;
ELSE
SELECT 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarUbicacionPNC` (IN `orden` INT, IN `ubicacion` VARCHAR(50), IN `detalle` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.PNC=1 and d.ubicacion=ubicacion AND d.idDetalle_proyecto=detalle) THEN
SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.PNC=1 and d.ubicacion=ubicacion AND d.idDetalle_proyecto=detalle;

ELSE

SELECT 0;

END IF;

END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ActualizarEstado` (`doc` VARCHAR(13), `est` BOOLEAN) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE val varchar(13);
set val= (SELECT numero_documento from usuario where numero_documento=doc);

IF val=doc THEN
UPDATE usuario SET estado=est WHERE numero_documento=doc;
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ActualizarEstadoLecturaPuertoSerialFacilitadorOperarios` (`estado` TINYINT(1), `doc` VARCHAR(13)) RETURNS TINYINT(1) NO SQL
BEGIN
#solo se podra modificar la informacion de un solo usuario facilitador de cada área.
UPDATE usuariopuerto u SET u.estadoLectura=estado WHERE u.documentousario=doc;

return 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ActualizarLiderProyectoEnsamble` (`detalle` INT, `doc` VARCHAR(13)) RETURNS INT(1) NO SQL
BEGIN

#Numero de documento de identidad de la persona encargada de un procto de un proyeto.
UPDATE detalle_proyecto d SET d.lider_proyecto=doc WHERE d.idDetalle_proyecto=detalle;

return 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CambiarContraseña` (`doc` VARCHAR(13), `contra` VARCHAR(20), `anti` VARCHAR(20)) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE var varchar(20);
set var=(SELECT u.contraeña FROM usuario u WHERE u.numero_documento = doc);
IF var=anti THEN
UPDATE usuario u SET u.contraeña=contra WHERE u.numero_documento=doc;
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CambiarEstadoProcesos` (`idProceso` INT) RETURNS TINYINT(1) NO SQL
BEGIN
# Agregar validación, Para modifiacr el estado de un proceso a desactivado se necesita que el procesos no este seleccionado para ningun producto.
IF EXISTS(SELECT * FROM procesos p WHERE p.idproceso=idProceso AND p.estado=1) THEN # Activo
#Desactivar
	UPDATE procesos p SET p.estado=0 WHERE p.idproceso=idProceso;
ELSE
#Activar
	UPDATE procesos p SET p.estado=1 WHERE p.idproceso=idProceso;
END IF;

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CantidadProcesosProducto` (`idDetalleProducto` INT, `area` INT) RETURNS INT(11) NO SQL
BEGIN

DECLARE cantidadp int;

IF area = 1 THEN # Formato estandar

	SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);

	UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

	SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

	UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

	SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

	UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

	SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

	UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

ELSE

	IF area = 2 THEN # Teclados
    
    	SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);
	
		UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

		UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

		UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

		UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;
    
    ELSE # Ensamble
    
    	SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);

		UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

		UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

		UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

		SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

		UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;
    
    END IF;

END IF;

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ClasificarCondicionProducto` (`orden` VARCHAR(10), `idProducto` INT, `ubic` VARCHAR(25), `material` VARCHAR(2), `area` INT, `idColor_antisolder` VARCHAR(2), `ruteo` TINYINT) RETURNS INT(11) NO SQL
BEGIN

DECLARE lleva_antisolder int;

IF idColor_antisolder="0" THEN
#No lleva antisolder
	SET lleva_antisolder = 0;

ELSE
#Si lleva antisolder
	SET lleva_antisolder = 1;

END IF;

# ...
IF (idProducto=1 or idProducto=7) AND area = 1 THEN # Circuito o PCB
	# ...
    RETURN (SELECT c.idCondicion FROM condicion_producto c WHERE c.idProducto=idProducto AND c.material=material AND c.antisorder=lleva_antisolder AND c.ruteo=ruteo AND c.area=area LIMIT 1);
    # ...
ELSE
#...
RETURN (SELECT c.idCondicion FROM condicion_producto c WHERE c.idProducto=idProducto AND c.area=area LIMIT 1);
#...
END IF;
#...

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ClasificarEstadoProcesos` (`proceso1` INT, `proceso2` INT, `cant` INT, `area` TINYINT(1)) RETURNS TINYINT(1) NO SQL
BEGIN

IF area=1 THEN #Formato estandar - FE
# ...
	#Clasificar el estado del proceso 1 (pausado=2 o terminado=3)
	IF EXISTS(SELECT * FROM detalle_formato_estandar f WHERE f.idDetalle_formato_estandar=proceso1 AND CONVERT(f.cantidad_terminada,int)>=cant AND CONVERT(f.cantidadProceso,int)=0 AND f.estado=4) THEN
    # ...
 		UPDATE detalle_formato_estandar f SET f.estado=3, f.fecha_fin=now(), f.mes_de_corte=CURDATE() WHERE f.idDetalle_formato_estandar=proceso1;#Estado Terminado
 	# ...
	ELSE	    
 		UPDATE detalle_formato_estandar f SET f.estado=2, f.fecha_fin=null WHERE f.idDetalle_formato_estandar=proceso1;#Estado Pausado
 	# ...
	END IF;
# ...
ELSE 
   IF area=2 THEN# Teclados
    # ...
	#Clasificar el estado del proceso 1 (pausado=2 o terminado=3)
	IF EXISTS(SELECT * FROM detalle_teclados t WHERE t.idDetalle_teclados=proceso1 AND CONVERT(t.cantidad_terminada,int)>=cant AND CONVERT(t.cantidadProceso,int)=0 AND t.estado=4) THEN
    # ...
 		UPDATE detalle_teclados t SET t.estado=3, t.fecha_fin=now(), t.mes_de_corte=CURDATE() WHERE t.idDetalle_teclados=proceso1;#Estado Terminado
 	# ...
	ELSE	    
 		UPDATE detalle_teclados t SET t.estado=2, t.fecha_fin=null WHERE t.idDetalle_teclados=proceso1;#Estado Pausado
 	# ...
	END IF;
	#...
	#Clasificar el estado del proceso 2 (pausado=2 o terminado=3)
	IF EXISTS(SELECT * FROM detalle_teclados t WHERE t.idDetalle_teclados=proceso2 AND CONVERT(t.cantidad_terminada,int)>=cant AND CONVERT(t.cantidadProceso,int)=0 AND t.estado!=4) THEN
    # ....
 		UPDATE detalle_teclados t SET t.estado=3, t.fecha_fin=now(), t.mes_de_corte=CURDATE() WHERE t.idDetalle_teclados=proceso2;#Estado Terminado
    #...    
	ELSE
 		IF EXISTS(SELECT * FROM detalle_teclados t WHERE t.idDetalle_teclados=proceso2 AND t.estado!=4 AND t.estado!=1) THEN
       	# ...
			UPDATE detalle_teclados t SET t.estado=2, t.fecha_fin=null WHERE t.idDetalle_teclados=proceso2;#Estado Pausado
        # ...    
 		END IF; 
	END IF;
    # ...
   ELSE# Ensamble
    # ...
	 #Clasificar el estado del proceso 1 (pausado=2 o terminado=3)
	 IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso1 AND CONVERT(e.cantidad_terminada,int)>=cant AND CONVERT(e.cantidadProceso,int)=0 AND e.estado=4) THEN
     # ...
 		UPDATE detalle_ensamble e SET e.estado=3, e.fecha_fin=now(), e.mes_de_corte=CURDATE() WHERE e.idDetalle_ensamble=proceso1;#Estado Terminado
 	 # ...
	 ELSE	    
 		UPDATE detalle_ensamble e SET e.estado=2, e.fecha_fin=null WHERE e.idDetalle_ensamble=proceso1;#Estado Pausado
 	 # ...
	 END IF;
     #...
	 #Clasificar el estado del proceso 2 (pausado=2 o terminado=3)
	 IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso2 AND CONVERT(e.cantidad_terminada,int)>=cant AND CONVERT(e.cantidadProceso,int)=0 AND e.estado!=4) THEN
     # ...
 	   	UPDATE detalle_ensamble e SET e.estado=3, e.fecha_fin=now(), e.mes_de_corte=CURDATE() WHERE e.idDetalle_ensamble=proceso2;#Estado Terminado
     #...    
	 ELSE
 		 IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso2 AND e.estado!=4 AND e.estado!=1) THEN
       	 # ...
		 	UPDATE detalle_ensamble e SET e.estado=2, e.fecha_fin=null WHERE e.idDetalle_ensamble=proceso2;#Estado Pausado
         # ...    
 		 END IF; 
	 END IF;
   # ... 
   END IF;
# ...
END IF;
#...
return 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarelIDDetalledelproductoArea` (`numOrden` VARCHAR(10), `idProducto` TINYINT, `productoPNC` VARCHAR(25), `area` TINYINT(1)) RETURNS INT(11) NO SQL
BEGIN

DECLARE idDetalleProducto int;

IF productoPNC='' THEN
  set idDetalleProducto=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(numOrden) AND dd.idProducto=idProducto AND dd.idArea=area AND dd.ubicacion is null));
ELSE
  set idDetalleProducto=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(numOrden) AND dd.idProducto=idProducto AND dd.idArea=area AND dd.ubicacion=productoPNC));
END IF;

RETURN idDetalleProducto;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarEstadoDetalleProyecto` (`detalle` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto e WHERE e.idDetalle_proyecto=detalle AND e.estado=1) THEN
	return 1;
ELSE
	return 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarIDDetalleProductosFE` (`numOrden` VARCHAR(10), `idProducto` TINYINT, `PNC` VARCHAR(25)) RETURNS INT(11) NO SQL
BEGIN
# ...
 IF PNC='' THEN
    RETURN (SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=numOrden AND d.idProducto=idProducto AND d.ubicacion IS null);
 ELSE
	RETURN (SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=numOrden AND d.idProducto=idProducto AND d.ubicacion=PNC);
 END IF;
# ...
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarProcesoFinalSeleccionado` (`idDetalleProducto` INT, `area` TINYINT(1)) RETURNS INT(11) NO SQL
BEGIN
#Esto no aplica para formato estandar - FE
DECLARE proceso int;

IF area = 2 THEN # Teclados
	SET proceso = (SELECT t.idproceso FROM detalle_teclados t WHERE t.idDetalle_proyecto = idDetalleProducto AND t.proceso_final = 1);
ELSE # Ensamble
	SET proceso = (SELECT e.idproceso FROM detalle_ensamble e WHERE e.idDetalle_proyecto = idDetalleProducto AND e.proceso_final = 1);
END IF;

RETURN proceso;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarPuertoComunicacionServidorSocket` (`direccionIP` VARCHAR(16), `area` TINYINT(1), `programa` TINYINT(1)) RETURNS VARCHAR(4) CHARSET latin1 NO SQL
BEGIN

IF area > 0 THEN # Puerto del servidor de los reportes

	RETURN (SELECT s.puerto FROM servidor_reporte s WHERE s.ipServidor=direccionIP AND s.reporte=area AND estado=0 LIMIT 1);

ELSE # Puerto del servidor del programa

	RETURN (SELECT s.puerto FROM servidor_reporte s WHERE s.ipServidor=direccionIP AND s.programa=programa LIMIT 1);

END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarUltimoProceso` (`idDetalleProducto` INT, `area` INT) RETURNS INT(11) NO SQL
BEGIN
DECLARE orden tinyint(2);

IF area = 1 THEN # Formato estandar - FE

	SET orden = (SELECT MAX(f.orden) FROM detalle_formato_estandar f WHERE f.idDetalle_proyecto);

ELSE	

	IF area = 2 THEN # Teclados - TE
    
    	SET orden = (SELECT MAX(t.orden) FROM detalle_proyecto t WHERE t.idDetalle_proyecto);
    
    ELSE # Ensamble - EN
    
    	SET orden = (SELECT MAX(e.orden) FROM detalle_ensamble e WHERE e.idDetalle_proyecto);
    
    END IF;

END IF;

RETURN orden;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoAlmacen` (`iddetalle` INT, `orden` INT) RETURNS INT(11) NO SQL
BEGIN

DELETE FROM almacen WHERE idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
 
CALL PA_CambiarEstadoDeProyecto(orden);

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EstadoDeProyecto` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden
         AND p.estado!=4) THEN
         RETURN 1;

ELSE
	RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_GestionarRutaQRs` (`documento` VARCHAR(13), `path` VARCHAR(150)) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM usuariopuerto u WHERE u.documentousario=documento) THEN
#Modificar registro
UPDATE usuariopuerto u SET u.rutaQRs=path WHERE u.documentousario=documento;
RETURN 1;
ELSE
#Registrar
INSERT INTO usuariopuerto(documentousario,rutaQRs) VALUES(documento,path);
RETURN 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_IniciarSesion` (`usuario` VARCHAR(13), `pasw` VARCHAR(20)) RETURNS TINYINT(2) NO SQL
BEGIN
DECLARE val varchar(13);
DECLARE car int;
SET val=(SELECT u.numero_documento from usuario u WHERE u.numero_documento=usuario AND u.contraeña= pasw AND estado=1);
if val!='' THEN
set car=(SELECT cargo_idcargo FROM usuario WHERE numero_documento = usuario);
  RETURN car;
ELSE
  RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_InsertarModificarUsuar` (`_doc` VARCHAR(13), `_tipo` VARCHAR(3), `_nombre` VARCHAR(30), `_apellido` VARCHAR(30), `_cargo` TINYINT, `_estado` TINYINT, `op` TINYINT, `rec` VARCHAR(10)) RETURNS TINYINT(1) READS SQL DATA
BEGIN
 DECLARE val varchar(13);
if op=1 THEN
SET val=(SELECT numero_documento FROM usuario WHERE    numero_documento=_doc);
  IF val=_doc THEN
     RETURN 0;
 ELSE 
     INSERT INTO        usuario(numero_documento,tipo_documento,nombres,apellidos,cargo_idcargo,estado,contraeña,recuperacion)   VALUES (_doc,_tipo,_nombre,_apellido,_cargo,_estado,_doc,rec);
  return 1;
  
END IF;
ELSE
UPDATE usuario SET tipo_documento=_tipo,nombres=_nombre, apellidos=_apellido, cargo_idcargo=_cargo,estado=_estado where  numero_documento=_doc;
RETURN 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ModificarInfoDetalleProyecto` (`idDetalleProducto` INT, `cantidad` VARCHAR(6), `material` VARCHAR(6), `area` INT, `ubicacion` VARCHAR(25), `idColor_antisolder` VARCHAR(2), `ruteo` TINYINT(1), `idProducto` INT, `idEspesor` TINYINT) RETURNS TINYINT(1) NO SQL
BEGIN

# ...
IF !EXISTS(SELECT * FROM detalle_proyecto d WHERE d.idDetalle_proyecto = idDetalleProducto AND d.idProducto = idProducto AND d.material = material AND d.idArea = area AND d.antisolder = idColor_antisolder AND d.ruteo = ruteo AND d.idEspesor = idEspesor AND d.canitadad_total = cantidad) THEN

UPDATE detalle_proyecto dp SET dp.material = material, dp.ubicacion = ubicacion, dp.antisolder = idColor_antisolder, dp.ruteo = ruteo, dp.idEspesor = idEspesor WHERE dp.idDetalle_proyecto = idDetalleProducto;

	#Seimpre se van actualizar las cantidades del producto...
	UPDATE detalle_proyecto dp SET dp.canitadad_total = cantidad WHERE dp.idDetalle_proyecto = idDetalleProducto;
    
    IF area = 1 THEN # Esto unicamente se va hacer con Formato Estandar - FE
    
    	UPDATE detalle_formato_estandar f SET f.cantidadProceso = cantidad WHERE f.idDetalle_proyecto = idDetalleProducto AND f.orden = 1; # Actualizar la cantidad del proceso...
    
    END IF;
  # ...
  RETURN 1;# Se actualizo la informacion
  # ...
ELSE

	#Seimpre se van actualizar las cantidades del producto...
	UPDATE detalle_proyecto dp SET dp.canitadad_total = cantidad WHERE dp.idDetalle_proyecto = idDetalleProducto;

	#No es necesario modificar el detalle...
   RETURN 0;

END IF;

# ...
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarDetalleProyecto` (`orden` INT(11), `idProductoP` VARCHAR(20), `cantidad` VARCHAR(6), `area` VARCHAR(20), `estado` TINYINT(1), `material` VARCHAR(6), `pnc` TINYINT(1), `ubic` VARCHAR(30), `idColor_antisolder` VARCHAR(2), `ruteo` TINYINT, `idEspesor` TINYINT) RETURNS TINYINT(1) NO SQL
BEGIN
IF material != '' THEN#Esto se puede reducir a un solo

	INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`material`,`PNC`,`ubicacion`,`antisolder`,`ruteo`, `idEspesor`) VALUES ((SELECT idproducto from producto where nombre =idProductoP), cantidad, orden, (SELECT idArea FROM area WHERE nom_area = area), estado, material, pnc, ubic, idColor_antisolder, ruteo, idEspesor);
 	RETURN 1;
#
ELSE

	INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`PNC`,`ubicacion`,`antisolder`,`ruteo`, `idEspesor`) VALUES ((SELECT idproducto from producto where nombre =idProductoP),cantidad,orden, (SELECT idArea FROM area WHERE nom_area = area), estado, pnc, ubic, idColor_antisolder, ruteo, idEspesor);
	RETURN 1;
    
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProcesos` (`idProceso` INT, `nombre` VARCHAR(30), `area` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF idProceso=0 THEN
INSERT INTO `procesos`(`nombre_proceso`, `estado`, `idArea`) VALUES (nombre,1,area);
RETURN 1;
else
UPDATE procesos p SET p.nombre_proceso=nombre,p.idArea=area WHERE p.idproceso=idProceso;
RETURN 1;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProyecto` (`norden` VARCHAR(11), `doc` VARCHAR(13), `cliente` VARCHAR(150), `proyecto` VARCHAR(150), `tipo` VARCHAR(6), `entrega` VARCHAR(11), `accion` TINYINT(1), `fecha1` VARCHAR(11), `fecha2` VARCHAR(11), `fecha3` VARCHAR(11), `fecha4` VARCHAR(11), `novedad` VARCHAR(250), `estadopro` VARCHAR(13), `nfee` VARCHAR(11)) RETURNS TINYINT(11) NO SQL
BEGIN

IF accion = 1 THEN # Registrar

	INSERT INTO `proyecto`(`numero_orden`,`usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `fecha_ingreso`, `fecha_entrega`, `estado`,`entregaCircuitoFEoGF`,`entregaCOMCircuito`,`entregaPCBFEoGF`,`entregaPCBCom`) VALUES (norden, doc, cliente, proyecto, tipo, (SELECT now()), entrega,1, fecha1, fecha2, fecha3, fecha4); 

ELSE # Modificar
	 UPDATE `proyecto` SET `nombre_cliente`=cliente, `nombre_proyecto`=proyecto, `tipo_proyecto`=tipo, `fecha_entrega`=entrega, `entregaCircuitoFEoGF`=fecha1, `entregaCOMCircuito`=fecha2, `entregaPCBFEoGF`=fecha3, `entregaPCBCom`=fecha4, `novedades`=novedad, `estadoEmpresa`=estadopro, `NFEE`=nfee WHERE numero_orden=norden;

END IF;

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_validarActividad` (`doc` VARCHAR(13)) RETURNS INT(11) NO SQL
BEGIN

IF EXISTS(SELECT u.numero_documento from usuario u WHERE u.numero_documento=doc and u.sesion=1) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarCantidadProcesoAreasProduccion` (`idDetalleProyecto` INT, `lector` TINYINT, `area` TINYINT) RETURNS INT(11) NO SQL
BEGIN
#Consulta las cantidades que tiene el proceso de ensamble para validar si tiene equipos a los cuales les puede trabajar.

IF area=1 THEN #Formato Estandar - FE

	RETURN (SELECT f.cantidadProceso FROM detalle_formato_estandar f WHERE f.idDetalle_proyecto=idDetalleProyecto AND f.idproceso=lector);
    
ELSE
  IF area=2 THEN # Teclados - TE
  
    RETURN (SELECT t.cantidadProceso FROM detalle_teclados t WHERE t.idDetalle_proyecto=idDetalleProyecto AND t.idproceso=lector);
    
  ELSE #Ensamble - EN cuando área es 3
  
    RETURN (SELECT e.cantidadProceso FROM detalle_ensamble e WHERE e.idDetalle_proyecto=idDetalleProyecto AND e.idproceso=lector);
    
  END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_validarEliminacion` (`iddetalle` INT, `orden` INT, `tipo` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;

IF busqueda=1 THEN
  SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);   
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
 ELSE
 IF busqueda=2 THEN
 SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
  ELSE
  IF busqueda=3 THEN
    SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
    END IF;
 END if;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarEstadoEliminado` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden AND p.eliminacion=1) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarEstadoProyectoEjecucionOParada` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto p WHERE p.numero_orden=orden AND p.parada=1) THEN
RETURN 1;
ELSE
return 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarExistenciaProcesoSeleccionado` (`idProceso` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE respuesta int;

	SET respuesta = EXISTS(SELECT * FROM procesos_producto p WHERE p.idProceso=idProceso);
    
	RETURN respuesta;
    
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarNumerOrden` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto d WHERE d.numero_orden=orden) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarTomaDeTiempo` (`orden` INT, `detalle` INT, `lector` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN

DECLARE id int;

IF busqueda=1 THEN
SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
ELSE
  IF busqueda=2 THEN
SET id=(SELECT f.idDetalle_teclados from 
detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
  ELSE 
    IF busqueda=3 THEN
    SET id=(SELECT f.idDetalle_ensamble from 
detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
    END IF;
  END IF;
END IF;

IF id !='null' THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen`
--

CREATE TABLE `almacen` (
  `idalmacen` smallint(6) NOT NULL,
  `tiempo_total_proceso` varchar(20) DEFAULT NULL,
  `cantidad_recibida` varchar(7) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  `hora_registro` time DEFAULT NULL,
  `hora_llegada` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `area`
--

CREATE TABLE `area` (
  `idArea` tinyint(4) NOT NULL,
  `nom_area` varchar(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `area`
--

INSERT INTO `area` (`idArea`, `nom_area`) VALUES
(1, 'FE'),
(2, 'TE'),
(3, 'EN'),
(4, 'ALMACEN');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargo`
--

CREATE TABLE `cargo` (
  `idcargo` tinyint(4) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `cargo`
--

INSERT INTO `cargo` (`idcargo`, `nombre`) VALUES
(1, 'Gestor Técnico'),
(2, 'Encargado de FE y TE'),
(3, 'Encargado de EN'),
(4, 'Administrador'),
(5, 'Almacen'),
(6, 'Gestor Comercial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `color_antisolder`
--

CREATE TABLE `color_antisolder` (
  `idColor_antisolder` tinyint(3) NOT NULL,
  `color` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `color_antisolder`
--

INSERT INTO `color_antisolder` (`idColor_antisolder`, `color`) VALUES
(1, 'VERDE'),
(2, 'BLANCO'),
(3, 'NEGRO'),
(4, 'ROJO'),
(5, 'AZUL'),
(6, 'CELESTE'),
(7, 'ESMERALDA'),
(8, 'ROSADO'),
(9, 'GRIS');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `condicion_producto`
--

CREATE TABLE `condicion_producto` (
  `idCondicion` tinyint(4) NOT NULL,
  `idProducto` tinyint(4) NOT NULL,
  `area` varchar(2) DEFAULT NULL,
  `material` varchar(3) NOT NULL DEFAULT '0',
  `antisorder` tinyint(1) NOT NULL,
  `ruteo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `condicion_producto`
--

INSERT INTO `condicion_producto` (`idCondicion`, `idProducto`, `area`, `material`, `antisorder`, `ruteo`) VALUES
(1, 1, '1', 'TH', 1, 1),
(2, 1, '1', 'TH', 0, 0),
(3, 1, '3', '0', 0, 0),
(4, 5, '2', '0', 0, 0),
(5, 1, '1', 'TH', 1, 0),
(6, 1, '1', 'TH', 0, 1),
(7, 3, '1', '0', 0, 0),
(8, 4, '1', '0', 0, 0),
(9, 6, '1', '0', 0, 0),
(10, 2, '1', '0', 0, 0),
(11, 7, '1', 'TH', 1, 1),
(12, 7, '1', 'TH', 0, 0),
(13, 7, '1', 'TH', 1, 0),
(14, 7, '1', 'TH', 0, 1),
(15, 1, '1', 'FV', 1, 1),
(16, 1, '1', 'FV', 0, 0),
(17, 1, '1', 'FV', 1, 0),
(18, 1, '1', 'FV', 0, 1),
(19, 7, '1', 'FV', 1, 1),
(20, 7, '1', 'FV', 0, 0),
(21, 7, '1', 'FV', 1, 0),
(22, 7, '1', 'FV', 0, 1),
(23, 12, '3', '0', 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ensamble`
--

CREATE TABLE `detalle_ensamble` (
  `idDetalle_ensamble` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00:00',
  `cantidad_terminada` varchar(6) NOT NULL DEFAULT '0',
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT '1',
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `noperarios` tinyint(2) NOT NULL DEFAULT '0',
  `orden` tinyint(2) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0',
  `proceso_final` tinyint(1) NOT NULL DEFAULT '0',
  `mes_de_corte` varchar(10) NOT NULL DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_ensamble`
--

INSERT INTO `detalle_ensamble` (`idDetalle_ensamble`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`, `proceso_final`, `mes_de_corte`) VALUES
(1, '00:51:16', '170:54:05', '200', '2019-03-15', '2019-04-24', 68, 15, 3, '2019-04-24 07:07:23', '2019-04-24 07:07:39', 0, 0, '0', 0, '2019-04-24'),
(2, '00:00:00', '00:00:00', '200', '2019-03-08', '2019-03-20', 68, 16, 3, NULL, NULL, 0, 1, '0', 0, '2019-04-02'),
(3, '00:00:00', '30:56:14', '100', '2019-03-20', NULL, 68, 17, 2, '2019-04-24 07:12:42', '2019-04-24 17:34:48', 0, 0, '100', 0, '2019-04-02'),
(4, '00:00:00', '00:00:00', '100', '2019-03-27', NULL, 68, 18, 2, NULL, NULL, 0, 0, '0', 1, '2019-04-02'),
(5, '00:00:00', '00:00:00', '100', '2019-03-26', '2019-03-29', 200, 15, 3, NULL, NULL, 0, 1, '0', 0, '2019-04-02'),
(6, '00:00:00', '00:00:00', '0', NULL, NULL, 200, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(7, '00:00:00', '10:57:07', '0', '2019-03-27', NULL, 200, 17, 2, '2019-04-02 10:41:02', '2019-04-02 14:20:01', 0, 0, '100', 0, '2019-04-02'),
(8, '00:00:00', '00:00:00', '0', NULL, NULL, 200, 18, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(9, '00:00:00', '00:00:00', '2', '2019-03-12', '2019-03-13', 61, 15, 3, NULL, NULL, 0, 1, '0', 0, '2019-04-02'),
(10, '00:00:00', '00:00:00', '0', NULL, NULL, 61, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(11, '00:00:00', '00:00:00', '0', '2019-03-13', NULL, 61, 17, 2, NULL, NULL, 0, 0, '2', 0, '2019-04-02'),
(12, '00:00:00', '00:00:00', '0', NULL, NULL, 61, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(13, '00:00:20', '01:07:48', '200', '2019-03-29', '2019-04-02', 198, 15, 3, '2019-04-02 13:02:47', '2019-04-02 13:56:48', 0, 0, '0', 0, '2019-04-02'),
(14, '00:00:00', '00:00:31', '200', '2019-03-29', '2019-04-02', 198, 16, 3, '2019-04-02 10:42:09', '2019-04-02 10:42:40', 0, 1, '0', 0, '2019-04-02'),
(15, '00:00:00', '00:00:00', '0', '2019-03-29', NULL, 198, 17, 2, '2019-04-03 13:02:20', '2019-04-04 13:02:20', 0, 0, '200', 0, '2019-04-02'),
(16, '00:00:00', '00:00:00', '0', NULL, NULL, 198, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(21, '00:06:16', '00:18:49', '3', '2019-03-28', '2019-04-03', 88, 15, 3, '2019-04-03 06:43:03', '2019-04-03 07:01:52', 0, 1, '0', 0, '2019-04-03'),
(22, '00:00:00', '00:00:00', '0', NULL, NULL, 88, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(23, '00:10:46', '00:32:17', '3', '2019-04-03', '2019-04-03', 88, 17, 3, '2019-04-03 09:27:42', '2019-04-03 09:28:05', 0, 0, '0', 0, '2019-04-03'),
(24, '00:00:00', '00:00:00', '0', NULL, NULL, 88, 18, 1, NULL, NULL, 0, 0, '3', 1, '0000-00-00'),
(25, '00:00:01', '00:01:11', '48', '2019-03-28', '2019-04-02', 136, 15, 3, '2019-04-02 15:04:28', '2019-04-02 15:04:44', 0, 1, '0', 0, '2019-04-02'),
(26, '00:00:00', '00:00:00', '0', NULL, NULL, 136, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(27, '00:00:00', '07:15:45', '44', '2019-03-28', NULL, 136, 17, 2, '2019-04-03 06:04:40', '2019-04-03 08:14:30', 0, 0, '4', 0, '2019-04-02'),
(28, '00:00:00', '00:00:00', '0', NULL, NULL, 136, 18, 1, NULL, NULL, 0, 0, '36', 1, '0000-00-00'),
(29, '00:01:05', '00:01:05', '1', '2019-03-28', '2019-04-02', 258, 15, 3, '2019-04-02 10:35:24', '2019-04-02 10:36:29', 0, 1, '0', 0, '2019-04-02'),
(30, '00:00:00', '00:00:00', '0', NULL, NULL, 258, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(31, '00:00:43', '00:00:43', '1', '2019-04-02', '2019-04-02', 258, 17, 3, '2019-04-02 10:38:06', '2019-04-02 10:38:49', 0, 0, '0', 0, '2019-04-02'),
(32, '00:01:31', '00:01:31', '1', '2019-04-02', '2019-04-02', 258, 18, 3, '2019-04-02 10:46:50', '2019-04-02 10:48:21', 0, 0, '0', 1, '2019-04-02'),
(37, '01:22:41', '15:09:36', '11', '2019-04-02', '2019-04-08', 150, 15, 3, '2019-04-08 11:33:26', '2019-04-08 11:33:48', 0, 1, '0', 0, '2019-04-08'),
(38, '00:00:00', '00:00:00', '0', NULL, NULL, 150, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(39, '10:41:04', '117:31:41', '11', '2019-04-03', '2019-04-08', 150, 17, 3, '2019-04-08 11:33:15', '2019-04-08 11:34:45', 0, 0, '0', 0, '2019-04-08'),
(40, '00:00:00', '00:00:00', '0', NULL, NULL, 150, 18, 1, NULL, NULL, 0, 0, '10', 1, '0000-00-00'),
(41, '01:52:17', '03:44:33', '2', '2019-04-02', '2019-04-02', 232, 15, 3, '2019-04-02 10:57:56', '2019-04-02 14:42:29', 0, 1, '0', 0, '2019-04-02'),
(42, '00:00:00', '00:00:00', '0', NULL, NULL, 232, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(43, '16:15:07', '32:30:13', '2', '2019-04-03', '2019-04-04', 232, 17, 3, '2019-04-03 08:56:21', '2019-04-04 15:03:01', 0, 0, '0', 0, '2019-04-04'),
(44, '00:06:36', '00:13:12', '2', '2019-04-04', '2019-04-04', 232, 18, 3, '2019-04-04 16:03:31', '2019-04-04 16:16:43', 0, 0, '0', 1, '2019-04-04'),
(45, '04:11:26', '50:17:09', '12', '2019-04-02', '2019-04-05', 132, 15, 3, '2019-04-05 07:41:48', '2019-04-05 12:12:48', 0, 1, '0', 0, '2019-04-05'),
(46, '00:00:00', '00:00:00', '0', NULL, NULL, 132, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(47, '00:00:00', '12:20:50', '9', '2019-04-03', NULL, 132, 17, 2, '2019-04-08 06:57:25', '2019-04-08 16:27:22', 0, 0, '12', 0, '2019-04-04'),
(48, '00:00:00', '00:00:21', '9', '2019-04-05', NULL, 132, 18, 2, '2019-04-05 11:46:11', '2019-04-05 11:46:32', 0, 0, '0', 1, '0000-00-00'),
(49, '00:00:00', '00:00:00', '0', NULL, NULL, 288, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(50, '00:00:00', '00:00:00', '0', NULL, NULL, 288, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(51, '00:00:00', '00:00:00', '0', NULL, NULL, 288, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(52, '00:00:00', '00:00:00', '0', NULL, NULL, 288, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(53, '00:00:00', '26:23:49', '0', '2019-04-03', NULL, 293, 15, 2, '2019-04-04 11:02:27', '2019-04-04 11:03:03', 0, 1, '14', 0, '2019-04-04'),
(54, '00:00:00', '00:00:00', '0', NULL, NULL, 293, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(55, '00:00:00', '00:00:00', '0', NULL, NULL, 293, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(56, '00:00:00', '00:00:00', '0', NULL, NULL, 293, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(61, '00:00:00', '00:00:00', '0', NULL, NULL, 299, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(62, '00:00:00', '00:00:00', '0', NULL, NULL, 299, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(63, '00:00:00', '00:00:00', '0', NULL, NULL, 299, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(64, '00:00:00', '00:00:00', '0', NULL, NULL, 299, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(65, '00:39:00', '06:29:58', '10', '2019-04-09', '2019-04-10', 303, 15, 3, '2019-04-10 09:45:56', '2019-04-10 10:35:31', 0, 0, '0', 0, '2019-04-10'),
(66, '00:00:04', '00:00:37', '10', '2019-04-09', '2019-04-09', 303, 16, 3, '2019-04-09 06:12:42', '2019-04-09 06:13:19', 0, 1, '0', 0, '2019-04-09'),
(67, '00:00:00', '09:28:14', '0', '2019-04-10', NULL, 303, 17, 2, '2019-04-10 07:02:13', '2019-04-10 16:30:27', 0, 0, '10', 0, '0000-00-00'),
(68, '00:00:00', '00:00:00', '0', NULL, NULL, 303, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(69, '00:00:00', '00:00:36', '0', '2019-04-05', NULL, 307, 15, 2, '2019-04-05 08:07:12', '2019-04-05 08:07:48', 0, 1, '20', 0, '0000-00-00'),
(70, '00:00:00', '00:00:00', '0', NULL, NULL, 307, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(71, '00:00:00', '00:00:00', '0', NULL, NULL, 307, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(72, '00:00:00', '00:00:00', '0', NULL, NULL, 307, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(73, '00:00:00', '27:02:19', '40', '2019-04-05', NULL, 308, 15, 2, '2019-04-09 06:08:57', '2019-04-09 08:11:59', 0, 1, '10', 0, '0000-00-00'),
(74, '00:00:00', '00:00:00', '0', NULL, NULL, 308, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(75, '00:00:00', '00:00:00', '0', '2019-04-10', NULL, 308, 17, 2, '2019-04-10 06:48:03', '2019-04-11 06:48:03', 0, 0, '40', 0, '0000-00-00'),
(76, '00:00:00', '00:00:00', '0', NULL, NULL, 308, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(81, '00:00:00', '00:00:00', '0', '2019-04-05', NULL, 310, 15, 2, '2019-04-05 09:58:14', '2019-04-06 09:58:14', 0, 1, '1', 0, '0000-00-00'),
(82, '00:00:00', '00:00:00', '0', NULL, NULL, 310, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(83, '00:00:00', '00:00:00', '0', NULL, NULL, 310, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(84, '00:00:00', '00:00:00', '0', NULL, NULL, 310, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(89, '00:00:00', '00:00:00', '0', NULL, NULL, 311, 15, 1, NULL, NULL, 0, 1, '1', 0, '0000-00-00'),
(90, '00:00:00', '00:00:00', '0', NULL, NULL, 311, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(91, '00:00:00', '00:00:00', '0', NULL, NULL, 311, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(92, '00:00:00', '00:00:00', '0', NULL, NULL, 311, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(93, '00:00:00', '00:00:00', '0', NULL, NULL, 312, 15, 1, NULL, NULL, 0, 1, '1', 0, '0000-00-00'),
(94, '00:00:00', '00:00:00', '0', NULL, NULL, 312, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(95, '00:00:00', '00:00:00', '0', NULL, NULL, 312, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(96, '00:00:00', '00:00:00', '0', NULL, NULL, 312, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(97, '00:00:00', '82:19:34', '0', '2019-04-05', NULL, 313, 15, 2, '2019-04-09 07:29:35', '2019-04-10 07:29:35', 0, 1, '25', 0, '0000-00-00'),
(98, '00:00:00', '00:00:00', '0', NULL, NULL, 313, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(99, '00:00:00', '00:00:00', '0', NULL, NULL, 313, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(100, '00:00:00', '00:00:00', '0', NULL, NULL, 313, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(101, '01:42:24', '85:19:55', '50', '2019-04-05', '2019-04-09', 314, 15, 3, '2019-04-09 06:08:48', '2019-04-09 09:18:15', 0, 1, '0', 0, '2019-04-09'),
(102, '00:00:00', '00:00:00', '0', NULL, NULL, 314, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(103, '00:00:00', '00:00:00', '0', '2019-04-12', NULL, 314, 17, 2, '2019-04-12 06:19:54', '2019-04-13 06:19:54', 0, 0, '50', 0, '0000-00-00'),
(104, '00:00:00', '00:00:00', '0', NULL, NULL, 314, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(105, '00:00:00', '33:36:32', '24', '2019-04-08', NULL, 315, 15, 2, '2019-04-10 06:43:57', '2019-04-11 06:43:57', 1, 1, '1', 0, '0000-00-00'),
(106, '00:00:00', '00:00:00', '0', NULL, NULL, 315, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(107, '00:00:00', '00:02:38', '0', '2019-04-10', NULL, 315, 17, 2, '2019-04-10 06:45:04', '2019-04-10 06:47:42', 0, 0, '24', 0, '0000-00-00'),
(108, '00:00:00', '00:00:00', '0', NULL, NULL, 315, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(109, '00:00:00', '00:00:35', '0', '2019-04-05', NULL, 316, 15, 2, '2019-04-05 06:19:48', '2019-04-06 06:19:48', 0, 1, '25', 0, '0000-00-00'),
(110, '00:00:00', '00:00:00', '0', NULL, NULL, 316, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(111, '00:00:00', '00:00:00', '0', NULL, NULL, 316, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(112, '00:00:00', '00:00:00', '0', NULL, NULL, 316, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(113, '03:27:55', '86:38:07', '25', '2019-04-05', '2019-04-10', 309, 15, 3, '2019-04-10 07:46:42', '2019-04-10 07:47:54', 0, 1, '0', 0, '2019-04-10'),
(114, '00:00:00', '00:00:00', '0', NULL, NULL, 309, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(115, '00:00:00', '00:00:00', '0', NULL, NULL, 309, 17, 1, NULL, NULL, 0, 0, '25', 0, '0000-00-00'),
(116, '00:00:00', '00:00:00', '0', NULL, NULL, 309, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(117, '00:00:00', '00:00:00', '0', NULL, NULL, 319, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(118, '00:00:00', '00:00:00', '0', NULL, NULL, 319, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(119, '00:00:00', '00:00:00', '0', NULL, NULL, 319, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(120, '00:00:00', '00:00:00', '0', NULL, NULL, 319, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(125, '00:00:00', '00:00:00', '0', NULL, NULL, 322, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(126, '00:00:00', '00:00:00', '0', NULL, NULL, 322, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(127, '00:00:00', '00:00:00', '0', NULL, NULL, 322, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(128, '00:00:00', '00:00:00', '0', NULL, NULL, 322, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(129, '00:00:00', '178:04:28', '9', '2019-04-08', NULL, 334, 15, 2, '2019-04-10 07:58:52', '2019-04-17 15:22:31', 0, 0, '6', 0, '0000-00-00'),
(130, '00:00:00', '00:41:56', '15', '2019-04-08', NULL, 334, 16, 2, '2019-04-10 07:16:25', '2019-04-11 07:16:25', 0, 1, '85', 0, '0000-00-00'),
(131, '00:00:00', '05:07:18', '0', '2019-04-08', NULL, 334, 17, 2, '2019-04-09 06:17:04', '2019-04-09 07:33:34', 0, 0, '9', 0, '0000-00-00'),
(132, '00:00:00', '00:00:00', '0', NULL, NULL, 334, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(133, '00:00:00', '00:00:00', '0', NULL, NULL, 336, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(134, '00:00:00', '00:00:00', '0', NULL, NULL, 336, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(135, '00:00:00', '00:00:00', '0', NULL, NULL, 336, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(136, '00:00:00', '00:00:00', '0', NULL, NULL, 336, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(137, '00:00:00', '00:00:00', '0', NULL, NULL, 338, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(138, '00:00:00', '00:00:00', '0', NULL, NULL, 338, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(139, '00:00:00', '00:00:00', '0', NULL, NULL, 338, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(140, '00:00:00', '00:00:00', '0', NULL, NULL, 338, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(141, '00:00:00', '00:00:00', '0', NULL, NULL, 340, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(142, '00:00:00', '00:00:00', '0', NULL, NULL, 340, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(143, '00:00:00', '00:00:00', '0', NULL, NULL, 340, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(144, '00:00:00', '00:00:00', '0', NULL, NULL, 340, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(145, '00:00:00', '00:00:00', '0', NULL, NULL, 345, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(146, '00:00:00', '00:00:00', '0', NULL, NULL, 345, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(147, '00:00:00', '00:00:00', '0', NULL, NULL, 345, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(148, '00:00:00', '00:00:00', '0', NULL, NULL, 345, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(165, '00:00:00', '00:00:00', '0', NULL, NULL, 359, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(166, '00:00:00', '00:00:00', '0', NULL, NULL, 359, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(167, '00:00:00', '00:00:00', '0', NULL, NULL, 359, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(168, '00:00:00', '00:00:00', '0', NULL, NULL, 359, 18, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(169, '00:00:00', '00:00:00', '0', NULL, NULL, 360, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(170, '00:00:00', '00:00:00', '0', NULL, NULL, 360, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(171, '00:00:00', '00:00:00', '0', NULL, NULL, 360, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(172, '00:00:00', '00:00:00', '0', NULL, NULL, 360, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(173, '00:00:00', '00:00:00', '0', NULL, NULL, 366, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(174, '00:00:00', '00:00:00', '0', NULL, NULL, 366, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(175, '00:00:00', '00:00:00', '0', NULL, NULL, 366, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(176, '00:00:00', '00:00:00', '0', NULL, NULL, 366, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(177, '00:00:00', '00:00:00', '0', NULL, NULL, 367, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(178, '00:00:00', '00:00:00', '0', NULL, NULL, 367, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(179, '00:00:00', '00:00:00', '0', NULL, NULL, 367, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(180, '00:00:00', '00:00:00', '0', NULL, NULL, 367, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(181, '00:00:00', '00:00:00', '0', NULL, NULL, 368, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(182, '00:00:00', '00:00:00', '0', NULL, NULL, 368, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(183, '00:00:00', '00:00:00', '0', NULL, NULL, 368, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(184, '00:00:00', '00:00:00', '0', NULL, NULL, 368, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(185, '00:00:00', '00:00:00', '0', NULL, NULL, 369, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(186, '00:00:00', '00:00:00', '0', NULL, NULL, 369, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(187, '00:00:00', '00:00:00', '0', NULL, NULL, 369, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(188, '00:00:00', '00:00:00', '0', NULL, NULL, 369, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(193, '00:00:00', '00:00:00', '0', NULL, NULL, 354, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(194, '00:00:00', '00:00:00', '0', NULL, NULL, 354, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(195, '00:00:00', '00:00:00', '0', NULL, NULL, 354, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(196, '00:00:00', '00:00:00', '0', NULL, NULL, 354, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(197, '00:00:00', '00:44:56', '16', '2019-04-22', NULL, 396, 15, 2, '2019-04-23 08:01:09', '2019-04-23 08:01:50', 0, 1, '192', 0, '0000-00-00'),
(198, '00:00:00', '00:00:00', '0', NULL, NULL, 396, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(199, '00:00:00', '00:28:41', '16', '2019-04-23', NULL, 396, 17, 2, '2019-04-23 12:12:22', '2019-04-23 12:12:42', 0, 0, '0', 0, '0000-00-00'),
(200, '00:00:00', '00:00:00', '0', NULL, NULL, 396, 18, 1, NULL, NULL, 0, 0, '8', 1, '0000-00-00'),
(217, '00:00:00', '00:00:00', '0', NULL, NULL, 407, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(218, '00:00:00', '00:00:00', '0', NULL, NULL, 407, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(219, '00:00:00', '00:00:00', '0', NULL, NULL, 407, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(220, '00:00:00', '00:00:00', '0', NULL, NULL, 407, 18, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(221, '00:34:53', '29:04:25', '50', '2019-04-22', '2019-04-23', 408, 15, 3, '2019-04-23 06:09:09', '2019-04-23 12:17:24', 0, 1, '0', 0, '2019-04-23'),
(222, '00:00:00', '00:00:00', '0', NULL, NULL, 408, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(223, '00:00:00', '24:16:51', '0', '2019-04-23', NULL, 408, 17, 4, '2019-04-25 06:45:56', NULL, 2, 0, '50', 0, '0000-00-00'),
(224, '00:00:00', '00:00:00', '0', NULL, NULL, 408, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(225, '00:00:00', '00:00:00', '0', NULL, NULL, 410, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(226, '00:00:00', '00:00:00', '0', NULL, NULL, 410, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(227, '00:00:00', '00:00:00', '0', NULL, NULL, 410, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(228, '00:00:00', '00:00:00', '0', NULL, NULL, 410, 18, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(229, '00:34:38', '28:51:59', '50', '2019-04-22', '2019-04-23', 412, 15, 3, '2019-04-23 12:26:48', '2019-04-23 16:33:15', 0, 1, '0', 0, '2019-04-23'),
(230, '00:00:00', '00:00:00', '0', NULL, NULL, 412, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(231, '00:00:00', '30:29:48', '0', '2019-04-23', NULL, 412, 17, 4, '2019-04-25 06:47:32', NULL, 2, 0, '50', 0, '0000-00-00'),
(232, '00:00:00', '00:00:00', '0', NULL, NULL, 412, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(233, '00:00:00', '00:00:00', '0', NULL, NULL, 413, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(234, '00:00:00', '00:00:00', '0', NULL, NULL, 413, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(235, '00:00:00', '00:00:00', '0', NULL, NULL, 413, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(236, '00:00:00', '00:00:00', '0', NULL, NULL, 413, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(237, '00:00:00', '00:00:00', '0', NULL, NULL, 295, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(238, '00:00:00', '00:00:00', '0', NULL, NULL, 295, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(239, '00:00:00', '00:00:00', '0', NULL, NULL, 295, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(240, '00:00:00', '00:00:00', '0', NULL, NULL, 295, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(241, '00:00:00', '00:00:00', '0', '2019-04-25', NULL, 423, 15, 4, '2019-04-25 07:10:29', NULL, 1, 0, '26', 0, '0000-00-00'),
(242, '00:00:00', '00:47:40', '26', '2019-04-25', NULL, 423, 16, 4, '2019-04-25 09:50:58', NULL, 1, 1, '174', 0, '0000-00-00'),
(243, '00:00:00', '00:00:00', '0', NULL, NULL, 423, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(244, '00:00:00', '00:00:00', '0', NULL, NULL, 423, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(245, '00:00:00', '02:53:28', '0', '2019-04-23', NULL, 424, 15, 4, '2019-04-25 07:11:31', NULL, 1, 0, '68', 0, '0000-00-00'),
(246, '00:00:00', '00:02:07', '68', '2019-04-23', NULL, 424, 16, 4, '2019-04-25 07:05:30', NULL, 1, 1, '82', 0, '0000-00-00'),
(247, '00:00:00', '00:00:00', '0', NULL, NULL, 424, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(248, '00:00:00', '00:00:00', '0', NULL, NULL, 424, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(249, '00:00:00', '19:00:57', '16', '2019-04-23', NULL, 425, 15, 4, '2019-04-25 07:29:28', NULL, 2, 1, '34', 0, '0000-00-00'),
(250, '00:00:00', '00:00:00', '0', NULL, NULL, 425, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(251, '00:00:00', '00:00:00', '0', '2019-04-25', NULL, 425, 17, 4, '2019-04-25 07:29:54', NULL, 1, 0, '16', 0, '0000-00-00'),
(252, '00:00:00', '00:00:00', '0', NULL, NULL, 425, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(265, '00:00:00', '00:00:00', '0', NULL, NULL, 446, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(266, '00:00:00', '00:00:00', '0', NULL, NULL, 446, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(267, '00:00:00', '00:00:00', '0', NULL, NULL, 446, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(268, '00:00:00', '00:00:00', '0', NULL, NULL, 446, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(289, '00:00:00', '00:00:00', '0', NULL, NULL, 465, 15, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(290, '00:00:00', '00:00:00', '0', NULL, NULL, 465, 16, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(291, '00:00:00', '00:00:00', '0', NULL, NULL, 465, 17, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(292, '00:00:00', '00:00:00', '0', NULL, NULL, 465, 18, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_formato_estandar`
--

CREATE TABLE `detalle_formato_estandar` (
  `idDetalle_formato_estandar` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00:00',
  `cantidad_terminada` varchar(6) NOT NULL DEFAULT '0',
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT '1',
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `noperarios` tinyint(2) NOT NULL DEFAULT '0',
  `orden` tinyint(2) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0',
  `mes_de_corte` varchar(10) NOT NULL DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`, `mes_de_corte`) VALUES
(9, '00:00:04', '00:00:15', '4', '2019-04-02', '2019-04-02', 283, 1, 3, '2019-04-02 09:19:07', '2019-04-02 09:19:22', 0, 1, '0', '2019-04-02'),
(10, '05:05:02', '20:20:07', '4', '2019-04-02', '2019-04-03', 283, 2, 3, '2019-04-02 10:05:13', '2019-04-03 06:25:20', 0, 2, '0', '2019-04-03'),
(11, '84:20:13', '337:20:52', '4', '2019-04-03', '2019-04-17', 283, 3, 3, '2019-04-03 10:22:04', '2019-04-17 11:22:42', 0, 3, '0', '2019-04-17'),
(12, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 4, 1, NULL, NULL, 0, 4, '4', '0000-00-00'),
(13, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(14, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(15, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(16, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(17, '00:00:00', '00:00:00', '0', NULL, NULL, 283, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(18, '00:00:04', '00:00:11', '3', '2019-04-02', '2019-04-02', 286, 1, 3, '2019-04-02 09:20:26', '2019-04-02 09:20:37', 0, 1, '0', '2019-04-02'),
(19, '06:46:34', '20:19:43', '3', '2019-04-02', '2019-04-03', 286, 2, 3, '2019-04-02 10:06:00', '2019-04-03 06:25:43', 0, 2, '0', '2019-04-03'),
(20, '00:00:00', '337:20:15', '0', '2019-04-03', NULL, 286, 3, 2, '2019-04-03 10:23:05', '2019-04-17 10:53:29', 0, 3, '3', '2019-04-04'),
(21, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(22, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(23, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(24, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(25, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(26, '00:00:00', '00:00:00', '0', NULL, NULL, 286, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(27, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 1, 1, NULL, NULL, 0, 1, '84', '0000-00-00'),
(28, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(29, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(30, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(31, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(32, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(33, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(34, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(35, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 9, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(36, '00:00:00', '00:00:00', '0', NULL, NULL, 273, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(37, '00:00:05', '00:08:02', '100', '2019-04-02', '2019-04-02', 235, 1, 3, '2019-04-02 09:17:06', '2019-04-02 09:17:19', 0, 1, '0', '2019-04-02'),
(38, '03:33:08', '355:13:07', '100', '2019-04-02', '2019-04-17', 235, 2, 3, '2019-04-02 15:35:05', '2019-04-17 10:48:12', 0, 2, '0', '2019-04-17'),
(39, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 3, 1, NULL, NULL, 0, 3, '100', '0000-00-00'),
(40, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(41, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(42, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(43, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(44, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(45, '00:00:00', '00:00:00', '0', NULL, NULL, 235, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(72, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 1, 1, NULL, NULL, 0, 1, '50', '0000-00-00'),
(73, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(74, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(75, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(76, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(77, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(78, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(79, '00:00:00', '00:00:00', '0', NULL, NULL, 221, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(97, '00:00:00', '00:00:00', '10', '2019-03-29', '2019-03-29', 275, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(98, '00:05:38', '00:56:22', '10', '2019-04-02', '2019-04-02', 275, 2, 3, '2019-04-02 10:04:33', '2019-04-02 11:00:55', 0, 2, '0', '2019-04-02'),
(99, '00:03:25', '00:34:14', '10', '2019-04-02', '2019-04-02', 275, 3, 3, '2019-04-02 14:28:58', '2019-04-02 15:03:12', 0, 3, '0', '2019-04-02'),
(100, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 4, 1, NULL, NULL, 0, 4, '10', '0000-00-00'),
(101, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(102, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(103, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(104, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(105, '00:00:00', '00:00:00', '0', NULL, NULL, 275, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(106, '00:00:00', '00:00:00', '2', '2019-03-29', '2019-03-29', 277, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(107, '00:00:02', '00:00:04', '2', '2019-04-02', '2019-04-02', 277, 2, 3, '2019-04-02 09:31:51', '2019-04-02 09:31:55', 0, 2, '0', '2019-04-02'),
(108, '00:00:07', '00:00:14', '2', '2019-04-02', '2019-04-02', 277, 3, 3, '2019-04-02 09:33:30', '2019-04-02 09:33:44', 0, 3, '0', '2019-04-02'),
(109, '00:00:04', '00:00:08', '2', '2019-04-02', '2019-04-02', 277, 4, 3, '2019-04-02 09:34:27', '2019-04-02 09:34:35', 0, 4, '0', '2019-04-02'),
(110, '00:00:06', '00:00:11', '2', '2019-04-02', '2019-04-02', 277, 5, 3, '2019-04-02 09:35:25', '2019-04-02 09:35:36', 0, 5, '0', '2019-04-02'),
(111, '00:00:00', '00:00:00', '0', NULL, NULL, 277, 7, 1, NULL, NULL, 0, 7, '2', '0000-00-00'),
(112, '00:00:00', '00:00:00', '0', NULL, NULL, 277, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(113, '00:00:00', '00:00:00', '0', NULL, NULL, 277, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(114, '00:43:15', '01:26:30', '2', '2019-04-02', '2019-04-02', 277, 6, 3, '2019-04-02 10:11:36', '2019-04-02 11:38:06', 0, 6, '0', '2019-04-02'),
(115, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 276, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(116, '00:33:11', '05:31:52', '10', '2019-04-02', '2019-04-02', 276, 2, 3, '2019-04-02 10:04:51', '2019-04-02 15:36:43', 0, 2, '0', '2019-04-02'),
(117, '00:03:35', '00:35:46', '10', '2019-04-03', '2019-04-03', 276, 3, 3, '2019-04-03 07:36:40', '2019-04-03 08:12:26', 0, 3, '0', '2019-04-03'),
(118, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 4, 1, NULL, NULL, 0, 4, '10', '0000-00-00'),
(119, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(120, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(121, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(122, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(123, '00:00:00', '00:00:00', '0', NULL, NULL, 276, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(124, '00:00:00', '00:00:00', '10', '2019-03-29', '2019-03-29', 284, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(125, '00:00:01', '00:00:09', '10', '2019-04-02', '2019-04-02', 284, 2, 3, '2019-04-02 09:26:04', '2019-04-02 09:26:13', 0, 2, '0', '2019-04-02'),
(126, '00:00:03', '00:00:27', '10', '2019-04-02', '2019-04-02', 284, 3, 3, '2019-04-02 09:27:28', '2019-04-02 09:27:55', 0, 3, '0', '2019-04-02'),
(127, '00:00:01', '00:00:11', '10', '2019-04-02', '2019-04-02', 284, 4, 3, '2019-04-02 09:28:15', '2019-04-02 09:28:26', 0, 4, '0', '2019-04-02'),
(128, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 284, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(129, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 284, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(130, '00:00:00', '00:00:00', '0', NULL, NULL, 284, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(131, '00:00:00', '00:00:00', '0', NULL, NULL, 284, 10, 1, NULL, NULL, 0, 9, '10', '0000-00-00'),
(132, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 284, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(133, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(134, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(135, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(136, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(137, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(138, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(139, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(140, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 143, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(141, '00:00:00', '00:00:00', '0', NULL, NULL, 143, 9, 1, NULL, NULL, 0, 9, '3', '0000-00-00'),
(142, '00:00:00', '00:00:00', '0', NULL, NULL, 143, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(143, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 224, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(144, '00:00:01', '00:00:10', '20', '2019-04-02', '2019-04-02', 224, 2, 3, '2019-04-02 09:22:57', '2019-04-02 09:23:07', 0, 2, '0', '2019-04-02'),
(145, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 3, 1, NULL, NULL, 0, 3, '20', '0000-00-00'),
(146, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(147, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(148, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(149, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(150, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(151, '00:00:00', '00:00:00', '0', NULL, NULL, 224, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(152, '00:00:00', '00:00:00', '0', '2019-03-29', '2019-03-29', 278, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(153, '00:00:08', '00:00:08', '1', '2019-04-02', '2019-04-02', 278, 2, 3, '2019-04-02 09:31:24', '2019-04-02 09:31:32', 0, 2, '0', '2019-04-02'),
(154, '00:00:06', '00:00:06', '1', '2019-04-02', '2019-04-02', 278, 3, 3, '2019-04-02 09:32:31', '2019-04-02 09:32:37', 0, 3, '0', '2019-04-02'),
(155, '00:00:09', '00:00:09', '1', '2019-04-02', '2019-04-02', 278, 4, 3, '2019-04-02 09:34:09', '2019-04-02 09:34:18', 0, 4, '0', '2019-04-02'),
(156, '00:00:06', '00:00:06', '1', '2019-04-02', '2019-04-02', 278, 5, 3, '2019-04-02 09:34:56', '2019-04-02 09:35:02', 0, 5, '0', '2019-04-02'),
(157, '00:00:00', '00:00:00', '0', NULL, NULL, 278, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(158, '00:00:00', '00:00:00', '0', NULL, NULL, 278, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(159, '00:00:00', '00:00:00', '0', NULL, NULL, 278, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(160, '00:00:00', '00:00:00', '0', NULL, NULL, 278, 6, 1, NULL, NULL, 0, 6, '1', '0000-00-00'),
(161, '00:00:00', '00:00:00', '10', '2019-03-29', '2019-03-29', 279, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(162, '00:00:01', '00:00:09', '10', '2019-04-02', '2019-04-02', 279, 2, 3, '2019-04-02 09:23:56', '2019-04-02 09:24:05', 0, 2, '0', '2019-04-02'),
(163, '01:57:31', '19:35:07', '10', '2019-04-02', '2019-04-03', 279, 3, 3, '2019-04-02 11:43:38', '2019-04-03 06:20:50', 0, 3, '0', '2019-04-03'),
(164, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 4, 1, NULL, NULL, 0, 4, '10', '0000-00-00'),
(165, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(166, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(167, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(168, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(169, '00:00:00', '00:00:00', '0', NULL, NULL, 279, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(170, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(171, '00:00:05', '00:00:15', '3', '2019-04-02', '2019-04-02', 140, 2, 3, '2019-04-02 09:03:55', '2019-04-02 09:04:10', 0, 2, '0', '2019-04-02'),
(172, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(173, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(174, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(175, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(176, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(177, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 140, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(178, '00:00:00', '00:00:00', '0', NULL, NULL, 140, 9, 1, NULL, NULL, 0, 9, '3', '0000-00-00'),
(179, '00:00:00', '00:00:00', '0', NULL, NULL, 140, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(180, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(181, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(182, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(183, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(184, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(185, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(186, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(187, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 10, 1, NULL, NULL, 0, 9, '3', '0000-00-00'),
(188, '00:00:00', '00:00:00', '3', '2019-03-29', '2019-03-29', 263, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(189, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(190, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(191, '00:00:00', '00:00:00', '0', NULL, NULL, 274, 4, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(192, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 5, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(193, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 6, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(194, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(195, '00:00:00', '00:00:00', '5', '2019-03-29', '2019-03-29', 274, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(196, '00:14:32', '01:12:41', '5', '2019-04-02', '2019-04-02', 274, 10, 3, '2019-04-02 14:20:10', '2019-04-02 15:32:51', 0, 8, '0', '2019-04-02'),
(197, '00:00:00', '00:00:00', '50', NULL, NULL, 269, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(198, '00:00:00', '00:00:00', '50', NULL, NULL, 269, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(199, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 4, 1, NULL, NULL, 0, 3, '50', '0000-00-00'),
(200, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(201, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(202, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(203, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(204, '00:00:00', '00:00:00', '0', NULL, NULL, 269, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(205, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 267, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(206, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 267, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(207, '00:00:00', '00:00:08', '100', '2019-04-02', '2019-04-02', 267, 4, 3, '2019-04-02 09:36:08', '2019-04-02 09:36:16', 0, 3, '0', '2019-04-02'),
(208, '00:00:00', '00:00:10', '100', '2019-04-02', '2019-04-02', 267, 5, 3, '2019-04-02 09:36:44', '2019-04-02 09:36:54', 0, 4, '0', '2019-04-02'),
(209, '00:01:31', '02:32:17', '100', '2019-04-02', '2019-04-03', 267, 6, 3, '2019-04-03 06:35:22', '2019-04-03 06:44:57', 0, 5, '0', '2019-04-03'),
(210, '00:00:00', '00:00:00', '0', NULL, NULL, 267, 7, 1, NULL, NULL, 0, 6, '100', '0000-00-00'),
(211, '00:00:00', '00:00:00', '0', NULL, NULL, 267, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(212, '00:00:00', '00:00:00', '0', NULL, NULL, 267, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(213, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 229, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(214, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 229, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(215, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 229, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(216, '00:00:00', '00:00:12', '50', '2019-04-02', '2019-04-02', 229, 4, 3, '2019-04-02 09:37:59', '2019-04-02 09:38:11', 0, 4, '0', '2019-04-02'),
(217, '00:00:00', '00:00:08', '50', '2019-04-02', '2019-04-02', 229, 5, 3, '2019-04-02 09:38:26', '2019-04-02 09:38:34', 0, 5, '0', '2019-04-02'),
(218, '00:00:01', '00:00:37', '50', '2019-04-02', '2019-04-02', 229, 7, 3, '2019-04-02 09:39:44', '2019-04-02 09:40:21', 0, 7, '0', '2019-04-02'),
(219, '00:01:05', '00:53:47', '50', '2019-04-02', '2019-04-02', 229, 8, 3, '2019-04-02 11:44:42', '2019-04-02 12:26:09', 0, 8, '0', '2019-04-02'),
(220, '00:00:00', '00:00:00', '0', NULL, NULL, 229, 10, 1, NULL, NULL, 0, 9, '50', '0000-00-00'),
(221, '00:00:00', '00:00:09', '50', '2019-04-02', '2019-04-02', 229, 6, 3, '2019-04-02 09:39:10', '2019-04-02 09:39:19', 0, 6, '0', '2019-04-02'),
(222, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 270, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(223, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 270, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(224, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 4, 1, NULL, NULL, 0, 3, '50', '0000-00-00'),
(225, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(226, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(227, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(228, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(229, '00:00:00', '00:00:00', '0', NULL, NULL, 270, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(230, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 268, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(231, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 268, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(232, '00:00:00', '00:00:11', '100', '2019-04-02', '2019-04-02', 268, 4, 3, '2019-04-02 09:29:36', '2019-04-02 09:29:47', 0, 3, '0', '2019-04-02'),
(233, '00:00:00', '00:00:11', '100', '2019-04-02', '2019-04-02', 268, 5, 3, '2019-04-02 09:30:10', '2019-04-02 09:30:21', 0, 4, '0', '2019-04-02'),
(234, '00:00:03', '00:04:40', '100', '2019-04-02', '2019-04-02', 268, 6, 3, '2019-04-02 09:44:35', '2019-04-02 09:49:15', 0, 5, '0', '2019-04-02'),
(235, '00:00:20', '00:33:11', '100', '2019-04-02', '2019-04-02', 268, 7, 3, '2019-04-02 10:46:35', '2019-04-02 11:19:46', 0, 6, '0', '2019-04-02'),
(236, '00:00:09', '00:14:36', '100', '2019-04-02', '2019-04-02', 268, 8, 3, '2019-04-02 11:26:06', '2019-04-02 11:40:42', 0, 7, '0', '2019-04-02'),
(237, '00:00:00', '00:00:00', '0', NULL, NULL, 268, 10, 1, NULL, NULL, 0, 8, '100', '0000-00-00'),
(238, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(239, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(240, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 4, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(241, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 5, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(242, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 6, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(243, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(244, '00:00:00', '00:00:00', '40', '2019-03-29', '2019-03-29', 266, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(245, '00:00:00', '00:00:00', '0', NULL, NULL, 266, 10, 1, NULL, NULL, 0, 8, '40', '0000-00-00'),
(246, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(247, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(248, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(249, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(250, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(251, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(252, '00:00:00', '00:00:00', '130', '2019-03-29', '2019-03-29', 219, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(253, '00:00:00', '00:00:00', '0', NULL, NULL, 219, 9, 1, NULL, NULL, 0, 8, '130', '0000-00-00'),
(254, '00:00:00', '00:00:00', '0', NULL, NULL, 219, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(264, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(265, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(266, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(267, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(268, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(269, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(270, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(271, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 228, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(272, '00:00:00', '00:00:00', '0', NULL, NULL, 228, 9, 1, NULL, NULL, 0, 9, '50', '0000-00-00'),
(273, '00:00:00', '00:00:00', '0', NULL, NULL, 228, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(274, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(275, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(276, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(277, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(278, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(279, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(280, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(281, '00:00:00', '00:00:00', '100', '2019-03-29', '2019-03-29', 189, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(282, '00:00:00', '00:00:00', '0', NULL, NULL, 189, 9, 1, NULL, NULL, 0, 9, '100', '0000-00-00'),
(283, '00:00:00', '00:00:00', '0', NULL, NULL, 189, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(284, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(285, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(286, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(287, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(288, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(289, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(290, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(291, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(292, '00:00:00', '00:00:00', '14', '2019-03-29', '2019-03-29', 206, 9, 3, NULL, NULL, 0, 9, '0', '2019-04-02'),
(293, '00:00:00', '00:00:00', '0', NULL, NULL, 206, 10, 1, NULL, NULL, 0, 10, '14', '0000-00-00'),
(294, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(295, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(296, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(297, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(298, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(299, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(300, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(301, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(302, '00:00:00', '00:00:00', '25', '2019-03-29', '2019-03-29', 285, 9, 3, NULL, NULL, 0, 9, '0', '2019-04-02'),
(303, '00:00:00', '00:00:00', '0', NULL, NULL, 285, 10, 1, NULL, NULL, 0, 10, '25', '0000-00-00'),
(304, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(305, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(306, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(307, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(308, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(309, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(310, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(311, '00:00:00', '00:00:00', '50', '2019-03-29', '2019-03-29', 220, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(312, '00:00:00', '00:00:00', '0', NULL, '2019-03-29', 220, 9, 3, NULL, NULL, 0, 9, '0', '2019-04-02'),
(313, '00:00:00', '00:00:00', '0', NULL, NULL, 220, 10, 1, NULL, NULL, 0, 10, '50', '0000-00-00'),
(314, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(315, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(316, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(317, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(318, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(319, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 6, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(320, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 7, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(321, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 8, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(322, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 261, 9, 3, NULL, NULL, 0, 9, '0', '2019-04-02'),
(323, '00:00:00', '00:00:00', '0', NULL, NULL, 261, 10, 1, NULL, NULL, 0, 10, '15', '0000-00-00'),
(324, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(325, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 2, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(326, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 3, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(327, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 4, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(328, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 5, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(329, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(330, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(331, '00:00:00', '00:00:00', '30', '2019-03-29', '2019-03-29', 222, 9, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(332, '00:00:00', '00:00:00', '0', NULL, NULL, 222, 10, 1, NULL, NULL, 0, 9, '30', '0000-00-00'),
(333, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(334, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(335, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 4, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(336, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 5, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(337, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 6, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(338, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(339, '00:00:00', '00:00:00', '15', '2019-03-29', '2019-03-29', 250, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(340, '00:00:00', '00:00:00', '0', NULL, NULL, 250, 10, 1, NULL, NULL, 0, 8, '15', '0000-00-00'),
(341, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 1, 3, NULL, NULL, 0, 1, '0', '2019-04-02'),
(342, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 3, 3, NULL, NULL, 0, 2, '0', '2019-04-02'),
(343, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 4, 3, NULL, NULL, 0, 3, '0', '2019-04-02'),
(344, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 5, 3, NULL, NULL, 0, 4, '0', '2019-04-02'),
(345, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 6, 3, NULL, NULL, 0, 5, '0', '2019-04-02'),
(346, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 7, 3, NULL, NULL, 0, 6, '0', '2019-04-02'),
(347, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 8, 3, NULL, NULL, 0, 7, '0', '2019-04-02'),
(348, '00:00:00', '00:00:00', '20', '2019-03-29', '2019-03-29', 247, 9, 3, NULL, NULL, 0, 8, '0', '2019-04-02'),
(349, '00:00:00', '00:00:00', '0', NULL, NULL, 247, 10, 1, NULL, NULL, 0, 9, '20', '0000-00-00'),
(350, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(351, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(352, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(353, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(354, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(355, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(356, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(357, '00:00:00', '00:00:00', '0', NULL, NULL, 287, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(358, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 1, 1, NULL, NULL, 0, 1, '40', '0000-00-00'),
(359, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(360, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(361, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(362, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(363, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(364, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(365, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(366, '00:00:00', '00:00:00', '0', NULL, NULL, 289, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(367, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(368, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(369, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(370, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(371, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(372, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(373, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(374, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(375, '00:00:00', '00:00:00', '0', NULL, NULL, 290, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(376, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(377, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(378, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(379, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(380, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(381, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(382, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(383, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(384, '00:00:00', '00:00:00', '0', NULL, NULL, 291, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(385, '00:00:09', '00:01:29', '10', '2019-04-04', '2019-04-04', 292, 1, 3, '2019-04-04 06:11:00', '2019-04-04 06:12:29', 0, 1, '0', '2019-04-04'),
(386, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 3, 1, NULL, NULL, 0, 2, '10', '0000-00-00'),
(387, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(388, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(389, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(390, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(391, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(392, '00:00:00', '00:00:00', '0', NULL, NULL, 292, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(397, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 1, 1, NULL, NULL, 0, 1, '30', '0000-00-00'),
(398, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(399, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(400, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(401, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(402, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(403, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(404, '00:00:00', '00:00:00', '0', NULL, NULL, 296, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(405, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(406, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(407, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(408, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(409, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(410, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(411, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(412, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(413, '00:00:00', '00:00:00', '0', NULL, NULL, 297, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(414, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 1, 1, NULL, NULL, 0, 1, '15', '0000-00-00'),
(415, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(416, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(417, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(418, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(419, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(420, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(421, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(422, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 9, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(423, '00:00:00', '00:00:00', '0', NULL, NULL, 298, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(424, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(425, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(426, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(427, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(428, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(429, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(430, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(431, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(432, '00:00:00', '00:00:00', '0', NULL, NULL, 300, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(433, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(434, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(435, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(436, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(437, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(438, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(439, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(440, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(441, '00:00:00', '00:00:00', '0', NULL, NULL, 301, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(442, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 1, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(443, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(444, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(445, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(446, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(447, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(448, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(449, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(450, '00:00:00', '00:00:00', '0', NULL, NULL, 302, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(451, '00:00:16', '01:04:51', '250', '2019-04-24', '2019-04-24', 304, 1, 3, '2019-04-24 08:18:16', '2019-04-24 09:23:07', 0, 1, '0', '2019-04-24'),
(452, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 2, 1, NULL, NULL, 0, 2, '250', '0000-00-00'),
(453, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(454, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(455, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(456, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(457, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(458, '00:00:00', '00:00:00', '0', NULL, NULL, 304, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(459, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 1, 1, NULL, NULL, 0, 1, '20', '0000-00-00'),
(460, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(461, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(462, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(463, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(464, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(465, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(466, '00:00:00', '00:00:00', '0', NULL, NULL, 305, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(467, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(468, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(469, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(470, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(471, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(472, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(473, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(474, '00:00:00', '00:00:00', '0', NULL, NULL, 306, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(475, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 1, 1, NULL, NULL, 0, 1, '30', '0000-00-00'),
(476, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(477, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(478, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(479, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(480, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(481, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(482, '00:00:00', '00:00:00', '0', NULL, NULL, 317, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(483, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(484, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(485, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(486, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(487, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(488, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(489, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(490, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(491, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 9, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(492, '00:00:00', '00:00:00', '0', NULL, NULL, 318, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(497, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(498, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(499, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(500, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(501, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(502, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(503, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(504, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(505, '00:00:00', '00:00:00', '0', NULL, NULL, 321, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(506, '00:00:00', '00:00:00', '0', NULL, NULL, 320, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(507, '00:00:00', '00:00:00', '0', NULL, NULL, 320, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(508, '00:00:00', '00:00:00', '0', NULL, NULL, 320, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(509, '00:00:00', '00:00:00', '0', NULL, NULL, 320, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(519, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 1, 1, NULL, NULL, 0, 1, '9', '0000-00-00'),
(520, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(521, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(522, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(523, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(524, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(525, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(526, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(527, '00:00:00', '00:00:00', '0', NULL, NULL, 323, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(528, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(529, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(530, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(531, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(532, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(533, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(534, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(535, '00:00:00', '00:00:00', '0', NULL, NULL, 324, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(536, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(537, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(538, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(539, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(540, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(541, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(542, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(543, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(544, '00:00:00', '00:00:00', '0', NULL, NULL, 325, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(545, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(546, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(547, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(548, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(549, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(550, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(551, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(552, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(553, '00:00:00', '00:00:00', '0', NULL, NULL, 326, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(554, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(555, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(556, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00');
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`, `mes_de_corte`) VALUES
(557, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(558, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(559, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(560, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(561, '00:00:00', '00:00:00', '0', NULL, NULL, 327, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(562, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(563, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(564, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(565, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(566, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(567, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(568, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(569, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(570, '00:00:00', '00:00:00', '0', NULL, NULL, 328, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(571, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(572, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(573, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(574, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(575, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(576, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(577, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(578, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(579, '00:00:00', '00:00:00', '0', NULL, NULL, 329, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(580, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 1, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(581, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(582, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(583, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(584, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(585, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(586, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(587, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(588, '00:00:00', '00:00:00', '0', NULL, NULL, 330, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(589, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 1, 1, NULL, NULL, 0, 1, '20', '0000-00-00'),
(590, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(591, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(592, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(593, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(594, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(595, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(596, '00:00:00', '00:00:00', '0', NULL, NULL, 331, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(597, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(598, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(599, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(600, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(601, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(602, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(603, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(604, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(605, '00:00:00', '00:00:00', '0', NULL, NULL, 332, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(606, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(607, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(608, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(609, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(610, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(611, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(612, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(613, '00:00:00', '00:00:00', '0', NULL, NULL, 333, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(614, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(615, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(616, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(617, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(618, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(619, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(620, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(621, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(622, '00:00:00', '00:00:00', '0', NULL, NULL, 335, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(623, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(624, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(625, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(626, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(627, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(628, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(629, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(630, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(631, '00:00:00', '00:00:00', '0', NULL, NULL, 337, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(632, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(633, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(634, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(635, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(636, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(637, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(638, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(639, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(640, '00:00:00', '00:00:00', '0', NULL, NULL, 339, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(641, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(642, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(643, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(644, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(645, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(646, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(647, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(648, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(649, '00:00:00', '00:00:00', '0', NULL, NULL, 341, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(650, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(651, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(652, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(653, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(654, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(655, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(656, '00:00:00', '00:00:00', '0', NULL, NULL, 342, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(657, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(658, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(659, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(660, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(661, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(662, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(663, '00:00:00', '00:00:00', '0', NULL, NULL, 343, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(664, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(665, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(666, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(667, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(668, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(669, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(670, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(671, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(672, '00:00:00', '00:00:00', '0', NULL, NULL, 344, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(673, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 1, 1, NULL, NULL, 0, 1, '20', '0000-00-00'),
(674, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(675, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(676, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(677, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(678, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(679, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(680, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(681, '00:00:00', '00:00:00', '0', NULL, NULL, 346, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(682, '00:00:28', '00:09:22', '20', '2019-04-22', '2019-04-22', 347, 1, 3, '2019-04-22 11:24:25', '2019-04-22 11:24:40', 0, 1, '0', '2019-04-22'),
(683, '01:02:08', '20:42:37', '20', '2019-04-22', '2019-04-23', 347, 2, 3, '2019-04-22 11:25:05', '2019-04-23 08:07:42', 0, 2, '0', '2019-04-23'),
(684, '00:01:08', '00:22:35', '20', '2019-04-23', '2019-04-23', 347, 3, 3, '2019-04-23 14:15:26', '2019-04-23 14:38:01', 0, 3, '0', '2019-04-23'),
(685, '00:14:36', '04:52:08', '20', '2019-04-24', '2019-04-24', 347, 4, 3, '2019-04-24 12:21:33', '2019-04-24 13:40:06', 0, 4, '0', '2019-04-24'),
(686, '00:00:01', '00:00:21', '20', '2019-04-25', '2019-04-25', 347, 5, 3, '2019-04-25 08:54:31', '2019-04-25 08:54:52', 0, 5, '0', '2019-04-25'),
(687, '00:00:01', '00:00:10', '20', '2019-04-25', '2019-04-25', 347, 7, 3, '2019-04-25 08:56:08', '2019-04-25 08:56:18', 0, 7, '0', '2019-04-25'),
(688, '00:00:01', '00:00:17', '20', '2019-04-25', '2019-04-25', 347, 8, 3, '2019-04-25 08:56:33', '2019-04-25 08:56:50', 0, 8, '0', '2019-04-25'),
(689, '00:00:00', '00:00:00', '0', NULL, NULL, 347, 10, 1, NULL, NULL, 0, 9, '20', '0000-00-00'),
(690, '00:00:00', '00:00:08', '20', '2019-04-25', '2019-04-25', 347, 6, 3, '2019-04-25 08:55:44', '2019-04-25 08:55:52', 0, 6, '0', '2019-04-25'),
(691, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 1, 1, NULL, NULL, 0, 1, '6', '0000-00-00'),
(692, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(693, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(694, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(695, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(696, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(697, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(698, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(699, '00:00:00', '00:00:00', '0', NULL, NULL, 348, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(700, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(701, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(702, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(703, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(704, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(705, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(706, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(707, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(708, '00:00:00', '00:00:00', '0', NULL, NULL, 349, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(709, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 1, 1, NULL, NULL, 0, 1, '25', '0000-00-00'),
(710, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(711, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(712, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(713, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(714, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(715, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(716, '00:00:00', '00:00:00', '0', NULL, NULL, 350, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(717, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(718, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(719, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(720, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(721, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(722, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(723, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(724, '00:00:00', '00:00:00', '0', NULL, NULL, 351, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(725, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 1, 1, NULL, NULL, 0, 1, '20', '0000-00-00'),
(726, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(727, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(728, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(729, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(730, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(731, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(732, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(733, '00:00:00', '00:00:00', '0', NULL, NULL, 352, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(743, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(744, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(745, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(746, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(747, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(748, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(749, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(750, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(751, '00:00:00', '00:00:00', '0', NULL, NULL, 358, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(752, '00:00:16', '00:08:01', '30', '2019-04-17', '2019-04-17', 361, 1, 3, '2019-04-17 16:18:10', '2019-04-17 16:26:11', 0, 1, '0', '2019-04-17'),
(753, '00:06:56', '03:27:48', '30', '2019-04-23', '2019-04-24', 361, 2, 3, '2019-04-24 06:51:02', '2019-04-24 09:26:01', 0, 2, '0', '2019-04-24'),
(754, '00:00:11', '00:05:42', '30', '2019-04-24', '2019-04-24', 361, 3, 3, '2019-04-24 13:40:09', '2019-04-24 13:45:51', 0, 3, '0', '2019-04-24'),
(755, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 4, 1, NULL, NULL, 0, 4, '30', '0000-00-00'),
(756, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(757, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(758, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(759, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(760, '00:00:00', '00:00:00', '0', NULL, NULL, 361, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(761, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(762, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(763, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(764, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(765, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(766, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(767, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(768, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(769, '00:00:00', '00:00:00', '0', NULL, NULL, 362, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(779, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 1, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(780, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(781, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(782, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(783, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(784, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(785, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(786, '00:00:00', '00:00:00', '0', NULL, NULL, 364, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(787, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(788, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(789, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(790, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(791, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(792, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(793, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(794, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(795, '00:00:00', '00:00:00', '0', NULL, NULL, 365, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(796, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(797, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(798, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(799, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(800, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(801, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(802, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(803, '00:00:00', '00:00:00', '0', NULL, NULL, 370, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(804, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 1, 1, NULL, NULL, 0, 1, '40', '0000-00-00'),
(805, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(806, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(807, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(808, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(809, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(810, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(811, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(812, '00:00:00', '00:00:00', '0', NULL, NULL, 363, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(813, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(814, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(815, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(816, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(817, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(818, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(819, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(820, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(821, '00:00:00', '00:00:00', '0', NULL, NULL, 371, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(822, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(823, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(824, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(825, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(826, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(827, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(828, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(829, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(830, '00:00:00', '00:00:00', '0', NULL, NULL, 372, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(831, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(832, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(833, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(834, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(835, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(836, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(837, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(838, '00:00:00', '00:00:00', '0', NULL, NULL, 373, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(839, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 1, 1, NULL, NULL, 0, 1, '6', '0000-00-00'),
(840, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(841, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(842, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(843, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(844, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(845, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(846, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(847, '00:00:00', '00:00:00', '0', NULL, NULL, 374, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(848, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(849, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(850, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(851, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(852, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(853, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(854, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(855, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(856, '00:00:00', '00:00:00', '0', NULL, NULL, 375, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(857, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(858, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(859, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(860, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(861, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(862, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(863, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(864, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(865, '00:00:00', '00:00:00', '0', NULL, NULL, 376, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(866, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(867, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(868, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(869, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(870, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(871, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(872, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(873, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(874, '00:00:00', '00:00:00', '0', NULL, NULL, 377, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(875, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(876, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(877, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(878, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(879, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(880, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(881, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(882, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(883, '00:00:00', '00:00:00', '0', NULL, NULL, 378, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(884, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 1, 1, NULL, NULL, 0, 1, '150', '0000-00-00'),
(885, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(886, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(887, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(888, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(889, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(890, '00:00:00', '00:00:00', '0', NULL, NULL, 379, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(891, '00:00:29', '00:48:36', '100', '2019-04-23', '2019-04-23', 380, 1, 3, '2019-04-23 08:59:11', '2019-04-23 09:47:47', 0, 1, '0', '2019-04-23'),
(892, '00:00:00', '00:00:01', '100', '2019-04-24', '2019-04-24', 380, 3, 3, '2019-04-24 13:40:08', '2019-04-24 13:40:09', 0, 2, '0', '2019-04-24'),
(893, '00:09:25', '15:41:48', '100', '2019-04-24', '2019-04-25', 380, 4, 3, '2019-04-25 07:03:23', '2019-04-25 07:03:58', 0, 3, '0', '2019-04-25'),
(894, '00:00:00', '00:00:30', '100', '2019-04-25', '2019-04-25', 380, 5, 3, '2019-04-25 07:04:53', '2019-04-25 07:05:23', 0, 4, '0', '2019-04-25'),
(895, '00:00:00', '00:00:16', '100', '2019-04-25', '2019-04-25', 380, 7, 3, '2019-04-25 07:05:59', '2019-04-25 07:06:15', 0, 5, '0', '2019-04-25'),
(896, '00:00:00', '00:00:18', '100', '2019-04-25', '2019-04-25', 380, 8, 3, '2019-04-25 07:07:01', '2019-04-25 07:07:19', 0, 6, '0', '2019-04-25'),
(897, '00:00:00', '00:00:00', '0', NULL, NULL, 380, 10, 1, NULL, NULL, 0, 7, '100', '0000-00-00'),
(898, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(899, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(900, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(901, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(902, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(903, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(904, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(905, '00:00:00', '00:00:00', '0', NULL, NULL, 381, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(906, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(907, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(908, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(909, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(910, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(911, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(912, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(913, '00:00:00', '00:00:00', '0', NULL, NULL, 382, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(914, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(915, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(916, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(917, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(918, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(919, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(920, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(921, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(922, '00:00:00', '00:00:00', '0', NULL, NULL, 383, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(923, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 1, 1, NULL, NULL, 0, 1, '6', '0000-00-00'),
(924, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(925, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(926, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(927, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(928, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(929, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(930, '00:00:00', '00:00:00', '0', NULL, NULL, 384, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(931, '00:00:00', '00:00:01', '0', '2019-04-16', NULL, 385, 1, 2, '2019-04-16 07:23:53', '2019-04-16 07:23:54', 0, 1, '2', '0000-00-00'),
(932, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(933, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(934, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(935, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(936, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(937, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(938, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(939, '00:00:00', '00:00:00', '0', NULL, NULL, 385, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(940, '13:43:46', '27:27:31', '2', '2019-04-16', '2019-04-17', 386, 1, 3, '2019-04-17 10:51:17', '2019-04-17 10:51:26', 0, 1, '0', '2019-04-17'),
(941, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 2, 1, NULL, NULL, 0, 2, '2', '0000-00-00'),
(942, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(943, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(944, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(945, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(946, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(947, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(948, '00:00:00', '00:00:00', '0', NULL, NULL, 386, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(949, '00:00:00', '00:00:23', '0', '2019-04-16', NULL, 387, 1, 2, '2019-04-23 17:58:55', '2019-04-23 17:59:05', 0, 1, '2', '0000-00-00'),
(950, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(951, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(952, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(953, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(954, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(955, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(956, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(957, '00:00:00', '00:00:00', '0', NULL, NULL, 387, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(958, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(959, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(960, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(961, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(962, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(963, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(964, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(965, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(966, '00:00:00', '00:00:00', '0', NULL, NULL, 388, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(967, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(968, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(969, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(970, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(971, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(972, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(973, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(974, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(975, '00:00:00', '00:00:00', '0', NULL, NULL, 389, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(976, '00:04:37', '00:09:13', '2', '2019-04-17', '2019-04-17', 390, 1, 3, '2019-04-17 06:18:09', '2019-04-17 06:27:22', 0, 1, '0', '2019-04-17'),
(977, '01:30:35', '03:01:10', '2', '2019-04-17', '2019-04-17', 390, 3, 3, '2019-04-17 07:51:30', '2019-04-17 10:52:40', 0, 2, '0', '2019-04-17'),
(978, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 4, 1, NULL, NULL, 0, 3, '2', '0000-00-00'),
(979, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(980, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(981, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(982, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(983, '00:00:00', '00:00:00', '0', NULL, NULL, 390, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(984, '00:16:44', '00:33:28', '2', '2019-04-17', '2019-04-17', 391, 1, 3, '2019-04-17 16:42:37', '2019-04-17 17:15:10', 0, 1, '0', '2019-04-17'),
(985, '09:30:05', '19:00:09', '2', '2019-04-22', '2019-04-23', 391, 2, 3, '2019-04-22 11:42:03', '2019-04-23 06:42:12', 0, 2, '0', '2019-04-23'),
(986, '00:02:07', '00:04:13', '2', '2019-04-23', '2019-04-23', 391, 3, 3, '2019-04-23 09:02:15', '2019-04-23 09:02:39', 0, 3, '0', '2019-04-23'),
(987, '01:12:01', '02:24:02', '2', '2019-04-23', '2019-04-23', 391, 4, 3, '2019-04-23 11:04:42', '2019-04-23 13:28:44', 0, 4, '0', '2019-04-23'),
(988, '00:00:11', '00:00:21', '2', '2019-04-24', '2019-04-24', 391, 5, 3, '2019-04-24 06:49:39', '2019-04-24 06:50:00', 0, 5, '0', '2019-04-24'),
(989, '00:00:06', '00:00:12', '2', '2019-04-24', '2019-04-24', 391, 7, 3, '2019-04-24 11:45:09', '2019-04-24 11:45:21', 0, 7, '0', '2019-04-24'),
(990, '00:00:05', '00:00:09', '2', '2019-04-24', '2019-04-24', 391, 8, 3, '2019-04-24 11:45:38', '2019-04-24 11:45:47', 0, 8, '0', '2019-04-24'),
(991, '00:00:04', '00:00:08', '2', '2019-04-24', '2019-04-24', 391, 10, 3, '2019-04-24 11:46:06', '2019-04-24 11:46:14', 0, 9, '0', '2019-04-24'),
(992, '00:17:10', '00:34:19', '2', '2019-04-24', '2019-04-24', 391, 6, 3, '2019-04-24 06:52:27', '2019-04-24 07:26:46', 0, 6, '0', '2019-04-24'),
(993, '03:41:33', '18:27:44', '5', '2019-04-16', '2019-04-17', 392, 1, 3, '2019-04-16 16:22:11', '2019-04-17 10:49:55', 0, 1, '0', '2019-04-17'),
(994, '00:03:37', '00:18:07', '5', '2019-04-22', '2019-04-22', 392, 2, 3, '2019-04-22 11:13:31', '2019-04-22 11:31:38', 0, 2, '0', '2019-04-22'),
(995, '00:03:17', '00:16:24', '5', '2019-04-22', '2019-04-22', 392, 3, 3, '2019-04-22 14:54:52', '2019-04-22 15:11:16', 0, 3, '0', '2019-04-22'),
(996, '00:08:32', '00:42:42', '5', '2019-04-22', '2019-04-22', 392, 4, 3, '2019-04-22 15:23:46', '2019-04-22 16:06:28', 0, 4, '0', '2019-04-22'),
(997, '00:00:03', '00:00:14', '5', '2019-04-23', '2019-04-23', 392, 5, 3, '2019-04-23 06:16:45', '2019-04-23 06:16:59', 0, 5, '0', '2019-04-23'),
(998, '00:00:00', '00:00:00', '0', NULL, NULL, 392, 7, 1, NULL, NULL, 0, 7, '5', '0000-00-00'),
(999, '00:00:00', '00:00:00', '0', NULL, NULL, 392, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1000, '00:00:00', '00:00:00', '0', NULL, NULL, 392, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1001, '00:28:30', '02:22:31', '5', '2019-04-23', '2019-04-23', 392, 6, 3, '2019-04-23 12:08:20', '2019-04-23 12:10:51', 0, 6, '0', '2019-04-23'),
(1002, '00:02:05', '00:02:05', '1', '2019-04-17', '2019-04-17', 393, 1, 3, '2019-04-17 11:54:40', '2019-04-17 11:56:45', 0, 1, '0', '2019-04-17'),
(1003, '00:00:12', '00:00:12', '1', '2019-04-23', '2019-04-23', 393, 3, 3, '2019-04-23 12:12:56', '2019-04-23 12:13:08', 0, 2, '0', '2019-04-23'),
(1004, '00:00:10', '00:00:10', '1', '2019-04-23', '2019-04-23', 393, 4, 3, '2019-04-23 12:13:56', '2019-04-23 12:14:06', 0, 3, '0', '2019-04-23'),
(1005, '00:00:10', '00:00:10', '1', '2019-04-23', '2019-04-23', 393, 5, 3, '2019-04-23 12:14:34', '2019-04-23 12:14:44', 0, 4, '0', '2019-04-23'),
(1006, '00:00:09', '00:00:09', '1', '2019-04-23', '2019-04-23', 393, 6, 3, '2019-04-23 12:15:08', '2019-04-23 12:15:17', 0, 5, '0', '2019-04-23'),
(1007, '00:40:18', '00:40:18', '1', '2019-04-23', '2019-04-23', 393, 7, 3, '2019-04-23 12:56:37', '2019-04-23 12:56:49', 0, 6, '0', '2019-04-23'),
(1008, '00:00:23', '00:00:23', '1', '2019-04-23', '2019-04-23', 393, 8, 3, '2019-04-23 12:58:20', '2019-04-23 12:58:43', 0, 7, '0', '2019-04-23'),
(1009, '00:00:15', '00:00:15', '1', '2019-04-23', '2019-04-23', 393, 10, 3, '2019-04-23 12:59:48', '2019-04-23 13:00:03', 0, 8, '0', '2019-04-23'),
(1010, '00:01:12', '00:59:44', '50', '2019-04-17', '2019-04-23', 394, 1, 3, '2019-04-23 12:55:27', '2019-04-23 13:53:09', 0, 1, '0', '2019-04-23'),
(1011, '00:00:01', '00:01:11', '50', '2019-04-23', '2019-04-25', 394, 2, 3, '2019-04-25 08:03:24', '2019-04-25 08:03:51', 0, 2, '0', '2019-04-25'),
(1012, '00:00:19', '00:15:35', '50', '2019-04-25', '2019-04-25', 394, 3, 3, '2019-04-25 08:06:09', '2019-04-25 08:21:44', 0, 3, '0', '2019-04-25'),
(1013, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 4, 1, NULL, NULL, 0, 4, '50', '0000-00-00'),
(1014, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1015, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1016, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1017, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1018, '00:00:00', '00:00:00', '0', NULL, NULL, 394, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1019, '00:16:25', '00:32:50', '2', '2019-04-17', '2019-04-17', 395, 1, 3, '2019-04-17 16:42:31', '2019-04-17 17:15:21', 0, 1, '0', '2019-04-17'),
(1020, '09:44:49', '19:29:38', '2', '2019-04-22', '2019-04-23', 395, 2, 3, '2019-04-22 11:13:17', '2019-04-23 06:42:55', 0, 2, '0', '2019-04-23'),
(1021, '00:03:33', '00:07:06', '2', '2019-04-23', '2019-04-23', 395, 3, 3, '2019-04-23 09:02:24', '2019-04-23 09:02:50', 0, 3, '0', '2019-04-23'),
(1022, '01:12:13', '02:24:26', '2', '2019-04-23', '2019-04-23', 395, 4, 3, '2019-04-23 11:04:29', '2019-04-23 13:28:55', 0, 4, '0', '2019-04-23'),
(1023, '00:00:08', '00:00:15', '2', '2019-04-24', '2019-04-24', 395, 5, 3, '2019-04-24 06:50:25', '2019-04-24 06:50:40', 0, 5, '0', '2019-04-24'),
(1024, '00:00:00', '00:00:00', '0', NULL, NULL, 395, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1025, '00:00:00', '00:00:00', '0', NULL, NULL, 395, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1026, '00:00:00', '00:00:00', '0', NULL, NULL, 395, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1027, '00:00:00', '00:00:12', '0', '2019-04-24', NULL, 395, 6, 2, '2019-04-24 11:56:48', '2019-04-24 11:57:00', 0, 6, '2', '0000-00-00'),
(1028, '00:04:07', '00:20:35', '5', '2019-04-22', '2019-04-22', 397, 1, 3, '2019-04-22 10:10:06', '2019-04-22 10:30:41', 0, 1, '0', '2019-04-22'),
(1029, '00:03:04', '00:15:22', '5', '2019-04-22', '2019-04-22', 397, 3, 3, '2019-04-22 14:55:18', '2019-04-22 15:10:40', 0, 2, '0', '2019-04-22'),
(1030, '02:59:04', '14:55:19', '5', '2019-04-22', '2019-04-23', 397, 4, 3, '2019-04-23 07:18:34', '2019-04-23 07:19:31', 0, 3, '0', '2019-04-23'),
(1031, '00:00:06', '00:00:30', '5', '2019-04-23', '2019-04-23', 397, 5, 3, '2019-04-23 10:46:47', '2019-04-23 10:47:17', 0, 4, '0', '2019-04-23'),
(1032, '00:00:11', '00:00:57', '5', '2019-04-23', '2019-04-23', 397, 6, 3, '2019-04-23 14:04:11', '2019-04-23 14:04:25', 0, 5, '0', '2019-04-23'),
(1033, '00:00:00', '00:00:00', '0', NULL, NULL, 397, 7, 1, NULL, NULL, 0, 6, '5', '0000-00-00'),
(1034, '00:00:00', '00:00:00', '0', NULL, NULL, 397, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1035, '00:00:00', '00:00:00', '0', NULL, NULL, 397, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1036, '00:03:58', '00:19:49', '5', '2019-04-22', '2019-04-22', 398, 1, 3, '2019-04-22 10:10:36', '2019-04-22 10:30:25', 0, 1, '0', '2019-04-22'),
(1037, '00:03:09', '00:15:46', '5', '2019-04-22', '2019-04-22', 398, 3, 3, '2019-04-22 14:55:07', '2019-04-22 15:10:53', 0, 2, '0', '2019-04-22'),
(1038, '02:59:00', '14:54:59', '5', '2019-04-22', '2019-04-23', 398, 4, 3, '2019-04-23 07:18:44', '2019-04-23 07:19:15', 0, 3, '0', '2019-04-23'),
(1039, '00:00:07', '00:00:36', '5', '2019-04-23', '2019-04-23', 398, 5, 3, '2019-04-23 10:46:54', '2019-04-23 10:47:30', 0, 4, '0', '2019-04-23'),
(1040, '00:03:35', '00:17:54', '5', '2019-04-23', '2019-04-23', 398, 6, 3, '2019-04-23 14:03:52', '2019-04-23 14:04:49', 0, 5, '0', '2019-04-23'),
(1041, '00:00:00', '00:00:00', '0', NULL, NULL, 398, 7, 1, NULL, NULL, 0, 6, '5', '0000-00-00'),
(1042, '00:00:00', '00:00:00', '0', NULL, NULL, 398, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1043, '00:00:00', '00:00:00', '0', NULL, NULL, 398, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1044, '00:00:00', '01:05:31', '588', '2019-04-23', NULL, 399, 1, 2, '2019-04-24 09:21:12', '2019-04-24 09:21:24', 0, 1, '1412', '0000-00-00'),
(1045, '00:00:00', '02:36:45', '588', '2019-04-23', NULL, 399, 3, 2, '2019-04-24 13:46:18', '2019-04-24 13:49:15', 0, 2, '0', '0000-00-00'),
(1046, '00:00:00', '00:01:07', '588', '2019-04-25', NULL, 399, 4, 2, '2019-04-25 09:18:12', '2019-04-25 09:19:19', 0, 3, '0', '0000-00-00'),
(1047, '00:00:00', '00:04:55', '588', '2019-04-25', NULL, 399, 5, 2, '2019-04-25 09:19:52', '2019-04-25 09:24:47', 0, 4, '0', '0000-00-00'),
(1048, '00:00:00', '00:00:00', '0', NULL, NULL, 399, 6, 1, NULL, NULL, 0, 5, '588', '0000-00-00'),
(1049, '00:00:00', '00:00:00', '0', NULL, NULL, 399, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1050, '00:00:00', '00:00:00', '0', NULL, NULL, 399, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1051, '00:00:00', '00:00:00', '0', NULL, NULL, 399, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1052, '00:00:00', '03:12:18', '1728', '2019-04-22', NULL, 400, 1, 2, '2019-04-22 11:26:46', '2019-04-22 14:39:04', 0, 1, '2272', '0000-00-00'),
(1053, '00:00:00', '16:15:52', '1728', '2019-04-23', NULL, 400, 3, 2, '2019-04-24 15:46:11', '2019-04-25 06:47:53', 0, 2, '0', '0000-00-00'),
(1054, '00:00:00', '00:00:47', '1728', '2019-04-25', NULL, 400, 4, 2, '2019-04-25 06:50:14', '2019-04-25 06:51:01', 0, 3, '0', '0000-00-00'),
(1055, '00:00:00', '00:00:13', '1728', '2019-04-25', NULL, 400, 5, 2, '2019-04-25 06:54:50', '2019-04-25 06:55:03', 0, 4, '0', '0000-00-00'),
(1056, '00:00:00', '00:00:00', '0', NULL, NULL, 400, 6, 1, NULL, NULL, 0, 5, '1728', '0000-00-00'),
(1057, '00:00:00', '00:00:00', '0', NULL, NULL, 400, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1058, '00:00:00', '00:00:00', '0', NULL, NULL, 400, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1059, '00:00:00', '00:00:00', '0', NULL, NULL, 400, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1060, '00:00:47', '00:55:14', '70', '2019-04-25', '2019-04-25', 401, 1, 3, '2019-04-25 08:11:23', '2019-04-25 09:06:37', 0, 1, '0', '2019-04-25'),
(1061, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 2, 1, NULL, NULL, 0, 2, '70', '0000-00-00'),
(1062, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00');
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`, `mes_de_corte`) VALUES
(1063, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1064, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1065, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1066, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1067, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1068, '00:00:00', '00:00:00', '0', NULL, NULL, 401, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1069, '00:03:36', '00:36:02', '10', '2019-04-23', '2019-04-23', 402, 1, 3, '2019-04-23 08:15:24', '2019-04-23 08:51:26', 0, 1, '0', '2019-04-23'),
(1070, '02:55:30', '29:15:04', '10', '2019-04-23', '2019-04-25', 402, 2, 3, '2019-04-24 06:50:41', '2019-04-25 06:55:55', 0, 2, '0', '2019-04-25'),
(1071, '00:00:36', '00:06:04', '10', '2019-04-25', '2019-04-25', 402, 3, 3, '2019-04-25 08:00:19', '2019-04-25 08:06:23', 0, 3, '0', '2019-04-25'),
(1072, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 4, 1, NULL, NULL, 0, 4, '10', '0000-00-00'),
(1073, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1074, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1075, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1076, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1077, '00:00:00', '00:00:00', '0', NULL, NULL, 402, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1078, '00:01:36', '00:23:53', '15', '2019-04-23', '2019-04-23', 403, 1, 3, '2019-04-23 14:20:24', '2019-04-23 14:44:17', 0, 1, '0', '2019-04-23'),
(1079, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 3, 1, NULL, NULL, 0, 2, '15', '0000-00-00'),
(1080, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1081, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1082, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1083, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1084, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1085, '00:00:00', '00:00:00', '0', NULL, NULL, 403, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1086, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 1, 1, NULL, NULL, 0, 1, '60', '0000-00-00'),
(1087, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1088, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1089, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1090, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1091, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1092, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1093, '00:00:00', '00:00:00', '0', NULL, NULL, 404, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1098, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 1, 1, NULL, NULL, 0, 1, '50', '0000-00-00'),
(1099, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1100, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1101, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1102, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1103, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1104, '00:00:00', '00:00:00', '0', NULL, NULL, 406, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1105, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 1, 1, NULL, NULL, 0, 1, '50', '0000-00-00'),
(1106, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1107, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1108, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1109, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1110, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1111, '00:00:00', '00:00:00', '0', NULL, NULL, 409, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1112, '00:00:00', '00:00:00', '0', NULL, NULL, 405, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1113, '00:00:00', '00:00:00', '0', NULL, NULL, 405, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1114, '00:00:00', '00:00:00', '0', NULL, NULL, 405, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1115, '00:00:00', '00:00:00', '0', NULL, NULL, 405, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1116, '00:01:10', '00:34:53', '30', '2019-04-24', '2019-04-24', 414, 1, 3, '2019-04-24 11:29:37', '2019-04-24 12:04:30', 0, 1, '0', '2019-04-24'),
(1117, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 2, 1, NULL, NULL, 0, 2, '30', '0000-00-00'),
(1118, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1119, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1120, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1121, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1122, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1123, '00:00:00', '00:00:00', '0', NULL, NULL, 414, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1124, '00:00:00', '00:00:00', '0', NULL, NULL, 294, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1125, '00:00:00', '00:00:00', '0', NULL, NULL, 294, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1126, '00:00:00', '00:00:00', '0', NULL, NULL, 294, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1127, '00:00:00', '00:00:00', '0', NULL, NULL, 294, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1128, '00:04:37', '00:13:51', '3', '2019-04-22', '2019-04-22', 415, 1, 3, '2019-04-22 15:24:38', '2019-04-22 15:38:29', 0, 1, '0', '2019-04-22'),
(1129, '01:10:13', '03:30:40', '3', '2019-04-23', '2019-04-23', 415, 2, 3, '2019-04-23 10:45:40', '2019-04-23 14:16:20', 0, 2, '0', '2019-04-23'),
(1130, '00:00:03', '00:00:09', '3', '2019-04-23', '2019-04-23', 415, 3, 3, '2019-04-23 14:17:06', '2019-04-23 14:17:15', 0, 3, '0', '2019-04-23'),
(1131, '00:00:06', '00:00:19', '3', '2019-04-24', '2019-04-24', 415, 4, 3, '2019-04-24 07:43:16', '2019-04-24 07:43:35', 0, 4, '0', '2019-04-24'),
(1132, '00:03:28', '00:10:23', '3', '2019-04-24', '2019-04-24', 415, 5, 3, '2019-04-24 08:22:43', '2019-04-24 08:33:06', 0, 5, '0', '2019-04-24'),
(1133, '00:00:03', '00:00:10', '3', '2019-04-24', '2019-04-24', 415, 7, 3, '2019-04-24 11:46:32', '2019-04-24 11:46:42', 0, 7, '0', '2019-04-24'),
(1134, '00:00:03', '00:00:10', '3', '2019-04-24', '2019-04-24', 415, 8, 3, '2019-04-24 11:46:56', '2019-04-24 11:47:06', 0, 8, '0', '2019-04-24'),
(1135, '00:00:04', '00:00:12', '3', '2019-04-24', '2019-04-24', 415, 10, 3, '2019-04-24 11:47:21', '2019-04-24 11:47:33', 0, 9, '0', '2019-04-24'),
(1136, '00:24:42', '01:14:05', '3', '2019-04-24', '2019-04-24', 415, 6, 3, '2019-04-24 09:33:12', '2019-04-24 10:47:17', 0, 6, '0', '2019-04-24'),
(1137, '00:28:42', '00:57:23', '2', '2019-04-23', '2019-04-23', 416, 1, 3, '2019-04-23 12:56:05', '2019-04-23 13:53:02', 0, 1, '0', '2019-04-23'),
(1138, '00:00:42', '00:01:23', '2', '2019-04-24', '2019-04-24', 416, 2, 3, '2019-04-24 06:40:43', '2019-04-24 06:41:07', 0, 2, '0', '2019-04-24'),
(1139, '00:00:06', '00:00:11', '2', '2019-04-24', '2019-04-24', 416, 3, 3, '2019-04-24 06:46:50', '2019-04-24 06:47:01', 0, 3, '0', '2019-04-24'),
(1140, '00:00:11', '00:00:22', '2', '2019-04-24', '2019-04-24', 416, 4, 3, '2019-04-24 06:47:19', '2019-04-24 06:47:41', 0, 4, '0', '2019-04-24'),
(1141, '00:00:16', '00:00:32', '2', '2019-04-24', '2019-04-24', 416, 5, 3, '2019-04-24 06:48:08', '2019-04-24 06:48:40', 0, 5, '0', '2019-04-24'),
(1142, '00:00:00', '00:00:00', '0', NULL, NULL, 416, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1143, '00:00:00', '00:00:00', '0', NULL, NULL, 416, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1144, '00:00:00', '00:00:00', '0', NULL, NULL, 416, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1145, '00:00:00', '00:00:00', '0', NULL, NULL, 416, 6, 1, NULL, NULL, 0, 6, '2', '0000-00-00'),
(1146, '00:04:26', '00:22:11', '5', '2019-04-24', '2019-04-24', 417, 1, 3, '2019-04-24 07:37:52', '2019-04-24 07:38:02', 0, 1, '0', '2019-04-24'),
(1147, '00:00:07', '00:00:36', '5', '2019-04-25', '2019-04-25', 417, 2, 3, '2019-04-25 07:36:21', '2019-04-25 07:36:57', 0, 2, '0', '2019-04-25'),
(1148, '00:00:17', '00:01:27', '5', '2019-04-25', '2019-04-25', 417, 3, 3, '2019-04-25 07:38:06', '2019-04-25 07:39:33', 0, 3, '0', '2019-04-25'),
(1149, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 4, 1, NULL, NULL, 0, 4, '5', '0000-00-00'),
(1150, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1151, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1152, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1153, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1154, '00:00:00', '00:00:00', '0', NULL, NULL, 417, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1155, '00:04:19', '00:04:19', '1', '2019-04-22', '2019-04-22', 418, 1, 3, '2019-04-22 15:11:28', '2019-04-22 15:15:47', 0, 1, '0', '2019-04-22'),
(1156, '19:53:17', '19:53:17', '1', '2019-04-22', '2019-04-23', 418, 2, 3, '2019-04-22 16:18:43', '2019-04-23 12:12:00', 0, 2, '0', '2019-04-23'),
(1157, '00:00:44', '00:00:44', '1', '2019-04-23', '2019-04-23', 418, 3, 3, '2019-04-23 12:12:36', '2019-04-23 12:13:20', 0, 3, '0', '2019-04-23'),
(1158, '00:00:12', '00:00:12', '1', '2019-04-23', '2019-04-23', 418, 4, 3, '2019-04-23 12:13:37', '2019-04-23 12:13:49', 0, 4, '0', '2019-04-23'),
(1159, '00:00:09', '00:00:09', '1', '2019-04-23', '2019-04-23', 418, 5, 3, '2019-04-23 12:14:22', '2019-04-23 12:14:31', 0, 5, '0', '2019-04-23'),
(1160, '00:00:00', '00:00:00', '0', NULL, NULL, 418, 7, 1, NULL, NULL, 0, 7, '1', '0000-00-00'),
(1161, '00:00:00', '00:00:00', '0', NULL, NULL, 418, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1162, '00:00:00', '00:00:00', '0', NULL, NULL, 418, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1163, '00:06:59', '00:06:59', '1', '2019-04-23', '2019-04-23', 418, 6, 3, '2019-04-23 12:15:12', '2019-04-23 12:22:02', 0, 6, '0', '2019-04-23'),
(1164, '00:11:06', '00:22:12', '2', '2019-04-24', '2019-04-24', 419, 1, 3, '2019-04-24 06:49:50', '2019-04-24 07:12:02', 0, 1, '0', '2019-04-24'),
(1165, '00:07:27', '00:14:54', '2', '2019-04-24', '2019-04-24', 419, 3, 3, '2019-04-24 14:11:22', '2019-04-24 14:26:16', 0, 2, '0', '2019-04-24'),
(1166, '00:00:06', '00:00:11', '2', '2019-04-25', '2019-04-25', 419, 4, 3, '2019-04-25 08:36:29', '2019-04-25 08:36:40', 0, 3, '0', '2019-04-25'),
(1167, '00:00:29', '00:00:58', '2', '2019-04-25', '2019-04-25', 419, 5, 3, '2019-04-25 09:10:20', '2019-04-25 09:11:18', 0, 4, '0', '2019-04-25'),
(1168, '00:00:00', '00:00:00', '0', NULL, NULL, 419, 6, 1, NULL, NULL, 0, 5, '2', '0000-00-00'),
(1169, '00:00:00', '00:00:00', '0', NULL, NULL, 419, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1170, '00:00:00', '00:00:00', '0', NULL, NULL, 419, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1171, '00:00:00', '00:00:00', '0', NULL, NULL, 419, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1172, '00:02:41', '00:53:30', '20', '2019-04-24', '2019-04-24', 420, 1, 3, '2019-04-24 10:32:33', '2019-04-24 11:26:03', 0, 1, '0', '2019-04-24'),
(1173, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 3, 1, NULL, NULL, 0, 2, '20', '0000-00-00'),
(1174, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1175, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1176, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1177, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1178, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1179, '00:00:00', '00:00:00', '0', NULL, NULL, 420, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1180, '00:02:41', '00:53:44', '20', '2019-04-24', '2019-04-24', 421, 1, 3, '2019-04-24 10:32:28', '2019-04-24 11:26:12', 0, 1, '0', '2019-04-24'),
(1181, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 3, 1, NULL, NULL, 0, 2, '20', '0000-00-00'),
(1182, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1183, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1184, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1185, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1186, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1187, '00:00:00', '00:00:00', '0', NULL, NULL, 421, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1188, '00:00:13', '00:00:26', '2', '2019-04-24', '2019-04-24', 422, 1, 3, '2019-04-24 06:55:22', '2019-04-24 06:55:48', 0, 1, '0', '2019-04-24'),
(1189, '00:00:17', '00:00:34', '2', '2019-04-25', '2019-04-25', 422, 2, 3, '2019-04-25 07:36:05', '2019-04-25 07:36:39', 0, 2, '0', '2019-04-25'),
(1190, '00:00:32', '00:01:04', '2', '2019-04-25', '2019-04-25', 422, 3, 3, '2019-04-25 07:37:54', '2019-04-25 07:38:58', 0, 3, '0', '2019-04-25'),
(1191, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 4, 1, NULL, NULL, 0, 4, '2', '0000-00-00'),
(1192, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1193, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1194, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1195, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1196, '00:00:00', '00:00:00', '0', NULL, NULL, 422, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1197, '00:04:24', '00:44:04', '10', '2019-04-23', '2019-04-23', 426, 1, 3, '2019-04-23 15:37:49', '2019-04-23 16:21:53', 0, 1, '0', '2019-04-23'),
(1198, '00:00:00', '00:00:00', '0', '2019-04-24', NULL, 426, 2, 4, '2019-04-24 07:26:41', NULL, 1, 2, '10', '0000-00-00'),
(1199, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1200, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1201, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1202, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1203, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1204, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1205, '00:00:00', '00:00:00', '0', NULL, NULL, 426, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1206, '00:00:34', '00:28:32', '50', '2019-04-24', '2019-04-24', 427, 1, 3, '2019-04-24 13:11:37', '2019-04-24 13:40:09', 0, 1, '0', '2019-04-24'),
(1207, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 2, 1, NULL, NULL, 0, 2, '50', '0000-00-00'),
(1208, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1209, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1210, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1211, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1212, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1213, '00:00:00', '00:00:00', '0', NULL, NULL, 427, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1214, '00:00:40', '00:19:53', '30', '2019-04-24', '2019-04-24', 428, 1, 3, '2019-04-24 14:38:12', '2019-04-24 14:58:05', 0, 1, '0', '2019-04-24'),
(1215, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 2, 1, NULL, NULL, 0, 2, '30', '0000-00-00'),
(1216, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1217, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1218, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1219, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1220, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1221, '00:00:00', '00:00:00', '0', NULL, NULL, 428, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1222, '00:00:38', '00:19:13', '30', '2019-04-24', '2019-04-24', 429, 1, 3, '2019-04-24 15:12:20', '2019-04-24 15:31:33', 0, 1, '0', '2019-04-24'),
(1223, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 2, 1, NULL, NULL, 0, 2, '30', '0000-00-00'),
(1224, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1225, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1226, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1227, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1228, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1229, '00:00:00', '00:00:00', '0', NULL, NULL, 429, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1230, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 1, 1, NULL, NULL, 0, 1, '15', '0000-00-00'),
(1231, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1232, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1233, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1234, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1235, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1236, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1237, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1238, '00:00:00', '00:00:00', '0', NULL, NULL, 430, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1239, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1240, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1241, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1242, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1243, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1244, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1245, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1246, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1247, '00:00:00', '00:00:00', '0', NULL, NULL, 431, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1248, '00:01:47', '00:44:40', '25', '2019-04-24', '2019-04-24', 432, 1, 3, '2019-04-24 12:23:48', '2019-04-24 13:08:28', 0, 1, '0', '2019-04-24'),
(1249, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 2, 1, NULL, NULL, 0, 2, '25', '0000-00-00'),
(1250, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1251, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1252, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1253, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1254, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1255, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1256, '00:00:00', '00:00:00', '0', NULL, NULL, 432, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1257, '00:11:10', '00:11:10', '1', '2019-04-24', '2019-04-24', 433, 1, 3, '2019-04-24 10:13:03', '2019-04-24 10:24:13', 0, 1, '0', '2019-04-24'),
(1258, '00:00:19', '00:00:19', '1', '2019-04-24', '2019-04-24', 433, 2, 3, '2019-04-24 13:46:13', '2019-04-24 13:46:32', 0, 2, '0', '2019-04-24'),
(1259, '00:36:30', '00:36:30', '1', '2019-04-25', '2019-04-25', 433, 3, 3, '2019-04-25 08:09:19', '2019-04-25 08:45:49', 0, 3, '0', '2019-04-25'),
(1260, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 4, 1, NULL, NULL, 0, 4, '1', '0000-00-00'),
(1261, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1262, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1263, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1264, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1265, '00:00:00', '00:00:00', '0', NULL, NULL, 433, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1266, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 1, 1, NULL, NULL, 0, 1, '6', '0000-00-00'),
(1267, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1268, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1269, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1270, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1271, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1272, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1273, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1274, '00:00:00', '00:00:00', '0', NULL, NULL, 434, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1275, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(1276, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1277, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1278, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1279, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1280, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1281, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1282, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1283, '00:00:00', '00:00:00', '0', NULL, NULL, 435, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1284, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1285, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1286, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1287, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1288, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1289, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1290, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1291, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1292, '00:00:00', '00:00:00', '0', NULL, NULL, 436, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1293, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 1, 1, NULL, NULL, 0, 1, '800', '0000-00-00'),
(1294, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1295, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1296, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1297, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1298, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1299, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1300, '00:00:00', '00:00:00', '0', NULL, NULL, 437, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1301, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 1, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(1302, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1303, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1304, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1305, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1306, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1307, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 9, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1308, '00:00:00', '00:00:00', '0', NULL, NULL, 438, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1309, '00:00:00', '00:00:00', '0', NULL, NULL, 439, 1, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1310, '00:00:00', '00:00:00', '0', NULL, NULL, 439, 4, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(1311, '00:00:00', '00:00:00', '0', NULL, NULL, 439, 10, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1312, '00:00:00', '00:00:00', '0', NULL, NULL, 440, 1, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1313, '00:00:00', '00:00:00', '0', NULL, NULL, 440, 4, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(1314, '00:00:00', '00:00:00', '0', NULL, NULL, 440, 10, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1319, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 1, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(1320, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1321, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1322, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1323, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1324, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1325, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1326, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1327, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 9, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1328, '00:00:00', '00:00:00', '0', NULL, NULL, 442, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(1329, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 1, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(1330, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1331, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1332, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1333, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 6, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1334, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 7, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1335, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 8, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1336, '00:00:00', '00:00:00', '0', NULL, NULL, 443, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1337, '00:00:00', '00:00:00', '0', NULL, NULL, 441, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1338, '00:00:00', '00:00:00', '0', NULL, NULL, 441, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1339, '00:00:00', '00:00:00', '0', NULL, NULL, 441, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1340, '00:00:00', '00:00:00', '0', NULL, NULL, 441, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1377, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 1, 1, NULL, NULL, 0, 1, '10', '0000-00-00'),
(1378, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1379, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1380, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1381, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1382, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1383, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1384, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 10, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1385, '00:00:00', '00:00:00', '0', NULL, NULL, 457, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1386, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 1, 1, NULL, NULL, 0, 1, '1', '0000-00-00'),
(1387, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1388, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1389, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1390, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1391, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1392, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 9, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1393, '00:00:00', '00:00:00', '0', NULL, NULL, 458, 10, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1394, '00:00:00', '00:00:00', '0', NULL, NULL, 459, 1, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1395, '00:00:00', '00:00:00', '0', NULL, NULL, 459, 4, 1, NULL, NULL, 0, 1, '2', '0000-00-00'),
(1396, '00:00:00', '00:00:00', '0', NULL, NULL, 459, 10, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1397, '00:00:00', '00:00:00', '0', NULL, NULL, 460, 1, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1398, '00:00:00', '00:00:00', '0', NULL, NULL, 460, 4, 1, NULL, NULL, 0, 1, '3', '0000-00-00'),
(1399, '00:00:00', '00:00:00', '0', NULL, NULL, 460, 10, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1404, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 1, 1, NULL, NULL, 0, 1, '5', '0000-00-00'),
(1405, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 2, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1406, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 3, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1407, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 4, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1408, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 5, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1409, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 6, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1410, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 7, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1411, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 8, 1, NULL, NULL, 0, 8, '0', '0000-00-00'),
(1412, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 9, 1, NULL, NULL, 0, 9, '0', '0000-00-00'),
(1413, '00:00:00', '00:00:00', '0', NULL, NULL, 462, 10, 1, NULL, NULL, 0, 10, '0', '0000-00-00'),
(1414, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 1, 1, NULL, NULL, 0, 1, '6', '0000-00-00'),
(1415, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1416, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1417, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00'),
(1418, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 7, 1, NULL, NULL, 0, 5, '0', '0000-00-00'),
(1419, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 8, 1, NULL, NULL, 0, 6, '0', '0000-00-00'),
(1420, '00:00:00', '00:00:00', '0', NULL, NULL, 463, 10, 1, NULL, NULL, 0, 7, '0', '0000-00-00'),
(1421, '00:00:00', '00:00:00', '0', NULL, NULL, 461, 1, 1, NULL, NULL, 0, 1, '4', '0000-00-00'),
(1422, '00:00:00', '00:00:00', '0', NULL, NULL, 461, 3, 1, NULL, NULL, 0, 2, '0', '0000-00-00'),
(1423, '00:00:00', '00:00:00', '0', NULL, NULL, 461, 4, 1, NULL, NULL, 0, 3, '0', '0000-00-00'),
(1424, '00:00:00', '00:00:00', '0', NULL, NULL, 461, 5, 1, NULL, NULL, 0, 4, '0', '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_proyecto`
--

CREATE TABLE `detalle_proyecto` (
  `idDetalle_proyecto` int(11) NOT NULL,
  `idProducto` tinyint(4) NOT NULL,
  `canitadad_total` varchar(6) NOT NULL,
  `material` varchar(6) DEFAULT NULL,
  `proyecto_numero_orden` int(11) NOT NULL,
  `idArea` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  `PNC` tinyint(1) NOT NULL,
  `ubicacion` varchar(25) DEFAULT NULL,
  `pro_porIniciar` tinyint(10) DEFAULT '0',
  `pro_Ejecucion` tinyint(10) DEFAULT '0',
  `pro_Pausado` tinyint(10) DEFAULT '0',
  `pro_Terminado` tinyint(10) DEFAULT '0',
  `tiempo_total` varchar(20) NOT NULL DEFAULT '00:00:00',
  `Total_timepo_Unidad` varchar(20) NOT NULL DEFAULT '00:00:00',
  `fecha_salida` datetime DEFAULT NULL,
  `lider_proyecto` varchar(13) DEFAULT NULL,
  `antisolder` varchar(2) NOT NULL DEFAULT '0',
  `ruteo` tinyint(1) DEFAULT '0',
  `mes_de_corte` varchar(10) NOT NULL DEFAULT '0000-00-00',
  `cantidad_terminada` varchar(6) NOT NULL DEFAULT '0',
  `fecha_terminacion_cantidad` varchar(10) DEFAULT NULL,
  `idEspesor` tinyint(3) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `idProducto`, `canitadad_total`, `material`, `proyecto_numero_orden`, `idArea`, `estado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`, `lider_proyecto`, `antisolder`, `ruteo`, `mes_de_corte`, `cantidad_terminada`, `fecha_terminacion_cantidad`, `idEspesor`) VALUES
(61, 1, '2', '', 32329, 3, 3, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, '44006996', '0', 0, '2019-04-02', '0', NULL, 0),
(68, 1, '200', NULL, 32124, 3, 2, 0, NULL, 0, 0, 2, 2, '201:50:19', '00:00:00', NULL, '43605625', '', 0, '2019-04-02', '100', '30/03/2019', 0),
(88, 1, '3', '', 32456, 3, 3, 0, NULL, 2, 0, 0, 2, '00:51:06', '00:00:00', NULL, '43542658', '0', 0, '2019-04-02', '0', NULL, 0),
(132, 1, '12', '', 32494, 3, 3, 0, NULL, 1, 0, 2, 1, '62:38:20', '00:00:00', NULL, '1017187557', '0', 0, '2019-04-02', '9', '2019-04-05', 0),
(136, 1, '40', '', 32470, 3, 3, 0, NULL, 2, 0, 1, 1, '07:16:56', '00:00:00', NULL, '43605625', '0', 0, '2019-04-02', '0', NULL, 0),
(140, 1, '3', 'TH', 32473, 1, 3, 0, NULL, 8, 0, 0, 2, '00:00:15', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(143, 1, '3', 'TH', 32474, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(150, 1, '10', '', 32497, 3, 3, 0, NULL, 2, 0, 0, 2, '132:41:17', '00:00:00', NULL, '21424773', '0', 0, '2019-04-02', '0', NULL, 0),
(189, 1, '100', 'TH', 32508, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(198, 1, '200', '', 32357, 3, 3, 0, NULL, 1, 1, 0, 2, '01:08:19', '00:00:00', NULL, '43542658', '0', 0, '2019-04-02', '0', NULL, 0),
(200, 1, '100', NULL, 32290, 3, 3, 0, NULL, 2, 0, 1, 1, '10:57:07', '00:00:00', NULL, '1036622270', '', 0, '2019-04-02', '0', NULL, 0),
(206, 1, '14', 'TH', 32515, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(219, 1, '130', 'TH', 32528, 1, 3, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 1, '2019-04-02', '0', NULL, 0),
(220, 1, '50', 'TH', 32529, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(221, 1, '50', 'TH', 32530, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '2019-04-02', '0', NULL, 0),
(222, 1, '30', 'TH', 32533, 1, 3, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 1, '2019-04-02', '0', NULL, 0),
(224, 1, '20', 'TH', 32532, 1, 3, 0, NULL, 7, 0, 0, 2, '00:00:10', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(228, 1, '50', 'TH', 32536, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(229, 1, '50', 'TH', 32537, 1, 3, 0, NULL, 1, 0, 0, 8, '00:54:53', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(232, 1, '2', '', 32539, 3, 3, 0, NULL, 1, 0, 0, 3, '36:27:58', '18:14:00', '2019-04-04 16:16:43', '43542658', '0', 0, '2019-04-04', '2', '2019-04-04', 0),
(235, 1, '100', 'TH', 32541, 1, 3, 0, NULL, 7, 0, 0, 2, '355:21:09', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(247, 1, '20', 'FV', 32551, 1, 3, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(250, 1, '15', 'FV', 32554, 1, 3, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(258, 1, '1', '', 32558, 3, 3, 0, NULL, 1, 0, 0, 3, '00:03:19', '00:03:19', '2019-04-02 10:48:21', '21424773', '0', 0, '2019-04-02', '1', '2019-04-02', 0),
(261, 1, '15', 'TH', 32565, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(263, 1, '3', 'TH', 32476, 1, 3, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(266, 1, '40', 'FV', 32566, 1, 3, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(267, 1, '100', 'FV', 32567, 1, 3, 0, NULL, 3, 0, 0, 5, '02:32:35', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(268, 1, '100', 'FV', 32568, 1, 3, 0, NULL, 1, 0, 0, 7, '00:52:49', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(269, 1, '50', 'FV', 32569, 1, 3, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(270, 1, '50', 'FV', 32570, 1, 3, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(273, 1, '84', 'TH', 32576, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(274, 1, '5', 'FV', 32577, 1, 3, 0, NULL, 0, 0, 0, 8, '01:12:41', '00:14:32', '2019-04-02 15:32:51', NULL, '1', 0, '2019-04-02', '5', '2019-04-02', 0),
(275, 1, '10', 'TH', 32578, 1, 3, 0, NULL, 6, 0, 0, 3, '01:30:36', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(276, 1, '10', 'TH', 32580, 1, 3, 0, NULL, 6, 0, 0, 3, '06:07:38', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(277, 1, '2', 'TH', 32582, 1, 3, 0, NULL, 3, 0, 0, 6, '01:27:07', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(278, 1, '1', 'TH', 32583, 1, 3, 0, NULL, 4, 0, 0, 5, '00:00:29', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(279, 1, '10', 'TH', 32585, 1, 3, 0, NULL, 6, 0, 0, 3, '19:35:16', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(283, 1, '4', 'TH', 32592, 1, 3, 0, NULL, 6, 0, 0, 3, '357:41:14', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(284, 1, '10', 'TH', 32593, 1, 3, 0, NULL, 5, 0, 0, 4, '00:00:47', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(285, 1, '25', 'TH', 32594, 1, 3, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-02', '0', NULL, 0),
(286, 1, '3', 'TH', 32596, 1, 3, 0, NULL, 6, 0, 1, 2, '357:40:09', '00:00:00', NULL, NULL, '1', 0, '2019-04-02', '0', NULL, 0),
(287, 1, '2', 'FV', 32618, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '3', 0, '2019-04-04', '0', NULL, 3),
(288, 1, '2', NULL, 32618, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '2019-04-04', '0', NULL, 0),
(289, 1, '40', 'TH', 32619, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 4),
(290, 1, '2', 'TH', 32621, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 4),
(291, 1, '2', 'TH', 32622, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 4),
(292, 1, '10', 'FV', 32626, 1, 2, 0, NULL, 7, 0, 0, 1, '00:01:29', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 1),
(293, 1, '14', NULL, 32515, 3, 3, 0, NULL, 3, 0, 1, 0, '26:23:49', '00:00:00', NULL, '42702332', '0', 0, '2019-04-04', '0', NULL, 0),
(294, 6, '1', '', 31762, 1, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '2019-04-04', '0', NULL, 0),
(295, 1, '100', '', 31762, 3, 3, 0, NULL, 4, 0, 0, 0, '75:45:21', '00:00:00', NULL, '43542658', '0', 0, '2019-04-04', '0', NULL, 0),
(296, 1, '30', 'FV', 32627, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 1),
(297, 1, '2', 'TH', 32628, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 4),
(298, 1, '15', 'TH', 32629, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '2019-04-04', '0', NULL, 4),
(299, 1, '15', NULL, 32629, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '2019-04-04', '0', NULL, 0),
(300, 1, '1', 'TH', 32630, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '2019-04-04', '0', NULL, 4),
(301, 1, '5', 'TH', 32631, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '2019-04-04', '0', NULL, 4),
(302, 1, '10', 'TH', 32352, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '2019-04-04', '0', NULL, 1),
(303, 1, '10', NULL, 32352, 3, 3, 0, NULL, 1, 0, 1, 2, '15:58:49', '00:00:00', NULL, '43542658', '0', 0, '2019-04-04', '0', NULL, 0),
(304, 1, '250', 'TH', 32634, 1, 2, 0, NULL, 7, 0, 0, 1, '01:04:51', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(305, 1, '20', 'TH', 32635, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(306, 1, '5', 'FV', 32636, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(307, 1, '20', NULL, 32532, 3, 3, 0, NULL, 3, 0, 1, 0, '00:00:36', '00:00:00', NULL, '42702332', '0', 0, '0000-00-00', '0', NULL, 0),
(308, 1, '50', NULL, 32499, 3, 3, 0, NULL, 2, 1, 1, 0, '27:02:19', '00:00:00', NULL, '1036622270', '0', 0, '0000-00-00', '0', NULL, 0),
(309, 1, '25', '', 32500, 3, 3, 0, NULL, 3, 0, 0, 1, '86:38:07', '00:00:00', NULL, '43605625', '0', 0, '0000-00-00', '0', NULL, 0),
(310, 1, '1', NULL, 32501, 3, 3, 0, NULL, 3, 1, 0, 0, '00:00:00', '00:00:00', NULL, '23917651', '0', 0, '0000-00-00', '0', NULL, 0),
(311, 1, '1', '', 32502, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, '23917651', '0', 0, '0000-00-00', '0', NULL, 0),
(312, 1, '1', NULL, 32503, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, '23917651', '0', 0, '0000-00-00', '0', NULL, 0),
(313, 1, '25', NULL, 32504, 3, 3, 0, NULL, 3, 1, 0, 0, '82:19:34', '00:00:00', NULL, '21424773', '0', 0, '0000-00-00', '0', NULL, 0),
(314, 1, '50', NULL, 32505, 3, 3, 0, NULL, 2, 1, 0, 1, '85:19:55', '00:00:00', NULL, '44006996', '0', 0, '0000-00-00', '0', NULL, 0),
(315, 1, '25', NULL, 32506, 3, 3, 0, NULL, 2, 1, 1, 0, '33:39:10', '00:00:00', NULL, '1017187557', '0', 0, '0000-00-00', '0', NULL, 0),
(316, 1, '25', NULL, 32507, 3, 3, 0, NULL, 3, 1, 0, 0, '00:00:35', '00:00:00', NULL, '23917651', '0', 0, '0000-00-00', '0', NULL, 0),
(317, 1, '30', 'TH', 32644, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(318, 1, '1', 'TH', 32610, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '0000-00-00', '0', NULL, 4),
(319, 1, '1', NULL, 32610, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(320, 6, '1', '', 326, 1, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(321, 1, '1', 'TH', 326, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(322, 1, '1', '', 326, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(323, 1, '9', 'TH', 32645, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '9', 0, '0000-00-00', '0', NULL, 4),
(324, 1, '5', 'FV', 32648, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 1),
(325, 1, '5', 'TH', 32649, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(326, 1, '5', 'TH', 32650, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(327, 1, '5', 'FV', 32651, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(328, 1, '3', 'TH', 32652, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(329, 1, '2', 'TH', 32653, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(330, 1, '10', 'TH', 32654, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(331, 1, '20', 'FV', 32656, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 3),
(332, 1, '4', 'TH', 32657, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(333, 1, '4', 'TH', 32658, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(334, 1, '100', NULL, 32375, 3, 3, 0, NULL, 1, 1, 2, 0, '183:53:42', '00:00:00', NULL, '42702332', '0', 0, '0000-00-00', '0', NULL, 0),
(335, 1, '3', 'TH', 32624, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 5),
(336, 1, '3', NULL, 32624, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(337, 1, '3', 'TH', 32625, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 5),
(338, 1, '3', NULL, 32625, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(339, 1, '2', 'TH', 32659, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(340, 1, '1', NULL, 32661, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(341, 1, '2', 'TH', 32660, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(342, 1, '1', 'FV', 32663, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 1),
(343, 1, '1', 'FV', 32664, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 1),
(344, 1, '3', 'TH', 32667, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(345, 1, '87', NULL, 32665, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(346, 1, '20', 'TH', 32668, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(347, 1, '20', 'TH', 32669, 1, 2, 0, NULL, 1, 0, 0, 8, '26:07:38', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(348, 1, '6', 'TH', 32670, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(349, 1, '2', 'TH', 32671, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(350, 1, '25', 'FV', 32672, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(351, 1, '2', 'FV', 32673, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 1),
(352, 7, '20', 'TH', 32498, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '2', 0, '0000-00-00', '0', NULL, 1),
(354, 1, '20', '', 32498, 3, 4, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, '1017187557', '0', 0, '0000-00-00', '0', NULL, 0),
(358, 7, '3', 'TH', 32455, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(359, 12, '3', NULL, 32455, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(360, 1, '3', NULL, 32455, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(361, 1, '30', 'TH', 32674, 1, 2, 0, NULL, 6, 0, 0, 3, '03:41:31', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(362, 1, '2', 'TH', 32675, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 4),
(363, 1, '40', 'TH', 32676, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(364, 1, '10', 'FV', 32677, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(365, 1, '2', 'TH', 32678, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(366, 1, '2', NULL, 32472, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(367, 1, '3', NULL, 32473, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(368, 1, '3', NULL, 32474, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(369, 1, '3', NULL, 32475, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(370, 1, '1', 'FV', 32682, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(371, 1, '5', 'TH', 32680, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '6', 0, '0000-00-00', '0', NULL, 1),
(372, 1, '4', 'TH', 32684, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(373, 1, '4', 'FV', 32685, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(374, 1, '6', 'TH', 32686, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(375, 1, '1', 'TH', 32687, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(376, 1, '5', 'TH', 32688, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '3', 0, '0000-00-00', '0', NULL, 4),
(377, 1, '1', 'TH', 32689, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(378, 1, '5', 'TH', 32696, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(379, 1, '150', 'FV', 32697, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 1),
(380, 1, '100', 'FV', 32698, 1, 2, 0, NULL, 1, 0, 0, 6, '16:31:29', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 1),
(381, 1, '2', 'TH', 32699, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(382, 1, '5', 'FV', 32700, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(383, 1, '2', 'TH', 32701, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(384, 1, '6', 'FV', 32703, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(385, 1, '2', 'TH', 32705, 1, 2, 0, NULL, 8, 0, 1, 0, '00:00:01', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(386, 1, '2', 'TH', 32706, 1, 2, 0, NULL, 8, 0, 0, 1, '27:27:31', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(387, 1, '2', 'TH', 32704, 1, 2, 0, NULL, 8, 0, 1, 0, '00:00:23', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(388, 1, '4', 'TH', 32707, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(389, 1, '3', 'TH', 32708, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(390, 1, '2', 'FV', 32709, 1, 3, 0, NULL, 6, 0, 0, 2, '03:10:23', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 1),
(391, 1, '2', 'TH', 32710, 1, 3, 0, NULL, 0, 0, 0, 9, '22:37:01', '11:18:33', '2019-04-24 11:46:14', NULL, '5', 0, '2019-04-24', '2', '2019-04-24', 4),
(392, 1, '5', 'TH', 32711, 1, 2, 0, NULL, 3, 0, 0, 6, '22:07:42', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(393, 1, '1', 'FV', 32717, 1, 3, 0, NULL, 0, 0, 0, 8, '00:43:42', '00:43:42', '2019-04-23 13:00:03', NULL, '4', 0, '2019-04-23', '1', '2019-04-23', 1),
(394, 1, '50', 'TH', 32718, 1, 2, 0, NULL, 6, 0, 0, 3, '01:16:30', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 4),
(395, 1, '2', 'TH', 32719, 1, 2, 0, NULL, 3, 0, 1, 5, '22:34:27', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(396, 1, '200', NULL, 32546, 3, 2, 0, NULL, 2, 0, 2, 0, '01:13:37', '00:00:00', NULL, '1036629003', '0', 0, '0000-00-00', '0', NULL, 0),
(397, 1, '5', 'FV', 32721, 1, 2, 0, NULL, 3, 0, 0, 5, '15:32:43', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 1),
(398, 1, '5', 'FV', 32722, 1, 2, 0, NULL, 3, 0, 0, 5, '15:49:04', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 1),
(399, 1, '2000', 'FV', 32723, 1, 2, 0, NULL, 4, 0, 4, 0, '03:48:18', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(400, 1, '4000', 'FV', 32724, 1, 2, 0, NULL, 4, 0, 4, 0, '19:29:10', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(401, 1, '70', 'TH', 32726, 1, 2, 0, NULL, 8, 0, 0, 1, '00:55:14', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(402, 1, '10', 'TH', 32727, 1, 2, 0, NULL, 6, 0, 0, 3, '29:57:10', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(403, 1, '15', 'FV', 32730, 1, 2, 0, NULL, 7, 0, 0, 1, '00:23:53', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(404, 1, '60', 'FV', 32731, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(405, 6, '1', '', 32599, 1, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(406, 7, '50', 'FV', 32599, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(407, 12, '50', '', 32599, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(408, 1, '50', '', 32599, 3, 4, 0, NULL, 2, 1, 0, 1, '53:21:16', '00:00:00', NULL, '1017187557', '0', 0, '0000-00-00', '0', NULL, 0),
(409, 7, '50', 'FV', 32600, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(410, 12, '50', '', 32600, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(411, 5, '50', '', 32600, 2, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(412, 1, '50', '', 32600, 3, 4, 0, NULL, 2, 1, 0, 1, '59:21:47', '00:00:00', NULL, '42702332', '0', 0, '0000-00-00', '0', NULL, 0),
(413, 1, '5000', NULL, 32328, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(414, 1, '30', 'TH', 32736, 1, 2, 0, NULL, 7, 0, 0, 1, '00:34:53', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(415, 1, '3', 'TH', 32737, 1, 3, 0, NULL, 0, 0, 0, 9, '05:09:59', '01:43:19', '2019-04-24 11:47:33', NULL, '1', 0, '2019-04-24', '3', '2019-04-24', 4),
(416, 1, '2', 'TH', 32738, 1, 2, 0, NULL, 4, 0, 0, 5, '00:59:51', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(417, 1, '5', 'TH', 32741, 1, 2, 0, NULL, 6, 0, 0, 3, '00:24:14', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(418, 1, '1', 'TH', 32740, 1, 2, 0, NULL, 3, 0, 0, 6, '20:05:40', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(419, 1, '2', 'FV', 32742, 1, 2, 0, NULL, 4, 0, 0, 4, '00:38:15', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 1),
(420, 1, '20', 'FV', 32743, 1, 2, 0, NULL, 7, 0, 0, 1, '00:53:30', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(421, 1, '20', 'FV', 32744, 1, 2, 0, NULL, 7, 0, 0, 1, '00:53:44', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 1),
(422, 1, '2', 'TH', 32746, 1, 2, 0, NULL, 6, 0, 0, 3, '00:02:04', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(423, 1, '200', NULL, 32459, 3, 4, 0, NULL, 2, 2, 0, 0, '00:47:40', '00:00:00', NULL, '42702332', '0', 0, '0000-00-00', '0', NULL, 0),
(424, 1, '150', NULL, 32378, 3, 4, 0, NULL, 2, 2, 0, 0, '02:55:35', '00:00:00', NULL, '43605625', '0', 0, '0000-00-00', '0', NULL, 0),
(425, 1, '50', NULL, 32547, 3, 4, 0, NULL, 2, 2, 0, 0, '19:00:57', '00:00:00', NULL, '43542658', '0', 0, '0000-00-00', '0', NULL, 0),
(426, 1, '10', 'TH', 32748, 1, 4, 0, NULL, 7, 1, 0, 1, '00:44:04', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(427, 1, '50', 'TH', 32749, 1, 2, 0, NULL, 7, 0, 0, 1, '00:28:32', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(428, 1, '30', 'TH', 32750, 1, 2, 0, NULL, 7, 0, 0, 1, '00:19:53', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(429, 1, '30', 'TH', 32751, 1, 2, 0, NULL, 7, 0, 0, 1, '00:19:13', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 4),
(430, 1, '15', 'TH', 32752, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(431, 1, '1', 'TH', 32753, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '3', 0, '0000-00-00', '0', NULL, 4),
(432, 1, '25', 'TH', 32755, 1, 2, 0, NULL, 8, 0, 0, 1, '00:44:40', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 4),
(433, 1, '1', 'TH', 32756, 1, 2, 0, NULL, 6, 0, 0, 3, '00:47:59', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(434, 1, '6', 'TH', 32757, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '3', 0, '0000-00-00', '0', NULL, 4),
(435, 1, '3', 'TH', 32762, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '4', 0, '0000-00-00', '0', NULL, 4),
(436, 1, '1', 'TH', 32763, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '2', 0, '0000-00-00', '0', NULL, 4),
(437, 1, '800', 'FV', 32765, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '5', 0, '0000-00-00', '0', NULL, 1),
(438, 2, '10', 'FV', 2000, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(439, 4, '10', 'FV', 2000, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(440, 3, '10', 'FV', 2000, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(441, 6, '1', '', 2000, 1, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(442, 1, '2', 'TH', 2000, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '0000-00-00', '0', NULL, 1),
(443, 7, '3', 'FV', 2000, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '3', 0, '0000-00-00', '0', NULL, 2),
(445, 5, '4', '', 2000, 2, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(446, 1, '5', '', 2000, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(457, 1, '10', 'TH', 32768, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 0, '0000-00-00', '0', NULL, 4),
(458, 2, '1', 'FV', 20001, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(459, 4, '2', 'FV', 20001, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(460, 3, '3', 'FV', 20001, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(461, 6, '4', '', 20001, 1, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(462, 1, '5', 'TH', 20001, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '1', 1, '0000-00-00', '0', NULL, 1),
(463, 7, '6', 'FV', 20001, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 2),
(464, 5, '7', '', 20001, 2, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0),
(465, 1, '8', '', 20001, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00:00', '00:00:00', NULL, NULL, '0', 0, '0000-00-00', '0', NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_teclados`
--

CREATE TABLE `detalle_teclados` (
  `idDetalle_teclados` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00:00',
  `cantidad_terminada` varchar(6) NOT NULL DEFAULT '0',
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT '1',
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `noperarios` tinyint(2) NOT NULL DEFAULT '0',
  `orden` tinyint(2) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0',
  `proceso_final` tinyint(1) NOT NULL DEFAULT '0',
  `mes_de_corte` varchar(10) NOT NULL DEFAULT '0000-00-00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_teclados`
--

INSERT INTO `detalle_teclados` (`idDetalle_teclados`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`, `proceso_final`, `mes_de_corte`) VALUES
(5, '00:00:00', '00:00:00', '0', NULL, NULL, 411, 11, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(6, '00:00:00', '00:00:00', '0', NULL, NULL, 411, 12, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(7, '00:00:00', '00:00:00', '0', NULL, NULL, 411, 13, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(8, '00:00:00', '00:00:00', '0', NULL, NULL, 411, 14, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(13, '00:00:00', '00:00:00', '0', NULL, NULL, 445, 11, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(14, '00:00:00', '00:00:00', '0', NULL, NULL, 445, 12, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(15, '00:00:00', '00:00:00', '0', NULL, NULL, 445, 13, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(16, '00:00:00', '00:00:00', '0', NULL, NULL, 445, 14, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00'),
(25, '00:00:00', '00:00:00', '0', NULL, NULL, 464, 11, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(26, '00:00:00', '00:00:00', '0', NULL, NULL, 464, 12, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(27, '00:00:00', '00:00:00', '0', NULL, NULL, 464, 13, 1, NULL, NULL, 0, 0, '0', 0, '0000-00-00'),
(28, '00:00:00', '00:00:00', '0', NULL, NULL, 464, 14, 1, NULL, NULL, 0, 0, '0', 1, '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `espesor`
--

CREATE TABLE `espesor` (
  `idEspesor` tinyint(3) NOT NULL,
  `nom_espesor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `espesor`
--

INSERT INTO `espesor` (`idEspesor`, `nom_espesor`) VALUES
(1, '1.6 - 1 CAPA'),
(2, '0.8 - 1 CAPA'),
(3, '0.1 - 1 CAPA'),
(4, '1.6 - 2 CAPAS'),
(5, '0.8 - 2 CAPAS'),
(6, '0.1 - 2 CAPAS');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos`
--

CREATE TABLE `procesos` (
  `idproceso` tinyint(4) NOT NULL,
  `nombre_proceso` varchar(30) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `idArea` tinyint(4) NOT NULL,
  `orden_mostrar` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `procesos`
--

INSERT INTO `procesos` (`idproceso`, `nombre_proceso`, `estado`, `idArea`, `orden_mostrar`) VALUES
(1, 'Perforado', 1, 1, 1),
(2, 'Quimicos', 1, 1, 2),
(3, 'Caminos', 1, 1, 3),
(4, 'Quemado', 1, 1, 4),
(5, 'C.C.TH', 1, 1, 5),
(6, 'Screen', 1, 1, 6),
(7, 'Estañado', 1, 1, 7),
(8, 'C.C.2', 1, 1, 8),
(9, 'Ruteo', 1, 1, 9),
(10, 'Maquinas', 1, 1, 10),
(11, 'Correas y Conversor', 1, 2, 1),
(12, 'Lexan', 1, 2, 2),
(13, 'Acople', 1, 2, 3),
(14, 'Calidad TE', 1, 2, 4),
(15, 'Manual', 1, 3, 1),
(16, 'Automatico', 1, 3, 2),
(17, 'Control Calidad', 1, 3, 3),
(18, 'Empaque', 1, 3, 4),
(19, 'Componentes', 1, 4, 0),
(20, 'GF', 1, 4, 0),
(21, 'Prueba', 0, 2, 5),
(22, 'Nuevo Proceso', 0, 1, 11);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos_producto`
--

CREATE TABLE `procesos_producto` (
  `idProceso_producto` int(11) NOT NULL,
  `idCondicion` tinyint(4) NOT NULL,
  `orden` varchar(2) NOT NULL DEFAULT '1',
  `idProceso` tinyint(4) NOT NULL,
  `procesoFinal` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `procesos_producto`
--

INSERT INTO `procesos_producto` (`idProceso_producto`, `idCondicion`, `orden`, `idProceso`, `procesoFinal`) VALUES
(2, 2, '1', 1, 0),
(8, 3, '0', 15, 0),
(14, 3, '0', 16, 0),
(15, 3, '0', 17, 0),
(16, 3, '0', 18, 1),
(17, 1, '1', 1, 0),
(18, 1, '2', 2, 0),
(19, 1, '3', 3, 0),
(20, 1, '4', 4, 0),
(21, 1, '5', 5, 0),
(22, 1, '6', 6, 0),
(23, 1, '7', 7, 0),
(24, 1, '8', 8, 0),
(25, 1, '9', 9, 0),
(26, 1, '10', 10, 0),
(27, 4, '0', 11, 0),
(28, 4, '0', 12, 0),
(29, 4, '0', 13, 0),
(30, 4, '0', 14, 1),
(31, 2, '2', 2, 0),
(32, 2, '3', 3, 0),
(33, 2, '4', 4, 0),
(34, 2, '5', 5, 0),
(35, 2, '6', 7, 0),
(36, 2, '7', 8, 0),
(37, 2, '8', 10, 0),
(38, 5, '1', 1, 0),
(39, 5, '2', 2, 0),
(40, 5, '3', 3, 0),
(41, 5, '4', 4, 0),
(42, 5, '5', 5, 0),
(43, 5, '7', 7, 0),
(44, 5, '8', 8, 0),
(46, 5, '9', 10, 0),
(47, 5, '6', 6, 0),
(48, 6, '1', 1, 0),
(49, 6, '2', 2, 0),
(50, 6, '3', 3, 0),
(51, 6, '4', 4, 0),
(52, 6, '5', 5, 0),
(53, 6, '6', 7, 0),
(54, 6, '7', 8, 0),
(55, 6, '8', 9, 0),
(56, 6, '9', 10, 0),
(57, 7, '2', 1, 0),
(58, 7, '1', 4, 0),
(59, 7, '3', 10, 0),
(60, 8, '2', 1, 0),
(61, 8, '1', 4, 0),
(62, 8, '3', 10, 0),
(63, 9, '1', 1, 0),
(64, 9, '2', 3, 0),
(65, 9, '3', 4, 0),
(66, 9, '4', 5, 0),
(67, 10, '1', 1, 0),
(68, 10, '2', 3, 0),
(69, 10, '3', 4, 0),
(70, 10, '4', 5, 0),
(71, 10, '5', 7, 0),
(72, 10, '6', 8, 0),
(73, 10, '7', 9, 0),
(74, 10, '8', 10, 0),
(75, 11, '1', 1, 0),
(76, 11, '2', 2, 0),
(77, 11, '3', 3, 0),
(78, 11, '4', 4, 0),
(79, 11, '5', 5, 0),
(80, 11, '6', 6, 0),
(81, 11, '7', 7, 0),
(82, 11, '8', 8, 0),
(83, 11, '9', 9, 0),
(84, 11, '10', 10, 0),
(85, 12, '1', 1, 0),
(86, 12, '2', 2, 0),
(87, 12, '3', 3, 0),
(88, 12, '4', 4, 0),
(89, 12, '5', 5, 0),
(90, 12, '6', 7, 0),
(91, 12, '7', 8, 0),
(92, 12, '8', 10, 0),
(93, 13, '1', 1, 0),
(94, 13, '2', 2, 0),
(95, 13, '3', 3, 0),
(96, 13, '4', 4, 0),
(97, 13, '5', 5, 0),
(98, 13, '6', 6, 0),
(99, 13, '7', 7, 0),
(100, 13, '8', 8, 0),
(101, 13, '9', 10, 0),
(102, 14, '1', 1, 0),
(103, 14, '2', 2, 0),
(104, 14, '3', 3, 0),
(105, 14, '4', 4, 0),
(106, 14, '5', 5, 0),
(107, 14, '6', 7, 0),
(108, 14, '7', 8, 0),
(109, 14, '8', 9, 0),
(110, 14, '9', 10, 0),
(111, 15, '1', 1, 0),
(112, 15, '2', 3, 0),
(113, 15, '3', 4, 0),
(114, 15, '4', 5, 0),
(115, 15, '5', 6, 0),
(116, 15, '6', 7, 0),
(117, 15, '7', 8, 0),
(118, 15, '8', 9, 0),
(119, 15, '9', 10, 0),
(120, 16, '1', 1, 0),
(121, 16, '2', 3, 0),
(122, 16, '3', 4, 0),
(123, 16, '4', 5, 0),
(124, 16, '5', 7, 0),
(125, 16, '6', 8, 0),
(126, 16, '7', 10, 0),
(127, 17, '1', 1, 0),
(128, 17, '2', 3, 0),
(129, 17, '3', 4, 0),
(130, 17, '4', 5, 0),
(131, 17, '5', 6, 0),
(132, 17, '6', 7, 0),
(133, 17, '7', 8, 0),
(134, 17, '8', 10, 0),
(135, 18, '1', 1, 0),
(136, 18, '2', 3, 0),
(137, 18, '3', 4, 0),
(138, 18, '4', 5, 0),
(139, 18, '5', 7, 0),
(140, 18, '6', 8, 0),
(141, 18, '7', 9, 0),
(142, 18, '8', 10, 0),
(143, 19, '1', 1, 0),
(144, 19, '2', 3, 0),
(145, 19, '3', 4, 0),
(146, 19, '4', 5, 0),
(147, 19, '5', 6, 0),
(148, 19, '6', 7, 0),
(149, 19, '7', 8, 0),
(150, 19, '8', 9, 0),
(151, 19, '9', 10, 0),
(152, 20, '1', 1, 0),
(153, 20, '2', 3, 0),
(154, 20, '3', 4, 0),
(155, 20, '4', 5, 0),
(156, 20, '5', 7, 0),
(157, 20, '6', 8, 0),
(158, 20, '7', 10, 0),
(159, 21, '1', 1, 0),
(160, 21, '2', 3, 0),
(161, 21, '3', 4, 0),
(162, 21, '4', 5, 0),
(163, 21, '5', 6, 0),
(164, 21, '6', 7, 0),
(165, 21, '7', 8, 0),
(166, 21, '8', 10, 0),
(167, 22, '1', 1, 0),
(168, 22, '2', 3, 0),
(169, 22, '3', 4, 0),
(170, 22, '4', 5, 0),
(171, 22, '5', 7, 0),
(172, 22, '6', 8, 0),
(173, 22, '7', 9, 0),
(174, 22, '8', 10, 0),
(175, 23, '0', 15, 0),
(176, 23, '0', 16, 0),
(177, 23, '0', 17, 0),
(178, 23, '0', 18, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idproducto` tinyint(4) NOT NULL,
  `nombre` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idproducto`, `nombre`) VALUES
(1, 'Circuito'),
(2, 'Conversor'),
(3, 'Repujado'),
(4, 'Troquel'),
(5, 'Teclado'),
(6, 'Stencil'),
(7, 'PCB'),
(8, 'Circuito GF'),
(9, 'PCB GF'),
(10, 'Circuito COM'),
(11, 'PCB COM'),
(12, 'Circuito-TE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `numero_orden` int(11) NOT NULL,
  `usuario_numero_documento` varchar(13) NOT NULL,
  `nombre_cliente` varchar(150) DEFAULT NULL,
  `nombre_proyecto` varchar(150) DEFAULT NULL,
  `tipo_proyecto` varchar(6) DEFAULT NULL,
  `fecha_ingreso` datetime NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `fecha_salidal` datetime DEFAULT NULL,
  `estado` tinyint(4) NOT NULL,
  `eliminacion` tinyint(1) DEFAULT '1',
  `parada` tinyint(1) DEFAULT '1',
  `entregaCircuitoFEoGF` date DEFAULT NULL,
  `entregaCOMCircuito` date DEFAULT NULL,
  `entregaPCBFEoGF` date DEFAULT NULL,
  `entregaPCBCom` date DEFAULT NULL,
  `novedades` varchar(250) DEFAULT NULL,
  `estadoEmpresa` varchar(13) DEFAULT NULL,
  `NFEE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `proyecto`
--

INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `estado`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(326, '1036650501', 'EOG MODULE TX', 'MARIO ANDRES VILLAMIZAR PALACIO ', 'Normal', '2019-04-05 09:34:08', '2019-04-11', NULL, 1, 0, 1, '2019-04-08', '2019-04-11', NULL, NULL, '', NULL, NULL),
(2000, '981130', 'Juan David Marulanda Paniagua', 'Prueba de desarrollo, informacion de QR', 'Normal', '2019-04-25 08:08:19', '2019-04-01', NULL, 1, 0, 1, '2019-04-11', '2019-04-17', NULL, NULL, '', NULL, NULL),
(20001, '981130', 'Prueba de desarrollo', 'Prueba de desarrollo', 'Normal', '2019-04-25 09:51:24', '2019-04-25', NULL, 1, 0, 1, '2019-04-25', '2019-04-26', NULL, NULL, '', NULL, NULL),
(31762, '1017156424', 'COLCERAMICA', 'DRAA', 'Normal', '2019-04-03 08:06:59', '2019-04-09', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32045, '1017156424', 'TECREA S.A.S ', 'MainBoard GatewayIoT ', 'Normal', '2019-03-07 08:44:31', '2019-02-05', NULL, 4, 1, 1, '2019-01-31', '2019-02-28', NULL, NULL, NULL, 'A tiempo', NULL),
(32124, '1017156424', 'INSITE S.A.S ', 'INL8 V3 ', 'Normal', '2019-03-07 14:59:12', '2019-03-07', NULL, 2, 1, 1, '2019-02-19', '2019-02-16', NULL, NULL, NULL, 'A tiempo', NULL),
(32137, '1216714539', 'DISEVEN INNOVACION TECNOLOGICA S.A.S ', 'BASE CON BATERIA ', 'Normal', '2019-03-05 14:24:55', '2019-03-12', NULL, 4, 1, 1, '2019-02-20', '2019-02-17', NULL, NULL, NULL, 'A tiempo', NULL),
(32213, '1152697088', 'LOGISEGURIDAD LTDA', 'BRAZALETE SIGFOX BAJAS CANTIDADES', 'Normal', '2019-03-06 07:33:27', '2019-02-27', '2019-03-28 14:16:51', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32247, '1017156424', 'TECREA S.A.S ', 'IBUTTON DISPOSABLE ', 'Normal', '2019-03-07 09:11:36', '2019-03-04', NULL, 4, 1, 1, '2019-02-21', '2019-02-19', NULL, NULL, NULL, 'A tiempo', NULL),
(32249, '1216714539', 'TECREA S.A.S ', 'CAMA PINCHOS TRACKFOX LORA ', 'Normal', '2019-03-04 10:55:48', '2019-02-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32287, '1017156424', 'DOMETAL ', '8200 ', 'Normal', '2019-03-07 09:10:00', '2019-03-18', NULL, 4, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32288, '1017156424', 'DOMETAL ', '7904 ', 'Normal', '2019-03-07 09:12:31', '2019-03-18', NULL, 4, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32290, '1017156424', 'DOMETAL ', '8199', 'Normal', '2019-03-18 12:03:09', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32291, '1017156424', 'DOMETAL ', '8198 ', 'Normal', '2019-03-18 11:33:43', '2019-03-18', NULL, 4, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32318, '1017156424', 'TECREA S.A.S ', 'SX3 ', 'Normal', '2019-03-12 16:01:23', '2019-03-19', NULL, 4, 1, 1, '2019-03-11', '2019-03-20', NULL, NULL, NULL, 'A tiempo', NULL),
(32321, '1152697088', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 2', 'Normal', '2019-03-06 07:39:12', '2019-03-04', '2019-03-11 10:41:13', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32322, '1152697088', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 1', 'Normal', '2019-03-06 07:42:26', '2019-03-04', '2019-03-11 10:46:45', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32324, '1216714539', 'SEINTMA S.A.S ', 'EKS 4 V4 ', 'Normal', '2019-03-06 07:35:50', '2019-03-05', NULL, 4, 1, 1, '2019-02-28', '2019-02-25', NULL, NULL, NULL, 'A tiempo', NULL),
(32328, '1017156424', 'LUMEN', 'PCB REC 146MM', 'Normal', '2019-04-22 07:20:29', '2019-04-26', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32329, '1017156424', 'TECREA S.A.S ', 'MODULO GATEWAYIOT 3G ', 'Normal', '2019-03-07 09:32:58', '2019-03-15', NULL, 4, 1, 1, '2019-03-12', '2019-03-09', NULL, NULL, '', 'A tiempo', NULL),
(32352, '1017156424', 'COLCERAMICA ', 'VENTUS', 'Normal', '2019-04-04 06:18:11', '2019-04-04', NULL, 2, 1, 1, '2019-04-03', '2019-04-04', NULL, NULL, NULL, 'A tiempo', NULL),
(32353, '98765201', 'DISEVEN INNOVACION TECNOLOGICA S.A.S ', 'LUXURY UNIVERSAL RELES DOS ENTRADAS DOS SALIDAS', 'Normal', '2019-03-04 07:56:48', '2019-03-18', '2019-03-12 15:59:38', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32357, '1017156424', 'TORNES SECURITY', 'ALWF', 'Normal', '2019-03-18 11:56:25', '2019-04-12', NULL, 4, 1, 1, '2019-03-12', '2019-03-09', NULL, NULL, '', 'A tiempo', NULL),
(32375, '1216714539', 'INVYTEC ', 'CALIMA II V2_46 ', 'Normal', '2019-03-04 07:30:45', '2019-04-01', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32378, '98765201', 'SOLUCIONES WIGA S.A.S', 'PCBA004_3_1', 'Normal', '2019-03-04 07:46:14', '2019-04-12', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32396, '1216714539', 'LEON VELASQUEZ C y CIA SAS ', 'DISPLAY ', 'Normal', '2019-03-04 09:57:35', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32397, '1216714539', 'LEON VELASQUEZ C y CIA SAS ', 'SECUENCIADOR ', 'Normal', '2019-03-04 10:00:39', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32398, '1216714539', 'LEON VELASQUEZ C y CIA SAS ', 'INTERFACE RELAY ', 'Normal', '2019-03-04 10:41:14', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32399, '1216714539', 'DISEÃ‘OS ELECTRICOS E INGENIERIA S.A.S   DISELECT S.A.S. ', ' PCB485 ', 'Normal', '2019-03-04 10:45:02', '2019-03-15', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32400, '1216714539', 'DISEÃ‘OS ELECTRICOS E INGENIERIA S.A.S   DISELECT S.A.S. ', 'PCB420 ', 'Normal', '2019-03-04 10:47:46', '2019-03-15', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32401, '1017156424', 'GERMAN DAVID SOSA RAMIREZ ', 'MICROTRACKPAD ', 'Normal', '2019-03-12 11:02:26', '2019-03-13', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32402, '1216714539', 'GLOBUS SISTEMAS S.A.S ', 'CONV_TTL_RS232 ', 'RQT', '2019-03-04 11:36:15', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32404, '1216714539', 'TECNOTIUM S.A.S ', 'ADC_PIC18F_PIC12 ', 'Normal', '2019-03-04 12:03:46', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32405, '1216714539', 'TECNOTIUM S.A.S ', 'REG_GPS_ACOND ', 'Normal', '2019-03-04 12:06:46', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32406, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MCVF_4S_XBEE ', 'Normal', '2019-03-04 13:27:02', '2019-03-13', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32407, '1216714539', 'SIN RED SOLUTIONS S.A.S ', 'PANEL RF ', 'Normal', '2019-03-04 12:09:03', '2019-03-13', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32410, '98765201', 'C.I. G&LINGERIE S.A.S', 'TARJETA LCD', 'Normal', '2019-03-12 11:05:11', '2019-03-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32412, '1152697088', 'DANIEL PADIERNA VANEGAS', 'Sistema de gobierno de embarcaciones navales 2017v2', 'Normal', '2019-03-04 15:50:42', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32414, '1216714539', 'MEDENCOL ', 'NEGATOSCOPIO ', 'Normal', '2019-03-04 16:23:31', '2019-03-14', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32415, '1017156424', 'FANTASIA DEL AGUA ', 'INTERFAZ POTENCIA ', 'Normal', '2019-03-12 07:22:37', '2019-03-28', NULL, 4, 1, 1, '2019-03-15', '2019-03-12', NULL, NULL, NULL, 'A tiempo', NULL),
(32417, '1017156424', 'TECREA S.A.S ', 'ISQUARED ', 'Normal', '2019-03-12 07:21:35', '2019-04-17', NULL, 4, 1, 1, '2019-03-28', '2019-03-25', NULL, NULL, NULL, 'A tiempo', NULL),
(32418, '1216714539', 'INDUSTRIAS METALICAS LOS PINOS ', '1600000442 PUERTO BLUETOOTH 4.0 ', 'RQT', '2019-03-05 13:04:23', '2019-03-12', '2019-03-07 08:55:19', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32419, '1216714539', 'SEBASTIAN JIMENEZ GOMEZ', 'ODIN VERSION 1.1 ', 'Normal', '2019-03-04 16:42:04', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32420, '1216714539', 'OSWALDO  ALZATE VELASQUEZ ', 'G_BOARDC1 ', 'Normal', '2019-03-04 16:45:17', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32421, '1216714539', 'MEDENCOL ', 'EQUIPO EVO II 2014 CON MANDO ', 'Normal', '2019-03-04 16:57:07', '2019-03-08', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32422, '1216714539', 'MEDENCOL ', 'MANDOS MAXIM 2006 V7 ', 'Normal', '2019-03-04 17:13:43', '2019-03-13', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32423, '1216714539', 'MEDENCOL ', 'MAXIM 18 ', 'Normal', '2019-03-04 17:21:09', '2019-03-11', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32428, '1216714539', 'SYSTEMS AND SERVICES GROUP SAS (SSG AC SAS) ', 'UTO RGB V7 ', 'Normal', '2019-03-05 16:17:14', '2019-03-13', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32429, '1216714539', 'GERMAN EDUARDO CARRASCO CARRASCO ', 'NEO_64_Plus ', 'Normal', '2019-03-05 16:21:22', '2019-03-13', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32430, '1216714539', 'NOVA CONTROL S.A.S ', 'MONITOR_LLM_V3 ', 'Normal', '2019-03-05 16:24:59', '2019-03-14', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32431, '1216714539', 'LUIS FELIPE ECHEVERRI ', 'Game_Board_2019 ', 'Normal', '2019-03-06 07:41:29', '2019-03-15', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32437, '1017156424', 'CREAME INCUBADORA DE EMPRESAS ', 'RES_V3 ', 'Normal', '2019-03-07 09:16:31', '2019-03-12', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32438, '1017156424', 'ENERGESIS NATURA S.A.S ', 'CAMBIO1 ', 'Normal', '2019-03-07 09:14:28', '2019-03-19', '2019-03-18 07:15:14', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32439, '1017156424', 'OPTEC POWER SAS ', 'TD40D16C ', 'Normal', '2019-03-07 09:13:18', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32440, '1152697088', 'OPTEC POWER SAS', 'OPv24SP15-INH-2EMI-V9', 'Normal', '2019-03-07 09:01:55', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32441, '1152697088', 'OPTEC POWER SAS', 'TA60D06-VR2-V3', 'Normal', '2019-03-07 09:09:25', '2019-03-26', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32442, '1216714539', 'LUIS ESTEBAN VILLAMARIN ', 'GERBER ', 'RQT', '2019-03-07 12:35:51', '2019-03-12', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32443, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'DISPLAY DOBLE V1 ', 'Normal', '2019-03-07 12:03:46', '2019-03-14', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32445, '1216714539', 'HAPPYCITY ', 'REPETIDOR 16 CANALES TTL ', 'Normal', '2019-03-07 14:45:37', '2019-03-14', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32446, '1216714539', 'ALEXANDER ESPINOSA GARCIA ', ' HELIO 01 ', 'Normal', '2019-03-07 15:29:39', '2019-03-19', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32448, '1216714539', 'JUAN SEBASTIAN CASAS BURGOS ', 'INVERSOR TRIFASICO ', 'Normal', '2019-03-08 07:51:26', '2019-03-15', '2019-03-18 08:31:28', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32449, '1216714539', 'OSWALDO PUERTA TOVAR ', 'DISPLAY_1_8_2DIG ', 'Normal', '2019-03-08 08:03:36', '2019-03-20', '2019-03-22 12:37:32', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32450, '1216714539', 'OSWALDO PUERTA TOVAR ', 'VEL_DISPLAY1_8_5V ', 'Normal', '2019-03-08 08:08:01', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32451, '1216714539', 'RPM INGENIEROS S.A.S ', 'BASE PMR ', 'Normal', '2019-03-08 12:54:00', '2019-03-18', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32452, '1216714539', 'INGENIERIA VML S.A.S ', 'PANEL 050319 ', 'Normal', '2019-03-08 15:34:51', '2019-03-21', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32453, '1152697088', 'DISEÑO ELECTRÓNICO LTDA', 'TECLADO TECBAL LC-45 PRINTER', 'Normal', '2019-03-11 08:53:33', '2019-03-27', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32454, '1216714539', 'ANDRES FELIPE GOMEZ RENDON ', 'RHEMONT 1.0 ', 'Normal', '2019-03-08 16:48:40', '2019-03-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32455, '1017156424', 'TECREA', 'TARJETAS SENSOR DE PROXIMIDAD', 'Normal', '2019-04-09 06:07:34', '2019-04-04', NULL, 1, 1, 1, NULL, NULL, '2019-04-17', NULL, '', NULL, NULL),
(32456, '1017156424', 'TECREA S.A.S ', 'MODULO GATEWAY WIFI ', 'Normal', '2019-03-12 07:17:06', '2019-04-02', NULL, 2, 1, 1, '2019-03-28', '2019-03-25', NULL, NULL, '', 'A tiempo', NULL),
(32457, '1017156424', 'TECREA S.A.S ', 'CAMA DE PINCHOS TRACKFOX LORA ', 'Normal', '2019-03-12 07:10:47', '2019-03-14', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32458, '1216714539', 'SISTEMA SONORO DE COLOMBIA LTDA ', 'ControlCentral_USB ', 'Normal', '2019-03-11 10:36:16', '2019-03-21', '2019-03-18 07:15:30', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32459, '1017156424', 'SOLUCIONES WIGA S.A.S ', 'PCBA014_1_1 ', 'Normal', '2019-03-12 07:11:38', '2019-04-24', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32460, '1216714539', 'PITMMAM SAS ', 'COLLECTOR ', 'Quick', '2019-03-11 12:09:17', '2019-03-12', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32461, '1216714539', 'SIN RED SOLUTIONS S.A.S ', 'CTRLSENSORES2 ', 'Normal', '2019-03-11 16:10:54', '2019-03-18', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32463, '1216714539', 'GOTTA SAS ', ' INTERFAZ LCD_MF500v5_1 ', 'Normal', '2019-03-12 08:55:36', '2019-03-21', '2019-03-22 12:43:25', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32464, '1216714539', 'JUAN DAVID ROMAN GUTIERREZ ', 'DRIVERBOARDV2 ', 'Normal', '2019-03-12 10:47:30', '2019-03-19', '2019-03-18 07:14:33', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32466, '1216714539', 'YEISON DANIEL TAPIERO SANTA ', 'PCB ', 'Normal', '2019-03-13 09:17:43', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32467, '1216714539', 'EBENEZER TECHNOLOGIES SAS ', 'TECNOPARKING ', 'Normal', '2019-03-13 09:18:28', '2019-03-21', '2019-03-22 12:43:00', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32469, '1216714539', 'JOHN GERMAN GARCIA G ', 'MF_20190312 ', 'Normal', '2019-03-13 09:19:14', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32470, '98765201', 'FANTASIA DEL AGUA', 'DAISY CHAIN D V3.2.2015', 'Normal', '2019-03-14 15:03:53', '2019-03-29', NULL, 2, 1, 1, '2019-03-26', '2019-03-22', NULL, NULL, '', 'A tiempo', NULL),
(32471, '98765201', 'FANTASIA DEL AGUA', 'PCB_ALUMINIO_10W_V.1.0.2019', 'Normal', '2019-03-15 07:23:56', '2019-03-26', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32472, '98765201', 'FANTASIA DEL AGUA', 'PCB_ALUMINIO_10W_V.1.0.2019', 'Normal', '2019-03-15 07:28:35', '2019-03-26', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32473, '1017156424', 'FANTASIA DEL AGUA ', 'PCB_BASE_10W_4W_V.1.0.2019 ', 'Normal', '2019-03-15 07:30:16', '2019-03-26', NULL, 2, 1, 1, '2019-03-20', '2019-03-17', NULL, NULL, '', 'A tiempo', NULL),
(32474, '1017156424', 'FANTASIA DEL AGUA ', 'PCB_DRIVER_10W_4W_V.1.0.2019 ', 'Quick', '2019-03-15 07:31:14', '2019-03-26', NULL, 4, 1, 1, '2019-04-09', '2019-04-09', NULL, NULL, '', 'A tiempo', NULL),
(32475, '1017156424', 'FANTASIA DEL AGUA ', 'PCB_POTENCIA_10W_4W_1.0.2019 ', 'Normal', '2019-03-15 07:32:19', '2019-03-26', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32476, '1216714539', 'FANTASÍA DEL AGUA', 'FANTASIA DEL AGUA - PCB_LED_10W_4W_V.1.0.2019 (FEB 28-19) ', 'Normal', '2019-03-26 09:11:51', '2019-04-03', NULL, 4, 1, 1, '2019-03-29', '2019-03-27', NULL, NULL, '', 'A tiempo', NULL),
(32477, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', ' LUCES FLASHER 555 TRIAC ', 'Normal', '2019-03-13 07:40:19', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32478, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', '8 SECUENCIAS PIC ', 'Normal', '2019-03-13 07:43:07', '2019-03-22', '2019-03-20 14:03:13', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32479, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', 'TEMPORIZADOR RELEVO PIC ', 'Normal', '2019-03-13 07:45:30', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32480, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', 'IMPRESO FLASHER 555 ', 'Normal', '2019-03-13 07:47:53', '2019-03-26', '2019-03-20 08:33:12', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32481, '1216714539', 'MICHAEL ARMANDO ARAUJO ORDO%C3%91EZ ', 'SENSOR AFPSR ', 'Normal', '2019-03-14 13:46:50', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32482, '1216714539', 'BIOINNOVA S.A.S ', 'ALARMA MAESTRA ', 'Normal', '2019-03-13 08:32:10', '2019-03-22', '2019-03-22 12:45:13', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32483, '1216714539', 'DANIEL PADIERNA VANEGAS ', 'PUENTE H ', 'RQT', '2019-03-13 10:30:56', '2019-03-15', '2019-03-15 07:24:09', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32484, '1216714539', 'METROINDUSTRIAL SAS ', 'AUTOCLAVE ', 'Normal', '2019-03-13 10:50:50', '2019-03-20', '2019-03-19 09:23:03', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32485, '1152697088', 'INDELEC SAS', 'TECLADO ALINEADOR AP290', 'Normal', '2019-03-13 14:30:14', '2019-04-03', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32486, '1216714539', 'CARLOS HUMBERTO CUELLAR MARTINEZ ', 'SECUENCIAL_V3 ', 'Normal', '2019-03-13 16:50:32', '2019-03-20', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32487, '1017156424', 'INSSA S.A.S ', 'REPARACION INSSA TCP2016_V6 ', 'Normal', '2019-03-13 17:32:00', '2019-03-18', NULL, 4, 1, 1, '2019-03-13', '2019-03-22', NULL, NULL, NULL, 'A tiempo', NULL),
(32488, '1017156424', 'INSSA S.A.S ', 'REPARACION INSSA TCP2016_V6 ', 'Normal', '2019-03-13 17:46:09', '2019-03-18', NULL, 4, 1, 1, '2019-03-13', '2019-03-22', NULL, NULL, NULL, 'A tiempo', NULL),
(32489, '1216714539', 'JHON JAIRO PABON JARAMILLO ', 'DISPLAY 5 DIGITOS ', 'Normal', '2019-03-15 12:07:25', '2019-04-04', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32491, '1216714539', 'OSWALDO  ALZATE VELASQUEZ ', 'TX_ISO ', 'RQT', '2019-03-14 08:48:04', '2019-03-18', '2019-03-15 15:15:31', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32492, '1216714539', 'OSWALDO  ALZATE VELASQUEZ ', 'TX_FD ', 'RQT', '2019-03-14 08:57:10', '2019-03-18', '2019-03-15 15:05:31', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32494, '1216714539', 'HOSPINET COLOMBIA S.A.S ', 'TARJETA 18F47J53 CON COLORIMETRIA ', 'Normal', '2019-03-14 14:42:06', '2019-04-01', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32497, '98765201', 'INSSA S.A.S', 'TCP2016_V6', 'Normal', '2019-03-15 07:39:48', '2019-04-09', NULL, 2, 1, 1, '2019-03-27', '2019-03-22', NULL, NULL, '', 'A tiempo', NULL),
(32498, '1017156424', 'SANTIAGO JOSE URIBE', 'DESING_SENSOR', 'Normal', '2019-04-09 06:04:39', '2019-04-11', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32499, '1216714539', 'DOMETAL ', '8198 ', 'Normal', '2019-03-15 14:04:23', '2019-04-16', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32500, '1216714539', 'DOMETAL ', '8996 ', 'Normal', '2019-03-15 14:05:58', '2019-04-16', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32501, '1216714539', 'DOMETAL ', '8562 ', 'Normal', '2019-03-15 14:13:08', '2019-04-09', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32502, '1216714539', 'DOMETAL ', '8561 ', 'Normal', '2019-03-15 14:11:54', '2019-04-09', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32503, '1216714539', 'DOMETAL ', '8560 ', 'Normal', '2019-03-15 14:14:04', '2019-04-09', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32504, '1216714539', 'DOMETAL ', '8539 ED 4 MOV SIN AUTO ', 'Normal', '2019-03-15 14:14:15', '2019-04-16', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32505, '1216714539', 'DOMETAL ', '8199 ', 'Normal', '2019-03-15 14:15:02', '2019-04-16', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32506, '1216714539', 'DOMETAL ', '8538 ED 4 MOV SIN AUTO ', 'Normal', '2019-03-15 14:16:01', '2019-04-16', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32507, '1216714539', 'DOMETAL ', '8563 ', 'Normal', '2019-03-15 14:16:53', '2019-04-09', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32508, '1216714539', 'EFFITECH S.A.S ', 'MAXTRANSISTORES 2.0 ', 'Normal', '2019-03-15 16:31:14', '2019-04-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32509, '1216714539', 'MEDENCOL ', 'MANDO ELECTRICA DIGITAL ', 'Normal', '2019-03-15 16:34:35', '2019-03-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32510, '1216714539', 'MEDENCOL ', 'MANDOS MAXIM 2006 V7 ', 'Normal', '2019-03-15 16:40:23', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32511, '1216714539', 'MEDENCOL ', ' MAXIM 18 ', 'Normal', '2019-03-15 16:45:12', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32512, '1152697088', 'LABZUL S.A.S', 'TECLADO PARA HB43', 'Normal', '2019-03-15 16:52:57', '2019-04-01', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32514, '1216714539', 'PITMMAM SAS ', 'COLLECTOR ', 'Quick', '2019-03-18 12:02:14', '2019-03-19', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32515, '1017156424', 'NOVAVENTA S.A.S ', 'PROG MQ BVM 302 BIANCHI ', 'Normal', '2019-03-18 15:05:30', '2019-03-19', NULL, 2, 1, 1, '2019-04-03', '2019-04-03', NULL, NULL, '', 'A tiempo', NULL),
(32517, '1216714539', 'TECREA S.A.S ', 'CAM KIT PCB CONNECTOR ', 'Quick', '2019-03-18 15:47:26', '2019-03-19', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32518, '1216714539', 'ORION INFINITI S.A.S.   ORION S.A.S. ', ' GERBER RPM ', 'Normal', '2019-03-18 17:20:37', '2019-03-22', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32519, '1216714539', 'ORION INFINITI S.A.S.   ORION S.A.S. ', ' GERBER ACC ', 'Normal', '2019-03-18 17:22:43', '2019-03-28', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32520, '1216714539', 'SOFTTRONICS SOLUTIONS S.A ', 'BFP_INTERCO ', 'Normal', '2019-03-18 17:25:20', '2019-03-26', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32521, '1216714539', 'SOFTTRONICS SOLUTIONS S.A ', 'BFP_SHIELD ', 'Normal', '2019-03-18 17:27:36', '2019-03-26', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32523, '1216714539', 'JUAN FERNANDO OSORIO/ MIFE - MISCELANEA INTEGRAL FUTURISTAELECTRONICA', 'JUAN OSORIO - BASE_MCVF_XBEE (MAR 19-19) ', 'Normal', '2019-03-19 11:00:02', '2019-04-01', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32525, '1216714539', 'ELISA MEJIA ', 'ELISA MEJIA - PIC (MAR 18-19) ', 'Normal', '2019-03-19 13:58:58', '2019-03-27', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32526, '1216714539', 'INGENIERIA VML S.A.S', 'INGENIERIA VML S.A.S - PROYECTO VML (MAR 18-19) ', 'Normal', '2019-03-19 14:19:34', '2019-03-28', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32527, '1216714539', 'JHON STIVEN MEDINA VARGAS', 'JHON STIVEN MEDINA - BRAZO (MAR 06-19) ', 'Normal', '2019-03-19 15:00:15', '2019-03-27', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32528, '1216714539', 'OPTEC POWER SAS', 'OPTEC - SSR-DC-200-P2-V5 - MAR 19-19 ', 'Normal', '2019-03-20 08:09:41', '2019-04-10', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32529, '1216714539', 'OPTEC POWER SAS', 'OPTEC - SSR_DC_176_V1_P1 - MAR 19-19 ', 'Normal', '2019-03-20 08:10:29', '2019-04-02', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32530, '1216714539', 'OPTEC POWER SAS', 'OPTEC - SSR_DC_176_V1_P1 - MAR 19-19 ', 'Normal', '2019-03-20 08:11:05', '2019-04-02', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32532, '1017156424', 'FANTASIA DEL AGUA', ' 183 DMX DIGITAL ', 'Normal', '2019-03-20 10:02:22', '2019-04-08', NULL, 2, 1, 1, '2019-04-05', '2019-04-12', NULL, NULL, '', 'A tiempo', NULL),
(32533, '1216714539', 'OPTEC POWER SAS', 'OPTEC - A24A43BP-V2 - OCT 01-18 ', 'Normal', '2019-03-20 09:25:31', '2019-04-03', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32535, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MCVF80 ', 'Normal', '2019-03-20 10:59:31', '2019-04-04', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32536, '1216714539', 'B SMART ', 'PCB DIM T4 ', 'Normal', '2019-03-20 11:30:41', '2019-04-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32537, '1216714539', 'B SMART ', 'GERBER ', 'Normal', '2019-03-20 11:33:00', '2019-04-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32538, '1017156424', 'TIG', 'LAVAMANOS BATERIA', 'Normal', '2019-03-20 12:49:19', '2019-03-10', '2019-03-29 10:18:17', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32539, '1017156424', 'ATA SUDAMERING LTDA', 'CARGADOR BATERIA', 'Normal', '2019-03-20 12:43:59', '2019-04-02', '2019-04-04 16:16:43', 3, 1, 1, '2019-04-02', '2019-03-02', NULL, NULL, '', 'A tiempo', NULL),
(32541, '1216714539', 'GLOBUS SISTEMAS S.A.S ', 'CONVERSOR_TTL_RS232_PAULA_POKER ', 'Normal', '2019-03-20 15:11:34', '2019-04-08', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32542, '1216714539', 'ENERGIZANDO INGENIERIA Y CONSTRUCCION S.A.S. ', 'CRONOMETRO ', 'Normal', '2019-03-20 16:07:11', '2019-03-29', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32546, '1216714539', 'SOLUCIONES WIGA S.A.S ', 'PCBA015_1_1 ', 'Normal', '2019-03-21 08:57:52', '2019-05-07', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32547, '1216714539', 'SOLUCIONES WIGA S.A.S ', 'PCBA009_2_1 NODO 24 IN ', 'Normal', '2019-03-21 09:24:14', '2019-04-15', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32548, '1216714539', 'MEDENCOL ', ' EQUIPO EVO II 2014 CON MANDO ', 'Normal', '2019-03-21 09:49:41', '2019-04-02', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32549, '1216714539', 'UNIVERSIDAD NACIONAL DE COLOMBIA ', 'TARJETA DE CIRCUITO IMPRESO PCB ', 'Normal', '2019-03-21 14:21:52', '2019-04-01', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32550, '1216714539', 'FRECUENCIA Y VELOCIDAD ', ' CIRCUITO POTENCIA ', 'Normal', '2019-03-21 12:18:24', '2019-03-28', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32551, '1216714539', 'ORION HOLDING SAS ', 'PANEL ', 'Normal', '2019-03-21 13:58:32', '2019-04-04', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32553, '1216714539', 'ORLANDO JARAMILLO ZULETA ', 'Interfase R_Dig ', 'Normal', '2019-03-21 16:38:33', '2019-03-28', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32554, '1216714539', 'ORLANDO JARAMILLO ZULETA ', 'PoE Box ', 'Normal', '2019-03-21 16:41:46', '2019-04-02', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32555, '1216714539', 'ORLANDO JARAMILLO ZULETA ', 'Turbo_AC ', 'Normal', '2019-03-21 16:45:00', '2019-03-29', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32556, '1216714539', 'PITMMAM SAS ', 'COLLECTOR ', 'RQT', '2019-03-21 17:16:52', '2019-03-28', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32557, '1017156424', 'TECREA S.A.S ', 'iButton ANIMAL PRUEBA 64K BOOTLOADER ', 'Normal', '2019-03-22 08:49:00', '2019-04-04', NULL, 4, 1, 1, '2019-04-01', '2019-03-29', NULL, NULL, NULL, 'A tiempo', NULL),
(32558, '1216714539', 'TECREA S.A.S ', 'iButton ANIMAL PRUEBA 128K BOOTLOADER ', 'Normal', '2019-03-22 09:00:07', '2019-04-04', '2019-04-02 10:48:21', 3, 1, 1, '2019-04-01', '2019-03-29', NULL, NULL, '', 'A tiempo', NULL),
(32561, '1216714539', 'JOHNNY DANIEL SANCHEZ VANEGAS ', 'EFIS_B737 ', 'Normal', '2019-03-22 14:58:39', '2019-04-01', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32562, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', 'TARJETA SENSORES ', 'Normal', '2019-03-22 15:11:46', '2019-04-03', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32565, '1216714539', 'CREACIONES DALCA S.A.S ', 'GERBER ', 'Normal', '2019-03-26 07:40:16', '2019-04-05', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32566, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'OPMCVF_01 ', 'Normal', '2019-03-26 09:41:38', '2019-04-05', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32567, '1216714539', 'INTELMOTICS SAS ', 'Helo S V1.0 ', 'Normal', '2019-03-26 10:37:07', '2019-04-09', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32568, '1216714539', 'INTELMOTICS SAS ', ' EQUIPO HELO AIR ', 'Normal', '2019-03-26 10:39:20', '2019-04-09', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32569, '1216714539', 'EQUIPARME E.U ', 'PANEL BOVINO ', 'Normal', '2019-03-26 11:35:48', '2019-04-05', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32570, '1216714539', 'EQUIPARME E.U ', 'CONTROL BOVINO ', 'Normal', '2019-03-26 11:38:05', '2019-04-05', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32574, '1216714539', 'INSSA S.A.S ', ' ICS 4G ', 'Normal', '2019-03-26 16:49:19', '2019-04-02', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32575, '1216714539', 'INSSA S.A.S', 'INSSA - ICS GPS - MAR 14-19 ', 'Normal', '2019-03-26 16:52:53', '2019-04-01', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32576, '1216714539', 'JUAN PABLO SARMIENTO DIAZ GRANADOS ', ' ACT_MODULE ', 'Normal', '2019-03-26 17:06:10', '2019-04-12', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32577, '1216714539', 'HERNANDO GAMA DUARTE ', ' DOMINO 6.1 ', 'Normal', '2019-03-27 07:23:01', '2019-04-03', '2019-04-02 15:32:51', 3, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32578, '1216714539', 'TECHNOLOGY WELLS ', 'ALARMA GASES ', 'Normal', '2019-03-27 10:38:19', '2019-04-05', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32579, '1017156424', 'LUMEN', 'CIRCULAR 3030 63 LEDS', 'Normal', '2019-03-29 15:05:46', '2019-04-04', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32580, '1216714539', 'YEISON DANIEL TAPIERO SANTA ', ' LYREGLETA ', 'Normal', '2019-03-27 14:39:41', '2019-04-09', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32581, '1017156424', 'LUMEN', 'CIRCULAR   3030 49 LEDS', 'Normal', '2019-03-29 15:07:13', '2019-04-04', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32582, '1216714539', 'ASOCIACI%C3%93N VERDES PENSAMIENTOS ', ' TARJETA ', 'Normal', '2019-03-27 15:44:32', '2019-04-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32583, '1216714539', 'FUNDALCO S.A.S ', 'TARJETA ', 'Normal', '2019-03-27 15:49:55', '2019-04-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32585, '1216714539', 'ISWITCH   ANDRES FERNANDO ORTIZ TORRES ', 'HUELLASAUTOCORREGIDO1 ', 'Normal', '2019-03-27 17:33:41', '2019-04-05', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32586, '1216714539', 'CARLOS JOSE MEDINA GINER ', 'PRACTICA 3 ', 'Quick', '2019-03-28 10:18:27', '2019-03-29', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32587, '1216714539', 'ERASMO FRANCO ', 'Soldadura_MB45 ', 'Normal', '2019-03-28 10:50:04', '2019-04-03', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32589, '1216714539', 'ERASMO FRANCO ', ' SENOPTICO03 ', 'Normal', '2019-03-28 10:59:37', '2019-04-08', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32592, '1216714539', 'FREDY ORTIZ ', 'ORCA11 ', 'Normal', '2019-03-28 14:47:18', '2019-04-05', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32593, '1216714539', 'GOTTA SAS ', 'INTERFAZ LCD_MF500_EXT2 ', 'Normal', '2019-03-28 16:01:45', '2019-04-08', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32594, '1216714539', 'MICRO HOM S.A.S ', 'CONTROL PLANTA ', 'Normal', '2019-03-28 16:15:10', '2019-04-10', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32595, '1017156424', 'TECREA S.A.S', 'iButton Animal V2 Sensor Touch', 'Normal', '2019-03-29 13:16:01', '2019-04-03', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32596, '1216714539', 'ZIGO S.A.S ', 'MAQUINA 3S ', 'Normal', '2019-03-28 17:02:58', '2019-04-05', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32599, '1017156424', 'DOMETAL', '8539', 'Normal', '2019-04-22 06:33:05', '2019-04-25', NULL, 4, 1, 1, NULL, NULL, '2019-04-09', NULL, '', 'A tiempo', NULL),
(32600, '1017156424', 'DOMETAL', '8538', 'Normal', '2019-04-22 06:34:48', '2019-04-25', NULL, 4, 1, 1, NULL, NULL, '2019-04-09', NULL, '', 'A tiempo', NULL),
(32602, '1216714539', 'DANIEL ANDRES ROJAS PAREDES ', 'MTA 1 ', 'Normal', '2019-03-29 16:34:20', '2019-04-08', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32603, '1216714539', 'DANIEL ANDRES ROJAS PAREDES ', 'MTB 2 ', 'Normal', '2019-03-29 16:37:25', '2019-04-08', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32610, '1036650501', 'MARIO ANDRES VILLAMIZAR PALACIO', 'EOG MODULE TX', 'Normal', '2019-04-05 09:26:16', '2019-04-11', NULL, 1, 1, 1, '2019-04-08', '2019-04-11', NULL, NULL, NULL, NULL, NULL),
(32618, '1216714539', 'TECREA', 'TECREA-QUICK Acople sensor temperatura y humedad Disprolab-Abril 02-19 ', 'Quick', '2019-04-02 14:06:05', '2019-04-03', NULL, 1, 1, 1, '2019-04-03', '2019-04-03', NULL, NULL, NULL, NULL, NULL),
(32619, '1216714539', 'CELSA S.A.', 'CELSA-PCBA001_7_1 - ABR 1-19 ', 'Normal', '2019-04-02 14:31:58', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32621, '1216714539', 'MET GROUP SAS', 'MET GROUP SAS - Interfaz CAN - (ABR 02-19) ', 'Normal', '2019-04-02 15:14:31', '2019-04-09', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32622, '1216714539', 'MET GROUP SAS', 'MET GROUP SAS - UPS STS - (ABR 02-19) ', 'Normal', '2019-04-02 15:17:42', '2019-04-09', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32624, '1216714539', 'CHRISTIAN HASBUM MARTINEZ', 'CHRISTIAN HASBUN-DARF-MAR 27-19 ', 'Normal', '2019-04-08 07:17:58', '2019-04-11', NULL, 1, 1, 1, '2019-04-09', '2019-04-08', NULL, NULL, NULL, NULL, NULL),
(32625, '1216714539', 'CHRISTIAN HASBUM MARTINEZ', 'CHRISTIAN HASBUN-PROYECTO DABLE-MAR 28-19 ', 'Normal', '2019-04-08 07:20:31', '2019-04-24', NULL, 1, 1, 1, '2019-04-09', '2019-04-22', NULL, NULL, NULL, NULL, NULL),
(32626, '1216714539', 'RPM INGENIEROS S.A.S.', 'RPM - BOTONES PMR - ABR 02-19 ', 'Normal', '2019-04-03 07:13:12', '2019-04-10', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32627, '1216714539', 'JUAN FERNANDO OSORIO/ MIFE - MISCELANEA INTEGRAL FUTURISTAELECTRONICA', 'JUAN OSORIO - MCVF_CN04 (ABR 03-19) ', 'Normal', '2019-04-03 08:49:49', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32628, '1216714539', 'RAFAEL VEGA GONZALEZ', 'RAFAEL VEGA - MOSTRO_V3 (ABR 03-19) ', 'Normal', '2019-04-03 13:27:33', '2019-04-11', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32629, '1216714539', 'EXOTECHNO', 'CONTROLPROYECTO', 'Normal', '2019-04-03 14:05:22', '2019-04-25', NULL, 1, 1, 1, '2019-04-25', '2019-04-03', NULL, NULL, NULL, NULL, NULL),
(32630, '1216714539', 'DANIEL VELASQUEZ RODRIGUEZ', 'DANIEL VELASQUEZ - POWER_V2 (MAR 11-19) ', 'Normal', '2019-04-03 14:13:56', '2019-04-10', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32631, '1216714539', 'DANIEL VELASQUEZ RODRIGUEZ', 'DANIEL VELASQUEZ - ADE7763 (MAR 11-19) ', 'Normal', '2019-04-03 14:18:21', '2019-04-10', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32634, '1216714539', 'OPTEC POWER SAS', 'OPTEC - 25AC V10 - ABR 04-19 ', 'Normal', '2019-04-04 10:42:32', '2019-04-30', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32635, '1216714539', 'OPTEC POWER SAS', 'OPTEC - TD48A176TP-V1 - ABR 04-19 ', 'Normal', '2019-04-04 10:56:42', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32636, '1216714539', 'ESTEBAN RUIZ MUÑETON', 'ESTEBAN RUIZ - PCB_V1.0 (ABR 04-19) ', 'Normal', '2019-04-04 11:52:44', '2019-04-11', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32644, '1216714539', 'OPTEC POWER SAS', 'OPTEC - A24A53BP_V2 - ABR 04-19 ', 'Normal', '2019-04-05 07:32:40', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32645, '1216714539', 'INGENIERIA VML S.A.S', 'INGENIERIA VML S.A.S - PANEL_KBI_SCR (ABR 04-19) ', 'Normal', '2019-04-05 11:09:40', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32648, '1216714539', 'JUAN ESTEBAN AGUDELO', 'JUAN AGUDELO - RESISTENCIA ELECTRONICA 100W (ABR 04-19) ', 'Normal', '2019-04-05 15:00:55', '2019-04-11', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32649, '1216714539', 'UNIVERSIDAD DE ANTIOQUIA', 'WILLIAM ESCOBAR - HEATER_POWER (ABR 05-19) ', 'Normal', '2019-04-05 15:05:03', '2019-04-12', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32650, '1216714539', 'UNIVERSIDAD DE ANTIOQUIA', 'WILLIAM ESCOBAR - HEATER_CONTROL (ABR 05-19) ', 'Normal', '2019-04-05 15:12:59', '2019-04-12', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32651, '1216714539', 'UNIVERSIDAD DE ANTIOQUIA', 'WILLIAM ESCOBAR - WATER SOURCE (ABR 05-19) ', 'Normal', '2019-04-05 15:15:45', '2019-04-11', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32652, '1216714539', 'CARLOS AUGUSTO QUINTERO', 'CARLOS QUINTERO - AUTOTEC (ABR 04-19) FE ', 'Normal', '2019-04-05 16:13:56', '2019-04-12', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32653, '1216714539', 'AARON SANTIAGO PEDRAZA', 'AARON PEDRAZA - GRUPO 1_3 (ABR 05-19) ', 'Normal', '2019-04-05 16:19:03', '2019-04-12', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32654, '1036650501', 'INDUSTRIAS METALICAS LOS PINOS', 'TARJETA MICRO SW TRASLADO 160000461', 'Normal', '2019-04-05 16:46:49', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32656, '1216714539', 'DIGITELC SAS', 'DIGITELC - CARRO V5 (MAR 28-19) ', 'Normal', '2019-04-05 17:20:34', '2019-04-26', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32657, '1216714539', 'HERNANDO GAMA DUARTE', 'HERNANDO GAMA - EXTINTOR (ABR 05-19)', 'Normal', '2019-04-08 07:03:21', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32658, '1216714539', 'HERNANDO GAMA DUARTE', 'HERNANDO GAMA - TRACKER (ABR 05-19)', 'Normal', '2019-04-08 07:05:13', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32659, '1216714539', 'OSWALDO ALZATE VELASQUEZ', 'OSWALDO ALZATE - G_ADC_AXTEX_ISO3 (ABR 08-19) ', 'Normal', '2019-04-08 08:53:12', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32660, '1216714539', 'OSWALDO ALZATE VELASQUEZ', 'OSWALDO ALZATE - G_DAC_AXTEX_ISO4 (ABR 08-19) ', 'Normal', '2019-04-08 08:57:22', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32661, '1036650501', 'TECREA', 'HUB GPS WIFI', 'Normal', '2019-04-08 08:54:55', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32663, '1216714539', 'UNIVERSIDAD DE IBAGUE', 'DAVID ZAMBRANO - GLOBAL SENSORES (MAR 11-19) ', 'Normal', '2019-04-08 09:38:41', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32664, '1216714539', 'UNIVERSIDAD DE IBAGUE', 'DAVID ZAMBRANO - GLOBAL ACONDICIONAMIENTO (MAR 11-19) ', 'Normal', '2019-04-08 09:41:25', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32665, '1036650501', 'TECREA', 'ENSAMBLE ACOPLE IBUTTON LOGGER DISPROLAB', 'Normal', '2019-04-08 13:52:21', '2019-04-11', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32667, '1216714539', 'FREDY ORTIZ', 'FREDY ORTIZ - ORCA21_2019 (ABR 08-19) ', 'Normal', '2019-04-08 13:50:31', '2019-04-16', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32668, '1216714539', 'FREDY ORTIZ', 'FREDY ORTIZ - HALL2019 (ABR 08-19) ', 'Normal', '2019-04-08 13:52:52', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32669, '1216714539', 'FREDY ORTIZ', 'FREDY ORTIZ - PIX2019 (ABR 08-19) ', 'Normal', '2019-04-08 13:56:38', '2019-04-23', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32670, '1216714539', 'FREDY ORTIZ', 'FREDY ORTIZ - PUSH_B (ABR 08-19) ', 'Normal', '2019-04-08 14:01:22', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32671, '1216714539', 'UNIVERSIDAD EIA', 'SERGIO LOPEZ - ADPD188GG (ABR 02-19) ', 'Normal', '2019-04-08 16:08:37', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32672, '1216714539', 'INDUSTRIAS METALICAS LOS PINOS', 'LOS PINOS - IMPRESO 160000442 BLUETOOTH 4.0 V1 (22-09-18) - ABR 8-19 ', 'Normal', '2019-04-08 16:52:14', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32673, '1216714539', 'ORION HOLDING SAS  ', 'ORION HOLDING SAS - MAIN BOARD (ABR 08-19) ', 'Normal', '2019-04-08 17:26:08', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32674, '1216714539', 'IFORWARE S.A.S', 'IFORWARE S.A.S - PLACA (ABR 08-19) ', 'Normal', '2019-04-09 07:20:51', '2019-04-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32675, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA', 'MARTHA CASTIBLANCO - 5ANMASEJESV1 (ABR 05-19) ', 'Normal', '2019-04-09 11:02:22', '2019-04-16', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32676, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA', 'MARTHA CASTIBLANCO - VDR V6 (ABR 05-19) ', 'Normal', '2019-04-09 11:05:07', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32677, '1216714539', 'HARDOMO INNOVACION Y TECNOLOGIA', 'HARDOMO - CAL V.2 (ABR 08-19) ', 'Normal', '2019-04-09 11:34:25', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32678, '1216714539', 'PRODAING LTDA', 'ADRIAN DIAZ - THEROSTAR CONTROLLER - ABR 04-19 ', 'Quick', '2019-04-09 11:41:48', '2019-04-10', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32680, '1036650501', 'CELSIUS S.A.S.', 'SimulCor', 'Normal', '2019-04-10 10:35:51', '2019-04-15', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32682, '1216714539', 'Demo Ingeniería LTDA', 'DEMO INGENIERIA - FAN CTRL PANEL (ABR 08-19) ', 'Normal', '2019-04-10 07:15:27', '2019-04-16', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32684, '1216714539', 'LUISA FERNANDA VELASQUEZ ECHEVERRI / SMARTEAM', 'SMARTEAM - TARJETA PRINCIPAL (ABR 02-19) ', 'Normal', '2019-04-10 14:55:14', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32685, '1216714539', 'LUISA FERNANDA VELASQUEZ ECHEVERRI / SMARTEAM', 'SMARTEAM - TARJETA FUENTE (ABR 02-19) ', 'Normal', '2019-04-10 15:00:05', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32686, '1216714539', 'LUISA FERNANDA VELASQUEZ ECHEVERRI / SMARTEAM', 'SMARTEAM - TARJETA CONECTORES (ABR 02-19) ', 'Normal', '2019-04-10 15:04:31', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32687, '1216714539', 'CORPORACIÓN INDUSTRIAL MINUTO DE DIOS', 'FERNEY LOPEZ - GERBERFILE (ABR 02-19) ', 'Normal', '2019-04-10 15:51:21', '2019-04-17', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32688, '1216714539', 'GIOVANNI POSADA', 'GIOVANNI POSADA - ORIOL2 (ABR 05-19) ', 'Normal', '2019-04-11 08:01:54', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32689, '1216714539', 'RPM INGENIEROS S.A.S.', 'RPM - labels Splitter ISA - ABR 08-19 ', 'Normal', '2019-04-11 09:22:46', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32696, '1216714539', 'ECCOMYSE S.A.S ', 'Timer_ADC_V02 ', 'Normal', '2019-04-12 07:33:42', '2019-04-23', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32697, '1216714539', 'OPTEC POWER SAS', 'OPTEC - VAR25_V6 - ABR 12-19 ', 'Normal', '2019-04-12 09:10:33', '2019-05-08', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32698, '1216714539', 'OPTEC POWER SAS', 'OPTEC - 75DCB2 - ABR 12-19 ', 'Normal', '2019-04-12 09:55:39', '2019-04-30', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32699, '1216714539', 'UNIVERSIDAD EAFIT', 'JUAN AMAYA - FREE - ABR 04-19 ', 'Normal', '2019-04-12 10:08:46', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32700, '1216714539', 'MEDENCOL ', 'EVOL 1 2019 ', 'Normal', '2019-04-12 11:26:14', '2019-04-22', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32701, '1216714539', 'MEDENCOL', 'MEDENCOL - MANDOS MAXIM 2006 V7 (ABR 12-19) ', 'Normal', '2019-04-12 11:48:14', '2019-04-23', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32703, '1216714539', 'SIOMA SAS ', 'ADAPTADOR JACK GROVE ', 'Normal', '2019-04-12 15:08:57', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32704, '1036650501', 'MILLENIUM BPO S.A.', 'ACCESORIES', 'Normal', '2019-04-12 17:05:06', '2019-04-23', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32705, '1216714539', 'MILLENIUM BPO S.A.', 'MILLENIUM - MULTIBEC - ABR 09-19 ', 'Normal', '2019-04-12 17:02:00', '2019-04-23', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32706, '1216714539', 'MILLENIUM BPO S.A.', 'MILLENIUM - JETSONHAT - ABR 09-19 ', 'Normal', '2019-04-12 17:05:03', '2019-04-23', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32707, '1216714539', 'POWERSUN SAS', 'POWERSUN SAS - DISPLAY BASIC TOUCH - (ABR 04-19) ', 'Normal', '2019-04-12 17:10:44', '2019-04-23', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32708, '1216714539', 'CARLOS AUGUSTO QUINTERO', 'CARLOS QUINTERO - ACUABOARDESP32_WROOM (MAR 29-19) ', 'Normal', '2019-04-15 09:22:11', '2019-04-24', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32709, '1216714539', 'MD INGENIERIA Y COMUNICACIONES LIMITADA ', 'FUENTE PODER MAIN ', 'Normal', '2019-04-15 13:25:17', '2019-04-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32710, '1216714539', 'MD INGENIERIA Y COMUNICACIONES LIMITADA ', 'FUENTE PODER SECONDARY ', 'Normal', '2019-04-15 13:28:55', '2019-04-25', '2019-04-24 11:46:14', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32711, '1216714539', 'UNIVERSIDAD DE ANTIOQUIA ', ' D_POWER ', 'Normal', '2019-04-15 14:41:38', '2019-04-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32717, '1036650501', 'TECREA', 'Cama de pinchos - TRACFOX LORA', 'Normal', '2019-04-16 07:11:22', '2019-04-23', '2019-04-23 13:00:03', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32718, '1216714539', 'UNIVERSIDAD POPULAR DEL CESAR ', 'MSP LOADER ', 'Normal', '2019-04-16 07:24:07', '2019-05-02', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32719, '1216714539', 'HERNANDO GAMA DUARTE', 'HERNANDO GAMA - MONITOR INDUCTOTHERM1 (ABR 15-19) ', 'Normal', '2019-04-16 07:28:16', '2019-04-26', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32721, '1216714539', 'MAPLASCALI SAS', 'MAPLASCALI SAS - C26M (ABR 09-19) ', 'Normal', '2019-04-16 11:13:43', '2019-04-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32722, '1216714539', 'MAPLASCALI SAS', 'MAPLASCALI SAS - C26L (ABR 09-19) ', 'Normal', '2019-04-16 11:18:37', '2019-04-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32723, '1216714539', 'INDUSTRIAS LEO S.A', 'INDUSTRIAS LEO - PLAQUETA 23A - ABR 10-19 ', 'Normal', '2019-04-16 12:21:19', '2019-05-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32724, '1216714539', 'INDUSTRIAS LEO S.A', 'INDUSTRIAS LEO - PLAQUETA 801 REGULADOR CULATA - ABR 10-19 ', 'Normal', '2019-04-16 12:22:07', '2019-05-24', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32726, '1216714539', ' WILMAN MORALES REY,PROYECTOS Y SERVICIOS DE INGENIERÍA SAS', 'WM S.A.S - GERBER (ABR 08-19) ', 'Normal', '2019-04-17 07:41:36', '2019-05-08', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32727, '1216714539', 'WILMAN MORALES REY,PROYECTOS Y SERVICIOS DE INGENIERÍA SAS', 'WM S.A.S - RPI 2.2 BORNERA (ABR 16-19) ', 'Normal', '2019-04-17 07:43:56', '2019-04-30', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32730, '1216714539', 'JUAN FERNANDO OSORIO/ MIFE - MISCELANEA INTEGRAL FUTURISTAELECTRONICA', 'JUAN OSORIO - MCVF_RF_4S_PW (ABR 17-19) ', 'Normal', '2019-04-17 12:11:39', '2019-04-30', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32731, '1216714539', 'JUAN FERNANDO OSORIO/ MIFE - MISCELANEA INTEGRAL FUTURISTAELECTRONICA', 'JUAN OSORIO - MCVF80 (ABR 17-19) ', 'Normal', '2019-04-17 12:14:50', '2019-05-06', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32736, '1216714539', 'OPTEC POWER SAS', 'OPTEC - 25TPAUL3 - ABR 12-19 ', 'Normal', '2019-04-22 07:23:15', '2019-05-06', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32737, '1216714539', 'PAULA VILLADA ', 'PCB ', 'RQT', '2019-04-22 09:34:53', '2019-04-25', '2019-04-24 11:47:33', 3, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32738, '1216714539', 'OSWALDO ALZATE VELASQUEZ', 'OSWALDO ALZATE - G_DAC_AXTEX_FD2 (ABR 22-19) ', 'Normal', '2019-04-22 09:40:57', '2019-04-29', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32740, '1216714539', 'BEATRIZ SALAZAR ', 'TRABAJO FINAL ', 'Quick', '2019-04-22 11:46:39', '2019-04-23', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32741, '1216714539', 'BIOINNOVA S.A.S ', 'CARLOS VARGAS - OXICOM UNO SHIELD (ABR 16-19) ', 'Normal', '2019-04-22 11:45:07', '2019-04-29', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32742, '1216714539', 'DIDIER JEAN PAUL ROLDAN OLARTE ', 'JP POTENCIA ', 'Normal', '2019-04-22 13:31:09', '2019-04-26', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL);
INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `estado`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(32743, '1216714539', 'UNIVERSIDAD EAFIT ', 'FUENTE ', 'Normal', '2019-04-22 14:38:50', '2019-05-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32744, '1216714539', 'UNIVERSIDAD EAFIT ', 'DAQ DIGITAL ', 'Normal', '2019-04-22 14:41:01', '2019-05-03', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32746, '1216714539', 'MARIA ALEJANDRA ARBELAEZ GARCIA ', 'ILUMINACION ', 'Normal', '2019-04-22 15:31:22', '2019-04-29', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32748, '1216714539', 'ZIGO SAS', 'ZIGO - SMART FINAL (ABR 22-19) ', 'Normal', '2019-04-23 09:40:58', '2019-05-03', NULL, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32749, '1216714539', 'OPTEC POWER SAS', 'OPTEC - 90DC - ABR 23-19 ', 'Normal', '2019-04-23 09:58:32', '2019-05-07', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32750, '1216714539', 'OPTEC POWER SAS', 'OPTEC - OPA48A40TP-P1-V2- ABR 23-19 ', 'Normal', '2019-04-23 10:04:34', '2019-05-07', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32751, '1216714539', 'OPTEC POWER SAS', 'OPTEC - OPA48A40TP-P2-V2- ABR 23-19 ', 'Normal', '2019-04-23 10:20:12', '2019-05-07', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32752, '1216714539', 'GEOTECH S.A. ', 'BQ25606 INTEGRACION ', 'Normal', '2019-04-23 10:24:04', '2019-05-06', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32753, '1216714539', 'AMP SOLUCIONES SAS', 'AMP SOLUCIONES - CONTROL DISPLAY ENTRADA ANALOGA (ABR 22-19) ', 'Normal', '2019-04-23 11:16:19', '2019-04-30', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32755, '1216714539', 'PINZUAR LTDA ', ' PA 58 2_PA 79 2 ', 'Normal', '2019-04-23 15:03:58', '2019-05-07', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32756, '1216714539', 'UNIVERSIDAD DE IBAGUE', 'DAVID ZAMBRANO - DSP_MODULE (MAR 11-19) ', 'Normal', '2019-04-23 16:46:06', '2019-05-02', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32757, '1216714539', 'PARQUE EXPLORA ', 'SATELLITEBOARD ', 'Normal', '2019-04-23 16:57:42', '2019-05-03', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32762, '1216714539', 'KNOWLINE EPSRM SAS', 'KNOWLINE EPSRM SAS - OWL4_V2_TERPEL (ABR 23-19) ', 'Normal', '2019-04-24 09:28:24', '2019-05-02', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32763, '1216714539', 'OSCAR QUIROZ ORTEGA ', 'CircuitoTostadora_v1.1 ', 'Normal', '2019-04-24 09:44:00', '2019-05-02', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32765, '1216714539', 'DERY DEICY RESTREPO MESA ', ' TIMER ', 'Normal', '2019-04-24 15:45:58', '2019-05-21', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32768, '1216714539', 'CRISTIAN CAMILO CANO MANCO ', 'PCB 25 ', 'Normal', '2019-04-25 09:44:22', '2019-05-07', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servidor_reporte`
--

CREATE TABLE `servidor_reporte` (
  `idServidor_reporte` int(11) NOT NULL,
  `ipServidor` varchar(16) CHARACTER SET utf8 NOT NULL,
  `reporte` tinyint(1) DEFAULT NULL,
  `programa` tinyint(1) DEFAULT NULL,
  `puerto` varchar(4) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `servidor_reporte`
--

INSERT INTO `servidor_reporte` (`idServidor_reporte`, `ipServidor`, `reporte`, `programa`, `puerto`, `estado`) VALUES
(1, '192.168.4.152', 1, NULL, '5987', 1),
(5, '192.168.4.152', NULL, 0, '5146', 1),
(6, '192.168.4.152', 2, NULL, '5422', 0),
(7, '192.168.4.152', 1, NULL, '5860', 0),
(8, '192.168.5.0', 1, NULL, '5398', 0),
(9, '192.168.4.247', NULL, 3, '5561', 1),
(10, '192.168.4.247', 3, NULL, '5068', 1),
(11, '192.168.4.247', 3, NULL, '5895', 0),
(12, '192.168.4.173', 3, NULL, '5238', 0),
(13, '192.168.4.178', 3, NULL, '5120', 0),
(14, '192.168.5.221', 3, NULL, '5634', 0),
(15, '192.168.4.173', 1, NULL, '5437', 0),
(16, '192.168.4.103', 3, NULL, '5860', 1),
(17, '192.168.4.173', 2, NULL, '5525', 0),
(18, '192.168.4.103', 3, NULL, '5949', 0),
(19, '192.168.5.0', 1, NULL, '5625', 0),
(20, '192.168.4.173', 3, NULL, '5138', 0),
(21, '192.168.4.173', 1, NULL, '5945', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiempo_invertido_mes_proceso`
--

CREATE TABLE `tiempo_invertido_mes_proceso` (
  `idtiempo_invertido_mes_proceso` int(11) NOT NULL,
  `mes_corte` varchar(10) CHARACTER SET utf8 NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `tiempo` varchar(20) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tiempo_invertido_mes_proceso`
--

INSERT INTO `tiempo_invertido_mes_proceso` (`idtiempo_invertido_mes_proceso`, `mes_corte`, `idproceso`, `tiempo`) VALUES
(1, '2019-04-02', 1, '00:00:00'),
(2, '2019-04-02', 2, '00:00:00'),
(3, '2019-04-02', 3, '00:00:00'),
(4, '2019-04-02', 4, '00:00:00'),
(5, '2019-04-02', 5, '00:00:00'),
(6, '2019-04-02', 6, '00:00:00'),
(7, '2019-04-02', 7, '00:00:00'),
(8, '2019-04-02', 8, '00:00:00'),
(9, '2019-04-02', 9, '00:00:00'),
(10, '2019-04-02', 10, '00:00:00'),
(11, '2019-04-02', 15, '00:00:00'),
(12, '2019-04-02', 16, '00:00:00'),
(13, '2019-04-02', 17, '00:00:00'),
(14, '2019-04-02', 18, '00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiempo_invertido_producto_mes`
--

CREATE TABLE `tiempo_invertido_producto_mes` (
  `idtiempo_invertido_producto_mes` int(11) NOT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `mes` varchar(10) CHARACTER SET utf8 NOT NULL,
  `tiempo_proyecto_mes` varchar(20) CHARACTER SET utf8 NOT NULL,
  `cantidad_terminada` varchar(6) NOT NULL DEFAULT '0',
  `fecha_terminacion_cantidad` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tiempo_invertido_producto_mes`
--

INSERT INTO `tiempo_invertido_producto_mes` (`idtiempo_invertido_producto_mes`, `idDetalle_proyecto`, `mes`, `tiempo_proyecto_mes`, `cantidad_terminada`, `fecha_terminacion_cantidad`) VALUES
(1, 61, '2019-04-02', '00:00:00', '0', ''),
(2, 68, '2019-04-02', '00:00:11', '100', '30/03/2019'),
(3, 88, '2019-04-02', '00:00:00', '0', ''),
(4, 136, '2019-04-02', '00:00:00', '0', ''),
(5, 140, '2019-04-02', '00:00:00', '0', ''),
(6, 143, '2019-04-02', '00:00:00', '0', ''),
(7, 189, '2019-04-02', '00:00:00', '0', ''),
(8, 198, '2019-04-02', '00:00:00', '0', ''),
(9, 200, '2019-04-02', '00:00:00', '0', ''),
(10, 206, '2019-04-02', '00:00:00', '0', ''),
(11, 219, '2019-04-02', '00:00:00', '0', ''),
(12, 220, '2019-04-02', '00:00:00', '0', ''),
(13, 221, '2019-04-02', '00:00:00', '0', ''),
(14, 222, '2019-04-02', '00:00:00', '0', ''),
(15, 224, '2019-04-02', '00:00:00', '0', ''),
(16, 228, '2019-04-02', '00:00:00', '0', ''),
(17, 229, '2019-04-02', '00:00:00', '0', ''),
(18, 235, '2019-04-02', '00:00:00', '0', ''),
(19, 247, '2019-04-02', '00:00:00', '0', ''),
(20, 250, '2019-04-02', '00:00:00', '0', ''),
(21, 258, '2019-04-02', '00:00:00', '0', ''),
(22, 261, '2019-04-02', '00:00:00', '0', ''),
(23, 263, '2019-04-02', '00:00:00', '0', ''),
(24, 266, '2019-04-02', '00:00:00', '0', ''),
(25, 267, '2019-04-02', '00:00:00', '0', ''),
(26, 268, '2019-04-02', '00:00:00', '0', ''),
(27, 269, '2019-04-02', '00:00:00', '0', ''),
(28, 270, '2019-04-02', '00:00:00', '0', ''),
(29, 273, '2019-04-02', '00:00:00', '0', ''),
(30, 274, '2019-04-02', '00:00:00', '0', ''),
(31, 275, '2019-04-02', '00:00:00', '0', ''),
(32, 276, '2019-04-02', '00:00:00', '0', ''),
(33, 277, '2019-04-02', '00:00:00', '0', ''),
(34, 278, '2019-04-02', '00:00:00', '0', ''),
(35, 279, '2019-04-02', '00:00:00', '0', ''),
(36, 283, '2019-04-02', '00:00:00', '0', ''),
(37, 284, '2019-04-02', '00:00:00', '0', ''),
(38, 285, '2019-04-02', '00:00:00', '0', ''),
(39, 286, '2019-04-02', '00:00:00', '0', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `numero_documento` varchar(13) NOT NULL,
  `tipo_documento` varchar(3) NOT NULL,
  `nombres` varchar(30) NOT NULL,
  `apellidos` varchar(30) DEFAULT NULL,
  `cargo_idcargo` tinyint(4) NOT NULL,
  `imagen` varchar(250) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL,
  `contraeña` varchar(20) NOT NULL,
  `sesion` tinyint(1) DEFAULT '0',
  `recuperacion` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`numero_documento`, `tipo_documento`, `nombres`, `apellidos`, `cargo_idcargo`, `imagen`, `estado`, `contraeña`, `sesion`, `recuperacion`) VALUES
('1017156424', 'CC', 'YAZMIN ANDREA', 'GALEANO CASTAÑEDA', 6, '', 1, 'yazmin1987', 1, 'dñpgxp68@4'),
('1017191779', 'CC', 'Sintia Liceth', 'Ossa Vasquez', 6, '', 0, '1017191779', 0, '51e-uiññl9'),
('1020479554', 'CC', 'Sebastian', 'Gallego Perez', 3, NULL, 1, '1020479554', 0, '6wjnnjg5a-'),
('1036650501', 'CC', 'DANIELA', 'GIRALDO ARIAS', 6, NULL, 1, '1036650501', 0, 'vch04udzn0'),
('1037587834', 'CC', 'Heidy Jhoana', 'Marulanda Restrepo', 3, '', 1, '1037587834', 1, 'sxpddlctvf'),
('1040044905', 'CC', 'Jose Daniel ', 'Grajales Carmona', 1, '', 1, '1040044905', 0, 'z9jmqbñ2kl'),
('1078579715', 'CC', 'MAIBER DAVID ', 'GONZALEZ MERCADO ', 1, '', 0, '3108967039', 0, 'w7n8pjyhd8'),
('1128266934', 'CC', 'Jhon Fredy', 'Velez Londoño', 4, '', 1, '1128266934', 0, '4elax2f2ub'),
('1152210828', 'CC', 'PAULA ANDREA ', 'HERRERA ÁLVAREZ', 5, '', 1, '1152210828', 1, 'eimaumks9s'),
('1152697088', 'CC', 'Diana Marcela', 'Patiño Cardona', 6, '', 1, '1152697088', 0, '1@zujadnñk'),
('1216714539', 'CC', 'Maria alejandra ', 'zuluaga rivera', 6, '', 1, '1216714539', 1, '84@w8wli4a'),
('123456789', 'CC', 'Almacen', '', 5, '', 0, '123456789', 0, 'jfmhh0vq5b'),
('42800589', 'CC', 'Juliana', 'Naranjo Henao', 6, '', 0, '42800589', 0, '-cnño-5wb4'),
('43263856', 'CC', 'Paula Andrea', 'Lopez Gutierrrez', 1, '', 1, '43263856', 0, 'cxcx03ñkf4'),
('43583398', 'CC', 'Viviana', 'Echavarria Machado', 4, NULL, 1, '43583398', 1, 'snbzyh7s@q'),
('43975208', 'CC', 'GLORIA ', 'JARAMILLO ', 2, '', 1, '43975208', 1, 'kbdnsdlciq'),
('71268332', 'CC', 'Adimaro', 'Montoya', 3, '', 0, '71268332', 0, '1vr8s4th-@'),
('981130', 'CC', 'Juan David', 'Marulanda Paniagua', 4, '', 1, '98113053240juan', 0, '1u-hyppy60'),
('98113053240', 'CC', 'Juan david', 'Marulanda Paniagua', 3, '', 1, '98113053240', 1, 'ue2282qgo1'),
('98699433', 'CC', 'ANDRES CAMILO', 'BUITRAGO GÓMEZ', 1, '', 1, '98699433', 0, 'ñkzrv7l@uh'),
('98765201', 'CC', 'EDISSON ANDRES', 'BARAHONA CASTRILLON', 6, '', 1, '98765201', 0, 'q1-4i3i99t');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuariopuerto`
--

CREATE TABLE `usuariopuerto` (
  `documentousario` varchar(13) CHARACTER SET utf8 DEFAULT NULL,
  `usuarioPuerto` varchar(6) DEFAULT NULL,
  `rutaQRs` varchar(150) DEFAULT NULL,
  `estadoLectura` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuariopuerto`
--

INSERT INTO `usuariopuerto` (`documentousario`, `usuarioPuerto`, `rutaQRs`, `estadoLectura`) VALUES
('43975208', 'COM11', NULL, 1),
('1017156424', 'COM1', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('981130', 'COM5', 'C:\\Users\\sis.informacion01\\Desktop\\', 0),
('71268332', 'COM1', NULL, 0),
('1128266934', 'COM4', NULL, 0),
('98765201', 'COM1', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('1216714539', 'COM5', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('1152697088', 'COM5', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('98113053240', 'COM7', NULL, 0),
('123456789', 'COM7', NULL, 0),
('1020479554', 'COM9', NULL, 0),
('1037587834', 'COM7', NULL, 1),
('1036650501', 'COM11', '\\\\servidor\\Proyectos2\\3 - QR\\', 0);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`idalmacen`),
  ADD KEY `fk_iddetalleproyecto_amacen` (`idDetalle_proyecto`),
  ADD KEY `fk_proceso_id` (`idproceso`);

--
-- Indices de la tabla `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`idArea`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`idcargo`);

--
-- Indices de la tabla `color_antisolder`
--
ALTER TABLE `color_antisolder`
  ADD PRIMARY KEY (`idColor_antisolder`);

--
-- Indices de la tabla `condicion_producto`
--
ALTER TABLE `condicion_producto`
  ADD PRIMARY KEY (`idCondicion`),
  ADD KEY `fk_condicion_producto_producto1_idx` (`idProducto`);

--
-- Indices de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD PRIMARY KEY (`idDetalle_ensamble`,`idDetalle_proyecto`,`idproceso`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`idDetalle_proyecto`),
  ADD KEY `fk_detalle_ensamble_Procesos1_idx` (`idproceso`);

--
-- Indices de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD PRIMARY KEY (`idDetalle_formato_estandar`,`idDetalle_proyecto`,`idproceso`),
  ADD KEY `fk_detalle_formato_estandar_detalle_proyecto1_idx` (`idDetalle_proyecto`),
  ADD KEY `fk_detalle_formato_estandar_Procesos1_idx` (`idproceso`);

--
-- Indices de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD PRIMARY KEY (`idDetalle_proyecto`,`idProducto`,`proyecto_numero_orden`,`idArea`),
  ADD KEY `fk_detalle_proyecto_proyecto1_idx` (`proyecto_numero_orden`),
  ADD KEY `fk_detalle_proyecto_producto1_idx` (`idProducto`),
  ADD KEY `fk_detalle_proyecto_area1_idx` (`idArea`);

--
-- Indices de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD PRIMARY KEY (`idDetalle_teclados`,`idDetalle_proyecto`,`idproceso`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`idDetalle_proyecto`),
  ADD KEY `fk_detalle_teclados_Procesos1_idx` (`idproceso`);

--
-- Indices de la tabla `espesor`
--
ALTER TABLE `espesor`
  ADD PRIMARY KEY (`idEspesor`);

--
-- Indices de la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD PRIMARY KEY (`idproceso`,`idArea`),
  ADD KEY `fk_Procesos_area1_idx` (`idArea`);

--
-- Indices de la tabla `procesos_producto`
--
ALTER TABLE `procesos_producto`
  ADD PRIMARY KEY (`idProceso_producto`),
  ADD KEY `fk_Procesos_productoto_condicion_producto1_idx` (`idCondicion`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idproducto`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`numero_orden`,`usuario_numero_documento`),
  ADD UNIQUE KEY `numero_orden_UNIQUE` (`numero_orden`),
  ADD KEY `fk_proyecto_usuario_idx` (`usuario_numero_documento`);

--
-- Indices de la tabla `servidor_reporte`
--
ALTER TABLE `servidor_reporte`
  ADD PRIMARY KEY (`idServidor_reporte`);

--
-- Indices de la tabla `tiempo_invertido_mes_proceso`
--
ALTER TABLE `tiempo_invertido_mes_proceso`
  ADD PRIMARY KEY (`idtiempo_invertido_mes_proceso`),
  ADD KEY `fk_tiempo_invertido_mes_proceso_procesos1_idx` (`idproceso`);

--
-- Indices de la tabla `tiempo_invertido_producto_mes`
--
ALTER TABLE `tiempo_invertido_producto_mes`
  ADD PRIMARY KEY (`idtiempo_invertido_producto_mes`),
  ADD KEY `fk_tiempo_invertido_producto_mes_detalle_proyecto1_idx` (`idDetalle_proyecto`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`numero_documento`,`cargo_idcargo`),
  ADD UNIQUE KEY `numero_documento_UNIQUE` (`numero_documento`),
  ADD KEY `fk_usuario_cargo1_idx` (`cargo_idcargo`);

--
-- Indices de la tabla `usuariopuerto`
--
ALTER TABLE `usuariopuerto`
  ADD KEY `fk_usuario_puerto1` (`documentousario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacen`
--
ALTER TABLE `almacen`
  MODIFY `idalmacen` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `area`
--
ALTER TABLE `area`
  MODIFY `idArea` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `idcargo` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `color_antisolder`
--
ALTER TABLE `color_antisolder`
  MODIFY `idColor_antisolder` tinyint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `condicion_producto`
--
ALTER TABLE `condicion_producto`
  MODIFY `idCondicion` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1425;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=466;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `espesor`
--
ALTER TABLE `espesor`
  MODIFY `idEspesor` tinyint(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `procesos`
--
ALTER TABLE `procesos`
  MODIFY `idproceso` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `procesos_producto`
--
ALTER TABLE `procesos_producto`
  MODIFY `idProceso_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=179;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32769;

--
-- AUTO_INCREMENT de la tabla `servidor_reporte`
--
ALTER TABLE `servidor_reporte`
  MODIFY `idServidor_reporte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `tiempo_invertido_mes_proceso`
--
ALTER TABLE `tiempo_invertido_mes_proceso`
  MODIFY `idtiempo_invertido_mes_proceso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `tiempo_invertido_producto_mes`
--
ALTER TABLE `tiempo_invertido_producto_mes`
  MODIFY `idtiempo_invertido_producto_mes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD CONSTRAINT `fk_iddetalleproyecto_amacen` FOREIGN KEY (`idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`),
  ADD CONSTRAINT `fk_proceso_id` FOREIGN KEY (`idproceso`) REFERENCES `procesos` (`idproceso`);

--
-- Filtros para la tabla `condicion_producto`
--
ALTER TABLE `condicion_producto`
  ADD CONSTRAINT `fk_condicion_producto_producto1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD CONSTRAINT `fk_detalle_ensamble_Procesos1` FOREIGN KEY (`idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ensamble_detalle_proyecto10` FOREIGN KEY (`idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD CONSTRAINT `fk_detalle_formato_estandar_Procesos1` FOREIGN KEY (`idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_formato_estandar_detalle_proyecto1` FOREIGN KEY (`idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD CONSTRAINT `fk_detalle_proyecto_area1` FOREIGN KEY (`idArea`) REFERENCES `area` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_producto1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idproducto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_proyecto1` FOREIGN KEY (`proyecto_numero_orden`) REFERENCES `proyecto` (`numero_orden`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD CONSTRAINT `fk_detalle_teclados_Procesos1` FOREIGN KEY (`idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_detalle_proyecto1` FOREIGN KEY (`idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD CONSTRAINT `fk_Procesos_area1` FOREIGN KEY (`idArea`) REFERENCES `area` (`idArea`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `procesos_producto`
--
ALTER TABLE `procesos_producto`
  ADD CONSTRAINT `fk_Procesos_productoto_condicion_producto1` FOREIGN KEY (`idCondicion`) REFERENCES `condicion_producto` (`idCondicion`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `fk_proyecto_usuario` FOREIGN KEY (`usuario_numero_documento`) REFERENCES `usuario` (`numero_documento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tiempo_invertido_mes_proceso`
--
ALTER TABLE `tiempo_invertido_mes_proceso`
  ADD CONSTRAINT `fk_tiempo_invertido_mes_proceso_procesos1` FOREIGN KEY (`idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tiempo_invertido_producto_mes`
--
ALTER TABLE `tiempo_invertido_producto_mes`
  ADD CONSTRAINT `fk_tiempo_invertido_producto_mes_detalle_proyecto1` FOREIGN KEY (`idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_usuario_cargo1` FOREIGN KEY (`cargo_idcargo`) REFERENCES `cargo` (`idcargo`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuariopuerto`
--
ALTER TABLE `usuariopuerto`
  ADD CONSTRAINT `fk_usuario_puerto1` FOREIGN KEY (`documentousario`) REFERENCES `usuario` (`numero_documento`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
