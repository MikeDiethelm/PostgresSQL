-- Aufgabe 1
-- Schreiben Sie SQL-Anweisungen für sämtliche benötigte CREATE TABLE-Anweisungen für Mitarbeiter, welche höchstens 
-- bei einer Firma arbeiten (analog dem Beispiel aus der Vorlesung 4). Firmen stellen naturgemäss mehrere Mitarbeiter an. 
-- Mitarbeiter haben Vor- und Nachnamen, Firmen jeweils einen Namen. Definieren Sie hierzu auch 
-- Primärschlüssel: Kombination Name und Vorname auf Mitarbeiter, Name auf Firma. Stellen Sie die Kardinalitäten mit 
-- Schlüsseln sicher. 
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
-- Laut Beschreibung soll ein Mitarbeiter höchstens bei einer Firma tätig sein, mit dieser Implementation kann jedoch 
-- ein Mitarbeiter bei beliebig vielen Firmen angestellt sein, also eine m zu m Beziehung und nicht wie verlangt eine
-- m zu 1 oder 1 zu m Beziehung.
DROP TABLE IF EXISTS Anstellung;
CREATE TABLE Anstellung(
  MVorname varchar(100) NOT NULL,
  MName    varchar(100) NOT NULL,
  FName    varchar(100) NOT NULL,
CONSTRAINT PK_Anstellung PRIMARY KEY (MVorname,MName),
CONSTRAINT FK_Mitarbeiter FOREIGN KEY (MVorname,MName) REFERENCES Mitarbeiter(Vorname,Name),
CONSTRAINT FK_Firma FOREIGN KEY (FName) REFERENCES Firma(Name)
);


-- Aufgabe 2
-- Fügen Sie der Tabelle Firma ein Attribut hinzu, um das Gründungsjahr mit einem geeigneten Datentyp zu erfassen. 
-- Es soll zusätzlich erfasst werden, welchen Jahreslohn ein Mitarbeiter bei einer Firma erhält. 
-- Beide neuen Attribute sollen bei der Dateneingabe immer Werte erhalten.
--  1) Auf welchem Element wird der Jahreslohn am sinnvollsten erfasst und warum?
--  2) Schreiben Sie wiederum die notwendigen SQL-Anweisungen (ALTER TABLE) und führen Sie
--     diese aus.
ALTER TABLE Firma ADD Gründungsjahr integer NOT NULL;
ALTER TABLE Anstellung ADD Jahreslohn Decimal(8,2) NOT NULL;

-- Aufgabe 3
-- Die Adressen von Mitarbeitern sollen nun auch erfasst werden. Schreiben Sie SQL-Anweisungen für das Hinzufügen von 
-- Attributen für PLZ, Ort, Strasse und Hausnummer hinzu. Überlegen Sie, für welche Attribute es sinnvoll ist, 
-- nicht immer einen Wert bei der Eingabe zu erzwingen. Überlegen Sie die Kon- sequenzen Ihrer Wahl der Datentypen. 
ALTER TABLE mitarbeiter ADD PLZ integer NOT NULL;
ALTER TABLE Mitarbeiter ADD Ort varchar(100) NOT NULL;
ALTER TABLE Mitarbeiter ADD Strasse varchar(100) NOT NULL;
ALTER TABLE Mitarbeiter ADD Hausnummer varchar(8) NULL;

-- Aufgabe 4
-- Fügen Sie nun Tupel in Ihre Tabellen ein (INSERT). Schauen Sie ggf. auf den Folien von Vorlesung 7 nach. 
-- Erstellen Sie SQL-Anweisungen für:
--  • 3 Firmen
--  • 5 Mitarbeiter, verteilt auf verschiedene Firmen
INSERT INTO Firma(Name,Gründungsjahr) VALUES 
('Galaxus',1988), 
('Denner',1989),
('Migrolino',1990);
INSERT INTO Mitarbeiter(Vorname,Name,Strasse,Hausnummer,Ort,PLZ) VALUES
('Mike','Diethelm','Bruggacherstrasse','24','Faellanden',8117),
('Jan','Imhof','Dojostrasse','12','Uster',8610),
('Erich','Goetschi','Poststrasse','1','Wegenstetten',4317),
('Yves','Wirz','Luzstrasse',NULL,'Kriens',6010),
('Adrian','Moser','St.gallerstr','56','St.gallen',9000);

INSERT INTO Anstellung (MVorname, MName, FName, Jahreslohn) VALUES
('Mike','Diethelm','Galaxus',120000),
('Jan','Imhof','Galaxus',120000),
('Erich','Goetschi','Denner',100000),
('Yves','Wirz','Denner',100000),
('Adrian','Moser','Migrolino',115000);

-- Aufgabe 5
-- Die Telefonnummern von Mitarbeitern sollen zusätzlich erfasst werden. Es wird verlangt, dass zwin- gend eine Nummer
-- vorhanden sein muss (NOT NULL).
--  1) Fügen Sie der Mitarbeitertabelle eine entsprechende Spalte hinzu. Schreiben Sie dazu eine entsprechende
--     SQL-Anweisung und führen Sie diese aus.
--  2) Was geschieht, wenn Sie bei der neuen Spalte „DEFAULT ...“ nicht ebenfalls spezifizieren? Wa- rum?
ALTER TABLE Mitarbeiter ADD Telefonnummer varchar(12) NOT NULL DEFAULT 'n/a'; -- Was macht DEFAULT 'n/a' ?
-- Da bereits Datensätze für Mitarbeiter vorhanden sind, werden auch diese um eine neue Spalte erweitert.
-- Wenn nun „NOT NULL“ definiert ist, aber kein „DEFAULT“, wird automa- tisch NULL als Wert in den neuen Spalten
-- der bestehenden Datensätze eingefügt. Dies ver- letzt in diesem Moment jedoch sofort die eben definierte Einschränkung.


-- Aufgabe 6
-- Ändern Sie nun die Adresse eines Mitarbeiters (UPDATE). Verwenden Sie dazu eine neue Adresse ohne Hausnummer.
UPDATE
  Mitarbeiter
SET
  PLZ      = '8401',
  Ort      = 'Winterthur',
  Strasse  = 'Im Lee',
  Hausnummer   = NULL
WHERE
  Name = 'Diethelm' AND Vorname = 'Mike';
select * from mitarbeiter;

-- Aufgabe 7
-- Ändern Sie den Namen einer Ihrer erfassten Firmen (UPDATE).
--	1) Erstellen Sie ein passendes SQL Statement und führen Sie es aus. Was passiert und warum?
--	2) Was ist notwendig, um dieses Update durchführen zu können? Nehmen Sie die Änderungen
--	   vor und führen Sie das UPDATE-Statement aus.
UPDATE Firma 
SET
	


-- Aufgabe 8
-- Stellen Sie sicher, dass Sie alle bisherigen SQL-Anweisungen noch in einer Datei zur Verfügung haben, um das Schema 
-- wiederherzustellen. Alternativ können Sie versuchen, von Ihrem DBMS ein Script für das Schema zu exportieren 
-- (ob und wie das funktioniert ist abhängig vom DBMS).
-- Schreiben Sie ein SQL Statement zum Löschen der Mitarbeitertabelle (DROP TABLE) und führen Sie es aus. 
-- Warum geht dies nicht ohne weiteres? Ergänzen Sie das Statement um den notwendigen Zusatz, damit die Tabelle gelöscht 
-- werden kann.












