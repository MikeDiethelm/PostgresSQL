-- Aufgabe 1
DROP TABLE IF EXISTS Mitarbeiter;
CREATE TABLE Mitarbeiter(
Vorname VARCHAR(200) NOT NULL,
Name VARCHAR(200) NOT NULL,
CONSTRAINT PK_Mitarbeiter PRIMARY KEY (Vorname,Name)
);

DROP TABLE IF EXISTS Firma;
CREATE TABLE Firma(
Name VARCHAR(200) NOT NULL,
CONSTRAINT PK_Firma PRIMARY KEY (Name)
);

-- Wie genau wird hier die Kardinalität mit Schlüsseln sichergestellt?
DROP TABLE IF EXISTS Anstellung;
CREATE TABLE Anstellung(
  MVorname varchar(100) NOT NULL,
  MName    varchar(100) NOT NULL,
  FName    varchar(100) NOT NULL,
CONSTRAINT PK_Anstellung PRIMARY KEY (MVorname,MName),
CONSTRAINT FK_Mitarbeiter FOREIGN KEY (MVorname,MName) REFERENCES Mitarbeiter(Vorname,Name),
CONSTRAINT FK_Firma FOREIGN KEY (FName) REFERENCES Firma(Name)
);

select * from Anstellung;

-- Aufgabe 2
ALTER TABLE Firma ADD Gründungsjahr integer NOT NULL;
ALTER TABLE Anstellung ADD Jahreslohn Decimal(8,2) NOT NULL;

-- Aufgabe 3
select * from mitarbeiter;
ALTER TABLE mitarbeiter ADD PLZ integer NOT NULL;
ALTER TABLE Mitarbeiter ADD Ort varchar(100) NOT NULL;
ALTER TABLE Mitarbeiter ADD Strasse varchar(100) NOT NULL;
ALTER TABLE Mitarbeiter ADD Hausnummer varchar(8) NULL;

-- Aufgabe 4















































