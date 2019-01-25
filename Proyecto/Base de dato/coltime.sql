-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-09-2018 a las 19:45:12
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_CalcularTiempoMinutos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT)  NO SQL
BEGIN
DECLARE id int;

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_formato_estandar f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_formato_estandar=id;

SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;


ELSE
 IF busqueda=2 THEN
 
SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_teclados f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_teclados=id;

SELECT f.tiempo_total_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;

 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

 UPDATE detalle_ensamble f SET  f.hora_terminacion=CURRENT_TIME WHERE f.idDetalle_ensamble=id;
  
  SELECT f.tiempo_total_por_proceso,TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as diferencia from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4;
  
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
 IF negocio=2 or negocio=3 THEN

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_ConsultarProcesos` ()  NO SQL
BEGIN

SELECT * FROM procesos p ORDER BY p.idproceso ASC;

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
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y') as inicio,Date_format(f.fecha_fin,'%d-%M-%Y') as fin,f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre as estado,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s') as tiempoActual,TIME_FORMAT(f.hora_terminacion,'%r') as "hora terminacion",TIME_FORMAT(TIMEDIFF(TIME_FORMAT(f.hora_terminacion,'%H:%i:%s'),TIME_FORMAT(f.hora_ejecucion,'%H:%i:%s')),'%H:%i:%s') as InicioTerminadoIntervalo,f.idDetalle_formato_estandar,f.restantes,f.noperarios FROM detalle_formato_estandar f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
ELSE
  IF negocio=2 THEN
  SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s'),TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_teclados,f.restantes,f.noperarios FROM detalle_teclados f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
  ELSE
   IF negocio=3 THEN
SELECT p.nombre_proceso,Date_Format(f.fecha_inicio,'%d-%M-%Y'),Date_format(f.fecha_fin,'%d-%M-%Y'),f.cantidad_terminada,f.tiempo_total_por_proceso,f.tiempo_por_unidad,e.nombre,TIME_FORMAT(f.hora_ejecucion,'%r'),TIME_FORMAT(TIMEDIFF(CURRENT_TIME,f.hora_ejecucion),'%H:%i:%s'),TIME_FORMAT(f.hora_terminacion,'%r'),TIME_FORMAT(TIMEDIFF(f.hora_terminacion,f.hora_ejecucion),'%H:%i:%s'),f.idDetalle_ensamble,f.restantes,f.noperarios FROM detalle_ensamble f JOIN procesos p on f.Procesos_idproceso=p.idproceso JOIN estado e on f.estado_idestado=e.idestado where f.detalle_proyecto_idDetalle_proyecto=detalle ORDER BY f.Procesos_idproceso ASC;
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

SELECT p.nombre_cliente,p.nombre_proyecto,DATE_FORMAT(p.fecha_ingreso,'%d-%M-%Y') as fechaIngreso,DATE_FORMAT(p.fecha_entrega,'%d-%M-%Y')AS fechaEntrega,dp.canitadad_total,dp.tiempo_total,dp.Total_timepo_Unidad,DATE_FORMAT(p.entregaCircuitoFEoGF,'%d-%M-%Y') AS fecha1,DATE_FORMAT(p.entregaCOMCircuito,'%d-%M-%Y') AS fecha2,DATE_FORMAT(p.entregaPCBFEoGF,'%d-%M-%Y') AS fecha3,DATE_FORMAT(p.entregaPCBCom,'%d-%M-%Y') AS fecha4 FROM proyecto p JOIN detalle_proyecto dp ON p.numero_orden=dp.proyecto_numero_orden WHERE dp.idDetalle_proyecto=iddetalle;

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
SELECT d.idDetalle_proyecto,d.tipo_negocio_idtipo_negocio,d.negocio_idnegocio from detalle_proyecto d JOIN tipo_negocio t ON d.tipo_negocio_idtipo_negocio=t.idtipo_negocio where d.proyecto_numero_orden=orden and d.PNC=0;
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

SELECT dp.proyecto_numero_orden,dp.canitadad_total,p.nombre_proceso,en.noperarios,en.estado_idestado,pp.tipo_proyecto,t.nombre FROM detalle_ensamble en LEFT JOIN detalle_proyecto dp ON en.detalle_proyecto_idDetalle_proyecto=dp.idDetalle_proyecto JOIN procesos p ON en.Procesos_idproceso=p.idproceso JOIN proyecto pp ON dp.proyecto_numero_orden=pp.numero_orden JOIN tipo_negocio t ON dp.tipo_negocio_idtipo_negocio=t.idtipo_negocio WHERE  dp.negocio_idnegocio=3 AND pp.estado_idestado!=3 AND pp.eliminacion!=0 ORDER BY dp.proyecto_numero_orden,dp.tipo_negocio_idtipo_negocio;


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
UPDATE detalle_formato_estandar f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_formato_estandar f SET  f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_formato_estandar=id1;
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
UPDATE detalle_teclados f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_teclados=id ;
END IF;

IF id1 !='null' THEN
UPDATE detalle_teclados f SET f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_teclados=id1 ;
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
UPDATE detalle_ensamble f SET f.fecha_inicio=CURDATE(), f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.noperarios=oper WHERE f.idDetalle_ensamble=id;
END IF;

IF id1 !='null' THEN
UPDATE detalle_ensamble f SET  f.estado_idestado=4, f.hora_ejecucion=CURRENT_TIME,f.hora_terminacion=null,f.noperarios=oper WHERE f.idDetalle_ensamble=id1 ;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `PA_PausarTomaDeTiempoDeProcesos` (IN `orden` INT, IN `detalle` INT, IN `lector` INT, IN `busqueda` INT, IN `tiempo` VARCHAR(8), IN `cantidad` INT, IN `est` TINYINT(1), IN `res` INT(6))  NO SQL
BEGIN
DECLARE id int;
DECLARE cantidadp int;
IF est=2 THEN

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  
  UPDATE detalle_ensamble f SET  f.estado_idestado=est, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id ;
  
  END IF; 
 END IF;
END IF;

ELSE

IF busqueda=1 THEN

SET id=(SELECT f.idDetalle_formato_estandar from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_formato_estandar f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE,f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_formato_estandar=id ;

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.idDetalle_teclados from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
 
 UPDATE detalle_teclados f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE, f.tiempo_total_proceso=tiempo, f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_teclados=id ;
 
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.idDetalle_ensamble from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  
  UPDATE detalle_ensamble f SET  f.estado_idestado=est,f.fecha_fin=CURRENT_DATE, f.tiempo_total_por_proceso=tiempo,f.cantidad_terminada=cantidad,f.restantes=res,f.noperarios=0 WHERE f.idDetalle_ensamble=id;
  
  END IF; 
 END IF;
END IF;

END IF;

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

SELECT d.proyecto_numero_orden FROM detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;


else
 IF negocio=2 THEN

SELECT d.proyecto_numero_orden FROM detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;

 ELSE
  IF negocio=3 THEN

SELECT d.proyecto_numero_orden FROM detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto WHERE f.estado_idestado=4 GROUP BY d.proyecto_numero_orden;

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

IF busqueda=1 THEN

SET id=(SELECT f.cantidad_terminada from detalle_formato_estandar f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
SET oper=(SELECT f.noperarios FROM detalle_formato_estandar f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);

ELSE
 IF busqueda=2 THEN
 
 SET id=(SELECT f.cantidad_terminada from detalle_teclados f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
  SET oper=(SELECT f.noperarios FROM detalle_teclados f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
 ELSE
  IF busqueda=3 THEN
  
  SET id=(SELECT f.cantidad_terminada from detalle_ensamble f JOIN detalle_proyecto d on f.detalle_proyecto_idDetalle_proyecto=d.idDetalle_proyecto where d.proyecto_numero_orden=orden AND d.idDetalle_proyecto=detalle and f.Procesos_idproceso=lector and f.estado_idestado=4);
    SET oper=(SELECT f.noperarios FROM detalle_ensamble f WHERE f.detalle_proyecto_idDetalle_proyecto=detalle and f.Procesos_idproceso=lector);
  ELSE
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
  UPDATE `detalle_ensamble` SET `tiempo_por_unidad`= "00:00",`tiempo_total_por_proceso`="00:00",`cantidad_terminada`=0,`fecha_inicio`=null,`fecha_fin`=null,`estado_idestado`=1,`hora_ejecucion`=null,`hora_terminacion`=null,restantes=0 WHERE `idDetalle_ensamble`=detalle;
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
  `cantidad_terminada` varchar(6) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `detalle_proyecto_idDetalle_proyecto` int(11) NOT NULL,
  `Procesos_idproceso` tinyint(4) NOT NULL,
  `estado_idestado` tinyint(4) NOT NULL,
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_formato_estandar`
--

INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1, '13:11', '158:21', '12', '2018-06-12', '2018-06-12', 1, 1, 3, '14:06:47', '16:45:08', 0, 0),
(2, '00:32', '06:33', '12', '2018-06-13', '2018-06-13', 1, 2, 3, '12:25:34', '12:32:07', 0, 0),
(3, '15:58', '191:45', '12', '2018-06-14', '2018-06-14', 1, 3, 3, '12:14:48', '14:53:29', 0, 0),
(4, '06:07', '73:27', '12', '2018-06-14', '2018-06-14', 1, 4, 3, '15:15:42', '16:29:09', 0, 0),
(5, '00:54', '10:56', '12', '2018-06-15', '2018-06-15', 1, 5, 3, '06:23:48', '06:34:44', 0, 0),
(6, '09:24', '112:56', '12', '2018-06-15', '2018-06-15', 1, 6, 3, '09:29:00', '11:21:56', 0, 0),
(7, '01:01', '12:22', '12', '2018-06-18', '2018-06-18', 1, 7, 3, '09:49:44', '10:02:06', 0, 0),
(8, '03:00', '36:08', '12', '2018-06-18', '2018-06-18', 1, 8, 3, '10:14:10', '10:50:18', 0, 0),
(9, '02:07', '25:31', '12', '2018-06-18', '2018-06-18', 1, 10, 3, '10:53:44', '11:19:15', 0, 0),
(10, '00:06', '00:26', '4', '2018-06-13', '2018-06-13', 2, 1, 3, '15:31:01', '15:31:27', 0, 0),
(11, '06:16', '25:04', '4', '2018-06-13', '2018-06-13', 2, 3, 3, '14:36:03', '15:01:07', 0, 0),
(12, '05:04', '20:19', '4', '2018-06-13', '2018-06-13', 2, 4, 3, '15:31:39', '15:51:58', 0, 0),
(13, '00:16', '01:07', '4', '2018-06-13', '2018-06-13', 2, 5, 3, '16:08:02', '16:09:09', 0, 0),
(14, '00:29', '01:57', '4', '2018-06-14', '2018-06-14', 2, 6, 3, '14:49:16', '14:51:13', 0, 0),
(15, '05:50', '23:22', '4', '2018-06-14', '2018-06-14', 2, 7, 3, '15:27:13', '15:50:35', 0, 0),
(16, '00:25', '01:42', '4', '2018-06-14', '2018-06-14', 2, 8, 3, '16:03:01', '16:04:43', 0, 0),
(17, '01:18', '05:15', '4', '2018-06-15', '2018-06-15', 2, 10, 3, '06:46:20', '06:51:35', 0, 0),
(18, '00:11', '05:59', '30', '2018-06-13', '2018-06-13', 3, 1, 3, '11:07:16', '11:13:15', 0, 0),
(19, '00:56', '28:17', '30', '2018-06-14', '2018-06-14', 3, 3, 3, '08:13:51', '08:42:08', 0, 0),
(20, '00:56', '28:23', '30', '2018-06-14', '2018-06-14', 3, 4, 3, '10:22:57', '10:51:20', 0, 0),
(21, '00:05', '02:35', '30', '2018-06-14', '2018-06-14', 3, 5, 3, '15:01:40', '15:04:15', 0, 0),
(22, '00:55', '27:55', '30', '2018-06-15', '2018-06-15', 3, 6, 3, '08:30:49', '08:58:44', 0, 0),
(23, '00:39', '19:46', '30', '2018-06-15', '2018-06-15', 3, 7, 3, '10:01:08', '10:20:54', 0, 0),
(24, '00:58', '29:25', '30', '2018-06-15', '2018-06-15', 3, 8, 3, '10:21:36', '10:51:01', 0, 0),
(25, '00:49', '24:47', '30', '2018-06-18', '2018-06-18', 3, 10, 3, '08:07:59', '08:32:46', 0, 0),
(26, '00:12', '06:24', '30', '2018-06-13', '2018-06-13', 4, 1, 3, '11:07:05', '11:13:29', 0, 0),
(27, '01:06', '33:15', '30', '2018-06-14', '2018-06-14', 4, 3, 3, '07:11:30', '07:44:45', 0, 0),
(28, '01:06', '33:20', '30', '2018-06-14', '2018-06-14', 4, 4, 3, '07:48:06', '08:21:26', 0, 0),
(29, '00:06', '03:03', '30', '2018-06-14', '2018-06-14', 4, 5, 3, '09:25:12', '09:28:15', 0, 0),
(30, '00:03', '01:45', '30', '2018-06-14', '2018-06-14', 4, 6, 3, '14:50:05', '14:51:50', 0, 0),
(31, '00:47', '23:59', '30', '2018-06-14', '2018-06-14', 4, 7, 3, '15:26:59', '15:50:58', 0, 0),
(32, '00:03', '01:40', '30', '2018-06-14', '2018-06-14', 4, 8, 3, '16:03:17', '16:04:57', 0, 0),
(33, '02:34', '77:02', '30', '2018-06-18', '2018-06-18', 4, 10, 3, '09:48:57', '10:30:18', 0, 0),
(34, '02:48', '56:04', '20', '2018-06-12', '2018-06-12', 5, 1, 3, '15:42:33', '16:38:37', 0, 0),
(35, '11:44', '234:44', '20', '2018-06-13', '2018-06-13', 5, 2, 3, '12:40:43', '16:35:27', 0, 0),
(36, '02:25', '48:35', '20', '2018-06-15', '2018-06-15', 5, 3, 3, '10:38:09', '11:06:26', 0, 0),
(37, '00:01', '00:25', '20', '2018-06-18', '2018-06-18', 5, 4, 3, '06:24:48', '06:25:13', 0, 0),
(38, '01:03', '21:01', '20', '2018-06-18', '2018-06-18', 5, 5, 3, '07:59:34', '08:20:35', 0, 0),
(39, '06:58', '139:29', '20', '2018-06-18', '2018-06-19', 5, 6, 3, '14:05:35', '16:07:09', 0, 0),
(40, '00:00', '00:15', '20', '2018-06-20', '2018-06-20', 5, 7, 3, '09:38:16', '09:38:31', 0, 0),
(41, '00:43', '14:21', '20', '2018-06-20', '2018-06-20', 5, 8, 3, '09:59:31', '10:13:52', 0, 0),
(42, '00:31', '10:24', '20', '2018-06-20', '2018-06-20', 5, 10, 3, '10:47:31', '10:57:55', 0, 0),
(43, '03:41', '36:57', '10', '2018-06-12', '2018-06-12', 6, 1, 3, '16:02:57', '16:39:54', 0, 0),
(44, '04:15', '42:38', '10', '2018-06-13', '2018-06-13', 6, 2, 3, '11:48:54', '12:31:32', 0, 0),
(45, '03:09', '31:33', '10', '2018-06-14', '2018-06-14', 6, 3, 3, '09:43:23', '09:49:01', 0, 0),
(46, '03:29', '34:50', '10', '2018-06-14', '2018-06-14', 6, 4, 3, '10:23:13', '10:58:03', 0, 0),
(47, '01:38', '16:21', '10', '2018-06-14', '2018-06-14', 6, 5, 3, '14:25:33', '14:41:54', 0, 0),
(48, '06:15', '62:35', '10', '2018-06-15', '2018-06-15', 6, 6, 3, '09:27:07', '10:00:13', 0, 0),
(49, '01:46', '17:42', '10', '2018-06-15', '2018-06-15', 6, 7, 3, '10:39:58', '10:40:36', 0, 0),
(50, '02:44', '27:21', '10', '2018-06-15', '2018-06-15', 6, 8, 3, '10:41:17', '11:08:38', 0, 0),
(51, '02:22', '23:47', '10', '2018-06-18', '2018-06-18', 6, 10, 3, '08:34:27', '08:58:14', 0, 0),
(52, '04:31', '18:06', '4', '2018-06-12', '2018-06-12', 7, 1, 3, '11:50:00', '12:08:06', 0, 0),
(53, '52:16', '209:06', '4', '2018-06-12', '2018-06-12', 7, 2, 3, '13:06:08', '16:35:14', 0, 0),
(54, '00:03', '00:15', '4', '2018-06-13', '2018-06-13', 7, 3, 3, '11:40:46', '11:41:01', 0, 0),
(55, '19:27', '77:50', '4', '2018-06-13', '2018-06-13', 7, 4, 3, '11:02:56', '12:20:46', 0, 0),
(56, '14:31', '58:06', '4', '2018-06-13', '2018-06-13', 7, 5, 3, '11:04:46', '12:02:52', 0, 0),
(57, '29:25', '117:42', '4', '2018-06-13', '2018-06-13', 7, 6, 3, '13:53:18', '15:51:00', 0, 0),
(58, '02:20', '09:23', '4', '2018-06-14', '2018-06-14', 7, 7, 3, '08:50:23', '08:59:46', 0, 0),
(59, '02:06', '08:24', '4', '2018-06-14', '2018-06-14', 7, 8, 3, '09:36:07', '09:44:31', 0, 0),
(60, '03:09', '12:37', '4', '2018-06-14', '2018-06-14', 7, 10, 3, '10:16:50', '10:29:27', 0, 0),
(61, '00:00', '00:00', '0', NULL, NULL, 8, 1, 1, NULL, NULL, 0, 0),
(62, '00:00', '00:00', '0', NULL, NULL, 8, 2, 1, NULL, NULL, 0, 0),
(63, '00:00', '00:00', '0', NULL, NULL, 8, 3, 1, NULL, NULL, 0, 0),
(64, '00:00', '00:00', '0', NULL, NULL, 8, 4, 1, NULL, NULL, 0, 0),
(65, '00:00', '00:00', '0', NULL, NULL, 8, 5, 1, NULL, NULL, 0, 0),
(66, '00:00', '00:00', '0', NULL, NULL, 8, 6, 1, NULL, NULL, 0, 0),
(67, '00:00', '00:00', '0', NULL, NULL, 8, 7, 1, NULL, NULL, 0, 0),
(68, '00:00', '00:00', '0', NULL, NULL, 8, 8, 1, NULL, NULL, 0, 0),
(69, '00:00', '00:00', '0', NULL, NULL, 8, 10, 1, NULL, NULL, 0, 0),
(70, '05:03', '151:51', '30', '2018-06-14', '2018-06-14', 9, 1, 3, '14:17:13', '14:23:26', 0, 0),
(71, '00:36', '18:05', '30', '2018-06-18', '2018-06-18', 9, 3, 3, '08:33:57', '08:52:02', 0, 0),
(72, '03:12', '96:13', '30', '2018-06-18', '2018-06-18', 9, 4, 3, '13:23:25', '14:59:38', 0, 0),
(73, '00:24', '12:11', '30', '2018-06-18', '2018-06-18', 9, 5, 3, '15:31:14', '15:40:04', 0, 0),
(74, '03:43', '111:35', '30', '2018-06-19', '2018-06-19', 9, 6, 3, '10:05:57', '11:38:29', 0, 0),
(75, '01:16', '38:12', '30', '2018-06-19', '2018-06-19', 9, 7, 3, '13:16:00', '13:33:22', 0, 0),
(76, '00:33', '16:57', '30', '2018-06-19', '2018-06-19', 9, 8, 3, '13:38:33', '13:55:30', 0, 0),
(77, '05:27', '163:31', '30', '2018-06-20', '2018-06-20', 9, 10, 3, '09:36:16', '09:37:00', 0, 0),
(78, '05:22', '53:40', '10', '2018-06-12', '2018-06-12', 10, 1, 3, '15:45:21', '16:39:01', 0, 0),
(79, '23:33', '235:39', '10', '2018-06-13', '2018-06-13', 10, 2, 3, '12:40:24', '16:36:03', 0, 0),
(80, '00:00', '37:41', '10', '2018-06-15', '2018-06-15', 10, 3, 3, '12:18:41', '12:50:12', 0, 1),
(81, '00:03', '00:38', '10', '2018-06-18', '2018-06-18', 10, 4, 3, '06:26:29', '06:27:07', 0, 0),
(82, '03:54', '39:02', '10', '2018-06-18', '2018-06-18', 10, 5, 3, '08:10:05', '08:49:07', 0, 0),
(83, '08:33', '85:30', '10', '2018-06-18', '2018-06-18', 10, 6, 3, '14:01:52', '15:16:22', 0, 0),
(84, '02:19', '23:14', '10', '2018-06-19', '2018-06-19', 10, 7, 3, '06:12:31', '06:35:45', 0, 0),
(85, '04:36', '46:05', '10', '2018-06-19', '2018-06-19', 10, 8, 3, '06:37:22', '07:23:27', 0, 0),
(86, '02:20', '23:29', '10', '2018-06-19', '2018-06-19', 10, 10, 3, '07:25:08', '07:48:37', 0, 0),
(87, '00:01', '00:17', '16', '2018-06-13', '2018-06-13', 11, 1, 3, '11:06:34', '11:06:51', 0, 0),
(88, '00:01', '00:21', '16', '2018-06-13', '2018-06-13', 11, 3, 3, '11:25:06', '11:25:18', 0, 0),
(89, '01:08', '18:18', '16', '2018-06-13', '2018-06-13', 11, 4, 3, '11:17:22', '11:35:40', 0, 0),
(90, '00:04', '01:12', '16', '2018-06-13', '2018-06-13', 11, 5, 3, '11:38:21', '11:39:33', 0, 0),
(91, '02:09', '34:24', '16', '2018-06-13', '2018-06-13', 11, 6, 3, '13:52:54', '14:27:18', 0, 0),
(92, '00:10', '02:46', '16', '2018-06-13', '2018-06-13', 11, 7, 3, '14:45:13', '14:47:59', 0, 0),
(93, '00:06', '01:41', '16', '2018-06-13', '2018-06-13', 11, 8, 3, '14:48:44', '14:50:25', 0, 0),
(94, '00:19', '05:16', '16', '2018-06-13', '2018-06-13', 11, 9, 3, '15:51:44', '15:57:00', 0, 0),
(95, '00:31', '08:28', '16', '2018-06-13', '2018-06-13', 11, 10, 3, '16:05:37', '16:14:05', 0, 0),
(96, '00:10', '00:21', '2', '2018-06-13', '2018-06-13', 12, 1, 3, '11:15:44', '11:16:05', 0, 0),
(97, '00:06', '00:13', '2', '2018-06-13', '2018-06-13', 12, 3, 3, '11:28:32', '11:28:45', 0, 0),
(98, '00:16', '00:33', '2', '2018-06-13', '2018-06-13', 12, 4, 3, '12:21:25', '12:21:58', 0, 0),
(99, '00:10', '00:21', '2', '2018-06-13', '2018-06-13', 12, 5, 3, '12:26:10', '12:26:31', 0, 0),
(100, '30:09', '60:18', '2', '2018-06-13', '2018-06-13', 12, 6, 3, '13:27:30', '13:47:45', 0, 0),
(101, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 12, 7, 3, '12:28:32', '12:28:32', 0, 0),
(102, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 12, 8, 3, NULL, NULL, 0, 0),
(103, '31:00', '62:01', '2', '2018-06-13', '2018-06-13', 12, 9, 3, '16:20:48', '17:22:49', 0, 0),
(104, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 12, 10, 3, '12:06:34', '12:06:34', 0, 0),
(105, '00:08', '00:16', '2', '2018-06-13', '2018-06-13', 13, 1, 3, '11:10:20', '11:10:36', 0, 0),
(106, '00:14', '00:29', '2', '2018-06-13', '2018-06-13', 13, 3, 3, '11:26:17', '11:26:46', 0, 0),
(107, '00:15', '00:31', '2', '2018-06-13', '2018-06-13', 13, 4, 3, '12:23:52', '12:24:23', 0, 0),
(108, '00:05', '00:10', '2', '2018-06-13', '2018-06-13', 13, 5, 3, '12:26:56', '12:27:06', 0, 0),
(109, '46:21', '92:43', '2', '2018-06-13', '2018-06-13', 13, 6, 3, '11:33:34', '12:35:19', 0, 0),
(110, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 13, 7, 3, '17:27:30', '17:27:30', 0, 0),
(111, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 13, 8, 3, '17:27:30', '17:27:30', 0, 0),
(112, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 13, 9, 3, '17:27:30', '17:58:30', 0, 0),
(113, '00:00', '00:00', '2', '2018-06-13', '2018-06-13', 13, 10, 3, '17:27:30', '17:27:30', 0, 0),
(114, '00:01', '00:17', '14', '2018-06-13', '2018-06-13', 14, 1, 3, '11:15:06', '11:15:23', 0, 0),
(115, '04:19', '60:27', '14', '2018-06-13', '2018-06-13', 14, 3, 3, '11:29:30', '12:29:57', 0, 0),
(116, '00:01', '00:23', '14', '2018-06-13', '2018-06-13', 14, 4, 3, '12:33:12', '12:33:35', 0, 0),
(117, '00:02', '00:29', '14', '2018-06-13', '2018-06-13', 14, 5, 3, '12:31:08', '12:31:37', 0, 0),
(118, '03:20', '46:51', '14', '2018-06-13', '2018-06-13', 14, 6, 3, '11:43:59', '12:30:50', 0, 0),
(119, '00:00', '00:00', '14', '2018-06-13', '2018-06-13', 14, 7, 3, '15:53:23', '15:53:23', 0, 0),
(120, '00:00', '00:00', '14', '2018-06-13', '2018-06-13', 14, 8, 3, '15:53:23', '15:53:23', 0, 0),
(121, '00:00', '00:00', '14', '2018-06-13', '2018-06-13', 14, 9, 3, '15:53:23', '15:53:23', 0, 0),
(122, '00:46', '10:54', '14', '2018-06-13', '2018-06-13', 14, 10, 3, '15:53:23', '16:04:17', 0, 0),
(123, '00:23', '11:53', '30', '2018-06-13', '2018-06-13', 15, 1, 3, '11:20:35', '11:32:28', 0, 0),
(124, '00:34', '17:03', '30', '2018-06-14', '2018-06-14', 15, 3, 3, '10:43:39', '11:00:42', 0, 0),
(125, '01:03', '31:30', '30', '2018-06-14', '2018-06-14', 15, 4, 3, '13:22:53', '13:41:13', 0, 0),
(126, '00:10', '05:06', '30', '2018-06-14', '2018-06-14', 15, 5, 3, '15:06:44', '15:11:50', 0, 0),
(127, '02:11', '65:31', '30', '2018-06-15', '2018-06-15', 15, 6, 3, '08:17:21', '09:22:52', 0, 0),
(128, '00:38', '19:08', '30', '2018-06-15', '2018-06-15', 15, 7, 3, '10:01:21', '10:20:29', 0, 0),
(129, '00:58', '29:14', '30', '2018-06-15', '2018-06-15', 15, 8, 3, '10:21:25', '10:50:39', 0, 0),
(130, '00:08', '04:08', '30', '2018-06-18', '2018-06-18', 15, 10, 3, '07:21:39', '07:25:47', 0, 0),
(131, '02:03', '12:22', '6', '2018-06-14', '2018-06-14', 16, 1, 3, '06:31:46', '06:44:08', 0, 0),
(132, '54:38', '327:53', '6', '2018-06-14', '2018-06-14', 16, 2, 3, '06:47:34', '12:15:27', 0, 0),
(133, '04:22', '26:15', '6', '2018-06-14', '2018-06-14', 16, 3, 3, '14:30:27', '14:31:07', 0, 0),
(134, '08:55', '53:32', '6', '2018-06-14', '2018-06-14', 16, 4, 3, '14:39:36', '15:33:08', 0, 0),
(135, '02:14', '13:27', '6', '2018-06-14', '2018-06-14', 16, 5, 3, '15:40:46', '15:54:13', 0, 0),
(136, '00:05', '00:30', '6', '2018-06-15', '2018-06-15', 16, 6, 3, '08:14:35', '08:15:05', 0, 0),
(137, '03:59', '23:58', '6', '2018-06-15', '2018-06-15', 16, 7, 3, '07:45:29', '08:09:27', 0, 0),
(138, '00:20', '02:02', '6', '2018-06-15', '2018-06-15', 16, 8, 3, '08:17:02', '08:18:46', 0, 0),
(139, '03:58', '23:50', '6', '2018-06-15', '2018-06-15', 16, 9, 3, '08:41:54', '09:05:44', 0, 0),
(140, '01:19', '07:59', '6', '2018-06-15', '2018-06-15', 16, 10, 3, '08:57:54', '09:05:53', 0, 0),
(141, '10:54', '218:19', '20', '2018-06-14', '2018-06-14', 17, 1, 3, '06:57:06', '10:35:25', 0, 0),
(142, '10:45', '215:02', '20', '2018-06-14', '2018-06-15', 17, 2, 3, '08:20:17', '09:36:48', 0, 0),
(143, '05:05', '101:51', '20', '2018-06-18', '2018-06-18', 17, 3, 3, '10:08:20', '11:50:11', 0, 0),
(144, '13:41', '273:46', '20', '2018-06-18', '2018-06-19', 17, 4, 3, '10:09:08', '13:56:56', 0, 0),
(145, '01:12', '24:11', '20', '2018-06-19', '2018-06-19', 17, 5, 3, '14:22:11', '14:46:22', 0, 0),
(146, '00:00', '60:45', '20', '2018-06-19', '2018-06-19', 17, 6, 3, '15:29:19', '16:27:19', 0, 0),
(147, '01:34', '31:26', '20', '2018-06-20', '2018-06-20', 17, 7, 3, '11:33:19', '12:04:45', 0, 0),
(148, '00:48', '16:10', '20', '2018-06-20', '2018-06-20', 17, 8, 3, '14:00:11', '14:16:21', 0, 0),
(149, '01:40', '33:37', '20', '2018-06-20', '2018-06-20', 17, 10, 3, '15:39:56', '16:13:33', 0, 0),
(150, '00:00', '00:20', '40', '2018-06-13', '2018-06-13', 18, 1, 3, '11:05:44', '11:06:04', 0, 0),
(151, '03:25', '136:40', '40', '2018-06-14', '2018-06-14', 18, 2, 3, '12:14:19', '14:30:59', 0, 0),
(152, '00:00', '00:08', '40', '2018-06-18', '2018-06-18', 18, 3, 3, '06:28:43', '06:28:51', 0, 0),
(153, '00:00', '00:29', '40', '2018-06-18', '2018-06-18', 18, 4, 3, '06:28:02', '06:28:31', 0, 0),
(154, '03:46', '151:01', '40', '2018-06-18', '2018-06-18', 18, 5, 3, '10:12:03', '12:43:04', 0, 0),
(155, '03:50', '153:48', '40', '2018-06-19', '2018-06-19', 18, 6, 3, '13:01:06', '14:02:14', 0, 0),
(156, '00:21', '14:17', '40', '2018-06-19', '2018-06-19', 18, 7, 3, '14:14:24', '14:28:41', 0, 0),
(157, '00:10', '06:50', '40', '2018-06-19', '2018-06-19', 18, 8, 3, '14:52:16', '14:59:06', 0, 0),
(158, '00:34', '23:07', '40', '2018-06-20', '2018-06-20', 18, 10, 3, '06:53:30', '07:16:37', 0, 0),
(159, '01:01', '46:27', '45', '2018-06-15', '2018-06-15', 19, 1, 3, '07:39:09', '08:25:36', 0, 0),
(160, '05:56', '267:28', '45', '2018-06-18', '2018-06-18', 19, 2, 3, '06:24:26', '10:51:54', 0, 0),
(161, '03:28', '156:44', '45', '2018-06-18', '2018-06-18', 19, 3, 3, '12:46:47', '15:23:31', 0, 0),
(162, '02:26', '110:07', '45', '2018-06-18', '2018-06-18', 19, 4, 3, '14:26:54', '16:17:01', 0, 0),
(163, '01:25', '63:48', '45', '2018-06-19', '2018-06-19', 19, 5, 3, '06:33:28', '07:14:41', 0, 0),
(164, '02:41', '121:28', '45', '2018-06-19', '2018-06-19', 19, 6, 3, '14:01:56', '14:26:19', 0, 0),
(165, '00:19', '14:29', '45', '2018-06-19', '2018-06-19', 19, 7, 3, '14:14:44', '14:29:13', 0, 0),
(166, '00:00', '10:15', '45', '2018-06-19', '2018-06-19', 19, 8, 3, '15:16:25', '15:26:11', 0, 0),
(167, '00:37', '28:03', '45', '2018-06-20', '2018-06-20', 19, 10, 3, '06:53:45', '07:21:48', 0, 0),
(168, '00:00', '00:00', '0', NULL, NULL, 20, 1, 1, NULL, NULL, 0, 0),
(169, '00:00', '00:00', '0', NULL, NULL, 20, 2, 1, NULL, NULL, 0, 0),
(170, '00:00', '00:00', '0', NULL, NULL, 20, 3, 1, NULL, NULL, 0, 0),
(171, '00:00', '00:00', '0', NULL, NULL, 20, 4, 1, NULL, NULL, 0, 0),
(172, '00:00', '00:00', '0', NULL, NULL, 20, 5, 1, NULL, NULL, 0, 0),
(173, '00:00', '00:00', '0', NULL, NULL, 20, 7, 1, NULL, NULL, 0, 0),
(174, '00:00', '00:00', '0', NULL, NULL, 20, 8, 1, NULL, NULL, 0, 0),
(175, '00:00', '00:00', '0', NULL, NULL, 20, 10, 1, NULL, NULL, 0, 0),
(176, '00:00', '00:00', '6', '2018-06-20', '2018-06-20', 21, 1, 3, '11:16:24', '11:16:33', 0, 0),
(177, '09:02', '54:13', '6', '2018-06-20', '2018-06-20', 21, 2, 3, '12:07:17', '13:01:30', 0, 0),
(178, '03:24', '20:25', '6', '2018-06-20', '2018-06-20', 21, 3, 3, '15:09:35', '15:16:39', 0, 0),
(179, '08:34', '51:29', '6', '2018-06-20', '2018-06-20', 21, 4, 3, '15:28:55', '16:20:24', 0, 0),
(180, '03:04', '18:24', '6', '2018-06-21', '2018-06-21', 21, 5, 3, '06:27:25', '06:45:49', 0, 0),
(181, '16:46', '100:37', '6', '2018-06-21', '2018-06-22', 21, 6, 3, '06:23:21', '06:24:02', 0, 0),
(182, '03:37', '21:44', '6', '2018-06-21', '2018-06-21', 21, 7, 3, '15:41:37', '16:03:21', 0, 0),
(183, '00:09', '00:58', '6', '2018-06-21', '2018-06-21', 21, 8, 3, '16:03:55', '16:04:53', 0, 0),
(184, '00:56', '05:40', '6', '2018-06-22', '2018-06-22', 21, 9, 3, '08:12:38', '08:18:18', 0, 0),
(185, '01:05', '06:32', '6', '2018-06-22', '2018-06-22', 21, 10, 3, '08:33:10', '08:39:42', 0, 0),
(186, '00:19', '17:12', '52', '2018-06-20', '2018-06-20', 22, 1, 3, '14:10:05', '14:27:06', 0, 0),
(187, '00:25', '21:50', '52', '2018-06-20', '2018-06-20', 22, 3, 3, '15:23:06', '15:44:56', 0, 0),
(188, '00:00', '60:37', '52', '2018-06-20', '2018-06-20', 22, 4, 3, '07:46:11', '08:46:11', 0, 0),
(189, '00:06', '05:17', '52', '2018-06-21', '2018-06-21', 22, 5, 3, '08:53:28', '08:58:45', 0, 0),
(190, '01:19', '68:43', '52', '2018-06-21', '2018-06-21', 22, 6, 3, '09:33:02', '10:41:45', 0, 0),
(191, '00:11', '10:02', '52', '2018-06-21', '2018-06-21', 22, 7, 3, '11:06:02', '11:16:04', 0, 0),
(192, '00:07', '06:43', '52', '2018-06-21', '2018-06-21', 22, 8, 3, '11:18:17', '11:25:00', 0, 0),
(193, '03:22', '175:05', '52', '2018-06-21', '2018-06-21', 22, 10, 3, '11:24:30', '14:19:35', 0, 0),
(194, '11:51', '47:25', '4', '2018-06-14', '2018-06-14', 23, 1, 3, '15:25:11', '16:12:36', 0, 0),
(195, '60:27', '241:48', '4', '2018-06-15', '2018-06-15', 23, 2, 3, '06:15:31', '10:17:19', 0, 0),
(196, '00:05', '00:22', '4', '2018-06-18', '2018-06-18', 23, 3, 3, '06:20:47', '06:21:09', 0, 0),
(197, '33:56', '135:46', '4', '2018-06-18', '2018-06-18', 23, 4, 3, '08:49:40', '09:22:58', 0, 0),
(198, '36:55', '147:40', '4', '2018-06-18', '2018-06-18', 23, 5, 3, '10:16:22', '12:44:02', 0, 0),
(199, '29:23', '117:34', '4', '2018-06-18', '2018-06-18', 23, 6, 3, '14:10:21', '16:07:55', 0, 0),
(200, '05:50', '23:20', '4', '2018-06-19', '2018-06-19', 23, 7, 3, '06:12:40', '06:36:00', 0, 0),
(201, '11:32', '46:08', '4', '2018-06-19', '2018-06-19', 23, 8, 3, '06:37:35', '07:23:43', 0, 0),
(202, '05:48', '23:15', '4', '2018-06-19', '2018-06-19', 23, 10, 3, '07:24:53', '07:48:08', 0, 0),
(203, '11:51', '47:25', '4', '2018-06-14', '2018-06-14', 24, 1, 3, '15:25:22', '16:12:47', 0, 0),
(204, '60:27', '241:51', '4', '2018-06-15', '2018-06-15', 24, 2, 3, '06:15:17', '10:17:08', 0, 0),
(205, '00:04', '00:18', '4', '2018-06-18', '2018-06-18', 24, 3, 3, '06:21:36', '06:21:54', 0, 0),
(206, '00:03', '00:15', '4', '2018-06-18', '2018-06-18', 24, 4, 3, '06:22:10', '06:22:25', 0, 0),
(207, '06:31', '26:07', '4', '2018-06-18', '2018-06-18', 24, 5, 3, '06:17:22', '06:43:29', 0, 0),
(208, '07:38', '30:33', '4', '2018-06-18', '2018-06-18', 24, 6, 3, '10:45:46', '11:16:19', 0, 0),
(209, '01:52', '07:31', '4', '2018-06-18', '2018-06-18', 24, 7, 3, '11:37:59', '11:45:30', 0, 0),
(210, '13:07', '52:28', '4', '2018-06-18', '2018-06-18', 24, 8, 3, '11:52:51', '12:45:19', 0, 0),
(211, '00:06', '00:26', '4', '2018-06-18', '2018-06-18', 24, 10, 3, '12:46:58', '12:47:24', 0, 0),
(212, '02:28', '24:46', '10', '2018-06-19', '2018-06-19', 25, 1, 3, '07:54:04', '08:18:50', 0, 0),
(213, '25:40', '256:48', '10', '2018-06-19', '2018-06-19', 25, 2, 3, '10:35:44', '14:52:32', 0, 0),
(214, '01:21', '13:32', '10', '2018-06-19', '2018-06-19', 25, 3, 3, '15:18:40', '15:32:12', 0, 0),
(215, '00:15', '02:34', '10', '2018-06-20', '2018-06-20', 25, 4, 3, '06:54:32', '06:57:06', 0, 0),
(216, '00:00', '10:42', '10', '2018-06-20', '2018-06-20', 25, 5, 3, '09:15:00', '09:25:28', 0, 0),
(217, '08:09', '81:35', '10', '2018-06-20', '2018-06-20', 25, 6, 3, '10:11:08', '11:32:43', 0, 0),
(218, '03:07', '31:13', '10', '2018-06-20', '2018-06-20', 25, 7, 3, '11:33:48', '12:05:01', 0, 0),
(219, '01:33', '15:38', '10', '2018-06-20', '2018-06-20', 25, 8, 3, '14:00:30', '14:16:08', 0, 0),
(220, '04:29', '44:50', '10', '2018-06-20', '2018-06-20', 25, 10, 3, '14:16:47', '15:01:37', 0, 0),
(221, '03:56', '11:49', '3', '2018-06-15', '2018-06-15', 26, 1, 3, '09:53:07', '10:04:56', 0, 0),
(222, '04:44', '14:13', '3', '2018-06-15', '2018-06-18', 26, 3, 3, '09:34:06', '09:42:28', 0, 0),
(223, '00:00', '16:11', '3', '2018-06-15', '2018-06-15', 26, 4, 3, '09:55:00', '10:11:00', 0, 0),
(224, '00:00', '00:00', '3', '2018-06-18', '2018-06-18', 26, 5, 3, '12:06:00', '12:05:05', 0, 0),
(225, '17:09', '51:28', '3', '2018-06-18', '2018-06-19', 26, 6, 3, '11:07:33', '11:46:18', 0, 0),
(226, '01:38', '04:54', '3', '2018-06-19', '2018-06-19', 26, 7, 3, '11:28:02', '11:32:56', 0, 0),
(227, '00:37', '01:52', '3', '2018-06-19', '2018-06-19', 26, 8, 3, '12:11:17', '12:13:09', 0, 0),
(228, '04:02', '12:08', '3', '2018-06-19', '2018-06-19', 26, 10, 3, '12:14:03', '12:26:11', 0, 0),
(229, '00:00', '20:35', '10', '2018-06-20', '2018-06-20', 27, 1, 3, '06:51:42', '07:12:17', 0, 0),
(230, '05:20', '53:28', '10', '2018-06-20', '2018-06-20', 27, 2, 3, '12:07:27', '13:00:55', 0, 0),
(231, '06:55', '69:16', '10', '2018-06-20', '2018-06-20', 27, 3, 3, '15:16:56', '16:08:01', 0, 0),
(232, '00:00', '35:20', '10', '2018-06-20', '2018-06-20', 27, 4, 3, '15:57:56', '16:33:16', 0, 0),
(233, '01:32', '15:29', '10', '2018-06-21', '2018-06-21', 27, 5, 3, '07:34:58', '07:50:27', 0, 0),
(234, '00:00', '70:04', '10', '2018-06-21', '2018-06-21', 27, 6, 3, '10:34:10', '11:44:00', 0, 0),
(235, '01:00', '10:09', '10', '2018-06-21', '2018-06-21', 27, 7, 3, '11:06:20', '11:16:29', 0, 0),
(236, '00:28', '04:41', '10', '2018-06-21', '2018-06-21', 27, 8, 3, '11:17:53', '11:22:34', 0, 0),
(237, '01:48', '18:04', '10', '2018-06-21', '2018-06-21', 27, 10, 3, '11:22:47', '11:40:51', 0, 0),
(238, '03:44', '37:20', '10', '2018-06-19', '2018-06-19', 28, 1, 3, '07:18:30', '07:55:50', 0, 0),
(239, '18:35', '185:55', '10', '2018-06-19', '2018-06-19', 28, 2, 3, '07:38:11', '10:44:06', 0, 0),
(240, '03:56', '39:23', '10', '2018-06-19', '2018-06-19', 28, 3, 3, '10:45:18', '11:24:41', 0, 0),
(241, '07:46', '77:44', '10', '2018-06-19', '2018-06-19', 28, 4, 3, '13:57:18', '15:15:02', 0, 0),
(242, '14:42', '147:06', '10', '2018-06-20', '2018-06-20', 28, 5, 3, '09:34:17', '09:34:47', 0, 0),
(243, '01:56', '19:26', '10', '2018-06-20', '2018-06-20', 28, 6, 3, '09:40:50', '10:00:16', 0, 0),
(244, '00:50', '08:25', '10', '2018-06-20', '2018-06-21', 28, 7, 3, '08:00:26', '08:02:54', 0, 0),
(245, '00:57', '09:35', '10', '2018-06-20', '2018-06-21', 28, 8, 3, '08:04:11', '08:06:24', 0, 0),
(246, '37:56', '379:21', '10', '2018-06-20', '2018-06-21', 28, 10, 3, '08:13:19', '14:22:12', 0, 0),
(247, '00:00', '00:00', '10', '2018-06-20', '2018-06-20', 29, 1, 3, '06:11:00', '06:11:12', 0, 0),
(248, '29:43', '297:10', '10', '2018-06-21', '2018-06-21', 29, 2, 3, '06:53:00', '11:50:10', 0, 0),
(249, '08:09', '81:37', '10', '2018-06-21', '2018-06-21', 29, 3, 3, '12:48:13', '14:09:50', 0, 0),
(250, '09:58', '99:41', '10', '2018-06-21', '2018-06-21', 29, 4, 3, '14:16:00', '15:55:41', 0, 0),
(251, '02:14', '22:26', '10', '2018-06-22', '2018-06-22', 29, 5, 3, '06:26:46', '06:49:12', 0, 0),
(252, '00:00', '45:38', '10', '2018-06-22', '2018-06-22', 29, 6, 3, '09:55:38', '10:30:15', 0, 0),
(253, '00:47', '07:58', '10', '2018-06-22', '2018-06-22', 29, 7, 3, '10:03:04', '10:11:02', 0, 0),
(254, '01:04', '10:43', '10', '2018-06-22', '2018-06-22', 29, 8, 3, '11:42:48', '11:53:31', 0, 0),
(255, '01:54', '19:07', '10', '2018-06-22', '2018-06-22', 29, 10, 3, '15:32:54', '15:51:23', 0, 0),
(256, '01:52', '09:22', '5', '2018-06-18', '2018-06-18', 30, 1, 3, '13:39:05', '13:48:27', 0, 0),
(257, '33:52', '169:21', '5', '2018-06-18', '2018-06-19', 30, 2, 3, '06:05:26', '06:30:23', 0, 0),
(258, '02:33', '12:46', '5', '2018-06-19', '2018-06-19', 30, 3, 3, '07:57:16', '08:10:02', 0, 0),
(259, '04:29', '22:26', '5', '2018-06-19', '2018-06-19', 30, 4, 3, '10:04:05', '10:04:22', 0, 0),
(260, '02:11', '10:59', '5', '2018-06-19', '2018-06-19', 30, 5, 3, '09:41:40', '09:52:39', 0, 0),
(261, '09:12', '46:00', '5', '2018-06-19', '2018-06-19', 30, 6, 3, '10:03:15', '10:49:15', 0, 0),
(262, '01:03', '05:19', '5', '2018-06-19', '2018-06-19', 30, 7, 3, '11:00:01', '11:05:20', 0, 0),
(263, '00:30', '02:34', '5', '2018-06-19', '2018-06-19', 30, 8, 3, '11:12:05', '11:14:39', 0, 0),
(264, '00:06', '00:32', '5', '2018-06-19', '2018-06-19', 30, 10, 3, '11:56:53', '11:57:25', 0, 0),
(265, '03:21', '33:38', '10', '2018-06-21', '2018-06-21', 31, 1, 3, '06:59:45', '07:33:23', 0, 0),
(266, '71:50', '718:29', '10', '2018-06-21', '2018-06-22', 31, 2, 3, '06:25:18', '09:42:35', 0, 0),
(267, '22:59', '229:51', '10', '2018-06-22', '2018-06-22', 31, 3, 3, '10:24:53', '14:14:44', 0, 0),
(268, '46:24', '464:08', '10', '2018-06-22', '2018-06-25', 31, 4, 3, '06:21:26', '12:00:12', 0, 0),
(269, '13:46', '137:40', '10', '2018-06-25', '2018-06-25', 31, 5, 3, '12:01:22', '12:01:34', 0, 0),
(270, '18:36', '186:02', '10', '2018-06-25', '2018-06-25', 31, 6, 3, '08:34:27', '11:40:29', 0, 0),
(271, '02:57', '29:30', '10', '2018-06-25', '2018-06-25', 31, 7, 3, '14:02:47', '14:32:17', 0, 0),
(272, '06:18', '63:02', '10', '2018-06-25', '2018-06-26', 31, 8, 3, '06:47:35', '07:29:29', 0, 0),
(273, '01:15', '12:35', '10', '2018-06-26', '2018-06-26', 31, 10, 3, '09:55:43', '10:08:18', 0, 0),
(274, '08:48', '88:03', '10', '2018-06-19', '2018-06-19', 32, 1, 3, '09:26:28', '10:24:53', 0, 0),
(275, '25:39', '256:37', '10', '2018-06-19', '2018-06-19', 32, 2, 3, '10:35:31', '14:52:08', 0, 0),
(276, '05:53', '58:53', '10', '2018-06-19', '2018-06-19', 32, 3, 3, '15:55:02', '16:53:55', 0, 0),
(277, '00:09', '01:34', '10', '2018-06-20', '2018-06-20', 32, 4, 3, '06:55:08', '06:56:42', 0, 0),
(278, '05:41', '56:51', '10', '2018-06-20', '2018-06-20', 32, 5, 3, '09:27:33', '10:24:24', 0, 0),
(279, '13:14', '132:22', '10', '2018-06-20', '2018-06-20', 32, 6, 3, '13:06:26', '14:45:19', 0, 0),
(280, '00:14', '02:29', '10', '2018-06-21', '2018-06-21', 32, 7, 3, '06:27:39', '06:30:08', 0, 0),
(281, '01:49', '18:11', '10', '2018-06-21', '2018-06-21', 32, 8, 3, '06:30:50', '06:49:01', 0, 0),
(282, '00:59', '09:50', '10', '2018-06-21', '2018-06-21', 32, 10, 3, '08:25:58', '08:35:48', 0, 0),
(283, '00:00', '00:00', '0', NULL, NULL, 33, 1, 1, NULL, NULL, 0, 0),
(284, '00:00', '00:00', '0', NULL, NULL, 33, 2, 1, NULL, NULL, 0, 0),
(285, '00:00', '00:00', '0', NULL, NULL, 33, 3, 1, NULL, NULL, 0, 0),
(286, '00:00', '00:00', '0', NULL, NULL, 33, 4, 1, NULL, NULL, 0, 0),
(287, '00:00', '00:00', '0', NULL, NULL, 33, 5, 1, NULL, NULL, 0, 0),
(288, '00:00', '00:00', '0', NULL, NULL, 33, 6, 1, NULL, NULL, 0, 0),
(289, '00:00', '00:00', '0', NULL, NULL, 33, 7, 1, NULL, NULL, 0, 0),
(290, '00:00', '00:00', '0', NULL, NULL, 33, 8, 1, NULL, NULL, 0, 0),
(291, '00:00', '00:00', '0', NULL, NULL, 33, 10, 1, NULL, NULL, 0, 0),
(292, '03:06', '31:01', '10', '2018-06-20', '2018-06-20', 34, 1, 3, '15:38:31', '16:09:32', 0, 0),
(293, '11:29', '114:50', '10', '2018-06-22', '2018-06-25', 34, 2, 3, '06:23:47', '06:39:59', 0, 0),
(294, '10:48', '108:01', '10', '2018-06-25', '2018-06-25', 34, 3, 3, '08:24:46', '10:12:47', 0, 0),
(295, '09:18', '93:05', '10', '2018-06-25', '2018-06-25', 34, 4, 3, '10:16:55', '11:50:00', 0, 0),
(296, '02:55', '29:13', '10', '2018-06-25', '2018-06-25', 34, 5, 3, '11:58:43', '12:27:56', 0, 0),
(297, '10:34', '105:49', '10', '2018-06-25', '2018-06-26', 34, 6, 3, '06:15:03', '06:48:33', 0, 0),
(298, '01:29', '14:59', '10', '2018-06-26', '2018-06-26', 34, 7, 3, '09:18:20', '09:24:05', 0, 0),
(299, '00:38', '06:22', '10', '2018-06-26', '2018-06-26', 34, 8, 3, '11:01:58', '11:08:20', 0, 0),
(300, '01:05', '10:58', '10', '2018-06-26', '2018-06-26', 34, 10, 3, '11:08:32', '11:19:30', 0, 0),
(301, '08:14', '82:21', '10', '2018-06-21', '2018-06-21', 35, 1, 3, '09:38:39', '11:01:00', 0, 0),
(302, '30:42', '307:07', '10', '2018-06-22', '2018-06-22', 35, 2, 3, '06:21:24', '11:28:31', 0, 0),
(303, '08:43', '87:10', '10', '2018-06-25', '2018-06-26', 35, 3, 3, '08:14:37', '09:05:52', 0, 0),
(304, '24:30', '245:04', '10', '2018-06-26', '2018-06-26', 35, 4, 3, '14:22:29', '14:23:18', 0, 0),
(305, '07:25', '74:12', '10', '2018-06-26', '2018-06-26', 35, 5, 3, '13:24:59', '14:32:55', 0, 0),
(306, '14:07', '141:11', '10', '2018-06-26', '2018-06-27', 35, 6, 3, '07:23:57', '07:55:19', 0, 0),
(307, '01:25', '14:17', '10', '2018-06-27', '2018-06-27', 35, 7, 3, '10:34:14', '10:48:31', 0, 0),
(308, '05:58', '59:46', '10', '2018-06-27', '2018-06-27', 35, 8, 3, '10:56:45', '11:56:31', 0, 0),
(309, '04:42', '47:08', '10', '2018-06-27', '2018-06-27', 35, 10, 3, '13:25:13', '14:12:21', 0, 0),
(310, '02:37', '65:47', '25', '2018-06-20', '2018-06-20', 36, 1, 3, '09:08:06', '09:53:14', 0, 0),
(311, '00:00', '185:32', '25', '2018-06-20', '2018-06-20', 36, 2, 3, '07:36:52', '08:31:52', 0, 0),
(312, '02:42', '67:38', '25', '2018-06-21', '2018-06-21', 36, 3, 3, '07:53:39', '09:01:17', 0, 0),
(313, '06:21', '159:01', '25', '2018-06-21', '2018-06-21', 36, 4, 3, '10:17:55', '12:56:56', 0, 0),
(314, '00:11', '04:43', '25', '2018-06-21', '2018-06-21', 36, 5, 3, '14:12:12', '14:16:55', 0, 0),
(315, '04:09', '104:07', '25', '2018-06-22', '2018-06-22', 36, 6, 3, '06:38:23', '08:22:30', 0, 0),
(316, '00:32', '13:32', '25', '2018-06-22', '2018-06-22', 36, 7, 3, '09:24:08', '09:37:40', 0, 0),
(317, '01:27', '36:29', '25', '2018-06-22', '2018-06-22', 36, 8, 3, '10:14:51', '10:51:20', 0, 0),
(318, '02:53', '72:25', '25', '2018-06-22', '2018-06-25', 36, 10, 3, '15:58:05', '15:58:15', 0, 0),
(319, '00:33', '05:39', '10', '2018-06-20', '2018-06-20', 37, 1, 3, '10:13:17', '10:18:56', 0, 0),
(320, '01:25', '14:13', '10', '2018-06-20', '2018-06-20', 37, 3, 3, '11:00:05', '11:14:18', 0, 0),
(321, '08:07', '81:14', '10', '2018-06-20', '2018-06-20', 37, 4, 3, '12:38:48', '14:00:02', 0, 0),
(322, '00:09', '01:36', '10', '2018-06-20', '2018-06-20', 37, 5, 3, '13:54:50', '13:56:26', 0, 0),
(323, '03:50', '38:29', '10', '2018-06-20', '2018-06-20', 37, 6, 3, '14:53:15', '15:31:44', 0, 0),
(324, '00:41', '06:53', '10', '2018-06-21', '2018-06-21', 37, 7, 3, '06:57:39', '07:04:32', 0, 0),
(325, '00:14', '02:25', '10', '2018-06-21', '2018-06-21', 37, 8, 3, '07:06:45', '07:09:10', 0, 0),
(326, '01:42', '17:00', '10', '2018-06-21', '2018-06-21', 37, 10, 3, '07:09:55', '07:26:55', 0, 0),
(327, '01:14', '12:23', '10', '2018-06-18', '2018-06-18', 38, 1, 3, '17:09:22', '17:21:45', 0, 0),
(328, '01:34', '15:47', '10', '2018-06-19', '2018-06-19', 38, 3, 3, '10:21:12', '10:36:59', 0, 0),
(329, '07:45', '77:36', '10', '2018-06-19', '2018-06-19', 38, 4, 3, '13:57:53', '15:15:29', 0, 0),
(330, '00:09', '01:32', '10', '2018-06-19', '2018-06-19', 38, 5, 3, '15:31:02', '15:32:34', 0, 0),
(331, '07:56', '79:24', '10', '2018-06-20', '2018-06-20', 38, 6, 3, '06:55:41', '08:15:05', 0, 0),
(332, '00:01', '00:18', '10', '2018-06-20', '2018-06-20', 38, 7, 3, '09:38:46', '09:39:04', 0, 0),
(333, '00:09', '01:37', '10', '2018-06-20', '2018-06-20', 38, 8, 3, '09:49:59', '09:51:36', 0, 0),
(334, '00:15', '02:36', '10', '2018-06-20', '2018-06-20', 38, 10, 3, '10:17:03', '10:19:39', 0, 0),
(335, '01:58', '19:45', '10', '2018-06-18', '2018-06-18', 39, 1, 3, '17:20:40', '17:40:25', 0, 0),
(336, '01:54', '19:01', '10', '2018-06-19', '2018-06-19', 39, 3, 3, '10:52:12', '10:55:40', 0, 0),
(337, '07:49', '78:19', '10', '2018-06-19', '2018-06-19', 39, 4, 3, '13:57:37', '15:15:56', 0, 0),
(338, '00:08', '01:25', '10', '2018-06-19', '2018-06-19', 39, 5, 3, '15:28:13', '15:29:38', 0, 0),
(339, '16:09', '161:33', '10', '2018-06-20', '2018-06-20', 39, 6, 3, '06:57:48', '09:39:16', 0, 0),
(340, '00:01', '00:11', '10', '2018-06-20', '2018-06-20', 39, 7, 3, '09:39:21', '09:39:32', 0, 0),
(341, '00:19', '03:15', '10', '2018-06-20', '2018-06-20', 39, 8, 3, '09:53:58', '09:57:13', 0, 0),
(342, '10:56', '109:28', '10', '2018-06-20', '2018-06-20', 39, 10, 3, '14:24:23', '16:13:51', 0, 0),
(343, '01:12', '121:36', '100', '2018-06-19', '2018-06-19', 40, 1, 3, '14:09:55', '15:01:41', 0, 0),
(344, '01:21', '136:14', '100', '2018-06-20', '2018-06-20', 40, 3, 3, '09:36:20', '09:36:55', 0, 0),
(345, '03:16', '328:08', '100', '2018-06-20', '2018-06-20', 40, 4, 3, '14:36:08', '16:05:18', 0, 0),
(346, '00:14', '24:06', '100', '2018-06-21', '2018-06-21', 40, 5, 3, '06:29:01', '06:53:07', 0, 0),
(347, '01:26', '143:47', '100', '2018-06-21', '2018-06-21', 40, 6, 3, '09:28:52', '09:53:30', 0, 0),
(348, '00:17', '29:37', '100', '2018-06-21', '2018-06-21', 40, 7, 3, '09:55:18', '10:24:55', 0, 0),
(349, '00:12', '21:22', '100', '2018-06-21', '2018-06-21', 40, 8, 3, '10:25:11', '10:46:33', 0, 0),
(350, '00:31', '52:57', '100', '2018-06-21', '2018-06-21', 40, 10, 3, '14:42:55', '15:35:52', 0, 0),
(351, '07:16', '43:38', '6', '2018-06-18', '2018-06-18', 41, 1, 3, '14:08:06', '14:51:44', 0, 0),
(352, '29:09', '174:54', '6', '2018-06-18', '2018-06-19', 41, 2, 3, '06:05:37', '07:36:33', 0, 0),
(353, '05:51', '35:08', '6', '2018-06-19', '2018-06-19', 41, 3, 3, '09:39:59', '10:15:07', 0, 0),
(354, '00:47', '04:44', '6', '2018-06-19', '2018-06-19', 41, 4, 3, '11:15:37', '11:20:21', 0, 0),
(355, '27:48', '166:53', '6', '2018-06-19', '2018-06-19', 41, 5, 3, '11:36:06', '14:22:59', 0, 0),
(356, '10:16', '61:41', '6', '2018-06-19', '2018-06-19', 41, 6, 3, '13:28:04', '14:29:45', 0, 0),
(357, '01:17', '07:44', '6', '2018-06-19', '2018-06-19', 41, 7, 3, '14:36:06', '14:43:50', 0, 0),
(358, '04:13', '25:19', '6', '2018-06-19', '2018-06-19', 41, 8, 3, '14:46:17', '15:11:36', 0, 0),
(359, '00:04', '00:26', '6', '2018-06-20', '2018-06-20', 41, 10, 3, '07:04:11', '07:04:37', 0, 0),
(360, '00:00', '00:19', '50', '2018-06-20', '2018-06-20', 42, 1, 3, '11:01:42', '11:02:01', 0, 0),
(361, '07:53', '394:47', '50', '2018-06-21', '2018-06-21', 42, 2, 3, '06:53:25', '13:28:12', 0, 0),
(362, '01:04', '53:21', '50', '2018-06-21', '2018-06-22', 42, 3, 3, '06:43:36', '07:05:42', 0, 0),
(363, '01:23', '69:52', '50', '2018-06-22', '2018-06-22', 42, 4, 3, '07:13:43', '08:23:35', 0, 0),
(364, '00:23', '19:31', '50', '2018-06-22', '2018-06-22', 42, 5, 3, '09:39:32', '09:59:03', 0, 0),
(365, '02:50', '141:54', '50', '2018-06-22', '2018-06-22', 42, 6, 3, '11:55:47', '14:17:41', 0, 0),
(366, '00:00', '00:26', '50', '2018-06-25', '2018-06-25', 42, 7, 3, '08:13:42', '08:14:08', 0, 0),
(367, '00:02', '01:49', '50', '2018-06-25', '2018-06-25', 42, 8, 3, '08:25:29', '08:27:18', 0, 0),
(368, '04:10', '208:34', '50', '2018-06-25', '2018-06-25', 42, 10, 3, '12:27:21', '15:55:55', 0, 0),
(369, '03:07', '31:16', '10', '2018-06-20', '2018-06-20', 43, 1, 3, '15:37:43', '16:08:59', 0, 0),
(370, '20:03', '200:33', '10', '2018-06-21', '2018-06-22', 43, 2, 3, '06:25:06', '07:38:23', 0, 0),
(371, '03:31', '35:16', '10', '2018-06-22', '2018-06-22', 43, 3, 3, '08:06:53', '08:42:09', 0, 0),
(372, '04:56', '49:28', '10', '2018-06-22', '2018-06-22', 43, 4, 3, '10:20:15', '10:50:23', 0, 0),
(373, '01:06', '11:02', '10', '2018-06-22', '2018-06-22', 43, 5, 3, '10:53:37', '11:04:39', 0, 0),
(374, '06:43', '67:19', '10', '2018-06-22', '2018-06-22', 43, 6, 3, '14:10:10', '15:17:29', 0, 0),
(375, '00:02', '00:26', '10', '2018-06-25', '2018-06-25', 43, 7, 3, '08:12:12', '08:12:38', 0, 0),
(376, '00:43', '07:10', '10', '2018-06-25', '2018-06-25', 43, 8, 3, '08:17:16', '08:24:26', 0, 0),
(377, '02:46', '27:40', '10', '2018-06-25', '2018-06-25', 43, 10, 3, '09:32:10', '09:54:09', 0, 0),
(378, '03:37', '108:46', '30', '2018-07-03', '2018-07-03', 44, 1, 3, '11:47:36', '13:36:22', 0, 0),
(379, '07:07', '213:52', '30', '2018-07-05', '2018-07-05', 44, 2, 3, '07:47:38', '11:21:30', 0, 0),
(380, '05:58', '179:17', '30', '2018-07-05', '2018-07-06', 44, 3, 3, '06:37:10', '08:53:57', 0, 0),
(381, '00:00', '00:00', '0', NULL, NULL, 44, 4, 1, NULL, NULL, 0, 0),
(382, '00:00', '00:00', '0', NULL, NULL, 44, 5, 1, NULL, NULL, 0, 0),
(383, '00:00', '00:00', '0', NULL, NULL, 44, 6, 1, NULL, NULL, 0, 0),
(384, '00:00', '00:00', '0', NULL, NULL, 44, 7, 1, NULL, NULL, 0, 0),
(385, '00:00', '00:00', '0', NULL, NULL, 44, 8, 1, NULL, NULL, 0, 0),
(386, '00:00', '00:00', '0', NULL, NULL, 44, 9, 1, NULL, NULL, 0, 0),
(387, '00:00', '00:00', '0', NULL, NULL, 44, 10, 1, NULL, NULL, 0, 0),
(388, '03:08', '31:26', '10', '2018-06-20', '2018-06-20', 45, 1, 3, '15:37:52', '16:09:18', 0, 0),
(389, '20:58', '209:43', '10', '2018-06-21', '2018-06-22', 45, 2, 3, '06:25:39', '07:37:46', 0, 0),
(390, '02:10', '21:45', '10', '2018-06-22', '2018-06-22', 45, 3, 3, '08:07:09', '08:28:54', 0, 0),
(391, '06:43', '67:19', '10', '2018-06-22', '2018-06-22', 45, 4, 3, '10:19:46', '11:03:09', 0, 0),
(392, '01:34', '15:43', '10', '2018-06-22', '2018-06-22', 45, 5, 3, '11:08:05', '11:23:48', 0, 0),
(393, '01:04', '10:42', '10', '2018-06-22', '2018-06-22', 45, 6, 3, '14:16:02', '14:16:25', 0, 0),
(394, '00:43', '07:18', '10', '2018-06-22', '2018-06-22', 45, 7, 3, '14:20:29', '14:27:47', 0, 0),
(395, '07:37', '76:19', '10', '2018-06-22', '2018-06-25', 45, 8, 3, '08:19:37', '08:21:19', 0, 0),
(396, '01:18', '13:07', '10', '2018-06-25', '2018-06-25', 45, 10, 3, '08:17:42', '08:30:49', 0, 0),
(397, '00:00', '00:00', '100', '2018-06-22', '2018-06-22', 46, 1, 3, '06:00:00', '06:02:00', 0, 0),
(398, '00:00', '00:00', '100', '2018-06-22', '2018-06-22', 46, 2, 3, '06:00:00', '06:02:00', 0, 0),
(399, '01:28', '146:46', '100', '2018-06-22', '2018-06-22', 46, 3, 3, '08:05:35', '10:32:21', 0, 0),
(400, '02:00', '200:38', '100', '2018-06-22', '2018-06-22', 46, 4, 3, '11:08:53', '14:29:31', 0, 0),
(401, '00:00', '00:12', '100', '2018-06-22', '2018-06-22', 46, 5, 3, '14:30:55', '14:31:07', 0, 0),
(402, '00:31', '51:42', '100', '2018-06-22', '2018-06-25', 46, 6, 3, '08:51:09', '09:25:02', 0, 0),
(403, '00:06', '11:20', '100', '2018-06-25', '2018-06-25', 46, 7, 3, '10:42:36', '10:53:56', 0, 0),
(404, '00:07', '11:40', '100', '2018-06-25', '2018-06-25', 46, 8, 3, '10:57:59', '11:09:39', 0, 0),
(405, '00:00', '00:14', '100', '2018-06-28', '2018-06-28', 46, 10, 3, '09:46:35', '09:46:49', 0, 0),
(406, '08:13', '82:11', '10', '2018-06-21', '2018-06-21', 47, 1, 3, '09:38:29', '11:00:40', 0, 0),
(407, '32:35', '325:51', '10', '2018-06-22', '2018-06-22', 47, 2, 3, '06:20:55', '11:46:46', 0, 0),
(408, '10:40', '106:48', '10', '2018-06-25', '2018-06-25', 47, 3, 3, '11:21:22', '11:49:29', 0, 0),
(409, '22:34', '225:45', '10', '2018-06-25', '2018-06-25', 47, 4, 3, '15:29:43', '16:25:25', 0, 0),
(410, '00:35', '05:54', '10', '2018-06-26', '2018-06-26', 47, 5, 3, '06:16:52', '06:22:46', 0, 0),
(411, '07:23', '73:50', '10', '2018-06-26', '2018-06-26', 47, 6, 3, '07:04:45', '08:18:35', 0, 0),
(412, '07:04', '70:41', '10', '2018-06-26', '2018-06-26', 47, 7, 3, '09:23:51', '09:36:21', 0, 0),
(413, '00:17', '02:58', '10', '2018-06-26', '2018-06-26', 47, 8, 3, '11:40:02', '11:43:00', 0, 0),
(414, '00:33', '05:39', '10', '2018-06-27', '2018-06-27', 47, 10, 3, '14:32:45', '14:38:24', 0, 0),
(415, '00:37', '07:33', '12', '2018-06-22', '2018-06-22', 48, 1, 3, '10:54:18', '11:01:51', 0, 0),
(416, '25:49', '309:49', '12', '2018-06-25', '2018-06-25', 48, 2, 3, '06:24:29', '11:34:18', 0, 0),
(417, '00:00', '11:38', '12', '2018-06-25', '2018-06-26', 48, 3, 3, '16:07:44', '16:17:20', 0, 0),
(418, '00:00', '33:27', '12', '2018-06-26', '2018-06-26', 48, 4, 3, '07:41:09', '08:11:00', 0, 0),
(419, '00:25', '010:03', '12', '2018-06-26', '2018-06-26', 48, 5, 3, '07:51:35', '07:56:38', 0, 0),
(420, '07:56', '95:12', '12', '2018-06-26', '2018-06-26', 48, 6, 3, '08:51:26', '10:26:38', 0, 0),
(421, '00:01', '00:13', '12', '2018-06-27', '2018-06-27', 48, 7, 3, '13:34:53', '13:35:06', 0, 0),
(422, '00:01', '00:16', '12', '2018-06-27', '2018-06-27', 48, 8, 3, '13:35:23', '13:35:39', 0, 0),
(423, '00:41', '08:15', '12', '2018-06-27', '2018-06-27', 48, 9, 3, '07:53:13', '08:01:28', 0, 0),
(424, '00:00', '00:10', '12', '2018-06-27', '2018-06-27', 48, 10, 3, '15:31:20', '15:31:30', 0, 0),
(425, '02:38', '10:32', '4', '2018-06-22', '2018-06-22', 49, 1, 3, '09:08:51', '09:19:23', 0, 0),
(426, '72:26', '289:47', '4', '2018-06-22', '2018-06-22', 49, 2, 3, '09:35:16', '14:25:03', 0, 0),
(427, '27:22', '109:28', '4', '2018-06-25', '2018-06-25', 49, 3, 3, '06:24:24', '08:13:52', 0, 0),
(428, '05:23', '21:33', '4', '2018-06-25', '2018-06-25', 49, 4, 3, '08:20:49', '08:42:22', 0, 0),
(429, '52:34', '210:19', '4', '2018-06-25', '2018-06-25', 49, 5, 3, '10:33:18', '13:53:25', 0, 0),
(430, '14:43', '58:54', '4', '2018-06-25', '2018-06-25', 49, 6, 3, '14:56:33', '15:55:27', 0, 0),
(431, '01:46', '07:07', '4', '2018-06-25', '2018-06-25', 49, 7, 3, '15:05:11', '15:12:18', 0, 0),
(432, '00:24', '01:36', '4', '2018-06-25', '2018-06-25', 49, 8, 3, '15:14:14', '15:15:50', 0, 0),
(433, '01:54', '07:39', '4', '2018-06-25', '2018-06-25', 49, 10, 3, '15:18:55', '15:26:34', 0, 0),
(434, '01:21', '13:34', '10', '2018-06-22', '2018-06-22', 50, 1, 3, '10:36:18', '10:49:52', 0, 0),
(435, '28:38', '286:25', '10', '2018-06-25', '2018-06-25', 50, 2, 3, '06:24:15', '11:10:40', 0, 0),
(436, '06:35', '65:58', '10', '2018-06-25', '2018-06-26', 50, 3, 3, '09:30:04', '09:30:13', 0, 0),
(437, '05:54', '59:04', '10', '2018-06-26', '2018-06-26', 50, 4, 3, '10:50:51', '11:31:16', 0, 0),
(438, '01:31', '15:14', '10', '2018-06-26', '2018-06-26', 50, 5, 3, '11:45:33', '12:00:47', 0, 0),
(439, '00:00', '60:00', '10', '2018-06-27', '2018-06-27', 50, 6, 3, '10:32:21', '10:55:21', 0, 0),
(440, '01:26', '14:24', '10', '2018-06-27', '2018-06-27', 50, 7, 3, '10:34:31', '10:48:55', 0, 0),
(441, '03:25', '34:17', '10', '2018-06-27', '2018-06-27', 50, 8, 3, '10:56:39', '11:30:56', 0, 0),
(442, '04:42', '47:06', '10', '2018-06-27', '2018-06-27', 50, 10, 3, '13:24:56', '14:12:02', 0, 0),
(443, '03:06', '31:00', '10', '2018-06-25', '2018-06-25', 51, 1, 3, '09:09:17', '09:40:17', 0, 0),
(444, '31:02', '310:28', '10', '2018-06-25', '2018-06-25', 51, 2, 3, '09:56:13', '15:06:41', 0, 0),
(445, '02:26', '24:27', '10', '2018-06-26', '2018-06-26', 51, 3, 3, '09:38:15', '10:02:42', 0, 0),
(446, '06:43', '67:17', '10', '2018-06-26', '2018-06-26', 51, 4, 3, '10:58:22', '12:05:39', 0, 0),
(447, '00:00', '15:00', '10', '2018-06-26', '2018-06-26', 51, 5, 3, '08:19:00', '08:27:00', 0, 0),
(448, '06:54', '69:07', '10', '2018-06-27', '2018-06-27', 51, 6, 3, '09:23:38', '10:32:45', 0, 0),
(449, '01:25', '14:18', '10', '2018-06-27', '2018-06-27', 51, 7, 3, '10:34:51', '10:49:09', 0, 0),
(450, '01:00', '10:02', '10', '2018-06-27', '2018-06-27', 51, 8, 3, '10:56:51', '11:06:53', 0, 0),
(451, '00:01', '00:10', '10', '2018-06-27', '2018-06-27', 51, 10, 3, '15:30:52', '15:31:02', 0, 0),
(452, '00:01', '05:49', '200', '2018-06-27', '2018-06-27', 52, 1, 3, '07:41:00', '07:46:49', 0, 0),
(453, '00:10', '36:36', '200', '2018-06-27', '2018-06-27', 52, 3, 3, '08:16:50', '08:53:26', 0, 0),
(454, '00:22', '75:51', '200', '2018-06-27', '2018-06-27', 52, 4, 3, '15:23:35', '15:42:50', 0, 0),
(455, '00:00', '02:42', '200', '2018-06-28', '2018-06-28', 52, 5, 3, '06:41:37', '06:44:19', 0, 0),
(456, '00:06', '20:54', '200', '2018-06-27', '2018-06-28', 52, 6, 3, '08:35:07', '08:52:19', 0, 0),
(457, '00:07', '24:10', '200', '2018-06-28', '2018-06-28', 52, 7, 3, '10:18:04', '10:42:14', 0, 0),
(458, '00:03', '12:56', '200', '2018-06-28', '2018-06-28', 52, 8, 3, '12:15:04', '12:28:00', 0, 0),
(459, '03:00', '600:23', '200', '2018-06-29', '2018-06-29', 52, 10, 3, '06:42:58', '16:43:21', 0, 0),
(460, '06:13', '31:06', '5', '2018-06-25', '2018-06-25', 53, 1, 3, '09:09:28', '09:40:34', 0, 0),
(461, '62:08', '310:44', '5', '2018-06-25', '2018-06-25', 53, 2, 3, '09:56:30', '15:07:14', 0, 0),
(462, '02:31', '12:35', '5', '2018-06-25', '2018-06-25', 53, 3, 3, '16:17:06', '16:27:29', 0, 0),
(463, '06:19', '31:35', '5', '2018-06-26', '2018-06-26', 53, 4, 3, '07:37:21', '07:41:27', 0, 0),
(464, '02:35', '12:55', '5', '2018-06-26', '2018-06-26', 53, 5, 3, '08:00:00', '08:12:55', 0, 0),
(465, '18:57', '94:46', '5', '2018-06-26', '2018-06-26', 53, 6, 3, '08:51:39', '10:26:25', 0, 0),
(466, '00:05', '00:28', '5', '2018-06-26', '2018-06-26', 53, 7, 3, '14:30:27', '14:30:55', 0, 0),
(467, '00:02', '00:11', '5', '2018-06-26', '2018-06-26', 53, 8, 3, '14:31:18', '14:31:29', 0, 0),
(468, '07:02', '35:13', '5', '2018-06-26', '2018-06-26', 53, 10, 3, '14:29:14', '15:04:27', 0, 0),
(469, '230:50', '461:41', '2', '2018-06-25', '2018-06-26', 54, 1, 3, '11:25:30', '14:41:03', 0, 0),
(470, '00:00', '200:00', '2', '2018-06-26', '2018-06-26', 54, 2, 3, '06:31:31', '09:48:00', 0, 0),
(471, '75:23', '150:46', '2', '2018-06-27', '2018-06-27', 54, 3, 3, '11:22:01', '13:39:52', 0, 0),
(472, '49:27', '98:55', '2', '2018-06-27', '2018-06-27', 54, 4, 3, '13:55:02', '15:33:57', 0, 0),
(473, '15:08', '30:16', '2', '2018-06-28', '2018-06-28', 54, 5, 3, '06:10:48', '06:41:04', 0, 0),
(474, '47:05', '94:10', '2', '2018-06-28', '2018-06-28', 54, 6, 3, '07:14:11', '08:48:21', 0, 0),
(475, '54:48', '109:36', '2', '2018-06-28', '2018-06-28', 54, 7, 3, '10:17:17', '12:06:53', 0, 0),
(476, '06:46', '13:33', '2', '2018-06-28', '2018-06-28', 54, 8, 3, '12:08:22', '12:09:18', 0, 0),
(477, '00:33', '01:07', '2', '2018-06-28', '2018-06-28', 54, 10, 3, '13:50:16', '13:51:23', 0, 0),
(478, '00:00', '15:00', '10', '2018-06-26', '2018-06-26', 55, 1, 3, '14:41:40', '15:07:00', 0, 0),
(479, '11:06', '111:00', '10', '2018-06-28', '2018-06-28', 55, 3, 3, '15:41:27', '16:27:35', 0, 0),
(480, '10:11', '101:55', '10', '2018-06-29', '2018-06-29', 55, 4, 3, '08:59:43', '10:41:38', 0, 0),
(481, '00:04', '00:48', '10', '2018-06-29', '2018-06-29', 55, 5, 3, '15:19:15', '15:20:03', 0, 0),
(482, '00:01', '00:18', '10', '2018-06-29', '2018-06-29', 55, 6, 3, '15:20:27', '15:20:45', 0, 0),
(483, '01:43', '17:15', '10', '2018-06-29', '2018-06-29', 55, 7, 3, '15:21:19', '15:21:50', 0, 0),
(484, '08:50', '88:23', '10', '2018-06-29', '2018-06-29', 55, 8, 3, '15:17:30', '16:36:07', 0, 0),
(485, '21:06', '211:02', '10', '2018-07-03', '2018-07-03', 55, 10, 3, '12:05:10', '12:06:25', 0, 0),
(486, '08:51', '17:43', '2', '2018-06-25', '2018-06-25', 56, 1, 3, '08:09:58', '08:27:41', 0, 0),
(487, '03:57', '07:54', '2', '2018-06-25', '2018-06-25', 56, 3, 3, '10:29:34', '10:37:28', 0, 0),
(488, '19:17', '38:35', '2', '2018-06-25', '2018-06-25', 56, 4, 3, '11:11:06', '11:49:41', 0, 0),
(489, '00:14', '00:29', '2', '2018-06-25', '2018-06-25', 56, 5, 3, '11:56:04', '11:56:33', 0, 0),
(490, '30:48', '61:37', '2', '2018-06-25', '2018-06-25', 56, 6, 3, '15:53:49', '15:55:05', 0, 0),
(491, '05:23', '10:47', '2', '2018-06-25', '2018-06-25', 56, 7, 3, '14:16:20', '14:27:07', 0, 0),
(492, '31:43', '63:26', '2', '2018-06-25', '2018-06-25', 56, 8, 3, '14:55:45', '15:59:11', 0, 0),
(493, '06:04', '12:08', '2', '2018-06-26', '2018-06-26', 56, 10, 3, '09:55:59', '10:08:07', 0, 0),
(503, '15:27', '92:47', '6', '2018-06-25', '2018-06-25', 58, 1, 3, '11:37:31', '13:10:18', 0, 0),
(504, '85:30', '513:04', '6', '2018-06-26', '2018-06-26', 58, 2, 3, '06:56:13', '15:29:17', 0, 0),
(505, '08:13', '49:20', '6', '2018-06-27', '2018-06-27', 58, 3, 3, '07:12:58', '08:02:18', 0, 0),
(506, '15:10', '91:01', '6', '2018-06-27', '2018-06-27', 58, 4, 3, '11:08:27', '12:39:28', 0, 0),
(507, '06:55', '41:31', '6', '2018-06-28', '2018-06-28', 58, 5, 3, '09:15:29', '09:16:09', 0, 0),
(508, '21:22', '128:14', '6', '2018-06-28', '2018-06-29', 58, 6, 3, '07:57:20', '08:23:20', 0, 0),
(509, '07:33', '45:22', '6', '2018-06-28', '2018-07-03', 58, 7, 3, '12:13:56', '12:14:23', 0, 0),
(510, '05:23', '32:23', '6', '2018-07-03', '2018-07-03', 58, 8, 3, '06:27:03', '06:59:26', 0, 0),
(511, '04:27', '26:45', '6', '2018-07-03', '2018-07-03', 58, 10, 3, '08:07:21', '08:34:06', 0, 0),
(512, '00:12', '05:47', '28', '2018-06-26', '2018-06-26', 59, 1, 3, '14:42:03', '14:47:50', 0, 0),
(513, '03:49', '107:05', '28', '2018-07-03', '2018-07-03', 59, 3, 3, '08:37:34', '10:24:39', 0, 0),
(514, '06:19', '177:09', '28', '2018-07-04', '2018-07-04', 59, 4, 3, '09:58:43', '10:07:35', 0, 0),
(515, '02:15', '63:02', '28', '2018-07-04', '2018-07-04', 59, 5, 3, '10:08:40', '11:10:57', 0, 0),
(516, '05:07', '143:39', '28', '2018-07-04', '2018-07-05', 59, 6, 3, '12:52:31', '12:52:58', 0, 0),
(517, '01:41', '47:33', '28', '2018-07-05', '2018-07-05', 59, 7, 3, '13:04:12', '13:51:45', 0, 0),
(518, '00:01', '00:28', '28', '2018-07-05', '2018-07-05', 59, 8, 3, '13:52:04', '13:52:32', 0, 0),
(519, '00:56', '26:35', '28', '2018-07-05', '2018-07-05', 59, 10, 3, '15:33:18', '15:59:53', 0, 0),
(520, '03:05', '06:11', '2', '2018-06-25', '2018-06-25', 60, 1, 3, '16:22:53', '16:29:04', 0, 0),
(521, '87:34', '175:09', '2', '2018-06-26', '2018-06-26', 60, 2, 3, '06:55:29', '09:50:38', 0, 0),
(522, '13:25', '26:51', '2', '2018-06-26', '2018-06-26', 60, 3, 3, '10:03:08', '10:29:59', 0, 0),
(523, '20:00', '40:00', '2', '2018-06-26', '2018-06-26', 60, 4, 3, '10:58:02', '11:38:02', 0, 0),
(524, '02:34', '05:09', '2', '2018-06-26', '2018-06-26', 60, 5, 3, '11:45:43', '11:50:52', 0, 0),
(525, '43:16', '86:32', '2', '2018-06-26', '2018-06-26', 60, 6, 3, '12:56:28', '14:23:00', 0, 0),
(526, '00:09', '00:18', '2', '2018-06-26', '2018-06-26', 60, 7, 3, '14:27:44', '14:28:02', 0, 0),
(527, '00:27', '00:54', '2', '2018-06-26', '2018-06-26', 60, 8, 3, '14:28:53', '14:29:47', 0, 0),
(528, '17:32', '35:04', '2', '2018-06-26', '2018-06-26', 60, 10, 3, '14:29:04', '15:04:08', 0, 0),
(529, '12:19', '24:39', '2', '2018-06-25', '2018-06-26', 61, 1, 3, '11:25:41', '11:49:34', 0, 0),
(530, '113:54', '227:49', '2', '2018-06-26', '2018-06-27', 61, 2, 3, '06:29:39', '08:26:02', 0, 0),
(531, '88:05', '176:10', '2', '2018-06-27', '2018-06-27', 61, 3, 3, '10:44:12', '13:40:22', 0, 0),
(532, '00:00', '74:00', '2', '2018-06-27', '2018-06-27', 61, 4, 3, '15:02:39', '16:27:00', 0, 0);
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(533, '26:03', '52:06', '2', '2018-06-28', '2018-06-28', 61, 5, 3, '09:27:37', '10:19:08', 0, 0),
(534, '35:32', '71:04', '2', '2018-06-28', '2018-06-28', 61, 6, 3, '11:18:39', '11:47:13', 0, 0),
(535, '12:40', '25:20', '2', '2018-06-28', '2018-06-28', 61, 7, 3, '13:09:07', '13:34:27', 0, 0),
(536, '02:38', '05:17', '2', '2018-06-28', '2018-06-28', 61, 8, 3, '14:29:21', '14:34:38', 0, 0),
(537, '03:40', '07:21', '2', '2018-06-28', '2018-06-28', 61, 10, 3, '14:37:13', '14:44:34', 0, 0),
(538, '01:06', '33:18', '30', '2018-06-27', '2018-06-27', 62, 1, 3, '06:59:51', '07:33:09', 0, 0),
(539, '06:10', '185:13', '30', '2018-06-27', '2018-06-27', 62, 2, 3, '08:03:19', '11:08:32', 0, 0),
(540, '00:24', '12:12', '30', '2018-06-27', '2018-06-27', 62, 3, 3, '16:43:18', '16:55:30', 0, 0),
(541, '01:59', '59:34', '30', '2018-06-28', '2018-06-28', 62, 4, 3, '07:55:44', '08:29:28', 0, 0),
(542, '00:12', '06:17', '30', '2018-06-28', '2018-06-28', 62, 5, 3, '10:07:59', '10:08:20', 0, 0),
(543, '01:24', '42:02', '30', '2018-06-28', '2018-06-28', 62, 6, 3, '12:11:24', '12:53:26', 0, 0),
(544, '00:46', '23:10', '30', '2018-06-28', '2018-06-28', 62, 7, 3, '13:10:31', '13:33:41', 0, 0),
(545, '00:12', '06:15', '30', '2018-06-28', '2018-06-28', 62, 8, 3, '15:06:25', '15:12:40', 0, 0),
(546, '00:34', '17:07', '30', '2018-06-29', '2018-06-29', 62, 10, 3, '06:45:07', '06:55:49', 0, 0),
(547, '04:14', '25:25', '6', '2018-06-26', '2018-06-26', 63, 1, 3, '07:34:24', '07:59:49', 0, 0),
(548, '39:56', '239:38', '6', '2018-06-26', '2018-06-26', 63, 2, 3, '08:05:23', '12:05:01', 0, 0),
(549, '21:23', '128:22', '6', '2018-06-26', '2018-06-26', 63, 3, 3, '12:16:39', '14:25:01', 0, 0),
(550, '06:54', '41:25', '6', '2018-06-26', '2018-06-26', 63, 4, 3, '14:38:52', '15:20:17', 0, 0),
(551, '12:01', '72:07', '6', '2018-06-26', '2018-06-26', 63, 5, 3, '15:20:49', '16:32:56', 0, 0),
(552, '00:00', '60:00', '6', '2018-06-26', '2018-06-26', 63, 6, 3, '16:23:30', '16:59:30', 0, 0),
(553, '01:35', '09:31', '6', '2018-06-27', '2018-06-27', 63, 7, 3, '07:31:48', '07:41:19', 0, 0),
(554, '03:42', '22:13', '6', '2018-06-27', '2018-06-27', 63, 8, 3, '07:47:25', '08:09:38', 0, 0),
(555, '00:02', '00:14', '6', '2018-06-27', '2018-06-27', 63, 10, 3, '09:26:53', '09:27:07', 0, 0),
(556, '01:12', '12:06', '10', '2018-06-26', '2018-06-26', 64, 1, 3, '16:21:46', '16:33:52', 0, 0),
(557, '27:33', '275:32', '10', '2018-06-28', '2018-06-28', 64, 2, 3, '06:10:22', '10:45:54', 0, 0),
(558, '04:18', '43:06', '10', '2018-06-28', '2018-06-29', 64, 3, 3, '10:02:34', '10:36:33', 0, 0),
(559, '00:05', '00:55', '10', '2018-06-29', '2018-06-29', 64, 4, 3, '13:08:31', '13:09:26', 0, 0),
(560, '02:27', '24:35', '10', '2018-06-29', '2018-06-29', 64, 5, 3, '15:07:58', '15:32:33', 0, 0),
(561, '02:32', '25:29', '10', '2018-07-03', '2018-07-03', 64, 6, 3, '14:54:16', '15:19:45', 0, 0),
(562, '00:49', '08:15', '10', '2018-07-03', '2018-07-03', 64, 7, 3, '15:22:08', '15:22:26', 0, 0),
(563, '00:02', '00:21', '10', '2018-07-03', '2018-07-03', 64, 8, 3, '15:35:10', '15:35:31', 0, 0),
(564, '01:02', '10:27', '10', '2018-07-04', '2018-07-04', 64, 10, 3, '06:34:12', '06:44:39', 0, 0),
(565, '05:02', '10:05', '2', '2018-06-26', '2018-06-26', 65, 1, 3, '15:57:42', '16:07:47', 0, 0),
(566, '36:29', '72:59', '2', '2018-06-27', '2018-06-27', 65, 2, 3, '13:37:29', '14:50:28', 0, 0),
(567, '06:10', '12:21', '2', '2018-06-27', '2018-06-27', 65, 3, 3, '16:43:26', '16:55:47', 0, 0),
(568, '129:19', '258:39', '2', '2018-06-27', '2018-06-28', 65, 4, 3, '08:29:08', '10:58:56', 0, 0),
(569, '48:48', '97:36', '2', '2018-06-28', '2018-06-29', 65, 5, 3, '16:03:33', '16:04:01', 0, 0),
(570, '00:48', '01:37', '2', '2018-06-29', '2018-06-29', 65, 6, 3, '16:00:38', '16:02:15', 0, 0),
(571, '02:11', '04:22', '2', '2018-06-29', '2018-06-29', 65, 7, 3, '16:10:24', '16:14:46', 0, 0),
(572, '05:50', '11:41', '2', '2018-07-03', '2018-07-03', 65, 8, 3, '06:24:54', '06:36:35', 0, 0),
(573, '01:54', '03:49', '2', '2018-07-03', '2018-07-03', 65, 10, 3, '08:34:34', '08:38:23', 0, 0),
(574, '10:37', '95:36', '9', '2018-06-28', '2018-06-28', 66, 1, 3, '11:43:57', '13:19:33', 0, 0),
(575, '47:43', '429:30', '9', '2018-06-28', '2018-06-29', 66, 2, 3, '06:13:50', '10:37:06', 0, 0),
(576, '30:04', '270:40', '9', '2018-06-29', '2018-06-29', 66, 3, 3, '10:38:37', '15:09:17', 0, 0),
(577, '07:51', '70:46', '9', '2018-06-29', '2018-06-29', 66, 4, 3, '16:04:56', '16:17:17', 0, 0),
(578, '10:28', '94:12', '9', '2018-07-03', '2018-07-03', 66, 5, 3, '09:45:41', '11:19:24', 0, 0),
(579, '00:00', '98:19', '9', '2018-07-03', '2018-07-03', 66, 6, 3, '16:11:24', '17:45:24', 0, 0),
(580, '13:30', '121:38', '9', '2018-07-04', '2018-07-04', 66, 7, 3, '07:47:04', '09:48:42', 0, 0),
(581, '03:38', '32:48', '9', '2018-07-04', '2018-07-04', 66, 8, 3, '09:49:34', '09:50:02', 0, 0),
(582, '00:59', '08:59', '9', '2018-07-04', '2018-07-04', 66, 9, 3, '09:46:31', '09:55:30', 0, 0),
(583, '03:24', '30:40', '9', '2018-07-04', '2018-07-04', 66, 10, 3, '10:58:22', '11:29:02', 0, 0),
(584, '04:38', '18:33', '4', '2018-06-26', '2018-06-26', 67, 1, 3, '15:04:19', '15:22:52', 0, 0),
(585, '49:08', '196:35', '4', '2018-06-27', '2018-06-27', 67, 2, 3, '06:31:01', '09:47:36', 0, 0),
(586, '49:04', '196:18', '4', '2018-06-27', '2018-06-27', 67, 3, 3, '12:01:10', '13:40:44', 0, 0),
(587, '13:28', '53:53', '4', '2018-06-27', '2018-06-27', 67, 4, 3, '14:39:31', '15:33:24', 0, 0),
(588, '16:27', '65:51', '4', '2018-06-27', '2018-06-27', 67, 5, 3, '16:40:47', '16:42:49', 0, 0),
(589, '00:50', '03:22', '4', '2018-06-27', '2018-06-27', 67, 6, 3, '16:44:27', '16:47:49', 0, 0),
(590, '34:34', '138:16', '4', '2018-06-28', '2018-06-28', 67, 7, 3, '07:02:56', '09:21:07', 0, 0),
(591, '00:09', '00:36', '4', '2018-06-28', '2018-06-28', 67, 8, 3, '10:53:10', '10:53:46', 0, 0),
(592, '06:42', '26:51', '4', '2018-06-28', '2018-06-28', 67, 10, 3, '10:55:04', '11:21:55', 0, 0),
(593, '08:34', '77:06', '9', '2018-06-27', '2018-06-28', 68, 1, 3, '07:21:41', '07:47:37', 0, 0),
(594, '30:11', '271:44', '9', '2018-06-28', '2018-06-29', 68, 2, 3, '06:13:24', '09:48:52', 0, 0),
(595, '17:52', '160:48', '9', '2018-06-29', '2018-06-29', 68, 3, 3, '14:22:01', '17:02:49', 0, 0),
(596, '10:18', '92:46', '9', '2018-06-30', '2018-06-30', 68, 4, 3, '08:54:39', '10:27:25', 0, 0),
(597, '00:56', '08:24', '9', '2018-07-03', '2018-07-04', 68, 5, 3, '10:02:00', '10:02:22', 0, 0),
(598, '16:05', '144:52', '9', '2018-07-04', '2018-07-05', 68, 6, 3, '11:46:36', '13:05:39', 0, 0),
(599, '10:28', '94:12', '9', '2018-07-05', '2018-07-05', 68, 7, 3, '12:39:23', '14:13:35', 0, 0),
(600, '05:22', '48:22', '9', '2018-07-05', '2018-07-05', 68, 8, 3, '14:13:46', '15:02:08', 0, 0),
(601, '06:24', '57:43', '9', '2018-07-05', '2018-07-05', 68, 10, 3, '15:02:28', '16:00:11', 0, 0),
(602, '08:40', '156:06', '18', '2018-06-29', '2018-06-29', 69, 1, 3, '10:34:23', '13:10:29', 0, 0),
(603, '13:35', '244:43', '18', '2018-07-04', '2018-07-04', 69, 2, 3, '14:35:51', '15:50:42', 0, 0),
(604, '16:32', '297:38', '18', '2018-07-05', '2018-07-05', 69, 3, 3, '08:21:35', '12:06:56', 0, 0),
(605, '16:36', '298:48', '18', '2018-07-05', '2018-07-06', 69, 4, 3, '07:37:15', '09:01:24', 0, 0),
(606, '02:28', '44:40', '18', '2018-07-06', '2018-07-06', 69, 5, 3, '09:39:52', '10:24:32', 0, 0),
(607, '00:00', '392:56', '0', '2018-07-06', NULL, 69, 6, 2, '09:38:18', '16:11:14', 18, 0),
(608, '00:00', '00:00', '0', NULL, NULL, 69, 7, 1, NULL, NULL, 0, 0),
(609, '00:00', '00:00', '0', NULL, NULL, 69, 8, 1, NULL, NULL, 0, 0),
(610, '00:00', '00:00', '0', NULL, NULL, 69, 10, 1, NULL, NULL, 0, 0),
(611, '16:33', '33:06', '2', '2018-06-27', '2018-06-27', 70, 1, 3, '07:00:36', '07:33:42', 0, 0),
(612, '92:53', '185:46', '2', '2018-06-27', '2018-06-27', 70, 2, 3, '08:02:08', '11:07:54', 0, 0),
(613, '44:02', '88:04', '2', '2018-06-27', '2018-06-27', 70, 3, 3, '12:13:13', '13:41:12', 0, 0),
(614, '34:32', '69:05', '2', '2018-06-27', '2018-06-27', 70, 4, 3, '13:53:02', '15:02:07', 0, 0),
(615, '00:10', '00:20', '2', '2018-06-27', '2018-06-27', 70, 5, 3, '15:37:44', '15:38:04', 0, 0),
(616, '46:14', '92:28', '2', '2018-06-27', '2018-06-28', 70, 6, 3, '09:50:02', '09:57:44', 0, 0),
(617, '11:45', '23:31', '2', '2018-06-28', '2018-06-28', 70, 7, 3, '10:18:22', '10:41:53', 0, 0),
(618, '05:10', '10:20', '2', '2018-06-28', '2018-06-28', 70, 8, 3, '11:38:53', '11:49:13', 0, 0),
(619, '118:01', '236:03', '2', '2018-06-28', '2018-06-28', 70, 10, 3, '12:33:34', '16:29:37', 0, 0),
(620, '06:04', '12:09', '2', '2018-06-26', '2018-06-26', 71, 1, 3, '15:23:20', '15:35:29', 0, 0),
(621, '97:27', '194:54', '2', '2018-06-27', '2018-06-27', 71, 2, 3, '06:31:09', '09:46:03', 0, 0),
(622, '10:25', '20:50', '2', '2018-06-27', '2018-06-27', 71, 3, 3, '09:56:58', '10:17:48', 0, 0),
(623, '14:11', '28:23', '2', '2018-06-27', '2018-06-27', 71, 4, 3, '11:08:41', '11:37:04', 0, 0),
(624, '01:18', '02:36', '2', '2018-06-27', '2018-06-27', 71, 5, 3, '11:38:30', '11:41:06', 0, 0),
(625, '43:51', '87:43', '2', '2018-06-27', '2018-06-27', 71, 6, 3, '12:05:34', '13:33:17', 0, 0),
(626, '02:31', '05:03', '2', '2018-06-27', '2018-06-27', 71, 7, 3, '13:16:18', '13:21:21', 0, 0),
(627, '05:04', '10:09', '2', '2018-06-27', '2018-06-27', 71, 8, 3, '13:23:57', '13:34:06', 0, 0),
(628, '23:33', '47:07', '2', '2018-06-27', '2018-06-27', 71, 10, 3, '13:24:42', '14:11:49', 0, 0),
(629, '07:10', '28:41', '4', '2018-06-28', '2018-06-28', 72, 1, 3, '06:35:34', '07:04:15', 0, 0),
(630, '74:20', '297:21', '4', '2018-06-28', '2018-06-28', 72, 2, 3, '07:31:02', '12:28:23', 0, 0),
(631, '09:16', '37:05', '4', '2018-06-28', '2018-06-28', 72, 3, 3, '15:41:51', '16:18:52', 0, 0),
(632, '15:06', '60:25', '4', '2018-06-29', '2018-06-29', 72, 4, 3, '10:02:29', '10:32:36', 0, 0),
(633, '00:08', '00:33', '4', '2018-06-29', '2018-06-29', 72, 5, 3, '16:08:07', '16:08:40', 0, 0),
(634, '02:51', '11:24', '4', '2018-06-29', '2018-07-03', 72, 6, 3, '07:52:33', '07:55:41', 0, 0),
(635, '00:04', '00:17', '4', '2018-07-03', '2018-07-03', 72, 7, 3, '11:49:08', '11:49:25', 0, 0),
(636, '00:06', '00:24', '4', '2018-07-03', '2018-07-03', 72, 8, 3, '11:50:36', '11:51:00', 0, 0),
(637, '18:04', '72:16', '4', '2018-07-03', '2018-07-03', 72, 10, 3, '10:48:13', '12:00:29', 0, 0),
(638, '33:14', '33:14', '1', '2018-06-27', '2018-06-27', 73, 1, 3, '07:00:07', '07:33:21', 0, 0),
(639, '185:00', '185:00', '1', '2018-06-27', '2018-06-27', 73, 2, 3, '08:02:39', '11:07:39', 0, 0),
(640, '16:15', '16:15', '1', '2018-06-27', '2018-06-27', 73, 3, 3, '11:57:27', '12:13:42', 0, 0),
(641, '103:02', '103:02', '1', '2018-06-27', '2018-06-27', 73, 4, 3, '13:53:13', '15:36:15', 0, 0),
(642, '00:23', '00:23', '1', '2018-06-27', '2018-06-27', 73, 5, 3, '15:37:51', '15:38:14', 0, 0),
(643, '97:13', '97:13', '1', '2018-06-27', '2018-06-27', 73, 6, 3, '15:36:23', '17:13:36', 0, 0),
(644, '16:06', '16:06', '1', '2018-06-28', '2018-06-28', 73, 7, 3, '06:46:38', '07:02:44', 0, 0),
(645, '00:23', '00:23', '1', '2018-06-28', '2018-06-28', 73, 8, 3, '16:34:22', '16:34:45', 0, 0),
(646, '241:10', '241:10', '1', '2018-06-28', '2018-06-28', 73, 10, 3, '12:33:44', '16:34:54', 0, 0),
(647, '03:17', '22:59', '7', '2018-06-27', '2018-06-27', 74, 1, 3, '09:59:59', '10:22:58', 0, 0),
(648, '49:05', '343:38', '7', '2018-06-28', '2018-06-28', 74, 2, 3, '06:10:05', '11:53:43', 0, 0),
(649, '08:05', '56:38', '7', '2018-06-30', '2018-06-30', 74, 3, 3, '09:22:52', '10:19:30', 0, 0),
(650, '17:06', '119:42', '7', '2018-07-03', '2018-07-03', 74, 4, 3, '12:29:48', '12:35:35', 0, 0),
(651, '13:26', '94:07', '7', '2018-07-04', '2018-07-04', 74, 5, 3, '07:41:41', '09:15:48', 0, 0),
(652, '27:59', '195:57', '7', '2018-07-04', '2018-07-04', 74, 6, 3, '11:47:21', '15:03:12', 0, 0),
(653, '00:03', '00:25', '7', '2018-07-05', '2018-07-05', 74, 7, 3, '10:11:26', '10:11:51', 0, 0),
(654, '03:42', '25:58', '7', '2018-07-05', '2018-07-05', 74, 8, 3, '07:47:58', '08:13:56', 0, 0),
(655, '05:50', '40:54', '7', '2018-07-05', '2018-07-05', 74, 10, 3, '08:15:58', '08:56:52', 0, 0),
(656, '11:28', '22:56', '2', '2018-06-27', '2018-06-27', 75, 1, 3, '10:00:17', '10:23:13', 0, 0),
(657, '167:48', '335:36', '2', '2018-06-27', '2018-06-27', 75, 2, 3, '11:29:33', '17:05:09', 0, 0),
(658, '07:02', '14:05', '2', '2018-06-27', '2018-06-27', 75, 3, 3, '17:12:42', '17:26:47', 0, 0),
(659, '19:42', '39:24', '2', '2018-06-28', '2018-06-28', 75, 4, 3, '07:55:33', '08:24:34', 0, 0),
(660, '24:49', '49:38', '2', '2018-06-28', '2018-06-28', 75, 5, 3, '10:05:19', '10:32:43', 0, 0),
(661, '22:46', '45:32', '2', '2018-06-28', '2018-06-28', 75, 6, 3, '12:13:40', '12:37:11', 0, 0),
(662, '11:56', '23:53', '2', '2018-06-28', '2018-06-28', 75, 7, 3, '13:09:17', '13:33:10', 0, 0),
(663, '07:29', '14:59', '2', '2018-06-28', '2018-06-28', 75, 8, 3, '15:28:28', '15:43:27', 0, 0),
(664, '03:47', '07:34', '2', '2018-06-28', '2018-06-28', 75, 10, 3, '15:44:00', '15:51:34', 0, 0),
(665, '04:21', '43:33', '10', '2018-06-28', '2018-06-28', 76, 1, 3, '08:26:29', '09:10:02', 0, 0),
(666, '61:29', '614:54', '10', '2018-06-29', '2018-06-29', 76, 2, 3, '06:24:26', '16:39:20', 0, 0),
(667, '08:04', '80:42', '10', '2018-06-30', '2018-06-30', 76, 3, 3, '08:01:05', '09:21:47', 0, 0),
(668, '06:09', '61:37', '10', '2018-06-30', '2018-06-30', 76, 4, 3, '10:05:11', '11:06:48', 0, 0),
(669, '14:29', '144:58', '10', '2018-07-03', '2018-07-04', 76, 5, 3, '07:52:02', '07:59:59', 0, 0),
(670, '18:51', '188:38', '10', '2018-07-04', '2018-07-04', 76, 6, 3, '11:46:13', '14:54:51', 0, 0),
(671, '00:00', '00:00', '0', NULL, NULL, 76, 7, 1, NULL, NULL, 0, 0),
(672, '00:00', '00:00', '0', NULL, NULL, 76, 8, 1, NULL, NULL, 0, 0),
(673, '00:00', '00:00', '0', NULL, NULL, 76, 10, 1, NULL, NULL, 0, 0),
(674, '00:57', '28:43', '30', '2018-06-28', '2018-06-28', 77, 1, 3, '06:36:00', '07:04:43', 0, 0),
(675, '09:55', '297:30', '30', '2018-06-28', '2018-06-28', 77, 2, 3, '07:30:46', '12:28:16', 0, 0),
(676, '01:50', '55:10', '30', '2018-06-28', '2018-06-28', 77, 3, 3, '15:41:42', '16:17:18', 0, 0),
(677, '00:52', '26:23', '30', '2018-06-29', '2018-06-29', 77, 4, 3, '09:00:41', '09:00:55', 0, 0),
(678, '00:03', '01:36', '30', '2018-06-29', '2018-06-29', 77, 5, 3, '10:07:14', '10:08:50', 0, 0),
(679, '01:06', '33:22', '30', '2018-06-29', '2018-06-29', 77, 6, 3, '10:12:31', '10:45:53', 0, 0),
(680, '01:12', '36:07', '30', '2018-06-29', '2018-06-29', 77, 7, 3, '14:27:59', '15:04:06', 0, 0),
(681, '00:13', '06:48', '30', '2018-06-29', '2018-06-29', 77, 8, 3, '15:06:05', '15:12:53', 0, 0),
(682, '02:29', '74:31', '30', '2018-06-30', '2018-06-30', 77, 9, 3, '06:17:36', '07:32:07', 0, 0),
(683, '00:01', '00:56', '30', '2018-07-06', '2018-07-06', 77, 10, 3, '09:50:07', '09:51:03', 0, 0),
(684, '33:37', '33:37', '1', '2018-06-27', '2018-06-27', 78, 1, 3, '07:00:19', '07:33:56', 0, 0),
(685, '186:24', '186:24', '1', '2018-06-27', '2018-06-27', 78, 2, 3, '08:01:46', '11:08:10', 0, 0),
(686, '05:48', '05:48', '1', '2018-06-27', '2018-06-27', 78, 3, 3, '11:27:44', '11:33:32', 0, 0),
(687, '34:15', '34:15', '1', '2018-06-27', '2018-06-27', 78, 4, 3, '12:04:58', '12:39:13', 0, 0),
(688, '00:47', '00:47', '1', '2018-06-27', '2018-06-27', 78, 5, 3, '12:52:15', '12:53:02', 0, 0),
(689, '73:01', '73:01', '1', '2018-06-27', '2018-06-27', 78, 6, 3, '14:17:56', '15:26:17', 0, 0),
(690, '03:00', '03:00', '1', '2018-06-27', '2018-06-27', 78, 7, 3, '15:04:37', '15:07:37', 0, 0),
(691, '00:22', '00:22', '1', '2018-06-27', '2018-06-27', 78, 8, 3, '15:26:53', '15:27:15', 0, 0),
(692, '04:10', '04:10', '1', '2018-06-27', '2018-06-27', 78, 10, 3, '15:10:13', '15:14:23', 0, 0),
(693, '00:58', '29:14', '30', '2018-06-28', '2018-06-28', 79, 1, 3, '06:35:44', '07:04:58', 0, 0),
(694, '09:56', '298:04', '30', '2018-06-28', '2018-06-28', 79, 2, 3, '07:30:34', '12:28:38', 0, 0),
(695, '03:50', '115:18', '30', '2018-06-28', '2018-06-28', 79, 3, 3, '16:17:37', '16:28:40', 0, 0),
(696, '00:36', '18:26', '30', '2018-06-29', '2018-06-29', 79, 4, 3, '08:56:34', '09:00:08', 0, 0),
(697, '00:15', '07:46', '30', '2018-06-29', '2018-06-29', 79, 5, 3, '09:47:18', '09:55:04', 0, 0),
(698, '00:51', '25:48', '30', '2018-06-29', '2018-06-29', 79, 6, 3, '09:59:38', '10:25:26', 0, 0),
(699, '01:12', '36:05', '30', '2018-06-29', '2018-06-29', 79, 7, 3, '14:27:51', '15:03:56', 0, 0),
(700, '00:04', '02:18', '30', '2018-06-29', '2018-06-29', 79, 8, 3, '15:06:11', '15:08:29', 0, 0),
(701, '00:00', '00:15', '30', '2018-06-30', '2018-06-30', 79, 9, 3, '07:17:41', '07:17:56', 0, 0),
(702, '00:00', '00:14', '30', '2018-07-06', '2018-07-06', 79, 10, 3, '09:51:58', '09:52:12', 0, 0),
(713, '02:05', '12:31', '6', '2018-06-29', '2018-06-29', 81, 1, 3, '13:22:18', '13:34:49', 0, 0),
(714, '00:01', '00:10', '6', '2018-07-04', '2018-07-04', 81, 2, 3, '06:28:26', '06:28:36', 0, 0),
(715, '04:39', '27:56', '6', '2018-07-03', '2018-07-03', 81, 3, 3, '10:27:41', '10:55:37', 0, 0),
(716, '00:15', '01:31', '6', '2018-07-03', '2018-07-03', 81, 4, 3, '15:32:37', '15:34:08', 0, 0),
(717, '13:33', '81:23', '6', '2018-07-04', '2018-07-04', 81, 5, 3, '08:01:07', '08:25:55', 0, 0),
(718, '08:02', '48:17', '6', '2018-07-04', '2018-07-04', 81, 6, 3, '10:55:39', '11:43:56', 0, 0),
(719, '03:23', '20:19', '6', '2018-07-04', '2018-07-04', 81, 7, 3, '12:06:12', '12:26:31', 0, 0),
(720, '00:03', '00:22', '6', '2018-07-05', '2018-07-05', 81, 8, 3, '10:08:35', '10:08:57', 0, 0),
(721, '01:36', '09:36', '6', '2018-07-05', '2018-07-05', 81, 9, 3, '10:06:30', '10:16:06', 0, 0),
(722, '00:04', '00:25', '6', '2018-07-06', '2018-07-06', 81, 10, 3, '09:53:22', '09:53:47', 0, 0),
(723, '10:58', '10:58', '1', '2018-07-04', '2018-07-04', 82, 1, 3, '10:13:36', '10:24:34', 0, 0),
(724, '75:35', '75:35', '1', '2018-07-04', '2018-07-04', 82, 3, 3, '14:57:21', '16:09:36', 0, 0),
(725, '18:39', '18:39', '1', '2018-07-04', '2018-07-04', 82, 4, 3, '16:13:13', '16:31:52', 0, 0),
(726, '08:03', '08:03', '1', '2018-07-05', '2018-07-05', 82, 5, 3, '06:35:37', '06:43:40', 0, 0),
(727, '39:35', '39:35', '1', '2018-07-05', '2018-07-05', 82, 6, 3, '15:30:50', '16:05:01', 0, 0),
(728, '18:19', '18:19', '1', '2018-07-06', '2018-07-06', 82, 7, 3, '06:38:11', '06:56:30', 0, 0),
(729, '00:14', '00:14', '1', '2018-07-06', '2018-07-06', 82, 8, 3, '10:03:30', '10:03:44', 0, 0),
(730, '00:00', '00:00', '0', NULL, NULL, 82, 10, 1, NULL, NULL, 0, 0),
(731, '06:34', '32:54', '5', '2018-06-29', '2018-06-29', 83, 1, 3, '09:16:36', '09:49:30', 0, 0),
(732, '63:47', '318:55', '5', '2018-06-29', '2018-06-29', 83, 2, 3, '10:37:56', '15:56:51', 0, 0),
(733, '11:18', '56:30', '5', '2018-06-30', '2018-06-30', 83, 3, 3, '06:57:43', '07:54:13', 0, 0),
(734, '10:42', '53:32', '5', '2018-06-30', '2018-06-30', 83, 4, 3, '09:38:29', '10:32:01', 0, 0),
(735, '19:52', '99:22', '5', '2018-07-03', '2018-07-03', 83, 5, 3, '08:07:58', '09:00:35', 0, 0),
(736, '08:39', '43:15', '5', '2018-07-03', '2018-07-04', 83, 6, 3, '06:37:45', '06:41:02', 0, 0),
(737, '07:46', '38:50', '5', '2018-07-04', '2018-07-04', 83, 7, 3, '07:52:15', '08:31:05', 0, 0),
(738, '00:46', '03:52', '5', '2018-07-04', '2018-07-04', 83, 8, 3, '13:47:39', '13:51:31', 0, 0),
(739, '22:59', '114:59', '5', '2018-07-04', '2018-07-04', 83, 10, 3, '14:11:13', '16:06:12', 0, 0),
(740, '16:03', '80:16', '5', '2018-06-29', '2018-06-29', 84, 1, 3, '08:02:43', '09:17:46', 0, 0),
(741, '04:51', '24:16', '5', '2018-06-29', '2018-06-29', 84, 3, 3, '14:13:44', '14:22:48', 0, 0),
(742, '06:35', '32:58', '5', '2018-06-29', '2018-06-29', 84, 4, 3, '15:03:28', '15:36:26', 0, 0),
(743, '00:58', '04:54', '5', '2018-06-29', '2018-06-29', 84, 5, 3, '15:38:15', '15:43:09', 0, 0),
(744, '14:44', '73:41', '5', '2018-07-03', '2018-07-03', 84, 6, 3, '06:36:53', '07:50:34', 0, 0),
(745, '00:04', '00:24', '5', '2018-07-03', '2018-07-03', 84, 7, 3, '11:48:17', '11:48:41', 0, 0),
(746, '00:03', '00:16', '5', '2018-07-03', '2018-07-03', 84, 8, 3, '11:51:34', '11:51:50', 0, 0),
(747, '10:07', '50:36', '5', '2018-07-03', '2018-07-03', 84, 10, 3, '10:47:58', '11:38:34', 0, 0),
(748, '06:28', '32:20', '5', '2018-06-29', '2018-06-29', 85, 1, 3, '09:16:43', '09:49:03', 0, 0),
(749, '63:55', '319:39', '5', '2018-06-29', '2018-06-29', 85, 2, 3, '10:37:43', '15:57:22', 0, 0),
(750, '11:18', '56:32', '5', '2018-06-30', '2018-06-30', 85, 3, 3, '06:57:28', '07:54:00', 0, 0),
(751, '13:30', '67:32', '5', '2018-06-30', '2018-06-30', 85, 4, 3, '09:23:48', '10:31:20', 0, 0),
(752, '03:42', '18:32', '5', '2018-07-03', '2018-07-03', 85, 5, 3, '14:43:37', '14:43:56', 0, 0),
(753, '21:12', '106:01', '5', '2018-07-03', '2018-07-03', 85, 6, 3, '13:01:29', '14:47:30', 0, 0),
(754, '00:04', '00:22', '5', '2018-07-03', '2018-07-03', 85, 7, 3, '14:48:35', '14:48:57', 0, 0),
(755, '00:05', '00:27', '5', '2018-07-03', '2018-07-03', 85, 8, 3, '14:51:23', '14:51:50', 0, 0),
(756, '00:04', '00:24', '5', '2018-07-03', '2018-07-03', 85, 10, 3, '16:16:35', '16:16:59', 0, 0),
(757, '02:11', '32:49', '15', '2018-06-29', '2018-06-29', 86, 1, 3, '09:16:25', '09:49:14', 0, 0),
(758, '21:18', '319:41', '15', '2018-06-29', '2018-06-29', 86, 2, 3, '10:38:09', '15:57:50', 0, 0),
(759, '03:45', '56:15', '15', '2018-06-30', '2018-06-30', 86, 3, 3, '06:57:34', '07:53:49', 0, 0),
(760, '04:11', '62:54', '15', '2018-06-30', '2018-06-30', 86, 4, 3, '09:24:59', '10:27:53', 0, 0),
(761, '08:25', '126:28', '15', '2018-07-03', '2018-07-03', 86, 5, 3, '09:37:44', '11:20:12', 0, 0),
(762, '06:11', '92:56', '15', '2018-07-04', '2018-07-04', 86, 6, 3, '08:50:54', '09:29:25', 0, 0),
(763, '00:01', '00:25', '15', '2018-07-04', '2018-07-04', 86, 7, 3, '10:56:19', '10:56:44', 0, 0),
(764, '00:01', '00:27', '15', '2018-07-04', '2018-07-04', 86, 8, 3, '16:11:58', '16:12:25', 0, 0),
(765, '01:23', '20:49', '15', '2018-07-04', '2018-07-04', 86, 10, 3, '15:50:50', '16:11:39', 0, 0),
(766, '04:42', '09:24', '2', '2018-06-28', '2018-06-28', 54, 9, 3, '13:28:01', '13:37:25', 0, 0),
(767, '11:55', '35:47', '3', '2018-06-29', '2018-06-29', 87, 1, 3, '15:08:52', '15:44:39', 0, 0),
(768, '13:06', '39:20', '3', '2018-06-30', '2018-06-30', 87, 3, 3, '06:10:34', '06:49:54', 0, 0),
(769, '21:55', '65:45', '3', '2018-06-30', '2018-06-30', 87, 4, 3, '07:19:32', '08:25:17', 0, 0),
(770, '00:16', '00:50', '3', '2018-07-03', '2018-07-03', 87, 5, 3, '06:33:05', '06:33:55', 0, 0),
(771, '32:36', '97:50', '3', '2018-07-03', '2018-07-03', 87, 6, 3, '14:31:50', '16:09:40', 0, 0),
(772, '12:54', '38:44', '3', '2018-07-04', '2018-07-04', 87, 7, 3, '07:51:38', '08:30:22', 0, 0),
(773, '00:18', '00:55', '3', '2018-07-04', '2018-07-04', 87, 8, 3, '12:06:07', '12:07:02', 0, 0),
(774, '37:25', '112:15', '3', '2018-07-04', '2018-07-04', 87, 10, 3, '14:12:10', '16:04:25', 0, 0),
(775, '07:02', '35:12', '5', '2018-06-29', '2018-06-29', 88, 1, 3, '15:09:02', '15:44:14', 0, 0),
(776, '07:52', '39:20', '5', '2018-06-30', '2018-06-30', 88, 3, 3, '06:10:48', '06:50:08', 0, 0),
(777, '10:58', '54:53', '5', '2018-06-30', '2018-06-30', 88, 4, 3, '07:30:05', '08:24:52', 0, 0),
(778, '00:56', '04:40', '5', '2018-07-03', '2018-07-03', 88, 5, 3, '06:18:51', '06:23:31', 0, 0),
(779, '15:03', '75:17', '5', '2018-07-03', '2018-07-03', 88, 6, 3, '06:36:25', '07:51:42', 0, 0),
(780, '00:06', '00:30', '5', '2018-07-03', '2018-07-03', 88, 7, 3, '11:47:11', '11:47:41', 0, 0),
(781, '00:04', '00:22', '5', '2018-07-03', '2018-07-03', 88, 8, 3, '11:54:02', '11:54:24', 0, 0),
(782, '13:38', '68:13', '5', '2018-07-03', '2018-07-03', 88, 10, 3, '10:48:29', '11:56:42', 0, 0),
(783, '01:11', '05:55', '5', '2018-06-29', '2018-06-29', 89, 1, 3, '16:51:51', '16:57:46', 0, 0),
(784, '10:24', '52:03', '5', '2018-07-03', '2018-07-03', 89, 3, 3, '11:37:08', '12:29:11', 0, 0),
(785, '01:21', '06:46', '5', '2018-07-03', '2018-07-03', 89, 4, 3, '15:27:38', '15:34:24', 0, 0),
(786, '01:28', '07:20', '5', '2018-07-04', '2018-07-04', 89, 5, 3, '06:18:34', '06:25:54', 0, 0),
(787, '08:45', '43:49', '5', '2018-07-04', '2018-07-04', 89, 6, 3, '10:56:49', '11:40:38', 0, 0),
(788, '33:12', '166:00', '5', '2018-07-04', '2018-07-04', 89, 7, 3, '12:27:38', '14:14:16', 0, 0),
(789, '00:05', '00:29', '5', '2018-07-04', '2018-07-04', 89, 8, 3, '14:07:16', '14:07:45', 0, 0),
(790, '22:40', '113:22', '5', '2018-07-04', '2018-07-04', 89, 10, 3, '14:11:37', '16:04:59', 0, 0),
(791, '02:17', '13:45', '6', '2018-07-04', '2018-07-04', 90, 1, 3, '15:02:09', '15:15:54', 0, 0),
(792, '41:17', '247:45', '6', '2018-07-05', '2018-07-05', 90, 2, 3, '07:46:48', '11:54:33', 0, 0),
(793, '03:43', '22:20', '6', '2018-07-05', '2018-07-05', 90, 3, 3, '14:55:07', '15:17:27', 0, 0),
(794, '05:26', '32:38', '6', '2018-07-05', '2018-07-05', 90, 4, 3, '15:46:44', '16:19:22', 0, 0),
(795, '01:36', '09:40', '6', '2018-07-06', '2018-07-06', 90, 5, 3, '07:05:02', '07:08:59', 0, 0),
(796, '00:00', '00:00', '0', NULL, NULL, 90, 6, 1, NULL, NULL, 0, 0),
(797, '00:00', '00:00', '0', NULL, NULL, 90, 7, 1, NULL, NULL, 0, 0),
(798, '00:00', '00:00', '0', NULL, NULL, 90, 8, 1, NULL, NULL, 0, 0),
(799, '00:00', '00:00', '0', NULL, NULL, 90, 9, 1, NULL, NULL, 0, 0),
(800, '00:00', '00:00', '0', NULL, NULL, 90, 10, 1, NULL, NULL, 0, 0),
(801, '03:20', '06:40', '2', '2018-06-29', '2018-06-29', 91, 1, 3, '17:09:17', '17:15:57', 0, 0),
(802, '00:07', '00:14', '2', '2018-07-04', '2018-07-04', 91, 2, 3, '06:33:17', '06:33:31', 0, 0),
(803, '31:20', '62:40', '2', '2018-07-03', '2018-07-03', 91, 3, 3, '11:36:46', '12:29:38', 0, 0),
(804, '19:44', '39:29', '2', '2018-07-04', '2018-07-04', 91, 4, 3, '09:26:41', '10:06:10', 0, 0),
(805, '90:03', '180:06', '2', '2018-07-04', '2018-07-04', 91, 5, 3, '13:49:48', '13:50:29', 0, 0),
(806, '48:46', '97:33', '2', '2018-07-05', '2018-07-05', 91, 6, 3, '08:12:23', '09:49:56', 0, 0),
(807, '02:46', '05:32', '2', '2018-07-05', '2018-07-05', 91, 7, 3, '10:18:06', '10:23:38', 0, 0),
(808, '01:08', '02:16', '2', '2018-07-05', '2018-07-05', 91, 8, 3, '10:24:45', '10:27:01', 0, 0),
(809, '10:26', '20:52', '2', '2018-07-05', '2018-07-05', 91, 10, 3, '11:40:42', '12:01:34', 0, 0),
(810, '03:00', '09:02', '3', '2018-07-03', '2018-07-03', 92, 1, 3, '10:44:55', '10:53:57', 0, 0),
(811, '00:10', '00:30', '3', '2018-07-04', '2018-07-04', 92, 2, 3, '06:27:02', '06:27:32', 0, 0),
(812, '28:59', '86:58', '3', '2018-07-04', '2018-07-04', 92, 3, 3, '10:03:44', '10:30:57', 0, 0),
(813, '20:02', '60:06', '3', '2018-07-04', '2018-07-04', 92, 4, 3, '11:09:20', '12:09:26', 0, 0),
(814, '06:13', '18:41', '3', '2018-07-04', '2018-07-04', 92, 5, 3, '14:28:03', '14:46:44', 0, 0),
(815, '26:08', '78:25', '3', '2018-07-05', '2018-07-05', 92, 6, 3, '11:03:25', '12:21:50', 0, 0),
(816, '41:02', '123:06', '3', '2018-07-05', '2018-07-05', 92, 7, 3, '12:38:42', '14:41:48', 0, 0),
(817, '00:47', '02:21', '3', '2018-07-05', '2018-07-05', 92, 8, 3, '14:42:27', '14:44:48', 0, 0),
(818, '22:32', '67:37', '3', '2018-07-05', '2018-07-05', 92, 10, 3, '14:52:00', '15:59:37', 0, 0),
(819, '23:09', '69:27', '3', '2018-07-03', '2018-07-03', 93, 1, 3, '09:13:47', '10:23:14', 0, 0),
(820, '00:08', '00:24', '3', '2018-07-04', '2018-07-04', 93, 2, 3, '06:30:38', '06:31:02', 0, 0),
(821, '23:34', '70:44', '3', '2018-07-04', '2018-07-04', 93, 3, 3, '10:04:06', '10:31:14', 0, 0),
(822, '19:55', '59:46', '3', '2018-07-04', '2018-07-04', 93, 4, 3, '11:09:08', '12:08:54', 0, 0),
(823, '04:24', '13:12', '3', '2018-07-04', '2018-07-05', 93, 5, 3, '07:11:21', '07:11:40', 0, 0),
(824, '23:42', '71:07', '3', '2018-07-05', '2018-07-05', 93, 6, 3, '11:03:42', '12:14:49', 0, 0),
(825, '41:03', '123:11', '3', '2018-07-05', '2018-07-05', 93, 7, 3, '12:38:53', '14:42:04', 0, 0),
(826, '00:53', '02:41', '3', '2018-07-05', '2018-07-05', 93, 8, 3, '14:42:21', '14:45:02', 0, 0),
(827, '22:36', '67:48', '3', '2018-07-05', '2018-07-05', 93, 10, 3, '14:51:36', '15:59:24', 0, 0),
(828, '01:11', '23:51', '20', '2018-07-04', '2018-07-04', 94, 1, 3, '10:48:44', '11:12:35', 0, 0),
(829, '00:00', '560:14', '0', '2018-07-06', NULL, 94, 2, 2, '06:46:02', '16:06:16', 20, 0),
(830, '00:00', '00:00', '0', NULL, NULL, 94, 3, 1, NULL, NULL, 0, 0),
(831, '00:00', '00:00', '0', NULL, NULL, 94, 4, 1, NULL, NULL, 0, 0),
(832, '00:00', '00:00', '0', NULL, NULL, 94, 5, 1, NULL, NULL, 0, 0),
(833, '00:00', '00:00', '0', NULL, NULL, 94, 6, 1, NULL, NULL, 0, 0),
(834, '00:00', '00:00', '0', NULL, NULL, 94, 7, 1, NULL, NULL, 0, 0),
(835, '00:00', '00:00', '0', NULL, NULL, 94, 8, 1, NULL, NULL, 0, 0),
(836, '00:00', '00:00', '0', NULL, NULL, 94, 10, 1, NULL, NULL, 0, 0),
(837, '00:47', '31:41', '40', '2018-07-04', '2018-07-04', 95, 1, 3, '16:08:02', '16:39:43', 0, 0),
(838, '00:00', '558:17', '0', '2018-07-06', NULL, 95, 2, 2, '06:46:41', '16:04:58', 40, 0),
(839, '00:00', '00:00', '0', NULL, NULL, 95, 3, 1, NULL, NULL, 0, 0),
(840, '00:00', '00:00', '0', NULL, NULL, 95, 4, 1, NULL, NULL, 0, 0),
(841, '00:00', '00:00', '0', NULL, NULL, 95, 5, 1, NULL, NULL, 0, 0),
(842, '00:00', '00:00', '0', NULL, NULL, 95, 6, 1, NULL, NULL, 0, 0),
(843, '00:00', '00:00', '0', NULL, NULL, 95, 7, 1, NULL, NULL, 0, 0),
(844, '00:00', '00:00', '0', NULL, NULL, 95, 8, 1, NULL, NULL, 0, 0),
(845, '00:00', '00:00', '0', NULL, NULL, 95, 9, 1, NULL, NULL, 0, 0),
(846, '00:00', '00:00', '0', NULL, NULL, 95, 10, 1, NULL, NULL, 0, 0),
(847, '15:37', '156:19', '10', '2018-07-04', '2018-07-04', 96, 1, 3, '06:28:31', '09:04:50', 0, 0),
(848, '24:58', '249:46', '10', '2018-07-05', '2018-07-05', 96, 2, 3, '07:45:32', '11:55:18', 0, 0),
(849, '00:00', '350:19', '0', '2018-07-06', NULL, 96, 3, 2, '10:20:30', '16:10:49', 10, 0),
(850, '00:00', '00:00', '0', NULL, NULL, 96, 4, 1, NULL, NULL, 0, 0),
(851, '00:00', '00:00', '0', NULL, NULL, 96, 5, 1, NULL, NULL, 0, 0),
(852, '00:00', '00:00', '0', NULL, NULL, 96, 6, 1, NULL, NULL, 0, 0),
(853, '00:00', '00:00', '0', NULL, NULL, 96, 7, 1, NULL, NULL, 0, 0),
(854, '00:00', '00:00', '0', NULL, NULL, 96, 8, 1, NULL, NULL, 0, 0),
(855, '00:00', '00:00', '0', NULL, NULL, 96, 10, 1, NULL, NULL, 0, 0),
(856, '05:09', '51:32', '10', '2018-06-29', '2018-06-29', 97, 1, 3, '13:42:48', '14:34:20', 0, 0),
(857, '00:01', '00:19', '10', '2018-07-04', '2018-07-04', 97, 2, 3, '06:35:53', '06:36:12', 0, 0),
(858, '04:05', '40:54', '10', '2018-07-03', '2018-07-03', 97, 3, 3, '08:01:41', '08:36:53', 0, 0),
(859, '16:53', '168:51', '10', '2018-07-03', '2018-07-03', 97, 4, 3, '09:40:38', '12:29:29', 0, 0),
(860, '06:12', '62:05', '10', '2018-07-03', '2018-07-03', 97, 5, 3, '13:48:18', '14:24:52', 0, 0),
(861, '06:19', '63:17', '10', '2018-07-03', '2018-07-04', 97, 6, 3, '06:29:57', '06:30:33', 0, 0),
(862, '04:09', '41:34', '10', '2018-07-04', '2018-07-04', 97, 7, 3, '07:49:14', '08:30:48', 0, 0),
(863, '31:47', '317:59', '10', '2018-07-04', '2018-07-04', 97, 8, 3, '08:58:07', '14:16:06', 0, 0),
(864, '11:11', '111:54', '10', '2018-07-04', '2018-07-04', 97, 10, 3, '14:11:48', '16:03:42', 0, 0),
(865, '14:07', '70:39', '5', '2018-07-03', '2018-07-03', 98, 1, 3, '09:13:39', '10:24:18', 0, 0),
(866, '00:09', '00:48', '5', '2018-07-04', '2018-07-04', 98, 2, 3, '06:29:19', '06:30:07', 0, 0),
(867, '18:19', '91:39', '5', '2018-07-04', '2018-07-04', 98, 3, 3, '10:03:59', '10:28:57', 0, 0),
(868, '11:18', '56:33', '5', '2018-07-04', '2018-07-04', 98, 4, 3, '11:08:50', '12:05:23', 0, 0),
(869, '10:24', '52:04', '5', '2018-07-04', '2018-07-04', 98, 5, 3, '14:55:43', '15:47:47', 0, 0),
(870, '24:09', '120:49', '5', '2018-07-05', '2018-07-05', 98, 6, 3, '14:02:30', '16:03:19', 0, 0),
(871, '03:41', '18:27', '5', '2018-07-06', '2018-07-06', 98, 7, 3, '06:37:52', '06:56:19', 0, 0),
(872, '00:04', '00:23', '5', '2018-07-06', '2018-07-06', 98, 8, 3, '10:04:38', '10:05:01', 0, 0),
(873, '00:00', '00:00', '0', NULL, NULL, 98, 10, 1, NULL, NULL, 0, 0),
(874, '03:34', '21:24', '6', '2018-07-03', '2018-07-03', 99, 1, 3, '07:39:27', '08:00:51', 0, 0),
(875, '00:13', '01:18', '6', '2018-07-04', '2018-07-04', 99, 2, 3, '06:37:13', '06:38:31', 0, 0),
(876, '13:08', '78:48', '6', '2018-07-03', '2018-07-03', 99, 3, 3, '12:55:53', '14:14:41', 0, 0),
(877, '00:02', '00:14', '6', '2018-07-04', '2018-07-04', 99, 4, 3, '06:42:37', '06:42:51', 0, 0),
(878, '00:03', '00:18', '6', '2018-07-04', '2018-07-04', 99, 5, 3, '06:43:16', '06:43:34', 0, 0),
(879, '35:52', '215:12', '6', '2018-07-04', '2018-07-04', 99, 6, 3, '08:09:28', '11:44:40', 0, 0),
(880, '21:31', '129:10', '6', '2018-07-04', '2018-07-04', 99, 7, 3, '12:28:51', '14:18:41', 0, 0),
(881, '00:26', '02:37', '6', '2018-07-04', '2018-07-04', 99, 8, 3, '14:19:30', '14:22:07', 0, 0),
(882, '00:37', '03:42', '6', '2018-07-04', '2018-07-05', 99, 10, 3, '14:50:02', '14:51:09', 0, 0),
(883, '25:59', '155:55', '6', '2018-07-04', '2018-07-04', 100, 1, 3, '06:28:44', '09:04:39', 0, 0),
(884, '59:25', '356:31', '6', '2018-07-05', '2018-07-05', 100, 2, 3, '07:45:58', '13:42:29', 0, 0),
(885, '13:26', '80:41', '6', '2018-07-06', '2018-07-06', 100, 3, 3, '08:44:15', '10:04:56', 0, 0),
(886, '00:00', '00:00', '0', NULL, NULL, 100, 4, 1, NULL, NULL, 0, 0),
(887, '00:00', '00:00', '0', NULL, NULL, 100, 5, 1, NULL, NULL, 0, 0),
(888, '00:00', '00:00', '0', NULL, NULL, 100, 6, 1, NULL, NULL, 0, 0),
(889, '00:00', '00:00', '0', NULL, NULL, 100, 7, 1, NULL, NULL, 0, 0),
(890, '00:00', '00:00', '0', NULL, NULL, 100, 8, 1, NULL, NULL, 0, 0),
(891, '00:00', '00:00', '0', NULL, NULL, 100, 10, 1, NULL, NULL, 0, 0),
(892, '02:21', '58:55', '25', '2018-07-05', '2018-07-05', 101, 1, 3, '06:32:09', '07:31:04', 0, 0),
(893, '00:00', '00:00', '0', NULL, NULL, 101, 2, 1, NULL, NULL, 0, 0),
(894, '00:00', '00:00', '0', NULL, NULL, 101, 3, 1, NULL, NULL, 0, 0),
(895, '00:00', '00:00', '0', NULL, NULL, 101, 4, 1, NULL, NULL, 0, 0),
(896, '00:00', '00:00', '0', NULL, NULL, 101, 5, 1, NULL, NULL, 0, 0),
(897, '00:00', '00:00', '0', NULL, NULL, 101, 6, 1, NULL, NULL, 0, 0),
(898, '00:00', '00:00', '0', NULL, NULL, 101, 7, 1, NULL, NULL, 0, 0),
(899, '00:00', '00:00', '0', NULL, NULL, 101, 8, 1, NULL, NULL, 0, 0),
(900, '00:00', '00:00', '0', NULL, NULL, 101, 10, 1, NULL, NULL, 0, 0),
(901, '03:36', '90:06', '25', '2018-07-06', '2018-07-06', 102, 1, 3, '07:40:08', '09:10:14', 0, 0),
(902, '00:00', '00:00', '0', NULL, NULL, 102, 2, 1, NULL, NULL, 0, 0),
(903, '00:00', '00:00', '0', NULL, NULL, 102, 3, 1, NULL, NULL, 0, 0),
(904, '00:00', '00:00', '0', NULL, NULL, 102, 4, 1, NULL, NULL, 0, 0),
(905, '00:00', '00:00', '0', NULL, NULL, 102, 5, 1, NULL, NULL, 0, 0),
(906, '00:00', '00:00', '0', NULL, NULL, 102, 6, 1, NULL, NULL, 0, 0),
(907, '00:00', '00:00', '0', NULL, NULL, 102, 7, 1, NULL, NULL, 0, 0),
(908, '00:00', '00:00', '0', NULL, NULL, 102, 8, 1, NULL, NULL, 0, 0),
(909, '00:00', '00:00', '0', NULL, NULL, 102, 10, 1, NULL, NULL, 0, 0),
(910, '04:03', '08:06', '2', '2018-07-04', '2018-07-04', 103, 1, 3, '13:17:49', '13:25:55', 0, 0),
(911, '50:27', '100:55', '2', '2018-07-04', '2018-07-05', 103, 2, 3, '06:41:00', '06:41:32', 0, 0),
(912, '12:19', '24:38', '2', '2018-07-05', '2018-07-05', 103, 3, 3, '06:45:42', '07:10:20', 0, 0),
(913, '24:27', '48:54', '2', '2018-07-05', '2018-07-05', 103, 4, 3, '07:53:07', '08:42:01', 0, 0),
(914, '07:04', '14:09', '2', '2018-07-05', '2018-07-05', 103, 5, 3, '09:09:42', '09:11:28', 0, 0),
(915, '44:07', '88:14', '2', '2018-07-05', '2018-07-05', 103, 6, 3, '09:42:14', '11:10:28', 0, 0),
(916, '04:17', '08:35', '2', '2018-07-05', '2018-07-05', 103, 7, 3, '11:08:52', '11:17:27', 0, 0),
(917, '02:52', '05:44', '2', '2018-07-05', '2018-07-05', 103, 8, 3, '11:19:15', '11:24:59', 0, 0),
(918, '10:06', '20:12', '2', '2018-07-05', '2018-07-05', 103, 10, 3, '11:40:57', '12:01:09', 0, 0),
(919, '03:28', '13:52', '4', '2018-07-04', '2018-07-04', 104, 1, 3, '15:02:17', '15:16:09', 0, 0),
(920, '62:07', '248:28', '4', '2018-07-05', '2018-07-05', 104, 2, 3, '07:46:25', '11:54:53', 0, 0),
(921, '05:35', '22:21', '4', '2018-07-05', '2018-07-05', 104, 3, 3, '14:55:17', '15:17:38', 0, 0),
(922, '25:21', '101:24', '4', '2018-07-06', '2018-07-06', 104, 4, 3, '07:37:05', '08:59:44', 0, 0),
(923, '00:00', '00:00', '0', NULL, NULL, 104, 5, 1, NULL, NULL, 0, 0),
(924, '00:00', '00:00', '0', NULL, NULL, 104, 6, 1, NULL, NULL, 0, 0),
(925, '00:00', '00:00', '0', NULL, NULL, 104, 7, 1, NULL, NULL, 0, 0),
(926, '00:00', '00:00', '0', NULL, NULL, 104, 8, 1, NULL, NULL, 0, 0),
(927, '00:00', '00:00', '0', NULL, NULL, 104, 9, 1, NULL, NULL, 0, 0),
(928, '00:00', '00:00', '0', NULL, NULL, 104, 10, 1, NULL, NULL, 0, 0),
(929, '00:00', '00:00', '0', NULL, NULL, 105, 1, 1, NULL, NULL, 0, 0),
(930, '00:00', '00:00', '0', NULL, NULL, 105, 3, 1, NULL, NULL, 0, 0),
(931, '00:00', '00:00', '0', NULL, NULL, 105, 4, 1, NULL, NULL, 0, 0),
(932, '00:00', '00:00', '0', NULL, NULL, 105, 5, 1, NULL, NULL, 0, 0),
(933, '00:00', '00:00', '0', NULL, NULL, 105, 6, 1, NULL, NULL, 0, 0),
(934, '00:00', '00:00', '0', NULL, NULL, 105, 7, 1, NULL, NULL, 0, 0),
(935, '00:00', '00:00', '0', NULL, NULL, 105, 8, 1, NULL, NULL, 0, 0),
(936, '00:00', '00:00', '0', NULL, NULL, 105, 10, 1, NULL, NULL, 0, 0),
(937, '00:00', '00:00', '0', NULL, NULL, 106, 1, 1, NULL, NULL, 0, 0),
(938, '00:00', '00:00', '0', NULL, NULL, 106, 2, 1, NULL, NULL, 0, 0),
(939, '00:00', '00:00', '0', NULL, NULL, 106, 3, 1, NULL, NULL, 0, 0),
(940, '00:00', '00:00', '0', NULL, NULL, 106, 4, 1, NULL, NULL, 0, 0),
(941, '00:00', '00:00', '0', NULL, NULL, 106, 5, 1, NULL, NULL, 0, 0),
(942, '00:00', '00:00', '0', NULL, NULL, 106, 6, 1, NULL, NULL, 0, 0),
(943, '00:00', '00:00', '0', NULL, NULL, 106, 7, 1, NULL, NULL, 0, 0),
(944, '00:00', '00:00', '0', NULL, NULL, 106, 8, 1, NULL, NULL, 0, 0),
(945, '00:00', '00:00', '0', NULL, NULL, 106, 10, 1, NULL, NULL, 0, 0),
(946, '14:42', '29:24', '2', '2018-07-05', '2018-07-05', 107, 1, 3, '11:26:02', '11:26:13', 0, 0),
(947, '29:55', '59:51', '2', '2018-07-05', '2018-07-05', 107, 3, 3, '14:02:09', '14:02:43', 0, 0),
(948, '08:26', '16:53', '2', '2018-07-05', '2018-07-05', 107, 4, 3, '14:12:10', '14:29:03', 0, 0),
(949, '02:11', '04:22', '2', '2018-07-06', '2018-07-06', 107, 5, 3, '06:28:39', '06:33:01', 0, 0),
(950, '00:00', '411:05', '0', '2018-07-06', NULL, 107, 6, 2, '09:24:41', '16:15:46', 2, 0),
(951, '00:00', '00:00', '0', NULL, NULL, 107, 7, 1, NULL, NULL, 0, 0),
(952, '00:00', '00:00', '0', NULL, NULL, 107, 8, 1, NULL, NULL, 0, 0),
(953, '00:00', '00:00', '0', NULL, NULL, 107, 10, 1, NULL, NULL, 0, 0),
(954, '05:11', '31:07', '6', '2018-07-05', '2018-07-05', 108, 1, 3, '13:46:17', '14:17:24', 0, 0),
(955, '19:28', '116:48', '6', '2018-07-05', '2018-07-06', 108, 2, 3, '06:47:28', '08:19:09', 0, 0),
(956, '13:21', '80:11', '6', '2018-07-06', '2018-07-06', 108, 3, 3, '08:45:04', '10:05:11', 0, 0),
(957, '00:00', '342:53', '0', '2018-07-06', NULL, 108, 4, 2, '10:26:26', '16:09:19', 6, 0),
(958, '00:00', '00:00', '0', NULL, NULL, 108, 5, 1, NULL, NULL, 0, 0),
(959, '00:00', '00:00', '0', NULL, NULL, 108, 6, 1, NULL, NULL, 0, 0),
(960, '00:00', '00:00', '0', NULL, NULL, 108, 7, 1, NULL, NULL, 0, 0),
(961, '00:00', '00:00', '0', NULL, NULL, 108, 8, 1, NULL, NULL, 0, 0),
(962, '00:00', '00:00', '0', NULL, NULL, 108, 9, 1, NULL, NULL, 0, 0),
(963, '00:00', '00:12', '0', '2018-07-13', NULL, 108, 10, 2, '08:35:00', '08:35:12', 6, 0),
(964, '00:00', '00:00', '0', NULL, NULL, 109, 1, 1, NULL, NULL, 0, 0),
(965, '00:00', '00:00', '0', NULL, NULL, 109, 2, 1, NULL, NULL, 0, 0),
(966, '00:00', '00:00', '0', NULL, NULL, 109, 3, 1, NULL, NULL, 0, 0),
(967, '00:00', '00:00', '0', NULL, NULL, 109, 4, 1, NULL, NULL, 0, 0),
(968, '00:00', '00:00', '0', NULL, NULL, 109, 5, 1, NULL, NULL, 0, 0),
(969, '00:00', '00:00', '0', NULL, NULL, 109, 7, 1, NULL, NULL, 0, 0),
(970, '00:00', '00:00', '0', NULL, NULL, 109, 8, 1, NULL, NULL, 0, 0),
(971, '00:00', '00:00', '0', NULL, NULL, 109, 10, 1, NULL, NULL, 0, 0),
(972, '00:08', '29:33', '200', '2018-07-05', '2018-07-05', 110, 1, 3, '10:56:23', '11:25:56', 0, 0),
(973, '00:00', '00:00', '0', NULL, NULL, 110, 3, 1, NULL, NULL, 0, 0),
(974, '00:00', '00:00', '0', NULL, NULL, 110, 4, 1, NULL, NULL, 0, 0),
(975, '00:00', '00:00', '0', NULL, NULL, 110, 5, 1, NULL, NULL, 0, 0),
(976, '00:00', '00:00', '0', NULL, NULL, 110, 7, 1, NULL, NULL, 0, 0),
(977, '00:00', '00:00', '0', NULL, NULL, 110, 8, 1, NULL, NULL, 0, 0),
(978, '00:00', '00:00', '0', NULL, NULL, 110, 10, 1, NULL, NULL, 0, 0),
(979, '00:00', '00:00', '0', NULL, NULL, 111, 1, 1, NULL, NULL, 0, 0),
(980, '00:00', '00:00', '0', NULL, NULL, 111, 3, 1, NULL, NULL, 0, 0),
(981, '00:00', '00:00', '0', NULL, NULL, 111, 4, 1, NULL, NULL, 0, 0),
(982, '00:00', '00:00', '0', NULL, NULL, 111, 5, 1, NULL, NULL, 0, 0),
(983, '00:00', '00:00', '0', NULL, NULL, 111, 7, 1, NULL, NULL, 0, 0),
(984, '00:00', '00:00', '0', NULL, NULL, 111, 8, 1, NULL, NULL, 0, 0),
(985, '00:00', '00:00', '0', NULL, NULL, 111, 10, 1, NULL, NULL, 0, 0),
(986, '00:00', '358:03', '0', '2018-07-06', NULL, 112, 1, 2, '10:09:56', '16:07:59', 30, 0),
(987, '00:00', '00:00', '0', NULL, NULL, 112, 2, 1, NULL, NULL, 0, 0),
(988, '00:00', '00:00', '0', NULL, NULL, 112, 3, 1, NULL, NULL, 0, 0),
(989, '00:00', '00:00', '0', NULL, NULL, 112, 4, 1, NULL, NULL, 0, 0),
(990, '00:00', '00:00', '0', NULL, NULL, 112, 5, 1, NULL, NULL, 0, 0),
(991, '00:00', '00:00', '0', NULL, NULL, 112, 6, 1, NULL, NULL, 0, 0),
(992, '00:00', '00:00', '0', NULL, NULL, 112, 7, 1, NULL, NULL, 0, 0),
(993, '00:00', '00:00', '0', NULL, NULL, 112, 8, 1, NULL, NULL, 0, 0),
(994, '00:00', '00:00', '0', NULL, NULL, 112, 10, 1, NULL, NULL, 0, 0),
(995, '00:00', '358:22', '0', '2018-07-06', NULL, 113, 1, 2, '10:09:44', '16:08:06', 10, 0),
(996, '00:00', '00:00', '0', NULL, NULL, 113, 2, 1, NULL, NULL, 0, 0),
(997, '00:00', '00:00', '0', NULL, NULL, 113, 3, 1, NULL, NULL, 0, 0),
(998, '00:00', '00:00', '0', NULL, NULL, 113, 4, 1, NULL, NULL, 0, 0),
(999, '00:00', '00:00', '0', NULL, NULL, 113, 5, 1, NULL, NULL, 0, 0),
(1000, '00:00', '00:00', '0', NULL, NULL, 113, 6, 1, NULL, NULL, 0, 0),
(1001, '00:00', '00:00', '0', NULL, NULL, 113, 7, 1, NULL, NULL, 0, 0),
(1002, '00:00', '00:00', '0', NULL, NULL, 113, 8, 1, NULL, NULL, 0, 0),
(1003, '00:00', '00:00', '0', NULL, NULL, 113, 10, 1, NULL, NULL, 0, 0),
(1004, '00:00', '00:00', '0', NULL, NULL, 114, 1, 1, NULL, NULL, 0, 0),
(1005, '00:00', '00:00', '0', NULL, NULL, 114, 3, 1, NULL, NULL, 0, 0),
(1006, '00:00', '00:00', '0', NULL, NULL, 114, 4, 1, NULL, NULL, 0, 0),
(1007, '00:00', '00:00', '0', NULL, NULL, 114, 5, 1, NULL, NULL, 0, 0),
(1008, '00:00', '00:00', '0', NULL, NULL, 114, 6, 1, NULL, NULL, 0, 0),
(1009, '00:00', '00:00', '0', NULL, NULL, 114, 7, 1, NULL, NULL, 0, 0),
(1010, '00:00', '00:00', '0', NULL, NULL, 114, 8, 1, NULL, NULL, 0, 0),
(1011, '00:00', '00:00', '0', NULL, NULL, 114, 10, 1, NULL, NULL, 0, 0),
(1012, '00:00', '358:10', '0', '2018-07-06', NULL, 115, 1, 2, '10:10:06', '16:08:16', 4, 0),
(1013, '00:00', '00:00', '0', NULL, NULL, 115, 2, 1, NULL, NULL, 0, 0),
(1014, '00:00', '00:00', '0', NULL, NULL, 115, 3, 1, NULL, NULL, 0, 0),
(1015, '00:00', '00:00', '0', NULL, NULL, 115, 4, 1, NULL, NULL, 0, 0),
(1016, '00:00', '00:00', '0', NULL, NULL, 115, 5, 1, NULL, NULL, 0, 0),
(1017, '00:00', '00:00', '0', NULL, NULL, 115, 6, 1, NULL, NULL, 0, 0),
(1018, '00:00', '00:00', '0', NULL, NULL, 115, 7, 1, NULL, NULL, 0, 0),
(1019, '00:00', '00:00', '0', NULL, NULL, 115, 8, 1, NULL, NULL, 0, 0),
(1020, '00:00', '00:00', '0', NULL, NULL, 115, 10, 1, NULL, NULL, 0, 0),
(1021, '06:15', '31:18', '5', '2018-07-05', '2018-07-05', 116, 1, 3, '13:46:26', '14:17:44', 0, 0),
(1022, '31:34', '157:51', '5', '2018-07-05', '2018-07-06', 116, 2, 3, '06:47:12', '09:00:24', 0, 0),
(1023, '00:05', '00:25', '5', '2018-07-06', '2018-07-06', 116, 3, 3, '09:57:16', '09:57:41', 0, 0),
(1024, '04:23', '21:59', '5', '2018-07-06', '2018-07-06', 116, 4, 3, '09:52:46', '10:14:45', 0, 0),
(1025, '00:00', '27:43', '0', '2018-07-06', NULL, 116, 5, 2, '10:21:40', '10:49:23', 5, 0),
(1026, '00:00', '00:00', '0', NULL, NULL, 116, 6, 1, NULL, NULL, 0, 0),
(1027, '00:00', '00:00', '0', NULL, NULL, 116, 7, 1, NULL, NULL, 0, 0),
(1028, '00:00', '00:00', '0', NULL, NULL, 116, 8, 1, NULL, NULL, 0, 0),
(1029, '00:00', '00:00', '0', NULL, NULL, 116, 10, 1, NULL, NULL, 0, 0),
(1030, '00:00', '00:00', '0', NULL, NULL, 117, 1, 1, NULL, NULL, 0, 0),
(1031, '00:00', '00:00', '0', NULL, NULL, 117, 3, 1, NULL, NULL, 0, 0),
(1032, '00:00', '00:00', '0', NULL, NULL, 117, 4, 1, NULL, NULL, 0, 0),
(1033, '00:00', '00:00', '0', NULL, NULL, 117, 5, 1, NULL, NULL, 0, 0),
(1034, '00:00', '00:00', '0', NULL, NULL, 117, 6, 1, NULL, NULL, 0, 0),
(1035, '00:00', '00:00', '0', NULL, NULL, 117, 7, 1, NULL, NULL, 0, 0),
(1036, '00:00', '00:00', '0', NULL, NULL, 117, 8, 1, NULL, NULL, 0, 0),
(1037, '00:00', '00:00', '0', NULL, NULL, 117, 10, 1, NULL, NULL, 0, 0),
(1038, '00:00', '00:00', '0', NULL, NULL, 118, 1, 1, NULL, NULL, 0, 0),
(1039, '00:00', '00:00', '0', NULL, NULL, 118, 2, 1, NULL, NULL, 0, 0),
(1040, '00:00', '00:00', '0', NULL, NULL, 118, 3, 1, NULL, NULL, 0, 0),
(1041, '00:00', '00:00', '0', NULL, NULL, 118, 4, 1, NULL, NULL, 0, 0),
(1042, '00:00', '00:00', '0', NULL, NULL, 118, 5, 1, NULL, NULL, 0, 0),
(1043, '00:00', '00:00', '0', NULL, NULL, 118, 6, 1, NULL, NULL, 0, 0),
(1044, '00:00', '00:00', '0', NULL, NULL, 118, 7, 1, NULL, NULL, 0, 0),
(1045, '00:00', '00:00', '0', NULL, NULL, 118, 8, 1, NULL, NULL, 0, 0),
(1046, '00:00', '00:00', '0', NULL, NULL, 118, 10, 1, NULL, NULL, 0, 0),
(1047, '00:00', '00:00', '0', NULL, NULL, 119, 1, 1, NULL, NULL, 0, 0),
(1048, '00:00', '00:00', '0', NULL, NULL, 119, 2, 1, NULL, NULL, 0, 0),
(1049, '00:00', '00:00', '0', NULL, NULL, 119, 3, 1, NULL, NULL, 0, 0),
(1050, '00:00', '00:00', '0', NULL, NULL, 119, 4, 1, NULL, NULL, 0, 0),
(1051, '00:00', '00:00', '0', NULL, NULL, 119, 5, 1, NULL, NULL, 0, 0),
(1052, '00:00', '00:00', '0', NULL, NULL, 119, 6, 1, NULL, NULL, 0, 0),
(1053, '00:00', '00:00', '0', NULL, NULL, 119, 7, 1, NULL, NULL, 0, 0),
(1054, '00:00', '00:00', '0', NULL, NULL, 119, 8, 1, NULL, NULL, 0, 0),
(1055, '00:00', '00:00', '0', NULL, NULL, 119, 10, 1, NULL, NULL, 0, 0),
(1056, '00:00', '00:00', '0', NULL, NULL, 120, 1, 1, NULL, NULL, 0, 0),
(1057, '00:00', '00:00', '0', NULL, NULL, 120, 2, 1, NULL, NULL, 0, 0),
(1058, '00:00', '00:00', '0', NULL, NULL, 120, 3, 1, NULL, NULL, 0, 0),
(1059, '00:00', '00:00', '0', NULL, NULL, 120, 4, 1, NULL, NULL, 0, 0),
(1060, '00:00', '00:00', '0', NULL, NULL, 120, 5, 1, NULL, NULL, 0, 0),
(1061, '00:00', '00:00', '0', NULL, NULL, 120, 6, 1, NULL, NULL, 0, 0),
(1062, '00:00', '00:00', '0', NULL, NULL, 120, 7, 1, NULL, NULL, 0, 0),
(1063, '00:00', '00:00', '0', NULL, NULL, 120, 8, 1, NULL, NULL, 0, 0),
(1064, '00:00', '00:00', '0', NULL, NULL, 120, 10, 1, NULL, NULL, 0, 0),
(1065, '00:00', '00:00', '0', NULL, NULL, 121, 1, 1, NULL, NULL, 0, 0),
(1066, '00:00', '00:00', '0', NULL, NULL, 121, 2, 1, NULL, NULL, 0, 0),
(1067, '00:00', '00:00', '0', NULL, NULL, 121, 3, 1, NULL, NULL, 0, 0),
(1068, '00:00', '00:00', '0', NULL, NULL, 121, 4, 1, NULL, NULL, 0, 0),
(1069, '00:00', '00:00', '0', NULL, NULL, 121, 5, 1, NULL, NULL, 0, 0),
(1070, '00:00', '00:00', '0', NULL, NULL, 121, 6, 1, NULL, NULL, 0, 0),
(1071, '00:00', '00:00', '0', NULL, NULL, 121, 7, 1, NULL, NULL, 0, 0),
(1072, '00:00', '00:00', '0', NULL, NULL, 121, 8, 1, NULL, NULL, 0, 0),
(1073, '00:00', '00:00', '0', NULL, NULL, 121, 10, 1, NULL, NULL, 0, 0),
(1074, '00:00', '00:00', '0', NULL, NULL, 122, 1, 1, NULL, NULL, 0, 0),
(1075, '00:00', '00:00', '0', NULL, NULL, 122, 2, 1, NULL, NULL, 0, 0),
(1076, '00:00', '00:00', '0', NULL, NULL, 122, 3, 1, NULL, NULL, 0, 0),
(1077, '00:00', '00:00', '0', NULL, NULL, 122, 4, 1, NULL, NULL, 0, 0),
(1078, '00:00', '00:00', '0', NULL, NULL, 122, 5, 1, NULL, NULL, 0, 0),
(1079, '00:00', '00:00', '0', NULL, NULL, 122, 6, 1, NULL, NULL, 0, 0),
(1080, '00:00', '00:00', '0', NULL, NULL, 122, 7, 1, NULL, NULL, 0, 0),
(1081, '00:00', '00:00', '0', NULL, NULL, 122, 8, 1, NULL, NULL, 0, 0),
(1082, '00:00', '00:00', '0', NULL, NULL, 122, 10, 1, NULL, NULL, 0, 0),
(1083, '00:00', '00:00', '0', NULL, NULL, 123, 1, 1, NULL, NULL, 0, 0),
(1084, '00:00', '00:00', '0', NULL, NULL, 123, 2, 1, NULL, NULL, 0, 0),
(1085, '00:00', '00:00', '0', NULL, NULL, 123, 3, 1, NULL, NULL, 0, 0),
(1086, '00:00', '00:00', '0', NULL, NULL, 123, 4, 1, NULL, NULL, 0, 0),
(1087, '00:00', '00:00', '0', NULL, NULL, 123, 5, 1, NULL, NULL, 0, 0),
(1088, '00:00', '00:00', '0', NULL, NULL, 123, 6, 1, NULL, NULL, 0, 0),
(1089, '00:00', '00:00', '0', NULL, NULL, 123, 7, 1, NULL, NULL, 0, 0),
(1090, '00:00', '00:00', '0', NULL, NULL, 123, 8, 1, NULL, NULL, 0, 0),
(1091, '00:00', '00:00', '0', NULL, NULL, 123, 10, 1, NULL, NULL, 0, 0),
(1092, '00:00', '00:00', '0', NULL, NULL, 124, 1, 1, NULL, NULL, 0, 0),
(1093, '00:00', '00:00', '0', NULL, NULL, 124, 2, 1, NULL, NULL, 0, 0),
(1094, '00:00', '00:00', '0', NULL, NULL, 124, 3, 1, NULL, NULL, 0, 0),
(1095, '00:00', '00:00', '0', NULL, NULL, 124, 4, 1, NULL, NULL, 0, 0),
(1096, '00:00', '00:00', '0', NULL, NULL, 124, 5, 1, NULL, NULL, 0, 0),
(1097, '00:00', '00:00', '0', NULL, NULL, 124, 6, 1, NULL, NULL, 0, 0),
(1098, '00:00', '00:00', '0', NULL, NULL, 124, 7, 1, NULL, NULL, 0, 0),
(1099, '00:00', '00:00', '0', NULL, NULL, 124, 8, 1, NULL, NULL, 0, 0),
(1100, '00:00', '00:00', '0', NULL, NULL, 124, 10, 1, NULL, NULL, 0, 0),
(1101, '00:00', '00:00', '0', NULL, NULL, 125, 1, 1, NULL, NULL, 0, 0),
(1102, '00:00', '00:00', '0', NULL, NULL, 125, 2, 1, NULL, NULL, 0, 0),
(1103, '00:00', '00:00', '0', NULL, NULL, 125, 3, 1, NULL, NULL, 0, 0),
(1104, '00:00', '00:00', '0', NULL, NULL, 125, 4, 1, NULL, NULL, 0, 0),
(1105, '00:00', '00:00', '0', NULL, NULL, 125, 5, 1, NULL, NULL, 0, 0),
(1106, '00:00', '00:00', '0', '2018-07-17', NULL, 125, 6, 3, '15:40:20', NULL, 0, 1),
(1107, '00:00', '00:00', '0', NULL, NULL, 125, 7, 1, NULL, NULL, 0, 0),
(1108, '00:00', '00:00', '0', NULL, NULL, 125, 8, 1, NULL, NULL, 0, 0),
(1109, '00:00', '00:00', '0', NULL, NULL, 125, 10, 1, NULL, NULL, 0, 0),
(1110, '00:00', '00:00', '0', NULL, NULL, 126, 1, 1, NULL, NULL, 0, 0),
(1111, '00:00', '00:00', '0', NULL, NULL, 126, 2, 1, NULL, NULL, 0, 0),
(1112, '00:00', '00:00', '0', NULL, NULL, 126, 3, 1, NULL, NULL, 0, 0),
(1113, '00:00', '00:00', '0', NULL, NULL, 126, 4, 1, NULL, NULL, 0, 0),
(1114, '00:00', '00:00', '0', NULL, NULL, 126, 5, 1, NULL, NULL, 0, 0),
(1115, '00:00', '00:00', '0', NULL, NULL, 126, 6, 1, NULL, NULL, 0, 0),
(1116, '00:00', '00:00', '0', NULL, NULL, 126, 7, 1, NULL, NULL, 0, 0),
(1117, '00:00', '00:00', '0', NULL, NULL, 126, 8, 1, NULL, NULL, 0, 0),
(1118, '00:00', '00:00', '0', NULL, NULL, 126, 10, 1, NULL, NULL, 0, 0),
(1119, '00:00', '00:00', '0', NULL, NULL, 127, 1, 1, NULL, NULL, 0, 0),
(1120, '00:00', '00:00', '0', NULL, NULL, 127, 3, 1, NULL, NULL, 0, 0),
(1121, '00:00', '00:00', '0', NULL, NULL, 127, 4, 1, NULL, NULL, 0, 0),
(1122, '00:00', '00:00', '0', NULL, NULL, 127, 5, 1, NULL, NULL, 0, 0),
(1123, '00:00', '00:00', '0', NULL, NULL, 127, 7, 1, NULL, NULL, 0, 0);
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1124, '00:00', '00:00', '0', NULL, NULL, 127, 8, 1, NULL, NULL, 0, 0),
(1125, '00:00', '00:00', '0', NULL, NULL, 127, 10, 1, NULL, NULL, 0, 0),
(1126, '00:00', '00:00', '0', NULL, NULL, 128, 1, 1, NULL, NULL, 0, 0),
(1127, '00:00', '00:00', '0', NULL, NULL, 128, 2, 1, NULL, NULL, 0, 0),
(1128, '00:00', '00:00', '0', NULL, NULL, 128, 3, 1, NULL, NULL, 0, 0),
(1129, '00:00', '00:00', '0', NULL, NULL, 128, 4, 1, NULL, NULL, 0, 0),
(1130, '00:00', '00:00', '0', NULL, NULL, 128, 5, 1, NULL, NULL, 0, 0),
(1131, '00:00', '00:00', '0', NULL, NULL, 128, 6, 1, NULL, NULL, 0, 0),
(1132, '00:00', '00:00', '0', NULL, NULL, 128, 7, 1, NULL, NULL, 0, 0),
(1133, '00:00', '00:00', '0', NULL, NULL, 128, 8, 1, NULL, NULL, 0, 0),
(1134, '00:00', '00:00', '0', NULL, NULL, 128, 10, 1, NULL, NULL, 0, 0),
(1135, '00:00', '00:00', '0', NULL, NULL, 129, 1, 1, NULL, NULL, 0, 0),
(1136, '00:00', '00:00', '0', NULL, NULL, 129, 2, 1, NULL, NULL, 0, 0),
(1137, '00:00', '00:00', '0', NULL, NULL, 129, 3, 1, NULL, NULL, 0, 0),
(1138, '00:00', '00:00', '0', NULL, NULL, 129, 4, 1, NULL, NULL, 0, 0),
(1139, '00:00', '00:00', '0', NULL, NULL, 129, 5, 1, NULL, NULL, 0, 0),
(1140, '00:00', '00:00', '0', NULL, NULL, 129, 6, 1, NULL, NULL, 0, 0),
(1141, '00:00', '00:00', '0', NULL, NULL, 129, 7, 1, NULL, NULL, 0, 0),
(1142, '00:00', '00:00', '0', NULL, NULL, 129, 8, 1, NULL, NULL, 0, 0),
(1143, '00:00', '00:00', '0', NULL, NULL, 129, 10, 1, NULL, NULL, 0, 0),
(1144, '00:00', '00:00', '0', NULL, NULL, 130, 1, 1, NULL, NULL, 0, 0),
(1145, '00:00', '00:00', '0', NULL, NULL, 130, 3, 1, NULL, NULL, 0, 0),
(1146, '00:00', '00:00', '0', NULL, NULL, 130, 4, 1, NULL, NULL, 0, 0),
(1147, '00:00', '00:00', '0', NULL, NULL, 130, 5, 1, NULL, NULL, 0, 0),
(1148, '00:00', '00:00', '0', NULL, NULL, 130, 7, 1, NULL, NULL, 0, 0),
(1149, '00:00', '00:00', '0', NULL, NULL, 130, 8, 1, NULL, NULL, 0, 0),
(1150, '00:00', '00:00', '0', NULL, NULL, 130, 10, 1, NULL, NULL, 0, 0),
(1151, '00:00', '00:00', '0', NULL, NULL, 131, 1, 1, NULL, NULL, 0, 0),
(1152, '00:00', '00:00', '0', NULL, NULL, 131, 3, 1, NULL, NULL, 0, 0),
(1153, '00:00', '00:00', '0', NULL, NULL, 131, 4, 1, NULL, NULL, 0, 0),
(1154, '00:00', '00:00', '0', NULL, NULL, 131, 5, 1, NULL, NULL, 0, 0),
(1155, '00:00', '00:00', '0', NULL, NULL, 131, 7, 1, NULL, NULL, 0, 0),
(1156, '00:00', '00:00', '0', NULL, NULL, 131, 8, 1, NULL, NULL, 0, 0),
(1157, '00:00', '00:00', '0', NULL, NULL, 131, 10, 1, NULL, NULL, 0, 0),
(1158, '00:00', '00:00', '0', NULL, NULL, 132, 1, 1, NULL, NULL, 0, 0),
(1159, '00:00', '00:00', '0', NULL, NULL, 132, 3, 1, NULL, NULL, 0, 0),
(1160, '00:00', '00:00', '0', NULL, NULL, 132, 4, 1, NULL, NULL, 0, 0),
(1161, '00:00', '00:00', '0', NULL, NULL, 132, 5, 1, NULL, NULL, 0, 0),
(1162, '00:00', '27:48', '0', '2018-07-25', NULL, 132, 6, 4, '14:59:41', NULL, 50, 1),
(1163, '00:00', '00:00', '0', NULL, NULL, 132, 7, 1, NULL, NULL, 0, 0),
(1164, '00:00', '00:00', '0', NULL, NULL, 132, 8, 1, NULL, NULL, 0, 0),
(1165, '00:00', '00:00', '0', NULL, NULL, 132, 10, 1, NULL, NULL, 0, 0),
(1166, '00:00', '00:00', '0', NULL, NULL, 133, 1, 1, NULL, NULL, 0, 0),
(1167, '00:00', '00:00', '0', NULL, NULL, 133, 2, 1, NULL, NULL, 0, 0),
(1168, '00:00', '00:00', '0', NULL, NULL, 133, 3, 1, NULL, NULL, 0, 0),
(1169, '00:00', '00:00', '0', NULL, NULL, 133, 4, 1, NULL, NULL, 0, 0),
(1170, '00:00', '00:00', '0', NULL, NULL, 133, 5, 1, NULL, NULL, 0, 0),
(1171, '00:00', '00:00', '0', NULL, NULL, 133, 6, 1, NULL, NULL, 0, 0),
(1172, '00:00', '00:00', '0', NULL, NULL, 133, 7, 1, NULL, NULL, 0, 0),
(1173, '00:00', '00:00', '0', NULL, NULL, 133, 8, 1, NULL, NULL, 0, 0),
(1174, '00:00', '00:00', '0', NULL, NULL, 133, 10, 1, NULL, NULL, 0, 0),
(1175, '00:00', '00:00', '0', NULL, NULL, 134, 1, 1, NULL, NULL, 0, 0),
(1176, '00:00', '00:00', '0', NULL, NULL, 134, 3, 1, NULL, NULL, 0, 0),
(1177, '00:00', '00:00', '0', NULL, NULL, 134, 4, 1, NULL, NULL, 0, 0),
(1178, '00:00', '00:00', '0', NULL, NULL, 134, 5, 1, NULL, NULL, 0, 0),
(1179, '00:00', '00:00', '0', NULL, NULL, 134, 6, 1, NULL, NULL, 0, 0),
(1180, '00:00', '00:00', '0', NULL, NULL, 134, 7, 1, NULL, NULL, 0, 0),
(1181, '00:00', '00:00', '0', NULL, NULL, 134, 8, 1, NULL, NULL, 0, 0),
(1182, '00:00', '00:00', '0', NULL, NULL, 134, 10, 1, NULL, NULL, 0, 0),
(1183, '00:00', '00:00', '0', NULL, NULL, 135, 1, 1, NULL, NULL, 0, 0),
(1184, '00:00', '00:00', '0', NULL, NULL, 135, 3, 1, NULL, NULL, 0, 0),
(1185, '00:00', '00:00', '0', NULL, NULL, 135, 4, 1, NULL, NULL, 0, 0),
(1186, '00:00', '00:00', '0', NULL, NULL, 135, 5, 1, NULL, NULL, 0, 0),
(1187, '00:00', '00:00', '0', NULL, NULL, 135, 6, 1, NULL, NULL, 0, 0),
(1188, '00:00', '00:00', '0', NULL, NULL, 135, 7, 1, NULL, NULL, 0, 0),
(1189, '00:00', '00:00', '0', NULL, NULL, 135, 8, 1, NULL, NULL, 0, 0),
(1190, '00:00', '00:00', '0', NULL, NULL, 135, 10, 1, NULL, NULL, 0, 0),
(1191, '00:00', '00:00', '0', NULL, NULL, 136, 1, 1, NULL, NULL, 0, 0),
(1192, '00:00', '00:00', '0', NULL, NULL, 136, 3, 1, NULL, NULL, 0, 0),
(1193, '00:00', '00:00', '0', NULL, NULL, 136, 4, 1, NULL, NULL, 0, 0),
(1194, '00:00', '00:00', '0', NULL, NULL, 136, 5, 1, NULL, NULL, 0, 0),
(1195, '00:00', '00:00', '0', NULL, NULL, 136, 6, 1, NULL, NULL, 0, 0),
(1196, '00:00', '00:00', '0', NULL, NULL, 136, 7, 1, NULL, NULL, 0, 0),
(1197, '00:00', '00:00', '0', NULL, NULL, 136, 8, 1, NULL, NULL, 0, 0),
(1198, '00:00', '00:00', '0', NULL, NULL, 136, 10, 1, NULL, NULL, 0, 0),
(1199, '01:49', '36:34', '20', '2018-07-16', '2018-07-16', 137, 1, 3, '14:26:19', '15:02:53', 0, 0),
(1200, '00:02', '00:54', '20', '2018-07-18', '2018-07-18', 137, 2, 3, '06:51:11', '06:52:05', 0, 0),
(1201, '01:09', '23:15', '20', '2018-07-17', '2018-07-18', 137, 3, 3, '14:27:31', '07:04:16', 0, 0),
(1202, '00:00', '00:14', '20', '2018-07-18', '2018-07-18', 137, 4, 3, '07:27:31', '07:27:45', 0, 0),
(1203, '06:00', '120:11', '20', '2018-07-18', '2018-07-18', 137, 5, 3, '14:26:02', '14:48:39', 0, 0),
(1204, '11:35', '231:40', '20', '2018-07-19', '2018-07-19', 137, 6, 3, '03:23:21', '06:27:35', 0, 0),
(1205, '00:00', '00:00', '0', NULL, NULL, 137, 7, 1, NULL, NULL, 0, 0),
(1206, '00:00', '00:00', '0', NULL, NULL, 137, 8, 1, NULL, NULL, 0, 0),
(1207, '00:00', '00:00', '0', NULL, NULL, 137, 10, 1, NULL, NULL, 0, 0),
(1208, '00:00', '00:00', '0', NULL, NULL, 138, 1, 1, NULL, NULL, 0, 0),
(1209, '00:00', '00:00', '0', NULL, NULL, 138, 3, 1, NULL, NULL, 0, 0),
(1210, '00:00', '00:00', '0', NULL, NULL, 138, 4, 1, NULL, NULL, 0, 0),
(1211, '00:00', '00:00', '0', NULL, NULL, 138, 5, 1, NULL, NULL, 0, 0),
(1212, '04:28', '134:15', '30', '2018-07-17', '2018-07-17', 138, 6, 3, '09:48:33', '12:02:48', 0, 0),
(1213, '00:00', '00:00', '0', NULL, NULL, 138, 7, 1, NULL, NULL, 0, 0),
(1214, '00:00', '00:00', '0', NULL, NULL, 138, 8, 1, NULL, NULL, 0, 0),
(1215, '00:00', '00:00', '0', NULL, NULL, 138, 10, 1, NULL, NULL, 0, 0),
(1216, '00:00', '00:00', '0', NULL, NULL, 139, 1, 1, NULL, NULL, 0, 0),
(1217, '00:00', '00:00', '0', NULL, NULL, 139, 2, 1, NULL, NULL, 0, 0),
(1218, '00:00', '00:00', '0', NULL, NULL, 139, 3, 1, NULL, NULL, 0, 0),
(1219, '00:00', '00:00', '0', NULL, NULL, 139, 4, 1, NULL, NULL, 0, 0),
(1220, '00:00', '00:00', '0', NULL, NULL, 139, 5, 1, NULL, NULL, 0, 0),
(1221, '00:00', '00:00', '0', NULL, NULL, 139, 6, 1, NULL, NULL, 0, 0),
(1222, '00:00', '00:00', '0', NULL, NULL, 139, 7, 1, NULL, NULL, 0, 0),
(1223, '00:00', '00:00', '0', NULL, NULL, 139, 8, 1, NULL, NULL, 0, 0),
(1224, '00:00', '00:00', '0', NULL, NULL, 139, 10, 1, NULL, NULL, 0, 0),
(1225, '00:00', '00:00', '0', NULL, NULL, 140, 1, 1, NULL, NULL, 0, 0),
(1226, '00:00', '00:00', '0', NULL, NULL, 140, 3, 1, NULL, NULL, 0, 0),
(1227, '00:00', '00:00', '0', NULL, NULL, 140, 4, 1, NULL, NULL, 0, 0),
(1228, '00:00', '00:00', '0', NULL, NULL, 140, 5, 1, NULL, NULL, 0, 0),
(1229, '00:00', '00:00', '0', NULL, NULL, 140, 6, 1, NULL, NULL, 0, 0),
(1230, '00:00', '00:00', '0', NULL, NULL, 140, 7, 1, NULL, NULL, 0, 0),
(1231, '00:00', '00:00', '0', NULL, NULL, 140, 8, 1, NULL, NULL, 0, 0),
(1232, '00:00', '00:00', '0', NULL, NULL, 140, 10, 1, NULL, NULL, 0, 0),
(1233, '00:00', '00:00', '0', NULL, NULL, 141, 1, 1, NULL, NULL, 0, 0),
(1234, '00:00', '00:00', '0', NULL, NULL, 141, 3, 1, NULL, NULL, 0, 0),
(1235, '00:00', '00:00', '0', NULL, NULL, 141, 4, 1, NULL, NULL, 0, 0),
(1236, '00:00', '00:00', '0', NULL, NULL, 141, 5, 1, NULL, NULL, 0, 0),
(1237, '00:00', '00:00', '0', NULL, NULL, 141, 6, 1, NULL, NULL, 0, 0),
(1238, '00:00', '00:00', '0', NULL, NULL, 141, 7, 1, NULL, NULL, 0, 0),
(1239, '00:00', '00:00', '0', NULL, NULL, 141, 8, 1, NULL, NULL, 0, 0),
(1240, '00:00', '00:00', '0', NULL, NULL, 141, 10, 1, NULL, NULL, 0, 0),
(1241, '01:10', '35:28', '30', '2018-07-16', '2018-07-16', 142, 1, 3, '17:13:43', '17:49:11', 0, 0),
(1242, '00:04', '02:28', '30', '2018-07-18', '2018-07-18', 142, 2, 3, '07:11:56', '07:14:24', 0, 0),
(1243, '09:31', '285:37', '30', '2018-07-18', '2018-07-18', 142, 3, 3, '07:08:53', '11:54:30', 0, 0),
(1244, '09:28', '284:17', '30', '2018-07-18', '2018-07-18', 142, 4, 3, '17:29:31', '18:53:21', 0, 0),
(1245, '06:28', '194:19', '30', '2018-07-19', '2018-07-19', 142, 5, 3, '10:12:18', '11:11:13', 0, 0),
(1246, '00:00', '00:00', '0', NULL, NULL, 142, 6, 1, NULL, NULL, 0, 0),
(1247, '00:00', '00:00', '0', NULL, NULL, 142, 7, 1, NULL, NULL, 0, 0),
(1248, '00:00', '00:00', '0', NULL, NULL, 142, 8, 1, NULL, NULL, 0, 0),
(1249, '00:00', '00:00', '0', NULL, NULL, 142, 10, 1, NULL, NULL, 0, 0),
(1250, '00:00', '00:00', '0', NULL, NULL, 143, 1, 1, NULL, NULL, 0, 0),
(1251, '00:00', '00:00', '0', NULL, NULL, 143, 2, 1, NULL, NULL, 0, 0),
(1252, '00:00', '00:00', '0', NULL, NULL, 143, 3, 1, NULL, NULL, 0, 0),
(1253, '00:00', '00:00', '0', NULL, NULL, 143, 4, 1, NULL, NULL, 0, 0),
(1254, '00:00', '00:00', '0', NULL, NULL, 143, 5, 1, NULL, NULL, 0, 0),
(1255, '00:00', '00:00', '0', NULL, NULL, 143, 6, 1, NULL, NULL, 0, 0),
(1256, '00:00', '00:00', '0', NULL, NULL, 143, 7, 1, NULL, NULL, 0, 0),
(1257, '00:00', '00:00', '0', NULL, NULL, 143, 8, 1, NULL, NULL, 0, 0),
(1258, '00:00', '00:00', '0', NULL, NULL, 143, 10, 1, NULL, NULL, 0, 0),
(1259, '00:00', '00:00', '0', NULL, NULL, 144, 1, 1, NULL, NULL, 0, 0),
(1260, '00:00', '00:00', '0', NULL, NULL, 144, 2, 1, NULL, NULL, 0, 0),
(1261, '00:00', '00:00', '0', NULL, NULL, 144, 3, 1, NULL, NULL, 0, 0),
(1262, '00:00', '00:00', '0', NULL, NULL, 144, 4, 1, NULL, NULL, 0, 0),
(1263, '00:00', '00:00', '0', NULL, NULL, 144, 5, 1, NULL, NULL, 0, 0),
(1264, '00:00', '00:00', '0', NULL, NULL, 144, 6, 1, NULL, NULL, 0, 0),
(1265, '00:00', '00:00', '0', NULL, NULL, 144, 7, 1, NULL, NULL, 0, 0),
(1266, '00:00', '00:00', '0', NULL, NULL, 144, 8, 1, NULL, NULL, 0, 0),
(1267, '00:00', '00:00', '0', NULL, NULL, 144, 10, 1, NULL, NULL, 0, 0),
(1268, '00:00', '00:00', '0', NULL, NULL, 145, 1, 1, NULL, NULL, 0, 0),
(1269, '00:00', '00:00', '0', NULL, NULL, 145, 2, 1, NULL, NULL, 0, 0),
(1270, '00:00', '00:00', '0', NULL, NULL, 145, 3, 1, NULL, NULL, 0, 0),
(1271, '00:00', '00:00', '0', NULL, NULL, 145, 4, 1, NULL, NULL, 0, 0),
(1272, '00:00', '00:00', '0', NULL, NULL, 145, 5, 1, NULL, NULL, 0, 0),
(1273, '00:00', '00:00', '0', NULL, NULL, 145, 6, 1, NULL, NULL, 0, 0),
(1274, '00:00', '00:00', '0', NULL, NULL, 145, 7, 1, NULL, NULL, 0, 0),
(1275, '00:00', '00:00', '0', NULL, NULL, 145, 8, 1, NULL, NULL, 0, 0),
(1276, '00:00', '00:00', '0', NULL, NULL, 145, 10, 1, NULL, NULL, 0, 0),
(1277, '00:00', '00:00', '0', NULL, NULL, 146, 1, 1, NULL, NULL, 0, 0),
(1278, '00:00', '00:00', '0', NULL, NULL, 146, 2, 1, NULL, NULL, 0, 0),
(1279, '00:00', '00:00', '0', NULL, NULL, 146, 3, 1, NULL, NULL, 0, 0),
(1280, '00:00', '00:00', '0', NULL, NULL, 146, 4, 1, NULL, NULL, 0, 0),
(1281, '00:00', '00:00', '0', NULL, NULL, 146, 5, 1, NULL, NULL, 0, 0),
(1282, '00:00', '00:00', '0', NULL, NULL, 146, 6, 1, NULL, NULL, 0, 0),
(1283, '00:00', '00:00', '0', NULL, NULL, 146, 7, 1, NULL, NULL, 0, 0),
(1284, '00:00', '00:00', '0', NULL, NULL, 146, 8, 1, NULL, NULL, 0, 0),
(1285, '00:00', '00:00', '0', NULL, NULL, 146, 10, 1, NULL, NULL, 0, 0),
(1286, '00:00', '00:00', '0', NULL, NULL, 147, 1, 1, NULL, NULL, 0, 0),
(1287, '00:00', '00:00', '0', NULL, NULL, 147, 2, 1, NULL, NULL, 0, 0),
(1288, '00:00', '38:25', '0', '2018-07-17', NULL, 147, 3, 2, '07:00:24', '07:38:49', 6, 0),
(1289, '00:00', '00:00', '0', NULL, NULL, 147, 4, 1, NULL, NULL, 0, 0),
(1290, '00:00', '00:00', '0', NULL, NULL, 147, 5, 1, NULL, NULL, 0, 0),
(1291, '00:00', '00:00', '0', NULL, NULL, 147, 6, 1, NULL, NULL, 0, 0),
(1292, '00:00', '00:00', '0', NULL, NULL, 147, 7, 1, NULL, NULL, 0, 0),
(1293, '00:00', '00:00', '0', NULL, NULL, 147, 8, 1, NULL, NULL, 0, 0),
(1294, '00:00', '00:00', '0', NULL, NULL, 147, 9, 1, NULL, NULL, 0, 0),
(1295, '00:00', '00:00', '0', NULL, NULL, 147, 10, 1, NULL, NULL, 0, 0),
(1296, '00:00', '00:00', '0', NULL, NULL, 148, 1, 1, NULL, NULL, 0, 0),
(1297, '00:00', '00:00', '0', NULL, NULL, 148, 2, 1, NULL, NULL, 0, 0),
(1298, '00:00', '00:00', '0', NULL, NULL, 148, 3, 1, NULL, NULL, 0, 0),
(1299, '00:00', '00:00', '0', NULL, NULL, 148, 4, 1, NULL, NULL, 0, 0),
(1300, '00:00', '00:00', '0', NULL, NULL, 148, 5, 1, NULL, NULL, 0, 0),
(1301, '00:00', '00:00', '0', NULL, NULL, 148, 6, 1, NULL, NULL, 0, 0),
(1302, '00:00', '00:00', '0', NULL, NULL, 148, 7, 1, NULL, NULL, 0, 0),
(1303, '00:00', '00:00', '0', NULL, NULL, 148, 8, 1, NULL, NULL, 0, 0),
(1304, '00:00', '00:00', '0', NULL, NULL, 148, 10, 1, NULL, NULL, 0, 0),
(1305, '00:00', '00:00', '0', NULL, NULL, 149, 1, 1, NULL, NULL, 0, 0),
(1306, '00:00', '00:00', '0', NULL, NULL, 149, 2, 1, NULL, NULL, 0, 0),
(1307, '00:00', '00:00', '0', NULL, NULL, 149, 3, 1, NULL, NULL, 0, 0),
(1308, '00:00', '00:00', '0', NULL, NULL, 149, 4, 1, NULL, NULL, 0, 0),
(1309, '00:00', '00:00', '0', NULL, NULL, 149, 5, 1, NULL, NULL, 0, 0),
(1310, '00:00', '00:00', '0', NULL, NULL, 149, 6, 1, NULL, NULL, 0, 0),
(1311, '00:00', '00:00', '0', NULL, NULL, 149, 7, 1, NULL, NULL, 0, 0),
(1312, '00:00', '00:00', '0', NULL, NULL, 149, 8, 1, NULL, NULL, 0, 0),
(1313, '00:00', '00:00', '0', NULL, NULL, 149, 9, 1, NULL, NULL, 0, 0),
(1314, '00:00', '00:00', '0', NULL, NULL, 149, 10, 1, NULL, NULL, 0, 0),
(1315, '00:00', '00:00', '0', NULL, NULL, 150, 1, 1, NULL, NULL, 0, 0),
(1316, '00:00', '00:00', '0', NULL, NULL, 150, 3, 1, NULL, NULL, 0, 0),
(1317, '00:00', '00:00', '0', NULL, NULL, 150, 4, 1, NULL, NULL, 0, 0),
(1318, '00:00', '00:00', '0', NULL, NULL, 150, 5, 1, NULL, NULL, 0, 0),
(1319, '00:00', '00:00', '0', NULL, NULL, 150, 6, 1, NULL, NULL, 0, 0),
(1320, '00:00', '00:00', '0', NULL, NULL, 150, 7, 1, NULL, NULL, 0, 0),
(1321, '00:00', '00:00', '0', NULL, NULL, 150, 8, 1, NULL, NULL, 0, 0),
(1322, '00:00', '00:00', '0', NULL, NULL, 150, 10, 1, NULL, NULL, 0, 0),
(1323, '00:00', '00:00', '0', NULL, NULL, 151, 1, 1, NULL, NULL, 0, 0),
(1324, '00:00', '00:00', '0', NULL, NULL, 151, 2, 1, NULL, NULL, 0, 0),
(1325, '00:00', '00:00', '0', NULL, NULL, 151, 3, 1, NULL, NULL, 0, 0),
(1326, '00:00', '00:00', '0', NULL, NULL, 151, 4, 1, NULL, NULL, 0, 0),
(1327, '00:00', '00:00', '0', NULL, NULL, 151, 5, 1, NULL, NULL, 0, 0),
(1328, '00:00', '00:00', '0', NULL, NULL, 151, 6, 1, NULL, NULL, 0, 0),
(1329, '00:00', '00:00', '0', NULL, NULL, 151, 7, 1, NULL, NULL, 0, 0),
(1330, '00:00', '00:00', '0', NULL, NULL, 151, 8, 1, NULL, NULL, 0, 0),
(1331, '00:00', '00:00', '0', NULL, NULL, 151, 10, 1, NULL, NULL, 0, 0),
(1332, '00:00', '01:11', '0', '2018-07-13', NULL, 152, 1, 2, '14:50:31', '14:50:56', 5, 0),
(1333, '04:42', '23:33', '5', '2018-07-16', '2018-07-16', 152, 3, 3, '07:06:33', '07:30:06', 0, 0),
(1334, '00:00', '00:00', '0', NULL, NULL, 152, 4, 1, NULL, NULL, 0, 0),
(1335, '00:00', '00:00', '0', NULL, NULL, 152, 5, 1, NULL, NULL, 0, 0),
(1336, '00:00', '00:00', '0', NULL, NULL, 152, 6, 1, NULL, NULL, 0, 0),
(1337, '00:00', '00:00', '0', NULL, NULL, 152, 7, 1, NULL, NULL, 0, 0),
(1338, '00:00', '00:00', '0', NULL, NULL, 152, 8, 1, NULL, NULL, 0, 0),
(1339, '00:00', '00:00', '0', NULL, NULL, 152, 10, 1, NULL, NULL, 0, 0),
(1340, '00:00', '00:00', '0', NULL, NULL, 153, 1, 1, NULL, NULL, 0, 0),
(1341, '00:00', '00:00', '0', NULL, NULL, 153, 2, 1, NULL, NULL, 0, 0),
(1342, '00:00', '00:00', '0', NULL, NULL, 153, 3, 1, NULL, NULL, 0, 0),
(1343, '00:00', '00:00', '0', NULL, NULL, 153, 4, 1, NULL, NULL, 0, 0),
(1344, '00:00', '00:00', '0', NULL, NULL, 153, 5, 1, NULL, NULL, 0, 0),
(1345, '00:00', '00:00', '0', '2018-07-17', NULL, 153, 6, 3, '09:31:20', NULL, 0, 0),
(1346, '00:00', '00:00', '0', NULL, NULL, 153, 7, 1, NULL, NULL, 0, 0),
(1347, '00:00', '00:00', '0', NULL, NULL, 153, 8, 1, NULL, NULL, 0, 0),
(1348, '00:00', '00:00', '0', NULL, NULL, 153, 10, 1, NULL, NULL, 0, 0),
(1349, '00:00', '00:00', '0', NULL, NULL, 154, 1, 1, NULL, NULL, 0, 0),
(1350, '00:00', '00:00', '0', NULL, NULL, 154, 2, 1, NULL, NULL, 0, 0),
(1351, '00:00', '00:00', '0', NULL, NULL, 154, 3, 1, NULL, NULL, 0, 0),
(1352, '10:19', '20:39', '2', '2018-07-17', '2018-07-17', 154, 4, 3, '10:19:02', '10:39:41', 0, 0),
(1353, '00:00', '00:00', '0', NULL, NULL, 154, 5, 1, NULL, NULL, 0, 0),
(1354, '24:12', '48:24', '2', '2018-07-17', '2018-07-17', 154, 6, 3, '11:43:21', '12:31:45', 0, 0),
(1355, '00:00', '00:00', '0', NULL, NULL, 154, 7, 1, NULL, NULL, 0, 0),
(1356, '00:00', '00:00', '0', NULL, NULL, 154, 8, 1, NULL, NULL, 0, 0),
(1357, '00:00', '00:00', '0', NULL, NULL, 154, 10, 1, NULL, NULL, 0, 0),
(1358, '00:00', '00:00', '0', NULL, NULL, 155, 1, 1, NULL, NULL, 0, 0),
(1359, '00:00', '00:00', '0', NULL, NULL, 155, 2, 1, NULL, NULL, 0, 0),
(1360, '00:00', '00:00', '0', NULL, NULL, 155, 3, 1, NULL, NULL, 0, 0),
(1361, '00:00', '00:00', '0', NULL, NULL, 155, 4, 1, NULL, NULL, 0, 0),
(1362, '00:00', '00:00', '0', NULL, NULL, 155, 5, 1, NULL, NULL, 0, 0),
(1363, '00:00', '00:00', '0', '2018-07-17', NULL, 155, 6, 3, '11:03:17', NULL, 0, 1),
(1364, '00:00', '00:00', '0', NULL, NULL, 155, 7, 1, NULL, NULL, 0, 0),
(1365, '00:00', '00:00', '0', NULL, NULL, 155, 8, 1, NULL, NULL, 0, 0),
(1366, '00:00', '00:00', '0', NULL, NULL, 155, 10, 1, NULL, NULL, 0, 0),
(1367, '00:00', '00:00', '0', NULL, NULL, 156, 1, 1, NULL, NULL, 0, 0),
(1368, '00:00', '00:00', '0', NULL, NULL, 156, 2, 1, NULL, NULL, 0, 0),
(1369, '00:00', '00:00', '0', NULL, NULL, 156, 3, 1, NULL, NULL, 0, 0),
(1370, '00:00', '00:00', '0', NULL, NULL, 156, 4, 1, NULL, NULL, 0, 0),
(1371, '00:00', '00:00', '0', NULL, NULL, 156, 5, 1, NULL, NULL, 0, 0),
(1372, '42:33', '85:06', '2', '2018-07-17', '2018-07-17', 156, 6, 3, '13:50:20', '15:15:26', 0, 0),
(1373, '00:00', '00:00', '0', NULL, NULL, 156, 7, 1, NULL, NULL, 0, 0),
(1374, '00:00', '00:00', '0', NULL, NULL, 156, 8, 1, NULL, NULL, 0, 0),
(1375, '00:00', '00:00', '0', NULL, NULL, 156, 10, 1, NULL, NULL, 0, 0),
(1376, '00:00', '00:00', '0', NULL, NULL, 157, 1, 1, NULL, NULL, 0, 0),
(1377, '00:00', '00:00', '0', NULL, NULL, 157, 3, 1, NULL, NULL, 0, 0),
(1378, '00:00', '51:54', '0', '2018-07-17', NULL, 157, 4, 2, '11:33:06', '06:41:12', 200, 0),
(1379, '00:00', '00:00', '0', NULL, NULL, 157, 5, 1, NULL, NULL, 0, 0),
(1380, '00:00', '00:00', '0', NULL, NULL, 157, 6, 1, NULL, NULL, 0, 0),
(1381, '00:00', '00:00', '0', NULL, NULL, 157, 7, 1, NULL, NULL, 0, 0),
(1382, '00:00', '00:00', '0', NULL, NULL, 157, 8, 1, NULL, NULL, 0, 0),
(1383, '00:00', '00:00', '0', NULL, NULL, 157, 10, 1, NULL, NULL, 0, 0),
(1384, '00:00', '00:00', '0', NULL, NULL, 158, 1, 1, NULL, NULL, 0, 0),
(1385, '00:00', '00:00', '0', NULL, NULL, 158, 2, 1, NULL, NULL, 0, 0),
(1386, '00:00', '00:00', '0', NULL, NULL, 158, 3, 1, NULL, NULL, 0, 0),
(1387, '01:01', '06:09', '6', '2018-07-18', '2018-07-18', 158, 4, 3, '06:51:09', '06:57:18', 0, 0),
(1388, '00:00', '00:00', '0', NULL, NULL, 158, 5, 1, NULL, NULL, 0, 0),
(1389, '00:00', '00:00', '0', NULL, NULL, 158, 6, 1, NULL, NULL, 0, 0),
(1390, '00:00', '00:00', '0', NULL, NULL, 158, 7, 1, NULL, NULL, 0, 0),
(1391, '00:00', '00:00', '0', NULL, NULL, 158, 8, 1, NULL, NULL, 0, 0),
(1392, '00:00', '00:00', '0', NULL, NULL, 158, 10, 1, NULL, NULL, 0, 0),
(1393, '00:00', '00:00', '0', NULL, NULL, 159, 1, 1, NULL, NULL, 0, 0),
(1394, '00:00', '00:00', '0', NULL, NULL, 159, 3, 1, NULL, NULL, 0, 0),
(1395, '00:00', '00:00', '0', NULL, NULL, 159, 4, 1, NULL, NULL, 0, 0),
(1396, '00:00', '00:00', '0', NULL, NULL, 159, 5, 1, NULL, NULL, 0, 0),
(1397, '01:04', '108:09', '100', '2018-07-27', '2018-07-27', 159, 6, 3, '04:07:24', '05:55:33', 0, 0),
(1398, '00:00', '00:00', '0', NULL, NULL, 159, 7, 1, NULL, NULL, 0, 0),
(1399, '00:00', '00:00', '0', NULL, NULL, 159, 8, 1, NULL, NULL, 0, 0),
(1400, '00:00', '00:00', '0', NULL, NULL, 159, 10, 1, NULL, NULL, 0, 0),
(1401, '00:00', '00:00', '0', NULL, NULL, 160, 1, 1, NULL, NULL, 0, 0),
(1402, '00:00', '00:00', '0', NULL, NULL, 160, 3, 1, NULL, NULL, 0, 0),
(1403, '00:00', '00:00', '0', NULL, NULL, 160, 4, 1, NULL, NULL, 0, 0),
(1404, '00:00', '00:00', '0', NULL, NULL, 160, 5, 1, NULL, NULL, 0, 0),
(1405, '03:20', '33:28', '10', '2018-07-23', '2018-07-23', 160, 6, 3, '11:13:00', '11:46:28', 0, 0),
(1406, '00:00', '00:00', '0', NULL, NULL, 160, 7, 1, NULL, NULL, 0, 0),
(1407, '00:00', '00:00', '0', NULL, NULL, 160, 8, 1, NULL, NULL, 0, 0),
(1408, '00:00', '00:00', '0', NULL, NULL, 160, 10, 1, NULL, NULL, 0, 0),
(1409, '00:00', '00:00', '0', NULL, NULL, 161, 1, 1, NULL, NULL, 0, 0),
(1410, '00:00', '00:00', '0', NULL, NULL, 161, 2, 1, NULL, NULL, 0, 0),
(1411, '00:00', '00:00', '0', NULL, NULL, 161, 3, 1, NULL, NULL, 0, 0),
(1412, '00:00', '00:00', '0', NULL, NULL, 161, 4, 1, NULL, NULL, 0, 0),
(1413, '00:00', '00:00', '0', NULL, NULL, 161, 5, 1, NULL, NULL, 0, 0),
(1414, '00:00', '88:21', '0', '2018-07-26', NULL, 161, 6, 4, '10:53:44', NULL, 2, 1),
(1415, '00:00', '00:00', '0', NULL, NULL, 161, 7, 1, NULL, NULL, 0, 0),
(1416, '00:00', '00:00', '0', NULL, NULL, 161, 8, 1, NULL, NULL, 0, 0),
(1417, '00:00', '00:00', '0', NULL, NULL, 161, 10, 1, NULL, NULL, 0, 0),
(1418, '00:00', '00:00', '0', NULL, NULL, 162, 1, 1, NULL, NULL, 0, 0),
(1419, '00:00', '00:00', '0', NULL, NULL, 162, 3, 1, NULL, NULL, 0, 0),
(1420, '00:00', '00:00', '0', NULL, NULL, 162, 4, 1, NULL, NULL, 0, 0),
(1421, '00:00', '00:00', '0', NULL, NULL, 162, 5, 1, NULL, NULL, 0, 0),
(1422, '02:02', '40:57', '20', '2018-07-25', '2018-07-25', 162, 6, 3, '10:19:24', '10:55:28', 0, 0),
(1423, '00:00', '00:00', '0', NULL, NULL, 162, 7, 1, NULL, NULL, 0, 0),
(1424, '00:00', '00:00', '0', NULL, NULL, 162, 8, 1, NULL, NULL, 0, 0),
(1425, '00:00', '00:00', '0', NULL, NULL, 162, 10, 1, NULL, NULL, 0, 0),
(1426, '00:00', '00:00', '0', NULL, NULL, 163, 1, 1, NULL, NULL, 0, 0),
(1427, '00:00', '00:00', '0', NULL, NULL, 163, 2, 1, NULL, NULL, 0, 0),
(1428, '00:00', '00:00', '0', NULL, NULL, 163, 3, 1, NULL, NULL, 0, 0),
(1429, '00:00', '00:00', '0', NULL, NULL, 163, 4, 1, NULL, NULL, 0, 0),
(1430, '00:00', '00:00', '0', NULL, NULL, 163, 5, 1, NULL, NULL, 0, 0),
(1431, '00:00', '00:00', '0', NULL, NULL, 163, 6, 1, NULL, NULL, 0, 0),
(1432, '00:00', '00:00', '0', NULL, NULL, 163, 7, 1, NULL, NULL, 0, 0),
(1433, '00:00', '00:00', '0', NULL, NULL, 163, 8, 1, NULL, NULL, 0, 0),
(1434, '00:00', '00:00', '0', NULL, NULL, 163, 10, 1, NULL, NULL, 0, 0),
(1435, '08:31', '08:31', '1', '2018-07-16', '2018-07-16', 164, 1, 3, '15:23:31', '15:32:02', 0, 0),
(1436, '00:00', '180:00', '1', '2018-07-17', '2018-07-17', 164, 2, 3, '09:00:00', '11:00:00', 0, 0),
(1437, '00:00', '45:00', '1', '2018-07-17', '2018-07-17', 164, 3, 3, '11:03:12', '12:00:00', 0, 0),
(1438, '30:16', '30:16', '1', '2018-07-17', '2018-07-18', 164, 4, 3, '16:06:41', '06:36:25', 0, 0),
(1439, '00:00', '00:00', '0', NULL, NULL, 164, 5, 1, NULL, NULL, 0, 0),
(1440, '00:00', '00:00', '0', NULL, NULL, 164, 6, 1, NULL, NULL, 0, 0),
(1441, '00:00', '00:00', '0', NULL, NULL, 164, 7, 1, NULL, NULL, 0, 0),
(1442, '00:00', '00:00', '0', NULL, NULL, 164, 8, 1, NULL, NULL, 0, 0),
(1443, '00:00', '00:00', '0', NULL, NULL, 164, 10, 1, NULL, NULL, 0, 0),
(1444, '40:21', '40:21', '1', '2018-07-16', '2018-07-16', 165, 1, 3, '09:30:07', '10:10:28', 0, 0),
(1445, '00:00', '00:00', '0', NULL, NULL, 165, 2, 1, NULL, NULL, 0, 0),
(1446, '00:00', '00:00', '0', NULL, NULL, 165, 3, 1, NULL, NULL, 0, 0),
(1447, '00:00', '00:00', '0', NULL, NULL, 165, 4, 1, NULL, NULL, 0, 0),
(1448, '00:00', '00:00', '0', NULL, NULL, 165, 5, 1, NULL, NULL, 0, 0),
(1449, '00:00', '00:00', '0', NULL, NULL, 165, 6, 1, NULL, NULL, 0, 0),
(1450, '00:00', '00:00', '0', NULL, NULL, 165, 7, 1, NULL, NULL, 0, 0),
(1451, '00:00', '00:00', '0', NULL, NULL, 165, 8, 1, NULL, NULL, 0, 0),
(1452, '00:00', '00:00', '0', NULL, NULL, 165, 10, 1, NULL, NULL, 0, 0),
(1453, '29:49', '119:19', '4', '2018-07-16', '2018-07-16', 166, 1, 3, '11:13:08', '13:12:27', 0, 0),
(1454, '00:00', '180:35', '4', '2018-07-16', '2018-07-16', 166, 2, 3, '11:23:00', '14:47:00', 0, 0),
(1455, '00:00', '10:50', '4', '2018-07-16', '2018-07-16', 166, 3, 3, '14:53:00', '15:04:07', 0, 0),
(1456, '43:58', '175:53', '4', '2018-07-17', '2018-07-17', 166, 4, 3, '06:10:39', '09:06:32', 0, 0),
(1457, '00:00', '15:00', '4', '2018-07-17', '2018-07-17', 166, 5, 3, '09:30:00', '09:16:00', 0, 0),
(1458, '00:00', '32:37', '0', '2018-07-17', NULL, 166, 6, 2, '11:03:32', '11:36:09', 4, 0),
(1459, '00:00', '00:00', '0', NULL, NULL, 166, 7, 1, NULL, NULL, 0, 0),
(1460, '00:00', '00:00', '0', NULL, NULL, 166, 8, 1, NULL, NULL, 0, 0),
(1461, '00:00', '00:00', '0', NULL, NULL, 166, 10, 1, NULL, NULL, 0, 0),
(1462, '00:48', '19:21', '24', '2018-07-17', '2018-07-18', 167, 1, 3, '16:04:28', '06:45:07', 0, 0),
(1463, '00:00', '57:50', '0', '2018-07-18', NULL, 167, 2, 2, '09:31:25', '09:32:08', 24, 0),
(1464, '00:00', '00:00', '0', NULL, NULL, 167, 3, 1, NULL, NULL, 0, 0),
(1465, '00:00', '00:00', '0', NULL, NULL, 167, 4, 1, NULL, NULL, 0, 0),
(1466, '00:00', '00:00', '0', NULL, NULL, 167, 5, 1, NULL, NULL, 0, 0),
(1467, '00:00', '00:00', '0', NULL, NULL, 167, 6, 1, NULL, NULL, 0, 0),
(1468, '00:00', '00:00', '0', NULL, NULL, 167, 7, 1, NULL, NULL, 0, 0),
(1469, '00:00', '00:00', '0', NULL, NULL, 167, 8, 1, NULL, NULL, 0, 0),
(1470, '00:00', '00:00', '0', NULL, NULL, 167, 10, 1, NULL, NULL, 0, 0),
(1471, '01:45', '08:48', '5', '2018-07-16', '2018-07-16', 168, 1, 3, '15:23:25', '15:32:13', 0, 0),
(1472, '00:00', '180:00', '5', '2018-07-17', '2018-07-17', 168, 2, 3, '07:00:00', '10:00:00', 0, 0),
(1473, '00:00', '45:00', '5', '2018-07-17', '2018-07-17', 168, 3, 3, '11:03:02', '12:00:00', 0, 0),
(1474, '05:13', '26:05', '5', '2018-07-17', '2018-07-18', 168, 4, 3, '16:06:21', '06:40:16', 0, 0),
(1475, '00:04', '00:23', '5', '2018-07-18', '2018-07-18', 168, 5, 3, '06:54:10', '06:54:33', 0, 0),
(1476, '31:55', '159:37', '5', '2018-07-18', '2018-07-18', 168, 6, 3, '09:49:52', '09:53:33', 0, 0),
(1477, '00:00', '00:00', '0', NULL, NULL, 168, 7, 1, NULL, NULL, 0, 0),
(1478, '00:00', '00:00', '0', NULL, NULL, 168, 8, 1, NULL, NULL, 0, 0),
(1479, '00:00', '00:00', '0', NULL, NULL, 168, 10, 1, NULL, NULL, 0, 0),
(1480, '00:00', '00:00', '0', NULL, NULL, 169, 1, 1, NULL, NULL, 0, 0),
(1481, '00:00', '00:00', '0', NULL, NULL, 169, 2, 1, NULL, NULL, 0, 0),
(1482, '00:00', '00:00', '0', NULL, NULL, 169, 3, 1, NULL, NULL, 0, 0),
(1483, '00:00', '00:00', '0', NULL, NULL, 169, 4, 1, NULL, NULL, 0, 0),
(1484, '00:00', '00:00', '0', NULL, NULL, 169, 5, 1, NULL, NULL, 0, 0),
(1485, '14:45', '88:34', '6', '2018-07-26', '2018-07-26', 169, 6, 3, '10:52:25', '10:53:07', 0, 0),
(1486, '00:00', '00:00', '0', NULL, NULL, 169, 7, 1, NULL, NULL, 0, 0),
(1487, '00:00', '00:00', '0', NULL, NULL, 169, 8, 1, NULL, NULL, 0, 0),
(1488, '00:00', '00:00', '0', NULL, NULL, 169, 10, 1, NULL, NULL, 0, 0),
(1489, '03:33', '07:06', '2', '2018-07-17', '2018-07-17', 170, 1, 3, '13:48:22', '13:55:28', 0, 0),
(1490, '00:00', '00:00', '0', NULL, NULL, 170, 2, 1, NULL, NULL, 0, 0),
(1491, '00:00', '03:21', '0', '2018-07-18', NULL, 170, 3, 2, '07:03:01', '07:06:22', 2, 0),
(1492, '00:00', '00:00', '0', NULL, NULL, 170, 4, 1, NULL, NULL, 0, 0),
(1493, '00:00', '00:00', '0', NULL, NULL, 170, 5, 1, NULL, NULL, 0, 0),
(1494, '00:00', '00:00', '0', NULL, NULL, 170, 6, 1, NULL, NULL, 0, 0),
(1495, '00:00', '00:00', '0', NULL, NULL, 170, 7, 1, NULL, NULL, 0, 0),
(1496, '00:00', '00:00', '0', NULL, NULL, 170, 8, 1, NULL, NULL, 0, 0),
(1497, '00:00', '00:00', '0', NULL, NULL, 170, 10, 1, NULL, NULL, 0, 0),
(1498, '00:00', '00:00', '0', NULL, NULL, 171, 1, 1, NULL, NULL, 0, 0),
(1499, '00:00', '00:00', '0', NULL, NULL, 171, 2, 1, NULL, NULL, 0, 0),
(1500, '00:00', '00:00', '0', NULL, NULL, 171, 3, 1, NULL, NULL, 0, 0),
(1501, '00:00', '00:00', '0', NULL, NULL, 171, 4, 1, NULL, NULL, 0, 0),
(1502, '00:00', '00:00', '0', NULL, NULL, 171, 5, 1, NULL, NULL, 0, 0),
(1503, '00:00', '00:00', '0', NULL, NULL, 171, 6, 1, NULL, NULL, 0, 0),
(1504, '00:00', '00:00', '0', NULL, NULL, 171, 7, 1, NULL, NULL, 0, 0),
(1505, '00:00', '00:00', '0', NULL, NULL, 171, 8, 1, NULL, NULL, 0, 0),
(1506, '00:00', '00:00', '0', NULL, NULL, 171, 10, 1, NULL, NULL, 0, 0),
(1507, '00:00', '20:24', '0', '2018-07-19', NULL, 172, 1, 2, '16:13:18', '16:17:06', 2, 0),
(1508, '00:00', '00:00', '0', NULL, NULL, 172, 3, 1, NULL, NULL, 0, 0),
(1509, '00:00', '00:00', '0', NULL, NULL, 172, 4, 1, NULL, NULL, 0, 0),
(1510, '00:00', '00:00', '0', NULL, NULL, 172, 5, 1, NULL, NULL, 0, 0),
(1511, '00:00', '00:00', '0', NULL, NULL, 172, 6, 1, NULL, NULL, 0, 0),
(1512, '00:00', '00:00', '0', NULL, NULL, 172, 7, 1, NULL, NULL, 0, 0),
(1513, '00:00', '00:00', '0', NULL, NULL, 172, 8, 1, NULL, NULL, 0, 0),
(1514, '00:00', '00:00', '0', NULL, NULL, 172, 10, 1, NULL, NULL, 0, 0),
(1515, '00:00', '00:00', '0', NULL, NULL, 173, 1, 1, NULL, NULL, 0, 0),
(1516, '00:00', '00:00', '0', NULL, NULL, 173, 2, 1, NULL, NULL, 0, 0),
(1517, '00:00', '00:00', '0', NULL, NULL, 173, 3, 1, NULL, NULL, 0, 0),
(1518, '00:00', '00:00', '0', NULL, NULL, 173, 4, 1, NULL, NULL, 0, 0),
(1519, '00:00', '00:00', '0', NULL, NULL, 173, 5, 1, NULL, NULL, 0, 0),
(1520, '00:00', '00:00', '0', NULL, NULL, 173, 7, 1, NULL, NULL, 0, 0),
(1521, '00:00', '00:00', '0', NULL, NULL, 173, 8, 1, NULL, NULL, 0, 0),
(1522, '00:00', '00:00', '0', NULL, NULL, 173, 10, 1, NULL, NULL, 0, 0),
(1523, '00:00', '00:00', '0', NULL, NULL, 174, 1, 1, NULL, NULL, 0, 0),
(1524, '00:00', '00:00', '0', NULL, NULL, 174, 3, 1, NULL, NULL, 0, 0),
(1525, '00:00', '00:00', '0', NULL, NULL, 174, 4, 1, NULL, NULL, 0, 0),
(1526, '00:00', '00:00', '0', NULL, NULL, 174, 5, 1, NULL, NULL, 0, 0),
(1527, '00:00', '00:00', '0', NULL, NULL, 174, 6, 1, NULL, NULL, 0, 0),
(1528, '00:00', '00:00', '0', NULL, NULL, 174, 7, 1, NULL, NULL, 0, 0),
(1529, '00:00', '00:00', '0', NULL, NULL, 174, 8, 1, NULL, NULL, 0, 0),
(1530, '00:00', '00:00', '0', NULL, NULL, 174, 10, 1, NULL, NULL, 0, 0),
(1531, '00:00', '00:00', '0', NULL, NULL, 175, 1, 1, NULL, NULL, 0, 0),
(1532, '00:00', '00:00', '0', NULL, NULL, 175, 3, 1, NULL, NULL, 0, 0),
(1533, '00:00', '00:00', '0', NULL, NULL, 175, 4, 1, NULL, NULL, 0, 0),
(1534, '00:00', '00:00', '0', NULL, NULL, 175, 5, 1, NULL, NULL, 0, 0),
(1535, '00:00', '00:00', '0', NULL, NULL, 175, 6, 1, NULL, NULL, 0, 0),
(1536, '00:00', '00:00', '0', NULL, NULL, 175, 7, 1, NULL, NULL, 0, 0),
(1537, '00:00', '00:00', '0', NULL, NULL, 175, 8, 1, NULL, NULL, 0, 0),
(1538, '00:00', '00:00', '0', NULL, NULL, 175, 10, 1, NULL, NULL, 0, 0),
(1539, '00:00', '00:00', '0', NULL, NULL, 176, 1, 1, NULL, NULL, 0, 0),
(1540, '00:00', '00:00', '0', NULL, NULL, 176, 3, 1, NULL, NULL, 0, 0),
(1541, '00:00', '00:00', '0', NULL, NULL, 176, 4, 1, NULL, NULL, 0, 0),
(1542, '00:00', '00:00', '0', NULL, NULL, 176, 5, 1, NULL, NULL, 0, 0),
(1543, '00:00', '00:00', '0', NULL, NULL, 176, 6, 1, NULL, NULL, 0, 0),
(1544, '00:00', '00:00', '0', NULL, NULL, 176, 7, 1, NULL, NULL, 0, 0),
(1545, '00:00', '00:00', '0', NULL, NULL, 176, 8, 1, NULL, NULL, 0, 0),
(1546, '00:00', '00:00', '0', NULL, NULL, 176, 10, 1, NULL, NULL, 0, 0),
(1547, '00:00', '00:00', '0', NULL, NULL, 177, 1, 1, NULL, NULL, 0, 0),
(1548, '00:00', '00:00', '0', NULL, NULL, 177, 2, 1, NULL, NULL, 0, 0),
(1549, '00:00', '00:00', '0', NULL, NULL, 177, 3, 1, NULL, NULL, 0, 0),
(1550, '00:00', '00:00', '0', NULL, NULL, 177, 4, 1, NULL, NULL, 0, 0),
(1551, '00:00', '00:00', '0', NULL, NULL, 177, 5, 1, NULL, NULL, 0, 0),
(1552, '00:00', '00:00', '0', NULL, NULL, 177, 6, 1, NULL, NULL, 0, 0),
(1553, '00:00', '00:00', '0', NULL, NULL, 177, 7, 1, NULL, NULL, 0, 0),
(1554, '00:00', '00:00', '0', NULL, NULL, 177, 8, 1, NULL, NULL, 0, 0),
(1555, '00:00', '00:00', '0', NULL, NULL, 177, 10, 1, NULL, NULL, 0, 0),
(1556, '00:00', '00:00', '0', NULL, NULL, 178, 1, 1, NULL, NULL, 0, 0),
(1557, '00:00', '00:00', '0', NULL, NULL, 178, 3, 1, NULL, NULL, 0, 0),
(1558, '00:00', '00:00', '0', NULL, NULL, 178, 4, 1, NULL, NULL, 0, 0),
(1559, '00:00', '00:00', '0', NULL, NULL, 178, 5, 1, NULL, NULL, 0, 0),
(1560, '00:00', '00:00', '0', NULL, NULL, 178, 6, 1, NULL, NULL, 0, 0),
(1561, '00:00', '00:00', '0', NULL, NULL, 178, 7, 1, NULL, NULL, 0, 0),
(1562, '00:00', '00:00', '0', NULL, NULL, 178, 8, 1, NULL, NULL, 0, 0),
(1563, '00:00', '00:00', '0', NULL, NULL, 178, 10, 1, NULL, NULL, 0, 0),
(1564, '00:00', '00:00', '0', NULL, NULL, 179, 1, 1, NULL, NULL, 0, 0),
(1565, '00:00', '00:00', '0', NULL, NULL, 179, 2, 1, NULL, NULL, 0, 0),
(1566, '00:00', '00:00', '0', NULL, NULL, 179, 3, 1, NULL, NULL, 0, 0),
(1567, '00:00', '00:00', '0', NULL, NULL, 179, 4, 1, NULL, NULL, 0, 0),
(1568, '00:00', '00:00', '0', NULL, NULL, 179, 5, 1, NULL, NULL, 0, 0),
(1569, '00:00', '00:00', '0', NULL, NULL, 179, 6, 1, NULL, NULL, 0, 0),
(1570, '00:00', '00:00', '0', NULL, NULL, 179, 7, 1, NULL, NULL, 0, 0),
(1571, '00:00', '00:00', '0', NULL, NULL, 179, 8, 1, NULL, NULL, 0, 0),
(1572, '00:00', '00:00', '0', NULL, NULL, 179, 10, 1, NULL, NULL, 0, 0),
(1573, '00:00', '00:00', '0', NULL, NULL, 180, 1, 1, NULL, NULL, 0, 0),
(1574, '00:00', '00:00', '0', NULL, NULL, 180, 3, 1, NULL, NULL, 0, 0),
(1575, '00:00', '00:00', '0', NULL, NULL, 180, 4, 1, NULL, NULL, 0, 0),
(1576, '00:00', '00:00', '0', NULL, NULL, 180, 5, 1, NULL, NULL, 0, 0),
(1577, '00:00', '00:00', '0', NULL, NULL, 180, 6, 1, NULL, NULL, 0, 0),
(1578, '00:00', '00:00', '0', NULL, NULL, 180, 7, 1, NULL, NULL, 0, 0),
(1579, '00:00', '00:00', '0', NULL, NULL, 180, 8, 1, NULL, NULL, 0, 0),
(1580, '00:00', '00:00', '0', NULL, NULL, 180, 10, 1, NULL, NULL, 0, 0),
(1581, '00:00', '00:00', '0', NULL, NULL, 181, 1, 1, NULL, NULL, 0, 0),
(1582, '00:00', '00:00', '0', NULL, NULL, 181, 2, 1, NULL, NULL, 0, 0),
(1583, '00:00', '00:00', '0', NULL, NULL, 181, 3, 1, NULL, NULL, 0, 0),
(1584, '00:00', '00:00', '0', NULL, NULL, 181, 4, 1, NULL, NULL, 0, 0),
(1585, '00:00', '00:00', '0', NULL, NULL, 181, 5, 1, NULL, NULL, 0, 0),
(1586, '00:00', '00:00', '0', '2018-07-27', NULL, 181, 6, 4, '04:03:01', NULL, 0, 1),
(1587, '00:00', '00:00', '0', NULL, NULL, 181, 7, 1, NULL, NULL, 0, 0),
(1588, '00:00', '00:00', '0', NULL, NULL, 181, 8, 1, NULL, NULL, 0, 0),
(1589, '00:00', '00:00', '0', NULL, NULL, 181, 10, 1, NULL, NULL, 0, 0),
(1590, '00:00', '00:00', '0', NULL, NULL, 182, 1, 1, NULL, NULL, 0, 0),
(1591, '00:00', '00:00', '0', NULL, NULL, 182, 3, 1, NULL, NULL, 0, 0),
(1592, '00:00', '00:00', '0', NULL, NULL, 182, 4, 1, NULL, NULL, 0, 0),
(1593, '00:00', '00:00', '0', NULL, NULL, 182, 5, 1, NULL, NULL, 0, 0),
(1594, '00:00', '00:00', '0', NULL, NULL, 182, 6, 1, NULL, NULL, 0, 0),
(1595, '00:00', '00:00', '0', NULL, NULL, 182, 7, 1, NULL, NULL, 0, 0),
(1596, '00:00', '00:00', '0', NULL, NULL, 182, 8, 1, NULL, NULL, 0, 0),
(1597, '00:00', '00:00', '0', NULL, NULL, 182, 10, 1, NULL, NULL, 0, 0),
(1598, '00:00', '00:00', '0', NULL, NULL, 183, 1, 1, NULL, NULL, 0, 0),
(1599, '00:00', '00:00', '0', NULL, NULL, 183, 2, 1, NULL, NULL, 0, 0),
(1600, '00:00', '00:00', '0', NULL, NULL, 183, 3, 1, NULL, NULL, 0, 0),
(1601, '00:00', '00:00', '0', NULL, NULL, 183, 4, 1, NULL, NULL, 0, 0),
(1602, '00:00', '00:00', '0', NULL, NULL, 183, 5, 1, NULL, NULL, 0, 0),
(1603, '08:20', '83:27', '10', '2018-07-25', '2018-07-25', 183, 6, 3, '09:55:13', '10:17:19', 0, 0),
(1604, '00:00', '00:00', '0', NULL, NULL, 183, 7, 1, NULL, NULL, 0, 0),
(1605, '00:00', '00:00', '0', NULL, NULL, 183, 8, 1, NULL, NULL, 0, 0),
(1606, '00:00', '00:00', '0', NULL, NULL, 183, 10, 1, NULL, NULL, 0, 0),
(1607, '00:00', '00:00', '0', NULL, NULL, 184, 1, 1, NULL, NULL, 0, 0),
(1608, '00:00', '00:00', '0', NULL, NULL, 184, 3, 1, NULL, NULL, 0, 0),
(1609, '00:00', '00:00', '0', NULL, NULL, 184, 4, 1, NULL, NULL, 0, 0),
(1610, '00:00', '00:00', '0', NULL, NULL, 184, 5, 1, NULL, NULL, 0, 0),
(1611, '00:00', '00:00', '0', NULL, NULL, 184, 7, 1, NULL, NULL, 0, 0),
(1612, '00:00', '00:00', '0', NULL, NULL, 184, 8, 1, NULL, NULL, 0, 0),
(1613, '00:00', '00:00', '0', NULL, NULL, 184, 10, 1, NULL, NULL, 0, 0),
(1614, '00:00', '00:00', '0', NULL, NULL, 185, 1, 1, NULL, NULL, 0, 0),
(1615, '00:00', '00:00', '0', NULL, NULL, 185, 3, 1, NULL, NULL, 0, 0),
(1616, '00:00', '00:00', '0', NULL, NULL, 185, 4, 1, NULL, NULL, 0, 0),
(1617, '00:00', '00:00', '0', NULL, NULL, 185, 5, 1, NULL, NULL, 0, 0),
(1618, '00:00', '00:00', '0', NULL, NULL, 185, 6, 1, NULL, NULL, 0, 0),
(1619, '00:00', '00:00', '0', NULL, NULL, 185, 7, 1, NULL, NULL, 0, 0),
(1620, '00:00', '00:00', '0', NULL, NULL, 185, 8, 1, NULL, NULL, 0, 0),
(1621, '00:00', '00:00', '0', NULL, NULL, 185, 10, 1, NULL, NULL, 0, 0),
(1622, '00:00', '00:00', '0', NULL, NULL, 186, 1, 1, NULL, NULL, 0, 0),
(1623, '00:00', '00:00', '0', NULL, NULL, 186, 3, 1, NULL, NULL, 0, 0),
(1624, '00:00', '00:00', '0', NULL, NULL, 186, 4, 1, NULL, NULL, 0, 0),
(1625, '00:00', '00:00', '0', NULL, NULL, 186, 5, 1, NULL, NULL, 0, 0),
(1626, '00:00', '00:00', '0', NULL, NULL, 186, 6, 1, NULL, NULL, 0, 0),
(1627, '00:00', '00:00', '0', NULL, NULL, 186, 7, 1, NULL, NULL, 0, 0),
(1628, '00:00', '00:00', '0', NULL, NULL, 186, 8, 1, NULL, NULL, 0, 0),
(1629, '00:00', '00:00', '0', NULL, NULL, 186, 9, 1, NULL, NULL, 0, 0),
(1630, '00:00', '00:00', '0', NULL, NULL, 186, 10, 1, NULL, NULL, 0, 0),
(1631, '00:00', '00:00', '0', NULL, NULL, 187, 1, 1, NULL, NULL, 0, 0),
(1632, '00:00', '00:00', '0', NULL, NULL, 187, 2, 1, NULL, NULL, 0, 0),
(1633, '00:00', '00:00', '0', NULL, NULL, 187, 3, 1, NULL, NULL, 0, 0),
(1634, '00:00', '00:00', '0', NULL, NULL, 187, 4, 1, NULL, NULL, 0, 0),
(1635, '00:00', '00:00', '0', NULL, NULL, 187, 5, 1, NULL, NULL, 0, 0),
(1636, '00:00', '00:00', '0', NULL, NULL, 187, 6, 1, NULL, NULL, 0, 0),
(1637, '00:00', '00:00', '0', NULL, NULL, 187, 7, 1, NULL, NULL, 0, 0),
(1638, '00:00', '00:00', '0', NULL, NULL, 187, 8, 1, NULL, NULL, 0, 0),
(1639, '00:00', '00:00', '0', NULL, NULL, 187, 10, 1, NULL, NULL, 0, 0),
(1640, '00:00', '00:00', '0', NULL, NULL, 188, 1, 1, NULL, NULL, 0, 0),
(1641, '00:00', '00:00', '0', NULL, NULL, 188, 3, 1, NULL, NULL, 0, 0),
(1642, '00:00', '00:00', '0', NULL, NULL, 188, 4, 1, NULL, NULL, 0, 0),
(1643, '00:00', '00:00', '0', NULL, NULL, 188, 5, 1, NULL, NULL, 0, 0),
(1644, '00:00', '00:00', '0', NULL, NULL, 188, 6, 1, NULL, NULL, 0, 0),
(1645, '00:00', '00:00', '0', NULL, NULL, 188, 7, 1, NULL, NULL, 0, 0),
(1646, '00:00', '00:00', '0', NULL, NULL, 188, 8, 1, NULL, NULL, 0, 0),
(1647, '00:00', '00:00', '0', NULL, NULL, 188, 10, 1, NULL, NULL, 0, 0),
(1648, '00:00', '00:00', '0', NULL, NULL, 189, 1, 1, NULL, NULL, 0, 0),
(1649, '00:00', '00:00', '0', NULL, NULL, 189, 2, 1, NULL, NULL, 0, 0),
(1650, '00:00', '00:00', '0', NULL, NULL, 189, 3, 1, NULL, NULL, 0, 0),
(1651, '00:00', '00:00', '0', NULL, NULL, 189, 4, 1, NULL, NULL, 0, 0),
(1652, '00:00', '00:00', '0', NULL, NULL, 189, 5, 1, NULL, NULL, 0, 0),
(1653, '00:00', '00:00', '0', NULL, NULL, 189, 6, 1, NULL, NULL, 0, 0),
(1654, '00:00', '00:00', '0', NULL, NULL, 189, 7, 1, NULL, NULL, 0, 0),
(1655, '00:00', '00:00', '0', NULL, NULL, 189, 8, 1, NULL, NULL, 0, 0),
(1656, '00:00', '00:00', '0', NULL, NULL, 189, 10, 1, NULL, NULL, 0, 0),
(1657, '00:00', '00:00', '0', NULL, NULL, 190, 1, 1, NULL, NULL, 0, 0),
(1658, '00:00', '00:00', '0', NULL, NULL, 190, 3, 1, NULL, NULL, 0, 0),
(1659, '00:00', '00:00', '0', NULL, NULL, 190, 4, 1, NULL, NULL, 0, 0),
(1660, '00:00', '00:00', '0', NULL, NULL, 190, 5, 1, NULL, NULL, 0, 0),
(1661, '00:00', '00:00', '0', NULL, NULL, 190, 6, 1, NULL, NULL, 0, 0),
(1662, '00:00', '00:00', '0', NULL, NULL, 190, 7, 1, NULL, NULL, 0, 0),
(1663, '00:00', '00:00', '0', NULL, NULL, 190, 8, 1, NULL, NULL, 0, 0),
(1664, '00:00', '00:00', '0', NULL, NULL, 190, 10, 1, NULL, NULL, 0, 0),
(1665, '00:00', '00:00', '0', NULL, NULL, 191, 1, 1, NULL, NULL, 0, 0),
(1666, '00:00', '00:00', '0', NULL, NULL, 191, 3, 1, NULL, NULL, 0, 0),
(1667, '00:00', '00:00', '0', NULL, NULL, 191, 4, 1, NULL, NULL, 0, 0),
(1668, '00:00', '00:00', '0', NULL, NULL, 191, 5, 1, NULL, NULL, 0, 0),
(1669, '00:00', '00:00', '0', NULL, NULL, 191, 6, 1, NULL, NULL, 0, 0),
(1670, '00:00', '00:00', '0', NULL, NULL, 191, 7, 1, NULL, NULL, 0, 0),
(1671, '00:00', '00:00', '0', NULL, NULL, 191, 8, 1, NULL, NULL, 0, 0),
(1672, '00:00', '00:00', '0', NULL, NULL, 191, 10, 1, NULL, NULL, 0, 0),
(1673, '00:00', '00:00', '0', NULL, NULL, 192, 1, 1, NULL, NULL, 0, 0),
(1674, '00:00', '00:00', '0', NULL, NULL, 192, 2, 1, NULL, NULL, 0, 0),
(1675, '00:00', '00:00', '0', NULL, NULL, 192, 3, 1, NULL, NULL, 0, 0),
(1676, '00:00', '00:00', '0', NULL, NULL, 192, 4, 1, NULL, NULL, 0, 0),
(1677, '00:00', '00:00', '0', NULL, NULL, 192, 5, 1, NULL, NULL, 0, 0),
(1678, '00:00', '00:00', '0', NULL, NULL, 192, 7, 1, NULL, NULL, 0, 0),
(1679, '00:00', '00:00', '0', NULL, NULL, 192, 8, 1, NULL, NULL, 0, 0),
(1680, '00:00', '00:00', '0', NULL, NULL, 192, 10, 1, NULL, NULL, 0, 0),
(1681, '00:00', '00:00', '0', NULL, NULL, 193, 1, 1, NULL, NULL, 0, 0),
(1682, '00:00', '00:00', '0', NULL, NULL, 193, 3, 1, NULL, NULL, 0, 0),
(1683, '00:00', '00:00', '0', NULL, NULL, 193, 4, 1, NULL, NULL, 0, 0),
(1684, '00:00', '00:00', '0', NULL, NULL, 193, 5, 1, NULL, NULL, 0, 0),
(1685, '00:00', '00:00', '0', NULL, NULL, 193, 6, 1, NULL, NULL, 0, 0),
(1686, '00:00', '00:00', '0', NULL, NULL, 193, 7, 1, NULL, NULL, 0, 0),
(1687, '00:00', '00:00', '0', NULL, NULL, 193, 8, 1, NULL, NULL, 0, 0),
(1688, '00:00', '00:00', '0', NULL, NULL, 193, 10, 1, NULL, NULL, 0, 0),
(1689, '00:00', '00:00', '0', NULL, NULL, 194, 1, 1, NULL, NULL, 0, 0),
(1690, '00:00', '00:00', '0', NULL, NULL, 194, 3, 1, NULL, NULL, 0, 0),
(1691, '00:00', '00:00', '0', NULL, NULL, 194, 4, 1, NULL, NULL, 0, 0),
(1692, '00:00', '00:00', '0', NULL, NULL, 194, 5, 1, NULL, NULL, 0, 0),
(1693, '00:00', '00:00', '0', NULL, NULL, 194, 6, 1, NULL, NULL, 0, 0),
(1694, '00:00', '00:00', '0', NULL, NULL, 194, 7, 1, NULL, NULL, 0, 0),
(1695, '00:00', '00:00', '0', NULL, NULL, 194, 8, 1, NULL, NULL, 0, 0),
(1696, '00:00', '00:00', '0', NULL, NULL, 194, 10, 1, NULL, NULL, 0, 0),
(1697, '00:00', '00:00', '0', NULL, NULL, 195, 1, 1, NULL, NULL, 0, 0),
(1698, '00:00', '00:00', '0', NULL, NULL, 195, 3, 1, NULL, NULL, 0, 0),
(1699, '00:00', '00:00', '0', NULL, NULL, 195, 4, 1, NULL, NULL, 0, 0),
(1700, '00:00', '00:00', '0', NULL, NULL, 195, 5, 1, NULL, NULL, 0, 0),
(1701, '00:00', '00:00', '0', NULL, NULL, 195, 6, 1, NULL, NULL, 0, 0),
(1702, '00:00', '00:00', '0', NULL, NULL, 195, 7, 1, NULL, NULL, 0, 0),
(1703, '00:00', '00:00', '0', NULL, NULL, 195, 8, 1, NULL, NULL, 0, 0),
(1704, '00:00', '00:00', '0', NULL, NULL, 195, 10, 1, NULL, NULL, 0, 0),
(1705, '00:00', '00:00', '0', NULL, NULL, 196, 1, 1, NULL, NULL, 0, 0),
(1706, '00:00', '00:00', '0', NULL, NULL, 196, 2, 1, NULL, NULL, 0, 0),
(1707, '00:00', '00:00', '0', NULL, NULL, 196, 3, 1, NULL, NULL, 0, 0),
(1708, '00:00', '00:00', '0', NULL, NULL, 196, 4, 1, NULL, NULL, 0, 0),
(1709, '00:00', '00:00', '0', NULL, NULL, 196, 5, 1, NULL, NULL, 0, 0),
(1710, '00:00', '00:00', '0', NULL, NULL, 196, 6, 1, NULL, NULL, 0, 0),
(1711, '00:00', '00:00', '0', NULL, NULL, 196, 7, 1, NULL, NULL, 0, 0),
(1712, '00:00', '00:00', '0', NULL, NULL, 196, 8, 1, NULL, NULL, 0, 0),
(1713, '00:00', '00:00', '0', NULL, NULL, 196, 10, 1, NULL, NULL, 0, 0),
(1714, '00:00', '00:00', '0', NULL, NULL, 197, 1, 1, NULL, NULL, 0, 0),
(1715, '00:00', '00:00', '0', NULL, NULL, 197, 2, 1, NULL, NULL, 0, 0),
(1716, '00:00', '00:00', '0', NULL, NULL, 197, 3, 1, NULL, NULL, 0, 0),
(1717, '00:00', '00:00', '0', NULL, NULL, 197, 4, 1, NULL, NULL, 0, 0),
(1718, '00:00', '00:00', '0', NULL, NULL, 197, 5, 1, NULL, NULL, 0, 0),
(1719, '00:00', '00:00', '0', NULL, NULL, 197, 6, 1, NULL, NULL, 0, 0),
(1720, '00:00', '00:00', '0', NULL, NULL, 197, 7, 1, NULL, NULL, 0, 0),
(1721, '00:00', '00:00', '0', NULL, NULL, 197, 8, 1, NULL, NULL, 0, 0),
(1722, '00:00', '00:00', '0', NULL, NULL, 197, 10, 1, NULL, NULL, 0, 0),
(1723, '00:00', '00:00', '0', NULL, NULL, 198, 1, 1, NULL, NULL, 0, 0),
(1724, '00:00', '00:00', '0', NULL, NULL, 198, 3, 1, NULL, NULL, 0, 0),
(1725, '00:00', '00:00', '0', NULL, NULL, 198, 4, 1, NULL, NULL, 0, 0),
(1726, '00:00', '00:00', '0', NULL, NULL, 198, 5, 1, NULL, NULL, 0, 0),
(1727, '00:00', '00:00', '0', NULL, NULL, 198, 6, 1, NULL, NULL, 0, 0),
(1728, '00:00', '00:00', '0', NULL, NULL, 198, 7, 1, NULL, NULL, 0, 0),
(1729, '00:00', '00:00', '0', NULL, NULL, 198, 8, 1, NULL, NULL, 0, 0),
(1730, '00:00', '00:00', '0', NULL, NULL, 198, 10, 1, NULL, NULL, 0, 0),
(1731, '00:00', '00:00', '0', NULL, NULL, 199, 1, 1, NULL, NULL, 0, 0),
(1732, '00:00', '00:00', '0', NULL, NULL, 199, 3, 1, NULL, NULL, 0, 0),
(1733, '00:00', '00:00', '0', NULL, NULL, 199, 4, 1, NULL, NULL, 0, 0),
(1734, '00:00', '00:00', '0', NULL, NULL, 199, 5, 1, NULL, NULL, 0, 0),
(1735, '00:00', '00:00', '0', NULL, NULL, 199, 6, 1, NULL, NULL, 0, 0),
(1736, '00:00', '00:00', '0', NULL, NULL, 199, 7, 1, NULL, NULL, 0, 0),
(1737, '00:00', '00:00', '0', NULL, NULL, 199, 8, 1, NULL, NULL, 0, 0),
(1738, '00:00', '00:00', '0', NULL, NULL, 199, 10, 1, NULL, NULL, 0, 0),
(1739, '00:00', '00:00', '0', NULL, NULL, 200, 1, 1, NULL, NULL, 0, 0),
(1740, '00:00', '00:00', '0', NULL, NULL, 200, 2, 1, NULL, NULL, 0, 0),
(1741, '00:00', '00:00', '0', NULL, NULL, 200, 3, 1, NULL, NULL, 0, 0),
(1742, '00:00', '00:00', '0', NULL, NULL, 200, 4, 1, NULL, NULL, 0, 0),
(1743, '00:00', '00:00', '0', NULL, NULL, 200, 5, 1, NULL, NULL, 0, 0),
(1744, '00:00', '00:00', '0', NULL, NULL, 200, 6, 1, NULL, NULL, 0, 0),
(1745, '00:00', '00:00', '0', NULL, NULL, 200, 7, 1, NULL, NULL, 0, 0),
(1746, '00:00', '00:00', '0', NULL, NULL, 200, 8, 1, NULL, NULL, 0, 0),
(1747, '00:00', '00:00', '0', NULL, NULL, 200, 10, 1, NULL, NULL, 0, 0),
(1748, '00:00', '00:00', '0', NULL, NULL, 201, 1, 1, NULL, NULL, 0, 0),
(1749, '00:00', '00:00', '0', NULL, NULL, 201, 3, 1, NULL, NULL, 0, 0),
(1750, '00:00', '00:00', '0', NULL, NULL, 201, 4, 1, NULL, NULL, 0, 0),
(1751, '00:00', '00:00', '0', NULL, NULL, 201, 5, 1, NULL, NULL, 0, 0),
(1752, '00:00', '00:00', '0', NULL, NULL, 201, 6, 1, NULL, NULL, 0, 0),
(1753, '00:00', '00:00', '0', NULL, NULL, 201, 7, 1, NULL, NULL, 0, 0),
(1754, '00:00', '00:00', '0', NULL, NULL, 201, 8, 1, NULL, NULL, 0, 0),
(1755, '00:00', '00:00', '0', NULL, NULL, 201, 10, 1, NULL, NULL, 0, 0),
(1756, '00:00', '00:00', '0', NULL, NULL, 202, 1, 1, NULL, NULL, 0, 0),
(1757, '00:00', '00:00', '0', NULL, NULL, 202, 3, 1, NULL, NULL, 0, 0),
(1758, '00:00', '00:00', '0', NULL, NULL, 202, 4, 1, NULL, NULL, 0, 0),
(1759, '00:00', '00:00', '0', NULL, NULL, 202, 5, 1, NULL, NULL, 0, 0),
(1760, '00:00', '00:00', '0', NULL, NULL, 202, 6, 1, NULL, NULL, 0, 0),
(1761, '00:00', '00:00', '0', NULL, NULL, 202, 7, 1, NULL, NULL, 0, 0),
(1762, '00:00', '00:00', '0', NULL, NULL, 202, 8, 1, NULL, NULL, 0, 0),
(1763, '00:00', '00:00', '0', NULL, NULL, 202, 10, 1, NULL, NULL, 0, 0),
(1764, '00:00', '00:00', '0', NULL, NULL, 203, 1, 1, NULL, NULL, 0, 0),
(1765, '00:00', '00:00', '0', NULL, NULL, 203, 3, 1, NULL, NULL, 0, 0),
(1766, '00:00', '00:00', '0', NULL, NULL, 203, 4, 1, NULL, NULL, 0, 0),
(1767, '00:00', '00:00', '0', NULL, NULL, 203, 5, 1, NULL, NULL, 0, 0),
(1768, '00:00', '00:00', '0', NULL, NULL, 203, 6, 1, NULL, NULL, 0, 0),
(1769, '00:00', '00:00', '0', NULL, NULL, 203, 7, 1, NULL, NULL, 0, 0),
(1770, '00:00', '00:00', '0', NULL, NULL, 203, 8, 1, NULL, NULL, 0, 0),
(1771, '00:00', '00:00', '0', NULL, NULL, 203, 10, 1, NULL, NULL, 0, 0),
(1772, '00:00', '00:00', '0', NULL, NULL, 204, 1, 1, NULL, NULL, 0, 0),
(1773, '00:00', '00:00', '0', NULL, NULL, 204, 3, 1, NULL, NULL, 0, 0),
(1774, '00:00', '00:00', '0', NULL, NULL, 204, 4, 1, NULL, NULL, 0, 0),
(1775, '00:00', '00:00', '0', NULL, NULL, 204, 5, 1, NULL, NULL, 0, 0),
(1776, '00:00', '00:00', '0', NULL, NULL, 204, 6, 1, NULL, NULL, 0, 0),
(1777, '00:00', '00:00', '0', NULL, NULL, 204, 7, 1, NULL, NULL, 0, 0),
(1778, '00:00', '00:00', '0', NULL, NULL, 204, 8, 1, NULL, NULL, 0, 0),
(1779, '00:00', '00:00', '0', NULL, NULL, 204, 10, 1, NULL, NULL, 0, 0),
(1780, '00:00', '00:00', '0', NULL, NULL, 205, 1, 1, NULL, NULL, 0, 0),
(1781, '00:00', '00:00', '0', NULL, NULL, 205, 3, 1, NULL, NULL, 0, 0),
(1782, '00:00', '00:00', '0', NULL, NULL, 205, 4, 1, NULL, NULL, 0, 0),
(1783, '00:00', '00:00', '0', NULL, NULL, 205, 5, 1, NULL, NULL, 0, 0),
(1784, '00:00', '00:00', '0', NULL, NULL, 205, 6, 1, NULL, NULL, 0, 0),
(1785, '00:00', '00:00', '0', NULL, NULL, 205, 7, 1, NULL, NULL, 0, 0),
(1786, '00:00', '00:00', '0', NULL, NULL, 205, 8, 1, NULL, NULL, 0, 0),
(1787, '00:00', '00:00', '0', NULL, NULL, 205, 10, 1, NULL, NULL, 0, 0),
(1788, '00:00', '00:00', '0', NULL, NULL, 206, 1, 1, NULL, NULL, 0, 0),
(1789, '00:00', '00:00', '0', NULL, NULL, 206, 2, 1, NULL, NULL, 0, 0),
(1790, '00:00', '00:00', '0', NULL, NULL, 206, 3, 1, NULL, NULL, 0, 0),
(1791, '00:00', '00:00', '0', NULL, NULL, 206, 4, 1, NULL, NULL, 0, 0),
(1792, '00:00', '00:00', '0', NULL, NULL, 206, 5, 1, NULL, NULL, 0, 0),
(1793, '00:00', '00:00', '0', NULL, NULL, 206, 6, 1, NULL, NULL, 0, 0),
(1794, '00:00', '00:00', '0', NULL, NULL, 206, 7, 1, NULL, NULL, 0, 0),
(1795, '00:00', '00:00', '0', NULL, NULL, 206, 8, 1, NULL, NULL, 0, 0),
(1796, '00:00', '00:00', '0', NULL, NULL, 206, 10, 1, NULL, NULL, 0, 0),
(1797, '00:00', '00:00', '0', NULL, NULL, 207, 1, 1, NULL, NULL, 0, 0),
(1798, '00:00', '00:00', '0', NULL, NULL, 207, 2, 1, NULL, NULL, 0, 0),
(1799, '00:00', '00:00', '0', NULL, NULL, 207, 3, 1, NULL, NULL, 0, 0),
(1800, '00:00', '00:00', '0', NULL, NULL, 207, 4, 1, NULL, NULL, 0, 0),
(1801, '00:00', '00:00', '0', NULL, NULL, 207, 5, 1, NULL, NULL, 0, 0),
(1802, '00:00', '00:00', '0', NULL, NULL, 207, 6, 1, NULL, NULL, 0, 0),
(1803, '00:00', '00:00', '0', NULL, NULL, 207, 7, 1, NULL, NULL, 0, 0),
(1804, '00:00', '00:00', '0', NULL, NULL, 207, 8, 1, NULL, NULL, 0, 0),
(1805, '00:00', '00:00', '0', NULL, NULL, 207, 10, 1, NULL, NULL, 0, 0),
(1806, '00:00', '00:00', '0', NULL, NULL, 208, 1, 1, NULL, NULL, 0, 0),
(1807, '00:00', '00:00', '0', NULL, NULL, 208, 2, 1, NULL, NULL, 0, 0),
(1808, '00:00', '00:00', '0', NULL, NULL, 208, 3, 1, NULL, NULL, 0, 0),
(1809, '00:00', '00:00', '0', NULL, NULL, 208, 4, 1, NULL, NULL, 0, 0),
(1810, '00:00', '00:00', '0', NULL, NULL, 208, 5, 1, NULL, NULL, 0, 0),
(1811, '00:00', '00:00', '0', NULL, NULL, 208, 6, 1, NULL, NULL, 0, 0),
(1812, '00:00', '00:00', '0', NULL, NULL, 208, 7, 1, NULL, NULL, 0, 0);
INSERT INTO `detalle_formato_estandar` (`idDetalle_formato_estandar`, `tiempo_por_unidad`, `tiempo_total_por_proceso`, `cantidad_terminada`, `fecha_inicio`, `fecha_fin`, `detalle_proyecto_idDetalle_proyecto`, `Procesos_idproceso`, `estado_idestado`, `hora_ejecucion`, `hora_terminacion`, `restantes`, `noperarios`) VALUES
(1813, '00:00', '00:00', '0', NULL, NULL, 208, 8, 1, NULL, NULL, 0, 0),
(1814, '00:00', '00:00', '0', NULL, NULL, 208, 10, 1, NULL, NULL, 0, 0),
(1815, '00:00', '00:00', '0', NULL, NULL, 209, 1, 1, NULL, NULL, 0, 0),
(1816, '00:00', '00:00', '0', NULL, NULL, 209, 2, 1, NULL, NULL, 0, 0),
(1817, '00:00', '00:00', '0', NULL, NULL, 209, 3, 1, NULL, NULL, 0, 0),
(1818, '00:00', '00:00', '0', NULL, NULL, 209, 4, 1, NULL, NULL, 0, 0),
(1819, '00:00', '00:00', '0', NULL, NULL, 209, 5, 1, NULL, NULL, 0, 0),
(1820, '00:00', '00:00', '0', NULL, NULL, 209, 6, 1, NULL, NULL, 0, 0),
(1821, '00:00', '00:00', '0', NULL, NULL, 209, 7, 1, NULL, NULL, 0, 0),
(1822, '00:00', '00:00', '0', NULL, NULL, 209, 8, 1, NULL, NULL, 0, 0),
(1823, '00:00', '00:00', '0', NULL, NULL, 209, 10, 1, NULL, NULL, 0, 0),
(1824, '00:00', '00:00', '0', NULL, NULL, 210, 1, 1, NULL, NULL, 0, 0),
(1825, '00:00', '00:00', '0', NULL, NULL, 210, 2, 1, NULL, NULL, 0, 0),
(1826, '00:00', '00:00', '0', NULL, NULL, 210, 3, 1, NULL, NULL, 0, 0),
(1827, '00:00', '00:00', '0', NULL, NULL, 210, 4, 1, NULL, NULL, 0, 0),
(1828, '00:00', '00:00', '0', NULL, NULL, 210, 5, 1, NULL, NULL, 0, 0),
(1829, '00:00', '00:00', '0', NULL, NULL, 210, 6, 1, NULL, NULL, 0, 0),
(1830, '00:00', '00:00', '0', NULL, NULL, 210, 7, 1, NULL, NULL, 0, 0),
(1831, '00:00', '00:00', '0', NULL, NULL, 210, 8, 1, NULL, NULL, 0, 0),
(1832, '00:00', '00:00', '0', NULL, NULL, 210, 10, 1, NULL, NULL, 0, 0),
(1833, '00:00', '00:00', '0', NULL, NULL, 211, 1, 1, NULL, NULL, 0, 0),
(1834, '00:00', '00:00', '0', NULL, NULL, 211, 2, 1, NULL, NULL, 0, 0),
(1835, '00:00', '00:00', '0', NULL, NULL, 211, 3, 1, NULL, NULL, 0, 0),
(1836, '00:00', '00:00', '0', NULL, NULL, 211, 4, 1, NULL, NULL, 0, 0),
(1837, '00:00', '00:00', '0', NULL, NULL, 211, 5, 1, NULL, NULL, 0, 0),
(1838, '00:00', '00:00', '0', NULL, NULL, 211, 6, 1, NULL, NULL, 0, 0),
(1839, '00:00', '00:00', '0', NULL, NULL, 211, 7, 1, NULL, NULL, 0, 0),
(1840, '00:00', '00:00', '0', NULL, NULL, 211, 8, 1, NULL, NULL, 0, 0),
(1841, '00:00', '00:00', '0', NULL, NULL, 211, 10, 1, NULL, NULL, 0, 0),
(1842, '00:00', '00:00', '0', NULL, NULL, 212, 1, 1, NULL, NULL, 0, 0),
(1843, '00:00', '00:00', '0', NULL, NULL, 212, 2, 1, NULL, NULL, 0, 0),
(1844, '00:00', '00:00', '0', NULL, NULL, 212, 3, 1, NULL, NULL, 0, 0),
(1845, '00:00', '00:00', '0', NULL, NULL, 212, 4, 1, NULL, NULL, 0, 0),
(1846, '00:00', '00:00', '0', NULL, NULL, 212, 5, 1, NULL, NULL, 0, 0),
(1847, '00:00', '00:00', '0', NULL, NULL, 212, 6, 1, NULL, NULL, 0, 0),
(1848, '00:00', '00:00', '0', NULL, NULL, 212, 7, 1, NULL, NULL, 0, 0),
(1849, '00:00', '00:00', '0', NULL, NULL, 212, 8, 1, NULL, NULL, 0, 0),
(1850, '00:00', '00:00', '0', NULL, NULL, 212, 10, 1, NULL, NULL, 0, 0),
(1851, '00:00', '00:00', '0', NULL, NULL, 213, 1, 1, NULL, NULL, 0, 0),
(1852, '00:00', '00:00', '0', NULL, NULL, 213, 2, 1, NULL, NULL, 0, 0),
(1853, '00:00', '00:00', '0', NULL, NULL, 213, 3, 1, NULL, NULL, 0, 0),
(1854, '00:00', '00:00', '0', NULL, NULL, 213, 4, 1, NULL, NULL, 0, 0),
(1855, '00:00', '00:00', '0', NULL, NULL, 213, 5, 1, NULL, NULL, 0, 0),
(1856, '00:00', '00:00', '0', NULL, NULL, 213, 6, 1, NULL, NULL, 0, 0),
(1857, '00:00', '00:00', '0', NULL, NULL, 213, 7, 1, NULL, NULL, 0, 0),
(1858, '00:00', '00:00', '0', NULL, NULL, 213, 8, 1, NULL, NULL, 0, 0),
(1859, '00:00', '00:00', '0', NULL, NULL, 213, 9, 1, NULL, NULL, 0, 0),
(1860, '00:00', '00:00', '0', NULL, NULL, 213, 10, 1, NULL, NULL, 0, 0),
(1861, '00:00', '00:00', '0', NULL, NULL, 214, 1, 1, NULL, NULL, 0, 0),
(1862, '00:00', '00:00', '0', NULL, NULL, 214, 2, 1, NULL, NULL, 0, 0),
(1863, '00:00', '00:00', '0', NULL, NULL, 214, 3, 1, NULL, NULL, 0, 0),
(1864, '00:00', '00:00', '0', NULL, NULL, 214, 4, 1, NULL, NULL, 0, 0),
(1865, '00:00', '00:00', '0', NULL, NULL, 214, 5, 1, NULL, NULL, 0, 0),
(1866, '00:00', '00:00', '0', NULL, NULL, 214, 6, 1, NULL, NULL, 0, 0),
(1867, '00:00', '00:00', '0', NULL, NULL, 214, 7, 1, NULL, NULL, 0, 0),
(1868, '00:00', '00:00', '0', NULL, NULL, 214, 8, 1, NULL, NULL, 0, 0),
(1869, '00:00', '00:00', '0', NULL, NULL, 214, 10, 1, NULL, NULL, 0, 0),
(1870, '00:00', '00:00', '0', NULL, NULL, 215, 1, 1, NULL, NULL, 0, 0),
(1871, '00:00', '00:00', '0', NULL, NULL, 215, 2, 1, NULL, NULL, 0, 0),
(1872, '00:00', '00:00', '0', NULL, NULL, 215, 3, 1, NULL, NULL, 0, 0),
(1873, '00:00', '00:00', '0', NULL, NULL, 215, 4, 1, NULL, NULL, 0, 0),
(1874, '00:00', '00:00', '0', NULL, NULL, 215, 5, 1, NULL, NULL, 0, 0),
(1875, '00:00', '00:00', '0', NULL, NULL, 215, 6, 1, NULL, NULL, 0, 0),
(1876, '00:00', '00:00', '0', NULL, NULL, 215, 7, 1, NULL, NULL, 0, 0),
(1877, '00:00', '00:00', '0', NULL, NULL, 215, 8, 1, NULL, NULL, 0, 0),
(1878, '00:00', '00:00', '0', NULL, NULL, 215, 10, 1, NULL, NULL, 0, 0),
(1879, '00:00', '00:00', '0', NULL, NULL, 216, 1, 1, NULL, NULL, 0, 0),
(1880, '00:00', '00:00', '0', NULL, NULL, 216, 3, 1, NULL, NULL, 0, 0),
(1881, '00:00', '00:00', '0', NULL, NULL, 216, 4, 1, NULL, NULL, 0, 0),
(1882, '00:00', '00:00', '0', NULL, NULL, 216, 5, 1, NULL, NULL, 0, 0),
(1883, '00:00', '00:00', '0', NULL, NULL, 216, 6, 1, NULL, NULL, 0, 0),
(1884, '00:00', '00:00', '0', NULL, NULL, 216, 7, 1, NULL, NULL, 0, 0),
(1885, '00:00', '00:00', '0', NULL, NULL, 216, 8, 1, NULL, NULL, 0, 0),
(1886, '00:00', '00:00', '0', NULL, NULL, 216, 9, 1, NULL, NULL, 0, 0),
(1887, '00:00', '00:00', '0', NULL, NULL, 216, 10, 1, NULL, NULL, 0, 0),
(1888, '00:00', '00:00', '0', NULL, NULL, 217, 1, 1, NULL, NULL, 0, 0),
(1889, '00:00', '00:00', '0', NULL, NULL, 217, 3, 1, NULL, NULL, 0, 0),
(1890, '00:00', '00:00', '0', NULL, NULL, 217, 4, 1, NULL, NULL, 0, 0),
(1891, '00:00', '00:00', '0', NULL, NULL, 217, 5, 1, NULL, NULL, 0, 0),
(1892, '00:00', '00:00', '0', NULL, NULL, 217, 6, 1, NULL, NULL, 0, 0),
(1893, '00:00', '00:00', '0', NULL, NULL, 217, 7, 1, NULL, NULL, 0, 0),
(1894, '00:00', '00:00', '0', NULL, NULL, 217, 8, 1, NULL, NULL, 0, 0),
(1895, '00:00', '00:00', '0', NULL, NULL, 217, 9, 1, NULL, NULL, 0, 0),
(1896, '00:00', '00:00', '0', NULL, NULL, 217, 10, 1, NULL, NULL, 0, 0),
(1897, '00:00', '00:00', '0', NULL, NULL, 218, 1, 1, NULL, NULL, 0, 0),
(1898, '00:00', '00:00', '0', NULL, NULL, 218, 2, 1, NULL, NULL, 0, 0),
(1899, '00:00', '00:00', '0', NULL, NULL, 218, 3, 1, NULL, NULL, 0, 0),
(1900, '00:00', '00:00', '0', NULL, NULL, 218, 4, 1, NULL, NULL, 0, 0),
(1901, '00:00', '00:00', '0', NULL, NULL, 218, 5, 1, NULL, NULL, 0, 0),
(1902, '00:00', '00:00', '0', NULL, NULL, 218, 6, 1, NULL, NULL, 0, 0),
(1903, '00:00', '00:00', '0', NULL, NULL, 218, 7, 1, NULL, NULL, 0, 0),
(1904, '00:00', '00:00', '0', NULL, NULL, 218, 8, 1, NULL, NULL, 0, 0),
(1905, '00:00', '00:00', '0', NULL, NULL, 218, 10, 1, NULL, NULL, 0, 0),
(1906, '00:00', '00:00', '0', NULL, NULL, 219, 1, 1, NULL, NULL, 0, 0),
(1907, '00:00', '00:00', '0', NULL, NULL, 219, 2, 1, NULL, NULL, 0, 0),
(1908, '00:00', '00:00', '0', NULL, NULL, 219, 3, 1, NULL, NULL, 0, 0),
(1909, '00:00', '00:00', '0', NULL, NULL, 219, 4, 1, NULL, NULL, 0, 0),
(1910, '00:00', '00:00', '0', NULL, NULL, 219, 5, 1, NULL, NULL, 0, 0),
(1911, '00:00', '00:00', '0', NULL, NULL, 219, 7, 1, NULL, NULL, 0, 0),
(1912, '00:00', '00:00', '0', NULL, NULL, 219, 8, 1, NULL, NULL, 0, 0),
(1913, '00:00', '00:00', '0', NULL, NULL, 219, 10, 1, NULL, NULL, 0, 0),
(1914, '00:00', '00:00', '0', NULL, NULL, 220, 1, 1, NULL, NULL, 0, 0),
(1915, '00:00', '00:00', '0', NULL, NULL, 220, 2, 1, NULL, NULL, 0, 0),
(1916, '00:00', '00:00', '0', NULL, NULL, 220, 3, 1, NULL, NULL, 0, 0),
(1917, '00:00', '00:00', '0', NULL, NULL, 220, 4, 1, NULL, NULL, 0, 0),
(1918, '00:00', '00:00', '0', NULL, NULL, 220, 5, 1, NULL, NULL, 0, 0),
(1919, '00:00', '00:00', '0', NULL, NULL, 220, 6, 1, NULL, NULL, 0, 0),
(1920, '00:00', '00:00', '0', NULL, NULL, 220, 7, 1, NULL, NULL, 0, 0),
(1921, '00:00', '00:00', '0', NULL, NULL, 220, 8, 1, NULL, NULL, 0, 0),
(1922, '00:00', '00:00', '0', NULL, NULL, 220, 10, 1, NULL, NULL, 0, 0),
(1923, '00:00', '00:00', '0', NULL, NULL, 221, 1, 1, NULL, NULL, 0, 0),
(1924, '00:00', '00:00', '0', NULL, NULL, 221, 2, 1, NULL, NULL, 0, 0),
(1925, '00:00', '00:00', '0', NULL, NULL, 221, 3, 1, NULL, NULL, 0, 0),
(1926, '00:00', '00:00', '0', NULL, NULL, 221, 4, 1, NULL, NULL, 0, 0),
(1927, '00:00', '00:00', '0', NULL, NULL, 221, 5, 1, NULL, NULL, 0, 0),
(1928, '00:00', '00:00', '0', NULL, NULL, 221, 6, 1, NULL, NULL, 0, 0),
(1929, '00:00', '00:00', '0', NULL, NULL, 221, 7, 1, NULL, NULL, 0, 0),
(1930, '00:00', '00:00', '0', NULL, NULL, 221, 8, 1, NULL, NULL, 0, 0),
(1931, '00:00', '00:00', '0', NULL, NULL, 221, 10, 1, NULL, NULL, 0, 0),
(1932, '00:00', '00:00', '0', NULL, NULL, 222, 1, 1, NULL, NULL, 0, 0),
(1933, '00:00', '00:00', '0', NULL, NULL, 222, 2, 1, NULL, NULL, 0, 0),
(1934, '00:00', '00:00', '0', NULL, NULL, 222, 3, 1, NULL, NULL, 0, 0),
(1935, '00:00', '00:00', '0', NULL, NULL, 222, 4, 1, NULL, NULL, 0, 0),
(1936, '00:00', '00:00', '0', NULL, NULL, 222, 5, 1, NULL, NULL, 0, 0),
(1937, '00:00', '00:00', '0', NULL, NULL, 222, 6, 1, NULL, NULL, 0, 0),
(1938, '00:00', '00:00', '0', NULL, NULL, 222, 7, 1, NULL, NULL, 0, 0),
(1939, '00:00', '00:00', '0', NULL, NULL, 222, 8, 1, NULL, NULL, 0, 0),
(1940, '00:00', '00:00', '0', NULL, NULL, 222, 10, 1, NULL, NULL, 0, 0),
(1941, '00:00', '00:00', '0', NULL, NULL, 223, 1, 1, NULL, NULL, 0, 0),
(1942, '00:00', '00:00', '0', NULL, NULL, 223, 2, 1, NULL, NULL, 0, 0),
(1943, '00:00', '00:00', '0', NULL, NULL, 223, 3, 1, NULL, NULL, 0, 0),
(1944, '00:00', '00:00', '0', NULL, NULL, 223, 4, 1, NULL, NULL, 0, 0),
(1945, '00:00', '00:00', '0', NULL, NULL, 223, 5, 1, NULL, NULL, 0, 0),
(1946, '00:00', '00:00', '0', NULL, NULL, 223, 6, 1, NULL, NULL, 0, 0),
(1947, '00:00', '00:00', '0', NULL, NULL, 223, 7, 1, NULL, NULL, 0, 0),
(1948, '00:00', '00:00', '0', NULL, NULL, 223, 8, 1, NULL, NULL, 0, 0),
(1949, '00:00', '00:00', '0', NULL, NULL, 223, 10, 1, NULL, NULL, 0, 0),
(1950, '00:00', '00:00', '0', NULL, NULL, 224, 1, 1, NULL, NULL, 0, 0),
(1951, '00:00', '00:00', '0', NULL, NULL, 224, 2, 1, NULL, NULL, 0, 0),
(1952, '00:00', '00:00', '0', NULL, NULL, 224, 3, 1, NULL, NULL, 0, 0),
(1953, '00:00', '00:00', '0', NULL, NULL, 224, 4, 1, NULL, NULL, 0, 0),
(1954, '00:00', '00:00', '0', NULL, NULL, 224, 5, 1, NULL, NULL, 0, 0),
(1955, '00:00', '00:00', '0', NULL, NULL, 224, 6, 1, NULL, NULL, 0, 0),
(1956, '00:00', '00:00', '0', NULL, NULL, 224, 7, 1, NULL, NULL, 0, 0),
(1957, '00:00', '00:00', '0', NULL, NULL, 224, 8, 1, NULL, NULL, 0, 0),
(1958, '00:00', '00:00', '0', NULL, NULL, 224, 10, 1, NULL, NULL, 0, 0),
(1959, '00:00', '00:00', '0', NULL, NULL, 225, 1, 1, NULL, NULL, 0, 0),
(1960, '00:00', '00:00', '0', NULL, NULL, 225, 2, 1, NULL, NULL, 0, 0),
(1961, '00:00', '00:00', '0', NULL, NULL, 225, 3, 1, NULL, NULL, 0, 0),
(1962, '00:00', '00:00', '0', NULL, NULL, 225, 4, 1, NULL, NULL, 0, 0),
(1963, '00:00', '00:00', '0', NULL, NULL, 225, 5, 1, NULL, NULL, 0, 0),
(1964, '00:00', '00:00', '0', NULL, NULL, 225, 6, 1, NULL, NULL, 0, 0),
(1965, '00:00', '00:00', '0', NULL, NULL, 225, 7, 1, NULL, NULL, 0, 0),
(1966, '00:00', '00:00', '0', NULL, NULL, 225, 8, 1, NULL, NULL, 0, 0),
(1967, '00:00', '00:00', '0', NULL, NULL, 225, 10, 1, NULL, NULL, 0, 0),
(1968, '00:00', '00:00', '0', NULL, NULL, 226, 1, 1, NULL, NULL, 0, 0),
(1969, '00:00', '00:00', '0', NULL, NULL, 226, 2, 1, NULL, NULL, 0, 0),
(1970, '00:00', '00:00', '0', NULL, NULL, 226, 3, 1, NULL, NULL, 0, 0),
(1971, '00:00', '00:00', '0', NULL, NULL, 226, 4, 1, NULL, NULL, 0, 0),
(1972, '00:00', '00:00', '0', NULL, NULL, 226, 5, 1, NULL, NULL, 0, 0),
(1973, '00:00', '00:00', '0', NULL, NULL, 226, 6, 1, NULL, NULL, 0, 0),
(1974, '00:00', '00:00', '0', NULL, NULL, 226, 7, 1, NULL, NULL, 0, 0),
(1975, '00:00', '00:00', '0', NULL, NULL, 226, 8, 1, NULL, NULL, 0, 0),
(1976, '00:00', '00:00', '0', NULL, NULL, 226, 10, 1, NULL, NULL, 0, 0),
(1977, '00:00', '00:00', '0', NULL, NULL, 227, 1, 1, NULL, NULL, 0, 0),
(1978, '00:00', '00:00', '0', NULL, NULL, 227, 2, 1, NULL, NULL, 0, 0),
(1979, '00:00', '00:00', '0', NULL, NULL, 227, 3, 1, NULL, NULL, 0, 0),
(1980, '00:00', '00:00', '0', NULL, NULL, 227, 4, 1, NULL, NULL, 0, 0),
(1981, '00:00', '00:00', '0', NULL, NULL, 227, 5, 1, NULL, NULL, 0, 0),
(1982, '00:00', '00:00', '0', NULL, NULL, 227, 6, 1, NULL, NULL, 0, 0),
(1983, '00:00', '00:00', '0', NULL, NULL, 227, 7, 1, NULL, NULL, 0, 0),
(1984, '00:00', '00:00', '0', NULL, NULL, 227, 8, 1, NULL, NULL, 0, 0),
(1985, '00:00', '00:00', '0', NULL, NULL, 227, 10, 1, NULL, NULL, 0, 0),
(1986, '00:00', '00:00', '0', NULL, NULL, 228, 1, 1, NULL, NULL, 0, 0),
(1987, '00:00', '00:00', '0', NULL, NULL, 228, 2, 1, NULL, NULL, 0, 0),
(1988, '00:00', '00:00', '0', NULL, NULL, 228, 3, 1, NULL, NULL, 0, 0),
(1989, '00:00', '00:00', '0', NULL, NULL, 228, 4, 1, NULL, NULL, 0, 0),
(1990, '00:00', '00:00', '0', NULL, NULL, 228, 5, 1, NULL, NULL, 0, 0),
(1991, '00:00', '00:00', '0', NULL, NULL, 228, 6, 1, NULL, NULL, 0, 0),
(1992, '00:00', '00:00', '0', NULL, NULL, 228, 7, 1, NULL, NULL, 0, 0),
(1993, '00:00', '00:00', '0', NULL, NULL, 228, 8, 1, NULL, NULL, 0, 0),
(1994, '00:00', '00:00', '0', NULL, NULL, 228, 10, 1, NULL, NULL, 0, 0),
(1995, '00:00', '00:00', '0', NULL, NULL, 229, 1, 1, NULL, NULL, 0, 0),
(1996, '00:00', '00:00', '0', NULL, NULL, 229, 2, 1, NULL, NULL, 0, 0),
(1997, '00:00', '00:00', '0', NULL, NULL, 229, 3, 1, NULL, NULL, 0, 0),
(1998, '00:00', '00:00', '0', NULL, NULL, 229, 4, 1, NULL, NULL, 0, 0),
(1999, '00:00', '00:00', '0', NULL, NULL, 229, 5, 1, NULL, NULL, 0, 0),
(2000, '00:00', '00:00', '0', NULL, NULL, 229, 6, 1, NULL, NULL, 0, 0),
(2001, '00:00', '00:00', '0', NULL, NULL, 229, 7, 1, NULL, NULL, 0, 0),
(2002, '00:00', '00:00', '0', NULL, NULL, 229, 8, 1, NULL, NULL, 0, 0),
(2003, '00:00', '00:00', '0', NULL, NULL, 229, 10, 1, NULL, NULL, 0, 0),
(2004, '00:00', '00:00', '0', NULL, NULL, 230, 1, 1, NULL, NULL, 0, 0),
(2005, '00:00', '00:00', '0', NULL, NULL, 230, 2, 1, NULL, NULL, 0, 0),
(2006, '00:00', '00:00', '0', NULL, NULL, 230, 3, 1, NULL, NULL, 0, 0),
(2007, '00:00', '00:00', '0', NULL, NULL, 230, 4, 1, NULL, NULL, 0, 0),
(2008, '00:00', '00:00', '0', NULL, NULL, 230, 5, 1, NULL, NULL, 0, 0),
(2009, '00:00', '00:00', '0', NULL, NULL, 230, 6, 1, NULL, NULL, 0, 0),
(2010, '00:00', '00:00', '0', NULL, NULL, 230, 7, 1, NULL, NULL, 0, 0),
(2011, '00:00', '00:00', '0', NULL, NULL, 230, 8, 1, NULL, NULL, 0, 0),
(2012, '00:00', '00:00', '0', NULL, NULL, 230, 10, 1, NULL, NULL, 0, 0),
(2013, '00:00', '00:00', '0', NULL, NULL, 231, 1, 1, NULL, NULL, 0, 0),
(2014, '00:00', '00:00', '0', NULL, NULL, 231, 2, 1, NULL, NULL, 0, 0),
(2015, '00:00', '00:00', '0', NULL, NULL, 231, 3, 1, NULL, NULL, 0, 0),
(2016, '00:00', '00:00', '0', NULL, NULL, 231, 4, 1, NULL, NULL, 0, 0),
(2017, '00:00', '00:00', '0', NULL, NULL, 231, 5, 1, NULL, NULL, 0, 0),
(2018, '00:00', '00:00', '0', NULL, NULL, 231, 6, 1, NULL, NULL, 0, 0),
(2019, '00:00', '00:00', '0', NULL, NULL, 231, 7, 1, NULL, NULL, 0, 0),
(2020, '00:00', '00:00', '0', NULL, NULL, 231, 8, 1, NULL, NULL, 0, 0),
(2021, '00:00', '00:00', '0', NULL, NULL, 231, 10, 1, NULL, NULL, 0, 0),
(2022, '00:00', '00:00', '0', NULL, NULL, 232, 1, 1, NULL, NULL, 0, 0),
(2023, '00:00', '00:00', '0', NULL, NULL, 232, 2, 1, NULL, NULL, 0, 0),
(2024, '00:00', '00:00', '0', NULL, NULL, 232, 3, 1, NULL, NULL, 0, 0),
(2025, '00:00', '00:00', '0', NULL, NULL, 232, 4, 1, NULL, NULL, 0, 0),
(2026, '00:00', '00:00', '0', NULL, NULL, 232, 5, 1, NULL, NULL, 0, 0),
(2027, '00:00', '00:00', '0', NULL, NULL, 232, 6, 1, NULL, NULL, 0, 0),
(2028, '00:00', '00:00', '0', NULL, NULL, 232, 7, 1, NULL, NULL, 0, 0),
(2029, '00:00', '00:00', '0', NULL, NULL, 232, 8, 1, NULL, NULL, 0, 0),
(2030, '00:00', '00:00', '0', NULL, NULL, 232, 10, 1, NULL, NULL, 0, 0),
(2031, '00:00', '00:00', '0', NULL, NULL, 233, 1, 1, NULL, NULL, 0, 0),
(2032, '00:00', '00:00', '0', NULL, NULL, 233, 3, 1, NULL, NULL, 0, 0),
(2033, '00:00', '00:00', '0', NULL, NULL, 233, 4, 1, NULL, NULL, 0, 0),
(2034, '00:00', '00:00', '0', NULL, NULL, 233, 5, 1, NULL, NULL, 0, 0),
(2035, '00:00', '00:00', '0', NULL, NULL, 233, 6, 1, NULL, NULL, 0, 0),
(2036, '00:00', '00:00', '0', NULL, NULL, 233, 7, 1, NULL, NULL, 0, 0),
(2037, '00:00', '00:00', '0', NULL, NULL, 233, 8, 1, NULL, NULL, 0, 0),
(2038, '00:00', '00:00', '0', NULL, NULL, 233, 10, 1, NULL, NULL, 0, 0),
(2039, '00:00', '00:00', '0', NULL, NULL, 234, 1, 1, NULL, NULL, 0, 0),
(2040, '00:00', '00:00', '0', NULL, NULL, 234, 3, 1, NULL, NULL, 0, 0),
(2041, '00:00', '00:00', '0', NULL, NULL, 234, 4, 1, NULL, NULL, 0, 0),
(2042, '00:00', '00:00', '0', NULL, NULL, 234, 5, 1, NULL, NULL, 0, 0),
(2043, '00:00', '00:00', '0', NULL, NULL, 234, 6, 1, NULL, NULL, 0, 0),
(2044, '00:00', '00:00', '0', NULL, NULL, 234, 7, 1, NULL, NULL, 0, 0),
(2045, '00:00', '00:00', '0', NULL, NULL, 234, 8, 1, NULL, NULL, 0, 0),
(2046, '00:00', '00:00', '0', NULL, NULL, 234, 10, 1, NULL, NULL, 0, 0),
(2047, '00:00', '00:00', '0', NULL, NULL, 235, 1, 1, NULL, NULL, 0, 0),
(2048, '00:00', '00:00', '0', NULL, NULL, 235, 3, 1, NULL, NULL, 0, 0),
(2049, '00:00', '00:00', '0', NULL, NULL, 235, 4, 1, NULL, NULL, 0, 0),
(2050, '00:00', '00:00', '0', NULL, NULL, 235, 5, 1, NULL, NULL, 0, 0),
(2051, '00:00', '00:00', '0', NULL, NULL, 235, 6, 1, NULL, NULL, 0, 0),
(2052, '00:00', '00:00', '0', NULL, NULL, 235, 7, 1, NULL, NULL, 0, 0),
(2053, '00:00', '00:00', '0', NULL, NULL, 235, 8, 1, NULL, NULL, 0, 0),
(2054, '00:00', '00:00', '0', NULL, NULL, 235, 10, 1, NULL, NULL, 0, 0),
(2055, '00:00', '00:00', '0', NULL, NULL, 236, 1, 1, NULL, NULL, 0, 0),
(2056, '00:00', '00:00', '0', NULL, NULL, 236, 2, 1, NULL, NULL, 0, 0),
(2057, '00:00', '00:00', '0', NULL, NULL, 236, 3, 1, NULL, NULL, 0, 0),
(2058, '00:00', '00:00', '0', NULL, NULL, 236, 4, 1, NULL, NULL, 0, 0),
(2059, '00:00', '00:00', '0', NULL, NULL, 236, 5, 1, NULL, NULL, 0, 0),
(2060, '00:00', '00:00', '0', NULL, NULL, 236, 6, 1, NULL, NULL, 0, 0),
(2061, '00:00', '00:00', '0', NULL, NULL, 236, 7, 1, NULL, NULL, 0, 0),
(2062, '00:00', '00:00', '0', NULL, NULL, 236, 8, 1, NULL, NULL, 0, 0),
(2063, '00:00', '00:00', '0', NULL, NULL, 236, 10, 1, NULL, NULL, 0, 0),
(2064, '00:00', '00:00', '0', NULL, NULL, 237, 1, 1, NULL, NULL, 0, 0),
(2065, '00:00', '00:00', '0', NULL, NULL, 237, 3, 1, NULL, NULL, 0, 0),
(2066, '00:00', '00:00', '0', NULL, NULL, 237, 4, 1, NULL, NULL, 0, 0),
(2067, '00:00', '00:00', '0', NULL, NULL, 237, 5, 1, NULL, NULL, 0, 0),
(2068, '00:00', '00:00', '0', NULL, NULL, 237, 7, 1, NULL, NULL, 0, 0),
(2069, '00:00', '00:00', '0', NULL, NULL, 237, 8, 1, NULL, NULL, 0, 0),
(2070, '00:00', '00:00', '0', NULL, NULL, 237, 10, 1, NULL, NULL, 0, 0),
(2071, '00:00', '00:00', '0', NULL, NULL, 238, 1, 1, NULL, NULL, 0, 0),
(2073, '00:00', '00:00', '0', NULL, NULL, 238, 3, 1, NULL, NULL, 0, 0),
(2074, '00:00', '00:00', '0', NULL, NULL, 238, 4, 1, NULL, NULL, 0, 0),
(2075, '00:00', '00:00', '0', NULL, NULL, 238, 5, 1, NULL, NULL, 0, 0),
(2076, '00:00', '00:00', '0', NULL, NULL, 238, 6, 1, NULL, NULL, 0, 0),
(2077, '00:00', '00:00', '0', NULL, NULL, 238, 7, 1, NULL, NULL, 0, 0),
(2078, '00:00', '00:00', '0', NULL, NULL, 238, 8, 1, NULL, NULL, 0, 0),
(2079, '00:00', '00:00', '0', NULL, NULL, 238, 10, 1, NULL, NULL, 0, 0),
(2080, '00:00', '00:00', '0', NULL, NULL, 239, 1, 1, NULL, NULL, 0, 0),
(2081, '00:00', '00:00', '0', NULL, NULL, 239, 2, 1, NULL, NULL, 0, 0),
(2082, '00:00', '00:00', '0', NULL, NULL, 239, 3, 1, NULL, NULL, 0, 0),
(2083, '00:00', '00:00', '0', NULL, NULL, 239, 4, 1, NULL, NULL, 0, 0),
(2084, '00:00', '00:00', '0', NULL, NULL, 239, 5, 1, NULL, NULL, 0, 0),
(2085, '00:00', '00:00', '0', NULL, NULL, 239, 6, 1, NULL, NULL, 0, 0),
(2086, '00:00', '00:00', '0', NULL, NULL, 239, 7, 1, NULL, NULL, 0, 0),
(2087, '00:00', '00:00', '0', NULL, NULL, 239, 8, 1, NULL, NULL, 0, 0),
(2088, '00:00', '00:00', '0', NULL, NULL, 239, 10, 1, NULL, NULL, 0, 0),
(2089, '00:00', '00:00', '0', NULL, NULL, 240, 1, 1, NULL, NULL, 0, 0),
(2090, '00:00', '00:00', '0', NULL, NULL, 240, 2, 1, NULL, NULL, 0, 0),
(2091, '00:00', '00:00', '0', NULL, NULL, 240, 3, 1, NULL, NULL, 0, 0),
(2092, '00:00', '00:00', '0', NULL, NULL, 240, 4, 1, NULL, NULL, 0, 0),
(2093, '00:00', '00:00', '0', NULL, NULL, 240, 5, 1, NULL, NULL, 0, 0),
(2094, '00:00', '00:00', '0', NULL, NULL, 240, 6, 1, NULL, NULL, 0, 0),
(2095, '00:00', '00:00', '0', NULL, NULL, 240, 7, 1, NULL, NULL, 0, 0),
(2096, '00:00', '00:00', '0', NULL, NULL, 240, 8, 1, NULL, NULL, 0, 0),
(2097, '00:00', '00:00', '0', NULL, NULL, 240, 10, 1, NULL, NULL, 0, 0),
(2098, '00:00', '00:00', '0', NULL, NULL, 241, 1, 1, NULL, NULL, 0, 0),
(2099, '00:00', '00:00', '0', NULL, NULL, 241, 2, 1, NULL, NULL, 0, 0),
(2100, '00:00', '00:00', '0', NULL, NULL, 241, 3, 1, NULL, NULL, 0, 0),
(2101, '00:00', '00:00', '0', NULL, NULL, 241, 4, 1, NULL, NULL, 0, 0),
(2102, '00:00', '00:00', '0', NULL, NULL, 241, 5, 1, NULL, NULL, 0, 0),
(2103, '00:00', '00:00', '0', NULL, NULL, 241, 6, 1, NULL, NULL, 0, 0),
(2104, '00:00', '00:00', '0', NULL, NULL, 241, 7, 1, NULL, NULL, 0, 0),
(2105, '00:00', '00:00', '0', NULL, NULL, 241, 8, 1, NULL, NULL, 0, 0),
(2106, '00:00', '00:00', '0', NULL, NULL, 241, 10, 1, NULL, NULL, 0, 0),
(2107, '00:00', '00:00', '0', NULL, NULL, 242, 1, 1, NULL, NULL, 0, 0),
(2108, '00:00', '00:00', '0', NULL, NULL, 242, 2, 1, NULL, NULL, 0, 0),
(2109, '00:00', '00:00', '0', NULL, NULL, 242, 3, 1, NULL, NULL, 0, 0),
(2110, '00:00', '00:00', '0', NULL, NULL, 242, 4, 1, NULL, NULL, 0, 0),
(2111, '00:00', '00:00', '0', NULL, NULL, 242, 5, 1, NULL, NULL, 0, 0),
(2112, '00:00', '00:00', '0', NULL, NULL, 242, 6, 1, NULL, NULL, 0, 0),
(2113, '00:00', '00:00', '0', NULL, NULL, 242, 7, 1, NULL, NULL, 0, 0),
(2114, '00:00', '00:00', '0', NULL, NULL, 242, 8, 1, NULL, NULL, 0, 0),
(2115, '00:00', '00:00', '0', NULL, NULL, 242, 10, 1, NULL, NULL, 0, 0),
(2116, '00:00', '00:00', '0', NULL, NULL, 243, 1, 1, NULL, NULL, 0, 0),
(2117, '00:00', '00:00', '0', NULL, NULL, 243, 2, 1, NULL, NULL, 0, 0),
(2118, '00:00', '00:00', '0', NULL, NULL, 243, 3, 1, NULL, NULL, 0, 0),
(2119, '00:00', '00:00', '0', NULL, NULL, 243, 4, 1, NULL, NULL, 0, 0),
(2120, '00:00', '00:00', '0', NULL, NULL, 243, 5, 1, NULL, NULL, 0, 0),
(2121, '00:00', '00:00', '0', NULL, NULL, 243, 6, 1, NULL, NULL, 0, 0),
(2122, '00:00', '00:00', '0', NULL, NULL, 243, 7, 1, NULL, NULL, 0, 0),
(2123, '00:00', '00:00', '0', NULL, NULL, 243, 8, 1, NULL, NULL, 0, 0),
(2124, '00:00', '00:00', '0', NULL, NULL, 243, 10, 1, NULL, NULL, 0, 0),
(2125, '00:00', '00:00', '0', NULL, NULL, 244, 1, 1, NULL, NULL, 0, 0),
(2126, '00:00', '00:00', '0', NULL, NULL, 244, 2, 1, NULL, NULL, 0, 0),
(2127, '00:00', '00:00', '0', NULL, NULL, 244, 3, 1, NULL, NULL, 0, 0),
(2128, '00:00', '00:00', '0', NULL, NULL, 244, 4, 1, NULL, NULL, 0, 0),
(2129, '00:00', '00:00', '0', NULL, NULL, 244, 5, 1, NULL, NULL, 0, 0),
(2130, '00:00', '00:00', '0', NULL, NULL, 244, 6, 1, NULL, NULL, 0, 0),
(2131, '00:00', '00:00', '0', NULL, NULL, 244, 7, 1, NULL, NULL, 0, 0),
(2132, '00:00', '00:00', '0', NULL, NULL, 244, 8, 1, NULL, NULL, 0, 0),
(2133, '00:00', '00:00', '0', NULL, NULL, 244, 10, 1, NULL, NULL, 0, 0),
(2134, '00:00', '00:00', '0', NULL, NULL, 245, 1, 1, NULL, NULL, 0, 0),
(2135, '00:00', '00:00', '0', NULL, NULL, 245, 3, 1, NULL, NULL, 0, 0),
(2136, '00:00', '00:00', '0', NULL, NULL, 245, 4, 1, NULL, NULL, 0, 0),
(2137, '00:00', '00:00', '0', NULL, NULL, 245, 5, 1, NULL, NULL, 0, 0),
(2138, '00:00', '00:00', '0', NULL, NULL, 245, 6, 1, NULL, NULL, 0, 0),
(2139, '00:00', '00:00', '0', NULL, NULL, 245, 7, 1, NULL, NULL, 0, 0),
(2140, '00:00', '00:00', '0', NULL, NULL, 245, 8, 1, NULL, NULL, 0, 0),
(2141, '00:00', '00:00', '0', NULL, NULL, 245, 10, 1, NULL, NULL, 0, 0),
(2142, '00:00', '00:00', '0', NULL, NULL, 246, 1, 1, NULL, NULL, 0, 0),
(2143, '00:00', '00:00', '0', NULL, NULL, 246, 3, 1, NULL, NULL, 0, 0),
(2144, '00:00', '00:00', '0', NULL, NULL, 246, 4, 1, NULL, NULL, 0, 0),
(2145, '00:00', '00:00', '0', NULL, NULL, 246, 5, 1, NULL, NULL, 0, 0),
(2146, '00:00', '00:00', '0', NULL, NULL, 246, 6, 1, NULL, NULL, 0, 0),
(2147, '00:00', '00:00', '0', NULL, NULL, 246, 7, 1, NULL, NULL, 0, 0),
(2148, '00:00', '00:00', '0', NULL, NULL, 246, 8, 1, NULL, NULL, 0, 0),
(2149, '00:00', '00:00', '0', NULL, NULL, 246, 10, 1, NULL, NULL, 0, 0),
(2150, '00:00', '00:00', '0', NULL, NULL, 247, 1, 1, NULL, NULL, 0, 0),
(2151, '00:00', '00:00', '0', NULL, NULL, 247, 2, 1, NULL, NULL, 0, 0),
(2152, '00:00', '00:00', '0', NULL, NULL, 247, 3, 1, NULL, NULL, 0, 0),
(2153, '00:00', '00:00', '0', NULL, NULL, 247, 4, 1, NULL, NULL, 0, 0),
(2154, '00:00', '00:00', '0', NULL, NULL, 247, 5, 1, NULL, NULL, 0, 0),
(2155, '00:00', '00:00', '0', NULL, NULL, 247, 6, 1, NULL, NULL, 0, 0),
(2156, '00:00', '00:00', '0', NULL, NULL, 247, 7, 1, NULL, NULL, 0, 0),
(2157, '00:00', '00:00', '0', NULL, NULL, 247, 8, 1, NULL, NULL, 0, 0),
(2158, '00:00', '00:00', '0', NULL, NULL, 247, 10, 1, NULL, NULL, 0, 0),
(2159, '00:00', '00:00', '0', NULL, NULL, 248, 1, 1, NULL, NULL, 0, 0),
(2160, '00:00', '00:00', '0', NULL, NULL, 248, 2, 1, NULL, NULL, 0, 0),
(2161, '00:00', '00:00', '0', NULL, NULL, 248, 3, 1, NULL, NULL, 0, 0),
(2162, '00:00', '00:00', '0', NULL, NULL, 248, 4, 1, NULL, NULL, 0, 0),
(2163, '00:00', '00:00', '0', NULL, NULL, 248, 5, 1, NULL, NULL, 0, 0),
(2164, '00:00', '00:00', '0', NULL, NULL, 248, 6, 1, NULL, NULL, 0, 0),
(2165, '00:00', '00:00', '0', NULL, NULL, 248, 7, 1, NULL, NULL, 0, 0),
(2166, '00:00', '00:00', '0', NULL, NULL, 248, 8, 1, NULL, NULL, 0, 0),
(2167, '00:00', '00:00', '0', NULL, NULL, 248, 10, 1, NULL, NULL, 0, 0),
(2168, '00:00', '00:00', '0', NULL, NULL, 249, 1, 1, NULL, NULL, 0, 0),
(2169, '00:00', '00:00', '0', NULL, NULL, 249, 3, 1, NULL, NULL, 0, 0),
(2170, '00:00', '00:00', '0', NULL, NULL, 249, 4, 1, NULL, NULL, 0, 0),
(2171, '00:00', '00:00', '0', NULL, NULL, 249, 5, 1, NULL, NULL, 0, 0),
(2172, '00:00', '00:00', '0', NULL, NULL, 249, 6, 1, NULL, NULL, 0, 0),
(2173, '00:00', '00:00', '0', NULL, NULL, 249, 7, 1, NULL, NULL, 0, 0),
(2174, '00:00', '00:00', '0', NULL, NULL, 249, 8, 1, NULL, NULL, 0, 0),
(2175, '00:00', '00:00', '0', NULL, NULL, 249, 10, 1, NULL, NULL, 0, 0),
(2176, '00:00', '00:00', '0', NULL, NULL, 250, 1, 1, NULL, NULL, 0, 0),
(2177, '00:00', '00:00', '0', NULL, NULL, 250, 2, 1, NULL, NULL, 0, 0),
(2178, '00:00', '00:00', '0', NULL, NULL, 250, 3, 1, NULL, NULL, 0, 0),
(2179, '00:00', '00:00', '0', NULL, NULL, 250, 4, 1, NULL, NULL, 0, 0),
(2180, '00:00', '00:00', '0', NULL, NULL, 250, 5, 1, NULL, NULL, 0, 0),
(2181, '00:00', '00:00', '0', NULL, NULL, 250, 6, 1, NULL, NULL, 0, 0),
(2182, '00:00', '00:00', '0', NULL, NULL, 250, 7, 1, NULL, NULL, 0, 0),
(2183, '00:00', '00:00', '0', NULL, NULL, 250, 8, 1, NULL, NULL, 0, 0),
(2184, '00:00', '00:00', '0', NULL, NULL, 250, 10, 1, NULL, NULL, 0, 0),
(2185, '00:00', '00:00', '0', NULL, NULL, 251, 1, 1, NULL, NULL, 0, 0),
(2186, '00:00', '00:00', '0', NULL, NULL, 251, 2, 1, NULL, NULL, 0, 0),
(2187, '00:00', '00:00', '0', NULL, NULL, 251, 3, 1, NULL, NULL, 0, 0),
(2188, '00:00', '00:00', '0', NULL, NULL, 251, 4, 1, NULL, NULL, 0, 0),
(2189, '00:00', '00:00', '0', NULL, NULL, 251, 5, 1, NULL, NULL, 0, 0),
(2190, '00:00', '00:00', '0', NULL, NULL, 251, 6, 1, NULL, NULL, 0, 0),
(2191, '00:00', '00:00', '0', NULL, NULL, 251, 7, 1, NULL, NULL, 0, 0),
(2192, '00:00', '00:00', '0', NULL, NULL, 251, 8, 1, NULL, NULL, 0, 0),
(2193, '00:00', '00:00', '0', NULL, NULL, 251, 10, 1, NULL, NULL, 0, 0),
(2194, '00:00', '00:00', '0', NULL, NULL, 252, 1, 1, NULL, NULL, 0, 0),
(2195, '00:00', '00:00', '0', NULL, NULL, 252, 2, 1, NULL, NULL, 0, 0),
(2196, '00:00', '00:00', '0', NULL, NULL, 252, 3, 1, NULL, NULL, 0, 0),
(2197, '00:00', '00:00', '0', NULL, NULL, 252, 4, 1, NULL, NULL, 0, 0),
(2198, '00:00', '00:00', '0', NULL, NULL, 252, 5, 1, NULL, NULL, 0, 0),
(2199, '00:00', '00:00', '0', NULL, NULL, 252, 6, 1, NULL, NULL, 0, 0),
(2200, '00:00', '00:00', '0', NULL, NULL, 252, 7, 1, NULL, NULL, 0, 0),
(2201, '00:00', '00:00', '0', NULL, NULL, 252, 8, 1, NULL, NULL, 0, 0),
(2202, '00:00', '00:00', '0', NULL, NULL, 252, 10, 1, NULL, NULL, 0, 0),
(2203, '00:00', '00:00', '0', NULL, NULL, 253, 1, 1, NULL, NULL, 0, 0),
(2204, '00:00', '00:00', '0', NULL, NULL, 253, 2, 1, NULL, NULL, 0, 0),
(2205, '00:00', '00:00', '0', NULL, NULL, 253, 3, 1, NULL, NULL, 0, 0),
(2206, '00:00', '00:00', '0', NULL, NULL, 253, 4, 1, NULL, NULL, 0, 0),
(2207, '00:00', '00:00', '0', NULL, NULL, 253, 5, 1, NULL, NULL, 0, 0),
(2208, '00:00', '00:00', '0', NULL, NULL, 253, 6, 1, NULL, NULL, 0, 0),
(2209, '00:00', '00:00', '0', NULL, NULL, 253, 7, 1, NULL, NULL, 0, 0),
(2210, '00:00', '00:00', '0', NULL, NULL, 253, 8, 1, NULL, NULL, 0, 0),
(2211, '00:00', '00:00', '0', NULL, NULL, 253, 10, 1, NULL, NULL, 0, 0),
(2212, '00:00', '00:00', '0', NULL, NULL, 254, 1, 1, NULL, NULL, 0, 0),
(2213, '00:00', '00:00', '0', NULL, NULL, 254, 2, 1, NULL, NULL, 0, 0),
(2214, '00:00', '00:00', '0', NULL, NULL, 254, 3, 1, NULL, NULL, 0, 0),
(2215, '00:00', '00:00', '0', NULL, NULL, 254, 4, 1, NULL, NULL, 0, 0),
(2216, '00:00', '00:00', '0', NULL, NULL, 254, 5, 1, NULL, NULL, 0, 0),
(2217, '00:00', '00:00', '0', NULL, NULL, 254, 6, 1, NULL, NULL, 0, 0),
(2218, '00:00', '00:00', '0', NULL, NULL, 254, 7, 1, NULL, NULL, 0, 0),
(2219, '00:00', '00:00', '0', NULL, NULL, 254, 8, 1, NULL, NULL, 0, 0),
(2220, '00:00', '00:00', '0', NULL, NULL, 254, 10, 1, NULL, NULL, 0, 0),
(2221, '00:00', '00:00', '0', NULL, NULL, 255, 1, 1, NULL, NULL, 0, 0),
(2222, '00:00', '00:00', '0', NULL, NULL, 255, 2, 1, NULL, NULL, 0, 0),
(2223, '00:00', '00:00', '0', NULL, NULL, 255, 3, 1, NULL, NULL, 0, 0),
(2224, '00:00', '00:00', '0', NULL, NULL, 255, 4, 1, NULL, NULL, 0, 0),
(2225, '00:00', '00:00', '0', NULL, NULL, 255, 5, 1, NULL, NULL, 0, 0),
(2226, '00:00', '00:00', '0', NULL, NULL, 255, 6, 1, NULL, NULL, 0, 0),
(2227, '00:00', '00:00', '0', NULL, NULL, 255, 7, 1, NULL, NULL, 0, 0),
(2228, '00:00', '00:00', '0', NULL, NULL, 255, 8, 1, NULL, NULL, 0, 0),
(2229, '00:00', '00:00', '0', NULL, NULL, 255, 10, 1, NULL, NULL, 0, 0),
(2230, '00:00', '00:00', '0', NULL, NULL, 256, 1, 1, NULL, NULL, 0, 0),
(2231, '00:00', '00:00', '0', NULL, NULL, 256, 2, 1, NULL, NULL, 0, 0),
(2232, '00:00', '00:00', '0', NULL, NULL, 256, 3, 1, NULL, NULL, 0, 0),
(2233, '00:00', '00:00', '0', NULL, NULL, 256, 4, 1, NULL, NULL, 0, 0),
(2234, '00:00', '00:00', '0', NULL, NULL, 256, 5, 1, NULL, NULL, 0, 0),
(2235, '00:00', '00:00', '0', NULL, NULL, 256, 7, 1, NULL, NULL, 0, 0),
(2236, '00:00', '00:00', '0', NULL, NULL, 256, 8, 1, NULL, NULL, 0, 0),
(2237, '00:00', '00:00', '0', NULL, NULL, 256, 10, 1, NULL, NULL, 0, 0),
(2238, '00:00', '00:00', '0', NULL, NULL, 257, 1, 1, NULL, NULL, 0, 0),
(2239, '00:00', '00:00', '0', NULL, NULL, 257, 2, 1, NULL, NULL, 0, 0),
(2240, '00:00', '00:00', '0', NULL, NULL, 257, 3, 1, NULL, NULL, 0, 0),
(2241, '00:00', '00:00', '0', NULL, NULL, 257, 4, 1, NULL, NULL, 0, 0),
(2242, '00:00', '00:00', '0', NULL, NULL, 257, 5, 1, NULL, NULL, 0, 0),
(2243, '00:00', '00:00', '0', NULL, NULL, 257, 6, 1, NULL, NULL, 0, 0),
(2244, '00:00', '00:00', '0', NULL, NULL, 257, 7, 1, NULL, NULL, 0, 0),
(2245, '00:00', '00:00', '0', NULL, NULL, 257, 8, 1, NULL, NULL, 0, 0),
(2246, '00:00', '00:00', '0', NULL, NULL, 257, 10, 1, NULL, NULL, 0, 0),
(2247, '00:00', '00:00', '0', NULL, NULL, 258, 1, 1, NULL, NULL, 0, 0),
(2248, '00:00', '00:00', '0', NULL, NULL, 258, 2, 1, NULL, NULL, 0, 0),
(2249, '00:00', '00:00', '0', NULL, NULL, 258, 3, 1, NULL, NULL, 0, 0),
(2250, '00:00', '00:00', '0', NULL, NULL, 258, 4, 1, NULL, NULL, 0, 0),
(2251, '00:00', '00:00', '0', NULL, NULL, 258, 5, 1, NULL, NULL, 0, 0),
(2252, '00:00', '00:00', '0', NULL, NULL, 258, 6, 1, NULL, NULL, 0, 0),
(2253, '00:00', '00:00', '0', NULL, NULL, 258, 7, 1, NULL, NULL, 0, 0),
(2254, '00:00', '00:00', '0', NULL, NULL, 258, 8, 1, NULL, NULL, 0, 0),
(2255, '00:00', '00:00', '0', NULL, NULL, 258, 10, 1, NULL, NULL, 0, 0),
(2256, '00:00', '00:00', '0', NULL, NULL, 259, 1, 1, NULL, NULL, 0, 0),
(2257, '00:00', '00:00', '0', NULL, NULL, 259, 2, 1, NULL, NULL, 0, 0),
(2258, '00:00', '00:00', '0', NULL, NULL, 259, 3, 1, NULL, NULL, 0, 0),
(2259, '00:00', '00:00', '0', NULL, NULL, 259, 4, 1, NULL, NULL, 0, 0),
(2260, '00:00', '00:00', '0', NULL, NULL, 259, 5, 1, NULL, NULL, 0, 0),
(2261, '00:00', '00:00', '0', NULL, NULL, 259, 6, 1, NULL, NULL, 0, 0),
(2262, '00:00', '00:00', '0', NULL, NULL, 259, 7, 1, NULL, NULL, 0, 0),
(2263, '00:00', '00:00', '0', NULL, NULL, 259, 8, 1, NULL, NULL, 0, 0),
(2264, '00:00', '00:00', '0', NULL, NULL, 259, 10, 1, NULL, NULL, 0, 0),
(2265, '00:00', '00:00', '0', NULL, NULL, 260, 1, 1, NULL, NULL, 0, 0),
(2266, '00:00', '00:00', '0', NULL, NULL, 260, 2, 1, NULL, NULL, 0, 0),
(2267, '00:00', '00:00', '0', NULL, NULL, 260, 3, 1, NULL, NULL, 0, 0),
(2268, '00:00', '00:00', '0', NULL, NULL, 260, 4, 1, NULL, NULL, 0, 0),
(2269, '00:00', '00:00', '0', NULL, NULL, 260, 5, 1, NULL, NULL, 0, 0),
(2270, '00:00', '00:00', '0', NULL, NULL, 260, 6, 1, NULL, NULL, 0, 0),
(2271, '00:00', '00:00', '0', NULL, NULL, 260, 7, 1, NULL, NULL, 0, 0),
(2272, '00:00', '00:00', '0', NULL, NULL, 260, 8, 1, NULL, NULL, 0, 0),
(2273, '00:00', '00:00', '0', NULL, NULL, 260, 10, 1, NULL, NULL, 0, 0),
(2274, '00:00', '00:00', '0', NULL, NULL, 261, 1, 1, NULL, NULL, 0, 0),
(2275, '00:00', '00:00', '0', NULL, NULL, 261, 3, 1, NULL, NULL, 0, 0),
(2276, '00:00', '00:00', '0', NULL, NULL, 261, 4, 1, NULL, NULL, 0, 0),
(2277, '00:00', '00:00', '0', NULL, NULL, 261, 5, 1, NULL, NULL, 0, 0),
(2278, '00:00', '00:00', '0', NULL, NULL, 261, 6, 1, NULL, NULL, 0, 0),
(2279, '00:00', '00:00', '0', NULL, NULL, 261, 7, 1, NULL, NULL, 0, 0),
(2280, '00:00', '00:00', '0', NULL, NULL, 261, 8, 1, NULL, NULL, 0, 0),
(2281, '00:00', '00:00', '0', NULL, NULL, 261, 10, 1, NULL, NULL, 0, 0),
(2282, '00:00', '00:00', '0', NULL, NULL, 262, 1, 1, NULL, NULL, 0, 0),
(2283, '00:00', '00:00', '0', NULL, NULL, 262, 2, 1, NULL, NULL, 0, 0),
(2284, '00:00', '00:00', '0', NULL, NULL, 262, 3, 1, NULL, NULL, 0, 0),
(2285, '00:00', '00:00', '0', NULL, NULL, 262, 4, 1, NULL, NULL, 0, 0),
(2286, '00:00', '00:00', '0', NULL, NULL, 262, 5, 1, NULL, NULL, 0, 0),
(2287, '00:00', '00:00', '0', NULL, NULL, 262, 6, 1, NULL, NULL, 0, 0),
(2288, '00:00', '00:00', '0', NULL, NULL, 262, 7, 1, NULL, NULL, 0, 0),
(2289, '00:00', '00:00', '0', NULL, NULL, 262, 8, 1, NULL, NULL, 0, 0),
(2290, '00:00', '00:00', '0', NULL, NULL, 262, 10, 1, NULL, NULL, 0, 0),
(2291, '00:00', '00:00', '0', NULL, NULL, 263, 1, 1, NULL, NULL, 0, 0),
(2292, '00:00', '00:00', '0', NULL, NULL, 263, 2, 1, NULL, NULL, 0, 0),
(2293, '00:00', '00:00', '0', NULL, NULL, 263, 3, 1, NULL, NULL, 0, 0),
(2294, '00:00', '00:00', '0', NULL, NULL, 263, 4, 1, NULL, NULL, 0, 0),
(2295, '00:00', '00:00', '0', NULL, NULL, 263, 5, 1, NULL, NULL, 0, 0),
(2296, '00:00', '00:00', '0', NULL, NULL, 263, 6, 1, NULL, NULL, 0, 0),
(2297, '00:00', '00:00', '0', NULL, NULL, 263, 7, 1, NULL, NULL, 0, 0),
(2298, '00:00', '00:00', '0', NULL, NULL, 263, 8, 1, NULL, NULL, 0, 0),
(2299, '00:00', '00:00', '0', NULL, NULL, 263, 10, 1, NULL, NULL, 0, 0),
(2300, '00:00', '00:00', '0', NULL, NULL, 264, 1, 1, NULL, NULL, 0, 0),
(2301, '00:00', '00:00', '0', NULL, NULL, 264, 3, 1, NULL, NULL, 0, 0),
(2302, '00:00', '00:00', '0', NULL, NULL, 264, 4, 1, NULL, NULL, 0, 0),
(2303, '00:00', '00:00', '0', NULL, NULL, 264, 5, 1, NULL, NULL, 0, 0),
(2304, '00:00', '00:00', '0', NULL, NULL, 264, 6, 1, NULL, NULL, 0, 0),
(2305, '00:00', '00:00', '0', NULL, NULL, 264, 7, 1, NULL, NULL, 0, 0),
(2306, '00:00', '00:00', '0', NULL, NULL, 264, 8, 1, NULL, NULL, 0, 0),
(2307, '00:00', '00:00', '0', NULL, NULL, 264, 10, 1, NULL, NULL, 0, 0),
(2308, '00:00', '00:00', '0', NULL, NULL, 265, 1, 1, NULL, NULL, 0, 0),
(2309, '00:00', '00:00', '0', NULL, NULL, 265, 2, 1, NULL, NULL, 0, 0),
(2310, '00:00', '00:00', '0', NULL, NULL, 265, 3, 1, NULL, NULL, 0, 0),
(2311, '00:00', '00:00', '0', NULL, NULL, 265, 4, 1, NULL, NULL, 0, 0),
(2312, '00:00', '00:00', '0', NULL, NULL, 265, 5, 1, NULL, NULL, 0, 0),
(2313, '00:00', '00:00', '0', NULL, NULL, 265, 6, 1, NULL, NULL, 0, 0),
(2314, '00:00', '00:00', '0', NULL, NULL, 265, 7, 1, NULL, NULL, 0, 0),
(2315, '00:00', '00:00', '0', NULL, NULL, 265, 8, 1, NULL, NULL, 0, 0),
(2316, '00:00', '00:00', '0', NULL, NULL, 265, 10, 1, NULL, NULL, 0, 0),
(2317, '00:00', '00:00', '0', NULL, NULL, 266, 1, 1, NULL, NULL, 0, 0),
(2318, '00:00', '00:00', '0', NULL, NULL, 266, 2, 1, NULL, NULL, 0, 0),
(2319, '00:00', '00:00', '0', NULL, NULL, 266, 3, 1, NULL, NULL, 0, 0),
(2320, '00:00', '00:00', '0', NULL, NULL, 266, 4, 1, NULL, NULL, 0, 0),
(2321, '00:00', '00:00', '0', NULL, NULL, 266, 5, 1, NULL, NULL, 0, 0),
(2322, '00:00', '00:00', '0', NULL, NULL, 266, 6, 1, NULL, NULL, 0, 0),
(2323, '00:00', '00:00', '0', NULL, NULL, 266, 7, 1, NULL, NULL, 0, 0),
(2324, '00:00', '00:00', '0', NULL, NULL, 266, 8, 1, NULL, NULL, 0, 0),
(2325, '00:00', '00:00', '0', NULL, NULL, 266, 10, 1, NULL, NULL, 0, 0),
(2326, '00:00', '00:00', '0', NULL, NULL, 267, 1, 1, NULL, NULL, 0, 0),
(2327, '00:00', '00:00', '0', NULL, NULL, 267, 2, 1, NULL, NULL, 0, 0),
(2328, '00:00', '00:00', '0', NULL, NULL, 267, 3, 1, NULL, NULL, 0, 0),
(2329, '00:00', '00:00', '0', NULL, NULL, 267, 4, 1, NULL, NULL, 0, 0),
(2330, '00:00', '00:00', '0', NULL, NULL, 267, 5, 1, NULL, NULL, 0, 0),
(2331, '00:00', '00:00', '0', NULL, NULL, 267, 6, 1, NULL, NULL, 0, 0),
(2332, '00:00', '00:00', '0', NULL, NULL, 267, 7, 1, NULL, NULL, 0, 0),
(2333, '00:00', '00:00', '0', NULL, NULL, 267, 8, 1, NULL, NULL, 0, 0),
(2334, '00:00', '00:00', '0', NULL, NULL, 267, 10, 1, NULL, NULL, 0, 0),
(2335, '00:00', '00:00', '0', NULL, NULL, 268, 1, 1, NULL, NULL, 0, 0),
(2336, '00:00', '00:00', '0', NULL, NULL, 268, 3, 1, NULL, NULL, 0, 0),
(2337, '00:00', '00:00', '0', NULL, NULL, 268, 4, 1, NULL, NULL, 0, 0),
(2338, '00:00', '00:00', '0', NULL, NULL, 268, 5, 1, NULL, NULL, 0, 0),
(2339, '00:00', '00:00', '0', NULL, NULL, 268, 6, 1, NULL, NULL, 0, 0),
(2340, '00:00', '00:00', '0', NULL, NULL, 268, 7, 1, NULL, NULL, 0, 0),
(2341, '00:00', '00:00', '0', NULL, NULL, 268, 8, 1, NULL, NULL, 0, 0),
(2342, '00:00', '00:00', '0', NULL, NULL, 268, 10, 1, NULL, NULL, 0, 0),
(2343, '00:00', '00:00', '0', NULL, NULL, 269, 1, 1, NULL, NULL, 0, 0),
(2344, '00:00', '00:00', '0', NULL, NULL, 269, 3, 1, NULL, NULL, 0, 0),
(2345, '00:00', '00:00', '0', NULL, NULL, 269, 4, 1, NULL, NULL, 0, 0),
(2346, '00:00', '00:00', '0', NULL, NULL, 269, 5, 1, NULL, NULL, 0, 0),
(2347, '00:00', '00:00', '0', NULL, NULL, 269, 6, 1, NULL, NULL, 0, 0),
(2348, '00:00', '00:00', '0', NULL, NULL, 269, 7, 1, NULL, NULL, 0, 0),
(2349, '00:00', '00:00', '0', NULL, NULL, 269, 8, 1, NULL, NULL, 0, 0),
(2350, '00:00', '00:00', '0', NULL, NULL, 269, 10, 1, NULL, NULL, 0, 0),
(2351, '00:00', '00:00', '0', NULL, NULL, 270, 1, 1, NULL, NULL, 0, 0),
(2352, '00:00', '00:00', '0', NULL, NULL, 270, 2, 1, NULL, NULL, 0, 0),
(2353, '00:00', '00:00', '0', NULL, NULL, 270, 3, 1, NULL, NULL, 0, 0),
(2354, '00:00', '00:00', '0', NULL, NULL, 270, 4, 1, NULL, NULL, 0, 0),
(2355, '00:00', '00:00', '0', NULL, NULL, 270, 5, 1, NULL, NULL, 0, 0),
(2356, '00:00', '00:00', '0', NULL, NULL, 270, 6, 1, NULL, NULL, 0, 0),
(2357, '00:00', '00:00', '0', NULL, NULL, 270, 7, 1, NULL, NULL, 0, 0),
(2358, '00:00', '00:00', '0', NULL, NULL, 270, 8, 1, NULL, NULL, 0, 0),
(2359, '00:00', '00:00', '0', NULL, NULL, 270, 10, 1, NULL, NULL, 0, 0),
(2360, '00:00', '00:00', '0', NULL, NULL, 271, 1, 1, NULL, NULL, 0, 0),
(2361, '00:00', '00:00', '0', NULL, NULL, 271, 2, 1, NULL, NULL, 0, 0),
(2362, '00:00', '00:00', '0', NULL, NULL, 271, 3, 1, NULL, NULL, 0, 0),
(2363, '00:00', '00:00', '0', NULL, NULL, 271, 4, 1, NULL, NULL, 0, 0),
(2364, '00:00', '00:00', '0', NULL, NULL, 271, 5, 1, NULL, NULL, 0, 0),
(2365, '00:00', '00:00', '0', NULL, NULL, 271, 6, 1, NULL, NULL, 0, 0),
(2366, '00:00', '00:00', '0', NULL, NULL, 271, 7, 1, NULL, NULL, 0, 0),
(2367, '00:00', '00:00', '0', NULL, NULL, 271, 8, 1, NULL, NULL, 0, 0),
(2368, '00:00', '00:00', '0', NULL, NULL, 271, 10, 1, NULL, NULL, 0, 0),
(2369, '00:00', '00:00', '0', NULL, NULL, 272, 1, 1, NULL, NULL, 0, 0),
(2370, '00:00', '00:00', '0', NULL, NULL, 272, 3, 1, NULL, NULL, 0, 0),
(2371, '00:00', '00:00', '0', NULL, NULL, 272, 4, 1, NULL, NULL, 0, 0),
(2372, '00:00', '00:00', '0', NULL, NULL, 272, 5, 1, NULL, NULL, 0, 0),
(2373, '00:00', '00:00', '0', NULL, NULL, 272, 6, 1, NULL, NULL, 0, 0),
(2374, '00:00', '00:00', '0', NULL, NULL, 272, 7, 1, NULL, NULL, 0, 0),
(2375, '00:00', '00:00', '0', NULL, NULL, 272, 8, 1, NULL, NULL, 0, 0),
(2376, '00:00', '00:00', '0', NULL, NULL, 272, 10, 1, NULL, NULL, 0, 0),
(2377, '00:00', '00:00', '0', NULL, NULL, 273, 1, 1, NULL, NULL, 0, 0),
(2378, '00:00', '00:00', '0', NULL, NULL, 273, 3, 1, NULL, NULL, 0, 0),
(2379, '00:00', '00:00', '0', NULL, NULL, 273, 4, 1, NULL, NULL, 0, 0),
(2380, '00:00', '00:00', '0', NULL, NULL, 273, 5, 1, NULL, NULL, 0, 0),
(2381, '00:00', '00:00', '0', NULL, NULL, 273, 6, 1, NULL, NULL, 0, 0),
(2382, '00:00', '00:00', '0', NULL, NULL, 273, 7, 1, NULL, NULL, 0, 0),
(2383, '00:00', '00:00', '0', NULL, NULL, 273, 8, 1, NULL, NULL, 0, 0),
(2384, '00:00', '00:00', '0', NULL, NULL, 273, 10, 1, NULL, NULL, 0, 0),
(2385, '00:00', '00:00', '0', NULL, NULL, 274, 1, 1, NULL, NULL, 0, 0),
(2386, '00:00', '00:00', '0', NULL, NULL, 274, 2, 1, NULL, NULL, 0, 0),
(2387, '00:00', '00:00', '0', NULL, NULL, 274, 3, 1, NULL, NULL, 0, 0),
(2388, '00:00', '00:00', '0', NULL, NULL, 274, 4, 1, NULL, NULL, 0, 0),
(2389, '00:00', '00:00', '0', NULL, NULL, 274, 5, 1, NULL, NULL, 0, 0),
(2390, '00:00', '00:00', '0', NULL, NULL, 274, 6, 1, NULL, NULL, 0, 0),
(2391, '00:00', '00:00', '0', NULL, NULL, 274, 7, 1, NULL, NULL, 0, 0),
(2392, '00:00', '00:00', '0', NULL, NULL, 274, 8, 1, NULL, NULL, 0, 0),
(2393, '00:00', '00:00', '0', NULL, NULL, 274, 10, 1, NULL, NULL, 0, 0),
(2394, '00:00', '00:00', '0', NULL, NULL, 275, 1, 1, NULL, NULL, 0, 0),
(2395, '00:00', '00:00', '0', NULL, NULL, 275, 2, 1, NULL, NULL, 0, 0),
(2396, '00:00', '00:00', '0', NULL, NULL, 275, 3, 1, NULL, NULL, 0, 0),
(2397, '00:00', '00:00', '0', NULL, NULL, 275, 4, 1, NULL, NULL, 0, 0),
(2398, '00:00', '00:00', '0', NULL, NULL, 275, 5, 1, NULL, NULL, 0, 0),
(2399, '00:00', '00:00', '0', NULL, NULL, 275, 6, 1, NULL, NULL, 0, 0),
(2400, '00:00', '00:00', '0', NULL, NULL, 275, 7, 1, NULL, NULL, 0, 0),
(2401, '00:00', '00:00', '0', NULL, NULL, 275, 8, 1, NULL, NULL, 0, 0),
(2402, '00:00', '00:00', '0', NULL, NULL, 275, 10, 1, NULL, NULL, 0, 0);

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
  `fecha_salida` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `detalle_proyecto`
--

INSERT INTO `detalle_proyecto` (`idDetalle_proyecto`, `tipo_negocio_idtipo_negocio`, `canitadad_total`, `material`, `proyecto_numero_orden`, `negocio_idnegocio`, `estado_idestado`, `PNC`, `ubicacion`, `pro_porIniciar`, `pro_Ejecucion`, `pro_Pausado`, `pro_Terminado`, `tiempo_total`, `Total_timepo_Unidad`, `fecha_salida`) VALUES
(1, 1, '12', 'TH', 30520, 1, 3, 0, NULL, 0, 0, 0, 9, '627:59', '52:14', '2018-06-18 11:19:16'),
(2, 1, '4', 'FV', 30523, 1, 3, 0, NULL, 0, 0, 0, 8, '79:12', '19:44', '2018-06-15 06:51:35'),
(3, 1, '30', 'FV', 30524, 1, 3, 0, NULL, 0, 0, 0, 8, '167:07', '05:29', '2018-06-18 08:32:47'),
(4, 1, '30', 'FV', 30525, 1, 3, 0, NULL, 0, 0, 0, 8, '180:28', '05:57', '2018-06-18 10:30:18'),
(5, 1, '20', 'TH', 30528, 1, 3, 0, NULL, 0, 0, 0, 9, '525:18', '26:13', '2018-06-20 10:57:55'),
(6, 1, '10', 'TH', 30530, 1, 3, 0, NULL, 0, 0, 0, 9, '293:44', '29:19', '2018-06-18 08:58:15'),
(7, 1, '4', 'TH', 30531, 1, 3, 0, NULL, 0, 0, 0, 9, '511:29', '127:48', '2018-06-14 10:29:28'),
(8, 1, '2', 'TH', 30479, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(9, 1, '30', 'FV', 30533, 1, 3, 0, NULL, 0, 0, 0, 8, '608:35', '20:14', '2018-06-20 09:37:01'),
(10, 1, '10', 'TH', 30534, 1, 3, 0, NULL, 0, 0, 0, 9, '544:58', '50:40', '2018-06-19 07:48:37'),
(11, 1, '16', 'FV', 30535, 1, 3, 0, NULL, 0, 0, 0, 9, '72:43', '04:29', '2018-06-13 16:14:05'),
(12, 1, '2', 'FV', 30536, 1, 3, 0, NULL, 0, 0, 0, 9, '123:47', '00:00', '2018-06-14 06:27:36'),
(13, 1, '2', 'FV', 30537, 1, 3, 0, NULL, 0, 0, 0, 9, '94:09', '00:00', '2018-06-14 06:20:27'),
(14, 1, '14', 'FV', 30538, 1, 3, 0, NULL, 3, 0, 0, 6, '119:21', '00:00', NULL),
(15, 1, '30', 'FV', 30539, 1, 3, 0, NULL, 0, 0, 0, 8, '183:33', '06:05', '2018-06-18 07:25:47'),
(16, 1, '6', 'TH', 30541, 1, 3, 0, NULL, 0, 0, 0, 10, '491:48', '81:53', '2018-06-15 09:05:54'),
(17, 1, '20', 'TH', 30544, 1, 3, 0, NULL, 0, 0, 0, 9, '975:07', '45:39', '2018-06-20 16:13:33'),
(18, 1, '40', 'TH', 30543, 1, 3, 0, NULL, 0, 0, 0, 9, '486:40', '12:06', '2018-06-20 07:16:37'),
(19, 1, '45', 'TH', 30545, 1, 3, 0, NULL, 0, 0, 0, 9, '818:49', '17:53', '2018-06-20 07:21:48'),
(20, 1, '30', 'TH', 30546, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(21, 1, '6', 'TH', 30547, 1, 3, 0, NULL, 0, 0, 0, 10, '280:02', '46:37', '2018-06-22 08:39:42'),
(22, 1, '52', 'FV', 30548, 1, 3, 0, NULL, 0, 0, 0, 8, '365:29', '05:49', '2018-06-22 07:30:22'),
(23, 1, '4', 'TH', 30549, 1, 3, 0, NULL, 0, 0, 0, 9, '783:18', '195:47', '2018-06-19 07:48:08'),
(24, 1, '4', 'TH', 30550, 1, 3, 0, NULL, 0, 0, 0, 9, '406:54', '101:39', '2018-06-18 12:47:25'),
(25, 1, '10', 'TH', 30552, 1, 3, 0, NULL, 0, 0, 0, 9, '481:38', '47:02', '2018-06-20 15:01:37'),
(26, 1, '3', 'FV', 30553, 1, 3, 0, NULL, 0, 0, 0, 8, '112:35', '32:06', '2018-06-19 12:26:11'),
(27, 1, '10', 'TH', 30556, 1, 3, 0, NULL, 0, 0, 0, 9, '297:06', '17:03', '2018-06-21 11:40:51'),
(28, 1, '10', 'TH', 30555, 1, 3, 0, NULL, 0, 0, 0, 9, '904:15', '90:22', '2018-06-21 14:22:12'),
(29, 1, '10', 'TH', 30557, 1, 3, 0, NULL, 0, 0, 0, 9, '584:20', '53:49', '2018-06-25 07:09:25'),
(30, 1, '5', 'TH', 30558, 1, 3, 0, NULL, 0, 0, 0, 9, '279:19', '55:48', '2018-06-19 11:57:25'),
(31, 1, '10', 'TH', 30559, 1, 3, 0, NULL, 0, 0, 0, 9, '1874:55', '187:26', '2018-06-26 10:08:18'),
(32, 1, '10', 'TH', 30560, 1, 3, 0, NULL, 0, 0, 0, 9, '624:50', '62:26', '2018-06-21 08:35:48'),
(33, 1, '100', 'TH', 30561, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(34, 1, '10', 'TH', 30562, 1, 3, 0, NULL, 0, 0, 0, 9, '514:18', '51:22', '2018-06-26 11:19:31'),
(35, 1, '10', 'TH', 30563, 1, 3, 0, NULL, 0, 0, 0, 9, '1058:16', '105:46', '2018-06-27 14:12:21'),
(36, 1, '25', 'TH', 30564, 1, 3, 0, NULL, 0, 0, 0, 9, '709:14', '20:52', '2018-06-25 15:58:16'),
(37, 1, '10', 'FV', 30565, 1, 3, 0, NULL, 0, 0, 0, 8, '167:29', '16:41', '2018-06-21 07:26:55'),
(38, 1, '10', 'FV', 30566, 1, 3, 0, NULL, 0, 0, 0, 8, '191:13', '19:03', '2018-06-20 10:19:39'),
(39, 1, '10', 'FV', 30567, 1, 3, 0, NULL, 0, 0, 0, 8, '392:57', '39:14', '2018-06-20 16:13:52'),
(40, 1, '100', 'FV', 30569, 1, 3, 0, NULL, 0, 0, 0, 8, '857:47', '08:29', '2018-06-21 15:35:53'),
(41, 1, '6', 'TH', 30570, 1, 3, 0, NULL, 0, 0, 0, 9, '520:27', '86:41', '2018-06-20 07:04:37'),
(42, 1, '50', 'TH', 30573, 1, 3, 0, NULL, 0, 0, 0, 9, '890:33', '17:45', '2018-06-25 15:55:55'),
(43, 1, '10', 'TH', 30576, 1, 3, 0, NULL, 0, 0, 0, 9, '430:10', '42:57', '2018-06-25 09:54:10'),
(44, 1, '30', 'TH', 30579, 1, 2, 0, NULL, 7, 0, 0, 3, '501:55', '00:00', NULL),
(45, 1, '10', 'TH', 30580, 1, 3, 0, NULL, 0, 0, 0, 9, '453:22', '45:15', '2018-06-25 08:30:49'),
(46, 1, '100', 'TH', 30581, 1, 3, 0, NULL, 0, 0, 0, 9, '422:32', '04:12', '2018-06-28 09:46:49'),
(47, 1, '10', 'TH', 30584, 1, 3, 0, NULL, 0, 0, 0, 9, '899:37', '89:54', '2018-06-27 14:38:25'),
(48, 1, '12', 'TH', 30585, 1, 3, 0, NULL, 0, 0, 0, 10, '476:36', '35:30', '2018-06-27 15:31:30'),
(49, 1, '4', 'TH', 30586, 1, 3, 0, NULL, 0, 0, 0, 9, '716:55', '179:10', '2018-06-25 15:55:27'),
(50, 1, '10', 'TH', 30587, 1, 3, 0, NULL, 0, 0, 0, 9, '596:02', '53:32', '2018-06-27 14:12:02'),
(51, 1, '10', 'TH', 30593, 1, 3, 0, NULL, 0, 0, 0, 9, '541:49', '52:37', '2018-06-27 15:31:03'),
(52, 1, '200', 'FV', 30599, 1, 3, 0, NULL, 0, 0, 0, 8, '779:21', '03:49', '2018-07-03 06:36:46'),
(53, 1, '5', 'TH', 30600, 1, 3, 0, NULL, 0, 0, 0, 9, '529:33', '105:52', '2018-06-26 15:04:28'),
(54, 1, '2', 'TH', 30601, 1, 3, 0, NULL, 0, 0, 0, 10, '1169:28', '484:42', '2018-06-28 13:51:23'),
(55, 1, '10', 'FV', 30602, 1, 3, 0, NULL, 0, 0, 0, 8, '545:41', '53:01', '2018-07-03 12:06:25'),
(56, 1, '2', 'FV', 30603, 1, 3, 0, NULL, 0, 0, 0, 8, '212:39', '106:17', '2018-06-26 10:08:07'),
(58, 1, '6', 'TH', 30609, 1, 3, 0, NULL, 0, 0, 0, 9, '1020:27', '170:00', '2018-07-03 12:14:23'),
(59, 1, '28', 'FV', 30611, 1, 3, 0, NULL, 0, 0, 0, 8, '571:18', '20:20', '2018-07-05 15:59:53'),
(60, 1, '2', 'TH', 30613, 1, 3, 0, NULL, 0, 0, 0, 9, '376:08', '188:02', '2018-06-26 15:04:08'),
(61, 1, '2', 'TH', 30614, 1, 3, 0, NULL, 0, 0, 0, 9, '663:46', '294:51', '2018-06-28 14:44:34'),
(62, 1, '30', 'TH', 30615, 1, 3, 0, NULL, 0, 0, 0, 9, '385:08', '12:47', '2018-06-29 06:55:50'),
(63, 1, '6', 'TH', 30616, 1, 3, 0, NULL, 0, 0, 0, 9, '598:55', '89:47', '2018-06-27 09:27:08'),
(64, 1, '10', 'TH', 30617, 1, 3, 0, NULL, 0, 0, 0, 9, '400:46', '40:00', '2018-07-04 06:44:39'),
(65, 1, '2', 'TH', 30618, 1, 3, 0, NULL, 0, 0, 0, 9, '473:09', '236:31', '2018-07-03 08:38:24'),
(66, 1, '9', 'TH', 30619, 1, 3, 0, NULL, 0, 0, 0, 10, '1253:08', '128:14', '2018-07-04 11:29:02'),
(67, 1, '4', 'TH', 30625, 1, 3, 0, NULL, 0, 0, 0, 9, '700:15', '175:00', '2018-06-28 11:21:56'),
(68, 1, '9', 'TH', 30626, 1, 3, 0, NULL, 0, 0, 0, 9, '955:57', '106:10', '2018-07-05 16:00:11'),
(69, 1, '18', 'TH', 30628, 1, 2, 0, NULL, 3, 0, 1, 5, '1434:51', '00:00', NULL),
(70, 1, '2', 'TH', 30627, 1, 3, 0, NULL, 0, 0, 0, 9, '738:43', '369:20', '2018-06-28 16:29:37'),
(71, 1, '2', 'TH', 30629, 1, 3, 0, NULL, 0, 0, 0, 9, '408:54', '204:24', '2018-06-27 14:11:49'),
(72, 1, '4', 'TH', 30630, 1, 3, 0, NULL, 0, 0, 0, 9, '508:26', '127:05', '2018-07-03 12:00:29'),
(73, 1, '1', 'TH', 30631, 1, 3, 0, NULL, 0, 0, 0, 9, '692:46', '692:46', '2018-06-28 16:34:54'),
(74, 1, '7', 'TH', 30633, 1, 3, 0, NULL, 0, 0, 0, 9, '900:18', '128:33', '2018-07-05 10:11:51'),
(75, 1, '2', 'TH', 30632, 1, 3, 0, NULL, 0, 0, 0, 9, '553:37', '276:47', '2018-06-28 15:51:34'),
(76, 1, '10', 'TH', 30635, 1, 2, 0, NULL, 3, 0, 0, 6, '1134:22', '00:00', NULL),
(77, 1, '30', 'TH', 30636, 1, 3, 0, NULL, 0, 0, 0, 10, '561:06', '18:38', '2018-07-06 09:51:03'),
(78, 1, '1', 'TH', 30637, 1, 3, 0, NULL, 0, 0, 0, 9, '341:24', '341:24', '2018-06-27 15:27:15'),
(79, 1, '30', 'TH', 30638, 1, 3, 0, NULL, 0, 0, 0, 10, '533:28', '17:42', '2018-07-06 09:52:12'),
(81, 1, '6', 'TH', 30644, 1, 3, 0, NULL, 0, 0, 0, 10, '202:30', '33:41', '2018-07-06 09:53:48'),
(82, 1, '1', 'FV', 30646, 1, 2, 0, NULL, 1, 0, 0, 7, '171:23', '00:00', NULL),
(83, 1, '5', 'TH', 30647, 1, 3, 0, NULL, 0, 0, 0, 9, '762:09', '152:23', '2018-07-04 16:06:12'),
(84, 1, '5', 'FV', 30648, 1, 3, 0, NULL, 0, 0, 0, 8, '267:21', '53:25', '2018-07-03 11:51:50'),
(85, 1, '5', 'TH', 30649, 1, 3, 0, NULL, 0, 0, 0, 9, '601:49', '120:18', '2018-07-03 16:16:59'),
(86, 1, '15', 'TH', 30651, 1, 3, 0, NULL, 0, 0, 0, 9, '712:44', '47:26', '2018-07-04 16:12:25'),
(87, 1, '3', 'FV', 30654, 1, 3, 0, NULL, 0, 0, 0, 8, '391:26', '130:25', '2018-07-04 16:04:25'),
(88, 1, '5', 'FV', 30655, 1, 3, 0, NULL, 0, 0, 0, 8, '278:27', '55:39', '2018-07-03 11:56:43'),
(89, 1, '5', 'FV', 30656, 1, 3, 0, NULL, 0, 0, 0, 8, '395:44', '79:06', '2018-07-04 16:05:00'),
(90, 1, '6', 'TH', 30658, 1, 2, 0, NULL, 5, 0, 0, 5, '326:08', '00:00', NULL),
(91, 1, '2', 'TH', 30659, 1, 3, 0, NULL, 0, 0, 0, 9, '415:22', '207:40', '2018-07-05 12:01:34'),
(92, 1, '3', 'TH', 30661, 1, 3, 0, NULL, 0, 0, 0, 9, '446:46', '148:53', '2018-07-05 15:59:38'),
(93, 1, '3', 'TH', 30662, 1, 3, 0, NULL, 0, 0, 0, 9, '478:20', '159:24', '2018-07-05 15:59:24'),
(94, 1, '20', 'TH', 30663, 1, 2, 0, NULL, 7, 0, 1, 1, '584:05', '00:00', NULL),
(95, 1, '40', 'TH', 30664, 1, 2, 0, NULL, 8, 0, 1, 1, '589:58', '00:00', NULL),
(96, 1, '10', 'TH', 30665, 1, 2, 0, NULL, 6, 0, 1, 2, '756:24', '00:00', NULL),
(97, 1, '10', 'TH', 30666, 1, 3, 0, NULL, 0, 0, 0, 9, '858:25', '85:46', '2018-07-04 16:03:42'),
(98, 1, '5', 'TH', 30668, 1, 2, 0, NULL, 1, 0, 0, 8, '411:22', '00:00', NULL),
(99, 1, '6', 'TH', 30669, 1, 3, 0, NULL, 0, 0, 0, 9, '452:43', '75:26', '2018-07-05 14:51:09'),
(100, 1, '6', 'TH', 30671, 1, 2, 0, NULL, 6, 0, 0, 3, '593:07', '00:00', NULL),
(101, 1, '25', 'TH', 30674, 1, 2, 0, NULL, 8, 0, 0, 1, '58:55', '00:00', NULL),
(102, 1, '25', 'TH', 30675, 1, 2, 0, NULL, 8, 0, 0, 1, '90:06', '00:00', NULL),
(103, 1, '2', 'TH', 30677, 1, 3, 0, NULL, 0, 0, 0, 9, '319:27', '159:42', '2018-07-05 12:01:09'),
(104, 1, '4', 'TH', 30679, 1, 2, 0, NULL, 6, 0, 0, 4, '386:05', '00:00', NULL),
(105, 1, '50', 'FV', 30680, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(106, 1, '2', 'TH', 30684, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(107, 1, '2', 'FV', 30685, 1, 2, 0, NULL, 3, 0, 1, 4, '521:35', '00:00', NULL),
(108, 1, '6', 'TH', 30686, 1, 2, 0, NULL, 5, 0, 2, 3, '571:11', '00:00', NULL),
(109, 1, '50', 'TH', 30687, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(110, 1, '200', 'FV', 30688, 1, 2, 0, NULL, 6, 0, 0, 1, '29:33', '00:00', NULL),
(111, 1, '250', 'FV', 30689, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(112, 1, '30', 'TH', 30690, 1, 2, 0, NULL, 8, 0, 1, 0, '358:03', '00:00', NULL),
(113, 1, '10', 'TH', 30691, 1, 2, 0, NULL, 8, 0, 1, 0, '358:22', '00:00', NULL),
(114, 1, '20', 'FV', 30692, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(115, 1, '4', 'TH', 30693, 1, 2, 0, NULL, 8, 0, 1, 0, '358:10', '00:00', NULL),
(116, 1, '5', 'TH', 30694, 1, 2, 0, NULL, 4, 0, 1, 4, '239:16', '00:00', NULL),
(117, 1, '3', 'FV', 30697, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(118, 1, '3', 'TH', 30698, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(119, 1, '10', 'TH', 30700, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(120, 1, '1', 'TH', 30701, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(121, 1, '5', 'TH', 30702, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(122, 1, '10', 'TH', 30704, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(123, 1, '10', 'TH', 30703, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(124, 1, '3', 'TH', 30705, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(125, 1, '50', 'TH', 30706, 1, 2, 0, NULL, 8, 0, 0, 1, '00:00', '00:00', NULL),
(126, 1, '8', 'TH', 30708, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(127, 1, '100', 'FV', 30709, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(128, 1, '10', 'TH', 30710, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(129, 1, '1', 'TH', 30711, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(130, 1, '10', 'FV', 30712, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(131, 1, '10', 'FV', 30713, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(132, 1, '50', 'FV', 30714, 1, 4, 0, NULL, 7, 1, 0, 0, '27:48', '00:00', NULL),
(133, 1, '3', 'TH', 30715, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(134, 1, '2', 'FV', 30717, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(135, 1, '10', 'FV', 30719, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(136, 1, '10', 'FV', 30720, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(137, 1, '20', 'TH', 30721, 1, 2, 0, NULL, 3, 0, 0, 6, '412:48', '00:00', NULL),
(138, 1, '30', 'FV', 30722, 1, 2, 0, NULL, 7, 0, 0, 1, '134:15', '00:00', NULL),
(139, 1, '5', 'TH', 30723, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(140, 1, '20', 'FV', 30724, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(141, 1, '20', 'FV', 30725, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(142, 1, '30', 'TH', 30718, 1, 2, 0, NULL, 4, 0, 0, 5, '802:09', '00:00', NULL),
(143, 1, '2', 'TH', 30729, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(144, 1, '2', 'TH', 30730, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(145, 1, '30', 'TH', 30731, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(146, 1, '100', 'TH', 30736, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(147, 1, '6', 'TH', 30737, 1, 2, 0, NULL, 9, 0, 1, 0, '38:25', '00:00', NULL),
(148, 1, '6', 'TH', 30738, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(149, 1, '200', 'TH', 30742, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL),
(150, 1, '2', 'FV', 30745, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(151, 1, '5', 'TH', 30746, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(152, 1, '5', 'FV', 30747, 1, 2, 0, NULL, 6, 0, 1, 1, '24:44', '00:00', NULL),
(153, 1, '6', 'TH', 30748, 1, 2, 0, NULL, 8, 0, 0, 1, '00:00', '00:00', NULL),
(154, 1, '2', 'TH', 30750, 1, 2, 0, NULL, 7, 0, 0, 2, '69:03', '00:00', NULL),
(155, 1, '2', 'TH', 30752, 1, 2, 0, NULL, 8, 0, 0, 1, '00:00', '00:00', NULL),
(156, 1, '2', 'TH', 30753, 1, 2, 0, NULL, 8, 0, 0, 1, '85:06', '00:00', NULL),
(157, 1, '200', 'FV', 30757, 1, 2, 0, NULL, 7, 0, 1, 0, '51:54', '00:00', NULL),
(158, 1, '6', 'TH', 30759, 1, 2, 0, NULL, 8, 0, 0, 1, '06:09', '00:00', NULL),
(159, 1, '100', 'FV', 30760, 1, 2, 0, NULL, 7, 0, 0, 1, '108:09', '00:00', NULL),
(160, 1, '10', 'FV', 30761, 1, 2, 0, NULL, 7, 0, 0, 1, '33:28', '00:00', NULL),
(161, 1, '2', 'TH', 30762, 1, 4, 0, NULL, 8, 1, 0, 0, '88:21', '00:00', NULL),
(162, 1, '20', 'FV', 30763, 1, 2, 0, NULL, 7, 0, 0, 1, '40:57', '00:00', NULL),
(163, 1, '5', 'TH', 30765, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(164, 1, '1', 'TH', 30766, 1, 2, 0, NULL, 5, 0, 0, 4, '263:47', '00:00', NULL),
(165, 1, '1', 'TH', 30767, 1, 2, 0, NULL, 8, 0, 0, 1, '40:21', '00:00', NULL),
(166, 1, '4', 'TH', 30769, 1, 2, 0, NULL, 3, 0, 1, 5, '534:14', '00:00', NULL),
(167, 1, '24', 'TH', 30770, 1, 2, 0, NULL, 7, 0, 1, 1, '77:11', '00:00', NULL),
(168, 1, '5', 'TH', 30771, 1, 2, 0, NULL, 3, 0, 0, 6, '419:53', '00:00', NULL),
(169, 1, '6', 'TH', 30775, 1, 2, 0, NULL, 8, 0, 0, 1, '88:34', '00:00', NULL),
(170, 1, '2', 'TH', 30780, 1, 2, 0, NULL, 7, 0, 1, 1, '10:27', '00:00', NULL),
(171, 1, '4', 'TH', 30781, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(172, 1, '2', 'FV', 30782, 1, 2, 0, NULL, 7, 0, 1, 0, '20:24', '00:00', NULL),
(173, 1, '15', 'TH', 30783, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(174, 1, '50', 'FV', 30784, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(175, 1, '100', 'FV', 30786, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(176, 1, '1000', 'FV', 30785, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(177, 1, '50', 'TH', 30788, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(178, 1, '5', 'FV', 30789, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(179, 1, '4', 'TH', 30791, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(180, 1, '200', 'FV', 30792, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(181, 1, '5', 'TH', 30795, 1, 4, 0, NULL, 8, 1, 0, 0, '00:00', '00:00', NULL),
(182, 1, '80', 'FV', 30796, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(183, 1, '10', 'TH', 30797, 1, 2, 0, NULL, 8, 0, 0, 1, '83:27', '00:00', NULL),
(184, 1, '40', 'FV', 30808, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(185, 1, '5', 'FV', 30810, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(186, 1, '16', 'FV', 30811, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(187, 1, '3', 'TH', 30812, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(188, 1, '20', 'FV', 30814, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(189, 1, '4', 'TH', 30816, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(190, 1, '10', 'FV', 30818, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(191, 1, '5', 'FV', 30819, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(192, 1, '50', 'TH', 30820, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(193, 1, '15', 'FV', 30822, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(194, 1, '3', 'FV', 30824, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(195, 1, '40', 'FV', 30825, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(196, 1, '10', 'TH', 30832, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(197, 1, '50', 'TH', 30833, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(198, 1, '50', 'FV', 30834, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(199, 1, '10', 'FV', 30835, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(200, 1, '10', 'TH', 30842, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(201, 1, '5', 'FV', 30845, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(202, 1, '5', 'FV', 30847, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(203, 1, '4', 'FV', 30846, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(204, 1, '20', 'FV', 30848, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(205, 1, '5', 'FV', 30849, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(206, 1, '2', 'TH', 30850, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(207, 1, '2', 'TH', 30851, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(208, 1, '6', 'TH', 30853, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(209, 1, '6', 'TH', 30854, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(210, 1, '5', 'TH', 30857, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(211, 1, '25', 'TH', 30859, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(212, 1, '50', 'TH', 30862, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(213, 1, '8', 'TH', 30863, 1, 1, 0, NULL, 10, 0, 0, 0, '00:00', '00:00', NULL),
(214, 1, '20', 'TH', 30864, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(215, 1, '20', 'TH', 30865, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(216, 1, '2', 'FV', 30866, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(217, 1, '2', 'FV', 30867, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(218, 1, '2', 'TH', 30869, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(219, 1, '30', 'TH', 30868, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(220, 1, '12', 'TH', 30870, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(221, 1, '100', 'TH', 30799, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(222, 1, '6', 'TH', 30871, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(223, 1, '6', 'TH', 30872, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(224, 1, '15', 'TH', 30874, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(225, 1, '20', 'TH', 30875, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(226, 1, '5', 'TH', 30876, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(227, 1, '3', 'TH', 30877, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(228, 1, '4', 'TH', 30878, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(229, 1, '4', 'TH', 30879, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(230, 1, '20', 'TH', 30881, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(231, 1, '50', 'TH', 30883, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(232, 1, '2', 'TH', 30884, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(233, 1, '200', 'FV', 30885, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(234, 1, '100', 'FV', 30886, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(235, 1, '30', 'FV', 30887, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(236, 1, '10', 'TH', 30888, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(237, 1, '160', 'FV', 30890, 1, 1, 0, NULL, 7, 0, 0, 0, '00:00', '00:00', NULL),
(238, 1, '40', 'FV', 30891, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(239, 1, '2', 'TH', 30892, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(240, 1, '100', 'TH', 30896, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(241, 1, '5', 'TH', 30897, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(242, 1, '2', 'TH', 30901, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(243, 1, '1', 'TH', 30902, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(244, 1, '10', 'TH', 30905, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(245, 1, '100', 'FV', 30906, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(246, 1, '100', 'FV', 30907, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(247, 1, '4', 'TH', 30908, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(248, 1, '40', 'TH', 30909, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(249, 1, '3', 'FV', 30911, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(250, 1, '50', 'TH', 30914, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(251, 1, '20', 'TH', 30916, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(252, 1, '4', 'TH', 30931, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(253, 1, '4', 'TH', 30932, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(254, 1, '4', 'TH', 30933, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(255, 1, '10', 'TH', 30936, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(256, 1, '20', 'TH', 30937, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(257, 1, '5', 'TH', 30939, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(258, 1, '4', 'TH', 30940, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(259, 1, '50', 'TH', 30941, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(260, 1, '5', 'TH', 30942, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(261, 1, '30', 'FV', 30943, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(262, 1, '5', 'TH', 30944, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(263, 1, '3', 'TH', 30945, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(264, 1, '2', 'FV', 30946, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(265, 1, '5', 'TH', 30947, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(266, 1, '10', 'TH', 30948, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(267, 1, '10', 'TH', 30949, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(268, 1, '20', 'FV', 30950, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(269, 1, '15', 'FV', 30951, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(270, 1, '4', 'TH', 30952, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(271, 1, '100', 'TH', 30953, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(272, 1, '1', 'FV', 30961, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(273, 1, '20', 'FV', 30963, 1, 1, 0, NULL, 8, 0, 0, 0, '00:00', '00:00', NULL),
(274, 1, '10', 'TH', 30964, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL),
(275, 1, '3', 'TH', 30965, 1, 1, 0, NULL, 9, 0, 0, 0, '00:00', '00:00', NULL);

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
  `hora_ejecucion` time DEFAULT NULL,
  `hora_terminacion` time DEFAULT NULL,
  `restantes` int(6) NOT NULL DEFAULT '0',
  `noperarios` tinyint(2) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
(30479, '1128266934', 'CRISTIAN CAMILO VELA MERCHAN ', 'TARJETA FINAL CONTROL ENERGIA ELECTRICA ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 08:28:05', '2018-06-13', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30520, '1128266934', 'FRANCISCO ANTONIO CARVAJAL ', 'GERBER CONTROL PUERTA_V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-07 13:35:20', '2018-06-20', '2018-06-18 11:19:16', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30523, '1128266934', 'DANIEL CUARTAS QUICENO ', 'ECU1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-07 16:38:56', '2018-06-14', '2018-06-15 06:51:35', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30524, '1128266934', 'DIGITALTEC S.A.S ', 'PERILLA C001 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-07 16:42:49', '2018-06-20', '2018-06-18 08:32:47', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30525, '98765201', 'DIGITALTEC S.A.S ', 'PERILLA C002 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-07 16:54:24', '2018-06-20', '2018-06-18 10:30:18', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30528, '98765201', 'JHON GERMAN GARCIA G ', 'AVP_20180405 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-08 12:07:17', '2018-06-22', '2018-06-20 10:57:55', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30530, '98765201', 'FABIO ENRIQUEZ URIBE ', 'PURIFICADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-08 15:23:58', '2018-06-20', '2018-06-18 08:58:15', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30531, '98765201', 'CORPORACION PARQUE EXPLORA ', 'MUS0202 CENTRALR0 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 07:50:39', '2018-06-15', '2018-06-14 10:29:28', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30533, '1128266934', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MVF_RF_4_S_PW ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 09:27:48', '2018-06-22', '2018-06-20 09:37:01', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30534, '1128266934', 'JHON GERMAN GARCIA G ', 'PMR_20180608 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 10:25:06', '2018-06-21', '2018-06-19 07:48:37', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30535, '98765201', 'RPM INGENIEROS S.A.S ', 'FICHO PCB ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 15:08:03', '2018-06-13', '2018-06-13 16:14:05', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30536, '98765201', 'TECREA S.A.S ', 'Caja Embriones mosaico 1 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 15:14:42', '2018-06-14', '2018-06-14 06:27:36', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30537, '98765201', 'TECREA S.A.S ', 'Caja Embriones mosaico 2 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 15:31:09', '2018-06-14', '2018-06-14 06:20:27', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30538, '98765201', 'TECREA S.A.S ', 'Caja Embriones mosaico 3 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 16:09:52', '2018-06-14', '2018-06-14 15:09:52', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30539, '98765201', 'MICHAEL ATEHORTUA HENAO ', 'SIMO DICE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 16:41:15', '2018-06-22', '2018-06-18 07:25:47', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30541, '98765201', 'LIBARDO ANDRES MONTOYA GOMEZ ', 'PCB1_oximeter ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 17:27:55', '2018-06-18', '2018-06-15 09:05:54', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30543, '1128266934', 'CORPORACION PARA LA INVESTIGACION DE LA CORROSION (CIC) ', 'RMU CPR RLite V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 17:40:33', '2018-06-25', '2018-06-20 07:16:37', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30544, '1128266934', 'CORPORACION PARA LA INVESTIGACION DE LA CORROSION (CIC) ', 'RMU CPR PORTABLE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 17:36:45', '2018-06-25', '2018-06-20 16:13:33', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30545, '98765201', 'CORPORACION PARA LA INVESTIGACION DE LA CORROSION (CIC) ', 'RMU CPR Vlite ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-12 17:40:39', '2018-06-25', '2018-06-20 07:21:48', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30546, '98765201', 'MAURICIO VASCO  OPTEC ', '75TPDUL V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-13 11:06:15', '2018-06-26', NULL, 0, 0, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, 'El QR de este proyecto esta presentando inconvenientes a la hora de realizar la respectiva lectura, por favor cambiar el QR o ver que sucede con el proceso de su implementación. ', NULL, NULL),
(30547, '98765201', 'SOPORTE Y LOGISTICA S.A.S ', 'Nflood%20GPS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-13 12:24:34', '2018-06-25', '2018-06-22 08:39:42', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30548, '98765201', 'DYNAMIC TRAINING S.A.S. ', 'PIENSA SEGURO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-13 17:32:41', '2018-06-27', '2018-06-22 07:30:22', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30549, '98765201', 'JEFFERSON DAVID CORREA ', ' UDEM_METEOR_FIX ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 07:22:42', '2018-06-21', '2018-06-19 07:48:08', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30550, '1128266934', 'SMARTECH INGENIER%C3%8DA SAS ', 'tarjeta modbus RTU ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 11:16:18', '2018-06-21', '2018-06-18 12:47:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30552, '1128266934', 'SIOMA SAS ', 'RSP V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 14:47:46', '2018-06-25', '2018-06-20 15:01:37', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30553, '1128266934', 'ANDRES MAURICIO HOLGUIN BERROCAL ', ' sensor_V ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 16:21:04', '2018-06-20', '2018-06-19 12:26:12', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30555, '98765201', 'UNIVERSIDAD DE MEDELLIN ', 'POTENCIA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 17:39:47', '2018-06-25', '2018-06-21 14:22:12', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30556, '98765201', 'UNIVERSIDAD DE MEDELLIN ', 'TERMOPARES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 17:36:32', '2018-06-25', '2018-06-21 11:40:51', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30557, '98765201', 'UNIVERSIDAD DE MEDELLIN ', ' MICROSWITCH ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-14 17:41:48', '2018-06-25', '2018-06-25 07:09:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30558, '98765201', 'A MAQ S.A. ', 'A92100518 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 08:32:03', '2018-06-22', '2018-06-19 11:57:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30559, '98765201', 'ELEVADORES INTEGRAL SAS ', 'A11K_ABR2017 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 11:31:19', '2018-06-28', '2018-06-26 10:08:18', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30560, '98765201', 'MILTON ORTEGA DELGADO ', 'SHIELD ARDUINO UNO SIN REGULADOR EXTERNO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 11:32:39', '2018-06-26', '2018-06-21 08:35:48', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30561, '98765201', 'ELEVADORES INTEGRAL SAS ', 'SPI_v_5_0_dic2016 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 11:46:59', '2018-07-04', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30562, '1128266934', 'BELLY BUTTON SAS ', 'ECO 5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 14:56:27', '2018-06-26', '2018-06-26 11:19:31', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30563, '1128266934', 'EDUARDO RODRIGUEZ MEJ%C3%8DA ', 'CUK 2.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 15:58:23', '2018-06-26', '2018-06-27 14:12:21', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30564, '1128266934', 'MICRO HOM S.A.S ', 'ARRANQUE V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 16:19:00', '2018-06-28', '2018-06-25 15:58:16', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30565, '98765201', 'RPM INGENIEROS S.A.S ', 'BOTONES PMR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-15 17:32:33', '2018-06-25', '2018-06-21 07:26:55', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30566, '98765201', 'MARIO STYVEN VELANDIA IBARRA ', ' BT V.1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-18 07:33:42', '2018-06-26', '2018-06-20 10:19:39', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30567, '98765201', 'MARIO STYVEN VELANDIA IBARRA ', ' FUENTE V.1.2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-18 07:34:56', '2018-06-26', '2018-06-20 16:13:52', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30569, '98765201', 'OSWALDO PUERTA TOVAR ', 'Vel_2dig_display_2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-18 11:18:30', '2018-07-03', '2018-06-21 15:35:53', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30570, '98765201', 'UNIVERSIDAD PONTIFICIA BOLIVARIANA ', 'SMARTCARD_3 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-18 11:26:14', '2018-06-19', '2018-06-20 07:04:37', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30573, '98765201', 'GROUND ELECTRONICS ', '13 TM 2X3 V1.0,1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-18 17:16:15', '2018-06-29', '2018-06-25 15:55:55', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30576, '98765201', 'JUAN JAIBER YEPES ZAPATA ', 'BOTONERA_DALI ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-19 13:49:14', '2018-06-28', '2018-06-25 09:54:10', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30579, '98765201', 'GECKORP S.A.S ', ' CORIUM ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-19 16:59:20', '2018-07-03', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30580, '98765201', 'JHON GERMAN GARCIA G ', 'TA_20180613 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-19 17:06:37', '2018-06-28', '2018-06-25 08:30:50', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30581, '98765201', 'JHON GERMAN GARCIA G ', 'ARREGLO DE LEDS V4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-19 17:16:12', '2018-07-06', '2018-06-28 09:46:49', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30584, '98765201', 'BIOINNOVA S.A.S ', 'ALATMA 2_8 V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-20 11:13:03', '2018-06-29', '2018-06-27 14:38:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30585, '98765201', 'GRUPO MASLER ROBOTICS ', 'SENSOR HALL PANEL X 12 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-20 13:52:33', '2018-07-03', '2018-06-27 15:31:30', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30586, '98765201', 'JUAN PABLO VARGAS MARTINEZ ', 'M95_BOARDV1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-20 15:58:24', '2018-06-27', '2018-06-25 15:55:27', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30587, '98765201', 'DIVERTRONICA MEDELLIN S.A ', 'LUCES FLASHER 555 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-20 16:22:23', '2018-06-29', '2018-06-27 14:12:02', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30593, '98765201', 'UNIVERSIDAD EAFIT ', 'TEMP_CONTROLLER_PID_GERBER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-21 17:15:13', '2018-07-03', '2018-06-27 15:31:03', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30599, '98765201', 'ALVARO ANDRES GUZMAN CASTA%C3%91EDA ', 'CONTROLADORA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 11:38:16', '2018-07-16', '2018-07-03 06:36:46', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30600, '98765201', 'MEDENCOL ', 'MANDO ELECTRICA DIGITAL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 11:51:08', '2018-06-29', '2018-06-26 15:04:28', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30601, '98765201', 'MEDENCOL ', 'EQUIPO EVO II 2014 CON MANDO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 11:52:33', '2018-06-29', '2018-06-28 13:51:23', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(30602, '98765201', 'MEDENCOL ', 'SILLON ELECTRICO EYECTOR INFRAROJO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 11:53:37', '2018-07-03', '2018-07-03 12:06:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30603, '98765201', 'RPM INGENIEROS S.A.S ', 'INDICADOR DE CARGA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 11:56:39', '2018-06-28', '2018-06-26 10:08:07', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30609, '98765201', 'NOVA CONTROL S.A.S ', 'CONTROL_VARIADORV7 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-22 16:31:37', '2018-07-05', '2018-07-03 12:14:23', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30611, '1216714539', 'JAVIER ARTURO GARCIA MURILLO ', 'Javier_Garcia_PlacaV1.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 08:29:13', '2018-07-06', '2018-07-05 15:59:53', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30613, '1152697088', 'EPM ', 'CRL_V.1.0_19 06 2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 10:27:24', '2018-07-03', '2018-06-26 15:04:08', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30614, '1152697088', 'IDEKA S.A.S ', 'Delux Board ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 12:22:49', '2018-07-03', '2018-06-28 14:44:34', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30615, '1152697088', 'CINDETEMM ', 'RELEV4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 12:30:38', '2018-07-09', '2018-06-29 06:55:50', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30616, '1152697088', 'TECONDOR S.A.S ', 'TRANSWOR tarjeta 1 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 15:34:37', '2018-06-26', '2018-06-27 09:27:08', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30617, '1152697088', 'NEARME LABS ', 'NEARME LABS   PCB   NOV 24 17 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 15:35:45', '2018-07-05', '2018-07-04 06:44:39', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30618, '1152697088', 'SERTISOFT S.A.S ', 'SS_MON ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 15:49:06', '2018-07-03', '2018-07-03 08:38:24', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30619, '1152697088', 'SERTISOFT S.A.S ', ' PANEL TODAS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-25 15:50:51', '2018-07-05', '2018-07-04 11:29:02', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30625, '1216714539', 'SONAR AVL SYSTEM S.A.S ', 'INS43_Contador_IrR2 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 09:42:33', '2018-06-27', '2018-06-28 11:21:56', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30626, '1216714539', 'ENERGIA Y TELECOMUNICACIONES INGENIERIA LTDA ', 'Sr. DARIO ANDRES ECHAVARRIA LONDO%C3%91O ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 10:51:11', '2018-07-06', '2018-07-05 16:00:11', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30627, '1216714539', 'INDUSTRIAS METALICAS LOS PINOS ', 'DRIVER 5M ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 11:06:54', '2018-06-29', '2018-06-28 16:29:37', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30628, '1216714539', 'ENERGIA Y TELECOMUNICACIONES INGENIERIA LTDA ', 'CARGADOR EPM2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 10:58:10', '2018-07-09', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30629, '1152697088', 'CRISTIAN CAMILO VELA MERCHAN ', 'GERBER ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 11:09:37', '2018-06-27', '2018-06-27 14:11:49', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30630, '1152697088', 'ROVOFIC DESIGMH ', 'ROVOFIC32U4_Baby3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 11:17:55', '2018-07-04', '2018-07-03 12:00:29', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30631, '1216714539', 'ESTEBAN RAVE ', 'RECOBRADOR SIN FUENTE ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 11:44:41', '2018-06-29', '2018-06-28 16:34:54', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30632, '1216714539', 'RAFAEL VEGA ', 'PCB1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 14:15:56', '2018-07-04', '2018-06-28 15:51:34', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30633, '1216714539', 'RAFAEL VEGA ', 'PCB3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 14:14:21', '2018-07-06', '2018-07-05 10:11:51', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30635, '981130', 'JUAN FERNANDO OSORIO TRUJILLO ', 'ALARMA_MIFE03 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 15:07:27', '2018-07-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30636, '981130', 'UNIVERSIDAD DE LOS ANDES ', 'SAMPLE HOLDER M12_VU ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 15:27:57', '2018-07-10', '2018-07-06 09:51:03', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30637, '981130', 'PMP INGENIERIA ', 'BATERIA V1.0 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 15:37:01', '2018-06-27', '2018-06-27 15:27:15', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30638, '981130', 'UNIVERSIDAD DE LOS ANDES ', 'SAMPLE HOLDER U_V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-26 15:46:20', '2018-07-10', '2018-07-06 09:52:12', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30644, '1216714539', 'LA CASA DEL FORRO ', 'PANEL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 08:45:04', '2018-07-06', '2018-07-06 09:53:48', 1, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', 'A tiempo', NULL),
(30646, '1216714539', 'JAVIER ENRIQUE MARIN LOPERA ', 'CONTROL 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 14:21:06', '2018-07-04', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30647, '1216714539', 'DEL AGRO SOLUCIONES PARA EL CAMPO SAS ', 'SEGURIDAD P ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 15:18:34', '2018-07-05', '2018-07-04 16:06:12', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30648, '1216714539', 'DEL AGRO SOLUCIONES PARA EL CAMPO SAS ', 'SEGURIDAD V ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 15:24:18', '2018-07-04', '2018-07-03 11:51:50', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30649, '1216714539', 'DEL AGRO SOLUCIONES PARA EL CAMPO SAS ', 'PROBADOR J ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 15:27:58', '2018-07-05', '2018-07-03 16:16:59', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30651, '1216714539', 'AGRUM TECNOLOGIA S.A.S. ', 'BigBrotherHW ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-27 16:41:15', '2018-07-10', '2018-07-04 16:12:26', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30654, '981130', 'ANDRES MAURICIO HOLGUIN BERROCAL ', 'SENSOR_SINC ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-28 12:47:21', '2018-07-05', '2018-07-04 16:04:25', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30655, '981130', 'ANDRES FELIPE TORRES ', 'ARBURG 221 MULTRONICA 14 PINES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-28 14:35:24', '2018-07-05', '2018-07-03 11:56:43', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30656, '981130', 'ANDRES FELIPE TORRES ', 'ARBURG 221 MULTRONICA 34 PINES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-28 14:36:29', '2018-07-05', '2018-07-04 16:05:00', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30658, '981130', 'UNIVERSIDAD EAFIT ', 'DISCO LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-28 15:47:47', '2018-07-10', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30659, '981130', 'UNIVERSIDAD EAFIT ', 'FREE METER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-28 15:49:13', '2018-07-06', '2018-07-05 12:01:34', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30661, '1152697088', 'UNIVERSIDAD EAFIT ', 'BMS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 07:41:40', '2018-07-09', '2018-07-05 15:59:38', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30662, '1152697088', 'UNIVERSIDAD EAFIT ', 'CONTROLLERS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 07:45:31', '2018-07-09', '2018-07-05 15:59:24', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30663, '1152697088', 'SISTEMA SONORO DE COLOMBIA LTDA ', 'SNT054 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 10:00:25', '2018-07-13', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30664, '1152697088', 'COINS S.A.S ', 'PR.7z ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 10:28:00', '2018-07-13', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30665, '1152697088', 'UNIVERSIDAD DE LOS ANDES ', 'FLOW SWITCH PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 10:39:19', '2018-07-11', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30666, '1152697088', 'ANDRES FELIPE BERMUDEZ ARANGO ', ' NODE ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 10:56:51', '2018-07-06', '2018-07-04 16:03:42', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30668, '1152697088', 'CASAS AUTOMATICAS LTDA ', 'CAMARA DE COMERCIO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 17:02:44', '2018-07-09', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30669, '1152697088', 'JUAN DAVID ROMAN GUTIERREZ ', 'DRIVER BOARD ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-06-29 17:14:02', '2018-07-06', '2018-07-05 14:51:09', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30671, '1216714539', 'NICOLAS LOPEZ ESTRADA ', 'MiniSumo ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-03 16:10:12', '2018-07-12', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30674, '1216714539', 'MICRO HOM S.A.S ', 'CARGADOR BATERIA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-03 17:16:35', '2018-07-16', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30675, '1216714539', 'MICRO HOM S.A.S ', 'CONTROL PLANTA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-03 17:17:43', '2018-07-16', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30677, '1216714539', 'NOVA CONTROL S.A.S ', 'CONTROL V1 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-03 17:18:34', '2018-07-04', '2018-07-05 12:01:09', 0, 1, 3, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30679, '1216714539', 'UNIVERSIDAD EAFIT ', 'CAMARA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 07:53:02', '2018-07-11', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30680, '1216714539', 'MAD INGENIEROS LTDA ', 'CXD_Lolin_IC_376S_v1.3_08junio2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 08:57:09', '2018-07-16', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30684, '1152697088', 'NETUX S.A.S ', 'OUTPUT FOR NXSENSOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 13:27:17', '2018-07-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30685, '1216714539', 'HERNANDO GAMA DUARTE ', 'EQ GALVANICO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 14:01:31', '2018-07-10', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30686, '1216714539', 'GROUND ELECTRONICS ', '71 MOSAICO DL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 15:35:43', '2018-07-13', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30687, '1152697088', 'MAURICIO VASCO  OPTEC ', 'TD48A25TP_PZ_V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 15:52:29', '2018-07-17', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30688, '1152697088', 'MAURICIO VASCO  OPTEC ', 'TECNOP2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 16:13:37', '2018-07-26', NULL, 0, 0, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30689, '1152697088', 'MAURICIO VASCO  OPTEC ', '25DCV2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 16:33:12', '2018-07-31', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30690, '1152697088', 'LINARQ SAS ', 'BOTON_LLAMDO_ENFERMERA_V2.3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-04 16:37:59', '2018-07-17', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30691, '1152697088', 'ISWITCH   ANDRES FERNANDO ORTIZ TORRES ', 'Iswitch ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 08:02:54', '2018-07-16', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30692, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MVF_RF_2S_PW ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 11:48:36', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30693, '1152697088', 'LINARQ SAS ', 'CENTRAL LLAMADO V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 12:01:46', '2018-07-12', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30694, '1152697088', 'A MAQ S.A. ', 'A92100518 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 12:21:28', '2018-07-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30697, '1152697088', 'CESAR MORENO ', '8 TECLAS C ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 15:01:41', '2018-07-11', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30698, '1152697088', 'CESAR MORENO ', 'CONTROL 8 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-05 15:08:18', '2018-07-12', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30700, '1216714539', 'PIMEDICA S.A ', 'FUENTE GATEWAY ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 09:43:04', '2018-07-18', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30701, '1216714539', 'NORBERTO HERRERA HOYOS ', ' DISPLAY ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 09:56:34', '2018-07-13', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30702, '1152697088', 'ENTER SITE LTDA ', 'CONT_REV3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 11:36:59', '2018-07-13', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30703, '1216714539', 'CESAR MORENO ', 'K LINK SAT OUT 7 3 2017 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 14:39:01', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30704, '1216714539', 'CESAR MORENO ', 'K LINK SAT OUT 7 3 2017 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 14:34:34', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30705, '1216714539', 'EPM ', 'INT_PRO_V.2.1_05 07 2018.brd ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 15:29:25', '2018-07-13', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30706, '1216714539', 'UNIVERSIDAD EAFIT ', 'MULTI RASPBERRY_V6.0_DobleCapa ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 15:45:07', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30708, '1216714539', 'CRISTIAN FELIPE PEREZ RESTREPO ', 'MEDIDOR DE ENERGIA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-06 17:33:00', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30709, '1216714539', 'MAURICIO VASCO  OPTEC ', ' 75DCB2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 07:16:16', '2018-07-24', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30710, '1216714539', 'WILLIAM JOSEPH GIRALDO OROZCO ', ' FARO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 09:32:35', '2018-07-18', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30711, '1152697088', 'ESTEBAN RAVE ', ' RECOBRADOR SIN FUENTE V2 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 11:02:15', '2018-07-12', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30712, '1152697088', 'UNIVERSIDAD DE IBAGUE ', 'TARJETA DE CONTROL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 11:06:49', '2018-07-17', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30713, '1152697088', 'UNIVERSIDAD DE IBAGUE ', 'TARJETA MEDIO PUENTE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 11:11:21', '2018-07-17', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30714, '1152697088', 'JOSE ARBEY SANCHEZ BETANCUR ', 'Gerber_SANDIAZ ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 11:17:27', '2018-07-19', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30715, '1152697088', 'USUGA ARAQUE ELMER ANTONIO ', 'MPPT ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 11:22:19', '2018-07-16', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30717, '1216714539', 'LUIS FERNANDO ALZATE CASTRILLON ', 'TCMH ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 14:48:57', '2018-07-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30718, '1216714539', 'ROSSEMBERG Y REINGENIERIA S.A.S ', 'R&RADS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-10 07:27:50', '2018-07-23', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30719, '1152697088', 'BIOMEDIK  GROUP S.A.S ', 'RF_POTENCIA_V12_04_2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:08:28', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30720, '1152697088', 'BIOMEDIK  GROUP S.A.S ', 'RF_FUENTE V11_04_2018 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:13:53', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30721, '1216714539', 'UNIVERSIDAD EAFIT ', 'ARDUINO LUCHO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:16:22', '2018-07-23', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30722, '1152697088', 'UNIVERSIDAD EAFIT ', 'FOTOCELDA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:18:21', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30723, '1152697088', 'UNIVERSIDAD EAFIT ', 'PROYECTO EDWIN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:22:19', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30724, '1216714539', 'UNIVERSIDAD EAFIT ', 'XBEE DAVID ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:24:47', '2018-07-19', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30725, '1152697088', 'UNIVERSIDAD EAFIT ', 'XBEE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-09 17:26:09', '2018-07-19', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30729, '1152697088', 'CESAR MORENO ', 'KEY12TC ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-10 17:09:42', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30730, '1152697088', 'CESAR MORENO ', ' SPKMASTERKL 1POOL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-10 17:14:17', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30731, '1152697088', 'INGNOVAC SAS ', ' IMPORTED COP01.2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-10 17:18:57', '2018-07-24', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30736, '1152697088', 'GUSTAVO ADOLFO TORO MEJIA ', 'CONTROL SEGURO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-11 11:36:29', '2018-07-30', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30737, '1152697088', 'UNIVERSIDAD EAFIT ', 'INSUFLADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-11 11:43:53', '2018-07-24', NULL, 1, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30738, '1152697088', 'UNIVERSIDAD EAFIT ', 'FREE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-11 11:49:32', '2018-07-23', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30742, '1216714539', 'RPM INGENIEROS S.A.S ', 'FICHO PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-11 15:47:59', '2018-08-02', NULL, 1, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30745, '1152697088', 'UNIVERSIDAD CATOLICA DE ORIENTE ', 'REMEDIACION ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-11 16:46:47', '2018-07-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30746, '1216714539', 'INVYTEC ', 'BALIZAL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 07:12:45', '2018-07-19', NULL, 0, 1, 1, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30747, '1152697088', 'JUAN FERNANDO OSORIO TRUJILLO ', 'MVF_8E_8S_01 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 11:08:05', '2018-07-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30748, '1216714539', 'EFFITECH S.A.S ', 'MAXTRANSISTORES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 13:24:36', '2018-07-24', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30750, '1216714539', 'JUAN CAMILO SALAZAR MEJIA ', 'IntSensor ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 16:40:25', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30752, '1152697088', 'LUIS FERNANDO PARRA ', 'PCBFingerPrint ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 17:28:22', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30753, '1152697088', 'LUIS FERNANDO PARRA ', 'Embroidery PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-12 17:37:24', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30757, '98765201', 'CESAR MORENO ', 'DOBLE T ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 10:14:21', '2018-08-06', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30759, '1152697088', 'ROVOFIC DESIGMH ', 'Shield_NANO3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 10:34:04', '2018-07-25', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30760, '1216714539', 'JORGE IGNACIO MACIAS ', 'TRANSFORMADOR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 12:30:45', '2018-07-30', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30761, '1216714539', 'UNIVERSIDAD NACIONAL DE COLOMBIA ', ' CLOROFILO C1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 12:44:14', '2018-07-24', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30762, '1216714539', 'RAFAEL VEGA ', 'PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 12:49:29', '2018-07-23', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30763, '1216714539', 'SUCONEL S.A ', 'BASE_PIC_KIT ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 15:10:25', '2018-07-26', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30765, '1216714539', 'COLTRACK S.A.S. ', 'USLEVELTRACK_SV4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 15:23:56', '2018-07-23', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30766, '1216714539', 'MICHAEL CANU ', '2018 UEB MC ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 15:34:52', '2018-07-23', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30767, '1216714539', 'AGROELECTRONICA INGENIERIA LTDA ', 'SOPORTE13JULIO ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-13 16:08:46', '2018-07-18', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30769, '1216714539', 'SONAR AVL SYSTEM S.A.S ', 'INS43_Contador_Ir_R2A ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-16 08:38:14', '2018-07-17', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30770, '1152697088', 'PONTIFICIA UNIVERSIDAD JAVERIANA ', 'CORNARE V2 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-16 10:44:04', '2018-07-24', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30771, '1152697088', 'FECHNER S.A.S ', 'RhemoPin ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-16 10:53:27', '2018-07-19', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30775, '1152697088', 'IVAN DARIO MORENO ', 'FTE 100A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-16 16:48:42', '2018-07-26', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30780, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', ' Gerber_simple_control ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-17 12:08:45', '2018-07-18', NULL, 0, 1, 2, 0, 0, 0, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30781, '1216714539', 'NICOLAS POTIER ANZOLA ', 'PIC 18F PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-17 13:40:54', '2018-07-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30782, '1216714539', 'TECREA S.A.S ', 'TEST_BQ ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-17 15:22:23', '2018-07-18', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30783, '1216714539', 'MAURICIO VASCO  OPTEC ', 'TA48A176TP V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-17 17:36:56', '2018-07-30', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30784, '1216714539', 'INCOMELEC S.A.S ', 'CAPTURADORA VERSI%C3%93N 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-17 17:41:34', '2018-07-30', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30785, '1216714539', 'NETUX S.A.S ', 'C&K_SWITCH ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-18 14:58:17', '2018-08-15', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30786, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'BASIC CONTROL V_5.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-18 13:59:56', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30788, '1216714539', 'ARQUITECTURA DE SOLUCIONES ', 'POTENCIAIOBASICO V9A ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-18 16:06:30', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30789, '1216714539', 'INDUSTRIAS METALICAS LOS PINOS ', 'TARJETA WIFI ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-18 17:02:53', '2018-07-25', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30791, '1216714539', 'UNIVERSIDAD EAFIT ', 'CIERRE ABDOMEN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-19 07:56:39', '2018-07-27', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30792, '1216714539', 'TAXIMETROS GEORGE ', 'TERMOCAR3DIG_VEL_COOLER ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-19 09:18:32', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30795, '1216714539', 'SIGMA ELECTRONICA ', 'UC20 RPI ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-19 15:30:21', '2018-07-27', NULL, 0, 1, 4, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30796, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'ORDE%C3%91O_MVF60 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-19 16:09:17', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30797, '1216714539', 'DIVERTRONICA MEDELLIN S.A ', 'LUCES FLASHER 555 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-19 16:24:37', '2018-07-31', NULL, 0, 1, 2, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 'A tiempo', NULL),
(30799, '1216714539', 'EQUIPETROL S.A. ', 'CABLE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 14:56:08', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30808, '1216714539', 'MAURICIO VASCO  OPTEC ', 'TD40D16C ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-23 15:31:46', '2018-08-02', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30810, '1216714539', 'CARLOS ANDRES RESTREPO RESTREPO ', 'CONTROL CELULAR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 07:27:42', '2018-07-30', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30811, '1216714539', 'MEDVISION SAS ', ' CapturinArduino ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 07:36:53', '2018-08-02', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30812, '1216714539', 'ANDERSON ALZATE IDARRAGA ', 'SIVAR ECL V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 07:47:10', '2018-07-31', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30814, '1216714539', 'MARCO AGUDELO ', 'CIRCUITO IMPRESO CONTROL SILLA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 10:38:23', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30816, '1216714539', 'SONAR AVL SYSTEM S.A.S ', ' INS40_v5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 11:06:15', '2018-07-31', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30818, '1216714539', 'DIGITELC S.A.S ', ' CARRO V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 15:44:56', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30819, '1216714539', 'DIGITALTEC S.A.S ', 'TARJETA MULTIUSOS 03 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 17:02:14', '2018-07-30', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30820, '1216714539', 'MAURICIO VASCO  OPTEC ', 'ESSI25DC V4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-24 17:27:44', '2018-08-06', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30822, '1216714539', 'ESTEBAN RUIZ MU%C3%91ETON ', 'PCBV3.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-25 14:44:40', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30824, '1216714539', 'HERNANDO GAMA DUARTE ', 'TOMAS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-25 15:06:08', '2018-07-31', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30825, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', 'OPMVFOR02_2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-25 15:25:34', '2018-08-06', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30832, '1216714539', 'CONTROLES INTELIGENTES SAS ', 'SENSOR PROTESIS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-25 17:17:56', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30833, '1216714539', 'GAS Y GAS S.A.S', 'GYG12 B ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 09:40:56', '2018-08-09', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30834, '1216714539', 'GAS Y GAS S.A.S', 'GYG12 B TECLADO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 09:51:11', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30835, '1216714539', 'SIGMA ELECTRONICA ', 'L96 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 10:23:00', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30842, '1216714539', 'CORPORACION PARA LA INVESTIGACION DE LA CORROSION (CIC) ', ' MUX_I ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 14:44:39', '2018-08-06', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30845, '1216714539', 'JOSE FERNANDO GARCIA HENAO ', '23TB1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 17:31:28', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30846, '1216714539', 'LUIS FERNANDO ALZATE CASTRILLON ', 'TMPCJ_V1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 17:39:10', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30847, '1216714539', 'HERNANDO GAMA DUARTE ', 'SW OPTICO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 17:36:13', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30848, '1216714539', 'HERNANDO GAMA DUARTE ', 'PESEBRE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-26 17:41:19', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30849, '1216714539', 'HERNANDO GAMA DUARTE ', 'SW RELAY ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 09:09:55', '2018-08-02', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30850, '1216714539', 'UNIVERSIDAD DE IBAGUE ', 'CIRCUITO FINAL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 09:19:58', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30851, '1216714539', 'RODRIGO RESTREPO RIVERA ', 'UPS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 09:53:41', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30853, '1216714539', 'VESTIMUNDO S.A ', 'PRINTEX   PRINCIPAL XBEE ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 14:50:31', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30854, '1216714539', 'VESTIMUNDO S.A ', 'PRINTEX  ENTRADAS DIGITALES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 14:55:05', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30857, '1216714539', 'DEL AGRO SOLUCIONES PARA EL CAMPO SAS ', 'SEGURIDAD P2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 15:36:14', '2018-08-03', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30859, '1216714539', 'CELSA S.A.S ', 'PCBA001_7_1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-27 17:12:03', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30862, '1216714539', 'NETUX S.A.S ', 'C&K_SWITCH ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 09:36:27', '2018-08-02', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(30863, '1216714539', 'JUAN PABLO SARMIENTO DIAZ GRANADOS ', 'MINI 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 10:04:30', '2018-08-09', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30864, '1216714539', 'SIOMA SAS ', 'LCD V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 11:19:43', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30865, '1216714539', 'SIOMA SAS ', 'RSP V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 11:24:32', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30866, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'PCB_QUEMADOR_ATTINY4313 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 12:28:27', '2018-07-31', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30867, '1216714539', 'SOFTWARE E INSTRUMENTACION S.A.S ', 'PCB_SIMPLE_ATTINY ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 12:31:47', '2018-07-31', NULL, 1, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30868, '1216714539', 'MAURICIO VASCO  OPTEC ', '75TPDUL V3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 14:39:13', '2018-08-13', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30869, '1216714539', 'JUAN DAVID MEZA GONZALEZ ', ' TESIS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 14:34:02', '2018-08-06', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30870, '1216714539', 'TECREA S.A.S ', 'ACOPLE RJ45 ALCOHONTROL ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 14:45:30', '2018-07-31', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30871, '1216714539', 'I 3NET S A S ', 'Gerber_PCB solo Btm_20180728141225 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 15:31:21', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(30872, '1216714539', 'I 3NET S A S ', 'Gerber_PCB solo Btm_20180728141225 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-30 15:36:28', '2018-08-01', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30874, '1216714539', 'MICHAEL CANU ', 'DCmotor driver ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 07:53:07', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30875, '1216714539', 'JHON GERMAN GARCIA G ', 'AVP_20180731 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 11:33:47', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `proyecto` (`numero_orden`, `usuario_numero_documento`, `nombre_cliente`, `nombre_proyecto`, `tipo_proyecto`, `FE`, `TE`, `IN`, `pcb_FE`, `pcb_TE`, `Conversor`, `Repujado`, `troquel`, `stencil`, `lexan`, `fecha_ingreso`, `fecha_entrega`, `fecha_salidal`, `ruteoC`, `antisolderC`, `estado_idestado`, `antisolderP`, `ruteoP`, `eliminacion`, `parada`, `entregaCircuitoFEoGF`, `entregaCOMCircuito`, `entregaPCBFEoGF`, `entregaPCBCom`, `novedades`, `estadoEmpresa`, `NFEE`) VALUES
(30876, '1216714539', 'LUIS FELIPE ECHEVERRI ', 'RotaryLeds2018_2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 11:58:24', '2018-08-10', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30877, '1216714539', 'CARLOS HUMBERTO CUELLAR MARTINEZ ', 'SECUENCIAL V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 13:37:13', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30878, '1216714539', 'UNIVERSIDAD DEL VALLE ', 'bncpinheader   CADCAM   Base ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 14:27:43', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30879, '1216714539', 'UNIVERSIDAD DEL VALLE ', 'bncpinheader   CADCAM   ext ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 14:33:08', '2018-08-08', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30881, '1216714539', 'B SMART ', 'LECTURA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-07-31 17:22:15', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30883, '1152697088', 'GRUPO INREVI SAS ', ' NEW GAS 1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-01 14:31:15', '2018-08-15', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30884, '1152697088', 'SOLITEC GLOBAL S.A.S ', 'CONMUTADOR DC   VER 2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-01 15:11:44', '2018-08-09', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30885, '1152697088', 'TAX CHUPA ', 'DISPLAY 5 DIGITOS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-01 16:39:06', '2018-08-24', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30886, '1152697088', 'TAX CHUPA ', 'TAXIMETRO_CHUPA ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-01 16:42:00', '2018-08-16', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30887, '1152697088', 'CINDETEMM ', ' PRE AMPLIFICADOR V2 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-01 16:58:35', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30888, '1216714539', 'UNIVERSIDAD EAFIT ', 'DISCO LED ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-02 09:08:13', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30890, '1216714539', 'MAURICIO VASCO  OPTEC ', 'TD24A05_v4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-02 11:21:37', '2018-08-27', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30891, '1216714539', 'JUAN FERNANDO OSORIO TRUJILLO ', ' MVF_RF_1S_3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-02 11:24:20', '2018-08-16', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, '', NULL, NULL),
(30892, '1216714539', 'ALEJANDRO CALDERON URIBE ', ' EsquematicoV1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-02 11:47:15', '2018-08-10', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30896, '1216714539', 'EFFITECH S.A.S ', 'INTERFACE PIC V2.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-03 09:47:56', '2018-08-23', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30897, '1216714539', 'INCOSYS SAS ', 'RETRO HORIZONTAL OIT V1.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-03 11:02:40', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30901, '1216714539', 'COLOR Y DISE%C3%91O ', 'CONTROL FLORES ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-03 16:05:12', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30902, '1216714539', 'PMP INGENIERIA ', 'BOMBAIOT V1.23 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-03 16:15:54', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30905, '1216714539', 'GROUND ELECTRONICS ', '75 XBEE USB V1.0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-06 08:31:31', '2018-08-16', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30906, '1216714539', 'NETUX S.A.S ', 'SHT 21 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-06 11:30:45', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30907, '1216714539', 'NETUX S.A.S ', 'TMP 382 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-06 11:34:47', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30908, '1216714539', 'NETUX S.A.S ', 'HHC_Rev_1_0_Texas ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-06 11:37:59', '2018-08-15', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30909, '1216714539', 'ONLYSOFT LTDA ', 'REF005 V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-06 15:11:37', '2018-08-21', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30911, '1216714539', 'HERNANDO GAMA DUARTE ', 'PNP NPN ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 08:56:09', '2018-08-14', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30914, '1216714539', 'OSCAR CAMILO ROJAS PINEDA ', 'PCBLV1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 15:05:07', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30916, '1216714539', 'ANGEL MIRO DIAZ CAMARGO ', 'BTS_20130922 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 15:30:43', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30931, '1216714539', 'NETUX S.A.S ', 'HHC_Rev_1_0_Nordic_chip ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 16:31:04', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30932, '1216714539', 'NETUX S.A.S ', 'HHC_Rev_1_0_Nordic_chip ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 16:52:03', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30933, '1216714539', 'NETUX S.A.S ', 'HHC_Rev_1_0_Nordic_PCB ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 16:56:15', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30936, '1216714539', 'FABIO ENRIQUEZ URIBE ', ' V5B GATEWAY PCB_IoT ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-08 17:24:20', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30937, '1216714539', 'MAURICIO VASCO  OPTEC ', 'TD48A176TP V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-09 10:37:45', '2018-08-23', NULL, 0, 0, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30939, '1216714539', 'TICLINE SAS ', 'TICAIR ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-09 10:43:39', '2018-08-16', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30940, '1152697088', 'MANTING S.A.S ', 'Shield Arduino Contact ID V1.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:32:25', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30941, '1152697088', 'ULTRA SA ', 'SOLUCION DMAX BRINKS ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:35:38', '2018-08-24', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30942, '1152697088', 'GECKORP S.A.S ', ' GSM_UNO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:41:07', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30943, '1152697088', 'CINDETEMM ', ' AMPLIFICADOR_MICROFONO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:43:40', '2018-08-23', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30944, '1152697088', 'ALEXANDER ESPINOSA GARCIA ', '3DCUBE001 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:46:41', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30945, '1152697088', 'GRUPO ACUAMATIC S.A.S ', 'ACUABOARD 3.3 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 09:49:19', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30946, '1152697088', 'JULIO EDUARDO SANCHEZ MAHECHA ', ' FINALISIMO 1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 10:09:35', '2018-08-16', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30947, '1152697088', 'TKZ ELECTRONICS ', 'TKZ FT 001 ', 'Quick', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 11:28:06', '2018-08-13', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30948, '1152697088', 'AGRUM TECNOLOGIA S.A.S. ', 'BigBrotherHW ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 11:35:27', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30949, '1152697088', 'BIOINNOVA S.A.S ', 'ALATMA 2_8 V2.1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 14:01:50', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30950, '1152697088', 'DIGITELC S.A.S ', ' CARRO V5 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 14:05:21', '2018-08-27', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30951, '1152697088', 'INELPRO S.A.S ', 'TARJETA P+I ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 15:55:11', '2018-08-22', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30952, '1152697088', 'VIVE MAS INVERSIONES S.A.S ', 'CARGADOR CONMUTADO V1 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-10 15:58:36', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30953, '1152697088', 'B SMART ', ' DIT4 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-13 08:07:30', '2018-08-29', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30961, '1152697088', 'DEMO INGENIERIA LTDA ', 'GERBERFANCTRLPANEL ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-13 15:25:15', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30963, '1152697088', 'OSWALDO PUERTA TOVAR ', 'DISPLAY_TWINGO ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-13 15:31:57', '2018-08-24', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30964, '1152697088', 'PROMOTORA MEDICA LAS AMERICAS ', 'TARJETA HILL_ROM_V1,0 ', 'Normal', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-13 17:05:18', '2018-08-23', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(30965, '1216714539', 'ANDERSON ALZATE IDARRAGA ', 'sivarECL_v1.1 ', 'RQT', 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, '2018-08-14 09:52:45', '2018-08-17', NULL, 0, 1, 1, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
('1017156424', 'CC', 'YAZMIN ANDREA', 'GALEANO CASTAÑEDA', 3, '', 1, 'yazmin1987', 0, 'dñpgxp68@4'),
('1017191779', 'CC', 'Sintia Liceth', 'Ossa Vasquez', 6, '', 0, '1017191779', 0, '51e-uiññl9'),
('1040044905', 'CC', 'Jose Daniel ', 'Grajales Carmona', 1, '', 1, '1040044905', 0, 'z9jmqbñ2kl'),
('1078579715', 'CC', 'MAIBER DAVID ', 'GONZALEZ MERCADO ', 1, '', 1, '3108967039', 0, 'w7n8pjyhd8'),
('1128266934', 'CC', 'Jhon Fredy', 'Velez Londoño', 4, '', 1, '1128266934', 1, '4elax2f2ub'),
('1152210828', 'CC', 'PAULA ANDREA ', 'HERRERA ÁLVAREZ', 5, '', 1, '1152210828', 0, 'eimaumks9s'),
('1152697088', 'CC', 'Diana Marcela', 'Patiño Cardona', 6, '', 1, '1152697088', 0, '1@zujadnñk'),
('1216714539', 'CC', 'Maria alejandra ', 'zuluaga rivera', 6, '', 1, '1216714539', 1, '84@w8wli4a'),
('123456789', 'CC', 'prueba', 'prueba', 2, '', 1, '123456789', 1, 'jfmhh0vq5b'),
('42800589', 'CC', 'Juliana', 'Naranjo Henao', 6, '', 1, '42800589', 0, '-cnño-5wb4'),
('43263856', 'CC', 'Paula Andrea', 'Lopez Gutierrrez', 1, '', 1, '43263856', 0, 'cxcx03ñkf4'),
('43975208', 'CC', 'GLORIA ', 'JARAMILLO ', 2, '', 1, '43975208', 1, 'kbdnsdlciq'),
('71268332', 'CC', 'Adimaro', 'Montoya', 3, '', 1, '71268332', 0, '1vr8s4th-@'),
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
  `usuarioPuerto` varchar(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuariopuerto`
--

INSERT INTO `usuariopuerto` (`documentousario`, `usuarioPuerto`) VALUES
('43975208', 'COM3'),
('1017156424', 'COM1'),
('981130', 'COM5'),
('71268332', 'COM1'),
('1128266934', 'COM4'),
('98765201', 'COM3'),
('1216714539', 'COM7'),
('1152697088', 'COM7'),
('98113053240', 'COM6'),
('123456789', 'COM7');

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
  MODIFY `idalmacen` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `idcargo` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `detalle_ensamble`
--
ALTER TABLE `detalle_ensamble`
  MODIFY `idDetalle_ensamble` smallint(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detalle_formato_estandar`
--
ALTER TABLE `detalle_formato_estandar`
  MODIFY `idDetalle_formato_estandar` smallint(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2403;

--
-- AUTO_INCREMENT de la tabla `detalle_proyecto`
--
ALTER TABLE `detalle_proyecto`
  MODIFY `idDetalle_proyecto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=276;

--
-- AUTO_INCREMENT de la tabla `detalle_teclados`
--
ALTER TABLE `detalle_teclados`
  MODIFY `idDetalle_teclados` smallint(6) NOT NULL AUTO_INCREMENT;

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
  MODIFY `numero_orden` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30966;

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
  ADD CONSTRAINT `fk_detalle_ensamble_estado1` FOREIGN KEY (`estado_idestado`) REFERENCES `estado` (`idestado`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_detalle_teclados_detalle_proyecto10` FOREIGN KEY (`detalle_proyecto_idDetalle_proyecto`) REFERENCES `detalle_proyecto` (`idDetalle_proyecto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

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
