-- ==================================================================
-- L_Praktikum_13: Integritätssicherung / Datenbankprogrammierung
-- ==================================================================

SET search_path TO DB_Praktikum_13;

-- ------------------------------------------------------------------
-- Aufgabe 2: Daten prüfen
-- ------------------------------------------------------------------

SELECT
  PLZ, COUNT(PLZ) AS Vorkommen
FROM
  PLZSchweiz
GROUP BY
  PLZ
HAVING
  COUNT(*) > 1
ORDER BY
  PLZ;

SELECT * FROM PLZSchweiz WHERE PLZ = 1041;

SELECT
  Ort, COUNT(Ort) AS Vorkommen
FROM
  PLZSchweiz
GROUP BY
  Ort
HAVING
  COUNT(*) > 1
ORDER BY
  Ort;

SELECT
  MIN(PLZ) AS Kleinste, MAX(PLZ) AS Groesste, COUNT(DISTINCT PLZ) AS AnzahlPLZ
FROM
  PLZSchweiz;

-- ------------------------------------------------------------------
-- Aufgabe 3: Tabelle erstellen & testen
-- ------------------------------------------------------------------

DROP TABLE IF EXISTS Adressen;

CREATE TABLE Adressen(
  AdrNr	    SERIAL PRIMARY KEY,
  Nachname	VARCHAR(50) NOT NULL,
  Vorname	VARCHAR(50) NOT NULL,
  Strasse	VARCHAR(50) NOT NULL,
  LandCode  CHAR(2)     NOT NULL CONSTRAINT DF_LandCode DEFAULT 'CH',
  PLZ	    VARCHAR(10) NOT NULL CONSTRAINT CK_PLZ CHECK(LENGTH(PLZ) >= 4),
  Ort	    VARCHAR(50) NOT NULL,
  Land      VARCHAR(50) NOT NULL CONSTRAINT DF_Land DEFAULT 'Switzerland'
);


SELECT * FROM Adressen;

INSERT INTO Adressen (Nachname, Vorname, Strasse, PLZ, Ort)
VALUES('Meier','Peter','Am Bach','ABCD','Zürich');

-- ------------------------------------------------------------------
-- Aufgabe 4: PLZ testen mit Funktion
-- ------------------------------------------------------------------

CREATE OR REPLACE FUNCTION IsCHPLZ(PLZ varchar(10))
	RETURNS bit
AS $$
BEGIN
  -- Prüfen, ob vierstellig numerisch
  IF PLZ NOT SIMILAR TO '%[0-9][0-9][0-9][0-9]%' THEN
    RETURN 0;
  END IF;

  -- Prüfen, ob in der Referenztabelle vorhanden
  IF PLZ::integer IN (SELECT DISTINCT p.PLZ FROM PLZSchweiz p) THEN
	RETURN 1;
  END IF;

  RETURN 0;
END; $$
LANGUAGE 'plpgsql';

-- Testfälle

SELECT IsCHPLZ('ac235');
SELECT IsCHPLZ('12345');
SELECT IsCHPLZ('1234');
SELECT IsCHPLZ('1235');
SELECT IsCHPLZ('83bb');
SELECT IsCHPLZ('8000');

-- ------------------------------------------------------------------
-- Aufgabe 5: Trigger erstellen
-- ------------------------------------------------------------------

CREATE OR REPLACE FUNCTION IsAdresseOK() RETURNS TRIGGER AS $IsAdresseOK$
DECLARE
  RetCode integer;
BEGIN
  IF (NEW.LandCode <> 'CH') AND (NEW.LandCode <> 'LI') THEN
    RETURN NEW; -- keine Prüfung nötig;
  END IF;

  -- CH und LI: PLZ prüfen
  SELECT IsCHPLZ(NEW.PLZ) INTO RetCode;

  IF RetCode = 0 THEN
    RAISE EXCEPTION 'Postleitzahl mussen numerisch und vierstellig und in der Referenztabelle vorhanden sein!'; -- nur zu Anschauungszwecken
  END IF;

  RETURN NEW;
END; $IsAdresseOK$
LANGUAGE 'plpgsql';

CREATE TRIGGER IsAdresseOK BEFORE INSERT OR UPDATE ON Adressen
  FOR EACH ROW EXECUTE PROCEDURE IsAdresseOK();

-- Testfälle
SELECT * FROM Adressen;

UPDATE Adressen SET PLZ = 1234 WHERE AdrNr = 1;
UPDATE Adressen SET PLZ = 1236 WHERE AdrNr = 1;

INSERT INTO Adressen (Nachname, Vorname, Strasse, LandCode, PLZ, Ort)
VALUES('Muster','Hans','Im Schilf','CH','1234','Irgendwo');

INSERT INTO Adressen (Nachname, Vorname, Strasse, LandCode, PLZ, Ort)
VALUES('Muster','Hans','Im Schilf','CH','9999','Irgendwo');

