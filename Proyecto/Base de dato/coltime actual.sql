-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 25-02-2019 a las 18:49:27
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
IF area=1 THEN

UPDATE detalle_formato_estandar d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;

ELSE
 IF area=2 THEN
  
 UPDATE detalle_teclados d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;
 
 ELSE
  
 UPDATE detalle_ensamble d SET d.tiempo_por_unidad=tiempo WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector;
 
 END IF;
END IF;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CalcularTiempoMinutos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN
DECLARE id int;

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.idproceso=lector);

 UPDATE detalle_formato_estandar f SET  f.hora_terminacion=now() WHERE f.idDetalle_formato_estandar=id;

SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia,TIMESTAMPDIFF(MINUTE,f.hora_ejecucion,f.hora_terminacion) AS diferencia2 from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4;


ELSE
 IF busqueda=2 THEN
 
SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.idproceso=lector);

 UPDATE detalle_teclados f SET  f.hora_terminacion=now() WHERE f.idDetalle_teclados=id;

SELECT f.tiempo_total_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4;

 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.idproceso=lector);

 UPDATE detalle_ensamble f SET  f.hora_terminacion=now() WHERE f.idDetalle_ensamble=id;
  
  SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4;
  
  END IF;
 
 END IF;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetalleProyecto` (IN `orden` VARCHAR(10), IN `estado` INT)  NO SQL
BEGIN

IF estado=0 THEN
SELECT d.idDetalle_proyecto,n.nom_area,t.nombre,d.canitadad_total,d.estado, d.PNC,d.ubicacion,d.material,p.parada FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden;
ELSE
SELECT d.idDetalle_proyecto,n.nom_area,t.nombre,d.canitadad_total,d.estado, d.PNC,d.ubicacion,d.material,p.parada FROM producto t  JOIN detalle_proyecto d on t.idProducto=d.idProducto JOIN area n on d.idArea=n.idArea JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden and p.eliminacion=1;
END IF;

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
SELECT p.nombre_proceso FROM procesos p WHERE p.idArea=area ORDER BY p.idproceso ASC;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosFE` (IN `detalle` INT)  NO SQL
begin

SELECT p.nombre_proceso FROM detalle_formato_estandar f JOIN procesos p on f.idproceso=p.idproceso WHERE f.idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`` PROCEDURE `PA_ConsultarProcesosProducto` (IN `idCondicional` INT)  NO SQL
BEGIN

SELECT c.idProceso,c.orden FROM procesos_producto c WHERE c.idCondicion=idCondicional;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarPRocesosReporteENoTE` (IN `op` INT)  NO SQL
BEGIN
#Ensamble=3; teclados=2
#...
SELECT * FROM procesos WHERE idArea=op AND estado=1;
#...
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEliminados` ()  NO SQL
BEGIN

SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado=e.idestado WHERE p.eliminacion=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEntrega` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteo,p.antisolder,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') and 
p.eliminacion=1;
              ELSE 
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosIngreso` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN 

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1; 
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosSalida` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,p.estado,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') AS inicio,Date_format(f.fecha_fin,'%d-%M-%Y') AS fin,f.cantidad_terminada,f.tiempo_total_proceso,f.tiempo_por_unidad,f.estado,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_teclados AS idDetalleProceso,f.orden,f.noperarios FROM detalle_teclados f JOIN procesos p on f.idproceso=p.idproceso where f.idDetalle_proyecto=detalle ORDER BY f.idproceso ASC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProductosNoConformes` (IN `orden` INT, IN `tipo` INT, IN `area` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.idProducto=tipo AND d.idArea=area;

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

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado,pp.tipo_proyecto FROM detalle_teclados en LEFT JOIN detalle_proyecto dp ON en.idDetalle_proyecto=dp.idDetalle_proyecto LEFT JOIN procesos p ON en.idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden WHERE pp.estado!=3 AND pp.eliminacion!=0 AND dp.idArea=2 ORDER BY dp.proyecto_numero_orden;

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
UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_formato_estandar=id;
END IF;

IF id1 !='null' THEN
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
UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_teclados=id ;
END IF;

IF id1 !='null' THEN
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
UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_ensamble=id;
END IF;

IF id1 !='null' THEN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PausarTomaDeTiempoDeProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `tiempo` VARCHAR(8), IN `cantidadTerminada` INT, IN `cantidadAntiguaTermianda` INT, IN `est` TINYINT(1), IN `res` INT(6), IN `procesoPasar` INT(6))  NO SQL
BEGIN
DECLARE id int;
DECLARE id2 int;
DECLARE ordenProcesos tinyint;
DECLARE cantidadp int;
DECLARE primero int;
DECLARE segundo int;
DECLARE restanteProcesoA int;
#se encarga de hacer la diferencia de tiempo de un dia para otro y tener el formato de hora aplicado.
#SELECT SEC_TO_TIME(TIMESTAMPDIFF(MINUTE, '2018-10-10 11:00:00','2018-10-11 12:00:00')*60)
IF est=2 THEN#Cuando el estado es pausado=2

IF busqueda=1 THEN#La variable busqueda hace referencia al area de produccion
 
# Nueva forma de manejo de las cantidades...
SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);#ID del proceso primario
#...
SET ordenProcesos=(SELECT f.orden from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4)+1;
#...
#Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
UPDATE detalle_formato_estandar f SET f.cantidadProceso=(CONVERT(f.cantidadProceso, int)-cantidadTerminada),f.cantidad_terminada=(f.cantidad_terminada+cantidadTerminada), f.noperarios=0,f.tiempo_total_por_proceso=tiempo WHERE f.idDetalle_formato_estandar=id;
# ...
SET id2=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.orden=ordenProcesos);#ID del proceso secundario
#...
#Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
UPDATE detalle_formato_estandar f SET f.cantidadProceso=(CONVERT(f.cantidadProceso, int)+cantidadTerminada) WHERE f.idDetalle_formato_estandar=id2;
#...
#Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=detalle);
  SELECT FU_ClasificarEstadoProcesos(id,id2,cantidadp,busqueda);
  #...
ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
 
 UPDATE detalle_teclados f SET  f.estado=est, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  #...
  IF procesoPasar=0 AND lector!=18 THEN
  	SET cantidadTerminada=0;
  END IF;
  #...
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);#ID del proceso primario
  #Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)-cantidadTerminada),e.cantidad_terminada=(e.cantidad_terminada+cantidadTerminada), e.noperarios=0,e.tiempo_total_por_proceso=tiempo WHERE e.idDetalle_ensamble=id;
  #...
  IF procesoPasar!=0 THEN#Si el proceso que se envia las cantidades es igual a 0 entonces no se van a sumar cantidades
  	SET id2=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=procesoPasar);#ID del proceso secundario
  #Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)+cantidadTerminada) WHERE e.idDetalle_ensamble=id2;
  ELSE
  	SET id2=0;
  END IF;
  #...
  #Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=detalle);
  SELECT FU_ClasificarEstadoProcesos(id,id2,cantidadp,busqueda);
  #...
  END IF; 
 END IF;
END IF;

ELSE#Cuando el estado es terminado=3

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado=est,f.fecha_fin=now(),f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
 
 UPDATE detalle_teclados f SET  f.estado=est,f.fecha_fin=now(), f.tiempo_total_proceso=tiempo, f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN#Acá ya no va ingresar nunca
  #Pendiente modificar esta forma de actualizar la base de datos
  #SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
  
  #UPDATE detalle_ensamble f SET  f.estado=est,f.fecha_fin=now(), f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id;
  SELECT "Esta parte del código ya no se va a utilziar más.";
  END IF; 
 END IF;
END IF;

END IF;

#Cantidad de proceso en los diferentes estados de las diferentes áreas
IF busqueda=1 THEN

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
 
 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
 ELSE
  if busqueda=3 THEN
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.idDetalle_proyecto=(detalle) AND d.estado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  #...
  END IF;
 END IF;
END IF;
   CALL PA_CambiarEstadoDeProductos(busqueda,detalle);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PromedioProductoPorMinuto` (IN `detalle` INT, IN `area` INT, IN `lector` INT)  NO SQL
BEGIN
IF area=1 THEN

SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_formato_estandar d WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector AND d.estado=3;

ELSE
 IF area=2 THEN

SELECT d.tiempo_total_proceso,d.cantidad_terminada FROM detalle_teclados d WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector AND d.estado=3;

 ELSE
  
 SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_ensamble d WHERE d.idDetalle_proyecto=detalle AND d.idproceso=lector AND d.estado=3;
 
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

INSERT INTO `detalle_ensamble`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES ('00:00','00:00','0',detalle,proceso,1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleFormatoEstandar` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25))  NO SQL
BEGIN
DECLARE material varchar(3);
DECLARE antisolder int;
declare ruteo int;
declare detalle int;

 IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=1 AND dd.ubicacion is null));

 ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=1 AND dd.ubicacion=ubic));

 END IF;



IF tipo=2 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,3,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,5,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,7,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,8,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,9,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,10,1);
ELSE
IF tipo=3 or tipo=4 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
   IF tipo=6 THEN
#Perforado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,1,1);
#Caminos
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,3,1);
#Quemado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
     IF tipo=1 or tipo=7 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,1,1);


set material=(SELECT d.material from detalle_proyecto d WHERE d.proyecto_numero_orden=(orden) AND d.idDetalle_proyecto=detalle);


IF material="TH" THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,2,1);
END IF;


 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,3,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,5,1);

     IF tipo=1 THEN
set antisolder=(SELECT antisolderC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
 
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
     END IF;
          IF tipo=7 THEN
          
set antisolder=(SELECT antisolderP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));
 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
          END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`) VALUES
('00:00','00:00','0',detalle,10,1);
   END IF;
  END IF;
 END IF;
END IF;

SET tipo= (SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.idDetalle_proyecto=detalle AND d.estado=1);


UPDATE detalle_proyecto SET pro_porIniciar=tipo WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(1,detalle);

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

INSERT INTO `detalle_teclados`(`tiempo_por_unidad`, `tiempo_total_proceso`, `cantidad_terminada`, `idDetalle_proyecto`, `idproceso`, `estado`)VALUES
('00:00','00:00','0',detalle,proceso,1);

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

CREATE DEFINER=`` PROCEDURE `PA_RegistrarProcesosProductoFE` (IN `idProceso` INT, IN `idDetalleProyecto` INT, IN `ordenEjecucion` TINYINT)  NO SQL
BEGIN
#
IF idProceso=1 THEN
# ...
	INSERT INTO `detalle_formato_estandar`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`) VALUES (idDetalleProyecto, idProceso, ordenEjecucion, (SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=idDetalleProyecto));
# ...
ELSE
# ...
	INSERT INTO `detalle_formato_estandar`(`idDetalle_proyecto`, `idproceso`, `orden`, `cantidadProceso`) VALUES (idDetalleProyecto, idProceso, ordenEjecucion, 0);
# ...
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
 SELECT p.numero_orden, de.idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.canitadad_total  FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar de ON dp.idDetalle_proyecto=de.idDetalle_proyecto join procesos pro ON de.idproceso=pro.idproceso WHERE dp.idArea=1 AND p.eliminacion=1 AND dp.estado=3 ORDER BY p.numero_orden;
ELSE
 IF area=2 THEN#Teclados
 SELECT p.numero_orden, de.idproceso,pro.nombre_proceso,de.tiempo_total_proceso,dp.tiempo_total,dp.canitadad_total  FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados de ON dp.idDetalle_proyecto=de.idDetalle_proyecto join procesos pro ON de.idproceso=pro.idproceso WHERE dp.idArea=2 AND p.eliminacion=1 AND dp.estado=3 ORDER BY p.numero_orden;
 ELSE
  IF area=3 THEN#Ensamble
   SELECT p.numero_orden, de.idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.Total_timepo_Unidad,dp.estado,dp.canitadad_total, de.cantidadProceso,dp.fecha_salida  FROM proyecto p LEFT JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.idDetalle_proyecto LEFT JOIN procesos pro ON de.idproceso=pro.idproceso WHERE dp.idArea=3 AND p.eliminacion=1 AND (DATE_FORMAT(p.fecha_ingreso, '%Y-%m-%d') between fechaI AND fechaF) ORDER BY p.numero_orden;
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_selccionarPrimerProcesoProyectosEnsamble` (IN `detalle` INT, IN `idproceso` INT)  NO SQL
BEGIN
#Reiniciar el orden de todos los procesos que tiene el detalle
UPDATE detalle_ensamble e SET e.orden=0,e.cantidadProceso=0 WHERE e.idDetalle_proyecto=detalle;

#Seleccionar el primer proceso
UPDATE detalle_ensamble e SET e.orden=1,e.cantidadProceso=(SELECT p.canitadad_total FROM detalle_proyecto p WHERE p.idDetalle_proyecto=detalle LIMIT 1) WHERE e.idDetalle_ensamble=idproceso;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Sesion` (IN `sec` INT, IN `ced` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.sesion=sec WHERE u.numero_documento=ced;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TiempoProceso` (IN `detalle` INT, IN `area` INT)  NO SQL
BEGIN

IF area=1 THEN
SELECT df.tiempo_total_por_proceso FROM detalle_formato_estandar df WHERE df.idDetalle_proyecto=detalle AND df.estado!=1;

ELSE
 IF area=2 THEN
  SELECT dt.tiempo_total_proceso FROM detalle_teclados dt WHERE dt.idDetalle_proyecto=detalle AND dt.estado!=1;
 ELSE
  SELECT de.tiempo_total_por_proceso FROM detalle_ensamble de WHERE de.idDetalle_proyecto=detalle AND de.estado!=1;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TodosLosDetallesEnEjecucion` (IN `orden` INT)  NO SQL
BEGIN
SELECT dp.idDetalle_proyecto,dp.idArea FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadDetalleProyecto` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN

DECLARE can int;
DECLARE id int;
DECLARE oper int;

IF busqueda=1 THEN# Formato estandar

SET id=(SELECT f.cantidad_terminada from detalle_formato_estandar f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
SET oper=(SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector);

ELSE
 IF busqueda=2 THEN# Teclatos
 
 SET id=(SELECT f.cantidad_terminada from detalle_teclados f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
  SET oper=(SELECT f.noperarios FROM detalle_teclados f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector);
 ELSE
  IF busqueda=3 THEN# Ensamble
  
  SET id=(SELECT f.cantidad_terminada from detalle_ensamble f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
    SET oper=(SELECT f.noperarios FROM detalle_ensamble f WHERE f.idDetalle_proyecto=detalle and f.idproceso=lector);
  ELSE# Almacen
   SET id=(SELECT f.cantidad_recibida from almacen f JOIN detalle_proyecto d on f.idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.idproceso=lector and f.estado=4);
  END IF; 
 END IF;
END IF;

set can=(select d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

SELECT can as contidad_total,id as cantidad_proceso,oper as operarios;
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_CambiarEstadoProcesos` (`id` INT, `estado` INT) RETURNS TINYINT(1) NO SQL
BEGIN

UPDATE procesos p SET p.estado=estado WHERE p.idproceso=id;
RETURN 1;

END$$

CREATE DEFINER=`` FUNCTION `FU_ClasificarCondicionProductoFE` (`orden` VARCHAR(10), `idProducto` INT, `ubic` VARCHAR(25), `material` VARCHAR(2)) RETURNS INT(11) NO SQL
BEGIN

DECLARE antisolder tinyint(1);
DECLARE ruteo tinyint(1);
declare detalle int;

#...
/*IF ubic='' THEN
  set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=1 AND dd.ubicacion is null));
ELSE
  set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.idProducto=tipo AND dd.idArea=1 AND dd.ubicacion=ubic));
END IF;*/

#...
IF idProducto=1 or idProducto=7 THEN
	IF idProducto=1 THEN
	# ...
	set antisolder=(SELECT antisolderC from proyecto where numero_orden=orden);
	# ...
	set ruteo=(SELECT ruteoC from proyecto where numero_orden=orden);
	# ...
	ELSE
	# ...
		IF idProducto=7 THEN
    
    		set antisolder=(SELECT antisolderP from proyecto where numero_orden=orden);

			set ruteo=(SELECT ruteoP from proyecto where numero_orden=orden);
    
    	END IF;
	# ...
	END IF;
    RETURN (SELECT c.idCondicion FROM condicion_producto c WHERE c.idProducto=idProducto AND c.material=material AND c.antisorder=antisolder AND c.ruteo=ruteo LIMIT 1);
ELSE
#...
RETURN (SELECT c.idCondicion FROM condicion_producto c WHERE c.idProducto=idProducto LIMIT 1);
#...
END IF;
#

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
ELSE #Ensamble
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
    # ....
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
#...
return 1;
END$$

CREATE DEFINER=`` FUNCTION `FU_ConsultarelIDDetalledelproductoFE` (`numOrden` VARCHAR(10), `idProducto` TINYINT, `productoPNC` VARCHAR(25)) RETURNS INT(11) NO SQL
BEGIN

DECLARE idDetalleProducto int;

IF productoPNC='' THEN
  set idDetalleProducto=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(numOrden) AND dd.idProducto=idProducto AND dd.idArea=1 AND dd.ubicacion is null));
ELSE
  set idDetalleProducto=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(numOrden) AND dd.idProducto=idProducto AND dd.idArea=1 AND dd.ubicacion=productoPNC));
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

CREATE DEFINER=`` FUNCTION `FU_ConsultarIDDetalleProductosFE` (`numOrden` VARCHAR(10), `idProducto` TINYINT, `PNC` VARCHAR(25)) RETURNS INT(11) NO SQL
BEGIN
# ...
 IF PNC='' THEN
    RETURN (SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=numOrden AND d.idProducto=idProducto AND d.ubicacion IS null);
 ELSE
	RETURN (SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=numOrden AND d.idProducto=idProducto AND d.ubicacion=PNC);
 END IF;
# ...
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ModificarDetalleProyecto` (`orden` INT, `idDetalle` INT, `cantidad` VARCHAR(6), `material` VARCHAR(6), `area` INT, `ubicacion` VARCHAR(25)) RETURNS TINYINT(1) NO SQL
BEGIN
UPDATE detalle_proyecto dp SET dp.canitadad_total=cantidad,dp.material=material,dp.ubicacion=ubicacion WHERE idDetalle_proyecto=idDetalle and proyecto_numero_orden=orden;
CALL PA_CambiarEstadoDeProductos(area,idDetalle);
RETURN 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarDetalleProyecto` (`orden` INT(11), `tipoNegocio` VARCHAR(20), `cantidad` VARCHAR(6), `area` VARCHAR(20), `estado` TINYINT(1), `material` VARCHAR(6), `pnc` TINYINT(1), `ubic` VARCHAR(30)) RETURNS TINYINT(1) NO SQL
BEGIN
IF material != '' THEN
INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`material`,`PNC`,`ubicacion`,`tiempo_total`,`Total_timepo_Unidad`) VALUES ((SELECT idproducto from producto where nombre =tipoNegocio),cantidad,orden,(SELECT idArea FROM area WHERE nom_area = area),estado,material,pnc,ubic,'00:00','00:00');
RETURN 1;
ELSE
INSERT INTO `detalle_proyecto`(`idProducto`, `canitadad_total`, `proyecto_numero_orden`, `idArea`, `estado`,`PNC`,`ubicacion`,`tiempo_total`,`Total_timepo_Unidad`) VALUES ((SELECT idproducto from producto where nombre =tipoNegocio),cantidad,orden,(SELECT idArea FROM area WHERE nom_area = area),estado,pnc,ubic,'00:00','00:00');
RETURN 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProcesos` (`op` INT, `nombre` VARCHAR(30), `area` INT, `id` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF op=1 THEN
INSERT INTO `procesos`(`nombre_proceso`, `estado`, `idArea`) VALUES (nombre,1,area);
RETURN 1;
else
UPDATE procesos p SET p.nombre_proceso=nombre,p.idArea=area WHERE p.idproceso=id;
RETURN 1;
END IF;


END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProyecto` (`doc` VARCHAR(13), `cliente` VARCHAR(150), `proyecto` VARCHAR(150), `tipo` VARCHAR(6), `fe` TINYINT(1), `te` TINYINT(1), `inte` TINYINT(1), `pcbfe` TINYINT(1), `pcbte` TINYINT(1), `conv` TINYINT(1), `rep` TINYINT(1), `tro` TINYINT(1), `st` TINYINT(1), `lexan` TINYINT(1), `entrega` VARCHAR(11), `ruteo` TINYINT(1), `anti` TINYINT(1), `norden` INT, `op` TINYINT(1), `ruteoP` TINYINT(1), `antiP` TINYINT(1), `fecha1` VARCHAR(11), `fecha2` VARCHAR(11), `fecha3` VARCHAR(11), `fecha4` VARCHAR(11), `novedad` VARCHAR(250), `estadopro` VARCHAR(13), `nfee` VARCHAR(11)) RETURNS TINYINT(11) NO SQL
BEGIN
DECLARE nov varchar(250);

IF novedad='' THEN
 SET nov='';
ELSE 
 SET nov=novedad;
END IF;

IF op=1 THEN

INSERT INTO `proyecto`(`numero_orden`,`usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `ruteoC`, `antisolderC`, `estado`,`ruteoP`,`antisolderP`,`entregaCircuitoFEoGF`,`entregaCOMCircuito`,`entregaPCBFEoGF`,`entregaPCBCom`) VALUES (norden,doc,cliente,proyecto,tipo,fe,te,inte,pcbfe,pcbte,conv,rep,tro,st,lexan,(SELECT now()),entrega,ruteo,anti,1,ruteoP,antiP,fecha1,fecha2,fecha3,fecha4); 
RETURN 1;
ELSE 
 UPDATE `proyecto` SET `nombre_cliente`=cliente,`nombre_proyecto`=proyecto,`tipo_proyecto`=tipo,`FE`=fe,`TE`=te,`IN`=inte,`pcb_FE`=pcbfe,`pcb_TE`=pcbte,`Conversor`=conv,`Repujado`=rep,`troquel`=tro,`stencil`=st,`lexan`=lexan,`fecha_entrega`=entrega,`ruteoC`=ruteo,`antisolderC`=anti,`ruteoP`=ruteoP,`antisolderP`=antiP,`entregaCircuitoFEoGF`=fecha1,`entregaCOMCircuito`=fecha2,`entregaPCBFEoGF`=fecha3,`entregaPCBCom`=fecha4,`novedades`=nov,`estadoEmpresa`=estadopro,`NFEE`=nfee WHERE numero_orden=norden;
RETURN 1;
END IF;

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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarNumerOrden` (`orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM proyecto d WHERE d.numero_orden=orden) THEN
RETURN 1;
ELSE
RETURN 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarProcesoInicioAreasProduccion` (`detalle` INT, `area` TINYINT, `idProceso` TINYINT) RETURNS TINYINT(1) NO SQL
BEGIN

IF area = 1 THEN #Formato Estandar - FE
# ...
	IF EXISTS(SELECT * FROM detalle_formato_estandar f WHERE f.idDetalle_proyecto=detalle AND f.idproceso=idProceso) THEN
	#Si existe un proceso seleccionado como inicial
		return 1;
	ELSE
	#No existe un proceso selccionado
		return 0;
	END IF;
# ...
ELSE # Ensamble - EN
# ...
IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_proyecto=detalle AND e.orden=1 AND e.idproceso=idProceso) THEN
	#Si existe un proceso seleccionado como inicial
		return 1;
	ELSE
	#No existe un proceso selccionado
		return 0;
	END IF;
# ...
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

--
-- Volcado de datos para la tabla `almacen`
--

INSERT INTO `almacen` (`idalmacen`, `tiempo_total_proceso`, `cantidad_recibida`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_registro`, `hora_llegada`) VALUES
(1, '0', '0', '2018-12-05', NULL, 16, 19, 4, '08:34:46', NULL),
(2, '34', '0', '2019-01-16', '2019-02-19', 40, 19, 3, '12:29:27', '08:40:08'),
(3, '34', '130', '2019-01-16', '2019-02-19', 41, 20, 3, '12:29:27', '06:31:26'),
(4, '0', '0', '2019-01-16', NULL, 46, 19, 4, '12:37:29', NULL),
(5, '34', '130', '2019-01-16', '2019-02-19', 47, 20, 3, '12:37:30', '08:42:52'),
(6, '0', '0', '2019-01-16', NULL, 50, 19, 4, '12:46:47', NULL),
(7, '0', '0', '2019-01-16', NULL, 51, 20, 4, '12:46:48', NULL),
(8, '0', '0', '2019-01-16', NULL, 54, 19, 4, '12:51:59', NULL),
(9, '0', '0', '2019-01-16', NULL, 55, 20, 4, '12:51:59', NULL),
(10, '0', '0', '2019-01-16', NULL, 58, 19, 4, '12:56:12', NULL),
(11, '0', '0', '2019-01-16', NULL, 59, 20, 4, '12:56:12', NULL),
(12, '0', '0', '2019-01-16', NULL, 62, 19, 4, '12:59:26', NULL),
(13, '0', '0', '2019-01-16', NULL, 63, 20, 4, '12:59:26', NULL),
(14, '0', '0', '2019-01-16', NULL, 65, 19, 4, '13:02:31', NULL),
(15, '0', '0', '2019-01-16', NULL, 66, 20, 4, '13:02:32', NULL),
(16, '0', '0', '2019-01-16', NULL, 69, 19, 4, '13:06:20', NULL),
(17, '0', '0', '2019-01-16', NULL, 70, 20, 4, '13:06:20', NULL),
(18, '0', '0', '2019-01-16', NULL, 73, 19, 4, '13:15:35', NULL),
(19, '0', '0', '2019-01-16', NULL, 74, 20, 4, '13:15:35', NULL),
(20, '0', '0', '2019-01-16', NULL, 77, 19, 4, '13:22:19', NULL),
(21, '0', '0', '2019-01-16', NULL, 78, 20, 4, '13:22:20', NULL),
(22, '0', '0', '2019-01-16', NULL, 80, 19, 4, '13:26:24', NULL),
(23, '0', '0', '2019-01-16', NULL, 81, 20, 4, '13:26:24', NULL),
(33, '0', '0', '2019-01-31', '2019-01-31', 136, 19, 3, '07:22:22', '07:24:26'),
(34, '0', '750', '2019-01-31', '2019-01-31', 137, 20, 3, '07:22:22', '07:24:17'),
(36, '0', '0', '2019-02-06', NULL, 174, 19, 4, '08:39:37', NULL),
(47, '0', '0', '2019-02-11', NULL, 220, 19, 4, '17:08:05', NULL),
(49, '0', '0', '2019-02-13', NULL, 239, 19, 4, '15:09:47', NULL),
(50, '0', '0', '2019-02-13', NULL, 246, 19, 4, '17:26:02', NULL),
(51, '0', '0', '2019-02-14', NULL, 252, 19, 4, '17:26:10', NULL),
(52, '0', '0', '2019-02-14', NULL, 253, 20, 4, '17:26:10', NULL),
(53, '0', '0', '2019-02-15', NULL, 257, 19, 4, '09:44:29', NULL),
(54, '0', '0', '2019-02-15', NULL, 265, 19, 4, '17:05:27', NULL),
(55, '0', '0', '2019-02-15', NULL, 266, 20, 4, '17:05:27', NULL),
(56, '0', '0', '2019-02-15', NULL, 268, 19, 4, '17:09:09', NULL),
(57, '0', '0', '2019-02-15', NULL, 269, 20, 4, '17:09:09', NULL),
(58, '0', '0', '2019-02-15', NULL, 271, 19, 4, '17:13:29', NULL),
(59, '0', '0', '2019-02-15', NULL, 272, 20, 4, '17:13:29', NULL),
(60, '0', '0', '2019-02-15', NULL, 274, 19, 4, '17:25:09', NULL),
(61, '0', '0', '2019-02-15', NULL, 275, 20, 4, '17:25:09', NULL),
(62, '0', '0', '2019-02-18', NULL, 279, 19, 4, '07:13:05', NULL),
(63, '0', '0', '2019-02-18', NULL, 288, 19, 4, '16:35:25', NULL),
(64, '0', '0', '2019-02-19', NULL, 297, 19, 4, '15:00:26', NULL),
(65, '0', '0', '2019-02-20', NULL, 307, 19, 4, '16:28:41', NULL),
(66, '0', '0', '2019-02-20', NULL, 313, 19, 4, '17:25:29', NULL),
(67, '0', '0', '2019-02-20', NULL, 314, 20, 4, '17:25:29', NULL),
(68, '0', '0', '2019-02-20', NULL, 317, 19, 4, '17:31:47', NULL),
(69, '0', '0', '2019-02-20', NULL, 318, 20, 4, '17:31:47', NULL);

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
(3, 'IN'),
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
  `material` varchar(3) DEFAULT NULL,
  `antisorder` tinyint(1) NOT NULL,
  `ruteo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `condicion_producto`
--

INSERT INTO `condicion_producto` (`idCondicion`, `idProducto`, `material`, `antisorder`, `ruteo`) VALUES
(1, 1, 'TH', 1, 1),
(2, 1, 'FV', 1, 1),
(3, 1, 'TH', 0, 0),
(4, 1, 'TH', 1, 0),
(5, 1, 'TH', 0, 1),
(6, 1, 'FV', 0, 0),
(7, 1, 'FV', 1, 0),
(8, 1, 'FV', 0, 1),
(9, 6, NULL, 0, 0),
(10, 4, NULL, 0, 0),
(11, 3, NULL, 0, 0),
(12, 2, NULL, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ensamble`
--

CREATE TABLE `detalle_ensamble` (
  `idDetalle_ensamble` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_por_proceso` varchar(10) DEFAULT '00:00',
  `cantidad_terminada` varchar(10) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `noperarios` tinyint(2) NOT NULL DEFAULT '0',
  `orden` tinyint(1) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_ensamble`
--

INSERT INTO `detalle_ensamble` (`idDetalle_ensamble`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`) VALUES
(5, '30:07', '9037:50', '300', '2018-11-19', '2018-11-20', 2, 15, 3, '2018-11-20 12:19:02', '2018-11-20 15:26:32', 0, 0, '0'),
(6, '00:00', '00:00', '0', NULL, NULL, 2, 16, 1, NULL, NULL, 0, 0, '0'),
(7, '00:00', '2768:52', '0', NULL, NULL, 2, 17, 2, NULL, NULL, 0, 0, '0'),
(8, '00:00', '62:12', '10', '2018-12-04', NULL, 2, 18, 2, '2018-12-04 08:10:30', '2018-12-04 08:10:50', 0, 0, '0'),
(9, '00:00', '00:00', '0', NULL, NULL, 3, 15, 2, NULL, NULL, 0, 0, '0'),
(10, '00:00', '00:00', '0', NULL, NULL, 3, 16, 1, NULL, NULL, 0, 0, '0'),
(11, '00:00', '00:00', '0', NULL, NULL, 3, 17, 1, NULL, NULL, 0, 0, '0'),
(12, '00:00', '00:00', '0', NULL, NULL, 3, 18, 1, NULL, NULL, 0, 0, '0'),
(13, '106:50', '106:50', '1', '2018-12-12', '2018-12-12', 4, 15, 3, '2018-12-12 09:49:39', '2018-12-12 10:09:12', 0, 1, '0'),
(14, '00:00', '00:00', '0', NULL, NULL, 4, 16, 1, NULL, NULL, 0, 0, '0'),
(15, '41:56', '83:53', '2', '2018-12-12', '2018-12-14', 4, 17, 3, '2018-12-14 11:44:12', '2018-12-14 11:44:38', 0, 0, '0'),
(16, '00:58', '00:58', '1', '2018-12-17', '2018-12-17', 4, 18, 3, '2018-12-17 10:31:58', '2018-12-17 10:32:56', 0, 0, '0'),
(17, '456:49', '456:49', '1', '2018-12-12', '2018-12-12', 5, 15, 3, '2018-12-12 15:36:48', '2018-12-12 15:37:03', 0, 1, '0'),
(18, '00:00', '00:00', '0', NULL, NULL, 5, 16, 1, NULL, NULL, 0, 0, '0'),
(19, '62:09', '62:09', '1', '2018-12-13', '2018-12-14', 5, 17, 3, '2018-12-14 11:42:32', '2018-12-14 11:43:05', 0, 0, '0'),
(20, '02:09', '02:09', '1', '2018-12-17', '2018-12-17', 5, 18, 3, '2018-12-17 10:39:16', '2018-12-17 10:41:25', 0, 0, '0'),
(21, '106:05', '106:05', '1', '2018-12-14', '2018-12-14', 6, 15, 3, '2018-12-14 11:52:52', '2018-12-14 11:53:10', 0, 1, '0'),
(22, '00:00', '00:00', '0', NULL, NULL, 6, 16, 1, NULL, NULL, 0, 0, '0'),
(23, '181:49', '181:49', '1', '2018-12-14', '2018-12-17', 6, 17, 3, '2018-12-17 09:24:48', '2018-12-17 09:25:16', 0, 0, '0'),
(24, '02:31', '02:31', '1', '2018-12-17', '2018-12-17', 6, 18, 3, '2018-12-17 10:43:01', '2018-12-17 10:45:32', 0, 0, '0'),
(25, '168:26', '168:26', '1', '2018-12-14', '2018-12-14', 7, 15, 3, '2018-12-14 14:32:01', '2018-12-14 14:32:48', 0, 1, '0'),
(26, '00:00', '00:00', '0', NULL, NULL, 7, 16, 1, NULL, NULL, 0, 0, '0'),
(27, '61:30', '61:30', '1', '2018-12-14', '2018-12-17', 7, 17, 3, '2018-12-17 09:25:55', '2018-12-17 09:26:28', 0, 0, '0'),
(28, '02:09', '02:09', '1', '2018-12-17', '2018-12-17', 7, 18, 3, '2018-12-17 10:48:19', '2018-12-17 10:50:28', 0, 0, '0'),
(29, '256:30', '256:30', '1', '2018-12-14', '2018-12-17', 8, 15, 3, '2018-12-17 06:40:53', '2018-12-17 08:55:20', 0, 1, '0'),
(30, '00:00', '00:00', '0', NULL, NULL, 8, 16, 1, NULL, NULL, 0, 0, '0'),
(31, '23:04', '23:04', '1', '2018-12-17', '2018-12-17', 8, 17, 3, '2018-12-17 15:31:56', '2018-12-17 15:32:18', 0, 0, '0'),
(32, '01:45', '01:45', '1', '2018-12-17', '2018-12-17', 8, 18, 3, '2018-12-17 15:44:34', '2018-12-17 15:46:19', 0, 0, '0'),
(33, '43:45', '87:31', '2', '2018-12-14', '2018-12-14', 9, 15, 3, '2018-12-14 13:41:14', '2018-12-14 13:41:15', 0, 1, '0'),
(34, '00:00', '00:00', '0', NULL, NULL, 9, 16, 1, NULL, NULL, 0, 0, '0'),
(35, '43:21', '43:21', '1', '2018-12-14', '2018-12-17', 9, 17, 3, '2018-12-17 09:00:15', '2018-12-17 09:18:48', 0, 0, '0'),
(36, '01:26', '01:26', '1', '2018-12-17', '2018-12-17', 9, 18, 3, '2018-12-17 10:52:16', '2018-12-17 10:53:42', 0, 0, '0'),
(37, '00:00', '00:00', '0', NULL, NULL, 10, 15, 1, NULL, NULL, 0, 0, '0'),
(38, '00:00', '00:00', '0', NULL, NULL, 10, 16, 1, NULL, NULL, 0, 0, '0'),
(39, '00:00', '00:00', '0', NULL, NULL, 10, 17, 1, NULL, NULL, 0, 0, '0'),
(40, '00:00', '00:00', '0', NULL, NULL, 10, 18, 1, NULL, NULL, 0, 0, '0'),
(41, '01:07', '05:35', '5', '2019-01-17', '2019-01-17', 11, 15, 3, '2019-01-17 12:18:17', '2019-01-17 12:18:54', 0, 1, '0'),
(42, '00:00', '08:00', '3', '2019-01-17', NULL, 11, 16, 2, '2019-01-17 12:23:56', '2019-01-17 12:24:29', 0, 0, '2'),
(43, '00:00', '00:49', '3', '2019-01-17', NULL, 11, 17, 2, '2019-01-17 12:06:25', '2019-01-17 12:07:14', 0, 0, '0'),
(44, '00:00', '01:01', '3', '2019-01-17', NULL, 11, 18, 2, '2019-01-17 12:08:01', '2019-01-17 12:09:02', 0, 0, '0'),
(45, '00:00', '1146:36', '0', '2018-12-06', NULL, 12, 15, 2, '2018-12-06 12:16:02', '2018-12-06 14:06:52', 0, 0, '0'),
(46, '00:00', '00:00', '0', NULL, NULL, 12, 16, 1, NULL, NULL, 0, 0, '0'),
(47, '00:00', '115:18', '0', '2018-12-06', NULL, 12, 17, 2, '2018-12-06 15:14:51', '2018-12-06 16:12:14', 0, 0, '0'),
(48, '00:00', '00:00', '0', NULL, NULL, 12, 18, 1, NULL, NULL, 0, 0, '0'),
(49, '00:00', '1186:34', '0', '2019-01-29', NULL, 13, 15, 2, '2019-02-20 09:09:03', '2019-02-20 09:09:11', 0, 1, '150'),
(50, '00:00', '00:00', '0', NULL, NULL, 13, 16, 1, NULL, NULL, 0, 0, '0'),
(51, '00:00', '00:00', '0', NULL, NULL, 13, 17, 1, NULL, NULL, 0, 0, '0'),
(52, '00:00', '00:00', '0', NULL, NULL, 13, 18, 1, NULL, NULL, 0, 0, '0'),
(53, '00:00', '00:00', '0', NULL, NULL, 14, 15, 1, NULL, NULL, 0, 0, '0'),
(54, '00:00', '00:00', '0', NULL, NULL, 14, 16, 1, NULL, NULL, 0, 1, '100'),
(55, '00:00', '00:00', '0', NULL, NULL, 14, 17, 1, NULL, NULL, 0, 0, '0'),
(56, '00:00', '00:00', '0', NULL, NULL, 14, 18, 1, NULL, NULL, 0, 0, '0'),
(57, '00:00', '00:00', '0', NULL, NULL, 15, 15, 1, NULL, NULL, 0, 0, '0'),
(58, '00:00', '00:00', '0', NULL, NULL, 15, 16, 1, NULL, NULL, 0, 0, '0'),
(59, '00:00', '00:00', '0', NULL, NULL, 15, 17, 1, NULL, NULL, 0, 0, '0'),
(60, '00:00', '00:00', '0', NULL, NULL, 15, 18, 1, NULL, NULL, 0, 0, '0'),
(61, '00:00', '3723:05', '0', '2018-11-30', NULL, 16, 15, 2, '2018-12-04 10:40:23', '2018-12-04 12:11:27', 0, 0, '0'),
(62, '00:00', '00:00', '0', NULL, NULL, 16, 16, 1, NULL, NULL, 0, 0, '0'),
(63, '00:00', '1507:40', '0', '2018-12-03', NULL, 16, 17, 2, '2018-12-05 06:00:21', '2018-12-05 12:51:29', 0, 0, '0'),
(64, '00:00', '00:00', '0', NULL, NULL, 16, 18, 1, NULL, NULL, 0, 0, '0'),
(65, '00:00', '2887:39', '5', '2019-02-23', NULL, 17, 15, 2, '2019-02-25 10:08:24', '2019-02-25 10:08:39', 0, 1, '5'),
(66, '00:00', '00:00', '0', NULL, NULL, 17, 16, 1, NULL, NULL, 0, 0, '4'),
(67, '00:00', '00:00', '0', NULL, NULL, 17, 17, 1, NULL, NULL, 0, 0, '1'),
(68, '00:00', '00:00', '0', NULL, NULL, 17, 18, 1, NULL, NULL, 0, 0, '0'),
(69, '84:47', '339:08', '4', '2018-12-14', '2018-12-17', 18, 15, 3, '2018-12-17 09:32:19', '2018-12-17 09:33:10', 0, 1, '0'),
(70, '00:00', '00:00', '0', NULL, NULL, 18, 16, 1, NULL, NULL, 0, 0, '0'),
(71, '87:53', '175:46', '2', '2018-12-17', '2018-12-20', 18, 17, 3, '2018-12-20 13:23:22', '2018-12-20 14:35:50', 0, 0, '0'),
(72, '02:41', '05:23', '2', '2018-12-20', '2018-12-20', 18, 18, 3, '2018-12-20 14:46:24', '2018-12-20 14:51:47', 0, 0, '0'),
(73, '00:00', '00:00', '0', NULL, NULL, 19, 15, 1, NULL, NULL, 0, 0, '0'),
(74, '00:00', '00:00', '0', NULL, NULL, 19, 16, 1, NULL, NULL, 0, 0, '0'),
(75, '00:00', '00:00', '0', NULL, NULL, 19, 17, 1, NULL, NULL, 0, 0, '0'),
(76, '00:00', '00:00', '0', NULL, NULL, 19, 18, 1, NULL, NULL, 0, 0, '0'),
(77, '00:00', '00:00', '0', NULL, NULL, 20, 15, 1, NULL, NULL, 0, 0, '0'),
(78, '00:00', '00:00', '0', NULL, NULL, 20, 16, 1, NULL, NULL, 0, 0, '0'),
(79, '00:00', '00:00', '0', NULL, NULL, 20, 17, 1, NULL, NULL, 0, 0, '0'),
(80, '00:00', '00:00', '0', NULL, NULL, 20, 18, 1, NULL, NULL, 0, 0, '0'),
(81, '00:00', '00:00', '0', NULL, NULL, 21, 15, 1, NULL, NULL, 0, 0, '0'),
(82, '00:00', '00:00', '0', NULL, NULL, 21, 16, 1, NULL, NULL, 0, 0, '0'),
(83, '00:00', '00:00', '0', NULL, NULL, 21, 17, 1, NULL, NULL, 0, 0, '0'),
(84, '00:00', '00:00', '0', NULL, NULL, 21, 18, 1, NULL, NULL, 0, 0, '0'),
(85, '00:00', '00:00', '0', NULL, NULL, 22, 15, 1, NULL, NULL, 0, 0, '0'),
(86, '00:00', '00:00', '0', NULL, NULL, 22, 16, 1, NULL, NULL, 0, 0, '0'),
(87, '00:00', '00:00', '0', NULL, NULL, 22, 17, 1, NULL, NULL, 0, 0, '0'),
(88, '00:00', '00:00', '0', NULL, NULL, 22, 18, 1, NULL, NULL, 0, 0, '0'),
(89, '00:00', '00:00', '0', NULL, NULL, 23, 15, 1, NULL, NULL, 0, 0, '0'),
(90, '00:00', '00:00', '0', NULL, NULL, 23, 16, 1, NULL, NULL, 0, 0, '0'),
(91, '00:00', '00:00', '0', NULL, NULL, 23, 17, 1, NULL, NULL, 0, 0, '0'),
(92, '00:00', '00:00', '0', NULL, NULL, 23, 18, 1, NULL, NULL, 0, 0, '0'),
(93, '00:00', '00:00', '0', NULL, NULL, 24, 15, 1, NULL, NULL, 0, 0, '0'),
(94, '00:00', '00:00', '0', NULL, NULL, 24, 16, 1, NULL, NULL, 0, 0, '0'),
(95, '00:00', '00:00', '0', NULL, NULL, 24, 17, 1, NULL, NULL, 0, 0, '0'),
(96, '00:00', '00:00', '0', NULL, NULL, 24, 18, 1, NULL, NULL, 0, 0, '0'),
(97, '00:00', '00:00', '0', NULL, NULL, 25, 15, 1, NULL, NULL, 0, 0, '0'),
(98, '00:00', '00:00', '0', NULL, NULL, 25, 16, 1, NULL, NULL, 0, 0, '0'),
(99, '00:00', '00:00', '0', NULL, NULL, 25, 17, 1, NULL, NULL, 0, 0, '0'),
(100, '00:00', '00:00', '0', NULL, NULL, 25, 18, 1, NULL, NULL, 0, 0, '0'),
(101, '00:00', '00:00', '0', NULL, NULL, 26, 15, 1, NULL, NULL, 0, 0, '0'),
(102, '00:00', '00:00', '0', NULL, NULL, 26, 16, 1, NULL, NULL, 0, 0, '0'),
(103, '00:00', '00:00', '0', NULL, NULL, 26, 17, 1, NULL, NULL, 0, 0, '0'),
(104, '00:00', '00:00', '0', NULL, NULL, 26, 18, 1, NULL, NULL, 0, 0, '0'),
(105, '00:00', '00:00', '0', NULL, NULL, 27, 15, 1, NULL, NULL, 0, 0, '0'),
(106, '00:00', '00:00', '0', NULL, NULL, 27, 16, 1, NULL, NULL, 0, 0, '0'),
(107, '00:00', '00:00', '0', NULL, NULL, 27, 17, 1, NULL, NULL, 0, 0, '0'),
(108, '00:00', '00:00', '0', NULL, NULL, 27, 18, 1, NULL, NULL, 0, 0, '0'),
(109, '00:00', '00:00', '0', NULL, NULL, 28, 15, 1, NULL, NULL, 0, 0, '0'),
(110, '00:00', '00:00', '0', NULL, NULL, 28, 16, 1, NULL, NULL, 0, 0, '0'),
(111, '00:00', '00:00', '0', NULL, NULL, 28, 17, 1, NULL, NULL, 0, 0, '0'),
(112, '00:00', '00:00', '0', NULL, NULL, 28, 18, 1, NULL, NULL, 0, 0, '0'),
(113, '00:00', '00:00', '0', NULL, NULL, 29, 15, 1, NULL, NULL, 0, 0, '0'),
(114, '00:00', '00:00', '0', NULL, NULL, 29, 16, 1, NULL, NULL, 0, 0, '0'),
(115, '00:00', '00:00', '0', NULL, NULL, 29, 17, 1, NULL, NULL, 0, 0, '0'),
(116, '00:00', '00:00', '0', NULL, NULL, 29, 18, 1, NULL, NULL, 0, 0, '0'),
(117, '00:00', '00:00', '0', NULL, NULL, 30, 15, 1, NULL, NULL, 0, 0, '0'),
(118, '00:00', '00:00', '0', NULL, NULL, 30, 16, 1, NULL, NULL, 0, 0, '0'),
(119, '00:00', '00:00', '0', NULL, NULL, 30, 17, 1, NULL, NULL, 0, 0, '0'),
(120, '00:00', '00:00', '0', NULL, NULL, 30, 18, 1, NULL, NULL, 0, 0, '0'),
(121, '00:00', '00:00', '0', NULL, NULL, 31, 15, 1, NULL, NULL, 0, 0, '0'),
(122, '00:00', '00:00', '0', NULL, NULL, 31, 16, 1, NULL, NULL, 0, 0, '0'),
(123, '00:00', '00:00', '0', NULL, NULL, 31, 17, 1, NULL, NULL, 0, 0, '0'),
(124, '00:00', '00:00', '0', NULL, NULL, 31, 18, 1, NULL, NULL, 0, 0, '0'),
(125, '00:00', '00:00', '0', NULL, NULL, 32, 15, 1, NULL, NULL, 0, 0, '0'),
(126, '00:00', '00:00', '0', NULL, NULL, 32, 16, 1, NULL, NULL, 0, 0, '0'),
(127, '15:01', '30:02', '2', '2018-12-13', '2018-12-13', 32, 17, 3, '2018-12-13 07:55:42', '2018-12-13 07:56:27', 0, 1, '0'),
(128, '02:08', '04:16', '2', '2018-12-13', '2018-12-13', 32, 18, 3, '2018-12-13 09:43:37', '2018-12-13 09:47:53', 0, 0, '0'),
(129, '00:00', '569:49', '5', '2018-12-12', NULL, 33, 15, 2, '2019-01-18 08:32:39', '2019-01-18 08:32:53', 0, 1, '25'),
(130, '00:00', '00:00', '0', NULL, NULL, 33, 16, 1, NULL, NULL, 0, 0, '0'),
(131, '00:00', '30:03', '5', '2018-12-13', NULL, 33, 17, 2, '2018-12-13 15:05:35', '2018-12-13 15:05:57', 0, 0, '0'),
(132, '00:00', '01:10', '5', '2018-12-13', NULL, 33, 18, 2, '2018-12-13 15:12:39', '2018-12-13 15:13:49', 0, 0, '0'),
(133, '00:00', '00:00', '0', NULL, NULL, 34, 15, 1, NULL, NULL, 0, 0, '0'),
(134, '00:00', '00:00', '0', NULL, NULL, 34, 16, 1, NULL, NULL, 0, 0, '0'),
(135, '00:00', '00:00', '0', NULL, NULL, 34, 17, 1, NULL, NULL, 0, 0, '0'),
(136, '00:00', '00:00', '0', NULL, NULL, 34, 18, 1, NULL, NULL, 0, 0, '0'),
(137, '00:00', '24:25', '0', '2019-01-14', NULL, 35, 15, 2, '2019-01-14 09:02:48', '2019-01-14 09:27:13', 0, 1, '2'),
(138, '00:00', '00:00', '0', NULL, NULL, 35, 16, 1, NULL, NULL, 0, 0, '0'),
(139, '00:00', '00:00', '0', NULL, NULL, 35, 17, 1, NULL, NULL, 0, 0, '0'),
(140, '00:00', '00:00', '0', NULL, NULL, 35, 18, 1, NULL, NULL, 0, 0, '0'),
(141, '16:13', '2109:54', '130', '2019-02-05', '2019-02-11', 42, 15, 3, '2019-02-11 07:57:23', '2019-02-11 07:57:43', 0, 1, '0'),
(142, '00:00', '00:00', '0', NULL, NULL, 42, 16, 1, NULL, NULL, 0, 0, '0'),
(143, '47:05', '6122:35', '130', '2019-02-06', '2019-02-20', 42, 17, 3, '2019-02-20 06:35:53', '2019-02-20 14:06:57', 0, 0, '0'),
(144, '00:00', '23:52', '81', '2019-02-13', NULL, 42, 18, 2, '2019-02-20 06:17:48', '2019-02-20 06:35:08', 0, 0, '49'),
(145, '04:21', '3397:50', '780', '2019-02-05', '2019-02-19', 48, 15, 3, '2019-02-19 11:06:26', '2019-02-19 11:07:15', 0, 1, '0'),
(146, '00:00', '00:00', '0', NULL, NULL, 48, 16, 1, NULL, NULL, 0, 0, '0'),
(147, '44:48', '9410:16', '210', '2019-02-05', '2019-02-20', 48, 17, 3, '2019-02-20 06:35:27', '2019-02-20 13:57:09', 0, 0, '0'),
(148, '00:00', '34:01', '115', '2019-02-19', NULL, 48, 18, 2, '2019-02-20 06:35:36', '2019-02-20 06:44:34', 0, 0, '15'),
(149, '00:00', '00:00', '0', NULL, NULL, 52, 15, 1, NULL, NULL, 0, 0, '200'),
(150, '31:38', '6326:44', '200', '2019-02-05', '2019-02-13', 52, 16, 3, '2019-02-13 06:24:04', '2019-02-13 06:24:30', 0, 1, '0'),
(151, '00:00', '00:00', '0', NULL, NULL, 52, 17, 1, NULL, NULL, 0, 0, '0'),
(152, '00:00', '00:00', '0', NULL, NULL, 52, 18, 1, NULL, NULL, 0, 0, '0'),
(153, '15:56', '796:55', '50', '2019-02-05', '2019-02-07', 56, 15, 3, '2019-02-07 06:04:03', '2019-02-07 06:28:48', 0, 1, '0'),
(154, '00:00', '00:00', '0', NULL, NULL, 56, 16, 1, NULL, NULL, 0, 0, '0'),
(155, '146:22', '3659:28', '25', '2019-02-06', '2019-02-14', 56, 17, 3, '2019-02-14 14:10:13', '2019-02-14 14:22:29', 0, 0, '0'),
(156, '00:38', '16:04', '25', '2019-02-12', '2019-02-14', 56, 18, 3, '2019-02-14 15:19:41', '2019-02-14 15:20:39', 0, 0, '0'),
(157, '35:46', '1395:20', '39', '2019-02-05', '2019-02-08', 60, 15, 3, '2019-02-08 07:05:06', '2019-02-08 10:55:47', 0, 1, '0'),
(158, '00:00', '00:00', '0', NULL, NULL, 60, 16, 1, NULL, NULL, 0, 0, '0'),
(159, '18:56', '738:26', '39', '2019-02-06', '2019-02-13', 60, 17, 3, '2019-02-13 06:55:15', '2019-02-13 14:26:22', 0, 0, '0'),
(160, '00:06', '03:58', '39', '2019-02-13', '2019-02-13', 60, 18, 3, '2019-02-13 15:05:45', '2019-02-13 15:09:43', 0, 0, '0'),
(161, '50:32', '1263:25', '25', '2019-02-05', '2019-02-06', 64, 15, 3, '2019-02-06 09:22:31', '2019-02-06 09:26:00', 0, 1, '0'),
(162, '00:00', '00:00', '0', NULL, NULL, 64, 16, 1, NULL, NULL, 0, 0, '0'),
(163, '14:37', '365:47', '25', '2019-02-05', '2019-02-14', 64, 17, 3, '2019-02-14 14:23:20', '2019-02-14 14:23:54', 0, 0, '0'),
(164, '00:12', '05:07', '25', '2019-02-14', '2019-02-14', 64, 18, 3, '2019-02-14 15:21:08', '2019-02-14 15:26:15', 0, 0, '0'),
(165, '20:46', '1038:59', '50', '2019-02-05', '2019-02-07', 67, 15, 3, '2019-02-07 05:58:39', '2019-02-07 06:31:01', 0, 1, '0'),
(166, '00:00', '00:00', '0', NULL, NULL, 67, 16, 1, NULL, NULL, 0, 0, '0'),
(167, '28:22', '1418:24', '50', '2019-02-05', '2019-02-13', 67, 17, 3, '2019-02-13 15:21:21', '2019-02-13 15:54:09', 0, 0, '0'),
(168, '00:33', '27:32', '50', '2019-02-13', '2019-02-14', 67, 18, 3, '2019-02-14 13:50:14', '2019-02-14 14:07:00', 0, 0, '0'),
(169, '14:06', '1595:08', '113', '2019-02-05', '2019-02-08', 71, 15, 3, '2019-02-08 14:25:09', '2019-02-08 14:25:42', 0, 1, '0'),
(170, '00:00', '00:00', '0', NULL, NULL, 71, 16, 1, NULL, NULL, 0, 0, '0'),
(171, '13:24', '1340:25', '100', '2019-02-06', '2019-02-18', 71, 17, 3, '2019-02-18 13:33:39', '2019-02-18 13:34:11', 0, 0, '0'),
(172, '00:14', '24:11', '100', '2019-02-13', '2019-02-18', 71, 18, 3, '2019-02-18 13:54:23', '2019-02-18 13:56:29', 0, 0, '0'),
(173, '07:22', '2397:38', '325', '2019-02-05', '2019-02-08', 75, 15, 3, '2019-02-08 13:03:18', '2019-02-08 13:59:32', 0, 1, '0'),
(174, '00:00', '00:00', '0', NULL, NULL, 75, 16, 1, NULL, NULL, 0, 0, '0'),
(175, '17:06', '1710:13', '100', '2019-02-06', '2019-02-18', 75, 17, 3, '2019-02-18 13:32:40', '2019-02-18 13:33:13', 0, 0, '0'),
(176, '00:13', '22:38', '100', '2019-02-13', '2019-02-18', 75, 18, 3, '2019-02-18 13:58:39', '2019-02-18 13:59:19', 0, 0, '0'),
(177, '105:02', '5252:04', '50', '2019-02-05', '2019-02-07', 79, 15, 3, '2019-02-07 10:12:05', '2019-02-07 12:29:47', 0, 1, '0'),
(178, '00:00', '00:00', '0', NULL, NULL, 79, 16, 1, NULL, NULL, 0, 0, '0'),
(179, '06:48', '340:46', '50', '2019-02-06', '2019-02-14', 79, 17, 3, '2019-02-14 14:08:37', '2019-02-14 14:09:13', 0, 0, '0'),
(180, '00:33', '27:36', '50', '2019-02-13', '2019-02-14', 79, 18, 3, '2019-02-14 15:13:52', '2019-02-14 15:19:05', 0, 0, '0'),
(181, '19:59', '1199:45', '60', '2019-02-05', '2019-02-07', 82, 15, 3, '2019-02-07 14:56:56', '2019-02-07 15:29:59', 0, 1, '0'),
(182, '00:00', '00:00', '0', NULL, NULL, 82, 16, 1, NULL, NULL, 0, 0, '0'),
(183, '22:53', '1373:47', '60', '2019-02-06', '2019-02-18', 82, 17, 3, '2019-02-18 13:31:22', '2019-02-18 13:31:57', 0, 0, '0'),
(184, '00:00', '00:20', '60', '2019-02-18', '2019-02-18', 82, 18, 3, '2019-02-18 13:59:56', '2019-02-18 14:00:16', 0, 0, '0'),
(189, '00:00', '00:00', '0', NULL, NULL, 96, 15, 1, NULL, NULL, 0, 0, '0'),
(190, '00:00', '00:00', '0', NULL, NULL, 96, 16, 1, NULL, NULL, 0, 0, '0'),
(191, '00:00', '00:00', '0', NULL, NULL, 96, 17, 1, NULL, NULL, 0, 0, '0'),
(192, '00:00', '00:00', '0', NULL, NULL, 96, 18, 1, NULL, NULL, 0, 0, '0'),
(193, '117:54', '1414:52', '12', '2019-01-28', '2019-01-29', 101, 15, 3, '2019-01-28 16:19:21', '2019-01-29 09:35:37', 0, 1, '0'),
(194, '00:00', '00:00', '0', NULL, NULL, 101, 16, 1, NULL, NULL, 0, 0, '0'),
(195, '294:07', '3529:24', '12', '2019-01-29', '2019-02-08', 101, 17, 3, '2019-02-08 10:57:07', '2019-02-08 10:57:33', 0, 0, '0'),
(196, '00:02', '00:33', '12', '2019-02-08', '2019-02-08', 101, 18, 3, '2019-02-08 11:05:45', '2019-02-08 11:06:18', 0, 0, '0'),
(197, '00:00', '1149:04', '10', '2019-01-29', NULL, 107, 15, 2, '2019-02-01 06:07:46', '2019-02-01 06:09:08', 0, 1, '10'),
(198, '00:00', '00:00', '0', NULL, NULL, 107, 16, 1, NULL, NULL, 0, 0, '0'),
(199, '00:00', '350:57', '10', '2019-02-01', NULL, 107, 17, 2, '2019-02-01 13:08:02', '2019-02-01 13:08:51', 0, 0, '0'),
(200, '00:00', '05:35', '10', '2019-02-01', NULL, 107, 18, 2, '2019-02-01 13:27:51', '2019-02-01 13:33:26', 0, 0, '0'),
(201, '00:00', '00:00', '0', NULL, NULL, 122, 15, 1, NULL, NULL, 0, 0, '0'),
(202, '00:00', '00:00', '0', NULL, NULL, 122, 16, 1, NULL, NULL, 0, 0, '0'),
(203, '00:00', '00:00', '0', NULL, NULL, 122, 17, 1, NULL, NULL, 0, 0, '0'),
(204, '00:00', '00:00', '0', NULL, NULL, 122, 18, 1, NULL, NULL, 0, 0, '0'),
(205, '03:28', '1950:29', '562', '2019-01-30', '2019-02-04', 125, 15, 3, '2019-02-04 12:19:50', '2019-02-04 14:40:08', 0, 1, '0'),
(206, '00:00', '00:00', '0', NULL, NULL, 125, 16, 1, NULL, NULL, 0, 0, '0'),
(207, '03:41', '2070:26', '562', '2019-01-31', '2019-02-08', 125, 17, 3, '2019-02-08 06:01:20', '2019-02-08 07:12:43', 0, 0, '0'),
(208, '01:49', '913:56', '500', '2019-02-01', '2019-02-08', 125, 18, 3, '2019-02-08 10:44:26', '2019-02-08 10:44:53', 0, 0, '0'),
(209, '00:00', '00:00', '0', NULL, NULL, 130, 15, 1, NULL, NULL, 0, 0, '0'),
(210, '00:00', '00:00', '0', NULL, NULL, 130, 16, 1, NULL, NULL, 0, 0, '0'),
(211, '00:00', '00:00', '0', NULL, NULL, 130, 17, 1, NULL, NULL, 0, 0, '0'),
(212, '00:00', '00:00', '0', NULL, NULL, 130, 18, 1, NULL, NULL, 0, 0, '0'),
(213, '01:18', '984:32', '750', '2019-01-31', '2019-02-04', 138, 15, 3, '2019-02-04 15:44:07', '2019-02-04 15:55:02', 0, 0, '0'),
(214, '01:34', '1182:23', '750', '2019-01-31', '2019-02-04', 138, 16, 3, '2019-02-04 06:57:51', '2019-02-04 09:51:12', 0, 1, '0'),
(215, '03:29', '2615:03', '750', '2019-02-01', '2019-02-07', 138, 17, 3, '2019-02-07 06:53:17', '2019-02-07 06:53:53', 0, 0, '0'),
(216, '00:09', '114:56', '750', '2019-02-01', '2019-02-07', 138, 18, 3, '2019-02-07 07:25:33', '2019-02-07 07:26:05', 0, 0, '0'),
(217, '03:49', '76:28', '20', '2019-02-11', '2019-02-11', 150, 15, 3, '2019-02-11 06:44:51', '2019-02-11 08:01:19', 0, 1, '0'),
(218, '00:00', '00:00', '0', NULL, NULL, 150, 16, 1, NULL, NULL, 0, 0, '0'),
(219, '01:01', '20:30', '20', '2019-02-11', '2019-02-11', 150, 17, 3, '2019-02-11 09:39:14', '2019-02-11 09:42:20', 0, 0, '0'),
(220, '00:13', '04:37', '20', '2019-02-11', '2019-02-11', 150, 18, 3, '2019-02-11 10:31:55', '2019-02-11 10:36:32', 0, 0, '0'),
(221, '00:00', '00:00', '0', NULL, NULL, 176, 15, 1, NULL, NULL, 0, 0, '0'),
(222, '00:00', '00:00', '0', NULL, NULL, 176, 16, 1, NULL, NULL, 0, 0, '0'),
(223, '00:00', '00:00', '0', NULL, NULL, 176, 17, 1, NULL, NULL, 0, 0, '0'),
(224, '00:00', '00:00', '0', NULL, NULL, 176, 18, 1, NULL, NULL, 0, 0, '0'),
(225, '00:00', '00:00', '0', NULL, NULL, 180, 15, 1, NULL, NULL, 0, 0, '0'),
(226, '00:00', '00:00', '0', NULL, NULL, 180, 16, 1, NULL, NULL, 0, 0, '0'),
(227, '00:00', '00:00', '0', NULL, NULL, 180, 17, 1, NULL, NULL, 0, 0, '0'),
(228, '00:00', '00:00', '0', NULL, NULL, 180, 18, 1, NULL, NULL, 0, 0, '0'),
(229, '00:00', '00:00', '0', NULL, NULL, 190, 15, 1, NULL, NULL, 0, 0, '0'),
(230, '00:00', '00:00', '0', NULL, NULL, 190, 16, 1, NULL, NULL, 0, 0, '0'),
(231, '00:00', '00:00', '0', NULL, NULL, 190, 17, 1, NULL, NULL, 0, 0, '0'),
(232, '00:00', '00:00', '0', NULL, NULL, 190, 18, 1, NULL, NULL, 0, 0, '0'),
(233, '00:00', '00:00', '0', NULL, NULL, 197, 15, 1, NULL, NULL, 0, 0, '0'),
(234, '00:00', '00:00', '0', NULL, NULL, 197, 16, 1, NULL, NULL, 0, 0, '0'),
(235, '00:00', '00:00', '0', NULL, NULL, 197, 17, 1, NULL, NULL, 0, 0, '0'),
(236, '00:00', '00:00', '0', NULL, NULL, 197, 18, 1, NULL, NULL, 0, 0, '0'),
(237, '00:00', '00:00', '0', NULL, NULL, 206, 15, 1, NULL, NULL, 0, 0, '1200'),
(238, '01:46', '2122:03', '1200', '2019-02-12', '2019-02-14', 206, 16, 3, '2019-02-14 06:01:15', '2019-02-14 11:19:03', 0, 1, '0'),
(239, '00:00', '00:00', '0', NULL, NULL, 206, 17, 1, NULL, NULL, 0, 0, '0'),
(240, '00:00', '00:00', '0', NULL, NULL, 206, 18, 1, NULL, NULL, 0, 0, '0'),
(241, '31:08', '3114:50', '100', '2019-02-11', '2019-02-12', 210, 15, 3, '2019-02-12 15:08:22', '2019-02-12 15:08:35', 0, 1, '0'),
(242, '00:00', '00:00', '0', NULL, NULL, 210, 16, 1, NULL, NULL, 0, 0, '0'),
(243, '00:00', '00:00', '0', NULL, NULL, 210, 17, 1, NULL, NULL, 0, 0, '0'),
(244, '00:23', '39:28', '100', '2019-02-12', '2019-02-12', 210, 18, 3, '2019-02-12 15:13:46', '2019-02-12 15:41:01', 0, 0, '0'),
(245, '00:00', '00:00', '0', NULL, NULL, 214, 15, 1, NULL, NULL, 0, 0, '0'),
(246, '00:00', '00:00', '0', NULL, NULL, 214, 16, 1, NULL, NULL, 0, 0, '0'),
(247, '00:00', '00:00', '0', NULL, NULL, 214, 17, 1, NULL, NULL, 0, 0, '0'),
(248, '00:00', '00:00', '0', NULL, NULL, 214, 18, 1, NULL, NULL, 0, 0, '0'),
(249, '00:00', '00:00', '0', NULL, NULL, 222, 15, 1, NULL, NULL, 0, 0, '0'),
(250, '00:00', '00:00', '0', NULL, NULL, 222, 16, 1, NULL, NULL, 0, 0, '0'),
(251, '00:00', '00:00', '0', NULL, NULL, 222, 17, 1, NULL, NULL, 0, 0, '0'),
(252, '00:00', '00:00', '0', NULL, NULL, 222, 18, 1, NULL, NULL, 0, 0, '0'),
(253, '00:00', '00:00', '0', NULL, NULL, 227, 15, 1, NULL, NULL, 0, 0, '0'),
(254, '00:00', '00:00', '0', NULL, NULL, 227, 16, 1, NULL, NULL, 0, 0, '0'),
(255, '00:00', '00:00', '0', NULL, NULL, 227, 17, 1, NULL, NULL, 0, 0, '0'),
(256, '00:00', '00:00', '0', NULL, NULL, 227, 18, 1, NULL, NULL, 0, 0, '0'),
(257, '00:00', '00:00', '0', NULL, NULL, 241, 15, 1, NULL, NULL, 0, 0, '0'),
(258, '00:00', '00:00', '0', NULL, NULL, 241, 16, 1, NULL, NULL, 0, 0, '0'),
(259, '00:00', '00:00', '0', NULL, NULL, 241, 17, 1, NULL, NULL, 0, 0, '0'),
(260, '00:00', '00:00', '0', NULL, NULL, 241, 18, 1, NULL, NULL, 0, 0, '0'),
(261, '00:00', '00:00', '0', NULL, NULL, 248, 15, 1, NULL, NULL, 0, 0, '0'),
(262, '00:00', '00:00', '0', NULL, NULL, 248, 16, 1, NULL, NULL, 0, 0, '0'),
(263, '00:00', '00:00', '0', NULL, NULL, 248, 17, 1, NULL, NULL, 0, 0, '0'),
(264, '00:00', '00:00', '0', NULL, NULL, 248, 18, 1, NULL, NULL, 0, 0, '0'),
(265, '00:00', '00:00', '0', NULL, NULL, 254, 15, 1, NULL, NULL, 0, 0, '0'),
(266, '00:00', '00:00', '0', NULL, NULL, 254, 16, 1, NULL, NULL, 0, 0, '0'),
(267, '00:00', '00:00', '0', NULL, NULL, 254, 17, 1, NULL, NULL, 0, 0, '0'),
(268, '00:00', '00:00', '0', NULL, NULL, 254, 18, 1, NULL, NULL, 0, 0, '0'),
(269, '00:00', '00:00', '0', NULL, NULL, 259, 15, 1, NULL, NULL, 0, 0, '0'),
(270, '00:00', '00:00', '0', NULL, NULL, 259, 16, 1, NULL, NULL, 0, 0, '0'),
(271, '00:00', '00:00', '0', NULL, NULL, 259, 17, 1, NULL, NULL, 0, 0, '0'),
(272, '00:00', '00:00', '0', NULL, NULL, 259, 18, 1, NULL, NULL, 0, 0, '0'),
(273, '00:00', '00:00', '0', NULL, NULL, 267, 15, 1, NULL, NULL, 0, 0, '0'),
(274, '00:00', '00:00', '0', NULL, NULL, 267, 16, 1, NULL, NULL, 0, 0, '0'),
(275, '00:00', '00:00', '0', NULL, NULL, 267, 17, 1, NULL, NULL, 0, 0, '0'),
(276, '00:00', '00:00', '0', NULL, NULL, 267, 18, 1, NULL, NULL, 0, 0, '0'),
(277, '00:00', '00:00', '0', NULL, NULL, 270, 15, 1, NULL, NULL, 0, 0, '0'),
(278, '00:00', '00:00', '0', NULL, NULL, 270, 16, 1, NULL, NULL, 0, 0, '0'),
(279, '00:00', '00:00', '0', NULL, NULL, 270, 17, 1, NULL, NULL, 0, 0, '0'),
(280, '00:00', '00:00', '0', NULL, NULL, 270, 18, 1, NULL, NULL, 0, 0, '0'),
(281, '00:00', '00:00', '0', NULL, NULL, 273, 15, 1, NULL, NULL, 0, 0, '0'),
(282, '00:00', '00:00', '0', NULL, NULL, 273, 16, 1, NULL, NULL, 0, 0, '0'),
(283, '00:00', '00:00', '0', NULL, NULL, 273, 17, 1, NULL, NULL, 0, 0, '0'),
(284, '00:00', '00:00', '0', NULL, NULL, 273, 18, 1, NULL, NULL, 0, 0, '0'),
(285, '00:00', '00:00', '0', NULL, NULL, 276, 15, 1, NULL, NULL, 0, 0, '0'),
(286, '00:00', '00:00', '0', NULL, NULL, 276, 16, 1, NULL, NULL, 0, 0, '0'),
(287, '00:00', '00:00', '0', NULL, NULL, 276, 17, 1, NULL, NULL, 0, 0, '0'),
(288, '00:00', '00:00', '0', NULL, NULL, 276, 18, 1, NULL, NULL, 0, 0, '0'),
(289, '00:00', '00:00', '0', NULL, NULL, 281, 15, 1, NULL, NULL, 0, 0, '0'),
(290, '00:00', '00:00', '0', NULL, NULL, 281, 16, 1, NULL, NULL, 0, 0, '0'),
(291, '00:00', '00:00', '0', NULL, NULL, 281, 17, 1, NULL, NULL, 0, 0, '0'),
(292, '00:00', '00:00', '0', NULL, NULL, 281, 18, 1, NULL, NULL, 0, 0, '0'),
(293, '00:00', '00:00', '0', NULL, NULL, 290, 15, 1, NULL, NULL, 0, 0, '0'),
(294, '00:00', '00:00', '0', NULL, NULL, 290, 16, 1, NULL, NULL, 0, 0, '0'),
(295, '00:00', '00:00', '0', NULL, NULL, 290, 17, 1, NULL, NULL, 0, 0, '0'),
(296, '00:00', '00:00', '0', NULL, NULL, 290, 18, 1, NULL, NULL, 0, 0, '0'),
(297, '00:00', '00:00', '0', NULL, NULL, 299, 15, 1, NULL, NULL, 0, 0, '0'),
(298, '00:00', '00:00', '0', NULL, NULL, 299, 16, 1, NULL, NULL, 0, 0, '0'),
(299, '00:00', '00:00', '0', NULL, NULL, 299, 17, 1, NULL, NULL, 0, 0, '0'),
(300, '00:00', '00:00', '0', NULL, NULL, 299, 18, 1, NULL, NULL, 0, 0, '0'),
(301, '00:00', '00:00', '0', NULL, NULL, 309, 15, 1, NULL, NULL, 0, 0, '0'),
(302, '00:00', '00:00', '0', NULL, NULL, 309, 16, 1, NULL, NULL, 0, 0, '0'),
(303, '00:00', '00:00', '0', NULL, NULL, 309, 17, 1, NULL, NULL, 0, 0, '0'),
(304, '00:00', '00:00', '0', NULL, NULL, 309, 18, 1, NULL, NULL, 0, 0, '0'),
(305, '00:00', '00:00', '0', NULL, NULL, 315, 15, 1, NULL, NULL, 0, 0, '0'),
(306, '00:00', '00:00', '0', NULL, NULL, 315, 16, 1, NULL, NULL, 0, 0, '0'),
(307, '00:00', '00:00', '0', NULL, NULL, 315, 17, 1, NULL, NULL, 0, 0, '0'),
(308, '00:00', '00:00', '0', NULL, NULL, 315, 18, 1, NULL, NULL, 0, 0, '0'),
(309, '00:00', '00:00', '0', NULL, NULL, 319, 15, 1, NULL, NULL, 0, 0, '0'),
(310, '00:00', '00:00', '0', NULL, NULL, 319, 16, 1, NULL, NULL, 0, 0, '0'),
(311, '00:00', '00:00', '0', NULL, NULL, 319, 17, 1, NULL, NULL, 0, 0, '0'),
(312, '00:00', '00:00', '0', NULL, NULL, 319, 18, 1, NULL, NULL, 0, 0, '0'),
(313, '00:00', '00:00', '0', NULL, NULL, 321, 15, 1, NULL, NULL, 0, 0, '0'),
(314, '00:00', '00:00', '0', NULL, NULL, 321, 16, 1, NULL, NULL, 0, 0, '0'),
(315, '00:00', '00:00', '0', NULL, NULL, 321, 17, 1, NULL, NULL, 0, 0, '0'),
(316, '00:00', '00:00', '0', NULL, NULL, 321, 18, 1, NULL, NULL, 0, 0, '0'),
(317, '00:00', '00:00', '0', NULL, NULL, 322, 15, 1, NULL, NULL, 0, 0, '0'),
(318, '00:00', '00:00', '0', NULL, NULL, 322, 16, 1, NULL, NULL, 0, 0, '0'),
(319, '00:00', '00:00', '0', NULL, NULL, 322, 17, 1, NULL, NULL, 0, 0, '0'),
(320, '00:00', '00:00', '0', NULL, NULL, 322, 18, 1, NULL, NULL, 0, 0, '0');

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
  `orden` tinyint(1) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`) VALUES
(1, '00:07', '01:17', '10', '2019-02-25', '2019-02-25', 329, 1, 3, '2019-02-25 11:55:30', '2019-02-25 11:56:18', 0, 1, '0'),
(2, '00:00', '00:25', '1', '2019-02-25', NULL, 329, 3, 2, '2019-02-25 12:12:25', '2019-02-25 12:12:40', 0, 2, '9'),
(3, '00:00', '00:00', '0', NULL, NULL, 329, 4, 1, NULL, NULL, 0, 3, '1'),
(4, '00:00', '00:00', '0', NULL, NULL, 329, 5, 1, NULL, NULL, 0, 4, '0'),
(5, '00:00', '00:00', '0', NULL, NULL, 329, 7, 1, NULL, NULL, 0, 5, '0'),
(6, '00:00', '00:00', '0', NULL, NULL, 329, 8, 1, NULL, NULL, 0, 6, '0'),
(7, '00:00', '00:00', '0', NULL, NULL, 329, 10, 1, NULL, NULL, 0, 7, '0'),
(8, '00:00', '00:00', '0', NULL, NULL, 330, 1, 1, NULL, NULL, 0, 1, '1'),
(9, '00:00', '00:00', '0', NULL, NULL, 330, 4, 1, NULL, NULL, 0, 2, '0'),
(10, '00:00', '00:00', '0', NULL, NULL, 331, 1, 1, NULL, NULL, 0, 1, '1'),
(11, '00:00', '00:00', '0', NULL, NULL, 331, 4, 1, NULL, NULL, 0, 2, '0'),
(12, '00:00', '00:00', '0', NULL, NULL, 331, 4, 1, NULL, NULL, 0, 2, '0'),
(13, '00:00', '00:00', '0', NULL, NULL, 332, 1, 1, NULL, NULL, 0, 1, '1'),
(14, '00:00', '00:00', '0', NULL, NULL, 332, 3, 1, NULL, NULL, 0, 2, '0'),
(15, '00:00', '00:00', '0', NULL, NULL, 332, 4, 1, NULL, NULL, 0, 3, '0'),
(16, '00:00', '00:00', '0', NULL, NULL, 333, 1, 1, NULL, NULL, 0, 1, '10'),
(17, '00:00', '00:00', '0', NULL, NULL, 333, 2, 1, NULL, NULL, 0, 2, '0'),
(18, '00:00', '00:00', '0', NULL, NULL, 333, 3, 1, NULL, NULL, 0, 3, '0'),
(19, '00:00', '00:00', '0', NULL, NULL, 333, 4, 1, NULL, NULL, 0, 4, '0'),
(20, '00:00', '00:00', '0', NULL, NULL, 333, 5, 1, NULL, NULL, 0, 5, '0'),
(21, '00:00', '00:00', '0', NULL, NULL, 333, 6, 1, NULL, NULL, 0, 6, '0'),
(22, '00:00', '00:00', '0', NULL, NULL, 333, 7, 1, NULL, NULL, 0, 7, '0'),
(23, '00:00', '00:00', '0', NULL, NULL, 333, 8, 1, NULL, NULL, 0, 8, '0'),
(24, '00:00', '00:00', '0', NULL, NULL, 333, 9, 1, NULL, NULL, 0, 9, '0'),
(25, '00:00', '00:00', '0', NULL, NULL, 333, 10, 1, NULL, NULL, 0, 1, '0');

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
  `tiempo_total` varchar(20) DEFAULT NULL,
  `Total_timepo_Unidad` varchar(20) DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL,
  `lider_proyecto` varchar(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `idProducto`, `canitadad_total`, `material`, `proyecto_numero_orden`, `idArea`, `estado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`, `lider_proyecto`) VALUES
(2, 1, '300', NULL, 31344, 3, 2, 0, NULL, 1, 1, 1, 1, '11868:54', '00:00', NULL, NULL),
(3, 1, '1', NULL, 31676, 3, 2, 0, NULL, 3, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(4, 1, '1', NULL, 31701, 3, 3, 0, NULL, 1, 0, 0, 3, '191:41', '149:44', '2018-12-17 10:32:56', '1037587834'),
(5, 1, '1', NULL, 31702, 3, 3, 0, NULL, 1, 0, 0, 3, '521:07', '521:07', '2018-12-17 10:41:26', '43605625'),
(6, 1, '1', NULL, 31703, 3, 3, 0, NULL, 1, 0, 0, 3, '290:25', '290:25', '2018-12-17 10:45:33', '43542658'),
(7, 1, '1', NULL, 31704, 3, 3, 0, NULL, 1, 0, 0, 3, '232:05', '232:05', '2018-12-17 10:50:28', '1037587834'),
(8, 1, '1', NULL, 31705, 3, 3, 0, NULL, 1, 0, 0, 3, '281:19', '281:19', '2018-12-17 15:46:20', '1037587834'),
(9, 1, '1', NULL, 31706, 3, 3, 0, NULL, 1, 0, 0, 3, '132:18', '88:32', '2018-12-17 10:53:43', '43542658'),
(10, 1, '1', NULL, 31707, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(11, 1, '5', '', 31743, 3, 2, 0, NULL, 0, 0, 3, 1, '15:25', '00:00', NULL, '42702332'),
(12, 1, '40', NULL, 31744, 3, 2, 0, NULL, 2, 0, 2, 0, '1261:54', '00:00', NULL, NULL),
(13, 1, '150', NULL, 31762, 3, 2, 0, NULL, 3, 0, 1, 0, '1186:34', '00:00', NULL, '43542658'),
(14, 1, '100', NULL, 31633, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036629003'),
(15, 1, '40', NULL, 31682, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(16, 1, '50', NULL, 31717, 3, 2, 0, NULL, 2, 0, 2, 0, '5230:45', '00:00', NULL, NULL),
(17, 1, '10', NULL, 31809, 3, 2, 0, NULL, 3, 0, 1, 0, '2887:39', '00:00', NULL, '43542658'),
(18, 1, '2', NULL, 31793, 3, 3, 0, NULL, 1, 0, 0, 3, '520:17', '175:21', '2018-12-20 14:51:47', '43542658'),
(19, 1, '200', NULL, 31810, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(20, 1, '200', NULL, 31815, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036622270'),
(21, 1, '100', NULL, 31816, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036629003'),
(22, 1, '50', NULL, 31817, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036680551'),
(23, 1, '25', NULL, 31818, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1017187557'),
(24, 1, '50', NULL, 31819, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036680551'),
(25, 1, '50', NULL, 31820, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1007110815'),
(26, 1, '16', NULL, 31836, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '1036629003'),
(27, 1, '1', NULL, 31845, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(28, 1, '5', NULL, 31846, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '43542658'),
(29, 1, '10', NULL, 31847, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '42702332'),
(30, 1, '20', NULL, 31880, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '43265824'),
(31, 1, '25', NULL, 31837, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(32, 1, '2', NULL, 31840, 3, 3, 0, NULL, 2, 0, 0, 2, '34:18', '17:09', '2018-12-13 09:47:53', '1017225857'),
(33, 1, '30', '', 31799, 3, 2, 0, NULL, 1, 0, 3, 0, '601:02', '00:00', NULL, '1037587834'),
(34, 1, '10', NULL, 31894, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(35, 1, '2', NULL, 31898, 3, 2, 0, NULL, 3, 0, 1, 0, '24:25', '00:00', NULL, '43605625'),
(36, 1, '3', 'TH', 32053, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(37, 1, '12', 'TH', 32054, 1, 2, 0, NULL, 9, 0, 1, 0, '90:37', '00:00', NULL, NULL),
(38, 1, '5', 'TH', 32055, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(39, 1, '1', 'TH', 32056, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(40, 10, '', NULL, 32060, 4, 3, 0, NULL, 0, 0, 0, 1, '34', '00:00', '2019-02-19 08:40:08', NULL),
(41, 8, '130', 'GF', 32060, 4, 3, 0, NULL, 0, 0, 0, 1, '00:00', '00:00', '2019-02-19 06:31:26', NULL),
(42, 1, '130', '', 32060, 3, 2, 0, NULL, 1, 0, 1, 2, '8256:21', '00:00', NULL, '43189198'),
(44, 1, '100', 'FV', 32058, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(45, 1, '100', 'FV', 32059, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(46, 10, '', NULL, 32061, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(47, 8, '130', 'GF', 32061, 4, 3, 0, NULL, 0, 0, 0, 1, '34', '00:00', '2019-02-19 08:42:52', NULL),
(48, 1, '130', '', 32061, 3, 2, 0, NULL, 1, 0, 1, 2, '12842:07', '00:00', NULL, '1046913982'),
(50, 10, '', NULL, 32062, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(51, 8, '200', 'GF', 32062, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(52, 1, '200', '', 32062, 3, 2, 0, NULL, 3, 0, 0, 1, '6326:44', '00:00', NULL, '43605625'),
(54, 10, '', NULL, 32063, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(55, 8, '25', 'GF', 32063, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(56, 1, '25', '', 32063, 3, 3, 0, NULL, 1, 0, 0, 3, '4472:27', '162:56', '2019-02-14 15:20:39', '44006996'),
(58, 10, '', NULL, 32064, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(59, 8, '39', 'GF', 32064, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(60, 1, '39', '', 32064, 3, 3, 0, NULL, 1, 0, 0, 3, '2137:44', '54:48', '2019-02-13 15:09:43', '1017187557'),
(62, 10, '', NULL, 32065, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(63, 8, '25', 'GF', 32065, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(64, 1, '25', NULL, 32065, 3, 3, 0, NULL, 1, 0, 0, 3, '1634:19', '65:21', '2019-02-14 15:26:15', '42702332'),
(65, 10, '', NULL, 32066, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(66, 8, '50', 'GF', 32066, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(67, 1, '50', '', 32066, 3, 3, 0, NULL, 1, 0, 0, 3, '2484:55', '49:41', '2019-02-14 14:07:00', '21424773'),
(69, 10, '', NULL, 32067, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(70, 8, '100', 'GF', 32067, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(71, 1, '100', '', 32067, 3, 3, 0, NULL, 1, 0, 0, 3, '2959:44', '27:44', '2019-02-18 13:56:29', '1036680551'),
(73, 10, '', NULL, 32068, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(74, 8, '100', 'GF', 32068, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(75, 1, '100', '', 32068, 3, 3, 0, NULL, 1, 0, 0, 3, '4130:29', '24:41', '2019-02-18 13:59:19', '1036622270'),
(77, 10, '', NULL, 32069, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(78, 8, '50', 'GF', 32069, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(79, 1, '50', NULL, 32069, 3, 3, 0, NULL, 1, 0, 0, 3, '5620:26', '112:23', '2019-02-14 15:19:06', '42702332'),
(80, 10, '', NULL, 32070, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(81, 8, '60', 'GF', 32070, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(82, 1, '60', '', 32070, 3, 3, 0, NULL, 1, 0, 0, 3, '2573:52', '42:52', '2019-02-18 14:00:16', '43542658'),
(84, 1, '25', 'TH', 29366, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(85, 1, '25', 'TH', 29375, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(87, 1, '5', 'TH', 32074, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(89, 1, '30', 'FV', 32075, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(90, 1, '2', 'TH', 32118, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(91, 1, '5', 'TH', 32121, 1, 2, 0, NULL, 4, 0, 0, 5, '801:41', '00:00', NULL, NULL),
(92, 1, '6', 'TH', 32122, 1, 4, 0, NULL, 3, 2, 0, 4, '1112:32', '00:00', NULL, NULL),
(93, 1, '5', 'TH', 32123, 1, 2, 0, NULL, 2, 0, 0, 7, '635:03', '00:00', NULL, NULL),
(96, 1, '200', '', 32124, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(98, 1, '4', 'TH', 32125, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(101, 1, '12', '', 31681, 3, 3, 0, NULL, 1, 0, 0, 3, '4944:49', '412:03', '2019-02-13 10:57:19', '1216727816'),
(103, 1, '100', 'TH', 32131, 1, 2, 0, NULL, 5, 0, 2, 2, '1938:05', '00:00', NULL, NULL),
(104, 1, '100', 'TH', 32132, 1, 2, 0, NULL, 5, 0, 2, 2, '2860:52', '00:00', NULL, NULL),
(105, 1, '20', 'FV', 32134, 1, 2, 0, NULL, 4, 0, 1, 3, '192:23', '00:00', NULL, NULL),
(106, 1, '2', 'TH', 32136, 1, 2, 0, NULL, 3, 0, 0, 6, '610:48', '00:00', NULL, NULL),
(107, 1, '20', NULL, 31795, 3, 2, 0, NULL, 1, 0, 3, 0, '1505:36', '00:00', NULL, '43542658'),
(108, 1, '30', 'TH', 32128, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(109, 1, '7', 'TH', 32140, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(110, 1, '10', 'FV', 32143, 1, 2, 0, NULL, 6, 0, 1, 1, '49:52', '00:00', NULL, NULL),
(111, 1, '10', 'FV', 32144, 1, 2, 0, NULL, 4, 0, 1, 3, '1314:49', '00:00', NULL, NULL),
(112, 1, '4', 'TH', 32145, 1, 4, 0, NULL, 4, 1, 0, 4, '365:15', '00:00', NULL, NULL),
(113, 1, '1', 'TH', 32147, 1, 4, 0, NULL, 3, 1, 0, 5, '1179:10', '00:00', NULL, NULL),
(114, 1, '10', 'FV', 32148, 1, 2, 0, NULL, 4, 0, 1, 3, '154:51', '00:00', NULL, NULL),
(115, 1, '10', 'TH', 32149, 1, 4, 0, NULL, 6, 1, 0, 2, '41:59', '00:00', NULL, NULL),
(116, 1, '10', 'FV', 32150, 1, 2, 0, NULL, 4, 0, 0, 4, '193:56', '00:00', NULL, NULL),
(117, 1, '10', 'TH', 32151, 1, 2, 0, NULL, 5, 0, 1, 3, '8455:07', '00:00', NULL, NULL),
(118, 1, '10', 'FV', 32152, 1, 2, 0, NULL, 4, 0, 0, 4, '213:45', '00:00', NULL, NULL),
(119, 1, '10', 'FV', 32153, 1, 4, 0, NULL, 4, 1, 0, 3, '216:27', '00:00', NULL, NULL),
(120, 1, '2', 'TH', 32154, 1, 2, 0, NULL, 3, 0, 0, 6, '7100:35', '00:00', NULL, NULL),
(121, 1, '2', 'TH', 32155, 1, 2, 0, NULL, 3, 0, 0, 6, '7087:35', '00:00', NULL, NULL),
(122, 1, '6', NULL, 32129, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(125, 1, '500', '', 32139, 3, 3, 0, NULL, 1, 0, 0, 3, '4934:51', '08:58', '2019-02-13 11:06:44', '43605625'),
(127, 1, '1', 'TH', 32158, 1, 4, 0, NULL, 5, 1, 0, 3, '394:03', '00:00', NULL, NULL),
(130, 1, '100', '', 32157, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(132, 1, '10', 'TH', 32160, 1, 2, 0, NULL, 4, 0, 0, 5, '602:02', '00:00', NULL, NULL),
(133, 1, '200', 'FV', 32161, 1, 4, 0, NULL, 5, 1, 0, 2, '179:13', '00:00', NULL, NULL),
(134, 1, '2', 'TH', 32163, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(135, 1, '12', 'TH', 32164, 1, 4, 0, NULL, 4, 1, 0, 4, '1646:14', '00:00', NULL, NULL),
(136, 10, '', NULL, 32138, 4, 3, 0, NULL, 0, 0, 0, 1, '0', '00:00', '2019-02-07 11:54:32', NULL),
(137, 8, '750', 'GF', 32138, 4, 3, 0, NULL, 0, 0, 0, 1, '0', '00:00', '2019-02-07 11:54:32', NULL),
(138, 1, '750', '', 32138, 3, 3, 0, NULL, 0, 0, 0, 4, '4896:54', '06:30', '2019-02-07 11:54:32', '43542658'),
(140, 1, '4', 'TH', 32166, 1, 4, 0, NULL, 4, 1, 0, 4, '46:02', '00:00', NULL, NULL),
(141, 1, '5', 'TH', 32169, 1, 4, 0, NULL, 4, 2, 0, 3, '17:35', '00:00', NULL, NULL),
(142, 1, '20', 'TH', 32170, 1, 4, 0, NULL, 5, 2, 0, 2, '1096:19', '00:00', NULL, NULL),
(143, 1, '4', 'TH', 32171, 1, 4, 0, NULL, 4, 1, 0, 4, '160:54', '00:00', NULL, NULL),
(144, 1, '500', 'FV', 32173, 1, 2, 0, NULL, 5, 0, 0, 3, '178:54', '00:00', NULL, NULL),
(145, 1, '3', 'FV', 32174, 1, 4, 0, NULL, 6, 1, 0, 1, '78:53', '00:00', NULL, NULL),
(146, 1, '12', 'FV', 32178, 1, 2, 0, NULL, 6, 0, 0, 2, '110:10', '00:00', NULL, NULL),
(147, 1, '50', 'TH', 32179, 1, 2, 0, NULL, 7, 0, 0, 1, '85:05', '00:00', NULL, NULL),
(150, 1, '20', '', 32180, 3, 3, 0, NULL, 1, 0, 0, 3, '101:35', '05:03', '2019-02-13 11:13:29', '43542658'),
(151, 1, '2', 'TH', 32181, 1, 4, 0, NULL, 5, 1, 0, 3, '4435:29', '00:00', NULL, NULL),
(152, 1, '2', 'TH', 32182, 1, 2, 0, NULL, 5, 0, 0, 4, '414:36', '00:00', NULL, NULL),
(153, 1, '2', 'TH', 32183, 1, 4, 0, NULL, 5, 3, 0, 1, '15:34', '00:00', NULL, NULL),
(154, 1, '1', 'TH', 32188, 1, 2, 0, NULL, 5, 0, 0, 4, '2096:49', '00:00', NULL, NULL),
(155, 1, '15', 'FV', 32189, 1, 2, 0, NULL, 5, 0, 1, 2, '132:21', '00:00', NULL, NULL),
(156, 1, '10', 'TH', 32190, 1, 4, 0, NULL, 7, 1, 0, 1, '198:26', '00:00', NULL, NULL),
(157, 1, '250', 'FV', 32192, 1, 2, 0, NULL, 6, 0, 0, 1, '31:37', '00:00', NULL, NULL),
(158, 1, '4', 'TH', 32193, 1, 4, 0, NULL, 5, 2, 0, 2, '145:47', '00:00', NULL, NULL),
(159, 1, '4', 'TH', 32194, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(160, 1, '1', 'TH', 32195, 1, 2, 0, NULL, 7, 0, 0, 2, '354:11', '00:00', NULL, NULL),
(161, 1, '10', 'TH', 32196, 1, 2, 0, NULL, 5, 0, 0, 4, '1597:58', '00:00', NULL, NULL),
(162, 1, '22', 'TH', 32199, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(163, 1, '25', 'TH', 32203, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(164, 1, '30', 'TH', 32200, 1, 2, 0, NULL, 8, 0, 0, 1, '51:14', '00:00', NULL, NULL),
(165, 1, '2', 'TH', 32204, 1, 4, 0, NULL, 5, 1, 0, 3, '483:02', '00:00', NULL, NULL),
(166, 1, '6', 'FV', 32205, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(167, 1, '20', 'FV', 32201, 1, 2, 0, NULL, 5, 0, 1, 2, '106:25', '00:00', NULL, NULL),
(168, 1, '6', 'TH', 32206, 1, 2, 0, NULL, 5, 0, 0, 4, '1553:32', '00:00', NULL, NULL),
(169, 1, '2', 'TH', 32207, 1, 2, 0, NULL, 5, 0, 0, 4, '501:54', '00:00', NULL, NULL),
(170, 1, '6', 'TH', 32208, 1, 4, 0, NULL, 5, 1, 0, 3, '1477:35', '00:00', NULL, NULL),
(171, 1, '10', 'TH', 32209, 1, 2, 0, NULL, 8, 0, 0, 1, '48:27', '00:00', NULL, NULL),
(172, 1, '20', 'FV', 32202, 1, 2, 0, NULL, 5, 0, 1, 2, '107:00', '00:00', NULL, NULL),
(173, 1, '20', 'TH', 32212, 1, 2, 0, NULL, 7, 0, 0, 2, '337:49', '00:00', NULL, NULL),
(174, 10, '', NULL, 32214, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(175, 1, '2', 'TH', 32214, 1, 4, 0, NULL, 8, 2, 0, 0, '00:00', '00:00', NULL, NULL),
(176, 1, '2', NULL, 32214, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(177, 1, '4', 'TH', 32215, 1, 2, 0, NULL, 8, 0, 0, 1, '48:13', '00:00', NULL, NULL),
(180, 1, '2', '', 32216, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(181, 1, '4', 'TH', 32217, 1, 4, 0, NULL, 5, 1, 0, 3, '166:25', '00:00', NULL, NULL),
(182, 1, '4', 'TH', 32218, 1, 2, 0, NULL, 4, 0, 0, 5, '1309:43', '00:00', NULL, NULL),
(183, 1, '2', 'TH', 32219, 1, 4, 0, NULL, 5, 2, 0, 2, '1102:36', '00:00', NULL, NULL),
(184, 1, '14', 'TH', 32220, 1, 4, 0, NULL, 5, 1, 0, 3, '157:26', '00:00', NULL, NULL),
(185, 1, '14', 'TH', 32221, 1, 4, 0, NULL, 5, 2, 0, 2, '137:28', '00:00', NULL, NULL),
(186, 1, '18', 'FV', 32222, 1, 4, 0, NULL, 5, 1, 0, 2, '86:49', '00:00', NULL, NULL),
(187, 1, '20', 'FV', 32223, 1, 2, 0, NULL, 5, 0, 0, 3, '99:06', '00:00', NULL, NULL),
(190, 1, '100', '', 32090, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(192, 1, '1', 'TH', 32225, 1, 4, 0, NULL, 7, 1, 0, 1, '197:40', '00:00', NULL, NULL),
(193, 1, '1', 'TH', 32224, 1, 4, 0, NULL, 7, 1, 0, 1, '198:03', '00:00', NULL, NULL),
(194, 1, '4', 'TH', 32226, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(197, 1, '10', '', 32071, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(199, 1, '9', 'TH', 32227, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(200, 1, '1', 'TH', 32230, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(201, 1, '1', 'TH', 32231, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(202, 1, '6', 'TH', 32237, 1, 2, 0, NULL, 7, 0, 0, 2, '214:58', '00:00', NULL, NULL),
(203, 1, '10', 'TH', 32236, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(206, 1, '1200', '', 32010, 3, 2, 0, NULL, 3, 0, 0, 1, '2122:03', '00:00', NULL, '1095791547'),
(210, 1, '100', '', 31561, 3, 3, 0, NULL, 2, 0, 0, 2, '3154:18', '31:31', '2019-02-13 10:56:23', '42702332'),
(214, 1, '2', NULL, 32240, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(215, 1, '1', 'TH', 32241, 1, 2, 0, NULL, 7, 0, 0, 2, '01:17', '00:00', NULL, NULL),
(216, 1, '50', 'FV', 32242, 1, 2, 0, NULL, 6, 0, 1, 0, '16:35', '00:00', NULL, NULL),
(217, 1, '5', 'TH', 32243, 1, 2, 0, NULL, 8, 0, 1, 0, '1993:42', '00:00', NULL, NULL),
(218, 1, '2', 'TH', 32244, 1, 2, 0, NULL, 8, 0, 0, 1, '20:33', '00:00', NULL, NULL),
(219, 1, '60', 'FV', 32245, 1, 2, 0, NULL, 7, 0, 1, 0, '02:02', '00:00', NULL, NULL),
(220, 10, '', NULL, 32246, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(221, 1, '10', 'FV', 32246, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(222, 1, '10', NULL, 32246, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(223, 6, '1', NULL, 32246, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(224, 1, '6', 'TH', 32251, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(227, 1, '20', '', 32247, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(229, 1, '10', 'FV', 32252, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(230, 1, '1', 'FV', 32248, 1, 2, 0, NULL, 7, 0, 0, 1, '55:00', '00:00', NULL, NULL),
(231, 1, '1', 'FV', 32249, 1, 2, 0, NULL, 8, 0, 0, 1, '63:07', '00:00', NULL, NULL),
(232, 1, '30', 'TH', 32255, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(233, 1, '30', 'FV', 32256, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(234, 1, '5', 'TH', 32260, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(235, 1, '5', 'FV', 32261, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(236, 1, '100', 'FV', 32262, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(237, 1, '100', 'FV', 32263, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(238, 1, '16', 'TH', 32264, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(239, 10, '', NULL, 32265, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(240, 1, '1', 'TH', 32265, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(241, 1, '1', NULL, 32265, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(242, 1, '10', 'TH', 32266, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(243, 1, '6', 'TH', 32267, 1, 2, 0, NULL, 9, 0, 0, 1, '05:59', '00:00', NULL, NULL),
(244, 1, '30', 'FV', 32268, 1, 4, 0, NULL, 7, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(245, 1, '30', 'TH', 32269, 1, 4, 0, NULL, 8, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(246, 10, '', NULL, 32270, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(247, 1, '5', 'TH', 32270, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(248, 1, '5', NULL, 32270, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(249, 1, '100', 'FV', 32273, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(250, 1, '2', 'TH', 32275, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(251, 1, '24', 'TH', 32276, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(252, 10, '', NULL, 32277, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(253, 8, '2', 'GF', 32277, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(254, 1, '2', NULL, 32277, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(255, 1, '2', 'TH', 32278, 1, 2, 0, NULL, 8, 0, 0, 1, '00:24', '00:00', NULL, NULL),
(257, 10, '', NULL, 32279, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(258, 1, '1', 'TH', 32279, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(259, 1, '1', NULL, 32279, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(260, 1, '2', 'TH', 32280, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(261, 1, '5', 'FV', 32281, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(262, 1, '1', 'TH', 32283, 1, 2, 0, NULL, 9, 0, 0, 1, '01:46', '00:00', NULL, NULL),
(263, 1, '10', 'TH', 32285, 1, 2, 0, NULL, 8, 0, 1, 0, '12:49', '00:00', NULL, NULL),
(264, 1, '20', 'TH', 32286, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(265, 10, '', NULL, 32287, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(266, 8, '50', 'GF', 32287, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(267, 1, '50', NULL, 32287, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(268, 10, '', NULL, 32288, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(269, 8, '25', 'GF', 32288, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(270, 1, '25', NULL, 32288, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(271, 10, '', NULL, 32289, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(272, 8, '3', 'GF', 32289, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(273, 1, '3', NULL, 32289, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(274, 10, '', NULL, 32291, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(275, 8, '50', 'GF', 32291, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(276, 1, '50', NULL, 32291, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(277, 6, '1', NULL, 32291, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(278, 1, '16', 'TH', 32293, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(279, 10, '', NULL, 32292, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(280, 1, '6', 'TH', 32292, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(281, 1, '6', NULL, 32292, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(282, 1, '1', 'TH', 32294, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(283, 1, '50', 'TH', 32295, 1, 2, 0, NULL, 8, 0, 0, 1, '114:45', '00:00', NULL, NULL),
(284, 1, '1', 'TH', 32296, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(285, 1, '25', 'TH', 32297, 1, 2, 0, NULL, 8, 0, 0, 1, '69:38', '00:00', NULL, NULL),
(286, 1, '24', 'TH', 32298, 1, 2, 0, NULL, 8, 0, 0, 1, '36:13', '00:00', NULL, NULL),
(287, 1, '10', 'TH', 32299, 1, 4, 0, NULL, 7, 1, 0, 1, '09:28', '00:00', NULL, NULL),
(288, 10, '', NULL, 32300, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(289, 1, '10', 'FV', 32300, 1, 4, 0, NULL, 8, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(290, 1, '10', NULL, 32300, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(291, 1, '5', 'FV', 32301, 1, 2, 0, NULL, 7, 0, 0, 1, '21:34', '00:00', NULL, NULL),
(294, 1, '21', 'TH', 32306, 1, 4, 0, NULL, 8, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(295, 1, '5', 'TH', 32307, 1, 2, 0, NULL, 8, 0, 0, 1, '28:48', '00:00', NULL, NULL),
(296, 1, '50', 'FV', 32310, 1, 2, 0, NULL, 6, 0, 0, 1, '41:02', '00:00', NULL, NULL),
(297, 10, '', NULL, 32309, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(298, 1, '3', 'TH', 32309, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(299, 1, '3', NULL, 32309, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(300, 1, '1', 'FV', 32311, 1, 2, 0, NULL, 6, 0, 0, 2, '09:41', '00:00', NULL, NULL),
(301, 1, '1', 'TH', 32312, 1, 2, 0, NULL, 8, 0, 0, 1, '09:33', '00:00', NULL, NULL),
(302, 1, '3', 'TH', 32302, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(303, 1, '4', 'TH', 32303, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(304, 1, '4', 'TH', 32313, 1, 4, 0, NULL, 7, 1, 0, 1, '09:09', '00:00', NULL, NULL),
(305, 1, '10', 'FV', 32314, 1, 4, 0, NULL, 6, 1, 0, 1, '08:09', '00:00', NULL, NULL),
(306, 1, '2', 'TH', 32315, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(307, 10, '', NULL, 32177, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(308, 1, '100', 'TH', 32177, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(309, 1, '100', NULL, 32177, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(310, 6, '1', NULL, 32177, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(311, 1, '20', 'TH', 32316, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(312, 1, '50', 'FV', 32317, 1, 2, 0, NULL, 7, 0, 0, 1, '39:30', '00:00', NULL, NULL),
(313, 10, '', NULL, 32318, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(314, 8, '12', 'GF', 32318, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(315, 1, '12', NULL, 32318, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(316, 6, '1', NULL, 32318, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(317, 10, '', NULL, 32319, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(318, 8, '5', 'GF', 32319, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(319, 1, '5', NULL, 32319, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(320, 6, '1', NULL, 32319, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(321, 1, '2', NULL, 32321, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(322, 1, '2', NULL, 32322, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(323, 1, '5', 'TH', 32323, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(324, 1, '5', 'TH', 32324, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(325, 1, '9', 'TH', 32325, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(326, 1, '10', 'TH', 32326, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(327, 1, '15', 'TH', 32327, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(328, 1, '12', 'TH', 32328, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(329, 2, '10', 'FV', 32329, 1, 2, 0, NULL, 5, 0, 1, 1, '01:42', '00:00', NULL, NULL),
(330, 4, '1', 'FV', 32329, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(331, 3, '1', 'FV', 32329, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(332, 6, '1', NULL, 32329, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(333, 1, '10', 'TH', 32329, 1, 1, 0, NULL, 0, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(334, 5, '10', NULL, 32330, 2, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_teclados`
--

CREATE TABLE `detalle_teclados` (
  `idDetalle_teclados` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_proceso` varchar(10) DEFAULT NULL,
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `idDetalle_proyecto` int(11) NOT NULL,
  `idproceso` tinyint(4) NOT NULL,
  `estado` tinyint(4) NOT NULL,
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_teclados`
--

INSERT INTO `detalle_teclados` (`idDetalle_teclados`, `tiempo_por_unidad`, `tiempo_total_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `idDetalle_proyecto`, `idproceso`, `estado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1, '00:00', '00:36', '0', '2018-12-05', NULL, 20, 11, 2, '2018-12-05 12:24:46', '2018-12-05 12:25:22', 15, 0),
(2, '00:00', '00:00', '0', NULL, NULL, 20, 12, 1, NULL, NULL, 0, 0),
(3, '00:00', '00:00', '0', NULL, NULL, 20, 13, 1, NULL, NULL, 0, 0),
(4, '00:00', '00:00', '0', NULL, NULL, 20, 14, 1, NULL, NULL, 0, 0),
(5, '00:00', '00:00', '0', NULL, NULL, 334, 11, 1, NULL, NULL, 0, 0),
(6, '00:00', '00:00', '0', NULL, NULL, 334, 12, 1, NULL, NULL, 0, 0),
(7, '00:00', '00:00', '0', NULL, NULL, 334, 13, 1, NULL, NULL, 0, 0),
(8, '00:00', '00:00', '0', NULL, NULL, 334, 14, 1, NULL, NULL, 0, 0);

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
(14, 'Control calidad', 1, 2),
(15, 'Manual', 1, 3),
(16, 'Automatico', 1, 3),
(17, 'Control Calidad', 1, 3),
(18, 'Empaque', 1, 3),
(19, 'Componentes', 1, 4),
(20, 'GF', 1, 4),
(25, 'demostracion', 0, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos_producto`
--

CREATE TABLE `procesos_producto` (
  `idProceso_producto` int(11) NOT NULL,
  `idCondicion` tinyint(4) NOT NULL,
  `orden` varchar(1) NOT NULL DEFAULT '1',
  `idProceso` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `procesos_producto`
--

INSERT INTO `procesos_producto` (`idProceso_producto`, `idCondicion`, `orden`, `idProceso`) VALUES
(1, 1, '1', 1),
(2, 1, '2', 2),
(3, 1, '3', 3),
(4, 1, '4', 4),
(5, 1, '5', 5),
(6, 1, '6', 6),
(7, 1, '7', 7),
(8, 1, '8', 8),
(9, 1, '9', 9),
(10, 1, '1', 10),
(11, 2, '1', 1),
(12, 2, '2', 3),
(14, 2, '3', 4),
(15, 2, '4', 5),
(16, 2, '5', 6),
(17, 2, '6', 7),
(18, 2, '7', 8),
(19, 2, '8', 9),
(20, 2, '9', 10),
(21, 3, '1', 1),
(22, 3, '2', 2),
(23, 3, '3', 3),
(24, 3, '4', 4),
(25, 3, '5', 5),
(26, 3, '6', 7),
(27, 3, '7', 8),
(28, 3, '8', 10),
(29, 4, '1', 1),
(30, 4, '2', 2),
(31, 4, '3', 3),
(32, 4, '4', 4),
(33, 4, '5', 5),
(34, 4, '6', 6),
(35, 4, '7', 7),
(36, 4, '8', 8),
(37, 4, '9', 10),
(38, 5, '1', 1),
(39, 5, '2', 2),
(40, 5, '3', 3),
(41, 5, '4', 4),
(42, 5, '5', 5),
(43, 5, '6', 6),
(44, 5, '7', 7),
(45, 5, '8', 8),
(46, 5, '9', 10),
(47, 6, '1', 1),
(48, 6, '2', 3),
(49, 6, '3', 4),
(50, 6, '4', 5),
(51, 6, '5', 7),
(52, 6, '6', 8),
(53, 6, '7', 10),
(54, 7, '1', 1),
(55, 7, '2', 3),
(56, 7, '3', 4),
(57, 7, '4', 5),
(58, 7, '5', 6),
(59, 7, '6', 7),
(60, 7, '7', 8),
(61, 7, '8', 10),
(62, 8, '1', 1),
(63, 8, '2', 3),
(64, 8, '3', 4),
(65, 8, '4', 5),
(66, 8, '5', 7),
(67, 8, '6', 8),
(68, 8, '7', 9),
(69, 8, '8', 10),
(70, 9, '1', 1),
(71, 9, '2', 3),
(72, 9, '3', 4),
(73, 10, '1', 1),
(74, 10, '2', 4),
(75, 11, '1', 1),
(77, 11, '2', 4),
(78, 12, '1', 1),
(79, 12, '2', 3),
(80, 12, '3', 4),
(81, 12, '4', 5),
(82, 12, '5', 7),
(83, 12, '6', 8),
(84, 12, '7', 10);

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
  `FE` tinyint(1) NOT NULL,
  `TE` tinyint(1) NOT NULL,
  `IN` tinyint(1) NOT NULL,
  `pcb_FE` tinyint(1) NOT NULL,
  `pcb_TE` tinyint(1) NOT NULL,
  `Conversor` tinyint(1) NOT NULL,
  `Repujado` tinyint(1) NOT NULL,
  `troquel` tinyint(1) NOT NULL,
  `stencil` tinyint(1) NOT NULL,
  `lexan` tinyint(1) NOT NULL,
  `fecha_ingreso` datetime NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `fecha_salidal` datetime DEFAULT NULL,
  `ruteoC` tinyint(1) DEFAULT NULL,
  `antisolderC` tinyint(1) DEFAULT NULL,
  `estado` tinyint(4) NOT NULL,
  `antisolderP` tinyint(1) DEFAULT NULL,
  `ruteoP` tinyint(1) DEFAULT NULL,
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

INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `ruteoC`, `antisolderC`, `estado`, `antisolderP`, `ruteoP`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(29366, '981130', 'Micro%20Hom%20Cali%20S.A.S ', 'Control%20Planta ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 16:25:41', '0020-07-10', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29375, '981130', 'Micro%20Hom%20Cali%20S.A.S ', 'Control%20Planta ', 'Normal', 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, '2019-01-17 09:03:42', '2018-10-04', NULL, 1, 1, 1, 0, 0, 0, 1, '2018-10-05', '2018-10-06', NULL, NULL, NULL, NULL, NULL),
(31344, '98765201', 'QSTARS S.A.S', 'TARJETA MLDT', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-15 14:48:01', '2018-11-19', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31561, '1216714539', 'ECOLUZ S.A.S ', 'Tarjeta Circular 4000   6000 lm ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-08 07:58:23', '2018-11-29', '2019-02-13 10:56:23', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(31633, '1152697088', 'Dometal', 'DOMETAL-8499 SISTEMA 2 V2.7-NOV 06 2018', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-28 07:30:21', '2018-12-11', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31676, '1152697088', 'JAVIER RUIZ SOMAYAR', ' ZIR-2', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-15 15:55:32', '2018-11-28', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31681, '981130', 'TECREA S.A.S ', 'INDUFRIAL GPSWIFITEMP ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-28 07:13:20', '2018-12-12', '2019-02-13 10:57:19', 0, 0, 3, 1, 1, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(31682, '1152697088', 'TECREA', 'TECREA-TELELAMP AUSTRALIA- NOV 15-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-28 07:32:37', '2018-12-14', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31701, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL ', 'PLACA LUCES', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:18:06', '2018-12-05', '2018-12-17 10:32:56', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31702, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA FUSIBLES', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:26:51', '2018-12-05', '2018-12-17 10:41:26', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31703, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA DE POTENCIA 5V', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:32:18', '2018-12-05', '2018-12-17 10:45:33', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31704, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA DE POTENCIA 12V', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:37:36', '2018-12-05', '2018-12-17 10:50:28', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31705, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA DE POTENCIA 24V', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:40:30', '2018-12-05', '2018-12-17 15:46:20', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31706, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA DE POTENCIA 28V', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:43:52', '2018-12-05', '2018-12-17 10:53:43', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31707, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'PLACA DE CONTROL', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-19 14:47:38', '2018-12-05', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31717, '98765201', 'INSSA S.A.S', 'TCP2016_V6', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-30 08:33:48', '2018-12-13', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31743, '98765201', 'TECREA S.A.S', 'TRACKFOX LORA', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-23 08:48:34', '2018-12-17', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(31744, '98765201', 'FANTASIA DEL AGUA', 'DAISY CHAIN D V3.2.2015', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-23 09:00:53', '2018-12-20', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31762, '1152697088', 'CORONA-Colcerámica', 'CORONA COLCERAMICA-DRAA V2.11 - OCT 23-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-27 07:06:11', '2018-12-26', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31793, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'MINDEFENSA - PLACA DE CONTROL - NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-03 10:31:36', '2018-12-14', '2018-12-20 14:51:47', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31795, '981130', 'TECREA S.A.S', 'TRACKFOX LORA', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-29 06:21:53', '2018-12-26', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31799, '98765201', 'TECREA S.A.S ', 'COLLAR FASE 1 ', 'RQT', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-12 10:27:19', '2018-12-14', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(31809, '1152697088', 'DISTRACOM S.A', 'DISTRACOM-MFC OMEGA-NOV 27-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-03 09:41:39', '2018-12-18', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31810, '1152697088', 'Dometal', 'DOMETAL-8076 CONCENTRADOR-NOV 28 2018', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:00:41', '2018-12-11', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31815, '1152697088', 'Dometal', 'DOMETAL-8076 CONCENTRADOR-NOV 28 2018', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:02:23', '2019-01-11', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31816, '1152697088', 'Dometal', 'DOMETAL-7141 ACELEROMETRO V2.6-NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:05:28', '2019-01-09', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31817, '1152697088', 'Dometal', 'DOMETAL-8201-NOV 28 -18-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:11:11', '2019-01-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31818, '1152697088', 'Dometal', 'DOMETAL-7905 CM PARTOS SISTEMA 2 v3-NOV 28-17', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:14:24', '2019-01-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31819, '1152697088', 'Dometal', 'DOMETAL-8199-NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:17:39', '2019-01-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31820, '1152697088', 'Dometal', 'DOMETAL-8200-NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-04 07:20:42', '2019-01-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31836, '1152697088', 'TUBULAR RUNNING & RENTAL SERVICES S.A.S', 'TR Y RS - CAT SYSTEM - OCT 05-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-05 09:57:55', '2018-12-26', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31837, '98765201', 'TUBULAR RUNNING & RENTAL SERVICES S.A.S', ' VALVE CONTROL', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-12 08:17:11', '2018-12-31', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31840, '98765201', 'COLCERAMICA S.A', 'DRAA V2.11', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-12 08:20:12', '2018-12-19', '2018-12-13 09:47:53', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31845, '1152697088', 'TECREA', 'TECREA-ENSAMBLE ADIC AUTECO-NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-06 15:46:55', '2018-12-10', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31846, '1152697088', 'TECREA', 'TECREA-TRACKFOX GPS-DIC 06-18', 'Quick', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-06 15:55:42', '2018-12-10', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31847, '1152697088', 'TECREA', 'TECREA-TRACKFOX BOTON-DIC 06-18', 'Quick', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-06 15:57:52', '2018-12-10', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31880, '98765201', 'TECREA S.A.S ', 'TRACKFOX BOTON AAA ', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-11 14:37:08', '2019-01-10', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31894, '98765201', 'FANTASIA DEL AGUA', 'DMX DIGITAL', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-12 17:14:58', '2018-12-28', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(31898, '98765201', 'CPESCO CONTROL DE PROCESOS ELECTROMECANICOS Y SERVICIOS DE COLOMBIA SAS ', 'LITTLE BOY ', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-13 12:45:40', '2019-01-10', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32010, '1216714539', 'HACEB S.A. ', 'N700 V3 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-08 07:02:05', '2019-02-21', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32053, '1152697088', 'JHON ERICK NAVARRETE ', 'GERBER 2 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-15 12:17:34', '2019-01-16', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32054, '1152697088', 'ACCESO VIRTUAL S.A.S ', 'MIMO2 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-15 12:20:25', '2019-01-22', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32055, '1152697088', 'GRUPO ACUAMATIC S.A.S ', 'ACUABOARDESP32_2019 01 11 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-15 12:27:08', '2019-01-22', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32056, '1152697088', 'CARLOS ANDRES PANCHANA ', 'CENTRIGUGA V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-15 15:53:57', '2019-01-22', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32058, '1216714539', 'NETUX S.A.S ', 'TMP382 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:33:21', '2019-01-30', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32059, '1216714539', 'NETUX S.A.S ', 'SHT21 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:37:15', '2019-01-30', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32060, '1152697088', 'DOMETAL ', '8198 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:29:26', '2019-02-21', NULL, 0, 0, 2, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32061, '1152697088', 'DOMETAL ', '8199 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:37:29', '2019-02-21', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32062, '1152697088', 'DOMETAL ', '8499 SISTEMA 2 V2.7 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:46:47', '2019-02-21', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32063, '1152697088', 'DOMETAL ', '8538 ED 4 MOV SIN AUTO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:51:59', '2019-02-15', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32064, '1152697088', 'DOMETAL ', '8539 ED 4 MOV SIN AUTO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 12:56:12', '2019-02-15', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32065, '1152697088', 'DOMETAL ', '7904 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-01-16 12:59:26', '2019-02-15', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, NULL, 'A tiempo', NULL),
(32066, '1152697088', 'DOMETAL ', '8073 CONTROL PIES V5 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 13:02:31', '2019-02-15', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32067, '1152697088', 'DOMETAL ', '8074 DERECHO v3 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 13:06:20', '2019-02-19', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32068, '1152697088', 'DOMETAL ', '8075 IZQUIERDO V3 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 13:15:35', '2019-02-19', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-03-06', NULL, NULL, '', 'A tiempo', NULL),
(32069, '1152697088', 'DOMETAL ', '8200 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-01-16 13:22:19', '2019-02-15', NULL, 1, 1, 4, 1, 1, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, NULL, 'A tiempo', NULL),
(32070, '1152697088', 'DOMETAL ', '8201 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-16 13:26:24', '2019-02-19', NULL, 0, 0, 4, 0, 0, 1, 1, '2019-02-06', '2019-02-06', NULL, NULL, '', 'A tiempo', NULL),
(32071, '1216714539', 'INVYTEC ', 'SKTONE_64 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-07 15:08:27', '2019-02-12', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32074, '981130', 'TECREA S.A.S ', 'BASE ILIGHT ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-17 09:58:06', '2019-01-25', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32075, '981130', 'INDUSTRIAS METALICAS LOS PINOS ', 'MANDO 7 TECLAS SMD V2 10 11 18 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-17 13:24:01', '2019-01-29', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32090, '1216714539', 'SOLUCIONES WIGA S.A.S ', 'PCBA014_1_1 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-07 08:43:02', '2019-02-20', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32118, '1216714539', 'LOGIC ELECTRONICS ', 'MARINILLA2018 V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-24 16:03:08', '2019-01-31', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32121, '1216714539', 'METROINDUSTRIAL SAS ', 'GERBER_HERMETICIDAD_DANIEL.tar ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-25 12:24:14', '2019-02-01', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32122, '1216714539', 'CARLOS HUMBERTO CUELLAR MARTINEZ ', 'SECUENCIAL V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-25 14:21:31', '2019-02-05', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32123, '1216714539', 'CORPORACION PARA LA INVESTIGACION DE LA CORROSION (CIC) ', 'CURRENTREV5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-25 14:21:56', '2019-02-01', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32124, '1216714539', 'INSITE S.A.S ', 'INL8 V3 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-25 14:47:52', '2019-03-07', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32125, '1216714539', 'DIDIER ALBERTO MARTINEZ SILVA ', 'C001 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-25 15:54:28', '2019-01-30', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32128, '1216714539', 'MICRO HOM S.A.S ', 'CARGADOR BATERIA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 09:08:47', '2019-02-07', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32129, '981130', 'DEINTEKO SAS', 'DEINTEKO SAS ', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-30 07:45:05', '2019-02-19', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32131, '1216714539', 'EFFITECH S.A.S ', 'INTERFAZ PIC 2.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-28 10:52:50', '2019-02-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32132, '1216714539', 'EFFITECH S.A.S ', 'TECLADO LUMINOSOS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-28 11:06:52', '2019-02-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32134, '1216714539', 'DISE%C3%91OS Y SOLUCIONES INDUSTRIALES S.A.S ', 'HPLC NANO blacksmith ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-28 16:01:00', '2019-02-07', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32136, '1216714539', 'OSWALDO  ALZATE VELASQUEZ ', 'BOARDM 22.5.7 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-28 16:10:15', '2019-02-04', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32138, '1216714539', 'TIG S.A.S ', 'LAVAMANOS ELECTRONICO V1.2 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 07:22:22', '2019-03-12', '2019-02-07 11:54:32', 0, 0, 3, 0, 0, 1, 1, '2019-01-31', '2019-01-31', NULL, NULL, '', 'A tiempo', NULL),
(32139, '1216714539', 'TIG S.A.S ', 'SANITARIO ELECTRONICO V1.2 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-30 09:26:04', '2019-02-15', '2019-02-13 11:06:44', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32140, '1216714539', 'PAULA ANDREA WHEELER ', 'GERBER ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 09:14:03', '2019-01-31', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32143, '1216714539', 'SOLINTES SAS ', 'OSCILADOR ELECTRONICO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 11:33:12', '2019-02-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32144, '1216714539', 'SOLINTES SAS ', 'GENERADOR DE SE%C3%91ALES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 11:35:20', '2019-02-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32145, '1216714539', 'DUKENET S.A.S ', 'DISPLAY ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 11:41:26', '2019-02-05', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32147, '1216714539', 'JAIME ALEJANDRO ALVAREZ VALENCIA ', ' DIVISOR 8 BITS ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 16:20:36', '2019-02-01', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32148, '1216714539', 'DANIEL DUARTE PUERTA ', 'RESET SENSOR PRESION ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 16:56:34', '2019-02-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32149, '1216714539', 'MICHAEL CANU ', 'PAPILLON 2019 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:05:31', '2019-02-07', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32150, '1216714539', 'STARTCHIP ', 'STC PC8 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:10:34', '2019-02-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32151, '1216714539', 'STARTCHIP ', 'STC PC8 1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:13:24', '2019-02-07', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32152, '1216714539', 'STARTCHIP ', 'STC PC8 3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:18:57', '2019-02-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32153, '1216714539', 'STARTCHIP ', 'STC PC9 1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:21:07', '2019-02-06', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32154, '1216714539', 'JOSE ARBEY SANCHEZ BETANCUR ', 'LED 1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:21:21', '2019-02-05', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32155, '1216714539', 'JOSE ARBEY SANCHEZ BETANCUR ', 'LED 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-29 17:22:05', '2019-02-05', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32157, '1216714539', 'SOLUCIONES WIGA S.A.S ', 'ENSAMBLE 100 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-30 09:53:03', '2019-02-13', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32158, '1216714539', 'INTEGRALDESIGNCM S.A.S ', 'PROY1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-30 09:26:39', '2019-02-06', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32160, '1216714539', 'LINARQ SAS ', 'CENTRAL_V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-30 12:22:36', '2019-02-08', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32161, '1216714539', 'TAXIMETROS GEORGE ', 'TERMOCAR3DIG_VEL_COOLER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-30 13:55:56', '2019-02-20', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32163, '1216714539', 'INSSA S.A.S ', 'NEW PCB ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-30 15:38:11', '2019-01-31', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32164, '1216714539', 'OLGA MARIA SERNA VILLA ', 'AUTODIALING2019 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-30 17:31:13', '2019-02-13', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32166, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', 'MASTER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 12:17:42', '2019-02-07', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32169, '1216714539', 'SOPORTE Y LOGISTICA S.A.S ', 'COORDINADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 14:24:59', '2019-02-07', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32170, '1216714539', 'SOPORTE Y LOGISTICA S.A.S ', 'ROUTER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 14:28:26', '2019-02-13', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32171, '1216714539', 'ENERGESIS NATURA S.A.S ', 'APERTURAS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 15:14:09', '2019-02-07', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32173, '1216714539', 'ALVARO ANDRES GUZMAN CASTA%C3%91EDA ', 'CONTROLADORA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 16:31:14', '2019-02-26', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32174, '1216714539', 'INTELLIGENT ELECTRONIC SOLUTIONS S.A.S ', 'BACKPLAINE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-01-31 16:39:07', '2019-02-06', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32177, '1216714539', 'COMERCIALIZADORA BECOR S.A. ', 'NANO SENSOR SMD ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-20 16:28:41', '2019-03-05', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-19', '2019-02-28', NULL, NULL, NULL, 'A tiempo', NULL),
(32178, '1216714539', 'DERY DEICY RESTREPO MESA ', 'CIOT_TERMOCONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-01 12:29:06', '2019-02-12', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32179, '1216714539', 'OPTEC POWER SAS ', 'TD48A25TP_PZ_V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-01 12:41:17', '2019-02-14', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32180, '1216714539', 'UNIVERSIDAD EAFIT ', 'PRECOR AUDIO BD ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-01 15:22:44', '2019-02-26', '2019-02-13 11:13:29', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32181, '1216714539', 'SOLE SOLUCIONES EMPRESARIALES LTDA ', 'TELEMETRIA REFRIGERACI%C3%93N ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-01 15:28:06', '2019-02-08', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32182, '1216714539', 'SOLE SOLUCIONES EMPRESARIALES LTDA ', 'TELEMETRIA CALOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-01 15:36:01', '2019-02-08', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32183, '1216714539', 'GROUND ELECTRONICS ', 'CORE B V2.1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-01 16:35:22', '2019-02-08', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32188, '1216714539', 'JULIAN DAVID ARBELAEZ GALLO ', ' TESIS_LISTA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 10:49:17', '2019-02-11', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32189, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MCVF_2S_PW ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 11:46:15', '2019-02-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32190, '1216714539', 'NETBEAM S.A. ', 'MSFM v1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 11:48:32', '2019-02-14', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32192, '1216714539', 'OPTEC POWER SAS ', '25DCV2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 11:58:21', '2019-02-28', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32193, '1216714539', 'HERNANDO GAMA DUARTE ', ' ON DELAY 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 14:35:18', '2019-02-11', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32194, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'LEDRGB ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 14:57:12', '2019-02-07', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32195, '1216714539', 'PMP INGENIERIA ', 'MATRIX RGB PROTO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 15:54:41', '2019-02-11', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32196, '1216714539', 'ANDRES FELIPE CARVAJAL MONTOYA ', ' ELECTRONICA CABINA DE EXTRACCION ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-04 16:50:23', '2019-02-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32199, '1216714539', 'OPTEC POWER SAS ', 'VIBRATOR_V13_110_220 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 10:55:04', '2019-02-18', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32200, '1216714539', 'UNIVERSIDAD EAFIT ', ' ARDUINO LUCHO PRACTICA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:29:26', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32201, '1216714539', 'UNIVERSIDAD EAFIT ', 'TECLADO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:34:32', '2019-02-15', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32202, '1216714539', 'UNIVERSIDAD EAFIT ', 'PULSADORES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:47:33', '2019-02-15', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32203, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'VDR V6 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:28:37', '2019-02-18', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32204, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'BLDCDVRv1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:30:49', '2019-02-12', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32205, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'IIS3DHHCTR_ADP ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:34:20', '2019-02-13', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32206, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'MOD2ROV1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:36:06', '2019-02-14', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32207, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'PCBMODDCMOTDVRV3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:39:59', '2019-02-12', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32208, '1216714539', 'MARTHA LILIANA CASTIBLANCO VARELA ', 'VDR_LBv1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:42:01', '2019-02-14', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32209, '1216714539', 'EVELYN JOHANA TAVERA FIGUEROA ', 'PROYECTO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 15:46:37', '2019-02-15', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32212, '1216714539', 'CELSA S.A.S ', 'PCBA001_7_1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-05 17:27:53', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32214, '1216714539', 'SOLUCIONES WIGA S.A.S ', 'PCBA012_2_1 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 08:39:36', '2019-02-18', NULL, 1, 1, 4, 0, 0, 0, 1, '2019-02-13', '2019-03-13', NULL, NULL, NULL, 'A tiempo', NULL),
(32215, '1216714539', 'SOLUTECNICAS INGENIERIA SAS ', 'BOARDNOLE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 09:57:09', '2019-02-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32216, '1216714539', 'SIOMA SAS ', 'PLACA V6 ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-06 11:14:59', '2019-02-18', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32217, '1216714539', 'SMARTECH INGENIER%C3%8DA SAS ', 'PROYECTO SENSOR DE NIVEL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 12:03:15', '2019-02-13', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32218, '1216714539', 'ATP TRADING SAS ', 'TARJETA AUXILIAR ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 12:04:30', '2019-02-07', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32219, '1216714539', 'DANIEL VELASQUEZ RODRIGUEZ ', 'INVITRO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 17:21:31', '2019-02-13', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32220, '1216714539', 'ANA MARIA TORRES VALENCIA ', 'ESCLAVOS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 17:35:29', '2019-02-18', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32221, '1216714539', 'ANA MARIA TORRES VALENCIA ', ' MAESTRO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 17:46:57', '2019-02-18', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32222, '1216714539', 'ANA MARIA TORRES VALENCIA ', 'USB HEMBRA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 17:49:33', '2019-02-15', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32223, '1216714539', 'ANA MARIA TORRES VALENCIA ', 'USB MACHO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-06 17:51:42', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32224, '1216714539', 'CARLOS ANDRES PANCHANA ', 'DATALOGGER CONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 10:46:05', '2019-02-14', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32225, '1216714539', 'CARLOS ANDRES PANCHANA ', ' DATALOGGER POTENCIA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 10:45:27', '2019-02-14', NULL, 0, 1, 4, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32226, '1216714539', 'SONAR AVL SYSTEM S.A.S ', 'RIO2_T ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 13:03:34', '2019-02-08', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32227, '1216714539', 'ALUTRAFIC LED S.A.S ', 'PANEL MINIDOWN 3030 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 15:41:46', '2019-02-18', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32230, '1216714539', 'DANIEL ANDRES ROJAS PAREDES ', 'lS33202A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 17:08:49', '2019-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32231, '1216714539', 'DANIEL ANDRES ROJAS PAREDES ', ' PC33202VSS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 17:12:55', '2019-02-14', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32236, '1216714539', 'INDUSTRIAS METALICAS LOS PINOS ', '1600000442 PUERTO BLUETOOTH 4.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 17:45:38', '2019-02-18', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32237, '1216714539', 'ERIK DANIEL RAMIREZ CALDERON ', 'MINISUMO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-07 17:14:38', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32240, '1216714539', 'JUAN PABLO RESTREPO URIBE ', 'FINAL ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-08 11:20:06', '2019-02-20', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-15', '2019-02-12', NULL, NULL, NULL, 'A tiempo', NULL),
(32241, '1216714539', 'CRISTIAN GIOVANNY MOLINA HERNANDEZ ', ' PCB ROVER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-08 14:28:57', '2019-02-15', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32242, '1216714539', 'OPTEC POWER SAS ', '100DC - Prueba de desarrollo', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-08 15:26:08', '2019-02-20', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32243, '1216714539', 'CASAS AUTOMATICAS LTDA ', 'CA_SERIAL_RC_8X4 V1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 16:25:45', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32244, '1216714539', 'CASAS AUTOMATICAS LTDA ', 'CA_WIFI_IP_RC_4X4_V1_0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 16:28:57', '2019-02-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32245, '1216714539', 'INADISA ', 'TARJETA PROGRAMADOR USB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 16:36:32', '2019-02-25', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32246, '1216714539', 'TECREA S.A.S ', 'Acople sensor temperatura y humedad Disprolab ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-11 17:08:05', '2019-02-18', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-13', '2019-02-13', NULL, NULL, NULL, 'A tiempo', NULL),
(32247, '1216714539', 'TECREA S.A.S ', 'IBUTTON DISPOSABLE ', 'Normal', 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-11 17:24:49', '2019-03-04', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(32248, '1216714539', 'TECREA S.A.S ', 'CAMA PINCHOS ISQUARED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 17:40:14', '2019-02-15', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32249, '1216714539', 'TECREA S.A.S ', 'CAMA PINCHOS TRACKFOX LORA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 17:48:08', '2019-02-15', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32251, '1216714539', 'MEDENCOL ', ' EQUIPO EVO II 2014 CON MANDO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 17:21:22', '2019-02-20', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32252, '1216714539', 'MEDENCOL ', 'SILLON ELECTRICO EYECTOR INFRAROJO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-11 17:28:30', '2019-02-19', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32255, '1216714539', 'OPTEC POWER SAS ', ' 75TPDUL V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 11:47:41', '2019-02-25', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32256, '1216714539', 'OPTEC POWER SAS ', 'TV48A50 V4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 12:02:56', '2019-02-22', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32260, '1216714539', 'MET INGENIERIA SAS ', 'GPRSControl_V1Estable ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 15:57:44', '2019-02-19', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32261, '1216714539', 'MET INGENIERIA SAS ', 'T_Cam_V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 15:57:59', '2019-02-19', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32262, '1216714539', 'OSWALDO PUERTA TOVAR ', 'TEMP_BAT_OIL_COOLER52 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 16:02:44', '2019-02-26', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32263, '1216714539', 'OSWALDO PUERTA TOVAR ', 'COTIZACI%C3%93N VEL_2DIG_DISPLAY_2019 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 16:05:25', '2019-02-26', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32264, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', 'MEDIDOR ACELERACION ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-12 17:08:29', '2019-02-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32265, '1216714539', 'TECREA S.A.S ', 'TARJETA PRUEBA SENSOR VCNL4040 IBUTTON ANIMAL ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 15:09:46', '2019-02-19', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-14', '2019-02-25', NULL, NULL, NULL, 'A tiempo', NULL),
(32266, '1216714539', 'TAUSAND ELECTRONICA SAS ', 'mimasbnc_v14b ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 16:53:18', '2019-02-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32267, '1216714539', 'TAUSAND ELECTRONICA SAS ', ' UIPANELUC_V1.10 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 16:56:32', '2019-02-22', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32268, '1216714539', 'INNOVATIVE SOLUTIONS GROUP SAS ', 'CB_TECLADO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 17:03:15', '2019-02-25', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32269, '1216714539', 'INNOVATIVE SOLUTIONS GROUP SAS ', 'CB_CONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 17:06:37', '2019-02-26', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32270, '1216714539', 'TECREA S.A.S ', 'ILIGHT SUPPLY LAYER ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-13 17:26:02', '2019-02-19', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-14', '2019-02-25', NULL, NULL, NULL, 'A tiempo', NULL),
(32273, '1216714539', 'MIGUEL EDUARDO CARRE%C3%91O ', 'CONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 14:25:13', '2019-02-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32275, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', ' LUXOMETRO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 15:31:12', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32276, '1216714539', 'OPTEC POWER SAS ', 'OPi48BF65BP V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 16:01:51', '2019-02-27', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32277, '1216714539', 'TECREA S.A.S ', 'ACOPLE GPS DISPROLAB ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 17:26:10', '2019-02-18', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-14', '2019-02-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32278, '1216714539', 'GROUND ELECTRONICS S.A.S ', 'GSM USB SD V1.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 17:32:44', '2019-02-21', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32279, '1216714539', 'DAVID ALEXANDER SADOVNIK ', ' PROJECT OUTPUTS FOR KPROJ_PCBV2 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 09:44:29', '2019-02-27', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-22', '2019-02-19', NULL, NULL, NULL, 'A tiempo', NULL),
(32280, '1216714539', 'WENDY PATRICIA HERNANDEZ ACOSTA ', 'FILTRO DE FLUIDO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 09:48:12', '2019-02-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32281, '1216714539', 'DANIEL DUARTE PUERTA ', 'Lector_7seg_serial_v5_485 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 11:23:30', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32283, '1216714539', 'CARLOS JOSE MEDINA GINER ', 'PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 13:14:21', '2019-02-22', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32285, '1216714539', 'BIOINNOVA S.A.S ', 'ALARMA TFT V 2.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 14:51:13', '2019-02-26', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32286, '1216714539', 'MAD INGENIEROS LTDA ', 'CXD V 3.2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 17:00:46', '2019-02-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32287, '1216714539', 'DOMETAL ', '8200 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-02-15 17:05:27', '2019-03-18', NULL, 1, 1, 4, 1, 1, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32288, '1216714539', 'DOMETAL ', '7904 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-02-15 17:09:09', '2019-03-18', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32289, '1216714539', 'DOMETAL ', '8996 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 17:13:28', '2019-03-11', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32291, '1216714539', 'DOMETAL ', '8198 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-02-15 17:25:09', '2019-03-18', NULL, 1, 1, 4, 1, 1, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32292, '1216714539', 'TECREA S.A.S ', 'LAP CAMKIT MAIN ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 07:13:05', '2019-03-04', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-02-23', NULL, NULL, NULL, 'A tiempo', NULL),
(32293, '1216714539', 'ALUTRAFIC LED S.A.S ', 'AT HORT REG 2835 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 07:11:00', '2019-02-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32294, '1216714539', 'LUISA FERNANDA VELASQUEZ ECHEVERRI / SMARTEAM ', ' CONTADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 11:51:42', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32295, '1216714539', 'COINS S.A.S ', 'ARCO DE LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 11:59:03', '2019-03-04', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32296, '1216714539', 'PEDRO MANUEL CASTRO DAVID ', 'PCB THS4531 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 12:35:44', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32297, '1216714539', 'MICRO HOM S.A.S ', 'ARRANQUE V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 14:34:25', '2019-03-01', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32298, '1216714539', 'SIOMA SAS ', ' PLACA V5 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 15:40:21', '2019-02-22', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32299, '1216714539', 'BIOINNOVA S.A.S ', 'FRONT END TRANSDUCTORE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 15:46:11', '2019-02-27', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32300, '1216714539', 'ETEC S.A. ', 'TEMPORIZADOR DE RETARDO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 16:35:24', '2019-03-04', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-03-07', NULL, NULL, NULL, 'A tiempo', NULL),
(32301, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MCVF_TX_24_IN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 16:46:14', '2019-02-22', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32302, '1216714539', 'GRUPO ACUAMATIC S.A.S ', 'acuaboardesp32 DEVKITC eagle 7_2019 02 18 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 10:41:47', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32303, '1216714539', 'ATP TRADING SAS ', 'Det_Ind_1302 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 10:42:37', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32306, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', 'TOKEN A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 08:37:23', '2019-03-05', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32307, '1216714539', 'FABIO LEON USUGA ROJO ', 'CARGADOR CONMUTADO ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 10:03:42', '2019-02-20', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32309, '1216714539', 'TECREA S.A.S ', 'LAP CAMKIT   LOWER ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 15:00:26', '2019-03-01', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-02-23', NULL, NULL, NULL, 'A tiempo', NULL),
(32310, '1216714539', 'OPTEC POWER SAS ', 'D24A40BP PZ V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 14:11:50', '2019-03-01', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32311, '1216714539', 'INDUSTRIAS LEO S.A ', 'PLAQUETA 534 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 16:17:27', '2019-02-25', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32312, '1216714539', 'SEBASTIAN JIMENEZ GOMEZ ', ' ODIN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 08:02:39', '2019-02-27', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32313, '1216714539', 'HERNANDO GAMA DUARTE ', 'EXTINTOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 12:00:13', '2019-02-27', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32314, '1216714539', 'RPM INGENIEROS S.A.S ', 'BASE PMR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 14:44:59', '2019-02-28', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32315, '1216714539', 'CARLOS JAVIER MOJICA CASILLAS ', 'LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 14:45:27', '2019-02-27', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32316, '1216714539', 'ARDOBOT ROBOTICA S.A.S ', 'CORE ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 16:45:11', '2019-03-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32317, '1216714539', 'POLITECNICO COLOMBIANO JIC ', 'FUENTE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 17:15:35', '2019-03-04', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32318, '1216714539', 'TECREA S.A.S ', 'SX3 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-20 17:25:29', '2019-03-19', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-11', '2019-03-20', NULL, NULL, NULL, 'A tiempo', NULL),
(32319, '1216714539', 'LYA ELECTRONICS ', 'UWIGO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-20 17:31:47', '2019-03-14', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-11', '2019-03-08', NULL, NULL, NULL, 'A tiempo', NULL),
(32321, '98765201', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 2', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-21 09:00:12', '2019-03-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32322, '98765201', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 2', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-21 09:13:35', '2019-03-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32323, '981130', 'Juan David Marulanda', 'Prueba de desarrollo', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-22 12:43:06', '2019-02-01', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32324, '981130', 'Juan David MArulanda P', 'Prueba de registro de procesos predeterminados para los productos de FE', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-23 08:30:03', '2019-02-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32325, '981130', 'Juan David Marulanda Paniagua', 'Prueba de registro de procesos de proyecto de productos de FE numero 2', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-23 08:33:30', '2019-02-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32326, '981130', 'Juan david Marualnda Paniagua', 'Prueba de desarrollo numero 3', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-23 08:37:56', '2019-02-12', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32327, '981130', 'Juan david marulanda paniagua', 'prueba de desarrollo numero 4', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-23 08:41:08', '2019-02-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32328, '981130', 'juan david marulanda', 'prueba de desarrollo numero 5', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-23 08:49:17', '2019-02-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32329, '981130', 'juan david marulanda paniagua', 'prueba de desarrollo numero 6', 'RQT', 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, '2019-02-23 09:17:28', '2019-02-15', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32330, '981130', 'juan david marulanda', 'prueba de desarrollo numero 8', 'Normal', 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, '2019-02-25 10:40:57', '2019-02-01', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
('1020479554', 'CC', 'Sebastian', 'Gallego Perez', 3, NULL, 1, '1020479554', 1, '6wjnnjg5a-'),
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
('98113053240', 'CC', 'Juan david', 'Marulanda Paniagua', 2, '', 1, '98113053240', 1, 'ue2282qgo1'),
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
('1017156424', 'COM5', NULL, 0),
('981130', 'COM5', '\\\\servidor\\Proyectos2\\3 - QR\\', 0),
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
  MODIFY `idalmacen` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

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
  MODIFY `idCondicion` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=321;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=335;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `procesos`
--
ALTER TABLE `procesos`
  MODIFY `idproceso` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `procesos_producto`
--
ALTER TABLE `procesos_producto`
  MODIFY `idProceso_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32331;

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
