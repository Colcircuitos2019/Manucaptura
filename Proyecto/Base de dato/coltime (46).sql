-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-03-2019 a las 22:21:49
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarProductoPorMinuto` (IN `detalle` INT, IN `area` INT, IN `lector` INT, IN `tiempo` VARCHAR(20))  NO SQL
BEGIN
# ...
IF area=1 THEN # Formato estandar - FE

	UPDATE detalle_formato_estandar d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;

ELSE
 IF area=2 THEN # Teclados - TE
  
 	UPDATE detalle_teclados d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;
 
 ELSE # Ensamble - EN
  
 	UPDATE detalle_ensamble d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;
 
 END IF;
END IF;
# ...
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalPorUnidad` (IN `detalle` INT, IN `tiempo` VARCHAR(20))  NO SQL
UPDATE detalle_proyecto dp SET dp.Total_timepo_Unidad=tiempo WHERE dp.idDetalle_proyecto=detalle$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarTiempoTotalProducto` (IN `detalle` INT, IN `cadena` VARCHAR(20))  NO SQL
BEGIN

UPDATE detalle_proyecto dp SET dp.tiempo_total=cadena WHERE dp.idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualziarCantidadProcesosEnsamble` (IN `ID` INT, IN `cantidades` VARCHAR(10))  NO SQL
BEGIN
#Cantidad que tiene el proceso de ensamble para procesar.
UPDATE detalle_ensamble e SET e.cantidadProceso=cantidades WHERE e.idDetalle_ensamble=ID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CalcularTiempoEjecucionProceso` (IN `detalle` INT, IN `lector` INT, IN `area` INT)  NO SQL
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

# Tiempo de ejecucion del proceso <- Este formato de tiempo que le estoy asignando no me sirve. Ver la forma de modificarlo a 00:00
SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') from detalle_formato_estandar f WHERE f.idDetalle_formato_estandar=idDetalleProceso);

# Numero de operarios que trabajan en el proceso de la OP
SET numero_operarios = (SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.idDetalle_formato_estandar = idDetalleProceso);

SELECT timpo_total_proceso, (SELECT CONVERT(sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios), char(10))) AS tiempo_ejecucion;

#SELECT f.tiempo_total_por_proceso, (SELECT sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios)) AS tiempo_ejecucion FROM detalle_formato_estandar f WHERE f.idDetalle_formato_estandar = idDetalleProceso;

#Actualizar el tiempo total de ejecucion del proceso
#UPDATE detalle_formato_estandar f SET f.tiempo_total_por_proceso = (SELECT ADDTIME(timpo_total_proceso,(SELECT sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios)))) WHERE f.idDetalle_formato_estandar=idDetalleProceso;

# Este select significa que el procedimiento fue ejecutado correctamente
#SELECT 1 AS respuesta;
# ...
ELSE
 IF area=2 THEN
 
	SET idDetalleProceso=(SELECT t.idDetalle_teclados from detalle_teclados t JOIN detalle_proyecto d on t.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and t.idproceso=lector);

	UPDATE detalle_teclados t SET  t.hora_terminacion=now() WHERE t.idDetalle_teclados=idDetalleProceso;

	# Tiempo total del proceso
	SET timpo_total_proceso = (SELECT t.tiempo_total_por_proceso from detalle_teclados t WHERE t.idDetalle_teclados=idDetalleProceso);

	# Tiempo de ejecucion del proceso <- Este formato de tiempo que le estoy asignando no me sirve. Ver la forma de modificarlo a 00:00
	SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(t.hora_terminacion,t.hora_ejecucion),'%H:%i:%s') from detalle_teclados t WHERE t.idDetalle_teclados = idDetalleProceso);

	# Numero de operarios que trabajan en el proceso de la OP
	SET numero_operarios = (SELECT t.noperarios FROM detalle_teclados t WHERE t.idDetalle_teclados = idDetalleProceso);

	SELECT timpo_total_proceso, (SELECT CONVERT(sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios),char(10))) AS tiempo_ejecucion;

#SELECT t.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(t.hora_terminacion,t.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_teclados t JOIN detalle_proyecto d on t.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=numOrden AND d.idDetalle_proyecto=detalle and t.idproceso=lector and t.estado=4;

 ELSE
  IF area=3 THEN
  
  	SET idDetalleProceso=(SELECT e.idDetalle_ensamble from detalle_ensamble e JOIN detalle_proyecto d on e.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and e.idproceso=lector);

 	UPDATE detalle_ensamble e SET  e.hora_terminacion=now() WHERE e.idDetalle_ensamble=idDetalleProceso;
  
  # Tiempo total del proceso
	SET timpo_total_proceso = (SELECT e.tiempo_total_por_proceso from detalle_ensamble e WHERE e.idDetalle_ensamble=idDetalleProceso);

	# Tiempo de ejecucion del proceso <- Este formato de tiempo que le estoy asignando no me sirve. Ver la forma de modificarlo a 00:00
	SET tiempo_ejecucion = (SELECT TIME_FORMAT(TIMEDIFF(e.hora_terminacion,e.hora_ejecucion),'%H:%i:%s') from detalle_ensamble e WHERE e.idDetalle_ensamble = idDetalleProceso);

	# Numero de operarios que trabajan en el proceso de la OP
	SET numero_operarios = (SELECT e.noperarios FROM detalle_ensamble e WHERE e.idDetalle_ensamble = idDetalleProceso);

	SELECT timpo_total_proceso, (SELECT CONVERT(sec_to_time(time_to_sec(tiempo_ejecucion) * numero_operarios),char(10))) AS tiempo_ejecucion;
  #SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=numOrden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4;
  
  END IF;
 
 END IF;
# ... Queda pendiente Almacen - AL
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProductos` (IN `area` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE iniciar int;
DECLARE pausar int;
DECLARE terminar int;
DECLARE ejecucion int;
SET iniciar=(SELECT d.pro_porIniciar FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET pausar=(SELECT d.pro_Pausado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET ejecucion=(SELECT d.pro_Ejecucion FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET terminar=(SELECT d.pro_Terminado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

IF area=1 OR area=4 THEN 

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado=1 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF ejecucion>=1 THEN
  UPDATE detalle_proyecto d SET d.estado=4 WHERE d.idDetalle_proyecto=detalle;
 ELSE
   IF pausar!=0 and ejecucion=0 and (terminar=0 or terminar!=0) THEN
  UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=detalle; 
  ELSE
   IF pausar=0 and ejecucion=0 and terminar!=0 AND iniciar!=0 THEN
   UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=detalle;
   ELSE
        IF (iniciar+pausar+ejecucion+terminar)=terminar AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  UPDATE detalle_proyecto d SET d.estado=3,d.fecha_salida=(SELECT now()) WHERE d.idDetalle_proyecto=detalle;  
    END IF;
   END IF;
  END IF;
 END IF;
END IF;  
 

ELSE
 IF area=2 OR area=3 THEN

  IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado=1 WHERE d.idDetalle_proyecto=detalle;
  END IF;


IF ejecucion >= 1  THEN
UPDATE detalle_proyecto d SET d.estado=4 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF pausar!=0 and ejecucion=0 and (terminar!=0 or terminar=0) THEN
    UPDATE detalle_proyecto d SET d.estado=2 WHERE d.idDetalle_proyecto=detalle;
 ELSE
  IF terminar!=0 AND ejecucion=0 AND pausar=0 THEN
        CALL PA_CambiarEstadoTerminadoTEIN(area,detalle);
   END IF;
 END IF;
END IF;

 END IF;
END IF;

CALL PA_CambiarEstadoDeProyecto((SELECT d.proyecto_numero_orden FROM detalle_proyecto d where d.idDetalle_proyecto=detalle));
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoTerminadoTEIN` (IN `area` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE res boolean;
IF area=2 THEN
  IF EXISTS(SELECT d.estado FROM detalle_teclados d where    d.idDetalle_proyecto=detalle AND d.idproceso=14 AND d.estado=3) THEN#El 14 es el proceso

 SET res= true;
 
 ELSE 

 SET res = false;

 END IF;

ELSE 
  IF area=3 THEN
 IF EXISTS(SELECT d.estado FROM detalle_ensamble d where    d.idDetalle_proyecto=detalle AND d.idproceso=18 AND d.estado=3) THEN#El 18 ese el proceso

 SET res= true;
 
 ELSE 

 SET res = false;
  
  END IF;
  
 END IF;
END IF;


IF res THEN

 UPDATE detalle_proyecto p SET p.estado=3,p.fecha_salida=(SELECT now())  where p.idDetalle_proyecto=detalle;
ELSE
  UPDATE detalle_proyecto p SET p.estado=2 where p.idDetalle_proyecto=detalle;

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

CREATE DEFINER=`` PROCEDURE `PA_ConsultarCondicionesProductos` (IN `idCondicion` INT)  NO SQL
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

/*IF estado=0 THEN
SELECT d.idDetalle_proyecto,n.nom_area,t.nombre,d.canitadad_total,d.estado, d.PNC,d.ubicacion,d.material,p.parada FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden;
ELSE
SELECT d.idDetalle_proyecto,n.nom_area,t.nombre,d.canitadad_total,d.estado, d.PNC,d.ubicacion,d.material,p.parada FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden and p.eliminacion=1;
END IF;*/

SELECT d.idDetalle_proyecto,n.nom_area,t.nombre,d.canitadad_total,d.estado, d.PNC,d.material, d.antisolder, d.ruteo FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea WHERE d.proyecto_numero_orden=orden;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarEstadoLecturaFacilitador` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.estadoLectura FROM usuariopuerto u WHERE u.documentousario= doc;

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

CREATE DEFINER=`` PROCEDURE `PA_ConsultarProcesosProductoProyecto` (IN `idDetalleProducto` VARCHAR(11), IN `area` VARCHAR(2))  NO SQL
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarPRocesosReporteENoTE` (IN `op` INT)  NO SQL
BEGIN
# Ensamble=3; teclados=2; Formato estandar=1
#...
SELECT * FROM procesos WHERE idArea=op AND estado=1;
#...
END$$

CREATE DEFINER=`` PROCEDURE `PA_ConsultarProductos` ()  NO SQL
BEGIN

	SELECT * FROM producto p;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDelDetalleDelproyecto` (IN `detalle` INT, IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') as inicio,Date_format(f.fecha_fin,'%d-%M-%Y') as fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') as hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%S') as InicioTerminadoIntervalo,f.idDetalle_formato_estandar,CONVERT(f.orden, int),f.noperarios, f.cantidadProceso FROM detalle_formato_estandar f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
ELSE
  IF area=2 THEN
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') AS inicio,Date_format(f.fecha_fin,'%d-%M-%Y') AS fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S')as tiempoActual,
TIME_FORMAT(f.hora_terminacion,'%r') AS hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') AS InicioTerminadoIntervalo,f.idDetalle_teclados,CONVERT(f.orden, int),f.noperarios, f.cantidadProceso FROM detalle_teclados f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
  ELSE
   IF area=3 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') AS inicio,Date_format(f.fecha_fin,'%d-%M-%Y') AS fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r') AS horaInicio,TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') AS hora_terminacion,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') AS InicioTerminadoIntervalo ,f.idDetalle_ensamble,CONVERT(f.orden,int),f.noperarios,f.cantidadProceso FROM detalle_ensamble f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
   ELSE
    IF area=4 THEN
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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarCambiarEstadoProyecto` (IN `orden` INT)  NO SQL
BEGIN
UPDATE proyecto p SET p.eliminacion=0 WHERE p.numero_orden=orden;

END$$

CREATE DEFINER=`` PROCEDURE `PA_EliminarProcesoProducto` (IN `idDetalleProducto` INT, IN `area` INT)  NO SQL
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

CREATE DEFINER=`` PROCEDURE `PA_EliminarProcesosCondicionProducto` (IN `idProcesoP` INT)  NO SQL
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

CREATE DEFINER=`` PROCEDURE `PA_EliminarProcesosProductoProyecto` (IN `idDetalleProducto` INT, IN `area` INT)  NO SQL
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
SELECT d.idDetalle_proyecto,d.idProducto,d.idArea,DATE_FORMAT(p.fecha_entrega,'%d-%m-%Y'),p.nombre_proyecto,d.canitadad_total,d.material from proyecto p JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN producto t ON d.idProducto=t.idProducto where d.proyecto_numero_orden=orden and d.PNC=0;
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

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado,pp.tipo_proyecto,dp.lider_proyecto,en.cantidad_terminada,en.cantidadProceso,en.orden FROM detalle_ensamble en LEFT JOIN detalle_proyecto dp ON en.idDetalle_proyecto=dp.idDetalle_proyecto JOIN procesos p ON en.idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden JOIN producto t ON dp.idProducto=t.idproducto WHERE  dp.idArea=3 AND pp.estado!=3 AND dp.estado!=3 AND pp.eliminacion!=0 ORDER BY dp.proyecto_numero_orden,dp.idProducto,en.orden;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNFE` ()  NO SQL
BEGIN

#SELECT p.numero_orden,d.material,p.tipo_proyecto,tn.nombre as tipoNegocio,d.canitadad_total,df.cantidad_terminada,df.idproceso,df.estado,d.PNC FROM proyecto p RIGHT JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN detalle_formato_estandar df ON d.idDetalle_proyecto=df.idDetalle_proyecto JOIN producto tn on d.idProducto=tn.idproducto WHERE d.idArea=1 AND p.eliminacion=1 AND d.estado!=3 GROUP BY d.idDetalle_proyecto,df.idproceso ORDER BY d.proyecto_numero_orden ASC;
SELECT d.proyecto_numero_orden,d.material,p.tipo_proyecto,tn.nombre,d.canitadad_total,df.cantidad_terminada,df.cantidadProceso,df.idproceso,df.estado,d.ubicacion FROM detalle_formato_estandar df RIGHT JOIN detalle_proyecto d ON df.idDetalle_proyecto=d.idDetalle_proyecto LEFT JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden JOIN producto tn on d.idProducto=tn.idproducto where d.idArea=1 AND p.eliminacion=1 AND d.estado!=3 AND df.cantidad_terminada is not null GROUP BY d.idDetalle_proyecto,df.idproceso ORDER BY d.proyecto_numero_orden,tn.nombre,d.PNC,d.ubicacion;
# AND df.fecha_fin is null
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNTE` ()  NO SQL
BEGIN

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,t.noperarios,t.estado,pp.tipo_proyecto,t.cantidad_terminada,t.cantidadProceso,t.orden FROM detalle_teclados t LEFT JOIN detalle_proyecto dp ON t.idDetalle_proyecto=dp.idDetalle_proyecto LEFT JOIN procesos p ON t.idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden WHERE pp.estado!=3 AND dp.estado!=3 AND pp.eliminacion!=0 AND dp.idArea=2 ORDER BY dp.proyecto_numero_orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarRenaudarTomaDeTiempoProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `oper` INT(3))  NO SQL
BEGIN
DECLARE id int;
DECLARE id1 int;
DECLARE cantidadp int;

IF busqueda=1 THEN

set id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=1);

set id1=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=2);

IF id !='null' THEN
#Cuando se iniciar el proceso por primera vez
UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_formato_estandar=id;
END IF;

IF id1 !='null' THEN
#Cuando se inicia el proceso por segunda o más veces
UPDATE detalle_formato_estandar f SET  f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id1;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;

ELSE
  IF busqueda=2 THEN
  
  set id=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=1);

set id1=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=2);

IF id !='null' THEN
#Cuando se iniciar el proceso por primera vez
UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_teclados=id ;
END IF;

IF id1 !='null' THEN
#Cuando se inicia el proceso por segunda o más veces
UPDATE detalle_teclados f SET f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_teclados=id1 ;
END IF;
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  
  ELSE 
    IF busqueda =3 THEN
    
set id=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=1);

set id1=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=2); 

IF id !='null' THEN
#Cuando se iniciar el proceso por primera vez
UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_ensamble=id;
END IF;

IF id1 !='null' THEN
#Cuando se inicia el proceso por segunda o más veces
UPDATE detalle_ensamble f SET  f.estado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_ensamble=id1 ;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
    
    END IF;  
  END IF;
END IF;
            CALL PA_CambiarEstadoDeProductos(busqueda,detalle);
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
#Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=idDetalleProducto);
  SELECT FU_ClasificarEstadoProcesos(idDetalleProceso,idDetalleProceso2,cantidadp,area);
  #...
ELSE
 IF area=2 THEN
 #... El proceso final se tiene que buscar el proceso con orden mayor para saber que ese es el proceso final.
 # Remplazar el id del proceso final "FU_ConsultarUltimoProceso"
  IF procesoPasar=0 AND idLector!=(SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto, area)) THEN# #Consultar el proceso final de la OP
  	SET cantidadTerminada=0;
  END IF;
  #...
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
  IF procesoPasar=0 AND idLector!= (SELECT FU_ConsultarProcesoFinalSeleccionado(idDetalleProducto, area)) THEN #Consultar el proceso final de la OP
  	SET cantidadTerminada=0;
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
IF area=1 THEN

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

ELSE
 IF area=2 THEN
 
 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;
 
 ELSE
  if area=3 THEN
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(idDetalleProducto) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=idDetalleProducto;
  #...
  END IF;
 END IF;
END IF;
   CALL PA_CambiarEstadoDeProductos(area,idDetalleProducto);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PromedioProductoPorMinuto` (IN `detalle` INT, IN `area` INT, IN `lector` INT)  NO SQL
BEGIN
IF area=1 THEN

SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_formato_estandar d WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector AND d.estado=3;

ELSE
 IF area=2 THEN

SELECT t.tiempo_total_proceso,t.cantidad_terminada FROM detalle_teclados t WHERE t.idDetalle_proyecto=detalle AND t.idproceso=lector AND t.estado=3;

 ELSE
  
 SELECT e.tiempo_total_por_proceso, e.cantidad_terminada FROM detalle_ensamble e WHERE e.idDetalle_proyecto=detalle AND e.idproceso=lector AND e.estado=3;
 
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

CREATE DEFINER=`` PROCEDURE `PA_registrarModificarSeleccionProcesos` (IN `idProceso` INT, IN `idCondicion` INT, IN `orden` INT, IN `idProceso_producto` INT)  NO SQL
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarEstadoProyecto` (IN `detalle` INT, IN `area` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.estado=3 AND dp.idDetalle_proyecto=detalle)  THEN

 IF area=1 THEN
    SELECT df.tiempo_por_unidad FROM detalle_formato_estandar df WHERE df.idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
 ELSE
  IF area=2 THEN
      SELECT df.tiempo_por_unidad FROM detalle_teclados df WHERE df.idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
   ELSE
      SELECT df.tiempo_por_unidad FROM detalle_ensamble df WHERE df.idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
  END IF;
 END IF;
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

CREATE DEFINER=`` PROCEDURE `pruebaDesarrollo` (IN `orden` INT)  NO SQL
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

/*IF estado IS null OR (estado !='Retraso' AND estado !='A tiempo') THEN
   UPDATE proyecto p SET p.estadoEmpresa='A tiempo' WHERE p.numero_orden = orden;
END IF;*/

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminado=0 THEN
	# Proyecto con el estado por inciiar
  	SELECT 1;
ELSE
 IF ejecucion>=1 THEN
  #Proyecto en estado de ejecución
  SELECT 4;

 ELSE
   IF pausar!=0 and ejecucion=0 and (terminado=0 or terminado!=0) THEN
   #Proyecto en estado de pausa
   SELECT 21;

  ELSE
   IF pausar=0 and ejecucion=0 and terminado!=0 AND iniciar!=0 THEN
   #Proyecto en estado pausado
	SELECT 22;
   ELSE
        IF (iniciar+pausar+ejecucion+terminado)=terminado AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
        # Proyecto terminado
		SELECT 3;
    END IF;
   END IF;
  END IF;
 END IF;
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ClasificarCondicionProducto` (`orden` VARCHAR(10), `idProducto` INT, `ubic` VARCHAR(25), `material` VARCHAR(2), `area` INT, `antisolder` TINYINT, `ruteo` TINYINT) RETURNS INT(11) NO SQL
BEGIN

# ...
IF (idProducto=1 or idProducto=7) AND area = 1 THEN # Circuito o PCB
	# ...
    RETURN (SELECT c.idCondicion FROM condicion_producto c WHERE c.idProducto=idProducto AND c.material=material AND c.antisorder=antisolder AND c.ruteo=ruteo AND c.area=area LIMIT 1);
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
 		UPDATE detalle_formato_estandar f SET f.estado=3, f.fecha_fin=now() WHERE f.idDetalle_formato_estandar=proceso1;#Estado Terminado
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
 		UPDATE detalle_teclados t SET t.estado=3, t.fecha_fin=now() WHERE t.idDetalle_teclados=proceso1;#Estado Terminado
 	# ...
	ELSE	    
 		UPDATE detalle_teclados t SET t.estado=2, t.fecha_fin=null WHERE t.idDetalle_teclados=proceso1;#Estado Pausado
 	# ...
	END IF;
	#...
	#Clasificar el estado del proceso 2 (pausado=2 o terminado=3)
	IF EXISTS(SELECT * FROM detalle_teclados t WHERE t.idDetalle_teclados=proceso2 AND CONVERT(t.cantidad_terminada,int)>=cant AND CONVERT(t.cantidadProceso,int)=0 AND t.estado!=4) THEN
    # ....
 		UPDATE detalle_teclados t SET t.estado=3, t.fecha_fin=now() WHERE t.idDetalle_teclados=proceso2;#Estado Terminado
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
 		UPDATE detalle_ensamble e SET e.estado=3, e.fecha_fin=now() WHERE e.idDetalle_ensamble=proceso1;#Estado Terminado
 	 # ...
	 ELSE	    
 		UPDATE detalle_ensamble e SET e.estado=2, e.fecha_fin=null WHERE e.idDetalle_ensamble=proceso1;#Estado Pausado
 	 # ...
	 END IF;
     #...
	 #Clasificar el estado del proceso 2 (pausado=2 o terminado=3)
	 IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso2 AND CONVERT(e.cantidad_terminada,int)>=cant AND CONVERT(e.cantidadProceso,int)=0 AND e.estado!=4) THEN
     # ...
 	   	UPDATE detalle_ensamble e SET e.estado=3, e.fecha_fin=now() WHERE e.idDetalle_ensamble=proceso2;#Estado Terminado
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

CREATE DEFINER=`` FUNCTION `FU_ConsultarProcesoFinalSeleccionado` (`idDetalleProducto` INT, `area` TINYINT(1)) RETURNS INT(11) NO SQL
BEGIN

DECLARE proceso int;

IF area = 2 THEN # Teclados
	SET proceso = (SELECT t.idproceso FROM detalle_teclados t WHERE t.idDetalle_proyecto = idDetalleProducto AND t.proceso_final = 1);
ELSE # Ensamble
	SET proceso = (SELECT e.idproceso FROM detalle_ensamble e WHERE e.idDetalle_proyecto = idDetalleProducto AND e.proceso_final = 1);
END IF;

RETURN proceso;

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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoEnsamble` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_ensamble` WHERE idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoFormatoestandar` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_formato_estandar` WHERE idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoTeclados` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_teclados` WHERE idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
CALL PA_CambiarEstadoDeProyecto(orden);
RETURN 1;
ELSE
RETURN 0;
END IF;
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ModificarInfoDetalleProyecto` (`idDetalleProducto` INT, `cantidad` VARCHAR(6), `material` VARCHAR(6), `area` INT, `ubicacion` VARCHAR(25), `antisolder` TINYINT(1), `ruteo` TINYINT(1), `idProducto` INT) RETURNS TINYINT(1) NO SQL
BEGIN

#Seimpre se van actualizar las cantidades del producto...
UPDATE detalle_proyecto dp SET dp.canitadad_total = cantidad WHERE dp.idDetalle_proyecto = idDetalleProducto;
# ...
IF !EXISTS(SELECT * FROM detalle_proyecto d WHERE d.idDetalle_proyecto = idDetalleProducto AND d.idProducto = idProducto AND d.material = material AND d.idArea = area AND d.antisolder = antisolder AND d.ruteo = ruteo) THEN

UPDATE detalle_proyecto dp SET dp.material = material,dp.ubicacion = ubicacion,dp.antisolder = antisolder,dp.ruteo = ruteo WHERE dp.idDetalle_proyecto = idDetalleProducto;
  # ...
  RETURN 1;# Se actualizo la informacion
  # ...
ELSE
	#No es necesario modificar el detalle...
   RETURN 0;

END IF;

# ...
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarDetalleProyecto` (`orden` INT(11), `idProductoP` VARCHAR(20), `cantidad` VARCHAR(6), `area` VARCHAR(20), `estado` TINYINT(1), `material` VARCHAR(6), `pnc` TINYINT(1), `ubic` VARCHAR(30), `antisolder` TINYINT, `ruteo` TINYINT) RETURNS TINYINT(1) NO SQL
BEGIN
IF material != '' THEN
	INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`material`,`PNC`,`ubicacion`,`antisolder`,`ruteo`) VALUES ((SELECT idproducto from producto where nombre =idProductoP), cantidad, orden, (SELECT idArea FROM area WHERE nom_area = area), estado, material, pnc, ubic, antisolder, ruteo);
 	RETURN 1;
#
ELSE
	INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`PNC`,`ubicacion`,`antisolder`,`ruteo`) VALUES ((SELECT idproducto from producto where nombre =idProductoP),cantidad,orden, (SELECT idArea FROM area WHERE nom_area = area), estado, pnc, ubic, antisolder, ruteo);
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ReiniciarTiempo` (`detalle` INT, `area` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidadp int;
DECLARE detalleN int;


IF area=1 THEN
UPDATE `detalle_formato_estandar` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_formato_estandar`=detalle;
SET detalleN =(SELECT d.idDetalle_proyecto FROM detalle_formato_estandar d WHERE d.idDetalle_formato_estandar=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(area,detalleN);
  RETURN 1;
ELSE
 IF area=2 THEN
 UPDATE `detalle_teclados` SET `tiempo_por_unidad`= "00:00",`tiempo_total_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_teclados`=detalle;
SET detalleN =(SELECT d.idDetalle_proyecto FROM detalle_teclados d WHERE d.idDetalle_teclados=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(area,detalleN);
 RETURN 1;
 ELSE
  UPDATE `detalle_ensamble` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,`cantidadProceso`=0 WHERE `idDetalle_ensamble`=detalle;
SET detalleN =(SELECT d.idDetalle_proyecto FROM detalle_ensamble d WHERE d.idDetalle_ensamble=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalleN) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;

CALL PA_CambiarEstadoDeProductos(area,detalleN);
  RETURN 1;
 END IF;
END IF;

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
  #Esta pendiente por implementar
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

CREATE DEFINER=`` FUNCTION `FU_ValidarExistenciaProcesoSeleccionado` (`idProceso` INT) RETURNS TINYINT(1) NO SQL
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
(22, 7, '1', 'FV', 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ensamble`
--

CREATE TABLE `detalle_ensamble` (
  `idDetalle_ensamble` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00',
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
  `proceso_final` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_formato_estandar`
--

CREATE TABLE `detalle_formato_estandar` (
  `idDetalle_formato_estandar` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00',
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
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`) VALUES
(4, '00:00', '00:00', '0', NULL, NULL, 2, 1, 1, NULL, NULL, 0, 1, '10'),
(5, '00:00', '00:00', '0', NULL, NULL, 2, 2, 1, NULL, NULL, 0, 2, '0'),
(6, '00:00', '00:00', '0', NULL, NULL, 2, 3, 1, NULL, NULL, 0, 3, '0'),
(7, '00:00', '00:00', '0', NULL, NULL, 2, 4, 1, NULL, NULL, 0, 4, '0'),
(8, '00:00', '00:00', '0', NULL, NULL, 2, 5, 1, NULL, NULL, 0, 5, '0'),
(9, '00:00', '00:00', '0', NULL, NULL, 2, 6, 1, NULL, NULL, 0, 6, '0'),
(10, '00:00', '00:00', '0', NULL, NULL, 2, 7, 1, NULL, NULL, 0, 7, '0'),
(11, '00:00', '00:00', '0', NULL, NULL, 2, 8, 1, NULL, NULL, 0, 8, '0'),
(12, '00:00', '00:00', '0', NULL, NULL, 2, 9, 1, NULL, NULL, 0, 9, '0'),
(13, '00:00', '00:00', '0', NULL, NULL, 2, 10, 1, NULL, NULL, 0, 10, '0'),
(21, '00:00', '00:00', '0', NULL, NULL, 3, 1, 1, NULL, NULL, 0, 1, '15'),
(22, '00:00', '00:00', '0', NULL, NULL, 3, 3, 1, NULL, NULL, 0, 2, '0'),
(23, '00:00', '00:00', '0', NULL, NULL, 3, 4, 1, NULL, NULL, 0, 3, '0'),
(24, '00:00', '00:00', '0', NULL, NULL, 3, 5, 1, NULL, NULL, 0, 4, '0'),
(25, '00:00', '00:00', '0', NULL, NULL, 3, 6, 1, NULL, NULL, 0, 5, '0'),
(26, '00:00', '00:00', '0', NULL, NULL, 3, 7, 1, NULL, NULL, 0, 6, '0'),
(27, '00:00', '00:00', '0', NULL, NULL, 3, 8, 1, NULL, NULL, 0, 7, '0'),
(28, '00:00', '00:00', '0', NULL, NULL, 3, 10, 1, NULL, NULL, 0, 8, '0'),
(29, '00:00', '00:00', '0', NULL, NULL, 4, 1, 1, NULL, NULL, 0, 1, '20'),
(30, '00:00', '00:00', '0', NULL, NULL, 4, 3, 1, NULL, NULL, 0, 2, '0'),
(31, '00:00', '00:00', '0', NULL, NULL, 4, 4, 1, NULL, NULL, 0, 3, '0'),
(32, '00:00', '00:00', '0', NULL, NULL, 4, 5, 1, NULL, NULL, 0, 4, '0'),
(33, '00:00', '00:00', '0', NULL, NULL, 4, 7, 1, NULL, NULL, 0, 5, '0'),
(34, '00:00', '00:00', '0', NULL, NULL, 4, 8, 1, NULL, NULL, 0, 6, '0'),
(35, '00:00', '00:00', '0', NULL, NULL, 4, 9, 1, NULL, NULL, 0, 7, '0'),
(36, '00:00', '00:00', '0', NULL, NULL, 4, 10, 1, NULL, NULL, 0, 8, '0'),
(37, '00:00', '00:00', '0', NULL, NULL, 5, 1, 1, NULL, NULL, 0, 2, '0'),
(38, '00:00', '00:00', '0', NULL, NULL, 5, 4, 1, NULL, NULL, 0, 1, '25'),
(39, '00:00', '00:00', '0', NULL, NULL, 5, 10, 1, NULL, NULL, 0, 3, '0');

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
  `tiempo_total` varchar(20) NOT NULL DEFAULT '00:00',
  `Total_timepo_Unidad` varchar(20) NOT NULL DEFAULT '00:00',
  `fecha_salida` datetime DEFAULT NULL,
  `lider_proyecto` varchar(13) DEFAULT NULL,
  `antisolder` tinyint(1) DEFAULT '0',
  `ruteo` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `idProducto`, `canitadad_total`, `material`, `proyecto_numero_orden`, `idArea`, `estado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`, `lider_proyecto`, `antisolder`, `ruteo`) VALUES
(2, 1, '10', 'TH', 1, 1, 3, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', '2019-03-14 12:19:40', NULL, 1, 1),
(3, 7, '15', 'FV', 1, 1, 3, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', '2019-03-14 12:19:40', NULL, 1, 0),
(4, 2, '20', 'FV', 2, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL, 0, 0),
(5, 4, '25', 'FV', 2, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_teclados`
--

CREATE TABLE `detalle_teclados` (
  `idDetalle_teclados` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(8) NOT NULL DEFAULT '00:00',
  `tiempo_total_por_proceso` varchar(10) NOT NULL DEFAULT '00:00',
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
  `proceso_final` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos`
--

CREATE TABLE `procesos` (
  `idproceso` tinyint(4) NOT NULL,
  `nombre_proceso` varchar(30) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `idArea` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `procesos`
--

INSERT INTO `procesos` (`idproceso`, `nombre_proceso`, `estado`, `idArea`) VALUES
(1, 'Perforado', 1, 1),
(2, 'Quimicos', 1, 1),
(3, 'Caminos', 1, 1),
(4, 'Quemado', 1, 1),
(5, 'C.C.TH', 1, 1),
(6, 'Screen', 1, 1),
(7, 'Estañado', 1, 1),
(8, 'C.C.2', 1, 1),
(9, 'Ruteo', 1, 1),
(10, 'Maquinas', 1, 1),
(11, 'Correas y Conversor', 1, 2),
(12, 'Lexan', 1, 2),
(13, 'Acople', 1, 2),
(14, 'Calidad TE', 1, 2),
(15, 'Manual', 1, 3),
(16, 'Automatico', 1, 3),
(17, 'Control Calidad', 1, 3),
(18, 'Empaque', 1, 3),
(19, 'Componentes', 1, 4),
(20, 'GF', 1, 4),
(21, 'Prueba', 0, 2),
(22, 'Nuevo Proceso', 1, 1);

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
(174, 22, '8', 10, 0);

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
(1, '981130', 'Juan david marulanda', 'prueba de desarrollo numero 3', 'Normal', '2019-03-14 12:01:45', '2019-03-14', '2019-03-14 12:19:40', 3, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(2, '981130', 'Juan david marulanda', 'prueba de desarrollo', 'Normal', '2019-03-14 12:30:00', '2019-03-14', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL);

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
('1017156424', 'CC', 'YAZMIN ANDREA', 'GALEANO CASTAÑEDA', 3, '', 1, 'yazmin1987', 0, 'dñpgxp68@4'),
('1017191779', 'CC', 'Sintia Liceth', 'Ossa Vasquez', 6, '', 0, '1017191779', 0, '51e-uiññl9'),
('1020479554', 'CC', 'Sebastian', 'Gallego Perez', 3, NULL, 1, '1020479554', 0, '6wjnnjg5a-'),
('1040044905', 'CC', 'Jose Daniel ', 'Grajales Carmona', 1, '', 1, '1040044905', 0, 'z9jmqbñ2kl'),
('1078579715', 'CC', 'MAIBER DAVID ', 'GONZALEZ MERCADO ', 1, '', 0, '3108967039', 0, 'w7n8pjyhd8'),
('1128266934', 'CC', 'Jhon Fredy', 'Velez Londoño', 4, '', 1, '1128266934', 0, '4elax2f2ub'),
('1152210828', 'CC', 'PAULA ANDREA ', 'HERRERA ÁLVAREZ', 5, '', 1, '1152210828', 1, 'eimaumks9s'),
('1152697088', 'CC', 'Diana Marcela', 'Patiño Cardona', 6, '', 1, '1152697088', 0, '1@zujadnñk'),
('1216714539', 'CC', 'Maria alejandra ', 'zuluaga rivera', 6, '', 1, '1216714539', 0, '84@w8wli4a'),
('123456789', 'CC', 'Almacen', '', 5, '', 1, '123456789', 0, 'jfmhh0vq5b'),
('42800589', 'CC', 'Juliana', 'Naranjo Henao', 6, '', 0, '42800589', 0, '-cnño-5wb4'),
('43263856', 'CC', 'Paula Andrea', 'Lopez Gutierrrez', 1, '', 1, '43263856', 0, 'cxcx03ñkf4'),
('43975208', 'CC', 'GLORIA ', 'JARAMILLO ', 2, '', 1, '43975208', 1, 'kbdnsdlciq'),
('71268332', 'CC', 'Adimaro', 'Montoya', 3, '', 0, '71268332', 0, '1vr8s4th-@'),
('981130', 'CC', 'Juan David', 'Marulanda Paniagua', 4, '', 1, '98113053240juan', 0, '1u-hyppy60'),
('98113053240', 'CC', 'Juan david', 'Marulanda Paniagua', 3, '', 1, '98113053240', 0, 'ue2282qgo1'),
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
('1017156424', 'COM5', NULL, 1),
('981130', 'COM5', NULL, 0),
('71268332', 'COM1', NULL, 0),
('1128266934', 'COM4', NULL, 0),
('98765201', 'COM1', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('1216714539', 'COM5', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('1152697088', 'COM5', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
('98113053240', 'COM5', NULL, 1),
('123456789', 'COM7', NULL, 0),
('1020479554', 'COM9', NULL, 0);

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
-- AUTO_INCREMENT de la tabla `condicion_producto`
--
ALTER TABLE `condicion_producto`
  MODIFY `idCondicion` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `procesos`
--
ALTER TABLE `procesos`
  MODIFY `idproceso` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `procesos_producto`
--
ALTER TABLE `procesos_producto`
  MODIFY `idProceso_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=175;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
