SET NAMES utf8mb4;
SET time_zone = '+00:00';

DROP TABLE IF EXISTS `ressources`;
DROP TABLE IF EXISTS `utilisateurs`;
DROP TABLE IF EXISTS `produits`;

CREATE TABLE `produits` (
  `PRO_id` int NOT NULL AUTO_INCREMENT,
  `PRO_lib` varchar(200) NOT NULL,
  `PRO_prix` decimal(10,2) NOT NULL,
  `PRO_description` text,
  PRIMARY KEY (`PRO_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `ressources` (
  `RE_id` int NOT NULL AUTO_INCREMENT,
  `RE_type` varchar(100) NOT NULL,
  `RE_url` varchar(1000) NOT NULL,
  `RE_nom` varchar(100) DEFAULT NULL,
  `PRO_id` int NOT NULL,
  PRIMARY KEY (`RE_id`),
  KEY `ressources_produits_FK` (`PRO_id`),
  CONSTRAINT `ressources_produits_FK` FOREIGN KEY (`PRO_id`) REFERENCES `produits` (`PRO_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

CREATE TABLE `utilisateurs` (
  `US_id` int NOT NULL AUTO_INCREMENT,
  `US_login` varchar(100) NOT NULL,
  `US_password` varchar(100) NOT NULL,
  PRIMARY KEY (`US_id`),
  UNIQUE KEY `US_login` (`US_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `produits` (`PRO_id`,`PRO_lib`,`PRO_prix`,`PRO_description`) VALUES
(1,'Pédales Shimano XT M8040 M/L',74.99,'Les pédales plates SHIMANO XT PD-M8040 sont destinées à un usage All Mountain/Enduro. Très solides grâce à leur axe en acier chromoly, elles se caractérisent notamment par leur plateforme concave, qui accueille 10 picots dévissables, qui favorisent le grip sous la semelle. Leur structure est également plus ouverte et dégagée, qui empêche la boue de s\'accumuler.'),
(2,'Selle FIZIK ARIONE VERSUS Rails Kium',59.99,'Modèle confortable avant tout, la selle FIZIK Arione Versus possède un profil tout à fait plat et très long (300 mm) qui convient aux pratiquants justifiant d\'une excellente souplesse vertébrale.'),
(3,'Chaussures VTT MAVIC CROSSMAX SL PRO THERMO Noir',164.99,'Les chaussures Cross Max SL Pro Thermo créées par la marque MAVIC plairont aux riders voulant profiter de leur vélo en hiver !');

INSERT INTO `utilisateurs` (`US_id`,`US_login`,`US_password`) VALUES
(1,'admin','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');
