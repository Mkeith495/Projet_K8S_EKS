DROP TABLE IF EXISTS ressources;
DROP TABLE IF EXISTS utilisateurs;
DROP TABLE IF EXISTS produits;

CREATE TABLE produits (
  pro_id SERIAL PRIMARY KEY,
  pro_lib VARCHAR(200) NOT NULL,
  pro_prix NUMERIC(10,2) NOT NULL,
  pro_description TEXT
);

CREATE TABLE ressources (
  re_id SERIAL PRIMARY KEY,
  re_type VARCHAR(100) NOT NULL,
  re_url VARCHAR(1000) NOT NULL,
  re_nom VARCHAR(100) NULL,
  pro_id INT NOT NULL REFERENCES produits(pro_id)
);

CREATE TABLE utilisateurs (
  us_id SERIAL PRIMARY KEY,
  us_login VARCHAR(100) NOT NULL UNIQUE,
  us_password VARCHAR(100) NOT NULL
);

INSERT INTO produits (pro_id, pro_lib, pro_prix, pro_description) VALUES
(1,'Pédales Shimano XT M8040 M/L',74.99,'Les pédales plates SHIMANO XT PD-M8040 sont destinées à un usage All Mountain/Enduro.'),
(2,'Selle FIZIK ARIONE VERSUS Rails Kium',59.99,'Modèle confortable avant tout, la selle FIZIK Arione Versus possède un profil tout à fait plat et très long (300 mm).'),
(3,'Chaussures VTT MAVIC CROSSMAX SL PRO THERMO Noir',164.99,'Les chaussures Cross Max SL Pro Thermo créées par la marque MAVIC plairont aux riders voulant profiter de leur vélo en hiver !');

INSERT INTO utilisateurs (us_id, us_login, us_password) VALUES
(1,'admin','5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8');

SELECT setval(pg_get_serial_sequence('produits','pro_id'), (SELECT MAX(pro_id) FROM produits));
SELECT setval(pg_get_serial_sequence('utilisateurs','us_id'), (SELECT MAX(us_id) FROM utilisateurs));
