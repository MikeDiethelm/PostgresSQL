-- ==================================================================
-- S_Praktikum_13: Integritätssicherung / Datenbankprogrammierung
-- ==================================================================

CREATE SCHEMA IF NOT EXISTS DB_Praktikum_13;

SET search_path TO DB_Praktikum_13;

-- ------------------------------------------------------------------
-- Aufgabe 2: Referenzdaten bereitstellen
--
-- Pfade zuerst anpassen (Dateien müssen auf einem lokalen Laufwerk 
-- liegen)
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS PLZSchweiz;

CREATE TABLE PLZSchweiz(
  PLZ    INTEGER      NOT NULL,
  Ort    VARCHAR(100) NOT NULL,
  Kanton VARCHAR(2)   NOT NULL,
  Land   VARCHAR(100) NOT NULL,

  PRIMARY KEY (PLZ,Ort)
);

COPY PLZSchweiz (PLZ,Ort,Kanton,Land)
FROM 'C:/csv/Postleitzahlen.csv' 
DELIMITER ';' 
CSV HEADER 
ENCODING 'UTF8';

SELECT * FROM PLZSchweiz;

DROP TABLE IF EXISTS ISOLaenderCodes;

CREATE TABLE ISOLaenderCodes(
  ISOCode CHAR(2)      NOT NULL PRIMARY KEY,
  Land    VARCHAR(100) NOT NULL
);

COPY ISOLaenderCodes (Land,ISOCode)
FROM 'C:/csv/ISOLaenderCodes.csv' 
DELIMITER ',' 
CSV HEADER 
ENCODING 'UTF8';

SELECT * FROM ISOLaenderCodes;
