/*
SQLyog Ultimate v13.1.2 (64 bit)
MySQL - 5.6.39 : Database - rhinomec
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Data for the table `inv_bodega` */

insert  into `inv_bodega`(`id`,`id_encargadoBodega`,`id_padre`,`id_bodegaPrincipal`,`gl_nombre`,`gl_descripcion`,`gl_ubicacion`,`nr_prioridadVenta`) values 
(1,5,NULL,1,'Segunda Norte 818','','',NULL),
(2,120,1,1,'A - Galpon','','',NULL),
(3,120,1,1,'B - Contenedor','','',NULL),
(4,120,1,1,'C - Contenedor','','',NULL),
(5,120,3,1,'BA - Zona Trasera','','',NULL),
(6,120,3,1,'BB - Zona Delantera','','',NULL),
(7,68,1,1,'D - Casa Cuidador','','',NULL),
(8,5,1,1,'E - Oficina','','',NULL),
(9,5,1,1,'F - Sala Electrica','','',NULL),
(10,5,NULL,10,'Av. Tupungato 3850','','',NULL),
(11,5,10,10,'A - Bodega','','',NULL),
(12,3,10,10,'B - Oficina Dynwork','','',NULL),
(13,5,10,10,'C - Oficina Rhinomec','','',NULL),
(14,5,11,10,'AA - Delantera','','',NULL),
(15,5,11,10,'AB - Trasera','','',NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
