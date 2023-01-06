-- ==================================================================
-- S_Praktikum_14: Indexe / Transaktionen
-- ==================================================================

SET SEARCH_PATH TO postgres_air;

---------------------------------------------------------------------
-- Aufgabe 1: Auswirkung von Indexen und Primärschlüsseln
---------------------------------------------------------------------

DROP TABLE IF EXISTS perftable;

CREATE TABLE perftable ( -- Extra keine Schlüssel!
  one INTEGER NOT NULL, 
  two INTEGER NOT NULL
);

-- Speicherungsform: HEAP

INSERT INTO perftable -- Tabelle mit Zufallszahlen füllen, anassen und wiederholen bis untenstehende Query ca. 10. Sec läuft
SELECT 
  rnum + FLOOR(RANDOM()*10)::INT AS one,
  FLOOR(RANDOM()*200000000)::INT AS two
FROM 
  (SELECT (num*10) AS rnum 
   FROM GENERATE_SERIES (1,20000000) AS s(num)
   ORDER BY RANDOM()
  ) AS x;
  
SELECT * FROM perftable; -- Zeit messen, ca. 6 Sec, "Tablescan"

-- Queries, Zeit messen
SELECT * FROM perftable WHERE one = 8054;

SELECT * FROM perftable WHERE one BETWEEN 8000 AND 9000;

-- Index erzeugen
CREATE INDEX perfindex ON perftable(one);

-- Index löschen
DROP INDEX perfindex;

-- Primärschlüssel erzeugen
ALTER TABLE perftable ADD PRIMARY KEY(one);

---------------------------------------------------------------------
-- Aufgabe 2: Auswirkung von Indexen auf das Lesen
---------------------------------------------------------------------

EXPLAIN
SELECT * FROM passenger WHERE first_name = 'DANI' AND last_name = 'WHEELER'; 

CREATE INDEX IX_Passenger ON passenger(first_name,last_name); 

DROP INDEX IX_Passenger;

---------------------------------------------------------------------
-- Aufgabe 3: Auswirkung von Indexen auf das Schreiben
---------------------------------------------------------------------

-- Tabelle kopieren (ohne Schlüssel)
CREATE TABLE passenger2 AS SELECT * FROM passenger; -- 40 Sek., HEAP

-- 200000 Tupel einfügen
INSERT INTO passenger2 SELECT * FROM passenger LIMIT 200000; -- 569 msec

-- Index erstellen
CREATE INDEX IX_Passenger2_1 ON passenger2(booking_id);

-- Nochmals 200000 Tupel einfügen
INSERT INTO passenger2 SELECT * FROM passenger LIMIT 200000; -- 1 Sec 167 MSec

-- Zweiten Index erstellen
CREATE INDEX IX_Passenger2_2 ON passenger2(first_name);

-- Nochmals 100000 Tupel einfügen
INSERT INTO passenger2 SELECT * FROM passenger LIMIT 200000; -- 3 sec 409 msec

DROP TABLE passenger2;

---------------------------------------------------------------------
-- Aufgabe 4: «My first Transaction»
---------------------------------------------------------------------

SELECT * FROM aircraft WHERE model LIKE 'Boeing%';

BEGIN TRANSACTION;
SELECT * FROM aircraft WHERE model LIKE 'Boeing%';
COMMIT;

---------------------------------------------------------------------
-- Aufgabe 5: Einmal «hin und zurück»
---------------------------------------------------------------------

-- damit es keine Probleme gibt mit Fremdschlüsseln...

ALTER TABLE flight DROP CONSTRAINT aircraft_code_fk;

SELECT * FROM aircraft;

BEGIN TRANSACTION;
DELETE FROM aircraft WHERE model LIKE 'Boeing%';
SELECT * FROM aircraft;
ROLLBACK;

SELECT * FROM aircraft;

---------------------------------------------------------------------
-- Aufgabe 6: Verschiedene Stufen der Isolation
---------------------------------------------------------------------

SELECT * FROM airport WHERE airport_code = 'ZRH';

-- Fenster 1: Schrittweise ausführen (zuerst erste zwei Anweisungen)
BEGIN TRANSACTION;
UPDATE airport SET airport_name = 'Zürich Airport' WHERE airport_code = 'ZRH';
COMMIT;

-- Fenster 2: Schrittweise ausführen
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM airport WHERE airport_code = 'ZRH';
SELECT * FROM airport WHERE airport_code = 'ZRH';
COMMIT;

-- 'Fehler' wieder einbauen für neuen Versuch
UPDATE airport SET airport_name = 'ZÃ¼rich Airport' WHERE airport_code = 'ZRH';

-- Das ganze nochmals, aber im Isolationslevel REPEATABLE READ

-- Fenster 1: Schrittweise ausführen (zuerst erste zwei Anweisungen)
BEGIN TRANSACTION;
UPDATE airport SET airport_name = 'Zürich Airport' WHERE airport_code = 'ZRH';
COMMIT;

-- Fenster 2: Schrittweise ausführen
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM airport WHERE airport_code = 'ZRH';
SELECT * FROM airport WHERE airport_code = 'ZRH';
COMMIT;

---------------------------------------------------------------------
-- Aufgabe 7: Deadlocks
---------------------------------------------------------------------
 
-- Inhalt kurz anschauen
SELECT * FROM airport WHERE airport_code = 'AGP';
SELECT * FROM passenger WHERE passenger_id = 8583106;

-- Fenster 1: Schrittweise ausführen 
BEGIN TRANSACTION;
UPDATE airport SET airport_name = 'Malaga Airport' WHERE airport_code = 'AGP';
UPDATE passenger SET first_name = 'DANY' WHERE passenger_id = 8583106;
COMMIT;

-- Fenster 2: Schrittweise ausführen 
BEGIN TRANSACTION;
UPDATE passenger SET first_name = 'DANY' WHERE passenger_id = 8583106;
UPDATE airport SET airport_name = 'Malaga Airport' WHERE airport_code = 'AGP';
COMMIT;

---------------------------------------------------------------------
-- Aufgabe 8: Misslungene Serialisierung
---------------------------------------------------------------------

-- Fenster 1: Schrittweise ausführen 
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM passenger WHERE passenger_id = 8583106;
UPDATE passenger SET first_name = 'DANY' WHERE passenger_id = 8583106;
COMMIT;

-- Fenster 2: Schrittweise ausführen 
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM passenger WHERE passenger_id = 8583106;
UPDATE passenger SET first_name = 'DANI' WHERE passenger_id = 8583106;
COMMIT;
