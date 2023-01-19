-- -----------------------------------------------
-- Entitäten erstellen
-- -----------------------------------------------
DROP TABLE IF EXISTS Kunden;
CREATE TABLE Kunden(
    KName VARCHAR(10) NOT NULL ,
    KVorname VARCHAR(10) NOT NULL ,
    KNr VARCHAR(10) NOT NULL ,
CONSTRAINT PK_Kunden PRIMARY KEY (KNr)
);

DROP TABLE IF EXISTS Bestellungen;
CREATE TABLE Bestellungen(
    KNr VARCHAR(10) NOT NULL ,
    BNr VARCHAR(10) NOT NULL ,
    Datum DATE NOT NULL,
    Uhrzeit TIME NOT NULL
CONSTRAINT PK_Bestellungen PRIMARY KEY (KNr,BNr)
);

DROP TABLE IF EXISTS Pizzerien;
CREATE TABLE Pizzerien(

);