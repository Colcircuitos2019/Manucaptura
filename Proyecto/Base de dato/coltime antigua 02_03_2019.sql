-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-03-2019 a las 17:47:04
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ActualizarProductoPorMinuto` (IN `detalle` INT, IN `negocio` INT, IN `lector` INT, IN `tiempo` VARCHAR(20))  NO SQL
BEGIN
IF negocio=1 THEN

UPDATE detalle_formato_estandar d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;

ELSE
 IF negocio=2 THEN
  
 UPDATE detalle_teclados d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;
 
 ELSE
  
 UPDATE detalle_ensamble d SET d.tiempo_por_unidad=tiempo WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector;
 
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

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_formato_estandar f SET  f.hora_terminacion=now() WHERE f.idDetalle_formato_estandar=id;

SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia,TIMESTAMPDIFF(MINUTE,f.hora_ejecucion,f.hora_terminacion) AS diferencia2 from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;


ELSE
 IF busqueda=2 THEN
 
SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_teclados f SET  f.hora_terminacion=now() WHERE f.idDetalle_teclados=id;

SELECT f.tiempo_total_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;

 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_ensamble f SET  f.hora_terminacion=now() WHERE f.idDetalle_ensamble=id;
  
  SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s') as diferencia from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;
  
  END IF;
 
 END IF;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoDeProductos` (IN `negocio` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE iniciar int;
DECLARE pausar int;
DECLARE terminar int;
DECLARE ejecucion int;
SET iniciar=(SELECT d.pro_porIniciar FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET pausar=(SELECT d.pro_Pausado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET ejecucion=(SELECT d.pro_Ejecucion FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);
SET terminar=(SELECT d.pro_Terminado FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

IF negocio=1 OR negocio=4 THEN 

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=1 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF ejecucion>=1 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=4 WHERE d.idDetalle_proyecto=detalle;
 ELSE
   IF pausar!=0 and ejecucion=0 and (terminar=0 or terminar!=0) THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle; 
  ELSE
   IF pausar=0 and ejecucion=0 and terminar!=0 AND iniciar!=0 THEN
   UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle;
   ELSE
        IF (iniciar+pausar+ejecucion+terminar)=terminar AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=3,d.fecha_salida=(SELECT now()) WHERE d.idDetalle_proyecto=detalle;  
    END IF;
   END IF;
  END IF;
 END IF;
END IF;  
 

ELSE
 IF negocio=2 OR negocio=3 THEN

  IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminar=0 THEN
  UPDATE detalle_proyecto d SET d.estado_idestado=1 WHERE d.idDetalle_proyecto=detalle;
  END IF;


IF ejecucion >= 1  THEN
UPDATE detalle_proyecto d SET d.estado_idestado=4 WHERE d.idDetalle_proyecto=detalle;
ELSE
 IF pausar!=0 and ejecucion=0 and (terminar!=0 or terminar=0) THEN
    UPDATE detalle_proyecto d SET d.estado_idestado=2 WHERE d.idDetalle_proyecto=detalle;
 ELSE
  IF terminar!=0 AND ejecucion=0 AND pausar=0 THEN
        CALL PA_CambiarEstadoTerminadoTEIN(negocio,detalle);
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

SET iniciar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=1);
SET pausar=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=2);
SET terminado=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=3);
SET ejecucion=(SELECT COUNT(*) FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.estado_idestado=4);
SET fecha=(SELECT p.NFEE FROM proyecto p WHERE p.numero_orden=orden);
SET estado=(SELECT p.estadoEmpresa FROM proyecto p WHERE p.numero_orden=orden);

IF estado IS null OR (estado !='Retraso' AND estado !='A tiempo') THEN
   UPDATE proyecto p SET p.estadoEmpresa='A tiempo' WHERE p.numero_orden = orden;
END IF;

IF iniciar!=0 AND pausar=0 AND ejecucion=0 and terminado=0 THEN
  UPDATE proyecto p SET p.estado_idestado=1, p.fecha_salidal=null WHERE p.numero_orden = orden;
	UPDATE proyecto p SET p.estadoEmpresa=null WHERE p.numero_orden = orden;
ELSE
 IF ejecucion>=1 THEN
  UPDATE proyecto p SET p.estado_idestado=4, p.fecha_salidal=null WHERE p.numero_orden = orden;

 ELSE
   IF pausar!=0 and ejecucion=0 and (terminado=0 or terminado!=0) THEN
  UPDATE proyecto p SET p.estado_idestado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

  ELSE
   IF pausar=0 and ejecucion=0 and terminado!=0 AND iniciar!=0 THEN
   UPDATE proyecto p SET p.estado_idestado=2, p.fecha_salidal=null WHERE p.numero_orden = orden; 

   ELSE
        IF (iniciar+pausar+ejecucion+terminado)=terminado AND iniciar=0 AND pausar=0 and ejecucion=0 THEN
  	UPDATE proyecto p SET p.estado_idestado=3, p.fecha_salidal=(SELECT NOW()) WHERE p.numero_orden = orden; 

    END IF;
   END IF;
  END IF;
 END IF;
END IF; 


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CambiarEstadoTerminadoTEIN` (IN `negocio` INT, IN `detalle` INT)  NO SQL
BEGIN
DECLARE res boolean;
IF negocio=2 THEN
  IF EXISTS(SELECT d.estado_idestado FROM detalle_teclados d where    d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=14 AND d.estado_idestado=3) THEN#El 14 es el proceso

 SET res= true;
 
 ELSE 

 SET res = false;

 END IF;

ELSE 
  IF negocio=3 THEN
 IF EXISTS(SELECT d.estado_idestado FROM detalle_ensamble d where    d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=18 AND d.estado_idestado=3) THEN#El 18 ese el proceso

 SET res= true;
 
 ELSE 

 SET res = false;
  
  END IF;
  
 END IF;
END IF;


IF res THEN

 UPDATE detalle_proyecto p SET p.estado_idestado=3,p.fecha_salida=(SELECT now())  where p.idDetalle_proyecto=detalle;
ELSE
  UPDATE detalle_proyecto p SET p.estado_idestado=2 where p.idDetalle_proyecto=detalle;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosEjecucion` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado_idestado=4 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosIngresadosArea` ()  NO SQL
BEGIN

SELECT COUNT(dp.idDetalle_proyecto) as catidadIngresada ,dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(p.fecha_ingreso,'%Y -%m -%d')=DATE_FORMAT(CURDATE(),'%Y -%m -%d')  and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosPorIniciar` ()  NO SQL
BEGIN

SELECT COUNT(*),dp.negocio_idnegocio FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dp.estado_idestado=1 AND dp.PNC=0 and p.eliminacion=1 GROUP BY dp.negocio_idnegocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadProyectosterminadosHoy` ()  NO SQL
BEGIN
DECLARE FE INT;
DECLARE TE INT;
DECLARE EN INT;
DECLARE AL INT;

SET FE =(SELECT COUNT(*) FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(df.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND df.Procesos_idproceso=10 AND dp.estado_idestado=3 AND df.estado_idestado=3 and p.eliminacion=1);

SET TE =(SELECT COUNT(*) FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(dt.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dt.Procesos_idproceso=14 AND dp.estado_idestado=3 AND dt.estado_idestado=3 and p.eliminacion=1);

SET EN =(SELECT COUNT(*) FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND de.Procesos_idproceso=18 AND dp.estado_idestado=3 AND de.estado_idestado=3 and p.eliminacion=1);

SET AL =(SELECT COUNT(*) FROM almacen de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE DATE_FORMAT(de.fecha_fin,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND dp.estado_idestado=3 AND de.estado_idestado=3 and p.eliminacion=1);

SELECT FE,TE,EN,AL;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CantidadUnidadesProyecto` (IN `orden` INT)  NO SQL
BEGIN
DECLARE total int;

SET total=(SELECT SUM(sp.canitadad_total) FROM detalle_proyecto sp WHERE sp.proyecto_numero_orden=orden AND sp.negocio_idnegocio!=4);

SELECT total;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetalleProyecto` (IN `orden` INT(11), IN `estado` INT)  NO SQL
BEGIN

IF estado=0 THEN
SELECT d.idDetalle_proyecto,n.nom_negocio,t.nombre,d.canitadad_total,e.nombre as estado, d.PNC,d.ubicacion,d.material,p.parada FROM tipo_negocio t  JOIN detalle_proyecto d on t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN negocio n on d.negocio_idnegocio=n.idnegocio JOIN estado e on d.estado_idestado=e.idestado JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden;
ELSE
SELECT d.idDetalle_proyecto,n.nom_negocio,t.nombre,d.canitadad_total,e.nombre as estado, d.PNC,d.ubicacion,d.material,p.parada FROM tipo_negocio t  JOIN detalle_proyecto d on t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN negocio n on d.negocio_idnegocio=n.idnegocio JOIN estado e on d.estado_idestado=e.idestado JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE d.proyecto_numero_orden=orden and p.eliminacion=1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarDetallesProyectosProduccion` (IN `area` INT, IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN
 #Estados del proyecto solo numero 1
SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=1;

ELSE
 IF op=3 THEN
#Estados del proyecto numero 3
SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND DATE_FORMAT(d.fecha_salida,'%Y-%m-%d')=DATE_FORMAT(CURRENT_DATE,'%Y-%m-%d') AND d.PNC=0 AND p.eliminacion=1;

 ELSE
  IF op=2 THEN
  #Esados del proyecto solo numero 2
 SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=2;
  ELSE
   #Esados del proyecto solo numero 4
 SELECT d.proyecto_numero_orden,t.nombre,d.estado_idestado,p.tipo_proyecto FROM tipo_negocio t JOIN detalle_proyecto d ON t.idtipo_negocio=d.tipo_negocio_idtipo_negocio JOIN proyecto p ON p.numero_orden=d.proyecto_numero_orden WHERE d.negocio_idnegocio=area AND d.PNC=0 AND p.eliminacion=1 AND d.estado_idestado=4;
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

SELECT p.idproceso FROM procesos p WHERE p.negocio_idnegocio=area and p.estado=1; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarImagenUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.imagen from usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarIndormacionQR` (IN `orden` INT)  NO SQL
BEGIN
select p.idDetalle_proyecto,d.idDetalle_formato_estandar,d.Procesos_idproceso from detalle_proyecto p INNER JOIN detalle_formato_estandar d ON p.idDetalle_proyecto=d.detalle_proyecto_idDetalle_proyecto where p.proyecto_numero_orden=orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarNumeroOrden` ()  NO SQL
SHOW TABLE STATUS like 'proyecto'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesoProductoEnsamble` (IN `idDetalle` INT)  NO SQL
BEGIN
#se encarga de consultar los proceso de ensamble en el orden que se les asigno la ejecución por el detalle del producto del proyecto.
SELECT e.idDetalle_ensamble,e.Procesos_idproceso,e.orden,e.cantidad_terminada,e.restantes FROM detalle_ensamble e WHERE e.detalle_proyecto_idDetalle_proyecto=idDetalle AND e.orden>0 ORDER BY e.orden ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesos` (IN `area` INT)  NO SQL
BEGIN

IF area=0 THEN
#Consultar todos los procesos en general
SELECT * FROM procesos p ORDER BY p.idproceso ASC;
ELSE
SELECT p.nombre_proceso FROM procesos p WHERE p.negocio_idnegocio=area ORDER BY p.idproceso ASC;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesosFE` (IN `detalle` INT)  NO SQL
begin

SELECT p.nombre_proceso FROM detalle_formato_estandar f JOIN procesos p on f.Procesos_idproceso=p.idproceso WHERE f.detalle_proyecto_idDetalle_proyecto=detalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarPRocesosReporteENoTE` (IN `op` INT)  NO SQL
BEGIN
#Ensamble=3; teclados=2
#...
SELECT * FROM procesos WHERE negocio_idnegocio=op AND estado=1;
#...
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEliminados` ()  NO SQL
BEGIN

SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=0;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProyectosEntrega` (IN `orden` INT, IN `nombreC` VARCHAR(45), IN `nombreP` VARCHAR(45), IN `fecha` VARCHAR(10))  NO SQL
BEGIN

IF orden='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteo,p.antisolder,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') and 
p.eliminacion=1;
              ELSE 
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_entrega,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1; 
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.eliminacion=1;
ELSE
  IF orden!='' and nombreC='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.eliminacion=1;
  ELSE 
    IF orden='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
    ELSE
      IF orden='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
       ELSE
         IF orden!='' and nombreC!='' and nombreP='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.eliminacion=1;
	      ELSE
            IF orden='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
            ELSE
              IF orden!='' and nombreC='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
              ELSE
                IF orden!='' and nombreC!='' and nombreP!='' and fecha='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND p.eliminacion=1;
                ELSE
                  IF orden='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
				  ELSE
                    IF orden!='' and nombreC='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
 					ELSE
                      IF orden='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                     					  ELSE
					     IF orden='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                          ELSE
                            IF orden!='' and nombreC!='' and nombreP='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
						     ELSE
                               IF orden!='' and nombreC='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_proyecto LIKE concat(nombreP,'%') AND p.numero_orden LIKE concat(orden,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;  
                               ELSE
                                 IF orden='' and nombreC!='' and nombreP!='' and fecha!='' THEN
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;
                                 ELSE
                                   IF orden!='' and nombreC!='' and nombreP!='' and fecha!='' THEN 
SELECT p.numero_orden,u.nombres,p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y %h:%i %p') as     ingreso,p.fecha_entrega,DATE_FORMAT(p.fecha_salidal,'%d-%M-%Y %h:%i %p') as salida,e.nombre,p.tipo_proyecto,p.FE,p.TE,p.IN,p.ruteoC,p.antisolderC,p.ruteoP,p.antisolderP,p.parada,p.entregaCircuitoFEoGF,p.entregaCOMCircuito,p.entregaPCBFEoGF,p.entregaPCBCom,p.novedades,p.estadoEmpresa,p.NFEE FROM usuario u JOIN proyecto p ON u.numero_documento=p.usuario_numero_documento LEFT JOIN estado e on p.estado_idestado=e.idestado WHERE p.numero_orden LIKE concat(orden,'%') AND p.nombre_cliente LIKE concat(nombreC,'%') AND p.nombre_proyecto LIKE concat(nombreP,'%') AND DATE_FORMAT(p.fecha_salidal,'%Y-%m-%d')=fecha AND p.eliminacion=1;                                   
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDelDetalleDelproyecto` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') as inicio,Date_format(f.fecha_fin,'%d-%M-%Y') as fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre as estado,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') as "hora terminacion",TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%S') as InicioTerminadoIntervalo,f.idDetalle_formato_estandar,f.restantes,f.noperarios FROM detalle_formato_estandar f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
ELSE
  IF negocio=2 THEN
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_teclados,f.restantes,f.noperarios FROM detalle_teclados f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
  ELSE
   IF negocio=3 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(now(),f.hora_ejecucion),'%H:%i:%S') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_ensamble,f.noperarios,f.noperarios,CONVERT(f.orden, int),f.idDetalle_ensamble,f.cantidadProceso FROM detalle_ensamble f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
   ELSE
    IF negocio=4 THEN
    SELECT p.nombre_proceso,Date_Format(al.fecha_inicio,'%d-%M-%Y'),Date_format(al.fecha_fin,'%d-%M-%Y'),al.cantidad_recibida,al.tiempo_total_proceso,al.tiempo_total_proceso,e.nombre,TIME_FORMAT(al.hora_registro,'%r'),datediff(CURRENT_DATE,al.fecha_inicio) as dias,TIME_FORMAT(al.hora_llegada,'%r'),datediff(al.fecha_fin,al.fecha_inicio),al.idalmacen FROM almacen al JOIN procesos p on al.Procesos_idproceso=p.idproceso JOIN estado e on al.estado_idestado=e.idestado where al.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY al.Procesos_idproceso ASC;
    END IF;
   END IF;
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion=ubic));

END IF;


UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_ensamble) FROM detalle_ensamble e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(3,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeLosProcesosDeTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(50))  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion=ubic));

END IF;

UPDATE detalle_proyecto SET pro_porIniciar=(SELECT COUNT(e.idDetalle_teclados) FROM detalle_teclados e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle) WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(2,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleDeProduccionProyectosActivos` (IN `orden` INT, IN `negocio` INT, IN `pnc` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden and d.negocio_idnegocio=negocio AND d.PNC=pnc AND d.estado_idestado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetalleProyectosProduccion` (IN `orden` INT, IN `negocio` INT, IN `pnc` INT)  NO SQL
BEGIN
IF negocio >=1 AND negocio <=4 THEN
SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden and d.negocio_idnegocio=negocio AND d.PNC=pnc;

ELSE
SELECT d.idDetalle_proyecto,t.nombre,d.estado_idestado,d.negocio_idnegocio  FROM detalle_proyecto d JOIN tipo_negocio t on d.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE d.proyecto_numero_orden=orden AND d.PNC=pnc;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesEnEjecucion` (IN `orden` INT, IN `estado` INT)  NO SQL
BEGIN

IF estado=4 THEN
SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=estado;


ELSE

SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=estado AND dp.negocio_idnegocio=4;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DetallesparaValidarEstado` (IN `orden` INT)  NO SQL
BEGIN

SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden; 

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_DiagramaFETEEN` (IN `op` INT)  NO SQL
BEGIN

IF op=1 THEN

SELECT df.Procesos_idproceso,COUNT(*),df.estado_idestado FROM detalle_formato_estandar df JOIN detalle_proyecto dp ON df.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE df.estado_idestado!=3 AND p.eliminacion=1 GROUP BY df.Procesos_idproceso,df.estado_idestado ORDER BY df.Procesos_idproceso ASC;

ELSE

IF op=2 THEN
SELECT dt.Procesos_idproceso,COUNT(*),dt.estado_idestado FROM detalle_teclados dt JOIN detalle_proyecto dp ON dt.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE dt.estado_idestado!=3 AND p.eliminacion=1 AND dp.estado_idestado!=3 GROUP BY dt.Procesos_idproceso,dt.estado_idestado ORDER BY dt.Procesos_idproceso ASC;

END IF;
SELECT de.Procesos_idproceso,COUNT(*),de.estado_idestado FROM detalle_ensamble de JOIN detalle_proyecto dp ON de.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden WHERE de.estado_idestado!=3 AND dp.estado_idestado!=3 AND p.eliminacion=1 GROUP BY de.Procesos_idproceso,de.estado_idestado ORDER BY de.Procesos_idproceso ASC;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Diagramas` (IN `inicio` VARCHAR(11), IN `fin` VARCHAR(11))  NO SQL
BEGIN

IF inicio='' AND fin='' THEN
SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 GROUP BY d.negocio_idnegocio;
ELSE
 IF inicio!='' AND fin='' THEN
  SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y')= DATE_FORMAT(inicio,'%d-%M-%Y') GROUP BY d.negocio_idnegocio;
 ELSE
  IF inicio!='' AND fin!='' THEN
  SELECT COUNT(*),d.negocio_idnegocio FROM detalle_proyecto d JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE p.eliminacion=1 AND DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') BETWEEN DATE_FORMAT(inicio,'%d-%M-%Y') AND DATE_FORMAT(fin,'%d-%M-%Y')  GROUP BY d.negocio_idnegocio; 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_EliminarProductosNoConformes` (IN `orden` INT, IN `tipo` INT, IN `negocio` INT)  NO SQL
BEGIN

SELECT d.idDetalle_proyecto FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden AND d.tipo_negocio_idtipo_negocio=tipo AND d.negocio_idnegocio=negocio;

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

SELECT  DATE_FORMAT(CURDATE(),'%d-%M-%Y') as fecha,COUNT(*) as cantidad,cantidadP,d.negocio_idnegocio FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden WHERE d.PNC=0 AND p.eliminacion=1 GROUP BY d.negocio_idnegocio ORDER BY d.negocio_idnegocio ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionFiltrariaDetalleProyecto` (IN `iddetalle` INT)  NO SQL
BEGIN

SELECT p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') as fechaIngreso,DATE_FORMAT(p.fecha_entrega,'%d-%M-%Y')AS fechaEntrega,dp.canitadad_total,dp.tiempo_total,dp.Total_timepo_Unidad,DATE_FORMAT(p.entregaCircuitoFEoGF,'%d-%M-%Y') AS fecha1,DATE_FORMAT(p.entregaCOMCircuito,'%d-%M-%Y') AS fecha2,DATE_FORMAT(p.entregaPCBFEoGF,'%d-%M-%Y') AS fecha3,DATE_FORMAT(p.entregaPCBCom,'%d-%M-%Y') AS fecha4,dp.lider_proyecto FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden WHERE dp.idDetalle_proyecto=iddetalle;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformacionProyectosProduccion` (IN `negocio` INT, IN `orden` INT, IN `clien` VARCHAR(40), IN `proyecto` VARCHAR(40), IN `tipo` VARCHAR(6))  NO SQL
BEGIN

IF orden=0 AND clien='' AND proyecto='' AND tipo='' THEN
  SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) and p.eliminacion=1;
ELSE
 IF orden!=0 AND clien='' AND proyecto='' AND tipo='' THEN
 	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT join proyecto p ON p.numero_orden=d.proyecto_numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') and p.eliminacion=1;
 ELSE
  IF orden=0 AND clien!='' AND proyecto='' AND tipo='' THEN
SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where  ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) and p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
  ELSE
   IF orden=0 AND clien='' AND proyecto!='' AND tipo='' THEN
   	  SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
   ELSE
    IF orden=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.tipo_proyecto=tipo and p.eliminacion=1;
    ELSE
     IF orden!=0 AND clien!='' AND proyecto='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
     ELSE 
      IF orden!=0 AND clien='' AND proyecto!='' AND tipo='' THEN
        SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
      ELSE
       IF orden!=0 AND clien='' AND proyecto='' AND tipo!='' THEN
       	 SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
       ELSE
        IF orden=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
          SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') and p.eliminacion=1;
        ELSE
         IF orden=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_cliente LIKE      CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo and p.eliminacion=1;
         ELSE
          IF orden=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
            SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.nombre_proyecto LIKE    CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
          ELSE
           IF orden!=0 AND clien!='' AND proyecto!='' AND tipo='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') AND p.eliminacion=1;
           ELSE
            IF orden=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
             SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND p.tipo_proyecto=tipo AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.nombre_cliente LIKE CONCAT('%',clien,'%') and p.eliminacion=1;
            ELSE
             IF orden!=0 AND clien='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_proyecto LIKE CONCAT(proyecto,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
             ELSE
              IF orden!=0 AND clien!='' AND proyecto='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
CONCAT('%',clien,'%') AND p.tipo_proyecto=tipo AND p.eliminacion=1;
              ELSE
               IF orden!=0 AND clien!='' AND proyecto!='' AND tipo!='' THEN
           SELECT DISTINCT(d.proyecto_numero_orden),p.estado_idestado,p.tipo_proyecto,p.parada FROM detalle_proyecto d RIGHT JOIN proyecto p on 
d.proyecto_numero_orden=p.numero_orden where ((p.fecha_salidal is null) and (DATEDIFF(CURRENT_DATE,p.fecha_salidal)<=0 or DATEDIFF(CURRENT_DATE,p.fecha_salidal)is null) and d.negocio_idnegocio=negocio AND (d.estado_idestado=1 or d.estado_idestado=2 OR d.estado_idestado=4)) AND d.proyecto_numero_orden LIKE CONCAT(orden,'%') AND p.nombre_cliente LIKE 
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
SELECT d.idDetalle_proyecto,d.tipo_negocio_idtipo_negocio,d.negocio_idnegocio,DATE_FORMAT(p.fecha_entrega,'%d-%m-%Y'),p.nombre_proyecto,d.canitadad_total,d.material from proyecto p JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN tipo_negocio t ON d.tipo_negocio_idtipo_negocio=t.idtipo_negocio where d.proyecto_numero_orden=orden and d.PNC=0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionEN` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(de.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND de.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(de.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND de.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionFE` (IN `orden` INT)  NO SQL
BEGIN


IF orden= 0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(df.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND df.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(df.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND df.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeDeProduccionTE` (IN `orden` INT)  NO SQL
BEGIN

IF orden=0 THEN
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(dt.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND dt.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

ELSE
SELECT dp.proyecto_numero_orden,n.nom_negocio,tn.nombre,MAX(dt.Procesos_idproceso) AS proceso,DATEDIFF(p.fecha_entrega,CURRENT_DATE) AS dias,dp.estado_idestado FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto JOIN negocio n ON dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio tn ON dp.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE dp.proyecto_numero_orden LIKE CONCAT(orden,'%') AND dp.PNC=0 AND p.estado_idestado!=3 AND p.eliminacion=1 AND dt.estado_idestado!=1 GROUP BY dp.proyecto_numero_orden, dp.tipo_negocio_idtipo_negocio;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeFinalColtime` ()  NO SQL
BEGIN

SELECT p.numero_orden AS orden,p.nombre_cliente AS cliente,dp.idDetalle_proyecto AS proyecto,dp.tipo_negocio_idtipo_negocio AS producto,p.fecha_ingreso AS ingreso,p.fecha_entrega AS entrega,dp.estado_idestado AS estadoDetalle,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeGeneralColtime` ()  NO SQL
BEGIN

#SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.negocio_idnegocio AS negocio,DATE_FORMAT(p.fecha_ingreso,'%Y-%m-%d') AS ingreso,p.fecha_entrega AS entrega,p.estadoEmpresa AS subEstado,p.NFEE AS NFEE,dp.estado_idestado AS estadoDetalle,dp.tipo_negocio_idtipo_negocio AS tipoNegocio,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto;

SELECT p.numero_orden AS orden,p.parada AS parada,p.nombre_cliente AS cliente,p.nombre_proyecto AS proyecto,dp.idDetalle_proyecto AS proyecto,dp.negocio_idnegocio AS negocio,DATE_FORMAT(p.fecha_ingreso,'%d/%m/%Y') AS ingreso,DATE_FORMAT(p.fecha_entrega,'%d/%m/%Y') AS entrega,p.estadoEmpresa AS subEstado,DATE_FORMAT(p.NFEE,'%d/%m/%Y') AS NFEE,dp.estado_idestado AS estadoDetalle,dp.tipo_negocio_idtipo_negocio AS tipoNegocio,df.Procesos_idproceso AS formatoEstandar,df.cantidad_terminada,dt.Procesos_idproceso as Teclados,dt.cantidad_terminada,de.Procesos_idproceso as Ensamble,de.cantidad_terminada,dp.canitadad_total FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_formato_estandar df ON dp.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_teclados dt ON dp.idDetalle_proyecto=dt.detalle_proyecto_idDetalle_proyecto LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto WHERE p.estado_idestado!=3 and dp.negocio_idnegocio!=4 and p.eliminacion!=0  ORDER BY p.numero_orden,df.idDetalle_formato_estandar,dt.Procesos_idproceso,de.Procesos_idproceso,dp.tipo_negocio_idtipo_negocio,dp.estado_idestado;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNEN` ()  NO SQL
BEGIN

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado_idestado,pp.tipo_proyecto,dp.lider_proyecto,en.cantidad_terminada,en.cantidadProceso,en.orden FROM detalle_ensamble en LEFT JOIN detalle_proyecto dp ON en.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN procesos p ON en.Procesos_idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden JOIN tipo_negocio t ON dp.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE  dp.negocio_idnegocio=3 AND pp.estado_idestado!=3 AND dp.estado_idestado!=3 AND pp.eliminacion!=0 ORDER BY dp.proyecto_numero_orden,dp.tipo_negocio_idtipo_negocio,en.orden;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNFE` ()  NO SQL
BEGIN

#SELECT p.numero_orden,d.material,p.tipo_proyecto,tn.nombre as tipoNegocio,d.canitadad_total,df.cantidad_terminada,df.Procesos_idproceso,df.estado_idestado,d.PNC FROM proyecto p RIGHT JOIN detalle_proyecto d ON p.numero_orden=d.proyecto_numero_orden JOIN detalle_formato_estandar df ON d.idDetalle_proyecto=df.detalle_proyecto_idDetalle_proyecto JOIN tipo_negocio tn on d.tipo_negocio_idtipo_negocio=tn.idtipo_negocio WHERE d.negocio_idnegocio=1 AND p.eliminacion=1 AND d.estado_idestado!=3 GROUP BY d.idDetalle_proyecto,df.Procesos_idproceso ORDER BY d.proyecto_numero_orden ASC;
SELECT d.proyecto_numero_orden,d.material,p.tipo_proyecto,tn.nombre,d.canitadad_total,df.cantidad_terminada,df.Procesos_idproceso,df.estado_idestado,d.ubicacion FROM detalle_formato_estandar df RIGHT JOIN detalle_proyecto d ON df.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto LEFT JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden JOIN tipo_negocio tn on d.tipo_negocio_idtipo_negocio=tn.idtipo_negocio where d.negocio_idnegocio=1 AND p.eliminacion=1 AND d.estado_idestado!=3 GROUP BY d.idDetalle_proyecto,df.Procesos_idproceso ORDER BY d.proyecto_numero_orden,tn.nombre,d.PNC,d.ubicacion;
# AND df.fecha_fin is null
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_InformeNTE` ()  NO SQL
BEGIN

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado_idestado,pp.tipo_proyecto FROM detalle_teclados en LEFT JOIN detalle_proyecto dp ON en.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto LEFT JOIN procesos p ON en.Procesos_idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden WHERE pp.estado_idestado!=3 AND pp.eliminacion!=0 AND dp.negocio_idnegocio=2 ORDER BY dp.proyecto_numero_orden;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarRenaudarTomaDeTiempoProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `oper` INT(3))  NO SQL
BEGIN
DECLARE id int;
DECLARE id1 int;
DECLARE cantidadp int;

IF busqueda=1 THEN

set id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2);

IF id !='null' THEN
UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_formato_estandar=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_formato_estandar f SET  f.estado_idestado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id1;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;

ELSE
  IF busqueda=2 THEN
  
  set id=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_teclados from detalle_teclados f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2);

IF id !='null' THEN
UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_teclados=id ;
END IF;

IF id1 !='null' THEN
UPDATE detalle_teclados f SET f.estado_idestado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_teclados=id1 ;
END IF;
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  
  ELSE 
    IF busqueda =3 THEN
    
set id=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=1);

set id1=(SELECT f.idDetalle_ensamble from detalle_ensamble f LEFT JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=2); 

IF id !='null' THEN
UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=now(),f.noperarios=oper WHERE f.idDetalle_ensamble=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_ensamble f SET  f.estado_idestado=4, f.hora_ejecucion=now(),f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_ensamble=id1 ;
END IF;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
    
    END IF;  
  END IF;
END IF;
            CALL PA_CambiarEstadoDeProductos(busqueda,detalle);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_IniciarTomaTiempoDetalleAlmacen` (IN `detalle` INT)  NO SQL
BEGIN

UPDATE almacen a SET a.estado_idestado=4 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle;

 UPDATE detalle_proyecto dp SET pro_Pausado=0,pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ModificarDetalleFormatoEstandar` (IN `orden` INT, IN `detalle` INT, IN `material` VARCHAR(2))  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_formato_estandar d  WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=2) THEN   
  IF material = 'FV' then
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=2; 
              END IF;
ELSE
    IF material='TH' then
              INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES ('00:00','00:00','0',detalle,2,1);
   END IF;
END IF;

  

IF (SELECT tipo_negocio_idtipo_negocio from detalle_proyecto WHERE proyecto_numero_orden=orden and idDetalle_proyecto=detalle
)=1  THEN


  IF (SELECT ruteoC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=9; 
      END IF;
    
  END IF;
  
 IF (SELECT antisolderC from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=6; 
      END IF;
    
  END IF;


    ELSE
    

  IF (SELECT ruteoP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,9,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=9) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=9; 
      END IF;
    
  END IF;

 IF (SELECT antisolderP from proyecto WHERE numero_orden=orden)=1 THEN
    
     IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
     d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
     f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN         
	   select "hola1";    
      ELSE
     INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, 
     `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
     ('00:00','00:00','0',detalle,6,1);
    END IF;
       
    ELSE
       
      IF (SELECT f.Procesos_idproceso from detalle_proyecto d JOIN detalle_formato_estandar f ON 
      d.idDetalle_proyecto=f.detalle_proyecto_idDetalle_proyecto WHERE d.proyecto_numero_orden=orden and 
      f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=6) THEN
        DELETE FROM detalle_formato_estandar  WHERE detalle_proyecto_idDetalle_proyecto=detalle and Procesos_idproceso=6; 
      END IF;
    
  END IF;

END IF;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NombreUsuario` (IN `doc` VARCHAR(13))  NO SQL
BEGIN

SELECT u.nombres FROM usuario u WHERE u.numero_documento=doc;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_NumeroOperarios` (IN `detalle` INT, IN `lector` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
ELSE
 IF negocio=2 THEN
  SELECT f.noperarios FROM detalle_teclados f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
 ELSE
  SELECT f.noperarios FROM detalle_ensamble f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PararTomaDeTiempoAlmacen` (IN `detalle` INT, IN `proceso` INT, IN `cantidad` INT, IN `estado` INT)  NO SQL
BEGIN
DECLARE fecha varchar(11);
IF estado=3 THEN
SET fecha=(SELECT datediff(CURRENT_DATE,al.fecha_inicio) FROM almacen al WHERE al.detalle_proyecto_idDetalle_proyecto=detalle AND al.Procesos_idproceso=proceso);

UPDATE almacen a SET a.fecha_fin=CURRENT_DATE, a.hora_llegada=CURRENT_TIME,a.cantidad_recibida=cantidad,a.estado_idestado=3,a.tiempo_total_proceso=datediff(CURRENT_DATE,a.fecha_inicio) WHERE a.detalle_proyecto_idDetalle_proyecto=detalle AND a.Procesos_idproceso=proceso;

UPDATE detalle_proyecto SET pro_Terminado=1 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto  SET pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle;

UPDATE detalle_proyecto dp SET dp.tiempo_total=fecha WHERE dp.idDetalle_proyecto=detalle; 

ELSE
 IF estado=2 THEN
  UPDATE almacen a SET a.estado_idestado=2 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle;
 UPDATE detalle_proyecto dp SET pro_Pausado=1,pro_Ejecucion=0 WHERE idDetalle_proyecto=detalle; 
 
 else
UPDATE almacen a SET a.cantidad_recibida=cantidad,a.estado_idestado=4 WHERE a.detalle_proyecto_idDetalle_proyecto=detalle AND a.Procesos_idproceso=proceso;

UPDATE detalle_proyecto  SET pro_Ejecucion=1 WHERE idDetalle_proyecto=detalle; 
 
 END IF;
END IF;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PausarTomaDeTiempoDeProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `tiempo` VARCHAR(8), IN `cantidadTerminada` INT, IN `cantidadAntiguaTermianda` INT, IN `est` TINYINT(1), IN `res` INT(6), IN `procesoPasar` INT(6))  NO SQL
BEGIN
DECLARE id int;
DECLARE id2 int;
DECLARE cantidadp int;
DECLARE primero int;
DECLARE segundo int;
DECLARE restanteProcesoA int;
#se encarga de hacer la diferencia de tiempo de un dia para otro y tener el formato de hora aplicado.
#SELECT SEC_TO_TIME(TIMESTAMPDIFF(MINUTE, '2018-10-10 11:00:00','2018-10-11 12:00:00')*60)
IF est=2 THEN#Cuando el estado es pausado=2

IF busqueda=1 THEN#La variable busqueda hace referencia al area de produccion

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  #...
  IF procesoPasar=0 AND lector!=18 THEN
  	SET cantidadTerminada=0;
  END IF;
  #...
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);#ID del proceso primario
  #Al proceso primario se la van a restar las cantidades terminadas, Esta pendiente calcular el estado del proceso que envia.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)-cantidadTerminada),e.cantidad_terminada=(e.cantidad_terminada+cantidadTerminada), e.noperarios=0,e.tiempo_total_por_proceso=tiempo WHERE e.idDetalle_ensamble=id;
  #...
  IF procesoPasar!=0 THEN#Si el proceso que se envia las cantidades es igual a 0 entonces no se van a sumar cantidades
  	SET id2=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=procesoPasar);#ID del proceso secundario
  #Al proceso secundario se la van a sumar las cantidades terminadas, Esta pendiente calcular el estado del proceso que recibe.
  UPDATE detalle_ensamble e SET e.cantidadProceso=(CONVERT(e.cantidadProceso, int)+cantidadTerminada) WHERE e.idDetalle_ensamble=id2;
  ELSE
  	SET id2=0;
  END IF;
  #...
  #Funcion para clasificar el estado de cada proceso, Esto queda pendiente
  SET cantidadp=(SELECT CONVERT(e.canitadad_total,int) FROM detalle_proyecto e WHERE e.idDetalle_proyecto=detalle);
  SELECT FU_ClasificarEstadoProcesosEnsamble(id,id2,cantidadp);
  #...
  END IF; 
 END IF;
END IF;

ELSE#Cuando el estado es terminado=3

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est,f.fecha_fin=now(),f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est,f.fecha_fin=now(), f.tiempo_total_proceso=tiempo, f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN#Acá ya no va ingresar nunca
  #Pendiente modificar esta forma de actualizar la base de datos
  #SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  
  #UPDATE detalle_ensamble f SET  f.estado_idestado=est,f.fecha_fin=now(), f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=(cantidadTerminada+cantidadAntiguaTermianda),f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id;
  SELECT "Esta parte del código ya no se va a utilziar más.";
  END IF; 
 END IF;
END IF;

END IF;

#Cantidad de proceso en los diferentes estados de las diferentes áreas
IF busqueda=1 THEN

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;

ELSE
 IF busqueda=2 THEN
 
 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
 
 ELSE
  if busqueda=3 THEN
  
  SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalle;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalle) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalle;
  #...
  END IF;
 END IF;
END IF;
   CALL PA_CambiarEstadoDeProductos(busqueda,detalle);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PromedioProductoPorMinuto` (IN `detalle` INT, IN `negocio` INT, IN `lector` INT)  NO SQL
BEGIN
IF negocio=1 THEN

SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_formato_estandar d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;

ELSE
 IF negocio=2 THEN

SELECT d.tiempo_total_proceso,d.cantidad_terminada FROM detalle_teclados d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;

 ELSE
  
 SELECT d.tiempo_total_por_proceso,d.cantidad_terminada FROM detalle_ensamble d WHERE d.detalle_proyecto_idDetalle_proyecto=detalle AND d.Procesos_idproceso=lector AND d.estado_idestado=3;
 
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ProyectosEnEjecucion` (IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN

SELECT d.proyecto_numero_orden FROM detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado_idestado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;


else
 IF negocio=2 THEN

SELECT d.proyecto_numero_orden FROM detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado_idestado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;

 ELSE
  IF negocio=3 THEN

SELECT d.proyecto_numero_orden FROM detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto JOIN proyecto p ON d.proyecto_numero_orden=p.numero_orden WHERE f.estado_idestado=4 AND p.eliminacion=1 GROUP BY d.proyecto_numero_orden;

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

set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=4));

INSERT INTO `almacen`(`tiempo_total_proceso`, `cantidad_recibida`, `fecha_inicio`,`detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_registro`) VALUES ('0','0',now(),detalle,proceso,4,CURRENT_TIME);

SET cantidad= (SELECT COUNT(*) FROM almacen a WHERE  a.detalle_proyecto_idDetalle_proyecto=detalle AND a.estado_idestado=4);


UPDATE detalle_proyecto d SET d.pro_Ejecucion=cantidad WHERE idDetalle_proyecto=detalle;

CALL PA_CambiarEstadoDeProductos(4,detalle);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleEnsamble` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=3 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_ensamble`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES ('00:00','00:00','0',detalle,proceso,1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleFormatoEstandar` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25))  NO SQL
BEGIN
DECLARE material varchar(3);
DECLARE antisolder int;
declare ruteo int;
declare detalle int;

 IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=1 AND dd.ubicacion is null));

 ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=1 AND dd.ubicacion=ubic));

 END IF;



IF tipo=2 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,5,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,10,1);
ELSE
IF tipo=3 or tipo=4 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
   IF tipo=6 THEN
#Perforado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);
#Caminos
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);
#Quemado
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);
ELSE
     IF tipo=1 or tipo=7 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,1,1);


set material=(SELECT d.material from detalle_proyecto d WHERE d.proyecto_numero_orden=(orden) AND d.idDetalle_proyecto=detalle);


IF material="TH" THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,2,1);
END IF;


 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,3,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,4,1);

INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,5,1);

     IF tipo=1 THEN
set antisolder=(SELECT antisolderC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoC from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
 
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
     END IF;
          IF tipo=7 THEN
          
set antisolder=(SELECT antisolderP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));

set ruteo=(SELECT ruteoP from proyecto where numero_orden=(SELECT proyecto_numero_orden from detalle_proyecto WHERE idDetalle_proyecto=detalle));
 IF antisolder=1 THEN
 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,6,1);
 END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,7,1);

 INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,8,1);

  IF ruteo=1 THEN
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,9,1);
 END IF;
          END IF;
INSERT INTO `detalle_formato_estandar`(`tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`) VALUES
('00:00','00:00','0',detalle,10,1);
   END IF;
  END IF;
 END IF;
END IF;

SET tipo= (SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=detalle AND d.estado_idestado=1);


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
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`material`,`PNC`) VALUES (producto,cantidad,orden,area,1,material,0);
SELECT 1;
ELSE
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`PNC`) VALUES (producto,cantidad,orden,area,1,0);
SELECT 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_RegistrarDetalleTeclados` (IN `orden` INT, IN `tipo` INT, IN `ubic` VARCHAR(25), IN `proceso` INT)  NO SQL
BEGIN

DECLARE detalle int;

IF ubic='' THEN
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion is null));

ELSE
 
set detalle=((SELECT dd.idDetalle_proyecto from detalle_proyecto dd WHERE dd.proyecto_numero_orden=(orden) AND dd.tipo_negocio_idtipo_negocio=tipo AND dd.negocio_idnegocio=2 AND dd.ubicacion=ubic));

END IF;

INSERT INTO `detalle_teclados`(`tiempo_por_unidad`, `tiempo_total_proceso`, `cantidad_terminada`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`)VALUES
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteGeneral` ()  NO SQL
BEGIN

SELECT p.numero_orden,p.nombre_cliente,p.nombre_proyecto,dp.canitadad_total,n.nom_negocio,t.nombre,dp.Total_timepo_Unidad,dp.tiempo_total FROM detalle_proyecto dp JOIN proyecto p ON dp.proyecto_numero_orden=p.numero_orden JOIN negocio n on dp.negocio_idnegocio=n.idnegocio JOIN tipo_negocio t ON dp.tipo_negocio_idtipo_negocio=t.idtipo_negocio;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ReporteTiemposAreaProduccion` (IN `area` INT, IN `fechaI` VARCHAR(10), IN `fechaF` VARCHAR(10))  NO SQL
BEGIN

IF area=1 THEN#Formato Estandar# Pendiente actualizar el reporte de los tiempo (Esto se realizara cuando se organice la forma de tomar los tiempos).
 SELECT p.numero_orden, de.Procesos_idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.canitadad_total  FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_formato_estandar de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto join procesos pro ON de.Procesos_idproceso=pro.idproceso WHERE dp.negocio_idnegocio=1 AND p.eliminacion=1 AND dp.estado_idestado=3 ORDER BY p.numero_orden;
ELSE
 IF area=2 THEN#Teclados Pendiente actualizar el reporte de los tiempo (Esto se realizara cuando se organice la forma de tomar los tiempos).
 SELECT p.numero_orden, de.Procesos_idproceso,pro.nombre_proceso,de.tiempo_total_proceso,dp.tiempo_total,dp.canitadad_total  FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden JOIN detalle_teclados de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto join procesos pro ON de.Procesos_idproceso=pro.idproceso WHERE dp.negocio_idnegocio=2 AND p.eliminacion=1 AND dp.estado_idestado=3 ORDER BY p.numero_orden;
 ELSE
  IF area=3 THEN#Ensamble
   SELECT p.numero_orden, de.Procesos_idproceso,pro.nombre_proceso,de.tiempo_total_por_proceso,dp.tiempo_total,dp.Total_timepo_Unidad,dp.estado_idestado,dp.canitadad_total, de.cantidadProceso,dp.fecha_salida  FROM proyecto p LEFT JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden LEFT JOIN detalle_ensamble de ON dp.idDetalle_proyecto=de.detalle_proyecto_idDetalle_proyecto LEFT JOIN procesos pro ON de.Procesos_idproceso=pro.idproceso WHERE dp.negocio_idnegocio=3 AND p.eliminacion=1 AND (DATE_FORMAT(dp.fecha_salida, '%Y-%m-%d') between fechaI AND fechaF) OR dp.fecha_salida IS null ORDER BY p.numero_orden;
  END IF;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_selccionarPrimerProcesoProyectosEnsamble` (IN `detalle` INT, IN `idproceso` INT)  NO SQL
BEGIN
#Reiniciar el orden de todos los procesos que tiene el detalle
UPDATE detalle_ensamble e SET e.orden=0,e.cantidadProceso=0 WHERE e.detalle_proyecto_idDetalle_proyecto=detalle;

#Seleccionar el primer proceso
UPDATE detalle_ensamble e SET e.orden=1,e.cantidadProceso=(SELECT p.canitadad_total FROM detalle_proyecto p WHERE p.idDetalle_proyecto=detalle LIMIT 1) WHERE e.idDetalle_ensamble=idproceso;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_Sesion` (IN `sec` INT, IN `ced` VARCHAR(13))  NO SQL
BEGIN

UPDATE usuario u SET u.sesion=sec WHERE u.numero_documento=ced;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TiempoProceso` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF negocio=1 THEN
SELECT df.tiempo_total_por_proceso FROM detalle_formato_estandar df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.estado_idestado!=1;

ELSE
 IF negocio=2 THEN
  SELECT dt.tiempo_total_proceso FROM detalle_teclados dt WHERE dt.detalle_proyecto_idDetalle_proyecto=detalle AND dt.estado_idestado!=1;
 ELSE
  SELECT de.tiempo_total_por_proceso FROM detalle_ensamble de WHERE de.detalle_proyecto_idDetalle_proyecto=detalle AND de.estado_idestado!=1;
 END IF;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_TodosLosDetallesEnEjecucion` (IN `orden` INT)  NO SQL
BEGIN
SELECT dp.idDetalle_proyecto,dp.negocio_idnegocio FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.estado_idestado=4;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadDetalleProyecto` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN

DECLARE can int;
DECLARE id int;
DECLARE oper int;

IF busqueda=1 THEN# Formato estandar

SET id=(SELECT f.cantidad_terminada from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
SET oper=(SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

ELSE
 IF busqueda=2 THEN# Teclatos
 
 SET id=(SELECT f.cantidad_terminada from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  SET oper=(SELECT f.noperarios FROM detalle_teclados f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
 ELSE
  IF busqueda=3 THEN# Ensamble
  
  SET id=(SELECT f.cantidad_terminada from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
    SET oper=(SELECT f.noperarios FROM detalle_ensamble f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
  ELSE# Almacen
   SET id=(SELECT f.cantidad_recibida from almacen f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  END IF; 
 END IF;
END IF;

set can=(select d.canitadad_total FROM detalle_proyecto d WHERE d.idDetalle_proyecto=detalle);

SELECT can as contidad_total,id as cantidad_proceso,oper as operarios;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarCantidadPNCOrigen` (IN `orden` INT, IN `detalle` INT, IN `op` INT, IN `tipo` INT, IN `negocio` INT)  NO SQL
BEGIN

IF op=1 THEN


 SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.idDetalle_proyecto=detalle;

else

SELECT d.canitadad_total FROM detalle_proyecto d WHERE d.proyecto_numero_orden=orden and d.PNC=0 and d.negocio_idnegocio=negocio AND d.tipo_negocio_idtipo_negocio=tipo;

END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarDetalleProyectoQR` (IN `orden` INT, IN `area` INT, IN `producto` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.proyecto_numero_orden=orden AND dp.negocio_idnegocio=area AND dp.tipo_negocio_idtipo_negocio=producto) THEN
SELECT 0;
ELSE
SELECT 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ValidarEstadoProyecto` (IN `detalle` INT, IN `negocio` INT)  NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto dp WHERE dp.estado_idestado=3 AND dp.idDetalle_proyecto=detalle)  THEN

 IF negocio=1 THEN
    SELECT df.tiempo_por_unidad FROM detalle_formato_estandar df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
 ELSE
  IF negocio=2 THEN
      SELECT df.tiempo_por_unidad FROM detalle_teclados df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
   ELSE
      SELECT df.tiempo_por_unidad FROM detalle_ensamble df WHERE df.detalle_proyecto_idDetalle_proyecto=detalle AND df.tiempo_por_unidad!='00:00';
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ClasificarEstadoProcesosEnsamble` (`proceso1` INT, `proceso2` INT, `cant` INT) RETURNS TINYINT(1) NO SQL
BEGIN
#Clasificar el estado del proceso 1 (pausado=2 o terminado=3)
IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso1 AND CONVERT(e.cantidad_terminada,int)>=cant AND CONVERT(e.cantidadProceso,int)=0 AND e.estado_idestado=4) THEN
 UPDATE detalle_ensamble e SET e.estado_idestado=3, e.fecha_fin=now() WHERE e.idDetalle_ensamble=proceso1;#Estado Terminado
 #RETURN 3;
ELSE	    
 UPDATE detalle_ensamble e SET e.estado_idestado=2, e.fecha_fin=null WHERE e.idDetalle_ensamble=proceso1;#Estado Pausado
 #RETURN 2;
END IF;
#...
#Clasificar el estado del proceso 2 (pausado=2 o terminado=3)
IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso2 AND CONVERT(e.cantidad_terminada,int)>=cant AND CONVERT(e.cantidadProceso,int)=0 AND e.estado_idestado!=4) THEN
 UPDATE detalle_ensamble e SET e.estado_idestado=3, e.fecha_fin=now() WHERE e.idDetalle_ensamble=proceso2;#Estado Terminado
ELSE
 IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.idDetalle_ensamble=proceso2 AND e.estado_idestado!=4 AND e.estado_idestado!=1) THEN
	UPDATE detalle_ensamble e SET e.estado_idestado=2, e.fecha_fin=null WHERE e.idDetalle_ensamble=proceso2;#Estado Pausado 
 END IF; 
END IF;
#...
return 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ConsultarEstadoDetalleProyecto` (`detalle` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_proyecto e WHERE e.idDetalle_proyecto=detalle AND e.estado_idestado=1) THEN
	return 1;
ELSE
	return 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoAlmacen` (`iddetalle` INT, `orden` INT) RETURNS INT(11) NO SQL
BEGIN

DELETE FROM almacen WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

DELETE FROM `detalle_proyecto` WHERE idDetalle_proyecto=iddetalle;
 
CALL PA_CambiarEstadoDeProyecto(orden);

RETURN 1;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_EliminarDetalleProyectoEnsamble` (`iddetalle` INT, `orden` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;
SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_ensamble` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

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
SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_formato_estandar` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

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
SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

IF cantidad=0 THEN
DELETE FROM `detalle_teclados` WHERE detalle_proyecto_idDetalle_proyecto=iddetalle;

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
         AND p.estado_idestado!=4) THEN
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ModificarDetalleProyecto` (`orden` INT, `idDetalle` INT, `cantidad` VARCHAR(6), `material` VARCHAR(6), `negocio` INT, `ubicacion` VARCHAR(25)) RETURNS TINYINT(1) NO SQL
BEGIN
UPDATE detalle_proyecto dp SET dp.canitadad_total=cantidad,dp.material=material,dp.ubicacion=ubicacion WHERE idDetalle_proyecto=idDetalle and proyecto_numero_orden=orden;
CALL PA_CambiarEstadoDeProductos(negocio,idDetalle);
RETURN 1;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarDetalleProyecto` (`orden` INT(11), `tipoNegocio` VARCHAR(20), `cantidad` VARCHAR(6), `negocio` VARCHAR(20), `estado` TINYINT(1), `material` VARCHAR(6), `pnc` TINYINT(1), `ubic` VARCHAR(30)) RETURNS TINYINT(1) NO SQL
BEGIN
IF material != '' THEN
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`material`,`PNC`,`ubicacion`,`tiempo_total`,`Total_timepo_Unidad`) VALUES ((SELECT idtipo_negocio from tipo_negocio where nombre =tipoNegocio),cantidad,orden,(SELECT idnegocio FROM negocio WHERE nom_negocio =negocio),estado,material,pnc,ubic,'00:00','00:00');
RETURN 1;
ELSE
INSERT INTO `detalle_proyecto`(`tipo_negocio_idtipo_negocio`, `canitadad_total`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`,`PNC`,`ubicacion`,`tiempo_total`,`Total_timepo_Unidad`) VALUES ((SELECT idtipo_negocio from tipo_negocio where nombre =tipoNegocio),cantidad,orden,(SELECT idnegocio FROM negocio WHERE nom_negocio =negocio),estado,pnc,ubic,'00:00','00:00');
RETURN 1;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_RegistrarModificarProcesos` (`op` INT, `nombre` VARCHAR(30), `area` INT, `id` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF op=1 THEN
INSERT INTO `procesos`(`nombre_proceso`, `estado`, `negocio_idnegocio`) VALUES (nombre,1,area);
RETURN 1;
else
UPDATE procesos p SET p.nombre_proceso=nombre,p.negocio_idnegocio=area WHERE p.idproceso=id;
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

INSERT INTO `proyecto`(`numero_orden`,`usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `ruteoC`, `antisolderC`, `estado_idestado`,`ruteoP`,`antisolderP`,`entregaCircuitoFEoGF`,`entregaCOMCircuito`,`entregaPCBFEoGF`,`entregaPCBCom`) VALUES (norden,doc,cliente,proyecto,tipo,fe,te,inte,pcbfe,pcbte,conv,rep,tro,st,lexan,(SELECT now()),entrega,ruteo,anti,1,ruteoP,antiP,fecha1,fecha2,fecha3,fecha4); 
RETURN 1;
ELSE 
 UPDATE `proyecto` SET `nombre_cliente`=cliente,`nombre_proyecto`=proyecto,`tipo_proyecto`=tipo,`FE`=fe,`TE`=te,`IN`=inte,`pcb_FE`=pcbfe,`pcb_TE`=pcbte,`Conversor`=conv,`Repujado`=rep,`troquel`=tro,`stencil`=st,`lexan`=lexan,`fecha_entrega`=entrega,`ruteoC`=ruteo,`antisolderC`=anti,`ruteoP`=ruteoP,`antisolderP`=antiP,`entregaCircuitoFEoGF`=fecha1,`entregaCOMCircuito`=fecha2,`entregaPCBFEoGF`=fecha3,`entregaPCBCom`=fecha4,`novedades`=nov,`estadoEmpresa`=estadopro,`NFEE`=nfee WHERE numero_orden=norden;
RETURN 1;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ReiniciarTiempo` (`detalle` INT, `negocio` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidadp int;
DECLARE detalleN int;


IF negocio=1 THEN
UPDATE `detalle_formato_estandar` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_formato_estandar`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_formato_estandar d WHERE d.idDetalle_formato_estandar=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_formato_estandar d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
  RETURN 1;
ELSE
 IF negocio=2 THEN
 UPDATE `detalle_teclados` SET `tiempo_por_unidad`= "00:00",`tiempo_total_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_teclados`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_teclados d WHERE d.idDetalle_teclados=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_teclados d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;
CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
 RETURN 1;
 ELSE
  UPDATE `detalle_ensamble` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,`cantidadProceso`=0 WHERE `idDetalle_ensamble`=detalle;
SET detalleN =(SELECT d.detalle_proyecto_idDetalle_proyecto FROM detalle_ensamble d WHERE d.idDetalle_ensamble=detalle);

 SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=1);

UPDATE detalle_proyecto SET pro_porIniciar=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=2);

UPDATE detalle_proyecto SET pro_Pausado=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=4);

UPDATE detalle_proyecto SET pro_Ejecucion=cantidadp WHERE idDetalle_proyecto=detalleN;

SET cantidadp =(SELECT COUNT(*) FROM detalle_ensamble d WHERE  d.detalle_proyecto_idDetalle_proyecto=(detalleN) AND d.estado_idestado=3);

UPDATE detalle_proyecto SET pro_Terminado=cantidadp WHERE idDetalle_proyecto=detalleN;

CALL PA_CambiarEstadoDeProductos(negocio,detalleN);
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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarCantidadParaProcesosEnsamble` (`detalle` INT, `lector` INT) RETURNS INT(11) NO SQL
BEGIN
#Consulta las cantidades que tiene el proceso de ensamble para validar si tiene equipos a los cuales les puede trabajar.
RETURN (SELECT e.cantidadProceso FROM detalle_ensamble e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle AND e.Procesos_idproceso=lector);

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_validarEliminacion` (`iddetalle` INT, `orden` INT, `tipo` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN
DECLARE cantidad int;

IF busqueda=1 THEN
  SET cantidad=(SELECT count(*) from detalle_formato_estandar f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);   
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
 ELSE
 IF busqueda=2 THEN
 SET cantidad=(SELECT count(*) from detalle_teclados f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);
IF cantidad=0 THEN
RETURN 1;
ELSE
RETURN 0;
END IF;
  ELSE
  IF busqueda=3 THEN
    SET cantidad=(SELECT count(*) from detalle_ensamble f INNER JOIN detalle_proyecto d  WHERE f.detalle_proyecto_idDetalle_proyecto=iddetalle AND f.fecha_inicio is not null and d.proyecto_numero_orden=orden);

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

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarProcesoInicioProcesoEnsamble` (`detalle` INT) RETURNS TINYINT(1) NO SQL
BEGIN

IF EXISTS(SELECT * FROM detalle_ensamble e WHERE e.detalle_proyecto_idDetalle_proyecto=detalle AND e.orden=1) THEN
#Si existe un proceso seleccionado como inicial
	return 1;
ELSE
#No existe un proceso selccionado
	return 0;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `FU_ValidarTomaDeTiempo` (`orden` INT, `detalle` INT, `lector` INT, `busqueda` INT) RETURNS TINYINT(1) NO SQL
BEGIN

DECLARE id int;

IF busqueda=1 THEN
SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
ELSE
  IF busqueda=2 THEN
SET id=(SELECT f.idDetalle_teclados from 
detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  ELSE 
    IF busqueda=3 THEN
    SET id=(SELECT f.idDetalle_ensamble from 
detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
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
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_registro` time DEFAULT NULL,
  `hora_llegada` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `almacen`
--

INSERT INTO `almacen` (`idalmacen`, `tiempo_total_proceso`, `cantidad_recibida`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_registro`, `hora_llegada`) VALUES
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
(69, '0', '0', '2019-02-20', NULL, 318, 20, 4, '17:31:47', NULL),
(70, '0', '0', '2019-02-21', NULL, 323, 19, 4, '11:26:53', NULL),
(71, '0', '0', '2019-02-21', NULL, 328, 19, 4, '14:50:54', NULL),
(72, '0', '0', '2019-02-21', NULL, 329, 20, 4, '14:50:54', NULL),
(73, '0', '0', '2019-02-21', NULL, 332, 19, 4, '15:17:21', NULL),
(74, '0', '0', '2019-02-21', NULL, 333, 20, 4, '15:17:21', NULL),
(75, '0', '0', '2019-02-21', NULL, 336, 19, 4, '15:21:36', NULL),
(76, '0', '0', '2019-02-21', NULL, 337, 20, 4, '15:21:36', NULL),
(77, '0', '0', '2019-02-27', NULL, 352, 19, 4, '11:58:59', NULL),
(78, '0', '0', '2019-02-27', NULL, 353, 20, 4, '11:59:00', NULL),
(79, '0', '0', '2019-02-27', NULL, 358, 19, 4, '12:49:43', NULL),
(80, '0', '0', '2019-02-27', NULL, 359, 20, 4, '12:49:43', NULL),
(81, '0', '0', '2019-02-28', NULL, 366, 19, 4, '08:55:52', NULL);

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
-- Estructura de tabla para la tabla `detalle_ensamble`
--

CREATE TABLE `detalle_ensamble` (
  `idDetalle_ensamble` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_por_proceso` varchar(10) DEFAULT '00:00',
  `cantidad_terminada` varchar(10) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `noperarios` tinyint(2) NOT NULL DEFAULT '0',
  `orden` tinyint(1) NOT NULL DEFAULT '0',
  `cantidadProceso` varchar(10) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_ensamble`
--

INSERT INTO `detalle_ensamble` (`idDetalle_ensamble`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `noperarios`, `orden`, `cantidadProceso`) VALUES
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
(65, '00:00', '00:00', '0', NULL, NULL, 17, 15, 1, NULL, NULL, 0, 0, '0'),
(66, '00:00', '00:00', '0', NULL, NULL, 17, 16, 1, NULL, NULL, 0, 0, '0'),
(67, '00:00', '00:00', '0', NULL, NULL, 17, 17, 1, NULL, NULL, 0, 0, '0'),
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
(320, '00:00', '00:00', '0', NULL, NULL, 322, 18, 1, NULL, NULL, 0, 0, '0'),
(321, '00:00', '00:00', '0', NULL, NULL, 325, 15, 1, NULL, NULL, 0, 0, '0'),
(322, '00:00', '00:00', '0', NULL, NULL, 325, 16, 1, NULL, NULL, 0, 0, '0'),
(323, '00:00', '00:00', '0', NULL, NULL, 325, 17, 1, NULL, NULL, 0, 0, '0'),
(324, '00:00', '00:00', '0', NULL, NULL, 325, 18, 1, NULL, NULL, 0, 0, '0'),
(325, '00:00', '00:00', '0', NULL, NULL, 330, 15, 1, NULL, NULL, 0, 0, '0'),
(326, '00:00', '00:00', '0', NULL, NULL, 330, 16, 1, NULL, NULL, 0, 0, '0'),
(327, '00:00', '00:00', '0', NULL, NULL, 330, 17, 1, NULL, NULL, 0, 0, '0'),
(328, '00:00', '00:00', '0', NULL, NULL, 330, 18, 1, NULL, NULL, 0, 0, '0'),
(329, '00:00', '00:00', '0', NULL, NULL, 334, 15, 1, NULL, NULL, 0, 0, '0'),
(330, '00:00', '00:00', '0', NULL, NULL, 334, 16, 1, NULL, NULL, 0, 0, '0'),
(331, '00:00', '00:00', '0', NULL, NULL, 334, 17, 1, NULL, NULL, 0, 0, '0'),
(332, '00:00', '00:00', '0', NULL, NULL, 334, 18, 1, NULL, NULL, 0, 0, '0'),
(333, '00:00', '00:00', '0', NULL, NULL, 338, 15, 1, NULL, NULL, 0, 0, '0'),
(334, '00:00', '00:00', '0', NULL, NULL, 338, 16, 1, NULL, NULL, 0, 0, '0'),
(335, '00:00', '00:00', '0', NULL, NULL, 338, 17, 1, NULL, NULL, 0, 0, '0'),
(336, '00:00', '00:00', '0', NULL, NULL, 338, 18, 1, NULL, NULL, 0, 0, '0'),
(337, '00:00', '00:00', '0', NULL, NULL, 354, 15, 1, NULL, NULL, 0, 0, '0'),
(338, '00:00', '00:00', '0', NULL, NULL, 354, 16, 1, NULL, NULL, 0, 0, '0'),
(339, '00:00', '00:00', '0', NULL, NULL, 354, 17, 1, NULL, NULL, 0, 0, '0'),
(340, '00:00', '00:00', '0', NULL, NULL, 354, 18, 1, NULL, NULL, 0, 0, '0'),
(341, '00:00', '00:00', '0', NULL, NULL, 360, 15, 1, NULL, NULL, 0, 0, '0'),
(342, '00:00', '00:00', '0', NULL, NULL, 360, 16, 1, NULL, NULL, 0, 0, '0'),
(343, '00:00', '00:00', '0', NULL, NULL, 360, 17, 1, NULL, NULL, 0, 0, '0'),
(344, '00:00', '00:00', '0', NULL, NULL, 360, 18, 1, NULL, NULL, 0, 0, '0'),
(345, '00:00', '00:00', '0', NULL, NULL, 368, 15, 1, NULL, NULL, 0, 0, '0'),
(346, '00:00', '00:00', '0', NULL, NULL, 368, 16, 1, NULL, NULL, 0, 0, '0'),
(347, '00:00', '00:00', '0', NULL, NULL, 368, 17, 1, NULL, NULL, 0, 0, '0'),
(348, '00:00', '00:00', '0', NULL, NULL, 368, 18, 1, NULL, NULL, 0, 0, '0');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_formato_estandar`
--

CREATE TABLE `detalle_formato_estandar` (
  `idDetalle_formato_estandar` smallint(6) NOT NULL,
  `tiempo_por_unidad` varchar(6) DEFAULT NULL,
  `tiempo_total_por_proceso` varchar(10) DEFAULT '00:00',
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1, '00:00', '00:00', '0', NULL, NULL, 13, 1, 1, NULL, NULL, 0, 0),
(2, '00:00', '00:00', '0', NULL, NULL, 13, 2, 1, NULL, NULL, 0, 0),
(3, '00:00', '00:00', '0', NULL, NULL, 13, 3, 1, NULL, NULL, 0, 0),
(4, '00:00', '00:00', '0', NULL, NULL, 13, 4, 1, NULL, NULL, 0, 0),
(5, '00:00', '00:00', '0', NULL, NULL, 13, 5, 1, NULL, NULL, 0, 0),
(6, '00:00', '00:00', '0', NULL, NULL, 13, 7, 1, NULL, NULL, 0, 0),
(7, '00:00', '00:00', '0', NULL, NULL, 13, 8, 1, NULL, NULL, 0, 0),
(8, '00:00', '00:00', '0', NULL, NULL, 13, 10, 1, NULL, NULL, 0, 0),
(9, '00:00', '00:00', '0', NULL, NULL, 17, 1, 1, NULL, NULL, 0, 0),
(10, '00:00', '00:00', '0', NULL, NULL, 17, 3, 1, NULL, NULL, 0, 0),
(11, '00:00', '00:00', '0', NULL, NULL, 17, 4, 1, NULL, NULL, 0, 0),
(12, '00:00', '00:00', '0', NULL, NULL, 17, 5, 1, NULL, NULL, 0, 0),
(13, '00:00', '00:00', '0', NULL, NULL, 17, 6, 1, NULL, NULL, 0, 0),
(14, '00:00', '00:00', '0', NULL, NULL, 17, 7, 1, NULL, NULL, 0, 0),
(15, '00:00', '00:00', '0', NULL, NULL, 17, 8, 1, NULL, NULL, 0, 0),
(16, '00:00', '00:00', '0', NULL, NULL, 17, 9, 1, NULL, NULL, 0, 0),
(17, '00:00', '00:00', '0', NULL, NULL, 17, 10, 1, NULL, NULL, 0, 0),
(18, '00:00', '00:00', '0', NULL, NULL, 19, 1, 1, NULL, NULL, 0, 0),
(19, '00:00', '00:00', '0', NULL, NULL, 19, 3, 1, NULL, NULL, 0, 0),
(20, '00:00', '00:00', '0', NULL, NULL, 19, 4, 1, NULL, NULL, 0, 0),
(21, '00:00', '00:00', '0', NULL, NULL, 36, 1, 1, NULL, NULL, 0, 0),
(22, '00:00', '00:00', '0', NULL, NULL, 36, 2, 1, NULL, NULL, 0, 0),
(23, '00:00', '00:00', '0', NULL, NULL, 36, 3, 1, NULL, NULL, 0, 0),
(24, '00:00', '00:00', '0', NULL, NULL, 36, 4, 1, NULL, NULL, 0, 0),
(25, '00:00', '00:00', '0', NULL, NULL, 36, 5, 1, NULL, NULL, 0, 0),
(26, '00:00', '00:00', '0', NULL, NULL, 36, 6, 1, NULL, NULL, 0, 0),
(27, '00:00', '00:00', '0', NULL, NULL, 36, 7, 1, NULL, NULL, 0, 0),
(28, '00:00', '00:00', '0', NULL, NULL, 36, 8, 1, NULL, NULL, 0, 0),
(29, '00:00', '00:00', '0', NULL, NULL, 36, 10, 1, NULL, NULL, 0, 0),
(30, '00:00', '90:37', '0', '2019-01-28', NULL, 37, 1, 2, '2019-01-30 16:11:03', '2019-01-30 16:11:15', 12, 0),
(31, '00:00', '00:00', '0', NULL, NULL, 37, 2, 1, NULL, NULL, 0, 0),
(32, '00:00', '00:00', '0', NULL, NULL, 37, 3, 1, NULL, NULL, 0, 0),
(33, '00:00', '00:00', '0', NULL, NULL, 37, 4, 1, NULL, NULL, 0, 0),
(34, '00:00', '00:00', '0', NULL, NULL, 37, 5, 1, NULL, NULL, 0, 0),
(35, '00:00', '00:00', '0', NULL, NULL, 37, 6, 1, NULL, NULL, 0, 0),
(36, '00:00', '00:00', '0', NULL, NULL, 37, 7, 1, NULL, NULL, 0, 0),
(37, '00:00', '00:00', '0', NULL, NULL, 37, 8, 1, NULL, NULL, 0, 0),
(38, '00:00', '00:00', '0', NULL, NULL, 37, 9, 1, NULL, NULL, 0, 0),
(39, '00:00', '00:00', '0', NULL, NULL, 37, 10, 1, NULL, NULL, 0, 0),
(40, '00:00', '00:00', '0', NULL, NULL, 38, 1, 1, NULL, NULL, 0, 0),
(41, '00:00', '00:00', '0', NULL, NULL, 38, 2, 1, NULL, NULL, 0, 0),
(42, '00:00', '00:00', '0', NULL, NULL, 38, 3, 1, NULL, NULL, 0, 0),
(43, '00:00', '00:00', '0', NULL, NULL, 38, 4, 1, NULL, NULL, 0, 0),
(44, '00:00', '00:00', '0', NULL, NULL, 38, 5, 1, NULL, NULL, 0, 0),
(45, '00:00', '00:00', '0', NULL, NULL, 38, 6, 1, NULL, NULL, 0, 0),
(46, '00:00', '00:00', '0', NULL, NULL, 38, 7, 1, NULL, NULL, 0, 0),
(47, '00:00', '00:00', '0', NULL, NULL, 38, 8, 1, NULL, NULL, 0, 0),
(48, '00:00', '00:00', '0', NULL, NULL, 38, 10, 1, NULL, NULL, 0, 0),
(49, '00:00', '00:00', '0', NULL, NULL, 39, 1, 1, NULL, NULL, 0, 0),
(50, '00:00', '00:00', '0', NULL, NULL, 39, 2, 1, NULL, NULL, 0, 0),
(51, '00:00', '00:00', '0', NULL, NULL, 39, 3, 1, NULL, NULL, 0, 0),
(52, '00:00', '00:00', '0', NULL, NULL, 39, 4, 1, NULL, NULL, 0, 0),
(53, '00:00', '00:00', '0', NULL, NULL, 39, 5, 1, NULL, NULL, 0, 0),
(54, '00:00', '00:00', '0', NULL, NULL, 39, 6, 1, NULL, NULL, 0, 0),
(55, '00:00', '00:00', '0', NULL, NULL, 39, 7, 1, NULL, NULL, 0, 0),
(56, '00:00', '00:00', '0', NULL, NULL, 39, 8, 1, NULL, NULL, 0, 0),
(57, '00:00', '00:00', '0', NULL, NULL, 39, 10, 1, NULL, NULL, 0, 0),
(61, '00:00', '00:00', '0', NULL, NULL, 44, 1, 1, NULL, NULL, 0, 0),
(62, '00:00', '00:00', '0', NULL, NULL, 44, 3, 1, NULL, NULL, 0, 0),
(63, '00:00', '00:00', '0', NULL, NULL, 44, 4, 1, NULL, NULL, 0, 0),
(64, '00:00', '00:00', '0', NULL, NULL, 44, 5, 1, NULL, NULL, 0, 0),
(65, '00:00', '00:00', '0', NULL, NULL, 44, 6, 1, NULL, NULL, 0, 0),
(66, '00:00', '00:00', '0', NULL, NULL, 44, 7, 1, NULL, NULL, 0, 0),
(67, '00:00', '00:00', '0', NULL, NULL, 44, 8, 1, NULL, NULL, 0, 0),
(68, '00:00', '00:00', '0', NULL, NULL, 44, 10, 1, NULL, NULL, 0, 0),
(69, '00:00', '00:00', '0', NULL, NULL, 45, 1, 1, NULL, NULL, 0, 0),
(70, '00:00', '00:00', '0', NULL, NULL, 45, 3, 1, NULL, NULL, 0, 0),
(71, '00:00', '00:00', '0', NULL, NULL, 45, 4, 1, NULL, NULL, 0, 0),
(72, '00:00', '00:00', '0', NULL, NULL, 45, 5, 1, NULL, NULL, 0, 0),
(73, '00:00', '00:00', '0', NULL, NULL, 45, 6, 1, NULL, NULL, 0, 0),
(74, '00:00', '00:00', '0', NULL, NULL, 45, 7, 1, NULL, NULL, 0, 0),
(75, '00:00', '00:00', '0', NULL, NULL, 45, 8, 1, NULL, NULL, 0, 0),
(76, '00:00', '00:00', '0', NULL, NULL, 45, 10, 1, NULL, NULL, 0, 0),
(101, '00:00', '00:00', '0', NULL, NULL, 84, 1, 1, NULL, NULL, 0, 0),
(102, '00:00', '00:00', '0', NULL, NULL, 84, 2, 1, NULL, NULL, 0, 0),
(103, '00:00', '00:00', '0', NULL, NULL, 84, 3, 1, NULL, NULL, 0, 0),
(104, '00:00', '00:00', '0', NULL, NULL, 84, 4, 1, NULL, NULL, 0, 0),
(105, '00:00', '00:00', '0', NULL, NULL, 84, 5, 1, NULL, NULL, 0, 0),
(106, '00:00', '00:00', '0', NULL, NULL, 84, 6, 1, NULL, NULL, 0, 0),
(107, '00:00', '00:00', '0', NULL, NULL, 84, 7, 1, NULL, NULL, 0, 0),
(108, '00:00', '00:00', '0', NULL, NULL, 84, 8, 1, NULL, NULL, 0, 0),
(109, '00:00', '00:00', '0', NULL, NULL, 84, 9, 1, NULL, NULL, 0, 0),
(110, '00:00', '00:00', '0', NULL, NULL, 84, 10, 1, NULL, NULL, 0, 0),
(111, '00:00', '00:00', '0', NULL, NULL, 85, 1, 1, NULL, NULL, 0, 0),
(112, '00:00', '00:00', '0', NULL, NULL, 85, 2, 1, NULL, NULL, 0, 0),
(113, '00:00', '00:00', '0', NULL, NULL, 85, 3, 1, NULL, NULL, 0, 0),
(114, '00:00', '00:00', '0', NULL, NULL, 85, 4, 1, NULL, NULL, 0, 0),
(115, '00:00', '00:00', '0', NULL, NULL, 85, 5, 1, NULL, NULL, 0, 0),
(116, '00:00', '00:00', '0', NULL, NULL, 85, 6, 1, NULL, NULL, 0, 0),
(117, '00:00', '00:00', '0', NULL, NULL, 85, 7, 1, NULL, NULL, 0, 0),
(118, '00:00', '00:00', '0', NULL, NULL, 85, 8, 1, NULL, NULL, 0, 0),
(119, '00:00', '00:00', '0', NULL, NULL, 85, 9, 1, NULL, NULL, 0, 0),
(120, '00:00', '00:00', '0', NULL, NULL, 85, 10, 1, NULL, NULL, 0, 0),
(121, '00:00', '00:00', '0', NULL, NULL, 87, 1, 1, NULL, NULL, 0, 0),
(122, '00:00', '00:00', '0', NULL, NULL, 87, 2, 1, NULL, NULL, 0, 0),
(123, '00:00', '00:00', '0', NULL, NULL, 87, 3, 1, NULL, NULL, 0, 0),
(124, '00:00', '00:00', '0', NULL, NULL, 87, 4, 1, NULL, NULL, 0, 0),
(125, '00:00', '00:00', '0', NULL, NULL, 87, 5, 1, NULL, NULL, 0, 0),
(126, '00:00', '00:00', '0', NULL, NULL, 87, 6, 1, NULL, NULL, 0, 0),
(127, '00:00', '00:00', '0', NULL, NULL, 87, 7, 1, NULL, NULL, 0, 0),
(128, '00:00', '00:00', '0', NULL, NULL, 87, 8, 1, NULL, NULL, 0, 0),
(129, '00:00', '00:00', '0', NULL, NULL, 87, 9, 1, NULL, NULL, 0, 0),
(130, '00:00', '00:00', '0', NULL, NULL, 87, 10, 1, NULL, NULL, 0, 0),
(131, '00:00', '00:00', '0', NULL, NULL, 89, 1, 1, NULL, NULL, 0, 0),
(132, '00:00', '00:00', '0', NULL, NULL, 89, 3, 1, NULL, NULL, 0, 0),
(133, '00:00', '00:00', '0', NULL, NULL, 89, 4, 1, NULL, NULL, 0, 0),
(134, '00:00', '00:00', '0', NULL, NULL, 89, 5, 1, NULL, NULL, 0, 0),
(135, '00:00', '00:00', '0', NULL, NULL, 89, 6, 1, NULL, NULL, 0, 0),
(136, '00:00', '00:00', '0', NULL, NULL, 89, 7, 1, NULL, NULL, 0, 0),
(137, '00:00', '00:00', '0', NULL, NULL, 89, 8, 1, NULL, NULL, 0, 0),
(138, '00:00', '00:00', '0', NULL, NULL, 89, 10, 1, NULL, NULL, 0, 0),
(139, '00:00', '00:00', '0', NULL, NULL, 90, 1, 1, NULL, NULL, 0, 0),
(140, '00:00', '00:00', '0', NULL, NULL, 90, 2, 1, NULL, NULL, 0, 0),
(141, '00:00', '00:00', '0', NULL, NULL, 90, 3, 1, NULL, NULL, 0, 0),
(142, '00:00', '00:00', '0', NULL, NULL, 90, 4, 1, NULL, NULL, 0, 0),
(143, '00:00', '00:00', '0', NULL, NULL, 90, 5, 1, NULL, NULL, 0, 0),
(144, '00:00', '00:00', '0', NULL, NULL, 90, 6, 1, NULL, NULL, 0, 0),
(145, '00:00', '00:00', '0', NULL, NULL, 90, 7, 1, NULL, NULL, 0, 0),
(146, '00:00', '00:00', '0', NULL, NULL, 90, 8, 1, NULL, NULL, 0, 0),
(147, '00:00', '00:00', '0', NULL, NULL, 90, 10, 1, NULL, NULL, 0, 0),
(148, '28:02', '140:14', '5', '2019-01-29', '2019-01-29', 91, 1, 3, '2019-01-29 10:41:41', '2019-01-29 13:01:55', 0, 0),
(149, '100:47', '503:56', '5', '2019-01-30', '2019-01-30', 91, 2, 3, '2019-01-30 06:15:55', '2019-01-30 14:39:51', 0, 0),
(150, '02:28', '12:21', '5', '2019-01-31', '2019-01-31', 91, 3, 3, '2019-01-31 09:03:52', '2019-01-31 09:16:13', 0, 0),
(151, '16:48', '84:04', '5', '2019-01-31', '2019-01-31', 91, 4, 3, '2019-01-31 10:02:11', '2019-01-31 11:26:15', 0, 0),
(152, '00:00', '00:00', '0', NULL, NULL, 91, 5, 1, NULL, NULL, 0, 0),
(153, '12:13', '61:06', '5', '2019-01-31', '2019-01-31', 91, 6, 3, '2019-01-31 16:25:31', '2019-01-31 17:26:37', 0, 0),
(154, '00:00', '00:00', '0', NULL, NULL, 91, 7, 1, NULL, NULL, 0, 0),
(155, '00:00', '00:00', '0', NULL, NULL, 91, 8, 1, NULL, NULL, 0, 0),
(156, '00:00', '00:00', '0', NULL, NULL, 91, 10, 1, NULL, NULL, 0, 0),
(157, '23:39', '141:57', '6', '2019-01-29', '2019-01-29', 92, 1, 3, '2019-01-29 13:25:48', '2019-01-29 15:47:24', 0, 0),
(158, '138:36', '831:41', '6', '2019-01-30', '2019-01-31', 92, 2, 3, '2019-01-31 06:14:27', '2019-01-31 06:14:47', 0, 0),
(159, '00:00', '44:56', '0', '2019-01-31', NULL, 92, 3, 4, '2019-01-31 14:59:22', NULL, 6, 1),
(160, '00:00', '00:00', '0', NULL, NULL, 92, 4, 1, NULL, NULL, 0, 0),
(161, '00:00', '00:00', '0', NULL, NULL, 92, 5, 1, NULL, NULL, 0, 0),
(162, '00:00', '93:32', '0', '2019-02-01', NULL, 92, 6, 4, '2019-02-04 07:10:42', NULL, 6, 1),
(163, '00:02', '00:15', '6', '2019-02-04', '2019-02-04', 92, 7, 3, '2019-02-04 08:07:28', '2019-02-04 08:07:43', 0, 0),
(164, '00:01', '00:11', '6', '2019-02-04', '2019-02-04', 92, 8, 3, '2019-02-04 08:08:05', '2019-02-04 08:08:16', 0, 0),
(165, '00:00', '00:00', '0', NULL, NULL, 92, 10, 1, NULL, NULL, 0, 0),
(166, '03:10', '15:51', '5', '2019-01-29', '2019-01-29', 93, 1, 3, '2019-01-29 14:19:39', '2019-01-29 14:35:30', 0, 0),
(167, '100:57', '504:46', '5', '2019-01-30', '2019-01-30', 93, 2, 3, '2019-01-30 06:15:31', '2019-01-30 14:40:17', 0, 0),
(168, '07:02', '35:11', '5', '2019-01-31', '2019-01-31', 93, 3, 3, '2019-01-31 10:14:22', '2019-01-31 10:14:58', 0, 0),
(169, '00:02', '00:14', '5', '2019-01-31', '2019-01-31', 93, 4, 3, '2019-01-31 11:50:07', '2019-01-31 11:50:21', 0, 0),
(170, '00:00', '00:00', '0', NULL, NULL, 93, 5, 1, NULL, NULL, 0, 0),
(171, '14:52', '74:24', '5', '2019-01-31', '2019-01-31', 93, 6, 3, '2019-01-31 16:11:56', '2019-01-31 17:26:20', 0, 0),
(172, '00:05', '00:25', '5', '2019-02-01', '2019-02-01', 93, 7, 3, '2019-02-01 06:41:06', '2019-02-01 06:41:31', 0, 0),
(173, '00:50', '04:12', '5', '2019-02-01', '2019-02-01', 93, 8, 3, '2019-02-01 06:42:02', '2019-02-01 06:46:14', 0, 0),
(174, '00:00', '00:00', '0', NULL, NULL, 93, 10, 1, NULL, NULL, 0, 0),
(178, '00:00', '00:00', '0', NULL, NULL, 98, 1, 1, NULL, NULL, 0, 0),
(179, '00:00', '00:00', '0', NULL, NULL, 98, 2, 1, NULL, NULL, 0, 0),
(180, '00:00', '00:00', '0', NULL, NULL, 98, 3, 1, NULL, NULL, 0, 0),
(181, '00:00', '00:00', '0', NULL, NULL, 98, 4, 1, NULL, NULL, 0, 0),
(182, '00:00', '00:00', '0', NULL, NULL, 98, 5, 1, NULL, NULL, 0, 0),
(183, '00:00', '00:00', '0', NULL, NULL, 98, 6, 1, NULL, NULL, 0, 0),
(184, '00:00', '00:00', '0', NULL, NULL, 98, 7, 1, NULL, NULL, 0, 0),
(185, '00:00', '00:00', '0', NULL, NULL, 98, 8, 1, NULL, NULL, 0, 0),
(186, '00:00', '00:00', '0', NULL, NULL, 98, 10, 1, NULL, NULL, 0, 0),
(190, '01:01', '102:00', '100', '2019-01-30', '2019-01-30', 103, 1, 3, '2019-01-30 07:59:42', '2019-01-30 09:41:42', 0, 0),
(191, '15:20', '1534:03', '100', '2019-01-31', '2019-02-01', 103, 2, 3, '2019-01-31 08:28:08', '2019-02-01 10:02:11', 0, 0),
(192, '00:00', '153:39', '0', '2019-02-01', NULL, 103, 3, 2, '2019-02-01 13:57:04', '2019-02-01 14:26:52', 100, 0),
(193, '00:00', '00:00', '0', NULL, NULL, 103, 4, 1, NULL, NULL, 0, 0),
(194, '00:00', '00:00', '0', NULL, NULL, 103, 5, 1, NULL, NULL, 0, 0),
(195, '00:00', '148:23', '0', '2019-02-04', NULL, 103, 6, 2, '2019-02-04 14:04:00', '2019-02-04 16:32:23', 100, 0),
(196, '00:00', '00:00', '0', NULL, NULL, 103, 7, 1, NULL, NULL, 0, 0),
(197, '00:00', '00:00', '0', NULL, NULL, 103, 8, 1, NULL, NULL, 0, 0),
(198, '00:00', '00:00', '0', NULL, NULL, 103, 10, 1, NULL, NULL, 0, 0),
(199, '00:22', '38:07', '100', '2019-01-29', '2019-01-29', 104, 1, 3, '2019-01-29 16:16:29', '2019-01-29 16:27:17', 0, 0),
(200, '00:00', '1088:24', '0', '2019-02-01', NULL, 104, 2, 2, '2019-02-04 06:47:17', '2019-02-04 16:02:14', 100, 0),
(201, '00:00', '261:25', '0', '2019-02-04', NULL, 104, 3, 2, '2019-02-04 11:42:00', '2019-02-04 15:09:57', 100, 0),
(202, '00:00', '00:00', '0', NULL, NULL, 104, 4, 1, NULL, NULL, 0, 0),
(203, '00:00', '00:00', '0', NULL, NULL, 104, 5, 1, NULL, NULL, 0, 0),
(204, '14:43', '1472:56', '100', '2019-02-06', '2019-02-08', 104, 6, 3, '2019-02-07 08:09:24', '2019-02-08 07:37:54', 0, 0),
(205, '00:00', '00:00', '0', NULL, NULL, 104, 7, 1, NULL, NULL, 0, 0),
(206, '00:00', '00:00', '0', NULL, NULL, 104, 8, 1, NULL, NULL, 0, 0),
(207, '00:00', '00:00', '0', NULL, NULL, 104, 10, 1, NULL, NULL, 0, 0),
(208, '03:49', '76:31', '20', '2019-01-30', '2019-01-30', 105, 1, 3, '2019-01-30 14:55:33', '2019-01-30 16:12:04', 0, 0),
(209, '00:00', '50:42', '0', '2019-01-30', NULL, 105, 3, 2, '2019-01-30 15:20:27', '2019-01-30 16:11:09', 20, 0),
(210, '00:00', '00:18', '20', '2019-01-31', '2019-01-31', 105, 4, 3, '2019-01-31 09:00:46', '2019-01-31 09:01:04', 0, 0),
(211, '00:00', '00:00', '0', NULL, NULL, 105, 5, 1, NULL, NULL, 0, 0),
(212, '03:14', '64:52', '20', '2019-01-31', '2019-01-31', 105, 6, 3, '2019-01-31 10:10:12', '2019-01-31 11:15:04', 0, 0),
(213, '00:00', '00:00', '0', NULL, NULL, 105, 7, 1, NULL, NULL, 0, 0),
(214, '00:00', '00:00', '0', NULL, NULL, 105, 8, 1, NULL, NULL, 0, 0),
(215, '00:00', '00:00', '0', NULL, NULL, 105, 10, 1, NULL, NULL, 0, 0),
(216, '07:45', '15:30', '2', '2019-01-29', '2019-01-29', 106, 1, 3, '2019-01-29 14:19:47', '2019-01-29 14:35:17', 0, 0),
(217, '250:31', '501:03', '2', '2019-01-30', '2019-01-30', 106, 2, 3, '2019-01-30 06:15:17', '2019-01-30 14:36:20', 0, 0),
(218, '00:03', '00:07', '2', '2019-01-31', '2019-01-31', 106, 3, 3, '2019-01-31 06:23:36', '2019-01-31 06:23:43', 0, 0),
(219, '17:47', '35:34', '2', '2019-01-30', '2019-01-30', 106, 4, 3, '2019-01-30 14:12:47', '2019-01-30 14:48:21', 0, 0),
(220, '00:07', '00:15', '2', '2019-01-30', '2019-01-30', 106, 5, 3, '2019-01-30 15:22:18', '2019-01-30 15:22:33', 0, 0),
(221, '29:09', '58:19', '2', '2019-01-31', '2019-01-31', 106, 6, 3, '2019-01-31 10:15:57', '2019-01-31 11:14:16', 0, 0),
(222, '00:00', '00:00', '0', NULL, NULL, 106, 7, 1, NULL, NULL, 0, 0),
(223, '00:00', '00:00', '0', NULL, NULL, 106, 8, 1, NULL, NULL, 0, 0),
(224, '00:00', '00:00', '0', NULL, NULL, 106, 10, 1, NULL, NULL, 0, 0),
(225, '00:00', '00:00', '0', NULL, NULL, 108, 1, 1, NULL, NULL, 0, 0),
(226, '00:00', '00:00', '0', NULL, NULL, 108, 2, 1, NULL, NULL, 0, 0),
(227, '00:00', '00:00', '0', NULL, NULL, 108, 3, 1, NULL, NULL, 0, 0),
(228, '00:00', '00:00', '0', NULL, NULL, 108, 4, 1, NULL, NULL, 0, 0),
(229, '00:00', '00:00', '0', NULL, NULL, 108, 5, 1, NULL, NULL, 0, 0),
(230, '00:00', '00:00', '0', NULL, NULL, 108, 6, 1, NULL, NULL, 0, 0),
(231, '00:00', '00:00', '0', NULL, NULL, 108, 7, 1, NULL, NULL, 0, 0),
(232, '00:00', '00:00', '0', NULL, NULL, 108, 8, 1, NULL, NULL, 0, 0),
(233, '00:00', '00:00', '0', NULL, NULL, 108, 10, 1, NULL, NULL, 0, 0),
(234, '00:00', '00:00', '0', NULL, NULL, 109, 1, 1, NULL, NULL, 0, 0),
(235, '00:00', '00:00', '0', NULL, NULL, 109, 2, 1, NULL, NULL, 0, 0),
(236, '00:00', '00:00', '0', NULL, NULL, 109, 3, 1, NULL, NULL, 0, 0),
(237, '00:00', '00:00', '0', NULL, NULL, 109, 4, 1, NULL, NULL, 0, 0),
(238, '00:00', '00:00', '0', NULL, NULL, 109, 5, 1, NULL, NULL, 0, 0),
(239, '00:00', '00:00', '0', NULL, NULL, 109, 6, 1, NULL, NULL, 0, 0),
(240, '00:00', '00:00', '0', NULL, NULL, 109, 7, 1, NULL, NULL, 0, 0),
(241, '00:00', '00:00', '0', NULL, NULL, 109, 8, 1, NULL, NULL, 0, 0),
(242, '00:00', '00:00', '0', NULL, NULL, 109, 10, 1, NULL, NULL, 0, 0),
(243, '02:44', '27:29', '10', '2019-02-04', '2019-02-04', 110, 1, 3, '2019-02-04 09:44:36', '2019-02-04 10:12:05', 0, 0),
(244, '00:00', '22:23', '0', '2019-02-04', NULL, 110, 3, 2, '2019-02-04 10:47:10', '2019-02-04 11:09:33', 10, 0),
(245, '00:00', '00:00', '0', NULL, NULL, 110, 4, 1, NULL, NULL, 0, 0),
(246, '00:00', '00:00', '0', NULL, NULL, 110, 5, 1, NULL, NULL, 0, 0),
(247, '00:00', '00:00', '0', NULL, NULL, 110, 6, 1, NULL, NULL, 0, 0),
(248, '00:00', '00:00', '0', NULL, NULL, 110, 7, 1, NULL, NULL, 0, 0),
(249, '00:00', '00:00', '0', NULL, NULL, 110, 8, 1, NULL, NULL, 0, 0),
(250, '00:00', '00:00', '0', NULL, NULL, 110, 10, 1, NULL, NULL, 0, 0),
(251, '126:31', '1265:12', '10', '2019-02-04', '2019-02-05', 111, 1, 3, '2019-02-04 09:44:29', '2019-02-05 06:49:41', 0, 0),
(252, '00:00', '23:53', '0', '2019-02-04', NULL, 111, 3, 2, '2019-02-04 10:47:01', '2019-02-04 11:10:54', 10, 0),
(253, '02:31', '25:12', '10', '2019-02-05', '2019-02-05', 111, 4, 3, '2019-02-05 06:48:50', '2019-02-05 07:14:02', 0, 0),
(254, '00:03', '00:32', '10', '2019-02-05', '2019-02-05', 111, 5, 3, '2019-02-05 07:17:09', '2019-02-05 07:17:41', 0, 0),
(255, '00:00', '00:00', '0', NULL, NULL, 111, 6, 1, NULL, NULL, 0, 0),
(256, '00:00', '00:00', '0', NULL, NULL, 111, 7, 1, NULL, NULL, 0, 0),
(257, '00:00', '00:00', '0', NULL, NULL, 111, 8, 1, NULL, NULL, 0, 0),
(258, '00:00', '00:00', '0', NULL, NULL, 111, 10, 1, NULL, NULL, 0, 0),
(259, '04:34', '18:19', '4', '2019-01-31', '2019-01-31', 112, 1, 3, '2019-01-31 09:15:43', '2019-01-31 09:34:02', 0, 0),
(260, '61:21', '245:24', '4', '2019-01-31', '2019-01-31', 112, 2, 3, '2019-01-31 09:46:25', '2019-01-31 13:51:49', 0, 0),
(261, '00:00', '21:42', '0', '2019-01-31', NULL, 112, 3, 4, '2019-01-31 14:43:37', NULL, 4, 1),
(262, '00:00', '00:00', '0', NULL, NULL, 112, 4, 1, NULL, NULL, 0, 0),
(263, '05:41', '22:47', '4', '2019-02-01', '2019-02-01', 112, 5, 3, '2019-02-01 06:19:20', '2019-02-01 06:42:07', 0, 0),
(264, '14:15', '57:03', '4', '2019-02-01', '2019-02-01', 112, 6, 3, '2019-02-01 10:41:08', '2019-02-01 10:44:57', 0, 0),
(265, '00:00', '00:00', '0', NULL, NULL, 112, 7, 1, NULL, NULL, 0, 0),
(266, '00:00', '00:00', '0', NULL, NULL, 112, 8, 1, NULL, NULL, 0, 0),
(267, '00:00', '00:00', '0', NULL, NULL, 112, 10, 1, NULL, NULL, 0, 0),
(268, '174:05', '174:05', '1', '2019-01-30', '2019-01-30', 113, 1, 3, '2019-01-30 12:31:41', '2019-01-30 12:32:01', 0, 0),
(269, '836:58', '836:58', '1', '2019-01-30', '2019-01-31', 113, 2, 3, '2019-01-30 16:18:25', '2019-01-31 06:15:23', 0, 0),
(270, '00:00', '18:52', '0', '2019-01-31', NULL, 113, 3, 4, '2019-01-31 09:35:02', NULL, 1, 1),
(271, '96:37', '96:37', '1', '2019-01-31', '2019-01-31', 113, 4, 3, '2019-01-31 09:50:21', '2019-01-31 11:26:58', 0, 0),
(272, '09:51', '09:51', '1', '2019-01-31', '2019-01-31', 113, 5, 3, '2019-01-31 13:39:15', '2019-01-31 13:49:06', 0, 0),
(273, '42:47', '42:47', '1', '2019-01-31', '2019-01-31', 113, 6, 3, '2019-01-31 15:28:32', '2019-01-31 16:11:19', 0, 0),
(274, '00:00', '00:00', '0', NULL, NULL, 113, 7, 1, NULL, NULL, 0, 0),
(275, '00:00', '00:00', '0', NULL, NULL, 113, 8, 1, NULL, NULL, 0, 0),
(276, '00:00', '00:00', '0', NULL, NULL, 113, 10, 1, NULL, NULL, 0, 0),
(277, '00:27', '04:38', '10', '2019-01-31', '2019-01-31', 114, 1, 3, '2019-01-31 10:12:28', '2019-01-31 10:17:06', 0, 0),
(278, '02:37', '26:14', '10', '2019-01-31', '2019-01-31', 114, 3, 3, '2019-01-31 11:12:32', '2019-01-31 11:27:33', 0, 0),
(279, '00:00', '81:59', '0', '2019-01-31', NULL, 114, 4, 2, '2019-01-31 11:29:20', '2019-01-31 12:51:19', 10, 0),
(280, '00:00', '00:00', '0', NULL, NULL, 114, 5, 1, NULL, NULL, 0, 0),
(281, '04:12', '42:00', '10', '2019-02-01', '2019-02-01', 114, 6, 3, '2019-02-01 10:34:21', '2019-02-01 11:08:29', 0, 0),
(282, '00:00', '00:00', '0', NULL, NULL, 114, 7, 1, NULL, NULL, 0, 0),
(283, '00:00', '00:00', '0', NULL, NULL, 114, 8, 1, NULL, NULL, 0, 0),
(284, '00:00', '00:00', '0', NULL, NULL, 114, 10, 1, NULL, NULL, 0, 0),
(285, '02:35', '25:52', '10', '2019-01-31', '2019-01-31', 115, 1, 3, '2019-01-31 09:42:26', '2019-01-31 10:08:18', 0, 0),
(286, '00:00', '00:00', '0', '2019-02-01', NULL, 115, 2, 4, '2019-02-01 10:28:34', NULL, 0, 1),
(287, '01:36', '16:07', '10', '2019-02-04', '2019-02-04', 115, 3, 3, '2019-02-04 07:47:27', '2019-02-04 08:03:34', 0, 0),
(288, '00:00', '00:00', '0', NULL, NULL, 115, 4, 1, NULL, NULL, 0, 0),
(289, '00:00', '00:00', '0', NULL, NULL, 115, 5, 1, NULL, NULL, 0, 0),
(290, '00:00', '00:00', '0', NULL, NULL, 115, 6, 1, NULL, NULL, 0, 0),
(291, '00:00', '00:00', '0', NULL, NULL, 115, 7, 1, NULL, NULL, 0, 0),
(292, '00:00', '00:00', '0', NULL, NULL, 115, 8, 1, NULL, NULL, 0, 0),
(293, '00:00', '00:00', '0', NULL, NULL, 115, 10, 1, NULL, NULL, 0, 0),
(294, '00:00', '00:00', '0', NULL, NULL, 116, 1, 1, NULL, NULL, 0, 0),
(295, '00:24', '04:08', '10', '2019-02-06', '2019-02-06', 116, 3, 3, '2019-02-06 06:26:15', '2019-02-06 06:30:23', 0, 0),
(296, '12:49', '128:12', '10', '2019-02-06', '2019-02-06', 116, 4, 3, '2019-02-06 07:09:05', '2019-02-06 09:17:17', 0, 0),
(297, '00:15', '02:37', '10', '2019-02-06', '2019-02-06', 116, 5, 3, '2019-02-06 09:33:18', '2019-02-06 09:35:55', 0, 0),
(298, '05:53', '58:59', '10', '2019-02-06', '2019-02-06', 116, 6, 3, '2019-02-06 11:26:50', '2019-02-06 12:25:49', 0, 0),
(299, '00:00', '00:00', '0', NULL, NULL, 116, 7, 1, NULL, NULL, 0, 0),
(300, '00:00', '00:00', '0', NULL, NULL, 116, 8, 1, NULL, NULL, 0, 0),
(301, '00:00', '00:00', '0', NULL, NULL, 116, 10, 1, NULL, NULL, 0, 0),
(302, '87:34', '875:49', '10', '2019-02-04', '2019-02-05', 117, 1, 3, '2019-02-04 16:11:42', '2019-02-05 06:47:31', 0, 0),
(303, '00:00', '7440:14', '2', '2019-02-06', NULL, 117, 2, 2, '2019-02-06 10:20:14', '2019-02-11 14:20:28', 8, 0),
(304, '05:53', '58:51', '10', '2019-02-06', '2019-02-06', 117, 3, 3, '2019-02-06 13:28:59', '2019-02-06 13:45:52', 0, 0),
(305, '00:00', '00:00', '0', NULL, NULL, 117, 4, 1, NULL, NULL, 0, 0),
(306, '00:00', '00:00', '0', NULL, NULL, 117, 5, 1, NULL, NULL, 0, 0),
(307, '08:01', '80:13', '10', '2019-02-07', '2019-02-07', 117, 6, 3, '2019-02-07 15:08:17', '2019-02-07 15:40:48', 0, 0),
(308, '00:00', '00:00', '0', NULL, NULL, 117, 7, 1, NULL, NULL, 0, 0),
(309, '00:00', '00:00', '0', NULL, NULL, 117, 8, 1, NULL, NULL, 0, 0),
(310, '00:00', '00:00', '0', NULL, NULL, 117, 10, 1, NULL, NULL, 0, 0),
(311, '00:00', '00:00', '0', NULL, NULL, 118, 1, 1, NULL, NULL, 0, 0),
(312, '01:14', '12:24', '10', '2019-02-06', '2019-02-06', 118, 3, 3, '2019-02-06 06:25:52', '2019-02-06 06:38:16', 0, 0),
(313, '13:42', '137:05', '10', '2019-02-06', '2019-02-06', 118, 4, 3, '2019-02-06 06:59:36', '2019-02-06 09:16:41', 0, 0),
(314, '00:25', '04:19', '10', '2019-02-06', '2019-02-06', 118, 5, 3, '2019-02-06 09:28:03', '2019-02-06 09:32:22', 0, 0),
(315, '05:59', '59:57', '10', '2019-02-06', '2019-02-06', 118, 6, 3, '2019-02-06 11:27:07', '2019-02-06 12:27:04', 0, 0),
(316, '00:00', '00:00', '0', NULL, NULL, 118, 7, 1, NULL, NULL, 0, 0),
(317, '00:00', '00:00', '0', NULL, NULL, 118, 8, 1, NULL, NULL, 0, 0),
(318, '00:00', '00:00', '0', NULL, NULL, 118, 10, 1, NULL, NULL, 0, 0),
(319, '00:00', '00:00', '0', NULL, NULL, 119, 1, 1, NULL, NULL, 0, 0),
(320, '00:00', '00:00', '0', '2019-02-06', NULL, 119, 3, 4, '2019-02-06 06:38:43', NULL, 10, 1),
(321, '10:58', '109:46', '10', '2019-02-06', '2019-02-06', 119, 4, 3, '2019-02-06 07:27:59', '2019-02-06 09:17:45', 0, 0),
(322, '01:01', '10:10', '10', '2019-02-06', '2019-02-06', 119, 5, 3, '2019-02-06 09:36:59', '2019-02-06 09:47:09', 0, 0),
(323, '09:39', '96:31', '10', '2019-02-06', '2019-02-06', 119, 6, 3, '2019-02-06 13:11:55', '2019-02-06 13:34:30', 0, 0),
(324, '00:00', '00:00', '0', NULL, NULL, 119, 7, 1, NULL, NULL, 0, 0),
(325, '00:00', '00:00', '0', NULL, NULL, 119, 8, 1, NULL, NULL, 0, 0),
(326, '00:00', '00:00', '0', NULL, NULL, 119, 10, 1, NULL, NULL, 0, 0),
(327, '3353:5', '6707:47', '2', '2019-01-31', '2019-02-05', 120, 1, 3, '2019-01-31 15:30:28', '2019-02-05 07:18:15', 0, 0),
(328, '158:52', '317:45', '2', '2019-02-01', '2019-02-01', 120, 2, 3, '2019-02-01 07:39:44', '2019-02-01 12:57:29', 0, 0),
(329, '03:38', '07:17', '2', '2019-02-01', '2019-02-01', 120, 3, 3, '2019-02-01 15:45:00', '2019-02-01 15:52:17', 0, 0),
(330, '00:00', '00:00', '0', NULL, NULL, 120, 4, 1, NULL, NULL, 0, 0),
(331, '00:00', '00:00', '0', NULL, NULL, 120, 5, 1, NULL, NULL, 0, 0),
(332, '30:24', '60:49', '2', '2019-02-04', '2019-02-04', 120, 6, 3, '2019-02-04 08:46:06', '2019-02-04 08:54:38', 0, 0),
(333, '00:05', '00:11', '2', '2019-02-04', '2019-02-04', 120, 7, 3, '2019-02-04 09:14:18', '2019-02-04 09:14:29', 0, 0),
(334, '03:23', '06:46', '2', '2019-02-04', '2019-02-04', 120, 8, 3, '2019-02-04 09:16:59', '2019-02-04 09:23:45', 0, 0),
(335, '00:00', '00:00', '0', NULL, NULL, 120, 10, 1, NULL, NULL, 0, 0),
(336, '3346:5', '6693:43', '2', '2019-01-31', '2019-02-05', 121, 1, 3, '2019-01-31 15:30:39', '2019-02-05 07:04:22', 0, 0),
(337, '159:15', '318:31', '2', '2019-02-01', '2019-02-01', 121, 2, 3, '2019-02-01 07:39:12', '2019-02-01 12:57:43', 0, 0),
(338, '03:50', '07:41', '2', '2019-02-01', '2019-02-01', 121, 3, 3, '2019-02-01 15:44:51', '2019-02-01 15:52:32', 0, 0),
(339, '00:00', '00:00', '0', NULL, NULL, 121, 4, 1, NULL, NULL, 0, 0),
(340, '00:00', '00:00', '0', NULL, NULL, 121, 5, 1, NULL, NULL, 0, 0),
(341, '30:24', '60:48', '2', '2019-02-04', '2019-02-04', 121, 6, 3, '2019-02-04 08:45:57', '2019-02-04 08:54:16', 0, 0),
(342, '00:05', '00:10', '2', '2019-02-04', '2019-02-04', 121, 7, 3, '2019-02-04 09:14:00', '2019-02-04 09:14:10', 0, 0),
(343, '03:21', '06:42', '2', '2019-02-04', '2019-02-04', 121, 8, 3, '2019-02-04 09:16:47', '2019-02-04 09:23:29', 0, 0),
(344, '00:00', '00:00', '0', NULL, NULL, 121, 10, 1, NULL, NULL, 0, 0),
(348, '48:35', '48:35', '1', '2019-02-06', '2019-02-06', 127, 1, 3, '2019-02-06 06:34:11', '2019-02-06 07:22:46', 0, 0),
(349, '306:17', '306:17', '1', '2019-02-06', '2019-02-06', 127, 2, 3, '2019-02-06 07:50:34', '2019-02-06 12:56:51', 0, 0),
(350, '39:11', '39:11', '1', '2019-02-06', '2019-02-06', 127, 3, 3, '2019-02-06 13:48:07', '2019-02-06 14:27:18', 0, 0),
(351, '00:00', '00:00', '0', NULL, NULL, 127, 4, 1, NULL, NULL, 0, 0),
(352, '00:00', '00:00', '0', NULL, NULL, 127, 5, 1, NULL, NULL, 0, 0),
(353, '00:00', '00:00', '0', '2019-02-07', NULL, 127, 6, 4, '2019-02-07 08:25:47', NULL, 0, 1),
(354, '00:00', '00:00', '0', NULL, NULL, 127, 7, 1, NULL, NULL, 0, 0),
(355, '00:00', '00:00', '0', NULL, NULL, 127, 8, 1, NULL, NULL, 0, 0),
(356, '00:00', '00:00', '0', NULL, NULL, 127, 10, 1, NULL, NULL, 0, 0),
(360, '02:18', '23:06', '10', '2019-02-04', '2019-02-04', 132, 1, 3, '2019-02-04 07:22:17', '2019-02-04 07:45:23', 0, 0),
(361, '47:15', '472:33', '10', '2019-02-04', '2019-02-04', 132, 2, 3, '2019-02-04 07:56:18', '2019-02-04 15:48:51', 0, 0),
(362, '00:00', '00:00', '0', NULL, NULL, 132, 3, 1, NULL, NULL, 0, 0),
(363, '00:00', '00:00', '0', NULL, NULL, 132, 4, 1, NULL, NULL, 0, 0),
(364, '00:00', '00:00', '0', NULL, NULL, 132, 5, 1, NULL, NULL, 0, 0),
(365, '08:22', '83:43', '10', '2019-02-06', '2019-02-06', 132, 6, 3, '2019-02-06 06:34:16', '2019-02-06 07:57:59', 0, 0),
(366, '00:01', '00:17', '10', '2019-02-06', '2019-02-06', 132, 7, 3, '2019-02-06 08:09:06', '2019-02-06 08:09:23', 0, 0),
(367, '02:14', '22:23', '10', '2019-02-06', '2019-02-06', 132, 8, 3, '2019-02-06 10:20:37', '2019-02-06 10:28:41', 0, 0),
(368, '00:00', '00:00', '0', NULL, NULL, 132, 10, 1, NULL, NULL, 0, 0),
(369, '00:20', '68:40', '200', '2019-02-06', '2019-02-06', 133, 1, 3, '2019-02-06 12:17:51', '2019-02-06 13:26:31', 0, 0),
(370, '00:33', '110:33', '200', '2019-02-07', '2019-02-07', 133, 3, 3, '2019-02-07 09:31:52', '2019-02-07 11:22:25', 0, 0),
(371, '00:00', '00:00', '0', NULL, NULL, 133, 4, 1, NULL, NULL, 0, 0),
(372, '00:00', '00:00', '0', NULL, NULL, 133, 5, 1, NULL, NULL, 0, 0),
(373, '00:00', '00:00', '0', '2019-02-11', NULL, 133, 6, 4, '2019-02-11 16:13:54', NULL, 0, 1),
(374, '00:00', '00:00', '0', NULL, NULL, 133, 7, 1, NULL, NULL, 0, 0),
(375, '00:00', '00:00', '0', NULL, NULL, 133, 8, 1, NULL, NULL, 0, 0),
(376, '00:00', '00:00', '0', NULL, NULL, 133, 10, 1, NULL, NULL, 0, 0),
(377, '00:00', '00:00', '0', NULL, NULL, 134, 1, 1, NULL, NULL, 0, 0),
(378, '00:00', '00:00', '0', NULL, NULL, 134, 2, 1, NULL, NULL, 0, 0),
(379, '00:00', '00:00', '0', NULL, NULL, 134, 3, 1, NULL, NULL, 0, 0),
(380, '00:00', '00:00', '0', NULL, NULL, 134, 4, 1, NULL, NULL, 0, 0),
(381, '00:00', '00:00', '0', NULL, NULL, 134, 5, 1, NULL, NULL, 0, 0),
(382, '00:00', '00:00', '0', NULL, NULL, 134, 6, 1, NULL, NULL, 0, 0),
(383, '00:00', '00:00', '0', NULL, NULL, 134, 7, 1, NULL, NULL, 0, 0),
(384, '00:00', '00:00', '0', NULL, NULL, 134, 8, 1, NULL, NULL, 0, 0),
(385, '00:00', '00:00', '0', NULL, NULL, 134, 10, 1, NULL, NULL, 0, 0),
(386, '92:53', '1114:45', '12', '2019-02-04', '2019-02-05', 135, 1, 3, '2019-02-04 13:34:30', '2019-02-05 06:48:43', 0, 0),
(387, '00:00', '00:00', '0', '2019-02-06', NULL, 135, 2, 4, '2019-02-06 06:37:04', NULL, 0, 1),
(388, '12:38', '151:40', '12', '2019-02-06', '2019-02-06', 135, 3, 3, '2019-02-06 08:53:22', '2019-02-06 10:16:33', 0, 0),
(389, '14:24', '172:53', '12', '2019-02-06', '2019-02-06', 135, 4, 3, '2019-02-06 10:33:01', '2019-02-06 13:25:54', 0, 0),
(390, '00:00', '00:00', '0', NULL, NULL, 135, 5, 1, NULL, NULL, 0, 0),
(391, '17:14', '206:56', '12', '2019-02-07', '2019-02-07', 135, 6, 3, '2019-02-07 15:08:28', '2019-02-07 15:51:41', 0, 0),
(392, '00:00', '00:00', '0', NULL, NULL, 135, 7, 1, NULL, NULL, 0, 0),
(393, '00:00', '00:00', '0', NULL, NULL, 135, 8, 1, NULL, NULL, 0, 0),
(394, '00:00', '00:00', '0', NULL, NULL, 135, 10, 1, NULL, NULL, 0, 0),
(398, '07:00', '28:01', '4', '2019-02-04', '2019-02-04', 140, 1, 3, '2019-02-04 14:29:18', '2019-02-04 14:57:19', 0, 0),
(399, '00:00', '00:00', '0', NULL, NULL, 140, 2, 1, NULL, NULL, 0, 0),
(400, '00:00', '00:00', '0', NULL, NULL, 140, 3, 1, NULL, NULL, 0, 0),
(401, '00:00', '00:00', '0', NULL, NULL, 140, 4, 1, NULL, NULL, 0, 0),
(402, '00:02', '00:11', '4', '2019-02-06', '2019-02-06', 140, 5, 3, '2019-02-06 06:31:58', '2019-02-06 06:32:09', 0, 0),
(403, '00:00', '16:13', '0', '2019-02-06', NULL, 140, 6, 4, '2019-02-06 10:31:56', NULL, 4, 1),
(404, '00:04', '00:17', '4', '2019-02-06', '2019-02-06', 140, 7, 3, '2019-02-06 11:42:28', '2019-02-06 11:42:45', 0, 0),
(405, '00:20', '01:20', '4', '2019-02-06', '2019-02-06', 140, 8, 3, '2019-02-06 11:43:09', '2019-02-06 11:44:29', 0, 0),
(406, '00:00', '00:00', '0', NULL, NULL, 140, 10, 1, NULL, NULL, 0, 0),
(407, '00:08', '00:41', '5', '2019-02-04', '2019-02-04', 141, 1, 3, '2019-02-04 13:34:05', '2019-02-04 13:34:42', 0, 0),
(408, '00:00', '00:00', '0', '2019-02-04', NULL, 141, 2, 4, '2019-02-04 14:10:43', NULL, 0, 1),
(409, '00:00', '00:00', '0', NULL, NULL, 141, 3, 1, NULL, NULL, 0, 0),
(410, '00:00', '00:00', '0', NULL, NULL, 141, 4, 1, NULL, NULL, 0, 0),
(411, '00:00', '00:00', '0', NULL, NULL, 141, 5, 1, NULL, NULL, 0, 0),
(412, '00:00', '16:22', '0', '2019-02-06', NULL, 141, 6, 4, '2019-02-06 10:31:41', NULL, 5, 1),
(413, '00:03', '00:16', '5', '2019-02-06', '2019-02-06', 141, 7, 3, '2019-02-06 11:42:21', '2019-02-06 11:42:37', 0, 0),
(414, '00:03', '00:16', '5', '2019-02-06', '2019-02-06', 141, 8, 3, '2019-02-06 11:43:03', '2019-02-06 11:43:19', 0, 0),
(415, '00:00', '00:00', '0', NULL, NULL, 141, 10, 1, NULL, NULL, 0, 0),
(416, '47:33', '951:15', '20', '2019-02-04', '2019-02-05', 142, 1, 3, '2019-02-04 14:57:11', '2019-02-05 06:48:25', 0, 0),
(417, '00:00', '00:00', '0', '2019-02-06', NULL, 142, 2, 4, '2019-02-06 09:50:19', NULL, 0, 1),
(418, '02:56', '58:58', '20', '2019-02-06', '2019-02-06', 142, 3, 3, '2019-02-06 13:12:07', '2019-02-06 13:46:32', 0, 0),
(419, '00:00', '00:00', '0', NULL, NULL, 142, 4, 1, NULL, NULL, 0, 0),
(420, '00:00', '00:00', '0', NULL, NULL, 142, 5, 1, NULL, NULL, 0, 0),
(421, '00:00', '86:06', '0', '2019-02-08', NULL, 142, 6, 4, '2019-02-11 13:51:58', NULL, 20, 1),
(422, '00:00', '00:00', '0', NULL, NULL, 142, 7, 1, NULL, NULL, 0, 0),
(423, '00:00', '00:00', '0', NULL, NULL, 142, 8, 1, NULL, NULL, 0, 0),
(424, '00:00', '00:00', '0', NULL, NULL, 142, 10, 1, NULL, NULL, 0, 0),
(425, '00:06', '00:27', '4', '2019-02-04', '2019-02-04', 143, 1, 3, '2019-02-04 13:33:51', '2019-02-04 13:34:16', 0, 0),
(426, '00:00', '00:00', '0', '2019-02-04', NULL, 143, 2, 4, '2019-02-04 14:10:58', NULL, 0, 1),
(427, '00:00', '00:00', '0', NULL, NULL, 143, 3, 1, NULL, NULL, 0, 0),
(428, '00:00', '00:00', '0', NULL, NULL, 143, 4, 1, NULL, NULL, 0, 0),
(429, '00:00', '00:00', '0', NULL, NULL, 143, 5, 1, NULL, NULL, 0, 0),
(430, '20:54', '83:39', '4', '2019-02-06', '2019-02-06', 143, 6, 3, '2019-02-06 06:34:40', '2019-02-06 07:58:19', 0, 0),
(431, '00:05', '00:20', '4', '2019-02-06', '2019-02-06', 143, 7, 3, '2019-02-06 08:09:12', '2019-02-06 08:09:32', 0, 0),
(432, '19:07', '76:28', '4', '2019-02-06', '2019-02-06', 143, 8, 3, '2019-02-06 08:09:51', '2019-02-06 09:26:19', 0, 0),
(433, '00:00', '00:00', '0', NULL, NULL, 143, 10, 1, NULL, NULL, 0, 0),
(434, '00:00', '00:00', '0', NULL, NULL, 144, 1, 1, NULL, NULL, 0, 0),
(435, '00:02', '21:49', '500', '2019-02-06', '2019-02-06', 144, 3, 3, '2019-02-06 06:26:07', '2019-02-06 06:47:56', 0, 0),
(436, '00:14', '124:34', '500', '2019-02-06', '2019-02-06', 144, 4, 3, '2019-02-06 08:54:12', '2019-02-06 10:58:46', 0, 0),
(437, '00:00', '00:00', '0', NULL, NULL, 144, 5, 1, NULL, NULL, 0, 0),
(438, '00:03', '32:31', '500', '2019-02-07', '2019-02-07', 144, 6, 3, '2019-02-07 11:32:58', '2019-02-07 12:05:29', 0, 0),
(439, '00:00', '00:00', '0', NULL, NULL, 144, 7, 1, NULL, NULL, 0, 0),
(440, '00:00', '00:00', '0', NULL, NULL, 144, 8, 1, NULL, NULL, 0, 0),
(441, '00:00', '00:00', '0', NULL, NULL, 144, 10, 1, NULL, NULL, 0, 0),
(442, '04:56', '14:49', '3', '2019-02-04', '2019-02-04', 145, 1, 3, '2019-02-04 09:28:17', '2019-02-04 09:43:06', 0, 0),
(443, '00:00', '64:04', '0', '2019-02-04', NULL, 145, 3, 4, '2019-02-04 11:41:30', NULL, 3, 1),
(444, '00:00', '00:00', '0', NULL, NULL, 145, 4, 1, NULL, NULL, 0, 0),
(445, '00:00', '00:00', '0', NULL, NULL, 145, 5, 1, NULL, NULL, 0, 0),
(446, '00:00', '00:00', '0', NULL, NULL, 145, 6, 1, NULL, NULL, 0, 0),
(447, '00:00', '00:00', '0', NULL, NULL, 145, 7, 1, NULL, NULL, 0, 0),
(448, '00:00', '00:00', '0', NULL, NULL, 145, 8, 1, NULL, NULL, 0, 0),
(449, '00:00', '00:00', '0', NULL, NULL, 145, 10, 1, NULL, NULL, 0, 0),
(450, '00:00', '00:00', '0', NULL, NULL, 146, 1, 1, NULL, NULL, 0, 0),
(451, '03:28', '41:38', '12', '2019-02-06', '2019-02-06', 146, 3, 3, '2019-02-06 13:29:05', '2019-02-06 13:46:07', 0, 0),
(452, '00:00', '00:00', '0', NULL, NULL, 146, 4, 1, NULL, NULL, 0, 0),
(453, '00:00', '00:00', '0', NULL, NULL, 146, 5, 1, NULL, NULL, 0, 0),
(454, '05:42', '68:32', '12', '2019-02-07', '2019-02-07', 146, 6, 3, '2019-02-07 08:46:25', '2019-02-07 09:54:57', 0, 0),
(455, '00:00', '00:00', '0', NULL, NULL, 146, 7, 1, NULL, NULL, 0, 0),
(456, '00:00', '00:00', '0', NULL, NULL, 146, 8, 1, NULL, NULL, 0, 0),
(457, '00:00', '00:00', '0', NULL, NULL, 146, 10, 1, NULL, NULL, 0, 0),
(458, '00:00', '00:00', '0', NULL, NULL, 147, 1, 1, NULL, NULL, 0, 0),
(459, '00:00', '00:00', '0', NULL, NULL, 147, 2, 1, NULL, NULL, 0, 0),
(460, '01:42', '85:05', '50', '2019-02-06', '2019-02-07', 147, 3, 3, '2019-02-07 09:20:59', '2019-02-07 09:21:09', 0, 0),
(461, '00:00', '00:00', '0', NULL, NULL, 147, 4, 1, NULL, NULL, 0, 0),
(462, '00:00', '00:00', '0', NULL, NULL, 147, 5, 1, NULL, NULL, 0, 0),
(463, '00:00', '00:00', '0', NULL, NULL, 147, 7, 1, NULL, NULL, 0, 0),
(464, '00:00', '00:00', '0', NULL, NULL, 147, 8, 1, NULL, NULL, 0, 0),
(465, '00:00', '00:00', '0', NULL, NULL, 147, 10, 1, NULL, NULL, 0, 0),
(476, '49:06', '98:13', '2', '2019-02-08', '2019-02-08', 151, 1, 3, '2019-02-08 07:16:07', '2019-02-08 08:54:20', 0, 0),
(477, '00:00', '4240:17', '0', '2019-02-08', NULL, 151, 2, 4, '2019-02-11 15:52:42', NULL, 2, 1),
(478, '12:19', '24:39', '2', '2019-02-08', '2019-02-08', 151, 3, 3, '2019-02-08 13:39:32', '2019-02-08 14:04:11', 0, 0),
(479, '00:00', '00:00', '0', NULL, NULL, 151, 4, 1, NULL, NULL, 0, 0),
(480, '00:00', '00:00', '0', NULL, NULL, 151, 5, 1, NULL, NULL, 0, 0),
(481, '36:10', '72:20', '2', '2019-02-08', '2019-02-08', 151, 6, 3, '2019-02-08 14:48:53', '2019-02-08 16:01:13', 0, 0),
(482, '00:00', '00:00', '0', NULL, NULL, 151, 7, 1, NULL, NULL, 0, 0),
(483, '00:00', '00:00', '0', NULL, NULL, 151, 8, 1, NULL, NULL, 0, 0),
(484, '00:00', '00:00', '0', NULL, NULL, 151, 10, 1, NULL, NULL, 0, 0),
(485, '49:06', '98:12', '2', '2019-02-08', '2019-02-08', 152, 1, 3, '2019-02-08 07:16:17', '2019-02-08 08:54:29', 0, 0),
(486, '102:22', '204:44', '2', '2019-02-08', '2019-02-08', 152, 2, 3, '2019-02-08 09:33:05', '2019-02-08 12:57:49', 0, 0),
(487, '12:06', '24:13', '2', '2019-02-08', '2019-02-08', 152, 3, 3, '2019-02-08 13:39:45', '2019-02-08 14:03:58', 0, 0),
(488, '00:00', '00:00', '0', NULL, NULL, 152, 4, 1, NULL, NULL, 0, 0),
(489, '00:00', '00:00', '0', NULL, NULL, 152, 5, 1, NULL, NULL, 0, 0),
(490, '43:43', '87:27', '2', '2019-02-08', '2019-02-08', 152, 6, 3, '2019-02-08 14:33:02', '2019-02-08 16:00:29', 0, 0),
(491, '00:00', '00:00', '0', NULL, NULL, 152, 7, 1, NULL, NULL, 0, 0),
(492, '00:00', '00:00', '0', NULL, NULL, 152, 8, 1, NULL, NULL, 0, 0),
(493, '00:00', '00:00', '0', NULL, NULL, 152, 10, 1, NULL, NULL, 0, 0),
(494, '00:00', '00:00', '0', NULL, NULL, 153, 1, 1, NULL, NULL, 0, 0),
(495, '00:00', '00:00', '0', '2019-02-06', NULL, 153, 2, 4, '2019-02-06 09:49:37', NULL, 0, 1),
(496, '07:47', '15:34', '2', '2019-02-06', '2019-02-06', 153, 3, 3, '2019-02-06 10:49:55', '2019-02-06 11:05:29', 0, 0),
(497, '00:00', '00:00', '0', '2019-02-06', NULL, 153, 4, 4, '2019-02-06 16:14:55', NULL, 0, 1),
(498, '00:00', '00:00', '0', NULL, NULL, 153, 5, 1, NULL, NULL, 0, 0),
(499, '00:00', '00:00', '0', '2019-02-07', NULL, 153, 6, 4, '2019-02-07 08:34:57', NULL, 0, 1),
(500, '00:00', '00:00', '0', NULL, NULL, 153, 7, 1, NULL, NULL, 0, 0),
(501, '00:00', '00:00', '0', NULL, NULL, 153, 8, 1, NULL, NULL, 0, 0),
(502, '00:00', '00:00', '0', NULL, NULL, 153, 10, 1, NULL, NULL, 0, 0),
(503, '48:15', '48:15', '1', '2019-02-06', '2019-02-06', 154, 1, 3, '2019-02-06 06:34:19', '2019-02-06 07:22:34', 0, 0),
(504, '305:10', '305:10', '1', '2019-02-06', '2019-02-06', 154, 2, 3, '2019-02-06 07:51:21', '2019-02-06 12:56:31', 0, 0),
(505, '39:07', '39:07', '1', '2019-02-06', '2019-02-06', 154, 3, 3, '2019-02-06 13:47:56', '2019-02-06 14:27:03', 0, 0),
(506, '00:00', '00:00', '0', NULL, NULL, 154, 4, 1, NULL, NULL, 0, 0),
(507, '00:00', '00:00', '0', NULL, NULL, 154, 5, 1, NULL, NULL, 0, 0),
(508, '1704:1', '1704:17', '1', '2019-02-07', '2019-02-08', 154, 6, 3, '2019-02-07 08:26:06', '2019-02-08 12:50:23', 0, 0),
(509, '00:00', '00:00', '0', NULL, NULL, 154, 7, 1, NULL, NULL, 0, 0),
(510, '00:00', '00:00', '0', NULL, NULL, 154, 8, 1, NULL, NULL, 0, 0),
(511, '00:00', '00:00', '0', NULL, NULL, 154, 10, 1, NULL, NULL, 0, 0),
(512, '02:26', '36:30', '15', '2019-02-06', '2019-02-06', 155, 1, 3, '2019-02-06 11:24:26', '2019-02-06 12:00:56', 0, 0),
(513, '00:00', '13:16', '0', '2019-02-06', NULL, 155, 3, 2, '2019-02-06 16:03:00', '2019-02-06 16:16:16', 15, 0),
(514, '00:00', '00:00', '0', NULL, NULL, 155, 4, 1, NULL, NULL, 0, 0),
(515, '00:00', '00:00', '0', NULL, NULL, 155, 5, 1, NULL, NULL, 0, 0),
(516, '05:30', '82:35', '15', '2019-02-07', '2019-02-07', 155, 6, 3, '2019-02-07 10:35:54', '2019-02-07 11:58:29', 0, 0),
(517, '00:00', '00:00', '0', NULL, NULL, 155, 7, 1, NULL, NULL, 0, 0),
(518, '00:00', '00:00', '0', NULL, NULL, 155, 8, 1, NULL, NULL, 0, 0),
(519, '00:00', '00:00', '0', NULL, NULL, 155, 10, 1, NULL, NULL, 0, 0),
(520, '00:00', '00:00', '0', '2019-02-08', NULL, 156, 1, 4, '2019-02-08 14:17:12', NULL, 0, 1),
(521, '19:50', '198:26', '10', '2019-02-11', '2019-02-11', 156, 2, 3, '2019-02-11 11:03:05', '2019-02-11 14:21:31', 0, 0),
(522, '00:00', '00:00', '0', NULL, NULL, 156, 3, 1, NULL, NULL, 0, 0),
(523, '00:00', '00:00', '0', NULL, NULL, 156, 4, 1, NULL, NULL, 0, 0),
(524, '00:00', '00:00', '0', NULL, NULL, 156, 5, 1, NULL, NULL, 0, 0),
(525, '00:00', '00:00', '0', NULL, NULL, 156, 6, 1, NULL, NULL, 0, 0),
(526, '00:00', '00:00', '0', NULL, NULL, 156, 7, 1, NULL, NULL, 0, 0),
(527, '00:00', '00:00', '0', NULL, NULL, 156, 8, 1, NULL, NULL, 0, 0),
(528, '00:00', '00:00', '0', NULL, NULL, 156, 10, 1, NULL, NULL, 0, 0),
(529, '00:07', '31:37', '250', '2019-02-07', '2019-02-07', 157, 1, 3, '2019-02-07 13:03:24', '2019-02-07 13:35:01', 0, 0),
(530, '00:00', '00:00', '0', NULL, NULL, 157, 3, 1, NULL, NULL, 0, 0),
(531, '00:00', '00:00', '0', NULL, NULL, 157, 4, 1, NULL, NULL, 0, 0),
(532, '00:00', '00:00', '0', NULL, NULL, 157, 5, 1, NULL, NULL, 0, 0),
(533, '00:00', '00:00', '0', NULL, NULL, 157, 7, 1, NULL, NULL, 0, 0),
(534, '00:00', '00:00', '0', NULL, NULL, 157, 8, 1, NULL, NULL, 0, 0),
(535, '00:00', '00:00', '0', NULL, NULL, 157, 10, 1, NULL, NULL, 0, 0),
(536, '00:00', '00:01', '0', '2019-02-06', NULL, 158, 1, 4, '2019-02-06 14:57:28', NULL, 4, 1),
(537, '00:00', '00:00', '0', '2019-02-07', NULL, 158, 2, 4, '2019-02-07 14:01:38', NULL, 0, 1),
(538, '07:26', '29:46', '4', '2019-02-08', '2019-02-08', 158, 3, 3, '2019-02-08 09:29:34', '2019-02-08 09:40:36', 0, 0),
(539, '00:00', '00:00', '0', NULL, NULL, 158, 4, 1, NULL, NULL, 0, 0),
(540, '00:00', '00:00', '0', NULL, NULL, 158, 5, 1, NULL, NULL, 0, 0),
(541, '29:00', '116:00', '4', '2019-02-11', '2019-02-11', 158, 6, 3, '2019-02-11 09:21:28', '2019-02-11 10:11:12', 0, 0),
(542, '00:00', '00:00', '0', NULL, NULL, 158, 7, 1, NULL, NULL, 0, 0),
(543, '00:00', '00:00', '0', NULL, NULL, 158, 8, 1, NULL, NULL, 0, 0),
(544, '00:00', '00:00', '0', NULL, NULL, 158, 10, 1, NULL, NULL, 0, 0),
(545, '00:00', '00:00', '0', NULL, NULL, 159, 1, 1, NULL, NULL, 0, 0),
(546, '00:00', '00:00', '0', NULL, NULL, 159, 2, 1, NULL, NULL, 0, 0),
(547, '00:00', '00:00', '0', NULL, NULL, 159, 3, 1, NULL, NULL, 0, 0),
(548, '00:00', '00:00', '0', NULL, NULL, 159, 4, 1, NULL, NULL, 0, 0),
(549, '00:00', '00:00', '0', NULL, NULL, 159, 5, 1, NULL, NULL, 0, 0),
(550, '00:00', '00:00', '0', NULL, NULL, 159, 6, 1, NULL, NULL, 0, 0),
(551, '00:00', '00:00', '0', NULL, NULL, 159, 7, 1, NULL, NULL, 0, 0),
(552, '00:00', '00:00', '0', NULL, NULL, 159, 8, 1, NULL, NULL, 0, 0),
(553, '00:00', '00:00', '0', NULL, NULL, 159, 10, 1, NULL, NULL, 0, 0),
(554, '48:08', '48:08', '1', '2019-02-06', '2019-02-06', 160, 1, 3, '2019-02-06 06:34:51', '2019-02-06 07:22:59', 0, 0),
(555, '306:03', '306:03', '1', '2019-02-06', '2019-02-06', 160, 2, 3, '2019-02-06 07:50:10', '2019-02-06 12:56:13', 0, 0),
(556, '00:00', '00:00', '0', NULL, NULL, 160, 3, 1, NULL, NULL, 0, 0),
(557, '00:00', '00:00', '0', NULL, NULL, 160, 4, 1, NULL, NULL, 0, 0),
(558, '00:00', '00:00', '0', NULL, NULL, 160, 5, 1, NULL, NULL, 0, 0),
(559, '00:00', '00:00', '0', NULL, NULL, 160, 6, 1, NULL, NULL, 0, 0),
(560, '00:00', '00:00', '0', NULL, NULL, 160, 7, 1, NULL, NULL, 0, 0),
(561, '00:00', '00:00', '0', NULL, NULL, 160, 8, 1, NULL, NULL, 0, 0),
(562, '00:00', '00:00', '0', NULL, NULL, 160, 10, 1, NULL, NULL, 0, 0),
(563, '01:38', '16:25', '10', '2019-02-06', '2019-02-06', 161, 1, 3, '2019-02-06 09:05:29', '2019-02-06 09:21:54', 0, 0),
(564, '145:08', '1451:26', '10', '2019-02-06', '2019-02-07', 161, 2, 3, '2019-02-06 11:44:55', '2019-02-07 11:56:21', 0, 0),
(565, '01:48', '18:03', '10', '2019-02-07', '2019-02-07', 161, 3, 3, '2019-02-07 14:33:55', '2019-02-07 14:51:58', 0, 0),
(566, '00:00', '00:00', '0', NULL, NULL, 161, 4, 1, NULL, NULL, 0, 0),
(567, '00:00', '00:00', '0', NULL, NULL, 161, 5, 1, NULL, NULL, 0, 0),
(568, '11:12', '112:04', '10', '2019-02-08', '2019-02-08', 161, 6, 3, '2019-02-08 14:49:10', '2019-02-08 16:03:35', 0, 0),
(569, '00:00', '00:00', '0', NULL, NULL, 161, 7, 1, NULL, NULL, 0, 0),
(570, '00:00', '00:00', '0', NULL, NULL, 161, 8, 1, NULL, NULL, 0, 0),
(571, '00:00', '00:00', '0', NULL, NULL, 161, 10, 1, NULL, NULL, 0, 0),
(572, '00:00', '00:00', '0', NULL, NULL, 162, 1, 1, NULL, NULL, 0, 0),
(573, '00:00', '00:00', '0', NULL, NULL, 162, 2, 1, NULL, NULL, 0, 0),
(574, '00:00', '00:00', '0', NULL, NULL, 162, 3, 1, NULL, NULL, 0, 0),
(575, '00:00', '00:00', '0', NULL, NULL, 162, 4, 1, NULL, NULL, 0, 0),
(576, '00:00', '00:00', '0', NULL, NULL, 162, 5, 1, NULL, NULL, 0, 0),
(577, '00:00', '00:00', '0', NULL, NULL, 162, 7, 1, NULL, NULL, 0, 0),
(578, '00:00', '00:00', '0', NULL, NULL, 162, 8, 1, NULL, NULL, 0, 0),
(579, '00:00', '00:00', '0', NULL, NULL, 162, 10, 1, NULL, NULL, 0, 0),
(580, '00:00', '00:00', '0', NULL, NULL, 163, 1, 1, NULL, NULL, 0, 0),
(581, '00:00', '00:00', '0', NULL, NULL, 163, 2, 1, NULL, NULL, 0, 0),
(582, '00:00', '00:00', '0', NULL, NULL, 163, 3, 1, NULL, NULL, 0, 0),
(583, '00:00', '00:00', '0', NULL, NULL, 163, 4, 1, NULL, NULL, 0, 0),
(584, '00:00', '00:00', '0', NULL, NULL, 163, 5, 1, NULL, NULL, 0, 0),
(585, '00:00', '00:00', '0', NULL, NULL, 163, 6, 1, NULL, NULL, 0, 0),
(586, '00:00', '00:00', '0', NULL, NULL, 163, 7, 1, NULL, NULL, 0, 0),
(587, '00:00', '00:00', '0', NULL, NULL, 163, 8, 1, NULL, NULL, 0, 0),
(588, '00:00', '00:00', '0', NULL, NULL, 163, 10, 1, NULL, NULL, 0, 0),
(589, '01:42', '51:14', '30', '2019-02-06', '2019-02-06', 164, 1, 3, '2019-02-06 14:05:54', '2019-02-06 14:57:08', 0, 0),
(590, '00:00', '00:00', '0', NULL, NULL, 164, 2, 1, NULL, NULL, 0, 0),
(591, '00:00', '00:00', '0', NULL, NULL, 164, 3, 1, NULL, NULL, 0, 0),
(592, '00:00', '00:00', '0', NULL, NULL, 164, 4, 1, NULL, NULL, 0, 0),
(593, '00:00', '00:00', '0', NULL, NULL, 164, 5, 1, NULL, NULL, 0, 0),
(594, '00:00', '00:00', '0', NULL, NULL, 164, 6, 1, NULL, NULL, 0, 0),
(595, '00:00', '00:00', '0', NULL, NULL, 164, 7, 1, NULL, NULL, 0, 0),
(596, '00:00', '00:00', '0', NULL, NULL, 164, 8, 1, NULL, NULL, 0, 0),
(597, '00:00', '00:00', '0', NULL, NULL, 164, 10, 1, NULL, NULL, 0, 0),
(598, '00:00', '00:01', '0', '2019-02-06', NULL, 165, 1, 4, '2019-02-06 14:57:18', NULL, 2, 1),
(599, '194:04', '388:09', '2', '2019-02-07', '2019-02-07', 165, 2, 3, '2019-02-07 07:33:13', '2019-02-07 14:01:22', 0, 0),
(600, '04:07', '08:14', '2', '2019-02-07', '2019-02-07', 165, 3, 3, '2019-02-07 15:05:10', '2019-02-07 15:13:24', 0, 0),
(601, '00:00', '00:00', '0', NULL, NULL, 165, 4, 1, NULL, NULL, 0, 0),
(602, '00:00', '00:00', '0', NULL, NULL, 165, 5, 1, NULL, NULL, 0, 0),
(603, '43:19', '86:38', '2', '2019-02-08', '2019-02-08', 165, 6, 3, '2019-02-08 08:49:42', '2019-02-08 10:16:20', 0, 0),
(604, '00:00', '00:00', '0', NULL, NULL, 165, 7, 1, NULL, NULL, 0, 0),
(605, '00:00', '00:00', '0', NULL, NULL, 165, 8, 1, NULL, NULL, 0, 0),
(606, '00:00', '00:00', '0', NULL, NULL, 165, 10, 1, NULL, NULL, 0, 0),
(607, '00:00', '00:00', '0', NULL, NULL, 166, 1, 1, NULL, NULL, 0, 0),
(608, '00:00', '00:00', '0', NULL, NULL, 166, 3, 1, NULL, NULL, 0, 0),
(609, '00:00', '00:00', '0', NULL, NULL, 166, 4, 1, NULL, NULL, 0, 0),
(610, '00:00', '00:00', '0', NULL, NULL, 166, 5, 1, NULL, NULL, 0, 0),
(611, '00:00', '00:00', '0', NULL, NULL, 166, 6, 1, NULL, NULL, 0, 0),
(612, '00:00', '00:00', '0', NULL, NULL, 166, 7, 1, NULL, NULL, 0, 0),
(613, '00:00', '00:00', '0', NULL, NULL, 166, 8, 1, NULL, NULL, 0, 0),
(614, '00:00', '00:00', '0', NULL, NULL, 166, 10, 1, NULL, NULL, 0, 0),
(615, '01:22', '27:30', '20', '2019-02-06', '2019-02-06', 167, 1, 3, '2019-02-06 15:12:43', '2019-02-06 15:40:13', 0, 0),
(616, '00:00', '12:51', '0', '2019-02-06', NULL, 167, 3, 2, '2019-02-06 16:03:30', '2019-02-06 16:16:21', 20, 0),
(617, '00:00', '00:00', '0', NULL, NULL, 167, 4, 1, NULL, NULL, 0, 0),
(618, '00:00', '00:00', '0', NULL, NULL, 167, 5, 1, NULL, NULL, 0, 0),
(619, '03:18', '66:04', '20', '2019-02-07', '2019-02-07', 167, 6, 3, '2019-02-07 09:55:28', '2019-02-07 11:01:32', 0, 0),
(620, '00:00', '00:00', '0', NULL, NULL, 167, 7, 1, NULL, NULL, 0, 0),
(621, '00:00', '00:00', '0', NULL, NULL, 167, 8, 1, NULL, NULL, 0, 0),
(622, '00:00', '00:00', '0', NULL, NULL, 167, 10, 1, NULL, NULL, 0, 0),
(623, '08:36', '51:38', '6', '2019-02-06', '2019-02-06', 168, 1, 3, '2019-02-06 14:06:00', '2019-02-06 14:57:38', 0, 0),
(624, '226:50', '1361:04', '6', '2019-02-07', '2019-02-08', 168, 2, 3, '2019-02-07 09:32:47', '2019-02-08 08:13:51', 0, 0),
(625, '04:07', '24:45', '6', '2019-02-08', '2019-02-08', 168, 3, 3, '2019-02-08 10:20:06', '2019-02-08 10:44:51', 0, 0),
(626, '00:00', '00:00', '0', NULL, NULL, 168, 4, 1, NULL, NULL, 0, 0),
(627, '00:00', '00:00', '0', NULL, NULL, 168, 5, 1, NULL, NULL, 0, 0),
(628, '19:20', '116:05', '6', '2019-02-11', '2019-02-11', 168, 6, 3, '2019-02-11 09:21:51', '2019-02-11 10:11:35', 0, 0),
(629, '00:00', '00:00', '0', NULL, NULL, 168, 7, 1, NULL, NULL, 0, 0),
(630, '00:00', '00:00', '0', NULL, NULL, 168, 8, 1, NULL, NULL, 0, 0),
(631, '00:00', '00:00', '0', NULL, NULL, 168, 10, 1, NULL, NULL, 0, 0),
(632, '07:21', '14:43', '2', '2019-02-06', '2019-02-06', 169, 1, 3, '2019-02-06 11:07:37', '2019-02-06 11:22:20', 0, 0),
(633, '194:11', '388:22', '2', '2019-02-07', '2019-02-07', 169, 2, 3, '2019-02-07 07:33:33', '2019-02-07 14:01:55', 0, 0),
(634, '06:01', '12:02', '2', '2019-02-07', '2019-02-07', 169, 3, 3, '2019-02-07 15:13:48', '2019-02-07 15:25:50', 0, 0),
(635, '00:00', '00:00', '0', NULL, NULL, 169, 4, 1, NULL, NULL, 0, 0),
(636, '00:00', '00:00', '0', NULL, NULL, 169, 5, 1, NULL, NULL, 0, 0),
(637, '43:23', '86:47', '2', '2019-02-08', '2019-02-08', 169, 6, 3, '2019-02-08 08:49:53', '2019-02-08 10:16:40', 0, 0),
(638, '00:00', '00:00', '0', NULL, NULL, 169, 7, 1, NULL, NULL, 0, 0),
(639, '00:00', '00:00', '0', NULL, NULL, 169, 8, 1, NULL, NULL, 0, 0),
(640, '00:00', '00:00', '0', NULL, NULL, 169, 10, 1, NULL, NULL, 0, 0),
(641, '00:00', '00:00', '0', '2019-02-06', NULL, 170, 1, 4, '2019-02-06 15:58:54', NULL, 0, 1),
(642, '222:54', '1337:25', '6', '2019-02-07', '2019-02-08', 170, 2, 3, '2019-02-07 14:21:34', '2019-02-08 12:38:59', 0, 0),
(643, '04:01', '24:09', '6', '2019-02-08', '2019-02-08', 170, 3, 3, '2019-02-08 13:53:46', '2019-02-08 14:06:45', 0, 0),
(644, '00:00', '00:00', '0', NULL, NULL, 170, 4, 1, NULL, NULL, 0, 0),
(645, '00:00', '00:00', '0', NULL, NULL, 170, 5, 1, NULL, NULL, 0, 0),
(646, '19:20', '116:01', '6', '2019-02-11', '2019-02-11', 170, 6, 3, '2019-02-11 09:21:38', '2019-02-11 10:11:24', 0, 0),
(647, '00:00', '00:00', '0', NULL, NULL, 170, 7, 1, NULL, NULL, 0, 0),
(648, '00:00', '00:00', '0', NULL, NULL, 170, 8, 1, NULL, NULL, 0, 0);
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(649, '00:00', '00:00', '0', NULL, NULL, 170, 10, 1, NULL, NULL, 0, 0),
(650, '04:50', '48:27', '10', '2019-02-11', '2019-02-11', 171, 1, 3, '2019-02-11 11:42:15', '2019-02-11 12:30:42', 0, 0),
(651, '00:00', '00:00', '0', NULL, NULL, 171, 2, 1, NULL, NULL, 0, 0),
(652, '00:00', '00:00', '0', NULL, NULL, 171, 3, 1, NULL, NULL, 0, 0),
(653, '00:00', '00:00', '0', NULL, NULL, 171, 4, 1, NULL, NULL, 0, 0),
(654, '00:00', '00:00', '0', NULL, NULL, 171, 5, 1, NULL, NULL, 0, 0),
(655, '00:00', '00:00', '0', NULL, NULL, 171, 6, 1, NULL, NULL, 0, 0),
(656, '00:00', '00:00', '0', NULL, NULL, 171, 7, 1, NULL, NULL, 0, 0),
(657, '00:00', '00:00', '0', NULL, NULL, 171, 8, 1, NULL, NULL, 0, 0),
(658, '00:00', '00:00', '0', NULL, NULL, 171, 10, 1, NULL, NULL, 0, 0),
(659, '01:22', '27:31', '20', '2019-02-06', '2019-02-06', 172, 1, 3, '2019-02-06 15:12:31', '2019-02-06 15:40:02', 0, 0),
(660, '00:00', '13:34', '0', '2019-02-06', NULL, 172, 3, 2, '2019-02-06 16:03:09', '2019-02-06 16:16:43', 20, 0),
(661, '00:00', '00:00', '0', NULL, NULL, 172, 4, 1, NULL, NULL, 0, 0),
(662, '00:00', '00:00', '0', NULL, NULL, 172, 5, 1, NULL, NULL, 0, 0),
(663, '03:17', '65:55', '20', '2019-02-07', '2019-02-07', 172, 6, 3, '2019-02-07 09:55:15', '2019-02-07 11:01:10', 0, 0),
(664, '00:00', '00:00', '0', NULL, NULL, 172, 7, 1, NULL, NULL, 0, 0),
(665, '00:00', '00:00', '0', NULL, NULL, 172, 8, 1, NULL, NULL, 0, 0),
(666, '00:00', '00:00', '0', NULL, NULL, 172, 10, 1, NULL, NULL, 0, 0),
(667, '02:24', '48:09', '20', '2019-02-07', '2019-02-07', 173, 1, 3, '2019-02-07 09:24:41', '2019-02-07 10:12:50', 0, 0),
(668, '14:29', '289:40', '20', '2019-02-11', '2019-02-11', 173, 2, 3, '2019-02-11 11:02:30', '2019-02-11 15:52:10', 0, 0),
(669, '00:00', '00:00', '0', NULL, NULL, 173, 3, 1, NULL, NULL, 0, 0),
(670, '00:00', '00:00', '0', NULL, NULL, 173, 4, 1, NULL, NULL, 0, 0),
(671, '00:00', '00:00', '0', NULL, NULL, 173, 5, 1, NULL, NULL, 0, 0),
(672, '00:00', '00:00', '0', NULL, NULL, 173, 6, 1, NULL, NULL, 0, 0),
(673, '00:00', '00:00', '0', NULL, NULL, 173, 7, 1, NULL, NULL, 0, 0),
(674, '00:00', '00:00', '0', NULL, NULL, 173, 8, 1, NULL, NULL, 0, 0),
(675, '00:00', '00:00', '0', NULL, NULL, 173, 10, 1, NULL, NULL, 0, 0),
(676, '00:00', '00:00', '0', '2019-02-08', NULL, 175, 1, 4, '2019-02-08 14:17:04', NULL, 0, 1),
(677, '00:00', '00:00', '0', '2019-02-11', NULL, 175, 2, 4, '2019-02-11 14:20:11', NULL, 0, 1),
(678, '00:00', '00:00', '0', NULL, NULL, 175, 3, 1, NULL, NULL, 0, 0),
(679, '00:00', '00:00', '0', NULL, NULL, 175, 4, 1, NULL, NULL, 0, 0),
(680, '00:00', '00:00', '0', NULL, NULL, 175, 5, 1, NULL, NULL, 0, 0),
(681, '00:00', '00:00', '0', NULL, NULL, 175, 6, 1, NULL, NULL, 0, 0),
(682, '00:00', '00:00', '0', NULL, NULL, 175, 7, 1, NULL, NULL, 0, 0),
(683, '00:00', '00:00', '0', NULL, NULL, 175, 8, 1, NULL, NULL, 0, 0),
(684, '00:00', '00:00', '0', NULL, NULL, 175, 9, 1, NULL, NULL, 0, 0),
(685, '00:00', '00:00', '0', NULL, NULL, 175, 10, 1, NULL, NULL, 0, 0),
(686, '12:03', '48:13', '4', '2019-02-11', '2019-02-11', 177, 1, 3, '2019-02-11 11:42:20', '2019-02-11 12:30:33', 0, 0),
(687, '00:00', '00:00', '0', NULL, NULL, 177, 2, 1, NULL, NULL, 0, 0),
(688, '00:00', '00:00', '0', NULL, NULL, 177, 3, 1, NULL, NULL, 0, 0),
(689, '00:00', '00:00', '0', NULL, NULL, 177, 4, 1, NULL, NULL, 0, 0),
(690, '00:00', '00:00', '0', NULL, NULL, 177, 5, 1, NULL, NULL, 0, 0),
(691, '00:00', '00:00', '0', NULL, NULL, 177, 6, 1, NULL, NULL, 0, 0),
(692, '00:00', '00:00', '0', NULL, NULL, 177, 7, 1, NULL, NULL, 0, 0),
(693, '00:00', '00:00', '0', NULL, NULL, 177, 8, 1, NULL, NULL, 0, 0),
(694, '00:00', '00:00', '0', NULL, NULL, 177, 10, 1, NULL, NULL, 0, 0),
(705, '06:31', '26:06', '4', '2019-02-07', '2019-02-07', 181, 1, 3, '2019-02-07 15:55:52', '2019-02-07 16:21:58', 0, 0),
(706, '00:00', '00:00', '0', '2019-02-08', NULL, 181, 2, 4, '2019-02-08 09:45:25', NULL, 0, 1),
(707, '06:05', '24:23', '4', '2019-02-08', '2019-02-08', 181, 3, 3, '2019-02-08 10:19:58', '2019-02-08 10:44:21', 0, 0),
(708, '00:00', '00:00', '0', NULL, NULL, 181, 4, 1, NULL, NULL, 0, 0),
(709, '00:00', '00:00', '0', NULL, NULL, 181, 5, 1, NULL, NULL, 0, 0),
(710, '28:59', '115:56', '4', '2019-02-11', '2019-02-11', 181, 6, 3, '2019-02-11 09:21:19', '2019-02-11 10:10:59', 0, 0),
(711, '00:00', '00:00', '0', NULL, NULL, 181, 7, 1, NULL, NULL, 0, 0),
(712, '00:00', '00:00', '0', NULL, NULL, 181, 8, 1, NULL, NULL, 0, 0),
(713, '00:00', '00:00', '0', NULL, NULL, 181, 10, 1, NULL, NULL, 0, 0),
(714, '01:34', '06:16', '4', '2019-02-07', '2019-02-07', 182, 1, 3, '2019-02-07 13:40:47', '2019-02-07 13:47:03', 0, 0),
(715, '272:25', '1089:41', '4', '2019-02-07', '2019-02-08', 182, 2, 3, '2019-02-07 14:20:45', '2019-02-08 08:30:26', 0, 0),
(716, '02:49', '11:17', '4', '2019-02-08', '2019-02-08', 182, 3, 3, '2019-02-08 08:43:22', '2019-02-08 08:54:39', 0, 0),
(717, '35:03', '140:12', '4', '2019-02-08', '2019-02-08', 182, 4, 3, '2019-02-08 09:06:54', '2019-02-08 11:27:06', 0, 0),
(718, '00:00', '00:00', '0', NULL, NULL, 182, 5, 1, NULL, NULL, 0, 0),
(719, '15:34', '62:17', '4', '2019-02-08', '2019-02-08', 182, 6, 3, '2019-02-08 12:45:10', '2019-02-08 12:45:29', 0, 0),
(720, '00:00', '00:00', '0', NULL, NULL, 182, 7, 1, NULL, NULL, 0, 0),
(721, '00:00', '00:00', '0', NULL, NULL, 182, 8, 1, NULL, NULL, 0, 0),
(722, '00:00', '00:00', '0', NULL, NULL, 182, 10, 1, NULL, NULL, 0, 0),
(723, '06:23', '12:47', '2', '2019-02-07', '2019-02-07', 183, 1, 3, '2019-02-07 11:13:18', '2019-02-07 11:26:05', 0, 0),
(724, '544:54', '1089:49', '2', '2019-02-07', '2019-02-08', 183, 2, 3, '2019-02-07 14:20:57', '2019-02-08 08:30:46', 0, 0),
(725, '00:00', '00:00', '0', '2019-02-08', NULL, 183, 3, 4, '2019-02-08 10:19:50', NULL, 0, 1),
(726, '00:00', '00:00', '0', NULL, NULL, 183, 4, 1, NULL, NULL, 0, 0),
(727, '00:00', '00:00', '0', NULL, NULL, 183, 5, 1, NULL, NULL, 0, 0),
(728, '00:00', '00:00', '0', '2019-02-11', NULL, 183, 6, 4, '2019-02-11 07:38:42', NULL, 0, 1),
(729, '00:00', '00:00', '0', NULL, NULL, 183, 7, 1, NULL, NULL, 0, 0),
(730, '00:00', '00:00', '0', NULL, NULL, 183, 8, 1, NULL, NULL, 0, 0),
(731, '00:00', '00:00', '0', NULL, NULL, 183, 10, 1, NULL, NULL, 0, 0),
(732, '01:52', '26:10', '14', '2019-02-07', '2019-02-07', 184, 1, 3, '2019-02-07 15:55:59', '2019-02-07 16:22:09', 0, 0),
(733, '00:00', '00:00', '0', '2019-02-08', NULL, 184, 2, 4, '2019-02-08 11:09:16', NULL, 0, 1),
(734, '01:28', '20:41', '14', '2019-02-08', '2019-02-08', 184, 3, 3, '2019-02-08 12:13:44', '2019-02-08 12:34:25', 0, 0),
(735, '00:00', '00:00', '0', NULL, NULL, 184, 4, 1, NULL, NULL, 0, 0),
(736, '00:00', '00:00', '0', NULL, NULL, 184, 5, 1, NULL, NULL, 0, 0),
(737, '07:53', '110:35', '14', '2019-02-11', '2019-02-11', 184, 6, 3, '2019-02-11 10:17:13', '2019-02-11 12:07:48', 0, 0),
(738, '00:00', '00:00', '0', NULL, NULL, 184, 7, 1, NULL, NULL, 0, 0),
(739, '00:00', '00:00', '0', NULL, NULL, 184, 8, 1, NULL, NULL, 0, 0),
(740, '00:00', '00:00', '0', NULL, NULL, 184, 10, 1, NULL, NULL, 0, 0),
(741, '01:52', '26:14', '14', '2019-02-07', '2019-02-07', 185, 1, 3, '2019-02-07 15:56:06', '2019-02-07 16:22:20', 0, 0),
(742, '00:00', '00:00', '0', '2019-02-08', NULL, 185, 2, 4, '2019-02-08 11:09:48', NULL, 0, 1),
(743, '00:00', '00:16', '0', '2019-02-08', NULL, 185, 3, 4, '2019-02-08 12:34:07', NULL, 14, 1),
(744, '00:00', '00:00', '0', NULL, NULL, 185, 4, 1, NULL, NULL, 0, 0),
(745, '00:00', '00:00', '0', NULL, NULL, 185, 5, 1, NULL, NULL, 0, 0),
(746, '07:55', '110:58', '14', '2019-02-11', '2019-02-11', 185, 6, 3, '2019-02-11 10:17:05', '2019-02-11 12:08:03', 0, 0),
(747, '00:00', '00:00', '0', NULL, NULL, 185, 7, 1, NULL, NULL, 0, 0),
(748, '00:00', '00:00', '0', NULL, NULL, 185, 8, 1, NULL, NULL, 0, 0),
(749, '00:00', '00:00', '0', NULL, NULL, 185, 10, 1, NULL, NULL, 0, 0),
(750, '00:00', '00:01', '0', '2019-02-08', NULL, 186, 1, 4, '2019-02-08 14:54:20', NULL, 18, 1),
(751, '01:04', '19:18', '18', '2019-02-11', '2019-02-11', 186, 3, 3, '2019-02-11 06:56:24', '2019-02-11 07:15:42', 0, 0),
(752, '00:00', '00:00', '0', NULL, NULL, 186, 4, 1, NULL, NULL, 0, 0),
(753, '00:00', '00:00', '0', NULL, NULL, 186, 5, 1, NULL, NULL, 0, 0),
(754, '03:45', '67:30', '18', '2019-02-11', '2019-02-11', 186, 6, 3, '2019-02-11 11:33:32', '2019-02-11 12:08:40', 0, 0),
(755, '00:00', '00:00', '0', NULL, NULL, 186, 7, 1, NULL, NULL, 0, 0),
(756, '00:00', '00:00', '0', NULL, NULL, 186, 8, 1, NULL, NULL, 0, 0),
(757, '00:00', '00:00', '0', NULL, NULL, 186, 10, 1, NULL, NULL, 0, 0),
(758, '00:35', '11:49', '20', '2019-02-08', '2019-02-08', 187, 1, 3, '2019-02-08 14:42:21', '2019-02-08 14:54:10', 0, 0),
(759, '00:58', '19:28', '20', '2019-02-11', '2019-02-11', 187, 3, 3, '2019-02-11 06:56:34', '2019-02-11 07:16:02', 0, 0),
(760, '00:00', '00:00', '0', NULL, NULL, 187, 4, 1, NULL, NULL, 0, 0),
(761, '00:00', '00:00', '0', NULL, NULL, 187, 5, 1, NULL, NULL, 0, 0),
(762, '03:23', '67:49', '20', '2019-02-11', '2019-02-11', 187, 6, 3, '2019-02-11 11:33:21', '2019-02-11 12:08:47', 0, 0),
(763, '00:00', '00:00', '0', NULL, NULL, 187, 7, 1, NULL, NULL, 0, 0),
(764, '00:00', '00:00', '0', NULL, NULL, 187, 8, 1, NULL, NULL, 0, 0),
(765, '00:00', '00:00', '0', NULL, NULL, 187, 10, 1, NULL, NULL, 0, 0),
(769, '00:00', '00:00', '0', '2019-02-08', NULL, 192, 1, 4, '2019-02-08 14:16:53', NULL, 0, 1),
(770, '197:40', '197:40', '1', '2019-02-11', '2019-02-11', 192, 2, 3, '2019-02-11 11:03:18', '2019-02-11 14:20:58', 0, 0),
(771, '00:00', '00:00', '0', NULL, NULL, 192, 3, 1, NULL, NULL, 0, 0),
(772, '00:00', '00:00', '0', NULL, NULL, 192, 4, 1, NULL, NULL, 0, 0),
(773, '00:00', '00:00', '0', NULL, NULL, 192, 5, 1, NULL, NULL, 0, 0),
(774, '00:00', '00:00', '0', NULL, NULL, 192, 6, 1, NULL, NULL, 0, 0),
(775, '00:00', '00:00', '0', NULL, NULL, 192, 7, 1, NULL, NULL, 0, 0),
(776, '00:00', '00:00', '0', NULL, NULL, 192, 8, 1, NULL, NULL, 0, 0),
(777, '00:00', '00:00', '0', NULL, NULL, 192, 10, 1, NULL, NULL, 0, 0),
(778, '00:00', '00:00', '0', '2019-02-08', NULL, 193, 1, 4, '2019-02-08 14:16:43', NULL, 0, 1),
(779, '198:03', '198:03', '1', '2019-02-11', '2019-02-11', 193, 2, 3, '2019-02-11 11:04:10', '2019-02-11 14:22:13', 0, 0),
(780, '00:00', '00:00', '0', NULL, NULL, 193, 3, 1, NULL, NULL, 0, 0),
(781, '00:00', '00:00', '0', NULL, NULL, 193, 4, 1, NULL, NULL, 0, 0),
(782, '00:00', '00:00', '0', NULL, NULL, 193, 5, 1, NULL, NULL, 0, 0),
(783, '00:00', '00:00', '0', NULL, NULL, 193, 6, 1, NULL, NULL, 0, 0),
(784, '00:00', '00:00', '0', NULL, NULL, 193, 7, 1, NULL, NULL, 0, 0),
(785, '00:00', '00:00', '0', NULL, NULL, 193, 8, 1, NULL, NULL, 0, 0),
(786, '00:00', '00:00', '0', NULL, NULL, 193, 10, 1, NULL, NULL, 0, 0),
(787, '00:00', '00:00', '0', NULL, NULL, 194, 1, 1, NULL, NULL, 0, 0),
(788, '00:00', '00:00', '0', NULL, NULL, 194, 2, 1, NULL, NULL, 0, 0),
(789, '00:00', '00:00', '0', NULL, NULL, 194, 3, 1, NULL, NULL, 0, 0),
(790, '00:00', '00:00', '0', NULL, NULL, 194, 4, 1, NULL, NULL, 0, 0),
(791, '00:00', '00:00', '0', NULL, NULL, 194, 5, 1, NULL, NULL, 0, 0),
(792, '00:00', '00:00', '0', NULL, NULL, 194, 6, 1, NULL, NULL, 0, 0),
(793, '00:00', '00:00', '0', NULL, NULL, 194, 7, 1, NULL, NULL, 0, 0),
(794, '00:00', '00:00', '0', NULL, NULL, 194, 8, 1, NULL, NULL, 0, 0),
(795, '00:00', '00:00', '0', NULL, NULL, 194, 10, 1, NULL, NULL, 0, 0),
(799, '00:00', '00:00', '0', NULL, NULL, 199, 1, 1, NULL, NULL, 0, 0),
(800, '00:00', '00:00', '0', NULL, NULL, 199, 2, 1, NULL, NULL, 0, 0),
(801, '00:00', '00:00', '0', NULL, NULL, 199, 3, 1, NULL, NULL, 0, 0),
(802, '00:00', '00:00', '0', NULL, NULL, 199, 4, 1, NULL, NULL, 0, 0),
(803, '00:00', '00:00', '0', NULL, NULL, 199, 5, 1, NULL, NULL, 0, 0),
(804, '00:00', '00:00', '0', NULL, NULL, 199, 6, 1, NULL, NULL, 0, 0),
(805, '00:00', '00:00', '0', NULL, NULL, 199, 7, 1, NULL, NULL, 0, 0),
(806, '00:00', '00:00', '0', NULL, NULL, 199, 8, 1, NULL, NULL, 0, 0),
(807, '00:00', '00:00', '0', NULL, NULL, 199, 10, 1, NULL, NULL, 0, 0),
(808, '00:00', '00:00', '0', NULL, NULL, 200, 1, 1, NULL, NULL, 0, 0),
(809, '00:00', '00:00', '0', NULL, NULL, 200, 2, 1, NULL, NULL, 0, 0),
(810, '00:00', '00:00', '0', NULL, NULL, 200, 3, 1, NULL, NULL, 0, 0),
(811, '00:00', '00:00', '0', NULL, NULL, 200, 4, 1, NULL, NULL, 0, 0),
(812, '00:00', '00:00', '0', NULL, NULL, 200, 5, 1, NULL, NULL, 0, 0),
(813, '00:00', '00:00', '0', NULL, NULL, 200, 6, 1, NULL, NULL, 0, 0),
(814, '00:00', '00:00', '0', NULL, NULL, 200, 7, 1, NULL, NULL, 0, 0),
(815, '00:00', '00:00', '0', NULL, NULL, 200, 8, 1, NULL, NULL, 0, 0),
(816, '00:00', '00:00', '0', NULL, NULL, 200, 10, 1, NULL, NULL, 0, 0),
(817, '00:00', '00:00', '0', NULL, NULL, 201, 1, 1, NULL, NULL, 0, 0),
(818, '00:00', '00:00', '0', NULL, NULL, 201, 2, 1, NULL, NULL, 0, 0),
(819, '00:00', '00:00', '0', NULL, NULL, 201, 3, 1, NULL, NULL, 0, 0),
(820, '00:00', '00:00', '0', NULL, NULL, 201, 4, 1, NULL, NULL, 0, 0),
(821, '00:00', '00:00', '0', NULL, NULL, 201, 5, 1, NULL, NULL, 0, 0),
(822, '00:00', '00:00', '0', NULL, NULL, 201, 6, 1, NULL, NULL, 0, 0),
(823, '00:00', '00:00', '0', NULL, NULL, 201, 7, 1, NULL, NULL, 0, 0),
(824, '00:00', '00:00', '0', NULL, NULL, 201, 8, 1, NULL, NULL, 0, 0),
(825, '00:00', '00:00', '0', NULL, NULL, 201, 10, 1, NULL, NULL, 0, 0),
(826, '02:38', '15:53', '6', '2019-02-08', '2019-02-08', 202, 1, 3, '2019-02-08 15:33:44', '2019-02-08 15:33:55', 0, 0),
(827, '33:10', '199:05', '6', '2019-02-11', '2019-02-11', 202, 2, 3, '2019-02-11 11:02:50', '2019-02-11 14:21:55', 0, 0),
(828, '00:00', '00:00', '0', NULL, NULL, 202, 3, 1, NULL, NULL, 0, 0),
(829, '00:00', '00:00', '0', NULL, NULL, 202, 4, 1, NULL, NULL, 0, 0),
(830, '00:00', '00:00', '0', NULL, NULL, 202, 5, 1, NULL, NULL, 0, 0),
(831, '00:00', '00:00', '0', NULL, NULL, 202, 6, 1, NULL, NULL, 0, 0),
(832, '00:00', '00:00', '0', NULL, NULL, 202, 7, 1, NULL, NULL, 0, 0),
(833, '00:00', '00:00', '0', NULL, NULL, 202, 8, 1, NULL, NULL, 0, 0),
(834, '00:00', '00:00', '0', NULL, NULL, 202, 10, 1, NULL, NULL, 0, 0),
(835, '00:00', '00:00', '0', NULL, NULL, 203, 1, 1, NULL, NULL, 0, 0),
(836, '00:00', '00:00', '0', NULL, NULL, 203, 2, 1, NULL, NULL, 0, 0),
(837, '00:00', '00:00', '0', NULL, NULL, 203, 3, 1, NULL, NULL, 0, 0),
(838, '00:00', '00:00', '0', NULL, NULL, 203, 4, 1, NULL, NULL, 0, 0),
(839, '00:00', '00:00', '0', NULL, NULL, 203, 5, 1, NULL, NULL, 0, 0),
(840, '00:00', '00:00', '0', NULL, NULL, 203, 6, 1, NULL, NULL, 0, 0),
(841, '00:00', '00:00', '0', NULL, NULL, 203, 7, 1, NULL, NULL, 0, 0),
(842, '00:00', '00:00', '0', NULL, NULL, 203, 8, 1, NULL, NULL, 0, 0),
(843, '00:00', '00:00', '0', NULL, NULL, 203, 10, 1, NULL, NULL, 0, 0),
(860, '00:17', '00:17', '1', '2019-02-14', '2019-02-14', 215, 1, 3, '2019-02-14 10:48:26', '2019-02-14 10:48:43', 0, 0),
(861, '00:00', '00:00', '0', NULL, NULL, 215, 2, 1, NULL, NULL, 0, 0),
(862, '00:00', '00:00', '0', NULL, NULL, 215, 3, 1, NULL, NULL, 0, 0),
(863, '00:00', '00:00', '0', NULL, NULL, 215, 4, 1, NULL, NULL, 0, 0),
(864, '00:00', '00:00', '0', NULL, NULL, 215, 5, 1, NULL, NULL, 0, 0),
(865, '00:00', '00:00', '0', NULL, NULL, 215, 6, 1, NULL, NULL, 0, 0),
(866, '00:00', '00:00', '0', NULL, NULL, 215, 7, 1, NULL, NULL, 0, 0),
(867, '01:00', '01:00', '1', '2019-02-14', '2019-02-14', 215, 8, 3, '2019-02-14 13:04:41', '2019-02-14 13:05:41', 0, 0),
(868, '00:00', '00:00', '0', NULL, NULL, 215, 10, 1, NULL, NULL, 0, 0),
(869, '00:00', '16:35', '5', '2019-02-15', NULL, 216, 1, 2, '2019-02-15 16:22:38', '2019-02-15 16:22:51', 45, 0),
(870, '00:00', '00:00', '0', NULL, NULL, 216, 3, 1, NULL, NULL, 0, 0),
(871, '00:00', '00:00', '0', NULL, NULL, 216, 4, 1, NULL, NULL, 0, 0),
(872, '00:00', '00:00', '0', NULL, NULL, 216, 5, 1, NULL, NULL, 0, 0),
(873, '00:00', '00:00', '0', NULL, NULL, 216, 7, 1, NULL, NULL, 0, 0),
(874, '00:00', '00:00', '0', NULL, NULL, 216, 8, 1, NULL, NULL, 0, 0),
(875, '00:00', '00:00', '0', NULL, NULL, 216, 10, 1, NULL, NULL, 0, 0),
(876, '00:00', '00:00', '0', NULL, NULL, 217, 1, 1, NULL, NULL, 0, 0),
(877, '00:00', '00:00', '0', NULL, NULL, 217, 2, 1, NULL, NULL, 0, 0),
(878, '00:00', '1993:42', '0', '2019-02-14', NULL, 217, 3, 2, '2019-02-14 07:19:17', '2019-02-15 16:23:31', 5, 0),
(879, '00:00', '00:00', '0', NULL, NULL, 217, 4, 1, NULL, NULL, 0, 0),
(880, '00:00', '00:00', '0', NULL, NULL, 217, 5, 1, NULL, NULL, 0, 0),
(881, '00:00', '00:00', '0', NULL, NULL, 217, 6, 1, NULL, NULL, 0, 0),
(882, '00:00', '00:00', '0', NULL, NULL, 217, 7, 1, NULL, NULL, 0, 0),
(883, '00:00', '00:00', '0', NULL, NULL, 217, 8, 1, NULL, NULL, 0, 0),
(884, '00:00', '00:00', '0', NULL, NULL, 217, 10, 1, NULL, NULL, 0, 0),
(885, '00:00', '00:00', '0', NULL, NULL, 218, 1, 1, NULL, NULL, 0, 0),
(886, '00:00', '00:00', '0', NULL, NULL, 218, 2, 1, NULL, NULL, 0, 0),
(887, '10:16', '20:33', '2', '2019-02-14', '2019-02-14', 218, 3, 3, '2019-02-14 06:43:10', '2019-02-14 07:03:43', 0, 0),
(888, '00:00', '00:00', '0', NULL, NULL, 218, 4, 1, NULL, NULL, 0, 0),
(889, '00:00', '00:00', '0', NULL, NULL, 218, 5, 1, NULL, NULL, 0, 0),
(890, '00:00', '00:00', '0', NULL, NULL, 218, 6, 1, NULL, NULL, 0, 0),
(891, '00:00', '00:00', '0', NULL, NULL, 218, 7, 1, NULL, NULL, 0, 0),
(892, '00:00', '00:00', '0', NULL, NULL, 218, 8, 1, NULL, NULL, 0, 0),
(893, '00:00', '00:00', '0', NULL, NULL, 218, 10, 1, NULL, NULL, 0, 0),
(894, '00:00', '00:51', '0', '2019-02-20', NULL, 219, 1, 2, '2019-02-20 07:35:02', '2019-02-20 07:35:53', 60, 0),
(895, '00:00', '00:00', '0', NULL, NULL, 219, 3, 1, NULL, NULL, 0, 0),
(896, '00:00', '00:00', '0', NULL, NULL, 219, 4, 1, NULL, NULL, 0, 0),
(897, '00:00', '00:00', '0', NULL, NULL, 219, 5, 1, NULL, NULL, 0, 0),
(898, '00:00', '00:00', '0', NULL, NULL, 219, 6, 1, NULL, NULL, 0, 0),
(899, '00:00', '00:00', '0', NULL, NULL, 219, 7, 1, NULL, NULL, 0, 0),
(900, '00:00', '00:00', '0', NULL, NULL, 219, 8, 1, NULL, NULL, 0, 0),
(901, '00:00', '00:00', '0', NULL, NULL, 219, 10, 1, NULL, NULL, 0, 0),
(902, '00:00', '00:00', '0', NULL, NULL, 221, 1, 1, NULL, NULL, 0, 0),
(903, '00:00', '00:00', '0', NULL, NULL, 221, 3, 1, NULL, NULL, 0, 0),
(904, '00:00', '00:00', '0', NULL, NULL, 221, 4, 1, NULL, NULL, 0, 0),
(905, '00:00', '00:00', '0', NULL, NULL, 221, 5, 1, NULL, NULL, 0, 0),
(906, '00:00', '00:00', '0', NULL, NULL, 221, 6, 1, NULL, NULL, 0, 0),
(907, '00:00', '00:00', '0', NULL, NULL, 221, 7, 1, NULL, NULL, 0, 0),
(908, '00:00', '00:00', '0', NULL, NULL, 221, 8, 1, NULL, NULL, 0, 0),
(909, '00:00', '00:00', '0', NULL, NULL, 221, 9, 1, NULL, NULL, 0, 0),
(910, '00:00', '00:00', '0', NULL, NULL, 221, 10, 1, NULL, NULL, 0, 0),
(911, '00:00', '00:00', '0', NULL, NULL, 223, 1, 1, NULL, NULL, 0, 0),
(912, '00:00', '00:00', '0', NULL, NULL, 223, 3, 1, NULL, NULL, 0, 0),
(913, '00:00', '00:00', '0', NULL, NULL, 223, 4, 1, NULL, NULL, 0, 0),
(914, '00:00', '00:00', '0', NULL, NULL, 224, 1, 1, NULL, NULL, 0, 0),
(915, '00:00', '00:00', '0', NULL, NULL, 224, 2, 1, NULL, NULL, 0, 0),
(916, '00:00', '00:00', '0', NULL, NULL, 224, 3, 1, NULL, NULL, 0, 0),
(917, '00:00', '00:00', '0', NULL, NULL, 224, 4, 1, NULL, NULL, 0, 0),
(918, '00:00', '00:00', '0', NULL, NULL, 224, 5, 1, NULL, NULL, 0, 0),
(919, '00:00', '00:00', '0', NULL, NULL, 224, 6, 1, NULL, NULL, 0, 0),
(920, '00:00', '00:00', '0', NULL, NULL, 224, 7, 1, NULL, NULL, 0, 0),
(921, '00:00', '00:00', '0', NULL, NULL, 224, 8, 1, NULL, NULL, 0, 0),
(922, '00:00', '00:00', '0', NULL, NULL, 224, 10, 1, NULL, NULL, 0, 0),
(936, '00:00', '00:00', '0', NULL, NULL, 229, 1, 1, NULL, NULL, 0, 0),
(937, '00:00', '00:00', '0', NULL, NULL, 229, 3, 1, NULL, NULL, 0, 0),
(938, '00:00', '00:00', '0', NULL, NULL, 229, 4, 1, NULL, NULL, 0, 0),
(939, '00:00', '00:00', '0', NULL, NULL, 229, 5, 1, NULL, NULL, 0, 0),
(940, '00:00', '00:00', '0', NULL, NULL, 229, 6, 1, NULL, NULL, 0, 0),
(941, '00:00', '00:00', '0', NULL, NULL, 229, 7, 1, NULL, NULL, 0, 0),
(942, '00:00', '00:00', '0', NULL, NULL, 229, 8, 1, NULL, NULL, 0, 0),
(943, '00:00', '00:00', '0', NULL, NULL, 229, 10, 1, NULL, NULL, 0, 0),
(944, '00:00', '00:00', '0', NULL, NULL, 230, 1, 1, NULL, NULL, 0, 0),
(945, '00:00', '00:00', '0', NULL, NULL, 230, 3, 1, NULL, NULL, 0, 0),
(946, '00:00', '00:00', '0', NULL, NULL, 230, 4, 1, NULL, NULL, 0, 0),
(947, '00:00', '00:00', '0', NULL, NULL, 230, 5, 1, NULL, NULL, 0, 0),
(948, '55:00', '55:00', '1', '2019-02-14', '2019-02-14', 230, 6, 3, '2019-02-14 09:58:39', '2019-02-14 10:53:39', 0, 0),
(949, '00:00', '00:00', '0', NULL, NULL, 230, 7, 1, NULL, NULL, 0, 0),
(950, '00:00', '00:00', '0', NULL, NULL, 230, 8, 1, NULL, NULL, 0, 0),
(951, '00:00', '00:00', '0', NULL, NULL, 230, 10, 1, NULL, NULL, 0, 0),
(952, '00:00', '00:00', '0', NULL, NULL, 231, 1, 1, NULL, NULL, 0, 0),
(953, '00:00', '00:00', '0', NULL, NULL, 231, 3, 1, NULL, NULL, 0, 0),
(954, '00:00', '00:00', '0', NULL, NULL, 231, 4, 1, NULL, NULL, 0, 0),
(955, '00:00', '00:00', '0', NULL, NULL, 231, 5, 1, NULL, NULL, 0, 0),
(956, '63:07', '63:07', '1', '2019-02-14', '2019-02-14', 231, 6, 3, '2019-02-14 09:50:49', '2019-02-14 10:53:56', 0, 0),
(957, '00:00', '00:00', '0', NULL, NULL, 231, 7, 1, NULL, NULL, 0, 0),
(958, '00:00', '00:00', '0', NULL, NULL, 231, 8, 1, NULL, NULL, 0, 0),
(959, '00:00', '00:00', '0', NULL, NULL, 231, 9, 1, NULL, NULL, 0, 0),
(960, '00:00', '00:00', '0', NULL, NULL, 231, 10, 1, NULL, NULL, 0, 0),
(961, '00:00', '00:00', '0', NULL, NULL, 232, 1, 1, NULL, NULL, 0, 0),
(962, '00:00', '00:00', '0', NULL, NULL, 232, 2, 1, NULL, NULL, 0, 0),
(963, '00:00', '00:00', '0', NULL, NULL, 232, 3, 1, NULL, NULL, 0, 0),
(964, '00:00', '00:00', '0', NULL, NULL, 232, 4, 1, NULL, NULL, 0, 0),
(965, '00:00', '00:00', '0', NULL, NULL, 232, 5, 1, NULL, NULL, 0, 0),
(966, '00:00', '00:00', '0', NULL, NULL, 232, 7, 1, NULL, NULL, 0, 0),
(967, '00:00', '00:00', '0', NULL, NULL, 232, 8, 1, NULL, NULL, 0, 0),
(968, '00:00', '00:00', '0', NULL, NULL, 232, 10, 1, NULL, NULL, 0, 0),
(969, '00:00', '00:00', '0', NULL, NULL, 233, 1, 1, NULL, NULL, 0, 0),
(970, '00:00', '00:00', '0', NULL, NULL, 233, 3, 1, NULL, NULL, 0, 0),
(971, '00:00', '00:00', '0', NULL, NULL, 233, 4, 1, NULL, NULL, 0, 0),
(972, '00:00', '00:00', '0', NULL, NULL, 233, 5, 1, NULL, NULL, 0, 0),
(973, '00:00', '00:00', '0', NULL, NULL, 233, 7, 1, NULL, NULL, 0, 0),
(974, '00:00', '00:00', '0', NULL, NULL, 233, 8, 1, NULL, NULL, 0, 0),
(975, '00:00', '00:00', '0', NULL, NULL, 233, 10, 1, NULL, NULL, 0, 0),
(976, '00:00', '00:00', '0', NULL, NULL, 234, 1, 1, NULL, NULL, 0, 0),
(977, '00:00', '00:00', '0', NULL, NULL, 234, 2, 1, NULL, NULL, 0, 0),
(978, '00:00', '00:00', '0', NULL, NULL, 234, 3, 1, NULL, NULL, 0, 0),
(979, '00:00', '00:00', '0', NULL, NULL, 234, 4, 1, NULL, NULL, 0, 0),
(980, '00:00', '00:00', '0', NULL, NULL, 234, 5, 1, NULL, NULL, 0, 0),
(981, '00:00', '00:00', '0', NULL, NULL, 234, 6, 1, NULL, NULL, 0, 0),
(982, '00:00', '00:00', '0', NULL, NULL, 234, 7, 1, NULL, NULL, 0, 0),
(983, '00:00', '00:00', '0', NULL, NULL, 234, 8, 1, NULL, NULL, 0, 0),
(984, '00:00', '00:00', '0', NULL, NULL, 234, 10, 1, NULL, NULL, 0, 0),
(985, '00:00', '00:00', '0', NULL, NULL, 235, 1, 1, NULL, NULL, 0, 0),
(986, '00:00', '00:00', '0', NULL, NULL, 235, 3, 1, NULL, NULL, 0, 0),
(987, '00:00', '00:00', '0', NULL, NULL, 235, 4, 1, NULL, NULL, 0, 0),
(988, '00:00', '00:00', '0', NULL, NULL, 235, 5, 1, NULL, NULL, 0, 0),
(989, '00:00', '00:00', '0', NULL, NULL, 235, 6, 1, NULL, NULL, 0, 0),
(990, '00:00', '00:00', '0', NULL, NULL, 235, 7, 1, NULL, NULL, 0, 0),
(991, '00:00', '00:00', '0', NULL, NULL, 235, 8, 1, NULL, NULL, 0, 0),
(992, '00:00', '00:00', '0', NULL, NULL, 235, 10, 1, NULL, NULL, 0, 0),
(993, '00:00', '00:00', '0', NULL, NULL, 236, 1, 1, NULL, NULL, 0, 0),
(994, '00:00', '00:00', '0', NULL, NULL, 236, 3, 1, NULL, NULL, 0, 0),
(995, '00:00', '00:00', '0', NULL, NULL, 236, 4, 1, NULL, NULL, 0, 0),
(996, '00:00', '00:00', '0', NULL, NULL, 236, 5, 1, NULL, NULL, 0, 0),
(997, '00:00', '00:00', '0', NULL, NULL, 236, 6, 1, NULL, NULL, 0, 0),
(998, '00:00', '00:00', '0', NULL, NULL, 236, 7, 1, NULL, NULL, 0, 0),
(999, '00:00', '00:00', '0', NULL, NULL, 236, 8, 1, NULL, NULL, 0, 0),
(1000, '00:00', '00:00', '0', NULL, NULL, 236, 10, 1, NULL, NULL, 0, 0),
(1001, '00:00', '00:00', '0', NULL, NULL, 237, 1, 1, NULL, NULL, 0, 0),
(1002, '00:00', '00:00', '0', NULL, NULL, 237, 3, 1, NULL, NULL, 0, 0),
(1003, '00:00', '00:00', '0', NULL, NULL, 237, 4, 1, NULL, NULL, 0, 0),
(1004, '00:00', '00:00', '0', NULL, NULL, 237, 5, 1, NULL, NULL, 0, 0),
(1005, '00:00', '00:00', '0', NULL, NULL, 237, 6, 1, NULL, NULL, 0, 0),
(1006, '00:00', '00:00', '0', NULL, NULL, 237, 7, 1, NULL, NULL, 0, 0),
(1007, '00:00', '00:00', '0', NULL, NULL, 237, 8, 1, NULL, NULL, 0, 0),
(1008, '00:00', '00:00', '0', NULL, NULL, 237, 10, 1, NULL, NULL, 0, 0),
(1009, '00:00', '00:00', '0', NULL, NULL, 238, 1, 1, NULL, NULL, 0, 0),
(1010, '00:00', '00:00', '0', NULL, NULL, 238, 2, 1, NULL, NULL, 0, 0),
(1011, '00:00', '00:00', '0', NULL, NULL, 238, 3, 1, NULL, NULL, 0, 0),
(1012, '00:00', '00:00', '0', NULL, NULL, 238, 4, 1, NULL, NULL, 0, 0),
(1013, '00:00', '00:00', '0', NULL, NULL, 238, 5, 1, NULL, NULL, 0, 0),
(1014, '00:00', '00:00', '0', NULL, NULL, 238, 6, 1, NULL, NULL, 0, 0),
(1015, '00:00', '00:00', '0', NULL, NULL, 238, 7, 1, NULL, NULL, 0, 0),
(1016, '00:00', '00:00', '0', NULL, NULL, 238, 8, 1, NULL, NULL, 0, 0),
(1017, '00:00', '00:00', '0', NULL, NULL, 238, 10, 1, NULL, NULL, 0, 0),
(1018, '00:00', '00:00', '0', NULL, NULL, 240, 1, 1, NULL, NULL, 0, 0),
(1019, '00:00', '00:00', '0', NULL, NULL, 240, 2, 1, NULL, NULL, 0, 0),
(1020, '00:00', '00:00', '0', NULL, NULL, 240, 3, 1, NULL, NULL, 0, 0),
(1021, '00:00', '00:00', '0', NULL, NULL, 240, 4, 1, NULL, NULL, 0, 0),
(1022, '00:00', '00:00', '0', NULL, NULL, 240, 5, 1, NULL, NULL, 0, 0),
(1023, '00:00', '00:00', '0', NULL, NULL, 240, 6, 1, NULL, NULL, 0, 0),
(1024, '00:00', '00:00', '0', NULL, NULL, 240, 7, 1, NULL, NULL, 0, 0),
(1025, '00:00', '00:00', '0', NULL, NULL, 240, 8, 1, NULL, NULL, 0, 0),
(1026, '00:00', '00:00', '0', NULL, NULL, 240, 9, 1, NULL, NULL, 0, 0),
(1027, '00:00', '00:00', '0', NULL, NULL, 240, 10, 1, NULL, NULL, 0, 0),
(1028, '00:00', '00:00', '0', NULL, NULL, 242, 1, 1, NULL, NULL, 0, 0),
(1029, '00:00', '00:00', '0', NULL, NULL, 242, 2, 1, NULL, NULL, 0, 0),
(1030, '00:00', '00:00', '0', NULL, NULL, 242, 3, 1, NULL, NULL, 0, 0),
(1031, '00:00', '00:00', '0', NULL, NULL, 242, 4, 1, NULL, NULL, 0, 0),
(1032, '00:00', '00:00', '0', NULL, NULL, 242, 5, 1, NULL, NULL, 0, 0),
(1033, '00:00', '00:00', '0', NULL, NULL, 242, 6, 1, NULL, NULL, 0, 0),
(1034, '00:00', '00:00', '0', NULL, NULL, 242, 7, 1, NULL, NULL, 0, 0),
(1035, '00:00', '00:00', '0', NULL, NULL, 242, 8, 1, NULL, NULL, 0, 0),
(1036, '00:00', '00:00', '0', NULL, NULL, 242, 10, 1, NULL, NULL, 0, 0),
(1037, '00:00', '00:00', '0', NULL, NULL, 243, 1, 1, NULL, NULL, 0, 0),
(1038, '00:00', '00:00', '0', NULL, NULL, 243, 2, 1, NULL, NULL, 0, 0),
(1039, '00:00', '00:00', '0', NULL, NULL, 243, 3, 1, NULL, NULL, 0, 0),
(1040, '00:00', '00:00', '0', NULL, NULL, 243, 4, 1, NULL, NULL, 0, 0),
(1041, '00:00', '00:00', '0', NULL, NULL, 243, 5, 1, NULL, NULL, 0, 0),
(1042, '00:00', '00:00', '0', NULL, NULL, 243, 6, 1, NULL, NULL, 0, 0),
(1043, '00:00', '00:00', '0', NULL, NULL, 243, 7, 1, NULL, NULL, 0, 0),
(1044, '00:00', '00:00', '0', NULL, NULL, 243, 8, 1, NULL, NULL, 0, 0),
(1045, '00:00', '00:00', '0', NULL, NULL, 243, 10, 1, NULL, NULL, 0, 0),
(1046, '00:00', '00:00', '0', NULL, NULL, 244, 1, 1, NULL, NULL, 0, 0),
(1047, '00:00', '00:00', '0', NULL, NULL, 244, 3, 1, NULL, NULL, 0, 0),
(1048, '00:00', '00:00', '0', NULL, NULL, 244, 4, 1, NULL, NULL, 0, 0),
(1049, '00:00', '00:00', '0', NULL, NULL, 244, 5, 1, NULL, NULL, 0, 0),
(1050, '00:00', '00:00', '0', '2019-02-20', NULL, 244, 6, 4, '2019-02-20 10:19:44', NULL, 0, 1),
(1051, '00:00', '00:00', '0', NULL, NULL, 244, 7, 1, NULL, NULL, 0, 0),
(1052, '00:00', '00:00', '0', NULL, NULL, 244, 8, 1, NULL, NULL, 0, 0),
(1053, '00:00', '00:00', '0', NULL, NULL, 244, 10, 1, NULL, NULL, 0, 0),
(1054, '00:00', '00:00', '0', NULL, NULL, 245, 1, 1, NULL, NULL, 0, 0),
(1055, '00:00', '00:00', '0', NULL, NULL, 245, 2, 1, NULL, NULL, 0, 0),
(1056, '00:00', '00:00', '0', '2019-02-20', NULL, 245, 3, 4, '2019-02-20 15:48:17', NULL, 0, 1),
(1057, '00:00', '00:00', '0', NULL, NULL, 245, 4, 1, NULL, NULL, 0, 0),
(1058, '00:00', '00:00', '0', NULL, NULL, 245, 5, 1, NULL, NULL, 0, 0),
(1059, '07:27', '223:35', '30', '2019-02-22', '2019-02-22', 245, 6, 3, '2019-02-22 08:49:29', '2019-02-22 10:51:56', 0, 0),
(1060, '00:00', '00:00', '0', NULL, NULL, 245, 7, 1, NULL, NULL, 0, 0),
(1061, '00:00', '00:00', '0', NULL, NULL, 245, 8, 1, NULL, NULL, 0, 0),
(1062, '00:00', '00:00', '0', NULL, NULL, 245, 10, 1, NULL, NULL, 0, 0),
(1063, '00:00', '00:00', '0', NULL, NULL, 247, 1, 1, NULL, NULL, 0, 0),
(1064, '00:00', '00:00', '0', NULL, NULL, 247, 2, 1, NULL, NULL, 0, 0),
(1065, '00:00', '00:00', '0', NULL, NULL, 247, 3, 1, NULL, NULL, 0, 0),
(1066, '00:00', '00:00', '0', NULL, NULL, 247, 4, 1, NULL, NULL, 0, 0),
(1067, '00:00', '00:00', '0', NULL, NULL, 247, 5, 1, NULL, NULL, 0, 0),
(1068, '00:00', '00:00', '0', NULL, NULL, 247, 6, 1, NULL, NULL, 0, 0),
(1069, '00:00', '00:00', '0', NULL, NULL, 247, 7, 1, NULL, NULL, 0, 0),
(1070, '00:00', '00:00', '0', NULL, NULL, 247, 8, 1, NULL, NULL, 0, 0),
(1071, '00:00', '00:00', '0', NULL, NULL, 247, 9, 1, NULL, NULL, 0, 0),
(1072, '00:00', '00:00', '0', NULL, NULL, 247, 10, 1, NULL, NULL, 0, 0),
(1073, '00:00', '00:00', '0', NULL, NULL, 249, 1, 1, NULL, NULL, 0, 0),
(1074, '00:00', '00:00', '0', NULL, NULL, 249, 3, 1, NULL, NULL, 0, 0),
(1075, '00:00', '00:00', '0', NULL, NULL, 249, 4, 1, NULL, NULL, 0, 0),
(1076, '00:00', '00:00', '0', NULL, NULL, 249, 5, 1, NULL, NULL, 0, 0),
(1077, '00:00', '00:00', '0', NULL, NULL, 249, 6, 1, NULL, NULL, 0, 0),
(1078, '00:00', '01:22', '100', '2019-02-21', '2019-02-21', 249, 7, 3, '2019-02-21 11:20:12', '2019-02-21 11:21:34', 0, 0),
(1079, '00:00', '00:00', '0', '2019-02-21', NULL, 249, 8, 4, '2019-02-21 11:23:26', NULL, 0, 1),
(1080, '00:00', '00:00', '0', NULL, NULL, 249, 10, 1, NULL, NULL, 0, 0),
(1084, '00:00', '00:00', '0', NULL, NULL, 250, 1, 1, NULL, NULL, 0, 0),
(1085, '00:00', '00:00', '0', NULL, NULL, 250, 2, 1, NULL, NULL, 0, 0),
(1086, '00:00', '00:00', '0', NULL, NULL, 250, 3, 1, NULL, NULL, 0, 0),
(1087, '00:00', '00:00', '0', NULL, NULL, 250, 4, 1, NULL, NULL, 0, 0),
(1088, '00:00', '00:00', '0', NULL, NULL, 250, 5, 1, NULL, NULL, 0, 0),
(1089, '00:00', '00:00', '0', NULL, NULL, 250, 6, 1, NULL, NULL, 0, 0),
(1090, '00:00', '00:00', '0', NULL, NULL, 250, 7, 1, NULL, NULL, 0, 0),
(1091, '00:00', '00:00', '0', NULL, NULL, 250, 8, 1, NULL, NULL, 0, 0),
(1092, '00:00', '00:00', '0', NULL, NULL, 250, 10, 1, NULL, NULL, 0, 0),
(1093, '00:00', '00:00', '0', NULL, NULL, 251, 1, 1, NULL, NULL, 0, 0),
(1094, '00:00', '00:00', '0', NULL, NULL, 251, 2, 1, NULL, NULL, 0, 0),
(1095, '00:00', '00:00', '0', NULL, NULL, 251, 3, 1, NULL, NULL, 0, 0),
(1096, '00:00', '00:00', '0', NULL, NULL, 251, 4, 1, NULL, NULL, 0, 0),
(1097, '00:00', '00:00', '0', NULL, NULL, 251, 5, 1, NULL, NULL, 0, 0),
(1098, '00:00', '00:00', '0', NULL, NULL, 251, 7, 1, NULL, NULL, 0, 0),
(1099, '00:00', '00:00', '0', NULL, NULL, 251, 8, 1, NULL, NULL, 0, 0),
(1100, '00:00', '00:00', '0', NULL, NULL, 251, 10, 1, NULL, NULL, 0, 0),
(1101, '00:12', '00:24', '2', '2019-02-15', '2019-02-15', 255, 1, 3, '2019-02-15 09:29:40', '2019-02-15 09:30:04', 0, 0),
(1102, '00:00', '00:00', '0', NULL, NULL, 255, 2, 1, NULL, NULL, 0, 0),
(1103, '00:00', '00:00', '0', NULL, NULL, 255, 3, 1, NULL, NULL, 0, 0),
(1104, '00:00', '00:00', '0', NULL, NULL, 255, 4, 1, NULL, NULL, 0, 0),
(1105, '00:00', '00:00', '0', NULL, NULL, 255, 5, 1, NULL, NULL, 0, 0),
(1106, '00:00', '00:00', '0', NULL, NULL, 255, 6, 1, NULL, NULL, 0, 0),
(1107, '00:00', '00:00', '0', NULL, NULL, 255, 7, 1, NULL, NULL, 0, 0),
(1108, '00:00', '00:00', '0', NULL, NULL, 255, 8, 1, NULL, NULL, 0, 0),
(1109, '00:00', '00:00', '0', NULL, NULL, 255, 10, 1, NULL, NULL, 0, 0),
(1119, '00:00', '00:00', '0', NULL, NULL, 258, 1, 1, NULL, NULL, 0, 0),
(1120, '00:00', '00:00', '0', NULL, NULL, 258, 2, 1, NULL, NULL, 0, 0),
(1121, '00:00', '00:00', '0', NULL, NULL, 258, 3, 1, NULL, NULL, 0, 0),
(1122, '00:00', '00:00', '0', NULL, NULL, 258, 4, 1, NULL, NULL, 0, 0),
(1123, '00:00', '00:00', '0', NULL, NULL, 258, 5, 1, NULL, NULL, 0, 0),
(1124, '00:00', '00:00', '0', NULL, NULL, 258, 6, 1, NULL, NULL, 0, 0),
(1125, '00:00', '00:00', '0', NULL, NULL, 258, 7, 1, NULL, NULL, 0, 0),
(1126, '00:00', '00:00', '0', NULL, NULL, 258, 8, 1, NULL, NULL, 0, 0),
(1127, '00:00', '00:00', '0', NULL, NULL, 258, 9, 1, NULL, NULL, 0, 0),
(1128, '00:00', '00:00', '0', NULL, NULL, 258, 10, 1, NULL, NULL, 0, 0),
(1129, '00:00', '00:00', '0', NULL, NULL, 260, 1, 1, NULL, NULL, 0, 0),
(1130, '00:00', '00:00', '0', NULL, NULL, 260, 2, 1, NULL, NULL, 0, 0),
(1131, '00:00', '00:00', '0', NULL, NULL, 260, 3, 1, NULL, NULL, 0, 0),
(1132, '00:00', '00:00', '0', NULL, NULL, 260, 4, 1, NULL, NULL, 0, 0),
(1133, '00:00', '00:00', '0', NULL, NULL, 260, 5, 1, NULL, NULL, 0, 0),
(1134, '00:00', '00:00', '0', NULL, NULL, 260, 6, 1, NULL, NULL, 0, 0),
(1135, '00:00', '00:00', '0', NULL, NULL, 260, 7, 1, NULL, NULL, 0, 0),
(1136, '00:00', '00:00', '0', NULL, NULL, 260, 8, 1, NULL, NULL, 0, 0),
(1137, '00:00', '00:00', '0', NULL, NULL, 260, 10, 1, NULL, NULL, 0, 0),
(1138, '00:00', '00:00', '0', NULL, NULL, 261, 1, 1, NULL, NULL, 0, 0),
(1139, '00:00', '00:00', '0', NULL, NULL, 261, 3, 1, NULL, NULL, 0, 0),
(1140, '00:00', '00:00', '0', NULL, NULL, 261, 4, 1, NULL, NULL, 0, 0),
(1141, '00:00', '00:00', '0', NULL, NULL, 261, 5, 1, NULL, NULL, 0, 0),
(1142, '00:00', '00:00', '0', NULL, NULL, 261, 6, 1, NULL, NULL, 0, 0),
(1143, '00:00', '00:00', '0', NULL, NULL, 261, 7, 1, NULL, NULL, 0, 0),
(1144, '00:00', '00:00', '0', NULL, NULL, 261, 8, 1, NULL, NULL, 0, 0),
(1145, '00:00', '00:00', '0', NULL, NULL, 261, 10, 1, NULL, NULL, 0, 0),
(1146, '00:00', '00:00', '0', NULL, NULL, 262, 1, 1, NULL, NULL, 0, 0),
(1147, '00:00', '00:00', '0', NULL, NULL, 262, 2, 1, NULL, NULL, 0, 0),
(1148, '00:00', '00:00', '0', NULL, NULL, 262, 3, 1, NULL, NULL, 0, 0),
(1149, '00:00', '00:00', '0', NULL, NULL, 262, 4, 1, NULL, NULL, 0, 0),
(1150, '00:00', '00:00', '0', NULL, NULL, 262, 5, 1, NULL, NULL, 0, 0),
(1151, '00:00', '00:00', '0', NULL, NULL, 262, 6, 1, NULL, NULL, 0, 0),
(1152, '00:00', '00:00', '0', NULL, NULL, 262, 7, 1, NULL, NULL, 0, 0),
(1153, '00:00', '00:00', '0', NULL, NULL, 262, 8, 1, NULL, NULL, 0, 0),
(1154, '00:00', '00:00', '0', NULL, NULL, 262, 10, 1, NULL, NULL, 0, 0),
(1155, '00:00', '00:00', '0', NULL, NULL, 263, 1, 1, NULL, NULL, 0, 0),
(1156, '00:00', '00:00', '0', NULL, NULL, 263, 2, 1, NULL, NULL, 0, 0),
(1157, '00:00', '12:49', '0', '2019-02-20', NULL, 263, 3, 2, '2019-02-20 15:33:50', '2019-02-20 15:46:39', 10, 0),
(1158, '00:00', '00:00', '0', NULL, NULL, 263, 4, 1, NULL, NULL, 0, 0),
(1159, '02:46', '27:46', '10', '2019-02-21', '2019-02-21', 263, 5, 3, '2019-02-21 12:03:23', '2019-02-21 12:31:09', 0, 0),
(1160, '05:50', '58:21', '10', '2019-02-22', '2019-02-22', 263, 6, 3, '2019-02-22 12:01:09', '2019-02-22 12:59:30', 0, 0),
(1161, '00:00', '00:00', '0', NULL, NULL, 263, 7, 1, NULL, NULL, 0, 0),
(1162, '00:00', '00:00', '0', NULL, NULL, 263, 8, 1, NULL, NULL, 0, 0),
(1163, '00:00', '00:00', '0', NULL, NULL, 263, 10, 1, NULL, NULL, 0, 0),
(1164, '01:04', '21:20', '20', '2019-02-22', '2019-02-22', 264, 1, 3, '2019-02-22 08:40:48', '2019-02-22 08:43:28', 0, 0),
(1165, '00:00', '00:00', '0', NULL, NULL, 264, 2, 1, NULL, NULL, 0, 0),
(1166, '02:34', '51:23', '20', '2019-02-27', '2019-02-27', 264, 3, 3, '2019-02-27 07:57:31', '2019-02-27 08:48:54', 0, 0),
(1167, '00:00', '00:00', '0', NULL, NULL, 264, 4, 1, NULL, NULL, 0, 0),
(1168, '00:00', '00:00', '0', NULL, NULL, 264, 5, 1, NULL, NULL, 0, 0),
(1169, '03:25', '68:23', '20', '2019-03-01', '2019-03-01', 264, 6, 3, '2019-03-01 14:38:10', '2019-03-01 15:46:33', 0, 0),
(1170, '00:00', '00:00', '0', NULL, NULL, 264, 7, 1, NULL, NULL, 0, 0),
(1171, '00:00', '00:00', '0', NULL, NULL, 264, 8, 1, NULL, NULL, 0, 0),
(1172, '00:00', '00:00', '0', NULL, NULL, 264, 10, 1, NULL, NULL, 0, 0),
(1173, '00:00', '00:00', '0', NULL, NULL, 277, 1, 1, NULL, NULL, 0, 0),
(1174, '00:00', '00:00', '0', NULL, NULL, 277, 3, 1, NULL, NULL, 0, 0),
(1175, '00:00', '00:00', '0', NULL, NULL, 277, 4, 1, NULL, NULL, 0, 0),
(1176, '00:00', '00:00', '0', NULL, NULL, 278, 1, 1, NULL, NULL, 0, 0),
(1177, '00:00', '00:00', '0', NULL, NULL, 278, 2, 1, NULL, NULL, 0, 0),
(1178, '00:00', '00:00', '0', NULL, NULL, 278, 3, 1, NULL, NULL, 0, 0),
(1179, '00:00', '00:00', '0', NULL, NULL, 278, 4, 1, NULL, NULL, 0, 0),
(1180, '00:00', '00:00', '0', NULL, NULL, 278, 5, 1, NULL, NULL, 0, 0),
(1181, '00:00', '00:00', '0', NULL, NULL, 278, 6, 1, NULL, NULL, 0, 0),
(1182, '00:00', '00:00', '0', NULL, NULL, 278, 7, 1, NULL, NULL, 0, 0),
(1183, '00:00', '00:00', '0', NULL, NULL, 278, 8, 1, NULL, NULL, 0, 0),
(1184, '00:00', '00:00', '0', NULL, NULL, 278, 10, 1, NULL, NULL, 0, 0),
(1185, '00:00', '00:00', '0', NULL, NULL, 280, 1, 1, NULL, NULL, 0, 0),
(1186, '00:00', '00:00', '0', NULL, NULL, 280, 2, 1, NULL, NULL, 0, 0),
(1187, '00:00', '00:00', '0', NULL, NULL, 280, 3, 1, NULL, NULL, 0, 0),
(1188, '00:00', '00:00', '0', NULL, NULL, 280, 4, 1, NULL, NULL, 0, 0),
(1189, '00:00', '00:00', '0', NULL, NULL, 280, 5, 1, NULL, NULL, 0, 0),
(1190, '00:00', '00:00', '0', NULL, NULL, 280, 6, 1, NULL, NULL, 0, 0),
(1191, '00:00', '00:00', '0', NULL, NULL, 280, 7, 1, NULL, NULL, 0, 0),
(1192, '00:00', '00:00', '0', NULL, NULL, 280, 8, 1, NULL, NULL, 0, 0),
(1193, '00:00', '00:00', '0', NULL, NULL, 280, 9, 1, NULL, NULL, 0, 0),
(1194, '00:00', '00:00', '0', NULL, NULL, 280, 10, 1, NULL, NULL, 0, 0),
(1195, '00:00', '00:00', '0', NULL, NULL, 282, 1, 1, NULL, NULL, 0, 0),
(1196, '00:00', '00:00', '0', NULL, NULL, 282, 2, 1, NULL, NULL, 0, 0),
(1197, '00:00', '00:00', '0', NULL, NULL, 282, 3, 1, NULL, NULL, 0, 0),
(1198, '00:00', '00:00', '0', NULL, NULL, 282, 4, 1, NULL, NULL, 0, 0),
(1199, '00:00', '00:00', '0', NULL, NULL, 282, 5, 1, NULL, NULL, 0, 0),
(1200, '00:00', '00:00', '0', NULL, NULL, 282, 6, 1, NULL, NULL, 0, 0),
(1201, '00:00', '00:00', '0', NULL, NULL, 282, 7, 1, NULL, NULL, 0, 0),
(1202, '00:00', '00:00', '0', NULL, NULL, 282, 8, 1, NULL, NULL, 0, 0),
(1203, '00:00', '00:00', '0', NULL, NULL, 282, 10, 1, NULL, NULL, 0, 0),
(1204, '02:17', '114:45', '50', '2019-02-20', '2019-02-20', 283, 1, 3, '2019-02-20 13:12:47', '2019-02-20 13:57:38', 0, 0),
(1205, '00:00', '1758:53', '0', '2019-02-21', NULL, 283, 2, 2, '2019-02-21 10:39:31', '2019-02-22 15:58:24', 50, 0),
(1206, '00:00', '207:34', '0', '2019-02-22', NULL, 283, 3, 2, '2019-02-22 13:01:32', '2019-02-22 15:39:30', 50, 0),
(1207, '00:00', '00:00', '0', NULL, NULL, 283, 4, 1, NULL, NULL, 0, 0),
(1208, '00:00', '00:00', '0', NULL, NULL, 283, 5, 1, NULL, NULL, 0, 0),
(1209, '00:00', '00:00', '0', NULL, NULL, 283, 6, 1, NULL, NULL, 0, 0),
(1210, '00:00', '00:00', '0', NULL, NULL, 283, 7, 1, NULL, NULL, 0, 0),
(1211, '00:00', '00:00', '0', NULL, NULL, 283, 8, 1, NULL, NULL, 0, 0),
(1212, '00:00', '00:00', '0', NULL, NULL, 283, 10, 1, NULL, NULL, 0, 0),
(1213, '00:00', '00:00', '0', NULL, NULL, 284, 1, 1, NULL, NULL, 0, 0),
(1214, '00:00', '00:00', '0', NULL, NULL, 284, 2, 1, NULL, NULL, 0, 0),
(1215, '00:00', '00:00', '0', NULL, NULL, 284, 3, 1, NULL, NULL, 0, 0),
(1216, '00:00', '00:00', '0', NULL, NULL, 284, 4, 1, NULL, NULL, 0, 0),
(1217, '00:00', '00:00', '0', NULL, NULL, 284, 5, 1, NULL, NULL, 0, 0),
(1218, '00:00', '00:00', '0', NULL, NULL, 284, 6, 1, NULL, NULL, 0, 0),
(1219, '00:00', '00:00', '0', NULL, NULL, 284, 7, 1, NULL, NULL, 0, 0),
(1220, '00:00', '00:00', '0', NULL, NULL, 284, 8, 1, NULL, NULL, 0, 0),
(1221, '00:00', '00:00', '0', NULL, NULL, 284, 10, 1, NULL, NULL, 0, 0),
(1222, '02:47', '69:38', '25', '2019-02-20', '2019-02-20', 285, 1, 3, '2019-02-20 11:47:25', '2019-02-20 12:57:03', 0, 0),
(1223, '00:00', '00:00', '0', '2019-02-21', NULL, 285, 2, 4, '2019-02-21 15:18:33', NULL, 0, 1),
(1224, '02:23', '59:49', '25', '2019-02-22', '2019-02-22', 285, 3, 3, '2019-02-22 07:37:13', '2019-02-22 08:37:02', 0, 0),
(1225, '03:31', '88:09', '25', '2019-02-22', '2019-02-22', 285, 4, 3, '2019-02-22 11:15:58', '2019-02-22 12:44:07', 0, 0),
(1226, '00:00', '00:00', '0', NULL, NULL, 285, 5, 1, NULL, NULL, 0, 0),
(1227, '00:00', '00:00', '0', NULL, NULL, 285, 6, 1, NULL, NULL, 0, 0),
(1228, '00:00', '00:00', '0', '2019-02-27', NULL, 285, 7, 4, '2019-02-27 08:04:08', NULL, 0, 1),
(1229, '00:00', '00:00', '0', '2019-02-27', NULL, 285, 8, 4, '2019-02-27 08:05:19', NULL, 0, 1),
(1230, '00:00', '00:00', '0', NULL, NULL, 285, 10, 1, NULL, NULL, 0, 0),
(1231, '00:00', '00:00', '0', NULL, NULL, 286, 1, 1, NULL, NULL, 0, 0),
(1232, '00:00', '00:00', '0', NULL, NULL, 286, 2, 1, NULL, NULL, 0, 0),
(1233, '01:30', '36:13', '24', '2019-02-20', '2019-02-20', 286, 3, 3, '2019-02-20 07:35:46', '2019-02-20 08:11:59', 0, 0),
(1234, '00:00', '00:00', '0', NULL, NULL, 286, 4, 1, NULL, NULL, 0, 0),
(1235, '00:00', '00:00', '0', NULL, NULL, 286, 5, 1, NULL, NULL, 0, 0),
(1236, '00:00', '00:00', '0', NULL, NULL, 286, 6, 1, NULL, NULL, 0, 0),
(1237, '00:04', '01:38', '24', '2019-02-21', '2019-02-21', 286, 7, 3, '2019-02-21 11:20:31', '2019-02-21 11:22:09', 0, 0),
(1238, '01:53', '45:29', '24', '2019-02-21', '2019-02-21', 286, 8, 3, '2019-02-21 11:23:38', '2019-02-21 12:09:07', 0, 0),
(1239, '00:00', '00:00', '0', NULL, NULL, 286, 10, 1, NULL, NULL, 0, 0),
(1240, '00:00', '00:00', '0', NULL, NULL, 287, 1, 1, NULL, NULL, 0, 0),
(1241, '00:00', '00:00', '0', '2019-02-21', NULL, 287, 2, 4, '2019-02-21 08:25:31', NULL, 0, 1),
(1242, '00:56', '09:28', '10', '2019-02-20', '2019-02-20', 287, 3, 3, '2019-02-20 10:03:02', '2019-02-20 10:12:30', 0, 0),
(1243, '00:00', '00:00', '0', NULL, NULL, 287, 4, 1, NULL, NULL, 0, 0),
(1244, '00:00', '00:00', '0', '2019-02-22', NULL, 287, 5, 4, '2019-02-22 07:19:38', NULL, 0, 1),
(1245, '00:00', '00:00', '0', NULL, NULL, 287, 6, 1, NULL, NULL, 0, 0),
(1246, '00:01', '00:18', '10', '2019-02-22', '2019-02-22', 287, 7, 3, '2019-02-22 08:13:57', '2019-02-22 08:14:15', 0, 0),
(1247, '00:00', '00:00', '0', NULL, NULL, 287, 8, 1, NULL, NULL, 0, 0),
(1248, '00:00', '00:00', '0', NULL, NULL, 287, 10, 1, NULL, NULL, 0, 0),
(1249, '00:00', '00:00', '0', NULL, NULL, 289, 1, 1, NULL, NULL, 0, 0),
(1250, '00:00', '00:00', '0', NULL, NULL, 289, 3, 1, NULL, NULL, 0, 0),
(1251, '00:00', '00:00', '0', NULL, NULL, 289, 4, 1, NULL, NULL, 0, 0),
(1252, '00:00', '00:00', '0', NULL, NULL, 289, 5, 1, NULL, NULL, 0, 0),
(1253, '00:00', '00:00', '0', '2019-02-20', NULL, 289, 6, 4, '2019-02-20 10:49:54', NULL, 0, 1),
(1254, '00:00', '00:00', '0', NULL, NULL, 289, 7, 1, NULL, NULL, 0, 0),
(1255, '00:00', '00:00', '0', NULL, NULL, 289, 8, 1, NULL, NULL, 0, 0),
(1256, '00:00', '00:00', '0', NULL, NULL, 289, 9, 1, NULL, NULL, 0, 0),
(1257, '00:00', '00:00', '0', NULL, NULL, 289, 10, 1, NULL, NULL, 0, 0),
(1258, '00:00', '00:00', '0', NULL, NULL, 291, 1, 1, NULL, NULL, 0, 0),
(1259, '04:18', '21:34', '5', '2019-02-20', '2019-02-20', 291, 3, 3, '2019-02-20 08:54:28', '2019-02-20 09:03:33', 0, 0),
(1260, '00:00', '00:00', '0', NULL, NULL, 291, 4, 1, NULL, NULL, 0, 0),
(1261, '00:00', '00:00', '0', NULL, NULL, 291, 5, 1, NULL, NULL, 0, 0),
(1262, '00:00', '00:00', '0', NULL, NULL, 291, 6, 1, NULL, NULL, 0, 0),
(1263, '00:15', '01:18', '5', '2019-02-21', '2019-02-21', 291, 7, 3, '2019-02-21 11:19:59', '2019-02-21 11:21:17', 0, 0),
(1264, '00:00', '00:00', '0', '2019-02-21', NULL, 291, 8, 4, '2019-02-21 11:23:12', NULL, 0, 1),
(1265, '00:00', '00:00', '0', NULL, NULL, 291, 10, 1, NULL, NULL, 0, 0),
(1266, '02:48', '59:07', '21', '2019-02-21', '2019-02-21', 294, 1, 3, '2019-02-21 09:45:50', '2019-02-21 10:44:57', 0, 0),
(1267, '00:00', '00:00', '0', NULL, NULL, 294, 2, 1, NULL, NULL, 0, 0),
(1268, '04:26', '93:10', '21', '2019-02-27', '2019-02-27', 294, 3, 3, '2019-02-27 12:27:21', '2019-02-27 12:46:38', 0, 0),
(1269, '00:00', '00:00', '0', NULL, NULL, 294, 4, 1, NULL, NULL, 0, 0),
(1270, '00:00', '00:00', '0', NULL, NULL, 294, 5, 1, NULL, NULL, 0, 0),
(1271, '09:30', '199:31', '21', '2019-03-01', '2019-03-01', 294, 6, 3, '2019-03-01 11:16:27', '2019-03-01 12:59:50', 0, 0),
(1272, '00:00', '00:00', '0', NULL, NULL, 294, 7, 1, NULL, NULL, 0, 0),
(1273, '00:00', '00:00', '0', NULL, NULL, 294, 8, 1, NULL, NULL, 0, 0),
(1274, '00:00', '00:00', '0', NULL, NULL, 294, 10, 1, NULL, NULL, 0, 0),
(1275, '00:00', '00:00', '0', NULL, NULL, 295, 1, 1, NULL, NULL, 0, 0),
(1276, '00:00', '00:00', '0', NULL, NULL, 295, 2, 1, NULL, NULL, 0, 0),
(1277, '05:45', '28:48', '5', '2019-02-20', '2019-02-20', 295, 3, 3, '2019-02-20 11:22:41', '2019-02-20 11:51:29', 0, 0),
(1278, '00:00', '00:00', '0', NULL, NULL, 295, 4, 1, NULL, NULL, 0, 0),
(1279, '00:00', '00:00', '0', NULL, NULL, 295, 5, 1, NULL, NULL, 0, 0),
(1280, '00:00', '00:00', '0', NULL, NULL, 295, 6, 1, NULL, NULL, 0, 0),
(1281, '00:00', '00:00', '0', NULL, NULL, 295, 7, 1, NULL, NULL, 0, 0),
(1282, '00:00', '00:00', '0', NULL, NULL, 295, 8, 1, NULL, NULL, 0, 0),
(1283, '00:00', '00:00', '0', NULL, NULL, 295, 10, 1, NULL, NULL, 0, 0),
(1284, '00:49', '41:02', '50', '2019-02-21', '2019-02-21', 296, 1, 3, '2019-02-21 07:57:09', '2019-02-21 08:38:11', 0, 0),
(1285, '00:57', '47:33', '50', '2019-02-21', '2019-02-21', 296, 3, 3, '2019-02-21 10:22:14', '2019-02-21 11:09:47', 0, 0),
(1286, '00:59', '49:39', '50', '2019-02-21', '2019-02-21', 296, 4, 3, '2019-02-21 14:43:40', '2019-02-21 15:33:19', 0, 0),
(1287, '00:00', '00:00', '0', NULL, NULL, 296, 5, 1, NULL, NULL, 0, 0),
(1288, '00:00', '00:00', '0', NULL, NULL, 296, 7, 1, NULL, NULL, 0, 0),
(1289, '00:00', '00:00', '0', NULL, NULL, 296, 8, 1, NULL, NULL, 0, 0),
(1290, '00:00', '00:00', '0', NULL, NULL, 296, 10, 1, NULL, NULL, 0, 0),
(1291, '00:00', '00:00', '0', NULL, NULL, 298, 1, 1, NULL, NULL, 0, 0),
(1292, '00:00', '00:00', '0', NULL, NULL, 298, 2, 1, NULL, NULL, 0, 0),
(1293, '00:00', '00:00', '0', NULL, NULL, 298, 3, 1, NULL, NULL, 0, 0),
(1294, '00:00', '00:00', '0', NULL, NULL, 298, 4, 1, NULL, NULL, 0, 0),
(1295, '00:00', '00:00', '0', NULL, NULL, 298, 5, 1, NULL, NULL, 0, 0),
(1296, '00:00', '00:00', '0', NULL, NULL, 298, 6, 1, NULL, NULL, 0, 0),
(1297, '00:00', '00:00', '0', NULL, NULL, 298, 7, 1, NULL, NULL, 0, 0),
(1298, '00:00', '00:00', '0', NULL, NULL, 298, 8, 1, NULL, NULL, 0, 0),
(1299, '00:00', '00:00', '0', NULL, NULL, 298, 9, 1, NULL, NULL, 0, 0),
(1300, '00:00', '00:00', '0', NULL, NULL, 298, 10, 1, NULL, NULL, 0, 0),
(1301, '01:54', '01:54', '1', '2019-02-20', '2019-02-20', 300, 1, 3, '2019-02-20 16:02:47', '2019-02-20 16:04:41', 0, 0),
(1302, '07:47', '07:47', '1', '2019-02-21', '2019-02-21', 300, 3, 3, '2019-02-21 06:51:51', '2019-02-21 06:59:38', 0, 0),
(1303, '00:00', '00:00', '0', NULL, NULL, 300, 4, 1, NULL, NULL, 0, 0),
(1304, '00:00', '00:00', '0', NULL, NULL, 300, 5, 1, NULL, NULL, 0, 0),
(1305, '00:00', '00:00', '0', NULL, NULL, 300, 6, 1, NULL, NULL, 0, 0),
(1306, '00:00', '00:00', '0', NULL, NULL, 300, 7, 1, NULL, NULL, 0, 0),
(1307, '00:00', '00:00', '0', NULL, NULL, 300, 8, 1, NULL, NULL, 0, 0),
(1308, '00:00', '00:00', '0', NULL, NULL, 300, 10, 1, NULL, NULL, 0, 0),
(1309, '09:33', '09:33', '1', '2019-02-20', '2019-02-20', 301, 1, 3, '2019-02-20 14:56:39', '2019-02-20 14:57:00', 0, 0),
(1310, '06:40', '06:40', '1', '2019-02-21', '2019-02-21', 301, 2, 3, '2019-02-21 11:07:47', '2019-02-21 11:14:27', 0, 0),
(1311, '07:37', '07:37', '1', '2019-02-21', '2019-02-21', 301, 3, 3, '2019-02-21 14:02:31', '2019-02-21 14:04:39', 0, 0),
(1312, '48:52', '48:52', '1', '2019-02-21', '2019-02-21', 301, 4, 3, '2019-02-21 14:43:51', '2019-02-21 15:32:43', 0, 0),
(1313, '08:51', '08:51', '1', '2019-02-21', '2019-02-21', 301, 5, 3, '2019-02-21 15:43:24', '2019-02-21 15:52:15', 0, 0),
(1314, '89:06', '89:06', '1', '2019-02-22', '2019-02-22', 301, 6, 3, '2019-02-22 10:11:57', '2019-02-22 11:41:03', 0, 0),
(1315, '00:00', '00:00', '0', NULL, NULL, 301, 7, 1, NULL, NULL, 0, 0),
(1316, '00:00', '00:00', '0', NULL, NULL, 301, 8, 1, NULL, NULL, 0, 0),
(1317, '00:00', '00:00', '0', NULL, NULL, 301, 10, 1, NULL, NULL, 0, 0),
(1318, '00:59', '05:59', '6', '2019-02-20', '2019-02-20', 243, 9, 3, '2019-02-20 09:24:09', '2019-02-20 09:30:08', 0, 0),
(1319, '01:46', '01:46', '1', '2019-02-20', '2019-02-20', 262, 9, 3, '2019-02-20 09:33:35', '2019-02-20 09:35:21', 0, 0),
(1320, '00:00', '00:00', '0', NULL, NULL, 302, 1, 1, NULL, NULL, 0, 0),
(1321, '00:00', '00:00', '0', NULL, NULL, 302, 2, 1, NULL, NULL, 0, 0),
(1322, '00:00', '00:00', '0', NULL, NULL, 302, 3, 1, NULL, NULL, 0, 0),
(1323, '00:00', '00:00', '0', NULL, NULL, 302, 4, 1, NULL, NULL, 0, 0),
(1324, '00:00', '00:00', '0', NULL, NULL, 302, 5, 1, NULL, NULL, 0, 0),
(1325, '00:00', '00:00', '0', NULL, NULL, 302, 6, 1, NULL, NULL, 0, 0),
(1326, '00:00', '00:00', '0', NULL, NULL, 302, 7, 1, NULL, NULL, 0, 0),
(1327, '00:00', '00:00', '0', NULL, NULL, 302, 8, 1, NULL, NULL, 0, 0),
(1328, '00:00', '00:00', '0', NULL, NULL, 302, 10, 1, NULL, NULL, 0, 0),
(1329, '00:00', '00:00', '0', NULL, NULL, 303, 1, 1, NULL, NULL, 0, 0),
(1330, '00:00', '00:00', '0', NULL, NULL, 303, 2, 1, NULL, NULL, 0, 0),
(1331, '00:00', '00:00', '0', NULL, NULL, 303, 3, 1, NULL, NULL, 0, 0),
(1332, '00:00', '00:00', '0', NULL, NULL, 303, 4, 1, NULL, NULL, 0, 0),
(1333, '00:00', '00:00', '0', NULL, NULL, 303, 5, 1, NULL, NULL, 0, 0),
(1334, '00:00', '00:00', '0', NULL, NULL, 303, 6, 1, NULL, NULL, 0, 0),
(1335, '00:00', '00:00', '0', NULL, NULL, 303, 7, 1, NULL, NULL, 0, 0),
(1336, '00:00', '00:00', '0', NULL, NULL, 303, 8, 1, NULL, NULL, 0, 0),
(1337, '00:00', '00:00', '0', NULL, NULL, 303, 10, 1, NULL, NULL, 0, 0),
(1338, '02:17', '09:09', '4', '2019-02-20', '2019-02-20', 304, 1, 3, '2019-02-20 14:57:11', '2019-02-20 14:57:20', 0, 0),
(1339, '17:11', '68:45', '4', '2019-02-21', '2019-02-21', 304, 2, 3, '2019-02-21 09:58:41', '2019-02-21 11:07:26', 0, 0),
(1340, '01:50', '07:23', '4', '2019-02-21', '2019-02-21', 304, 3, 3, '2019-02-21 14:02:39', '2019-02-21 14:04:02', 0, 0),
(1341, '12:16', '49:06', '4', '2019-02-21', '2019-02-21', 304, 4, 3, '2019-02-21 14:44:02', '2019-02-21 15:33:08', 0, 0),
(1342, '02:12', '08:49', '4', '2019-02-21', '2019-02-21', 304, 5, 3, '2019-02-21 15:43:41', '2019-02-21 15:52:30', 0, 0),
(1343, '18:29', '73:58', '4', '2019-02-22', '2019-02-22', 304, 6, 3, '2019-02-22 06:57:36', '2019-02-22 08:11:34', 0, 0),
(1344, '00:00', '00:00', '0', NULL, NULL, 304, 7, 1, NULL, NULL, 0, 0),
(1345, '00:00', '00:00', '0', NULL, NULL, 304, 8, 1, NULL, NULL, 0, 0),
(1346, '00:00', '00:00', '0', NULL, NULL, 304, 10, 1, NULL, NULL, 0, 0),
(1347, '00:48', '08:09', '10', '2019-02-21', '2019-02-21', 305, 1, 3, '2019-02-21 08:40:28', '2019-02-21 08:48:37', 0, 0),
(1348, '02:15', '22:30', '10', '2019-02-21', '2019-02-21', 305, 3, 3, '2019-02-21 09:56:01', '2019-02-21 10:18:31', 0, 0);
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1349, '00:00', '00:00', '0', NULL, NULL, 305, 4, 1, NULL, NULL, 0, 0),
(1350, '00:15', '02:36', '10', '2019-02-21', '2019-02-21', 305, 5, 3, '2019-02-21 11:58:04', '2019-02-21 12:00:40', 0, 0),
(1351, '04:25', '44:12', '10', '2019-02-22', '2019-02-22', 305, 6, 3, '2019-02-22 09:17:29', '2019-02-22 10:01:41', 0, 0),
(1352, '00:00', '00:00', '0', NULL, NULL, 305, 7, 1, NULL, NULL, 0, 0),
(1353, '00:00', '00:00', '0', NULL, NULL, 305, 8, 1, NULL, NULL, 0, 0),
(1354, '00:00', '00:00', '0', NULL, NULL, 305, 10, 1, NULL, NULL, 0, 0),
(1355, '46:13', '92:26', '2', '2019-02-27', '2019-02-27', 306, 1, 3, '2019-02-27 10:31:12', '2019-02-27 12:03:38', 0, 0),
(1356, '00:00', '00:00', '0', NULL, NULL, 306, 2, 1, NULL, NULL, 0, 0),
(1357, '00:00', '00:00', '0', NULL, NULL, 306, 3, 1, NULL, NULL, 0, 0),
(1358, '00:00', '00:00', '0', NULL, NULL, 306, 4, 1, NULL, NULL, 0, 0),
(1359, '00:00', '00:00', '0', NULL, NULL, 306, 5, 1, NULL, NULL, 0, 0),
(1360, '00:00', '00:00', '0', NULL, NULL, 306, 6, 1, NULL, NULL, 0, 0),
(1361, '00:00', '00:00', '0', NULL, NULL, 306, 7, 1, NULL, NULL, 0, 0),
(1362, '00:00', '00:00', '0', NULL, NULL, 306, 8, 1, NULL, NULL, 0, 0),
(1363, '00:00', '00:00', '0', NULL, NULL, 306, 10, 1, NULL, NULL, 0, 0),
(1364, '00:00', '00:00', '0', NULL, NULL, 308, 1, 1, NULL, NULL, 0, 0),
(1365, '00:00', '00:00', '0', NULL, NULL, 308, 2, 1, NULL, NULL, 0, 0),
(1366, '00:00', '00:00', '0', NULL, NULL, 308, 3, 1, NULL, NULL, 0, 0),
(1367, '00:00', '00:00', '0', NULL, NULL, 308, 4, 1, NULL, NULL, 0, 0),
(1368, '00:00', '00:00', '0', NULL, NULL, 308, 5, 1, NULL, NULL, 0, 0),
(1369, '00:00', '00:00', '0', NULL, NULL, 308, 6, 1, NULL, NULL, 0, 0),
(1370, '00:00', '00:00', '0', NULL, NULL, 308, 7, 1, NULL, NULL, 0, 0),
(1371, '00:00', '00:00', '0', NULL, NULL, 308, 8, 1, NULL, NULL, 0, 0),
(1372, '00:00', '00:00', '0', NULL, NULL, 308, 9, 1, NULL, NULL, 0, 0),
(1373, '00:00', '00:00', '0', NULL, NULL, 308, 10, 1, NULL, NULL, 0, 0),
(1374, '00:00', '00:00', '0', NULL, NULL, 310, 1, 1, NULL, NULL, 0, 0),
(1375, '00:00', '00:00', '0', NULL, NULL, 310, 3, 1, NULL, NULL, 0, 0),
(1376, '00:00', '00:00', '0', NULL, NULL, 310, 4, 1, NULL, NULL, 0, 0),
(1377, '00:00', '00:00', '0', NULL, NULL, 311, 1, 1, NULL, NULL, 0, 0),
(1378, '00:00', '00:00', '0', NULL, NULL, 311, 2, 1, NULL, NULL, 0, 0),
(1379, '00:00', '00:00', '0', NULL, NULL, 311, 3, 1, NULL, NULL, 0, 0),
(1380, '00:00', '00:00', '0', NULL, NULL, 311, 4, 1, NULL, NULL, 0, 0),
(1381, '00:00', '00:00', '0', NULL, NULL, 311, 5, 1, NULL, NULL, 0, 0),
(1382, '00:00', '00:00', '0', NULL, NULL, 311, 6, 1, NULL, NULL, 0, 0),
(1383, '00:00', '00:00', '0', NULL, NULL, 311, 7, 1, NULL, NULL, 0, 0),
(1384, '00:00', '00:00', '0', NULL, NULL, 311, 8, 1, NULL, NULL, 0, 0),
(1385, '00:00', '00:00', '0', NULL, NULL, 311, 10, 1, NULL, NULL, 0, 0),
(1386, '00:47', '39:30', '50', '2019-02-21', '2019-02-21', 312, 1, 3, '2019-02-21 08:50:34', '2019-02-21 09:30:04', 0, 0),
(1387, '00:00', '114:25', '0', '2019-02-21', NULL, 312, 3, 4, '2019-02-21 14:23:03', NULL, 50, 1),
(1388, '00:00', '00:00', '0', '2019-02-22', NULL, 312, 4, 4, '2019-02-22 06:59:04', NULL, 0, 1),
(1389, '00:00', '00:14', '50', '2019-02-22', '2019-02-22', 312, 5, 3, '2019-02-22 07:16:57', '2019-02-22 07:17:11', 0, 0),
(1390, '00:00', '53:12', '0', '2019-02-22', NULL, 312, 6, 2, '2019-02-22 15:07:03', '2019-02-22 15:12:11', 50, 0),
(1391, '00:00', '00:00', '0', '2019-02-27', NULL, 312, 7, 4, '2019-02-27 08:04:20', NULL, 0, 1),
(1392, '00:00', '00:00', '0', '2019-02-27', NULL, 312, 8, 4, '2019-02-27 08:05:26', NULL, 0, 1),
(1393, '00:00', '00:00', '0', NULL, NULL, 312, 10, 1, NULL, NULL, 0, 0),
(1394, '00:00', '00:00', '0', NULL, NULL, 316, 1, 1, NULL, NULL, 0, 0),
(1395, '00:00', '00:00', '0', NULL, NULL, 316, 3, 1, NULL, NULL, 0, 0),
(1396, '00:00', '00:00', '0', NULL, NULL, 316, 4, 1, NULL, NULL, 0, 0),
(1397, '00:00', '00:00', '0', NULL, NULL, 320, 1, 1, NULL, NULL, 0, 0),
(1398, '00:00', '00:00', '0', NULL, NULL, 320, 3, 1, NULL, NULL, 0, 0),
(1399, '00:00', '00:00', '0', NULL, NULL, 320, 4, 1, NULL, NULL, 0, 0),
(1400, '00:00', '00:00', '0', NULL, NULL, 324, 1, 1, NULL, NULL, 0, 0),
(1401, '00:00', '00:00', '0', NULL, NULL, 324, 2, 1, NULL, NULL, 0, 0),
(1402, '00:00', '00:00', '0', NULL, NULL, 324, 3, 1, NULL, NULL, 0, 0),
(1403, '00:00', '00:00', '0', NULL, NULL, 324, 4, 1, NULL, NULL, 0, 0),
(1404, '00:00', '00:00', '0', NULL, NULL, 324, 5, 1, NULL, NULL, 0, 0),
(1405, '00:00', '00:00', '0', NULL, NULL, 324, 6, 1, NULL, NULL, 0, 0),
(1406, '00:00', '00:00', '0', NULL, NULL, 324, 7, 1, NULL, NULL, 0, 0),
(1407, '00:00', '00:00', '0', NULL, NULL, 324, 8, 1, NULL, NULL, 0, 0),
(1408, '00:00', '00:00', '0', NULL, NULL, 324, 9, 1, NULL, NULL, 0, 0),
(1409, '00:00', '00:00', '0', NULL, NULL, 324, 10, 1, NULL, NULL, 0, 0),
(1410, '12:45', '63:48', '5', '2019-02-22', '2019-02-22', 326, 1, 3, '2019-02-22 12:53:10', '2019-02-22 13:56:58', 0, 0),
(1411, '00:00', '00:00', '0', NULL, NULL, 326, 2, 1, NULL, NULL, 0, 0),
(1412, '00:00', '00:00', '0', NULL, NULL, 326, 3, 1, NULL, NULL, 0, 0),
(1413, '00:00', '00:00', '0', NULL, NULL, 326, 4, 1, NULL, NULL, 0, 0),
(1414, '00:00', '00:00', '0', NULL, NULL, 326, 5, 1, NULL, NULL, 0, 0),
(1415, '00:00', '00:00', '0', NULL, NULL, 326, 6, 1, NULL, NULL, 0, 0),
(1416, '00:02', '00:10', '5', '2019-02-27', '2019-02-27', 326, 7, 3, '2019-02-27 08:03:38', '2019-02-27 08:03:48', 0, 0),
(1417, '00:00', '00:00', '0', '2019-02-27', NULL, 326, 8, 4, '2019-02-27 08:05:07', NULL, 0, 1),
(1418, '00:00', '00:00', '0', NULL, NULL, 326, 10, 1, NULL, NULL, 0, 0),
(1419, '00:00', '00:00', '0', NULL, NULL, 327, 1, 1, NULL, NULL, 0, 0),
(1420, '00:00', '00:00', '0', NULL, NULL, 327, 2, 1, NULL, NULL, 0, 0),
(1421, '00:00', '00:00', '0', NULL, NULL, 327, 3, 1, NULL, NULL, 0, 0),
(1422, '00:00', '00:00', '0', NULL, NULL, 327, 4, 1, NULL, NULL, 0, 0),
(1423, '00:00', '00:00', '0', NULL, NULL, 327, 5, 1, NULL, NULL, 0, 0),
(1424, '00:00', '00:00', '0', NULL, NULL, 327, 6, 1, NULL, NULL, 0, 0),
(1425, '00:00', '00:00', '0', NULL, NULL, 327, 7, 1, NULL, NULL, 0, 0),
(1426, '00:00', '00:00', '0', NULL, NULL, 327, 8, 1, NULL, NULL, 0, 0),
(1427, '00:00', '00:00', '0', NULL, NULL, 327, 10, 1, NULL, NULL, 0, 0),
(1428, '00:00', '00:00', '0', NULL, NULL, 331, 1, 1, NULL, NULL, 0, 0),
(1429, '00:00', '00:00', '0', NULL, NULL, 331, 3, 1, NULL, NULL, 0, 0),
(1430, '00:00', '00:00', '0', NULL, NULL, 331, 4, 1, NULL, NULL, 0, 0),
(1431, '00:00', '00:00', '0', NULL, NULL, 335, 1, 1, NULL, NULL, 0, 0),
(1432, '00:00', '00:00', '0', NULL, NULL, 335, 3, 1, NULL, NULL, 0, 0),
(1433, '00:00', '00:00', '0', NULL, NULL, 335, 4, 1, NULL, NULL, 0, 0),
(1434, '06:24', '64:06', '10', '2019-02-22', '2019-02-22', 339, 1, 3, '2019-02-22 12:53:01', '2019-02-22 13:57:07', 0, 0),
(1435, '00:00', '00:00', '0', NULL, NULL, 339, 2, 1, NULL, NULL, 0, 0),
(1436, '00:00', '00:00', '0', NULL, NULL, 339, 3, 1, NULL, NULL, 0, 0),
(1437, '00:00', '00:00', '0', NULL, NULL, 339, 4, 1, NULL, NULL, 0, 0),
(1438, '00:00', '00:00', '0', NULL, NULL, 339, 5, 1, NULL, NULL, 0, 0),
(1439, '00:00', '58:04', '0', '2019-02-27', NULL, 339, 6, 2, '2019-02-27 14:59:35', '2019-02-27 15:57:39', 10, 0),
(1440, '00:00', '00:00', '0', NULL, NULL, 339, 7, 1, NULL, NULL, 0, 0),
(1441, '00:00', '00:00', '0', NULL, NULL, 339, 8, 1, NULL, NULL, 0, 0),
(1442, '00:00', '00:00', '0', NULL, NULL, 339, 10, 1, NULL, NULL, 0, 0),
(1443, '03:44', '07:29', '2', '2019-02-22', '2019-02-22', 340, 1, 3, '2019-02-22 14:00:31', '2019-02-22 14:08:00', 0, 0),
(1444, '00:00', '00:00', '0', NULL, NULL, 340, 3, 1, NULL, NULL, 0, 0),
(1445, '00:00', '00:00', '0', NULL, NULL, 340, 4, 1, NULL, NULL, 0, 0),
(1446, '00:00', '00:00', '0', NULL, NULL, 340, 5, 1, NULL, NULL, 0, 0),
(1447, '00:00', '00:00', '0', NULL, NULL, 340, 6, 1, NULL, NULL, 0, 0),
(1448, '00:00', '00:00', '0', NULL, NULL, 340, 7, 1, NULL, NULL, 0, 0),
(1449, '00:00', '00:00', '0', NULL, NULL, 340, 8, 1, NULL, NULL, 0, 0),
(1450, '00:00', '00:00', '0', NULL, NULL, 340, 10, 1, NULL, NULL, 0, 0),
(1451, '00:00', '00:00', '0', NULL, NULL, 341, 1, 1, NULL, NULL, 0, 0),
(1452, '00:00', '00:00', '0', NULL, NULL, 341, 2, 1, NULL, NULL, 0, 0),
(1453, '04:17', '51:25', '12', '2019-02-27', '2019-02-27', 341, 3, 3, '2019-02-27 07:57:44', '2019-02-27 08:49:09', 0, 0),
(1454, '00:00', '00:00', '0', NULL, NULL, 341, 4, 1, NULL, NULL, 0, 0),
(1455, '00:00', '00:00', '0', NULL, NULL, 341, 5, 1, NULL, NULL, 0, 0),
(1456, '04:53', '58:37', '12', '2019-02-27', '2019-02-27', 341, 6, 3, '2019-02-27 14:00:41', '2019-02-27 14:59:18', 0, 0),
(1457, '00:00', '00:00', '0', NULL, NULL, 341, 7, 1, NULL, NULL, 0, 0),
(1458, '00:00', '00:00', '0', NULL, NULL, 341, 8, 1, NULL, NULL, 0, 0),
(1459, '00:00', '00:00', '0', NULL, NULL, 341, 10, 1, NULL, NULL, 0, 0),
(1460, '00:00', '00:00', '0', NULL, NULL, 342, 1, 1, NULL, NULL, 0, 0),
(1461, '00:00', '00:00', '0', NULL, NULL, 342, 3, 1, NULL, NULL, 0, 0),
(1462, '00:00', '00:00', '0', NULL, NULL, 342, 4, 1, NULL, NULL, 0, 0),
(1463, '00:00', '00:00', '0', NULL, NULL, 342, 5, 1, NULL, NULL, 0, 0),
(1464, '00:00', '00:00', '0', NULL, NULL, 342, 6, 1, NULL, NULL, 0, 0),
(1465, '00:00', '00:00', '0', NULL, NULL, 342, 7, 1, NULL, NULL, 0, 0),
(1466, '00:00', '00:00', '0', NULL, NULL, 342, 8, 1, NULL, NULL, 0, 0),
(1467, '00:00', '00:00', '0', NULL, NULL, 342, 10, 1, NULL, NULL, 0, 0),
(1468, '00:00', '00:00', '0', NULL, NULL, 343, 1, 1, NULL, NULL, 0, 0),
(1469, '00:00', '00:00', '0', NULL, NULL, 343, 3, 1, NULL, NULL, 0, 0),
(1470, '00:00', '00:00', '0', NULL, NULL, 343, 4, 1, NULL, NULL, 0, 0),
(1471, '00:00', '00:00', '0', NULL, NULL, 343, 5, 1, NULL, NULL, 0, 0),
(1472, '00:00', '00:00', '0', NULL, NULL, 343, 6, 1, NULL, NULL, 0, 0),
(1473, '00:00', '00:00', '0', '2019-02-27', NULL, 343, 7, 4, '2019-02-27 08:03:58', NULL, 0, 1),
(1474, '00:00', '00:00', '0', '2019-02-27', NULL, 343, 8, 4, '2019-02-27 08:05:13', NULL, 0, 1),
(1475, '00:00', '00:00', '0', NULL, NULL, 343, 10, 1, NULL, NULL, 0, 0),
(1476, '13:38', '68:11', '5', '2019-02-27', '2019-02-27', 344, 1, 3, '2019-02-27 14:09:59', '2019-02-27 15:18:10', 0, 0),
(1477, '00:00', '00:00', '0', NULL, NULL, 344, 2, 1, NULL, NULL, 0, 0),
(1478, '00:00', '00:00', '0', NULL, NULL, 344, 3, 1, NULL, NULL, 0, 0),
(1479, '00:00', '00:00', '0', NULL, NULL, 344, 4, 1, NULL, NULL, 0, 0),
(1480, '00:00', '00:00', '0', NULL, NULL, 344, 5, 1, NULL, NULL, 0, 0),
(1481, '00:00', '00:00', '0', NULL, NULL, 344, 6, 1, NULL, NULL, 0, 0),
(1482, '00:00', '00:00', '0', NULL, NULL, 344, 7, 1, NULL, NULL, 0, 0),
(1483, '00:00', '00:00', '0', NULL, NULL, 344, 8, 1, NULL, NULL, 0, 0),
(1484, '00:00', '00:00', '0', NULL, NULL, 344, 9, 1, NULL, NULL, 0, 0),
(1485, '00:00', '00:00', '0', NULL, NULL, 344, 10, 1, NULL, NULL, 0, 0),
(1486, '17:02', '68:08', '4', '2019-02-27', '2019-02-27', 345, 1, 3, '2019-02-27 14:09:51', '2019-02-27 15:17:59', 0, 0),
(1487, '00:00', '00:00', '0', NULL, NULL, 345, 2, 1, NULL, NULL, 0, 0),
(1488, '00:00', '00:00', '0', NULL, NULL, 345, 3, 1, NULL, NULL, 0, 0),
(1489, '00:00', '00:00', '0', NULL, NULL, 345, 4, 1, NULL, NULL, 0, 0),
(1490, '00:00', '00:00', '0', NULL, NULL, 345, 5, 1, NULL, NULL, 0, 0),
(1491, '00:00', '00:00', '0', NULL, NULL, 345, 6, 1, NULL, NULL, 0, 0),
(1492, '00:00', '00:00', '0', NULL, NULL, 345, 7, 1, NULL, NULL, 0, 0),
(1493, '00:00', '00:00', '0', NULL, NULL, 345, 8, 1, NULL, NULL, 0, 0),
(1494, '02:10', '08:43', '4', '2019-03-01', '2019-03-01', 345, 9, 3, '2019-03-01 15:04:06', '2019-03-01 15:12:49', 0, 0),
(1495, '00:00', '00:00', '0', NULL, NULL, 345, 10, 1, NULL, NULL, 0, 0),
(1496, '00:00', '00:00', '0', NULL, NULL, 346, 1, 1, NULL, NULL, 0, 0),
(1497, '00:00', '00:00', '0', NULL, NULL, 346, 2, 1, NULL, NULL, 0, 0),
(1498, '04:01', '08:03', '2', '2019-02-27', '2019-02-27', 346, 3, 3, '2019-02-27 11:42:29', '2019-02-27 11:50:32', 0, 0),
(1499, '00:00', '00:00', '0', NULL, NULL, 346, 4, 1, NULL, NULL, 0, 0),
(1500, '00:00', '00:00', '0', NULL, NULL, 346, 5, 1, NULL, NULL, 0, 0),
(1501, '26:03', '52:07', '2', '2019-02-27', '2019-02-27', 346, 6, 3, '2019-02-27 12:10:48', '2019-02-27 13:02:55', 0, 0),
(1502, '00:00', '00:00', '0', NULL, NULL, 346, 7, 1, NULL, NULL, 0, 0),
(1503, '00:00', '00:00', '0', NULL, NULL, 346, 8, 1, NULL, NULL, 0, 0),
(1504, '00:00', '00:00', '0', NULL, NULL, 346, 10, 1, NULL, NULL, 0, 0),
(1505, '00:00', '00:00', '0', NULL, NULL, 347, 1, 1, NULL, NULL, 0, 0),
(1506, '00:00', '00:00', '0', NULL, NULL, 347, 2, 1, NULL, NULL, 0, 0),
(1507, '00:00', '00:00', '0', NULL, NULL, 347, 3, 1, NULL, NULL, 0, 0),
(1508, '00:00', '00:00', '0', NULL, NULL, 347, 4, 1, NULL, NULL, 0, 0),
(1509, '00:00', '00:00', '0', NULL, NULL, 347, 5, 1, NULL, NULL, 0, 0),
(1510, '00:00', '00:00', '0', NULL, NULL, 347, 6, 1, NULL, NULL, 0, 0),
(1511, '00:00', '00:00', '0', NULL, NULL, 347, 7, 1, NULL, NULL, 0, 0),
(1512, '00:00', '00:00', '0', NULL, NULL, 347, 8, 1, NULL, NULL, 0, 0),
(1513, '00:00', '00:00', '0', NULL, NULL, 347, 10, 1, NULL, NULL, 0, 0),
(1514, '00:36', '12:13', '20', '2019-02-27', '2019-02-27', 348, 1, 3, '2019-02-27 15:38:36', '2019-02-27 15:50:49', 0, 0),
(1515, '00:00', '00:00', '0', NULL, NULL, 348, 2, 1, NULL, NULL, 0, 0),
(1516, '00:00', '00:00', '0', NULL, NULL, 348, 3, 1, NULL, NULL, 0, 0),
(1517, '00:00', '00:00', '0', NULL, NULL, 348, 4, 1, NULL, NULL, 0, 0),
(1518, '00:00', '00:00', '0', NULL, NULL, 348, 5, 1, NULL, NULL, 0, 0),
(1519, '00:00', '00:00', '0', NULL, NULL, 348, 6, 1, NULL, NULL, 0, 0),
(1520, '00:00', '00:00', '0', NULL, NULL, 348, 7, 1, NULL, NULL, 0, 0),
(1521, '00:00', '00:00', '0', NULL, NULL, 348, 8, 1, NULL, NULL, 0, 0),
(1522, '00:00', '00:00', '0', NULL, NULL, 348, 10, 1, NULL, NULL, 0, 0),
(1523, '00:00', '00:00', '0', NULL, NULL, 349, 1, 1, NULL, NULL, 0, 0),
(1524, '00:00', '00:00', '0', NULL, NULL, 349, 2, 1, NULL, NULL, 0, 0),
(1525, '00:00', '00:00', '0', NULL, NULL, 349, 3, 1, NULL, NULL, 0, 0),
(1526, '00:00', '00:00', '0', NULL, NULL, 349, 4, 1, NULL, NULL, 0, 0),
(1527, '00:00', '00:00', '0', NULL, NULL, 349, 5, 1, NULL, NULL, 0, 0),
(1528, '00:00', '00:00', '0', NULL, NULL, 349, 6, 1, NULL, NULL, 0, 0),
(1529, '00:00', '00:00', '0', NULL, NULL, 349, 7, 1, NULL, NULL, 0, 0),
(1530, '00:00', '00:00', '0', NULL, NULL, 349, 8, 1, NULL, NULL, 0, 0),
(1531, '00:00', '00:00', '0', NULL, NULL, 349, 10, 1, NULL, NULL, 0, 0),
(1532, '23:08', '92:35', '4', '2019-02-27', '2019-02-27', 350, 1, 3, '2019-02-27 10:31:17', '2019-02-27 12:03:52', 0, 0),
(1533, '00:00', '00:00', '0', NULL, NULL, 350, 2, 1, NULL, NULL, 0, 0),
(1534, '05:04', '20:16', '4', '2019-02-27', '2019-02-27', 350, 3, 3, '2019-02-27 14:42:59', '2019-02-27 15:03:15', 0, 0),
(1535, '00:00', '00:00', '0', NULL, NULL, 350, 4, 1, NULL, NULL, 0, 0),
(1536, '00:00', '00:00', '0', NULL, NULL, 350, 5, 1, NULL, NULL, 0, 0),
(1537, '00:00', '00:00', '0', NULL, NULL, 350, 6, 1, NULL, NULL, 0, 0),
(1538, '00:00', '00:00', '0', NULL, NULL, 350, 7, 1, NULL, NULL, 0, 0),
(1539, '00:00', '00:00', '0', NULL, NULL, 350, 8, 1, NULL, NULL, 0, 0),
(1540, '00:00', '00:00', '0', NULL, NULL, 350, 10, 1, NULL, NULL, 0, 0),
(1541, '00:00', '00:00', '0', NULL, NULL, 351, 1, 1, NULL, NULL, 0, 0),
(1542, '00:00', '00:00', '0', NULL, NULL, 351, 3, 1, NULL, NULL, 0, 0),
(1543, '00:00', '00:00', '0', NULL, NULL, 351, 4, 1, NULL, NULL, 0, 0),
(1544, '00:00', '00:00', '0', NULL, NULL, 351, 5, 1, NULL, NULL, 0, 0),
(1545, '00:00', '00:00', '0', NULL, NULL, 351, 7, 1, NULL, NULL, 0, 0),
(1546, '00:00', '00:00', '0', NULL, NULL, 351, 8, 1, NULL, NULL, 0, 0),
(1547, '00:00', '00:00', '0', NULL, NULL, 351, 10, 1, NULL, NULL, 0, 0),
(1548, '00:00', '00:00', '0', NULL, NULL, 355, 1, 1, NULL, NULL, 0, 0),
(1549, '00:00', '00:00', '0', NULL, NULL, 355, 3, 1, NULL, NULL, 0, 0),
(1550, '00:00', '00:00', '0', NULL, NULL, 355, 4, 1, NULL, NULL, 0, 0),
(1551, '33:47', '101:23', '3', '2019-03-01', '2019-03-01', 356, 1, 3, '2019-03-01 12:34:54', '2019-03-01 12:35:03', 0, 0),
(1552, '00:00', '00:00', '0', NULL, NULL, 356, 2, 1, NULL, NULL, 0, 0),
(1553, '00:00', '00:00', '0', NULL, NULL, 356, 3, 1, NULL, NULL, 0, 0),
(1554, '00:00', '00:00', '0', NULL, NULL, 356, 4, 1, NULL, NULL, 0, 0),
(1555, '00:00', '00:00', '0', NULL, NULL, 356, 5, 1, NULL, NULL, 0, 0),
(1556, '00:00', '00:00', '0', NULL, NULL, 356, 6, 1, NULL, NULL, 0, 0),
(1557, '00:00', '00:00', '0', NULL, NULL, 356, 7, 1, NULL, NULL, 0, 0),
(1558, '00:00', '00:00', '0', NULL, NULL, 356, 8, 1, NULL, NULL, 0, 0),
(1559, '00:00', '00:00', '0', NULL, NULL, 356, 10, 1, NULL, NULL, 0, 0),
(1560, '00:00', '00:00', '0', NULL, NULL, 357, 1, 1, NULL, NULL, 0, 0),
(1561, '00:00', '00:00', '0', NULL, NULL, 357, 2, 1, NULL, NULL, 0, 0),
(1562, '00:00', '00:00', '0', NULL, NULL, 357, 3, 1, NULL, NULL, 0, 0),
(1563, '00:00', '00:00', '0', NULL, NULL, 357, 4, 1, NULL, NULL, 0, 0),
(1564, '00:00', '00:00', '0', NULL, NULL, 357, 5, 1, NULL, NULL, 0, 0),
(1565, '00:00', '00:00', '0', NULL, NULL, 357, 6, 1, NULL, NULL, 0, 0),
(1566, '00:00', '00:00', '0', NULL, NULL, 357, 7, 1, NULL, NULL, 0, 0),
(1567, '00:00', '00:00', '0', NULL, NULL, 357, 8, 1, NULL, NULL, 0, 0),
(1568, '00:00', '00:00', '0', NULL, NULL, 357, 10, 1, NULL, NULL, 0, 0),
(1569, '00:00', '00:00', '0', NULL, NULL, 361, 1, 1, NULL, NULL, 0, 0),
(1570, '00:00', '00:00', '0', NULL, NULL, 361, 3, 1, NULL, NULL, 0, 0),
(1571, '00:00', '00:00', '0', NULL, NULL, 361, 4, 1, NULL, NULL, 0, 0),
(1572, '06:45', '101:21', '15', '2019-03-01', '2019-03-01', 362, 1, 3, '2019-03-01 12:35:11', '2019-03-01 12:35:19', 0, 0),
(1573, '00:00', '00:00', '0', NULL, NULL, 362, 2, 1, NULL, NULL, 0, 0),
(1574, '00:00', '00:00', '0', NULL, NULL, 362, 3, 1, NULL, NULL, 0, 0),
(1575, '00:00', '00:00', '0', NULL, NULL, 362, 4, 1, NULL, NULL, 0, 0),
(1576, '00:00', '00:00', '0', NULL, NULL, 362, 5, 1, NULL, NULL, 0, 0),
(1577, '00:00', '00:00', '0', NULL, NULL, 362, 6, 1, NULL, NULL, 0, 0),
(1578, '00:00', '00:00', '0', NULL, NULL, 362, 7, 1, NULL, NULL, 0, 0),
(1579, '00:00', '00:00', '0', NULL, NULL, 362, 8, 1, NULL, NULL, 0, 0),
(1580, '00:00', '00:00', '0', NULL, NULL, 362, 10, 1, NULL, NULL, 0, 0),
(1581, '00:00', '00:00', '0', NULL, NULL, 363, 1, 1, NULL, NULL, 0, 0),
(1582, '00:00', '00:00', '0', NULL, NULL, 363, 2, 1, NULL, NULL, 0, 0),
(1583, '00:00', '00:00', '0', NULL, NULL, 363, 3, 1, NULL, NULL, 0, 0),
(1584, '00:00', '00:00', '0', NULL, NULL, 363, 4, 1, NULL, NULL, 0, 0),
(1585, '00:00', '00:00', '0', NULL, NULL, 363, 5, 1, NULL, NULL, 0, 0),
(1586, '00:00', '00:00', '0', NULL, NULL, 363, 6, 1, NULL, NULL, 0, 0),
(1587, '00:00', '00:00', '0', NULL, NULL, 363, 7, 1, NULL, NULL, 0, 0),
(1588, '00:00', '00:00', '0', NULL, NULL, 363, 8, 1, NULL, NULL, 0, 0),
(1589, '00:00', '00:00', '0', NULL, NULL, 363, 10, 1, NULL, NULL, 0, 0),
(1590, '00:00', '00:00', '0', NULL, NULL, 364, 1, 1, NULL, NULL, 0, 0),
(1591, '00:00', '00:00', '0', NULL, NULL, 364, 2, 1, NULL, NULL, 0, 0),
(1592, '00:00', '00:00', '0', NULL, NULL, 364, 3, 1, NULL, NULL, 0, 0),
(1593, '00:00', '00:00', '0', NULL, NULL, 364, 4, 1, NULL, NULL, 0, 0),
(1594, '00:00', '00:00', '0', NULL, NULL, 364, 5, 1, NULL, NULL, 0, 0),
(1595, '00:00', '00:00', '0', NULL, NULL, 364, 6, 1, NULL, NULL, 0, 0),
(1596, '00:00', '00:00', '0', NULL, NULL, 364, 7, 1, NULL, NULL, 0, 0),
(1597, '00:00', '00:00', '0', NULL, NULL, 364, 8, 1, NULL, NULL, 0, 0),
(1598, '00:00', '00:00', '0', NULL, NULL, 364, 10, 1, NULL, NULL, 0, 0),
(1599, '21:40', '43:21', '2', '2019-03-01', '2019-03-01', 365, 1, 3, '2019-03-01 15:25:00', '2019-03-01 16:08:21', 0, 0),
(1600, '00:00', '00:00', '0', NULL, NULL, 365, 2, 1, NULL, NULL, 0, 0),
(1601, '00:00', '00:00', '0', NULL, NULL, 365, 3, 1, NULL, NULL, 0, 0),
(1602, '00:00', '00:00', '0', NULL, NULL, 365, 4, 1, NULL, NULL, 0, 0),
(1603, '00:00', '00:00', '0', NULL, NULL, 365, 5, 1, NULL, NULL, 0, 0),
(1604, '00:00', '00:00', '0', NULL, NULL, 365, 6, 1, NULL, NULL, 0, 0),
(1605, '00:00', '00:00', '0', NULL, NULL, 365, 7, 1, NULL, NULL, 0, 0),
(1606, '00:00', '00:00', '0', NULL, NULL, 365, 8, 1, NULL, NULL, 0, 0),
(1607, '00:00', '00:00', '0', NULL, NULL, 365, 10, 1, NULL, NULL, 0, 0),
(1608, '00:00', '00:00', '0', NULL, NULL, 367, 1, 1, NULL, NULL, 0, 0),
(1609, '00:00', '00:00', '0', NULL, NULL, 367, 2, 1, NULL, NULL, 0, 0),
(1610, '00:00', '00:00', '0', NULL, NULL, 367, 3, 1, NULL, NULL, 0, 0),
(1611, '00:00', '00:00', '0', NULL, NULL, 367, 4, 1, NULL, NULL, 0, 0),
(1612, '00:00', '00:00', '0', NULL, NULL, 367, 5, 1, NULL, NULL, 0, 0),
(1613, '00:00', '00:00', '0', NULL, NULL, 367, 6, 1, NULL, NULL, 0, 0),
(1614, '00:00', '00:00', '0', NULL, NULL, 367, 7, 1, NULL, NULL, 0, 0),
(1615, '00:00', '00:00', '0', NULL, NULL, 367, 8, 1, NULL, NULL, 0, 0),
(1616, '00:00', '00:00', '0', NULL, NULL, 367, 9, 1, NULL, NULL, 0, 0),
(1617, '00:00', '00:00', '0', NULL, NULL, 367, 10, 1, NULL, NULL, 0, 0),
(1618, '00:00', '00:00', '0', NULL, NULL, 369, 1, 1, NULL, NULL, 0, 0),
(1619, '00:00', '00:00', '0', NULL, NULL, 369, 2, 1, NULL, NULL, 0, 0),
(1620, '00:00', '00:00', '0', NULL, NULL, 369, 3, 1, NULL, NULL, 0, 0),
(1621, '00:00', '00:00', '0', NULL, NULL, 369, 4, 1, NULL, NULL, 0, 0),
(1622, '00:00', '00:00', '0', NULL, NULL, 369, 5, 1, NULL, NULL, 0, 0),
(1623, '00:00', '00:00', '0', NULL, NULL, 369, 6, 1, NULL, NULL, 0, 0),
(1624, '00:00', '00:00', '0', NULL, NULL, 369, 7, 1, NULL, NULL, 0, 0),
(1625, '00:00', '00:00', '0', NULL, NULL, 369, 8, 1, NULL, NULL, 0, 0),
(1626, '00:00', '00:00', '0', NULL, NULL, 369, 10, 1, NULL, NULL, 0, 0),
(1627, '00:00', '00:00', '0', NULL, NULL, 370, 1, 1, NULL, NULL, 0, 0),
(1628, '00:00', '00:00', '0', NULL, NULL, 370, 2, 1, NULL, NULL, 0, 0),
(1629, '00:00', '00:00', '0', NULL, NULL, 370, 3, 1, NULL, NULL, 0, 0),
(1630, '00:00', '00:00', '0', NULL, NULL, 370, 4, 1, NULL, NULL, 0, 0),
(1631, '00:00', '00:00', '0', NULL, NULL, 370, 5, 1, NULL, NULL, 0, 0),
(1632, '00:00', '00:00', '0', NULL, NULL, 370, 6, 1, NULL, NULL, 0, 0),
(1633, '00:00', '00:00', '0', NULL, NULL, 370, 7, 1, NULL, NULL, 0, 0),
(1634, '00:00', '00:00', '0', NULL, NULL, 370, 8, 1, NULL, NULL, 0, 0),
(1635, '00:00', '00:00', '0', NULL, NULL, 370, 10, 1, NULL, NULL, 0, 0),
(1636, '00:00', '00:00', '0', NULL, NULL, 371, 1, 1, NULL, NULL, 0, 0),
(1637, '00:00', '00:00', '0', NULL, NULL, 371, 2, 1, NULL, NULL, 0, 0),
(1638, '00:00', '00:00', '0', NULL, NULL, 371, 3, 1, NULL, NULL, 0, 0),
(1639, '00:00', '00:00', '0', NULL, NULL, 371, 4, 1, NULL, NULL, 0, 0),
(1640, '00:00', '00:00', '0', NULL, NULL, 371, 5, 1, NULL, NULL, 0, 0),
(1641, '00:00', '00:00', '0', NULL, NULL, 371, 6, 1, NULL, NULL, 0, 0),
(1642, '00:00', '00:00', '0', NULL, NULL, 371, 7, 1, NULL, NULL, 0, 0),
(1643, '00:00', '00:00', '0', NULL, NULL, 371, 8, 1, NULL, NULL, 0, 0),
(1644, '00:00', '00:00', '0', NULL, NULL, 371, 10, 1, NULL, NULL, 0, 0),
(1645, '00:00', '00:00', '0', NULL, NULL, 372, 1, 1, NULL, NULL, 0, 0),
(1646, '00:00', '00:00', '0', NULL, NULL, 372, 3, 1, NULL, NULL, 0, 0),
(1647, '00:00', '00:00', '0', NULL, NULL, 372, 4, 1, NULL, NULL, 0, 0),
(1648, '00:00', '00:00', '0', NULL, NULL, 372, 5, 1, NULL, NULL, 0, 0),
(1649, '00:00', '00:00', '0', NULL, NULL, 372, 6, 1, NULL, NULL, 0, 0),
(1650, '00:00', '00:00', '0', NULL, NULL, 372, 7, 1, NULL, NULL, 0, 0),
(1651, '00:00', '00:00', '0', NULL, NULL, 372, 8, 1, NULL, NULL, 0, 0),
(1652, '00:00', '00:00', '0', NULL, NULL, 372, 10, 1, NULL, NULL, 0, 0),
(1653, '43:15', '43:15', '1', '2019-03-01', '2019-03-01', 373, 1, 3, '2019-03-01 15:25:16', '2019-03-01 16:08:31', 0, 0),
(1654, '00:00', '00:00', '0', NULL, NULL, 373, 2, 1, NULL, NULL, 0, 0),
(1655, '00:00', '00:00', '0', NULL, NULL, 373, 3, 1, NULL, NULL, 0, 0),
(1656, '00:00', '00:00', '0', NULL, NULL, 373, 4, 1, NULL, NULL, 0, 0),
(1657, '00:00', '00:00', '0', NULL, NULL, 373, 5, 1, NULL, NULL, 0, 0),
(1658, '00:00', '00:00', '0', NULL, NULL, 373, 6, 1, NULL, NULL, 0, 0),
(1659, '00:00', '00:00', '0', NULL, NULL, 373, 7, 1, NULL, NULL, 0, 0),
(1660, '00:00', '00:00', '0', NULL, NULL, 373, 8, 1, NULL, NULL, 0, 0),
(1661, '00:00', '00:00', '0', NULL, NULL, 373, 10, 1, NULL, NULL, 0, 0),
(1662, '43:02', '43:02', '1', '2019-03-01', '2019-03-01', 374, 1, 3, '2019-03-01 15:25:09', '2019-03-01 16:08:11', 0, 0),
(1663, '00:00', '00:00', '0', NULL, NULL, 374, 2, 1, NULL, NULL, 0, 0),
(1664, '00:00', '00:00', '0', NULL, NULL, 374, 3, 1, NULL, NULL, 0, 0),
(1665, '00:00', '00:00', '0', NULL, NULL, 374, 4, 1, NULL, NULL, 0, 0),
(1666, '00:00', '00:00', '0', NULL, NULL, 374, 5, 1, NULL, NULL, 0, 0),
(1667, '00:00', '00:00', '0', NULL, NULL, 374, 6, 1, NULL, NULL, 0, 0),
(1668, '00:00', '00:00', '0', NULL, NULL, 374, 7, 1, NULL, NULL, 0, 0),
(1669, '00:00', '00:00', '0', NULL, NULL, 374, 8, 1, NULL, NULL, 0, 0),
(1670, '00:00', '00:00', '0', NULL, NULL, 374, 10, 1, NULL, NULL, 0, 0),
(1671, '00:00', '00:00', '0', NULL, NULL, 375, 1, 1, NULL, NULL, 0, 0),
(1672, '00:00', '00:00', '0', NULL, NULL, 375, 2, 1, NULL, NULL, 0, 0),
(1673, '00:00', '00:00', '0', NULL, NULL, 375, 3, 1, NULL, NULL, 0, 0),
(1674, '00:00', '00:00', '0', NULL, NULL, 375, 4, 1, NULL, NULL, 0, 0),
(1675, '00:00', '00:00', '0', NULL, NULL, 375, 5, 1, NULL, NULL, 0, 0),
(1676, '00:00', '00:00', '0', NULL, NULL, 375, 6, 1, NULL, NULL, 0, 0),
(1677, '00:00', '00:00', '0', NULL, NULL, 375, 7, 1, NULL, NULL, 0, 0),
(1678, '00:00', '00:00', '0', NULL, NULL, 375, 8, 1, NULL, NULL, 0, 0),
(1679, '00:00', '00:00', '0', NULL, NULL, 375, 10, 1, NULL, NULL, 0, 0),
(1680, '00:00', '00:00', '0', NULL, NULL, 376, 1, 1, NULL, NULL, 0, 0),
(1681, '00:00', '00:00', '0', NULL, NULL, 376, 3, 1, NULL, NULL, 0, 0),
(1682, '00:00', '00:00', '0', NULL, NULL, 376, 4, 1, NULL, NULL, 0, 0),
(1683, '00:00', '00:00', '0', NULL, NULL, 376, 5, 1, NULL, NULL, 0, 0),
(1684, '00:00', '00:00', '0', NULL, NULL, 376, 6, 1, NULL, NULL, 0, 0),
(1685, '00:00', '00:00', '0', NULL, NULL, 376, 7, 1, NULL, NULL, 0, 0),
(1686, '00:00', '00:00', '0', NULL, NULL, 376, 8, 1, NULL, NULL, 0, 0),
(1687, '00:00', '00:00', '0', NULL, NULL, 376, 10, 1, NULL, NULL, 0, 0),
(1688, '00:00', '00:00', '0', NULL, NULL, 377, 1, 1, NULL, NULL, 0, 0),
(1689, '00:00', '00:00', '0', NULL, NULL, 377, 3, 1, NULL, NULL, 0, 0),
(1690, '00:00', '00:00', '0', NULL, NULL, 377, 4, 1, NULL, NULL, 0, 0),
(1691, '00:00', '00:00', '0', NULL, NULL, 377, 5, 1, NULL, NULL, 0, 0),
(1692, '00:00', '00:00', '0', NULL, NULL, 377, 6, 1, NULL, NULL, 0, 0),
(1693, '00:00', '00:00', '0', NULL, NULL, 377, 7, 1, NULL, NULL, 0, 0),
(1694, '00:00', '00:00', '0', NULL, NULL, 377, 8, 1, NULL, NULL, 0, 0),
(1695, '00:00', '00:00', '0', NULL, NULL, 377, 10, 1, NULL, NULL, 0, 0),
(1696, '00:00', '00:00', '0', NULL, NULL, 378, 1, 1, NULL, NULL, 0, 0),
(1697, '00:00', '00:00', '0', NULL, NULL, 378, 3, 1, NULL, NULL, 0, 0),
(1698, '00:00', '00:00', '0', NULL, NULL, 378, 4, 1, NULL, NULL, 0, 0),
(1699, '00:00', '00:00', '0', NULL, NULL, 378, 5, 1, NULL, NULL, 0, 0),
(1700, '00:00', '00:00', '0', NULL, NULL, 378, 6, 1, NULL, NULL, 0, 0),
(1701, '00:00', '00:00', '0', NULL, NULL, 378, 7, 1, NULL, NULL, 0, 0),
(1702, '00:00', '00:00', '0', NULL, NULL, 378, 8, 1, NULL, NULL, 0, 0),
(1703, '00:00', '00:00', '0', NULL, NULL, 378, 10, 1, NULL, NULL, 0, 0),
(1704, '00:00', '00:00', '0', NULL, NULL, 379, 1, 1, NULL, NULL, 0, 0),
(1705, '00:00', '00:00', '0', NULL, NULL, 379, 2, 1, NULL, NULL, 0, 0),
(1706, '00:00', '00:00', '0', NULL, NULL, 379, 3, 1, NULL, NULL, 0, 0),
(1707, '00:00', '00:00', '0', NULL, NULL, 379, 4, 1, NULL, NULL, 0, 0),
(1708, '00:00', '00:00', '0', NULL, NULL, 379, 5, 1, NULL, NULL, 0, 0),
(1709, '00:00', '00:00', '0', NULL, NULL, 379, 6, 1, NULL, NULL, 0, 0),
(1710, '00:00', '00:00', '0', NULL, NULL, 379, 7, 1, NULL, NULL, 0, 0),
(1711, '00:00', '00:00', '0', NULL, NULL, 379, 8, 1, NULL, NULL, 0, 0),
(1712, '00:00', '00:00', '0', NULL, NULL, 379, 10, 1, NULL, NULL, 0, 0),
(1713, '00:00', '00:00', '0', NULL, NULL, 380, 1, 1, NULL, NULL, 0, 0),
(1714, '00:00', '00:00', '0', NULL, NULL, 380, 3, 1, NULL, NULL, 0, 0),
(1715, '00:00', '00:00', '0', NULL, NULL, 380, 4, 1, NULL, NULL, 0, 0),
(1716, '00:00', '00:00', '0', NULL, NULL, 380, 5, 1, NULL, NULL, 0, 0),
(1717, '00:00', '00:00', '0', NULL, NULL, 380, 6, 1, NULL, NULL, 0, 0),
(1718, '00:00', '00:00', '0', NULL, NULL, 380, 7, 1, NULL, NULL, 0, 0),
(1719, '00:00', '00:00', '0', NULL, NULL, 380, 8, 1, NULL, NULL, 0, 0),
(1720, '00:00', '00:00', '0', NULL, NULL, 380, 10, 1, NULL, NULL, 0, 0),
(1721, '00:00', '00:00', '0', NULL, NULL, 381, 1, 1, NULL, NULL, 0, 0),
(1722, '00:00', '00:00', '0', NULL, NULL, 381, 2, 1, NULL, NULL, 0, 0),
(1723, '00:00', '00:00', '0', NULL, NULL, 381, 3, 1, NULL, NULL, 0, 0),
(1724, '00:00', '00:00', '0', NULL, NULL, 381, 4, 1, NULL, NULL, 0, 0),
(1725, '00:00', '00:00', '0', NULL, NULL, 381, 5, 1, NULL, NULL, 0, 0),
(1726, '00:00', '00:00', '0', NULL, NULL, 381, 6, 1, NULL, NULL, 0, 0),
(1727, '00:00', '00:00', '0', NULL, NULL, 381, 7, 1, NULL, NULL, 0, 0),
(1728, '00:00', '00:00', '0', NULL, NULL, 381, 8, 1, NULL, NULL, 0, 0),
(1729, '00:00', '00:00', '0', NULL, NULL, 381, 10, 1, NULL, NULL, 0, 0),
(1730, '00:00', '00:00', '0', NULL, NULL, 382, 1, 1, NULL, NULL, 0, 0),
(1731, '00:00', '00:00', '0', NULL, NULL, 382, 2, 1, NULL, NULL, 0, 0),
(1732, '00:00', '00:00', '0', NULL, NULL, 382, 3, 1, NULL, NULL, 0, 0),
(1733, '00:00', '00:00', '0', NULL, NULL, 382, 4, 1, NULL, NULL, 0, 0),
(1734, '00:00', '00:00', '0', NULL, NULL, 382, 5, 1, NULL, NULL, 0, 0),
(1735, '00:00', '00:00', '0', NULL, NULL, 382, 6, 1, NULL, NULL, 0, 0),
(1736, '00:00', '00:00', '0', NULL, NULL, 382, 7, 1, NULL, NULL, 0, 0),
(1737, '00:00', '00:00', '0', NULL, NULL, 382, 8, 1, NULL, NULL, 0, 0),
(1738, '00:00', '00:00', '0', NULL, NULL, 382, 10, 1, NULL, NULL, 0, 0),
(1739, '00:00', '00:00', '0', NULL, NULL, 383, 1, 1, NULL, NULL, 0, 0),
(1740, '00:00', '00:00', '0', NULL, NULL, 383, 2, 1, NULL, NULL, 0, 0),
(1741, '00:00', '00:00', '0', NULL, NULL, 383, 3, 1, NULL, NULL, 0, 0),
(1742, '00:00', '00:00', '0', NULL, NULL, 383, 4, 1, NULL, NULL, 0, 0),
(1743, '00:00', '00:00', '0', NULL, NULL, 383, 5, 1, NULL, NULL, 0, 0),
(1744, '00:00', '00:00', '0', NULL, NULL, 383, 6, 1, NULL, NULL, 0, 0),
(1745, '00:00', '00:00', '0', NULL, NULL, 383, 7, 1, NULL, NULL, 0, 0),
(1746, '00:00', '00:00', '0', NULL, NULL, 383, 8, 1, NULL, NULL, 0, 0),
(1747, '00:00', '00:00', '0', NULL, NULL, 383, 10, 1, NULL, NULL, 0, 0),
(1748, '00:00', '00:00', '0', NULL, NULL, 384, 1, 1, NULL, NULL, 0, 0),
(1749, '00:00', '00:00', '0', NULL, NULL, 384, 3, 1, NULL, NULL, 0, 0),
(1750, '00:00', '00:00', '0', NULL, NULL, 384, 4, 1, NULL, NULL, 0, 0),
(1751, '00:00', '00:00', '0', NULL, NULL, 384, 5, 1, NULL, NULL, 0, 0),
(1752, '00:00', '00:00', '0', NULL, NULL, 384, 6, 1, NULL, NULL, 0, 0),
(1753, '00:00', '00:00', '0', NULL, NULL, 384, 7, 1, NULL, NULL, 0, 0),
(1754, '00:00', '00:00', '0', NULL, NULL, 384, 8, 1, NULL, NULL, 0, 0),
(1755, '00:00', '00:00', '0', NULL, NULL, 384, 10, 1, NULL, NULL, 0, 0),
(1756, '00:00', '00:00', '0', NULL, NULL, 385, 1, 1, NULL, NULL, 0, 0),
(1757, '00:00', '00:00', '0', NULL, NULL, 385, 3, 1, NULL, NULL, 0, 0),
(1758, '00:00', '00:00', '0', NULL, NULL, 385, 4, 1, NULL, NULL, 0, 0),
(1759, '00:00', '00:00', '0', NULL, NULL, 385, 5, 1, NULL, NULL, 0, 0),
(1760, '00:00', '00:00', '0', NULL, NULL, 385, 6, 1, NULL, NULL, 0, 0),
(1761, '00:00', '00:00', '0', NULL, NULL, 385, 7, 1, NULL, NULL, 0, 0),
(1762, '00:00', '00:00', '0', NULL, NULL, 385, 8, 1, NULL, NULL, 0, 0),
(1763, '00:00', '00:00', '0', NULL, NULL, 385, 10, 1, NULL, NULL, 0, 0),
(1764, '00:00', '00:00', '0', NULL, NULL, 386, 1, 1, NULL, NULL, 0, 0),
(1765, '00:00', '00:00', '0', NULL, NULL, 386, 3, 1, NULL, NULL, 0, 0),
(1766, '00:00', '00:00', '0', NULL, NULL, 386, 4, 1, NULL, NULL, 0, 0),
(1767, '00:00', '00:00', '0', NULL, NULL, 386, 5, 1, NULL, NULL, 0, 0),
(1768, '00:00', '00:00', '0', NULL, NULL, 386, 6, 1, NULL, NULL, 0, 0),
(1769, '00:00', '00:00', '0', NULL, NULL, 386, 7, 1, NULL, NULL, 0, 0),
(1770, '00:00', '00:00', '0', NULL, NULL, 386, 8, 1, NULL, NULL, 0, 0),
(1771, '00:00', '00:00', '0', NULL, NULL, 386, 10, 1, NULL, NULL, 0, 0),
(1772, '00:00', '00:00', '0', NULL, NULL, 387, 1, 1, NULL, NULL, 0, 0),
(1773, '00:00', '00:00', '0', NULL, NULL, 387, 3, 1, NULL, NULL, 0, 0),
(1774, '00:00', '00:00', '0', NULL, NULL, 387, 4, 1, NULL, NULL, 0, 0),
(1775, '00:00', '00:00', '0', NULL, NULL, 387, 5, 1, NULL, NULL, 0, 0),
(1776, '00:00', '00:00', '0', NULL, NULL, 387, 6, 1, NULL, NULL, 0, 0),
(1777, '00:00', '00:00', '0', NULL, NULL, 387, 7, 1, NULL, NULL, 0, 0),
(1778, '00:00', '00:00', '0', NULL, NULL, 387, 8, 1, NULL, NULL, 0, 0),
(1779, '00:00', '00:00', '0', NULL, NULL, 387, 10, 1, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_proyecto`
--

CREATE TABLE `detalle_proyecto` (
  `idDetalle_proyecto` int(11) NOT NULL,
  `tipo_negocio_idtipo_negocio` tinyint(4) NOT NULL,
  `canitadad_total` varchar(6) NOT NULL,
  `material` varchar(6) DEFAULT NULL,
  `proyecto_numero_orden` int(11) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
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

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `tipo_negocio_idtipo_negocio`, `canitadad_total`, `material`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`, `lider_proyecto`) VALUES
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
(17, 1, '10', NULL, 31809, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, '43542658'),
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
(219, 1, '60', 'FV', 32245, 1, 2, 0, NULL, 7, 0, 1, 0, '00:51', '00:00', NULL, NULL),
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
(245, 1, '30', 'TH', 32269, 1, 4, 0, NULL, 7, 1, 0, 1, '223:35', '00:00', NULL, NULL),
(246, 10, '', NULL, 32270, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(247, 1, '5', 'TH', 32270, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(248, 1, '5', NULL, 32270, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(249, 1, '100', 'FV', 32273, 1, 4, 0, NULL, 6, 1, 0, 1, '01:22', '00:00', NULL, NULL),
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
(263, 1, '10', 'TH', 32285, 1, 2, 0, NULL, 6, 0, 1, 2, '98:56', '00:00', NULL, NULL),
(264, 1, '20', 'TH', 32286, 1, 2, 0, NULL, 6, 0, 0, 3, '141:06', '00:00', NULL, NULL),
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
(283, 1, '50', 'TH', 32295, 1, 2, 0, NULL, 6, 0, 2, 1, '2081:12', '00:00', NULL, NULL),
(284, 1, '1', 'TH', 32296, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(285, 1, '25', 'TH', 32297, 1, 4, 0, NULL, 3, 3, 0, 3, '217:36', '00:00', NULL, NULL),
(286, 1, '24', 'TH', 32298, 1, 2, 0, NULL, 6, 0, 0, 3, '83:20', '00:00', NULL, NULL),
(287, 1, '10', 'TH', 32299, 1, 4, 0, NULL, 5, 2, 0, 2, '09:46', '00:00', NULL, NULL),
(288, 10, '', NULL, 32300, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(289, 1, '10', 'FV', 32300, 1, 4, 0, NULL, 8, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(290, 1, '10', NULL, 32300, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(291, 1, '5', 'FV', 32301, 1, 4, 0, NULL, 5, 1, 0, 2, '22:52', '00:00', NULL, NULL),
(294, 1, '21', 'TH', 32306, 1, 2, 0, NULL, 6, 0, 0, 3, '351:48', '00:00', NULL, NULL),
(295, 1, '5', 'TH', 32307, 1, 2, 0, NULL, 8, 0, 0, 1, '28:48', '00:00', NULL, NULL),
(296, 1, '50', 'FV', 32310, 1, 2, 0, NULL, 4, 0, 0, 3, '138:14', '00:00', NULL, NULL),
(297, 10, '', NULL, 32309, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(298, 1, '3', 'TH', 32309, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(299, 1, '3', NULL, 32309, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(300, 1, '1', 'FV', 32311, 1, 2, 0, NULL, 6, 0, 0, 2, '09:41', '00:00', NULL, NULL),
(301, 1, '1', 'TH', 32312, 1, 2, 0, NULL, 3, 0, 0, 6, '170:39', '00:00', NULL, NULL),
(302, 1, '3', 'TH', 32302, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(303, 1, '4', 'TH', 32303, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(304, 1, '4', 'TH', 32313, 1, 2, 0, NULL, 3, 0, 0, 6, '217:10', '00:00', NULL, NULL),
(305, 1, '10', 'FV', 32314, 1, 2, 0, NULL, 4, 0, 0, 4, '77:27', '00:00', NULL, NULL),
(306, 1, '2', 'TH', 32315, 1, 2, 0, NULL, 8, 0, 0, 1, '92:26', '00:00', NULL, NULL),
(307, 10, '', NULL, 32177, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(308, 1, '100', 'TH', 32177, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(309, 1, '100', NULL, 32177, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(310, 6, '1', NULL, 32177, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(311, 1, '20', 'TH', 32316, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(312, 1, '50', 'FV', 32317, 1, 4, 0, NULL, 1, 4, 1, 2, '207:21', '00:00', NULL, NULL),
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
(323, 10, '', NULL, 32324, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(324, 1, '5', 'TH', 32324, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(325, 1, '5', NULL, 32324, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(326, 1, '5', 'TH', 32326, 1, 4, 0, NULL, 6, 1, 0, 2, '63:58', '00:00', NULL, NULL),
(327, 1, '5', 'TH', 32327, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(328, 10, '', NULL, 32328, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(329, 8, '5000', 'GF', 32328, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(330, 1, '5000', NULL, 32328, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(331, 6, '1', NULL, 32328, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(332, 10, '', NULL, 32329, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(333, 8, '2', 'GF', 32329, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(334, 1, '2', NULL, 32329, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(335, 6, '1', NULL, 32329, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(336, 10, '', NULL, 32330, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(337, 8, '0', 'GF', 32330, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(338, 1, '0', NULL, 32330, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(339, 1, '10', 'TH', 32331, 1, 2, 0, NULL, 7, 0, 1, 1, '122:10', '00:00', NULL, NULL),
(340, 1, '2', 'FV', 32332, 1, 2, 0, NULL, 7, 0, 0, 1, '07:29', '00:00', NULL, NULL),
(341, 1, '12', 'TH', 32333, 1, 2, 0, NULL, 7, 0, 0, 2, '110:02', '00:00', NULL, NULL),
(342, 1, '100', 'FV', 32335, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(343, 1, '5', 'FV', 32336, 1, 4, 0, NULL, 6, 2, 0, 0, '00:00', '00:00', NULL, NULL),
(344, 1, '5', 'TH', 32339, 1, 2, 0, NULL, 9, 0, 0, 1, '68:11', '00:00', NULL, NULL),
(345, 1, '4', 'TH', 32340, 1, 2, 0, NULL, 8, 0, 0, 2, '76:51', '00:00', NULL, NULL),
(346, 1, '2', 'TH', 32343, 1, 2, 0, NULL, 7, 0, 0, 2, '60:10', '00:00', NULL, NULL),
(347, 1, '1', 'TH', 32348, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(348, 1, '20', 'TH', 32347, 1, 2, 0, NULL, 8, 0, 0, 1, '12:13', '00:00', NULL, NULL),
(349, 1, '6', 'TH', 32349, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(350, 1, '4', 'TH', 32350, 1, 2, 0, NULL, 7, 0, 0, 2, '112:51', '00:00', NULL, NULL),
(351, 1, '30', 'FV', 32351, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(352, 10, '', NULL, 32352, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(353, 8, '10', 'GF', 32352, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(354, 1, '10', NULL, 32352, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(355, 6, '1', NULL, 32352, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(356, 1, '3', 'TH', 32354, 1, 2, 0, NULL, 8, 0, 0, 1, '101:23', '00:00', NULL, NULL),
(357, 1, '6', 'TH', 32355, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(358, 10, '', NULL, 32353, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(359, 8, '190', 'GF', 32353, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(360, 1, '190', NULL, 32353, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(361, 6, '1', NULL, 32353, 1, 1, 0, NULL, 3, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(362, 1, '15', 'TH', 32356, 1, 2, 0, NULL, 8, 0, 0, 1, '101:21', '00:00', NULL, NULL),
(363, 1, '50', 'TH', 32359, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(364, 1, '20', 'TH', 32361, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(365, 1, '2', 'TH', 32360, 1, 2, 0, NULL, 8, 0, 0, 1, '43:21', '00:00', NULL, NULL),
(366, 10, '', NULL, 32362, 4, 4, 0, NULL, 0, 1, 0, 0, '00:00', '00:00', NULL, NULL),
(367, 1, '10', 'TH', 32362, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(368, 1, '10', NULL, 32362, 3, 1, 0, NULL, 4, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(369, 1, '4', 'TH', 32363, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(370, 1, '2', 'TH', 32364, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(371, 1, '10', 'TH', 32365, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(372, 1, '5', 'FV', 32366, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(373, 1, '1', 'TH', 32371, 1, 2, 0, NULL, 8, 0, 0, 1, '43:15', '00:00', NULL, NULL),
(374, 1, '1', 'TH', 32372, 1, 2, 0, NULL, 8, 0, 0, 1, '43:02', '00:00', NULL, NULL),
(375, 1, '2', 'TH', 32373, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(376, 1, '40', 'FV', 32376, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(377, 1, '5', 'FV', 32382, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(378, 1, '5', 'FV', 32383, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(379, 1, '2', 'TH', 32387, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(380, 1, '5', 'FV', 32384, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(381, 1, '5', 'TH', 32388, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(382, 1, '10', 'TH', 32385, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(383, 1, '20', 'TH', 32389, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(384, 1, '10', 'FV', 32386, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(385, 1, '1000', 'FV', 32393, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(386, 1, '4000', 'FV', 32394, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL),
(387, 1, '1000', 'FV', 32395, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL, NULL);

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
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` varchar(19) DEFAULT NULL,
  `hora_terminacion` varchar(19) DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_teclados`
--

INSERT INTO `detalle_teclados` (`idDetalle_teclados`, `tiempo_por_unidad`, `tiempo_total_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1, '00:00', '00:36', '0', '2018-12-05', NULL, 20, 11, 2, '2018-12-05 12:24:46', '2018-12-05 12:25:22', 15, 0),
(2, '00:00', '00:00', '0', NULL, NULL, 20, 12, 1, NULL, NULL, 0, 0),
(3, '00:00', '00:00', '0', NULL, NULL, 20, 13, 1, NULL, NULL, 0, 0),
(4, '00:00', '00:00', '0', NULL, NULL, 20, 14, 1, NULL, NULL, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_tipo_negocio_proceso`
--

CREATE TABLE `detalle_tipo_negocio_proceso` (
  `idproceso` tinyint(4) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL,
  `idtipo_negocio` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `idestado` tinyint(4) NOT NULL,
  `nombre` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`idestado`, `nombre`) VALUES
(4, 'Ejecucion'),
(2, 'Pausado'),
(1, 'Por iniciar'),
(3, 'Terminado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `negocio`
--

CREATE TABLE `negocio` (
  `idnegocio` tinyint(4) NOT NULL,
  `nom_negocio` varchar(7) NOT NULL,
  `estado` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `negocio`
--

INSERT INTO `negocio` (`idnegocio`, `nom_negocio`, `estado`) VALUES
(1, 'FE', 1),
(2, 'TE', 1),
(3, 'IN', 1),
(4, 'ALMACEN', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `procesos`
--

CREATE TABLE `procesos` (
  `idproceso` tinyint(4) NOT NULL,
  `nombre_proceso` varchar(30) NOT NULL,
  `estado` tinyint(1) NOT NULL,
  `negocio_idnegocio` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `procesos`
--

INSERT INTO `procesos` (`idproceso`, `nombre_proceso`, `estado`, `negocio_idnegocio`) VALUES
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
  `estado_idestado` tinyint(4) NOT NULL,
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

INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `ruteoC`, `antisolderC`, `estado_idestado`, `antisolderP`, `ruteoP`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
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
(31762, '1152697088', 'CORONA-Colcerámica', 'CORONA COLCERAMICA-DRAA V2.11 - OCT 23-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-11-27 07:06:11', '2018-12-26', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31793, '1152697088', 'MINISTERIO DE DEFENSA NACIONAL', 'MINDEFENSA - PLACA DE CONTROL - NOV 28-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-03 10:31:36', '2018-12-14', '2018-12-20 14:51:47', 0, 0, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31795, '981130', 'TECREA S.A.S', 'TRACKFOX LORA', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-01-29 06:21:53', '2018-12-26', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(31799, '98765201', 'TECREA S.A.S ', 'COLLAR FASE 1 ', 'RQT', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-12 10:27:19', '2018-12-14', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(31809, '1152697088', 'DISTRACOM S.A', 'DISTRACOM-MFC OMEGA-NOV 27-18', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2018-12-03 09:41:39', '2018-12-18', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
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
(32273, '1216714539', 'MIGUEL EDUARDO CARRE%C3%91O ', 'CONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 14:25:13', '2019-02-28', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32275, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', ' LUXOMETRO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 15:31:12', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32276, '1216714539', 'OPTEC POWER SAS ', 'OPi48BF65BP V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 16:01:51', '2019-02-27', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32277, '1216714539', 'TECREA S.A.S ', 'ACOPLE GPS DISPROLAB ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 17:26:10', '2019-02-18', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-14', '2019-02-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32278, '1216714539', 'GROUND ELECTRONICS S.A.S ', 'GSM USB SD V1.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-14 17:32:44', '2019-02-21', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32279, '1216714539', 'DAVID ALEXANDER SADOVNIK ', ' PROJECT OUTPUTS FOR KPROJ_PCBV2 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 09:44:29', '2019-02-27', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-22', '2019-02-19', NULL, NULL, NULL, 'A tiempo', NULL),
(32280, '1216714539', 'WENDY PATRICIA HERNANDEZ ACOSTA ', 'FILTRO DE FLUIDO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 09:48:12', '2019-02-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32281, '1216714539', 'DANIEL DUARTE PUERTA ', 'Lector_7seg_serial_v5_485 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 11:23:30', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32283, '1216714539', 'CARLOS JOSE MEDINA GINER ', 'PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 13:14:21', '2019-02-22', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32285, '1216714539', 'BIOINNOVA S.A.S ', 'ALARMA TFT V 2.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 14:51:13', '2019-02-26', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32286, '1216714539', 'MAD INGENIEROS LTDA ', 'CXD V 3.2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 17:00:46', '2019-02-28', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32287, '1216714539', 'DOMETAL ', '8200 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-02-15 17:05:27', '2019-03-18', NULL, 1, 1, 4, 1, 1, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32288, '1216714539', 'DOMETAL ', '7904 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, '2019-02-15 17:09:09', '2019-03-18', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32289, '1216714539', 'DOMETAL ', '8996 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-15 17:13:28', '2019-03-11', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32291, '1216714539', 'DOMETAL ', '8198 ', 'Normal', 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, '2019-02-15 17:25:09', '2019-03-18', NULL, 1, 1, 4, 1, 1, 1, 1, '2019-03-06', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32292, '1216714539', 'TECREA S.A.S ', 'LAP CAMKIT MAIN ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 07:13:05', '2019-03-04', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-02-23', NULL, NULL, NULL, 'A tiempo', NULL),
(32293, '1216714539', 'ALUTRAFIC LED S.A.S ', 'AT HORT REG 2835 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 07:11:00', '2019-02-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32294, '1216714539', 'LUISA FERNANDA VELASQUEZ ECHEVERRI / SMARTEAM ', ' CONTADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 11:51:42', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32295, '1216714539', 'COINS S.A.S ', 'ARCO DE LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 11:59:03', '2019-03-04', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32296, '1216714539', 'PEDRO MANUEL CASTRO DAVID ', 'PCB THS4531 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 12:35:44', '2019-02-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32297, '1216714539', 'MICRO HOM S.A.S ', 'ARRANQUE V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 14:34:25', '2019-03-01', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32298, '1216714539', 'SIOMA SAS ', ' PLACA V5 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 15:40:21', '2019-02-22', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(32299, '1216714539', 'BIOINNOVA S.A.S ', 'FRONT END TRANSDUCTORE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 15:46:11', '2019-02-27', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32300, '1216714539', 'ETEC S.A. ', 'TEMPORIZADOR DE RETARDO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 16:35:24', '2019-03-04', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-03-07', NULL, NULL, NULL, 'A tiempo', NULL),
(32301, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MCVF_TX_24_IN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-18 16:46:14', '2019-02-22', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32302, '1216714539', 'GRUPO ACUAMATIC S.A.S ', 'acuaboardesp32 DEVKITC eagle 7_2019 02 18 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 10:41:47', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32303, '1216714539', 'ATP TRADING SAS ', 'Det_Ind_1302 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 10:42:37', '2019-02-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32306, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', 'TOKEN A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 08:37:23', '2019-03-05', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32307, '1216714539', 'FABIO LEON USUGA ROJO ', 'CARGADOR CONMUTADO ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 10:03:42', '2019-02-20', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32309, '1216714539', 'TECREA S.A.S ', 'LAP CAMKIT   LOWER ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 15:00:26', '2019-03-01', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-26', '2019-02-23', NULL, NULL, NULL, 'A tiempo', NULL),
(32310, '1216714539', 'OPTEC POWER SAS ', 'D24A40BP PZ V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 14:11:50', '2019-03-01', NULL, 0, 0, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32311, '1216714539', 'INDUSTRIAS LEO S.A ', 'PLAQUETA 534 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-19 16:17:27', '2019-02-25', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32312, '1216714539', 'SEBASTIAN JIMENEZ GOMEZ ', ' ODIN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 08:02:39', '2019-02-27', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32313, '1216714539', 'HERNANDO GAMA DUARTE ', 'EXTINTOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 12:00:13', '2019-02-27', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32314, '1216714539', 'RPM INGENIEROS S.A.S ', 'BASE PMR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 14:44:59', '2019-02-28', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32315, '1216714539', 'CARLOS JAVIER MOJICA CASILLAS ', 'LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 14:45:27', '2019-02-27', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32316, '1216714539', 'ARDOBOT ROBOTICA S.A.S ', 'CORE ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 16:45:11', '2019-03-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32317, '1216714539', 'POLITECNICO COLOMBIANO JIC ', 'FUENTE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-20 17:15:35', '2019-03-04', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32318, '1216714539', 'TECREA S.A.S ', 'SX3 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-20 17:25:29', '2019-03-19', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-11', '2019-03-20', NULL, NULL, NULL, 'A tiempo', NULL),
(32319, '1216714539', 'LYA ELECTRONICS ', 'UWIGO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-20 17:31:47', '2019-03-14', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-11', '2019-03-08', NULL, NULL, NULL, 'A tiempo', NULL),
(32321, '98765201', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 2', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-21 09:00:12', '2019-03-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32322, '98765201', 'MICROPLAST ANTONIO PALACIO & COMPAÑIA S.A.S.', 'INTEGRACION 2', 'Normal', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '2019-02-21 09:13:35', '2019-03-04', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32324, '1216714539', 'SEINTMA S.A.S ', 'EKS 4 V4 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-21 11:26:53', '2019-03-05', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-28', '2019-02-25', NULL, NULL, NULL, 'A tiempo', NULL),
(32326, '1216714539', 'STARTCHIP ', 'GIO p02 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-21 12:04:39', '2019-02-28', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32327, '1216714539', 'NOVA CONTROL S.A.S ', 'SPD_WIRELESS_V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-21 12:09:08', '2019-02-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32328, '1216714539', 'LUMEN S.A.S ', 'PCB REC 146MM 12 219C BJB INF ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-21 14:50:54', '2019-03-17', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-27', '2019-03-15', NULL, NULL, NULL, 'A tiempo', NULL),
(32329, '1216714539', 'TECREA S.A.S ', 'MODULO GATEWAYIOT 3G ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-21 15:17:21', '2019-03-15', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-12', '2019-03-09', NULL, NULL, NULL, 'A tiempo', NULL),
(32330, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', 'LUXOMETRO ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-21 15:21:36', '2019-02-26', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-02-21', '2019-02-22', NULL, NULL, NULL, 'A tiempo', NULL),
(32331, '1216714539', 'ZIGO S.A.S ', 'CIRCUITO MAQUINA FINAL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-21 15:30:00', '2019-03-04', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32332, '1216714539', 'TECONDOR S.A.S ', 'SENSORES DE CORRIENTE ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-22 11:28:23', '2019-02-25', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32333, '1216714539', 'ANDRES FELIPE SANCHEZ PRISCO ', 'ESCLAVO_VER_1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-22 17:15:06', '2019-03-06', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32335, '1216714539', 'MARCO AGUDELO ', 'CIRCUITO IMPRESO CONTROL SILLA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-25 08:53:48', '2019-03-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32336, '1216714539', 'ANDRES CAMILO BUITRAGO ', 'SP_1_MOD ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-25 08:57:10', '2019-03-01', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32339, '1216714539', 'CARLOS EDUARDO PENAGOS ', 'TICKETSOFT 6.3 Raspberrry UP   CADCAM ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-25 16:39:07', '2019-03-04', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32340, '1216714539', 'SIN RED SOLUTIONS S.A.S ', 'PANEL LOGO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 07:18:20', '2019-03-05', NULL, 1, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32343, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'QUEMADOR_ATTINY_SMD ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 12:10:10', '2019-02-27', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL);
INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `ruteoC`, `antisolderC`, `estado_idestado`, `antisolderP`, `ruteoP`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(32347, '1216714539', 'JOHN GERMAN GARCIA G ', 'TCAR3_20190225 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 17:07:12', '2019-03-11', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32348, '1216714539', 'JOHN GERMAN GARCIA G ', 'ACOND_20190226 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 17:06:31', '2019-03-05', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32349, '1216714539', 'LIGHTCON INGENIERIA SAS ', 'QUANTUM ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 17:09:37', '2019-03-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32350, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'Gerber_PCB_RGB_MAS ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-26 17:13:02', '2019-03-01', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32351, '1216714539', 'AMBIENTES ELECTRICOS SEGUROS INGENIERIA S.A.S ', '3F6 65K ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 07:53:22', '2019-03-11', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32352, '1216714539', 'COLCERAMICA S.A ', 'VENTUS 8 ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-27 11:58:59', '2019-03-26', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-20', '2019-03-19', NULL, NULL, NULL, 'A tiempo', NULL),
(32353, '1216714539', 'DISEVEN INNOVACION TECNOLOGICA S.A.S ', 'LUXURY UNIVERSAL RELES DOS ENTRADAS DOS SALIDAS ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, '2019-02-27 12:49:43', '2019-04-10', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-22', '2019-03-19', NULL, NULL, NULL, 'A tiempo', NULL),
(32354, '1216714539', 'FREDY ORTIZ ', 'ORCA21_2019 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 12:41:46', '2019-03-07', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32355, '1216714539', 'FREDY ORTIZ ', 'CAR2019 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 12:48:11', '2019-03-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32356, '1216714539', 'GROUND ELECTRONICS S.A.S ', ' SCH 5008 S ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 15:47:55', '2019-03-11', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32359, '1216714539', 'NESTOR DAZA MEDINA ', 'LLAVES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 16:21:53', '2019-03-12', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32360, '1216714539', 'ENERGESIS NATURA S.A.S ', 'SERVIDOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 17:13:25', '2019-03-06', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32361, '1216714539', 'GROUND ELECTRONICS S.A.S ', ' TM 4x4_V1.0.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-27 17:01:16', '2019-03-12', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32362, '1216714539', 'ASHARA STUDIOS S.A.S ', 'SONDA (Ref P1v1.0) ', 'Normal', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 08:55:52', '2019-03-20', NULL, 1, 1, 4, 0, 0, 1, 1, '2019-03-08', '2019-03-05', NULL, NULL, NULL, 'A tiempo', NULL),
(32363, '1216714539', 'SONAR AVL SYSTEM S.A.S ', ' Rio2_V2 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 11:45:57', '2019-03-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32364, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'Gerber_PCB_CONTROL_BASICO_SMD ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 12:01:41', '2019-03-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32365, '1216714539', 'AMP SOLUCIONES S.A.S ', 'Control display 10 Inch ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 15:10:47', '2019-03-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32366, '1216714539', 'AMP SOLUCIONES S.A.S ', 'DISPLAY 2 DIGITOS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 15:16:19', '2019-03-06', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32371, '1216714539', 'MARYAM DEL MAR CORREA ', 'DIVISOR1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 16:08:46', '2019-03-07', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32372, '1216714539', 'MARYAM DEL MAR CORREA ', 'DIVISOR2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 16:11:26', '2019-03-07', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(32373, '1216714539', 'TRANSFORMADORES DE COLOMBIA TRACOL ', 'DISTRIBUCION ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-02-28 16:17:52', '2019-03-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32376, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'OPMVFOR02_2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 07:54:41', '2019-03-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32382, '1216714539', 'BIOMEDIK  GROUP S.A.S ', 'RF_POTENCIA_V12_04_2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 15:41:47', '2019-03-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32383, '1216714539', 'BIOMEDIK  GROUP S.A.S ', 'RF_FUENTE V11_04_2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 15:43:54', '2019-03-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32384, '1216714539', 'BIOMEDIK  GROUP S.A.S ', 'RELES RF ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 15:56:35', '2019-03-07', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32385, '1216714539', 'BIOMEDIK  GROUP S.A.S ', 'TECLADO TOUCH_V21_3_2017 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 16:01:16', '2019-03-12', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32386, '1216714539', 'BIOMEDIK  GROUP S.A.S ', 'MOTOR SOLEN V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 16:03:15', '2019-03-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32387, '1216714539', 'HERNANDO GAMA DUARTE ', ' ADULTO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 15:52:37', '2019-03-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32388, '1216714539', 'SUBSUELO 3D ', 'AMPLIFICADOR_16_CH ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 15:58:01', '2019-03-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32389, '1216714539', 'SUBSUELO 3D ', ' GANANCIAS_S16 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 16:01:40', '2019-03-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32393, '1216714539', 'INDUSTRIAS LEO S.A ', 'PLAQUETA 23A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 17:25:08', '2019-03-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32394, '1216714539', 'INDUSTRIAS LEO S.A ', 'PLAQUETA 801 REGULADOR CULATA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 17:30:36', '2019-03-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(32395, '1216714539', 'INDUSTRIAS LEO S.A ', 'PLAQUETA 531 JOG 50 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2019-03-01 17:32:56', '2019-03-28', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_negocio`
--

CREATE TABLE `tipo_negocio` (
  `idtipo_negocio` tinyint(4) NOT NULL,
  `nombre` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `tipo_negocio`
--

INSERT INTO `tipo_negocio` (`idtipo_negocio`, `nombre`) VALUES
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
('1017156424', 'CC', 'YAZMIN ANDREA', 'GALEANO CASTAÑEDA', 3, '', 1, 'yazmin1987', 1, 'dñpgxp68@4'),
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
('1017156424', 'COM7', NULL, 1),
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
  ADD KEY `fk_iddetalleproyecto_amacen` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_idestado_amacen` (`estado_idestado`),
  ADD KEY `fk_proceso_id` (`Procesos_idproceso`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`idcargo`);

--
-- Indices de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD PRIMARY KEY (`idDetalle_ensamble`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_ensamble_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_ensamble_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD PRIMARY KEY (`idDetalle_formato_estandar`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_formato_estandar_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_formato_estandar_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_formato_estandar_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD PRIMARY KEY (`idDetalle_proyecto`,`tipo_negocio_idtipo_negocio`,`proyecto_numero_orden`,`negocio_idnegocio`,`estado_idestado`),
  ADD KEY `fk_detalle_proyecto_proyecto1_idx` (`proyecto_numero_orden`),
  ADD KEY `fk_detalle_proyecto_tipo_negocio1_idx` (`tipo_negocio_idtipo_negocio`),
  ADD KEY `fk_detalle_proyecto_negocio1_idx` (`negocio_idnegocio`),
  ADD KEY `fk_detalle_proyecto_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD PRIMARY KEY (`idDetalle_teclados`,`detalle_proyecto_idDetalle_proyecto`,`Procesos_idproceso`,`estado_idestado`),
  ADD KEY `fk_detalle_teclados_detalle_proyecto1_idx` (`detalle_proyecto_idDetalle_proyecto`),
  ADD KEY `fk_detalle_teclados_Procesos1_idx` (`Procesos_idproceso`),
  ADD KEY `fk_detalle_teclados_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `detalle_tipo_negocio_proceso`
--
ALTER TABLE `detalle_tipo_negocio_proceso`
  ADD PRIMARY KEY (`idproceso`,`negocio_idnegocio`,`idtipo_negocio`),
  ADD KEY `fk_Procesos_has_tipo_negocio_tipo_negocio1_idx` (`idtipo_negocio`),
  ADD KEY `fk_Procesos_has_tipo_negocio_Procesos1_idx` (`idproceso`,`negocio_idnegocio`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`idestado`),
  ADD UNIQUE KEY `nombre_UNIQUE` (`nombre`);

--
-- Indices de la tabla `negocio`
--
ALTER TABLE `negocio`
  ADD PRIMARY KEY (`idnegocio`);

--
-- Indices de la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD PRIMARY KEY (`idproceso`,`negocio_idnegocio`),
  ADD KEY `fk_Procesos_negocio1_idx` (`negocio_idnegocio`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`numero_orden`,`usuario_numero_documento`,`estado_idestado`),
  ADD UNIQUE KEY `numero_orden_UNIQUE` (`numero_orden`),
  ADD KEY `fk_proyecto_usuario_idx` (`usuario_numero_documento`),
  ADD KEY `fk_proyecto_estado1_idx` (`estado_idestado`);

--
-- Indices de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  ADD PRIMARY KEY (`idtipo_negocio`);

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
  MODIFY `idalmacen` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=82;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `idcargo` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=349;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1780;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=388;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `estado`
--
ALTER TABLE `estado`
  MODIFY `idestado` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `negocio`
--
ALTER TABLE `negocio`
  MODIFY `idnegocio` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `procesos`
--
ALTER TABLE `procesos`
  MODIFY `idproceso` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32396;

--
-- AUTO_INCREMENT de la tabla `tipo_negocio`
--
ALTER TABLE `tipo_negocio`
  MODIFY `idtipo_negocio` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD CONSTRAINT `fk_iddetalleproyecto_amacen` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`),
  ADD CONSTRAINT `fk_idestado_amacen` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`),
  ADD CONSTRAINT `fk_proceso_id` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`);

--
-- Filtros para la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  ADD CONSTRAINT `fk_detalle_ensamble_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ensamble_detalle_proyecto10` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_ensamble_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  ADD CONSTRAINT `fk_detalle_formato_estandar_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_formato_estandar_detalle_proyecto1` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_formato_estandar_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  ADD CONSTRAINT `fk_detalle_proyecto_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_negocio1` FOREIGN KEY (`negocio_idnegocio`) REFERENCES `negocio` (`idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_proyecto1` FOREIGN KEY (`proyecto_numero_orden`) REFERENCES `proyecto` (`numero_orden`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_proyecto_tipo_negocio1` FOREIGN KEY (`tipo_negocio_idtipo_negocio`) REFERENCES `tipo_negocio` (`idtipo_negocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  ADD CONSTRAINT `fk_detalle_teclados_Procesos1` FOREIGN KEY (`Procesos_idproceso`) REFERENCES `procesos` (`idproceso`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_detalle_proyecto1` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `detalle_tipo_negocio_proceso`
--
ALTER TABLE `detalle_tipo_negocio_proceso`
  ADD CONSTRAINT `fk_Procesos_has_tipo_negocio_Procesos1` FOREIGN KEY (`idproceso`,`negocio_idnegocio`) REFERENCES `procesos` (`idproceso`, `negocio_idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Procesos_has_tipo_negocio_tipo_negocio1` FOREIGN KEY (`idtipo_negocio`) REFERENCES `tipo_negocio` (`idtipo_negocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `procesos`
--
ALTER TABLE `procesos`
  ADD CONSTRAINT `fk_Procesos_negocio1` FOREIGN KEY (`negocio_idnegocio`) REFERENCES `negocio` (`idnegocio`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `fk_proyecto_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
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
